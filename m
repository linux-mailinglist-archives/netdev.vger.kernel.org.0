Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 384861CB35E
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 17:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728602AbgEHPiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 11:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728174AbgEHPgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 11:36:49 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 035BDC061A0C;
        Fri,  8 May 2020 08:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=MVpXPi4fO9ek2hxfJ7eaB5mhfWvQarx43ZgTOZ4t1BM=; b=UNM07rxTMrjSKj57obB1kc0GKN
        4c/P3xwFW5d9k3Hfi744eTkLYszdumNcpfrOjsxrJ9UyA5pDgJlACed00AREq1SZCfAHi0YTUfXeL
        1a3vaAcVbG4IQqGt9D66OEKVcFQkxqBxp4rUGWmpPQER44ale5ue+RbbzOgzgKvdrdhoJt3D2NNxV
        1eAPLhsMIzXbIHLL3++l6NlGgamQ555CXKlTkvYsF5jaAuaiGhVap01g1xYLqxcArTXcJZqmFMBoz
        IZqNqIah5HvQMt9E9lRkiTzhTJQ5P5+JS/j09j+PuFEw8yw+wQnDHAw0xudwrm7AWdgH4vpWmQFKP
        ZOHP/mFw==;
Received: from [2001:4bb8:180:9d3f:90d7:9df8:7cd:3504] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jX53Q-00049Y-EX; Fri, 08 May 2020 15:36:48 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-rdma@vger.kernel.org, kvm@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH 04/12] bpf: use __anon_inode_getfd
Date:   Fri,  8 May 2020 17:36:26 +0200
Message-Id: <20200508153634.249933-5-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508153634.249933-1-hch@lst.de>
References: <20200508153634.249933-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use __anon_inode_getfd instead of opencoding the logic using
get_unused_fd_flags + anon_inode_getfile.  Also switch the
bpf_link_new_file calling conventions to match __anon_inode_getfd.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/bpf.h  |  2 +-
 kernel/bpf/cgroup.c  |  6 +++---
 kernel/bpf/syscall.c | 31 +++++++++----------------------
 3 files changed, 13 insertions(+), 26 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index fd2b2322412d7..539649fe8b885 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1103,7 +1103,7 @@ void bpf_link_cleanup(struct bpf_link *link, struct file *link_file,
 void bpf_link_inc(struct bpf_link *link);
 void bpf_link_put(struct bpf_link *link);
 int bpf_link_new_fd(struct bpf_link *link);
-struct file *bpf_link_new_file(struct bpf_link *link, int *reserved_fd);
+int bpf_link_new_file(struct bpf_link *link, struct file **link_file);
 struct bpf_link *bpf_link_get_from_fd(u32 ufd);
 
 int bpf_obj_pin_user(u32 ufd, const char __user *pathname);
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index cb305e71e7deb..8605287adcd9e 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -836,10 +836,10 @@ int cgroup_bpf_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
 	link->cgroup = cgrp;
 	link->type = attr->link_create.attach_type;
 
-	link_file = bpf_link_new_file(&link->link, &link_fd);
-	if (IS_ERR(link_file)) {
+	link_fd = bpf_link_new_file(&link->link, &link_file);
+	if (link_fd < 0) {
 		kfree(link);
-		err = PTR_ERR(link_file);
+		err = link_fd;
 		goto out_put_cgroup;
 	}
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 64783da342020..cb2364e17423c 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2307,23 +2307,10 @@ int bpf_link_new_fd(struct bpf_link *link)
  * complicated and expensive operations and should be delayed until all the fd
  * reservation and anon_inode creation succeeds.
  */
-struct file *bpf_link_new_file(struct bpf_link *link, int *reserved_fd)
+int bpf_link_new_file(struct bpf_link *link, struct file **file)
 {
-	struct file *file;
-	int fd;
-
-	fd = get_unused_fd_flags(O_CLOEXEC);
-	if (fd < 0)
-		return ERR_PTR(fd);
-
-	file = anon_inode_getfile("bpf_link", &bpf_link_fops, link, O_CLOEXEC);
-	if (IS_ERR(file)) {
-		put_unused_fd(fd);
-		return file;
-	}
-
-	*reserved_fd = fd;
-	return file;
+	return __anon_inode_getfd("bpf_link", &bpf_link_fops, link, O_CLOEXEC,
+			file);
 }
 
 struct bpf_link *bpf_link_get_from_fd(u32 ufd)
@@ -2406,10 +2393,10 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog)
 	}
 	bpf_link_init(&link->link, &bpf_tracing_link_lops, prog);
 
-	link_file = bpf_link_new_file(&link->link, &link_fd);
-	if (IS_ERR(link_file)) {
+	link_fd = bpf_link_new_file(&link->link, &link_file);
+	if (link_fd < 0) {
 		kfree(link);
-		err = PTR_ERR(link_file);
+		err = link_fd;
 		goto out_put_prog;
 	}
 
@@ -2520,10 +2507,10 @@ static int bpf_raw_tracepoint_open(const union bpf_attr *attr)
 	bpf_link_init(&link->link, &bpf_raw_tp_lops, prog);
 	link->btp = btp;
 
-	link_file = bpf_link_new_file(&link->link, &link_fd);
-	if (IS_ERR(link_file)) {
+	link_fd = bpf_link_new_file(&link->link, &link_file);
+	if (link_fd < 0) {
 		kfree(link);
-		err = PTR_ERR(link_file);
+		err = link_fd;
 		goto out_put_btp;
 	}
 
-- 
2.26.2


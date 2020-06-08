Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D99761F1DC9
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 18:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387464AbgFHQv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 12:51:28 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:31182 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387445AbgFHQv1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 12:51:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591635085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S2CPu4PWJvND4oh80THK787G1YcXxT1mBXHY/NYs6mU=;
        b=FpwzkvOBPuO07DJIJ8Mzp4pZLA9QYPHfHV4E54knEjdmc5WfE330lDboZ4LNJgBqj57/7q
        bMOwbWUpliIOuvesiwwBwZdb883eVFAJZn6IEn4OnpSef5wsMkOCs0LVVeloBNuVPmskng
        FTlX0jAPQRSBrHjIXna7C4ijoCZchR4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-118-9uWIv0teN5a5Dns4-HovgA-1; Mon, 08 Jun 2020 12:51:23 -0400
X-MC-Unique: 9uWIv0teN5a5Dns4-HovgA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D44FD7BAE;
        Mon,  8 Jun 2020 16:51:21 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9C80B8927C;
        Mon,  8 Jun 2020 16:51:18 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 93526300003EB;
        Mon,  8 Jun 2020 18:51:17 +0200 (CEST)
Subject: [PATCH bpf 1/3] bpf: syscall to start at file-descriptor 1
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     David Ahern <dsahern@gmail.com>, bpf@vger.kernel.org,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Date:   Mon, 08 Jun 2020 18:51:17 +0200
Message-ID: <159163507753.1967373.62249862728421448.stgit@firesoul>
In-Reply-To: <159163498340.1967373.5048584263152085317.stgit@firesoul>
References: <159163498340.1967373.5048584263152085317.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch change BPF syscall to avoid returning file descriptor value zero.

As mentioned in cover letter, it is very impractical when extending kABI
that the file-descriptor value 'zero' is valid, as this requires new fields
must be initialised as minus-1. First step is to change the kernel such that
BPF-syscall simply doesn't return value zero as a FD number.

This patch achieves this by similar code to anon_inode_getfd(), with the
exception of getting unused FD starting from 1. The kernel already supports
starting from a specific FD value, as this is used by f_dupfd(). It seems
simpler to replicate part of anon_inode_getfd() code and use this start from
offset feature, instead of using f_dupfd() handling afterwards.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 fs/file.c            |    2 +-
 include/linux/file.h |    1 +
 kernel/bpf/syscall.c |   38 ++++++++++++++++++++++++++++++++------
 3 files changed, 34 insertions(+), 7 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index abb8b7081d7a..122185cb7707 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -535,7 +535,7 @@ int __alloc_fd(struct files_struct *files,
 	return error;
 }
 
-static int alloc_fd(unsigned start, unsigned flags)
+int alloc_fd(unsigned start, unsigned flags)
 {
 	return __alloc_fd(current->files, start, rlimit(RLIMIT_NOFILE), flags);
 }
diff --git a/include/linux/file.h b/include/linux/file.h
index 122f80084a3e..927fb6c2582d 100644
--- a/include/linux/file.h
+++ b/include/linux/file.h
@@ -85,6 +85,7 @@ extern int f_dupfd(unsigned int from, struct file *file, unsigned flags);
 extern int replace_fd(unsigned fd, struct file *file, unsigned flags);
 extern void set_close_on_exec(unsigned int fd, int flag);
 extern bool get_close_on_exec(unsigned int fd);
+extern int alloc_fd(unsigned start, unsigned flags);
 extern int __get_unused_fd_flags(unsigned flags, unsigned long nofile);
 extern int get_unused_fd_flags(unsigned flags);
 extern void put_unused_fd(unsigned int fd);
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 4d530b1d5683..6eba236aacd1 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -688,6 +688,32 @@ const struct file_operations bpf_map_fops = {
 	.poll		= bpf_map_poll,
 };
 
+/* Code is similar to anon_inode_getfd(), except starts at FD 1 */
+int bpf_anon_inode_getfd(const char *name, const struct file_operations *fops,
+			 void *priv, int flags)
+{
+	int error, fd;
+	struct file *file;
+
+	error = alloc_fd(1, flags);
+	if (error < 0)
+		return error;
+	fd = error;
+
+	file = anon_inode_getfile(name, fops, priv, flags);
+	if (IS_ERR(file)) {
+		error = PTR_ERR(file);
+		goto err_put_unused_fd;
+	}
+	fd_install(fd, file);
+
+	return fd;
+
+err_put_unused_fd:
+	put_unused_fd(fd);
+	return error;
+}
+
 int bpf_map_new_fd(struct bpf_map *map, int flags)
 {
 	int ret;
@@ -696,8 +722,8 @@ int bpf_map_new_fd(struct bpf_map *map, int flags)
 	if (ret < 0)
 		return ret;
 
-	return anon_inode_getfd("bpf-map", &bpf_map_fops, map,
-				flags | O_CLOEXEC);
+	return bpf_anon_inode_getfd("bpf-map", &bpf_map_fops, map,
+				    flags | O_CLOEXEC);
 }
 
 int bpf_get_file_flag(int flags)
@@ -1840,8 +1866,8 @@ int bpf_prog_new_fd(struct bpf_prog *prog)
 	if (ret < 0)
 		return ret;
 
-	return anon_inode_getfd("bpf-prog", &bpf_prog_fops, prog,
-				O_RDWR | O_CLOEXEC);
+	return bpf_anon_inode_getfd("bpf-prog", &bpf_prog_fops, prog,
+				    O_RDWR | O_CLOEXEC);
 }
 
 static struct bpf_prog *____bpf_prog_get(struct fd f)
@@ -2471,7 +2497,7 @@ int bpf_link_settle(struct bpf_link_primer *primer)
 
 int bpf_link_new_fd(struct bpf_link *link)
 {
-	return anon_inode_getfd("bpf-link", &bpf_link_fops, link, O_CLOEXEC);
+	return bpf_anon_inode_getfd("bpf-link", &bpf_link_fops, link, O_CLOEXEC);
 }
 
 struct bpf_link *bpf_link_get_from_fd(u32 ufd)
@@ -4024,7 +4050,7 @@ static int bpf_enable_runtime_stats(void)
 		return -EBUSY;
 	}
 
-	fd = anon_inode_getfd("bpf-stats", &bpf_stats_fops, NULL, O_CLOEXEC);
+	fd = bpf_anon_inode_getfd("bpf-stats", &bpf_stats_fops, NULL, O_CLOEXEC);
 	if (fd >= 0)
 		static_key_slow_inc(&bpf_stats_enabled_key.key);
 



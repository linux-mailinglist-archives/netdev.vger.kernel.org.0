Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABE141CB373
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 17:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbgEHPgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 11:36:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbgEHPgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 11:36:40 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE5C2C061A0C;
        Fri,  8 May 2020 08:36:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=6EYCyTrFxa9+uQHjnJOrj9adSL4387IIusv8CGn+u5c=; b=srCBSzZwpa/R8vT9FGb8MSiNzT
        Qqn1uYSRLBeu5tyD/4XSsT0mYDn4lLbRdOf4moLFs/SGTwShV9DVJofzbIoBQmBoBJiCsWqkwHDqS
        6ifMQM06Uy05ogqQUznA5cW2YOrFFIeJ5LsIJcSd7jpMi1tvx7P3FtVwCveS1aikMR4WbSiyK0LT7
        /969LGJr0wCQLH7KzkFKs+MMOy8JW/daxQoggK4NgoMsrtAgwQEv7YMXtPvYU5W4jXBe7XEl/OQ1p
        uHAT3dFwh9mYW4W9MObM6CGHUmn/fWgH3Ylz2U2jryjURgP+RE+6QKq4EsiRP1gW7DDlgIA4OYoga
        wlnUSMRw==;
Received: from [2001:4bb8:180:9d3f:90d7:9df8:7cd:3504] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jX53I-00047B-4u; Fri, 08 May 2020 15:36:40 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-rdma@vger.kernel.org, kvm@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH 01/12] fd: add a new __anon_inode_getfd helper
Date:   Fri,  8 May 2020 17:36:23 +0200
Message-Id: <20200508153634.249933-2-hch@lst.de>
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

Add a helper that is equivalent to anon_inode_getfd minus the final
fd_install.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/anon_inodes.c            | 41 ++++++++++++++++++++++---------------
 include/linux/anon_inodes.h |  2 ++
 2 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
index 89714308c25b8..1b2acd2bbaa32 100644
--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -106,6 +106,26 @@ struct file *anon_inode_getfile(const char *name,
 }
 EXPORT_SYMBOL_GPL(anon_inode_getfile);
 
+int __anon_inode_getfd(const char *name, const struct file_operations *fops,
+		     void *priv, int flags, struct file **file)
+{
+	int fd;
+
+	fd = get_unused_fd_flags(flags);
+	if (fd < 0)
+		return fd;
+
+	*file = anon_inode_getfile(name, fops, priv, flags);
+	if (IS_ERR(*file))
+		goto err_put_unused_fd;
+	return fd;
+
+err_put_unused_fd:
+	put_unused_fd(fd);
+	return PTR_ERR(*file);
+}
+EXPORT_SYMBOL_GPL(__anon_inode_getfd);
+
 /**
  * anon_inode_getfd - creates a new file instance by hooking it up to an
  *                    anonymous inode, and a dentry that describe the "class"
@@ -125,26 +145,13 @@ EXPORT_SYMBOL_GPL(anon_inode_getfile);
 int anon_inode_getfd(const char *name, const struct file_operations *fops,
 		     void *priv, int flags)
 {
-	int error, fd;
 	struct file *file;
+	int fd;
 
-	error = get_unused_fd_flags(flags);
-	if (error < 0)
-		return error;
-	fd = error;
-
-	file = anon_inode_getfile(name, fops, priv, flags);
-	if (IS_ERR(file)) {
-		error = PTR_ERR(file);
-		goto err_put_unused_fd;
-	}
-	fd_install(fd, file);
-
+	fd = __anon_inode_getfd(name, fops, priv, flags, &file);
+	if (fd >= 0)
+		fd_install(fd, file);
 	return fd;
-
-err_put_unused_fd:
-	put_unused_fd(fd);
-	return error;
 }
 EXPORT_SYMBOL_GPL(anon_inode_getfd);
 
diff --git a/include/linux/anon_inodes.h b/include/linux/anon_inodes.h
index d0d7d96261adf..338449d06b617 100644
--- a/include/linux/anon_inodes.h
+++ b/include/linux/anon_inodes.h
@@ -16,6 +16,8 @@ struct file *anon_inode_getfile(const char *name,
 				void *priv, int flags);
 int anon_inode_getfd(const char *name, const struct file_operations *fops,
 		     void *priv, int flags);
+int __anon_inode_getfd(const char *name, const struct file_operations *fops,
+		     void *priv, int flags, struct file **file);
 
 #endif /* _LINUX_ANON_INODES_H */
 
-- 
2.26.2


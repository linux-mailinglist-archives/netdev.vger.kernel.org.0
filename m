Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7DF61CB332
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 17:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728355AbgEHPhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 11:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728418AbgEHPhL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 11:37:11 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F247EC061A0C;
        Fri,  8 May 2020 08:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=uQupytwSEXnv3/F3EONV14yFM9iDWY0BYhUPftguMlU=; b=ECjye1lFh/oDKkHSp8s8r3/PBL
        bY/42wC5a85E1iHD+psjQ/gkXg7hcCE7r0N2ufr4ZnmtVS2rYT80SgF8xdIozTYFqxl0tf1Z49wkr
        brImDOTrRr2yXeQqkxa8oM7wZ8d1A07kuZ+YelyRE3/Ejv0WR63qqwEi7NkSPvm6JCdwbnIFIuFhh
        ca06xctQt3/rLg9MSgExt6X6hISxql6kbhSk4akzhzTPYah7nLCyDQJuj3qQCGYA/oqYFM9Kr5h5f
        gIMF4UxTD82Q2/oQLlx6fL74cfXHXgNPMz/nvaxsMY6cMkjGOAWo/Ha8ThQx5El+S/JcOa/eOm9Qh
        ch4YtVZw==;
Received: from [2001:4bb8:180:9d3f:90d7:9df8:7cd:3504] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jX53m-0004ST-Ff; Fri, 08 May 2020 15:37:10 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-rdma@vger.kernel.org, kvm@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH 12/12] vtpm_proxy: use __anon_inode_getfd
Date:   Fri,  8 May 2020 17:36:34 +0200
Message-Id: <20200508153634.249933-13-hch@lst.de>
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
get_unused_fd_flags + anon_inode_getfile.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/char/tpm/tpm_vtpm_proxy.c | 23 +++++------------------
 1 file changed, 5 insertions(+), 18 deletions(-)

diff --git a/drivers/char/tpm/tpm_vtpm_proxy.c b/drivers/char/tpm/tpm_vtpm_proxy.c
index 91c772e38bb54..4c0a31209ae5a 100644
--- a/drivers/char/tpm/tpm_vtpm_proxy.c
+++ b/drivers/char/tpm/tpm_vtpm_proxy.c
@@ -534,7 +534,7 @@ static struct file *vtpm_proxy_create_device(
 				 struct vtpm_proxy_new_dev *vtpm_new_dev)
 {
 	struct proxy_dev *proxy_dev;
-	int rc, fd;
+	int fd;
 	struct file *file;
 
 	if (vtpm_new_dev->flags & ~VTPM_PROXY_FLAGS_ALL)
@@ -546,19 +546,10 @@ static struct file *vtpm_proxy_create_device(
 
 	proxy_dev->flags = vtpm_new_dev->flags;
 
-	/* setup an anonymous file for the server-side */
-	fd = get_unused_fd_flags(O_RDWR);
-	if (fd < 0) {
-		rc = fd;
+	fd = __anon_inode_getfd("[vtpms]", &vtpm_proxy_fops, proxy_dev, O_RDWR,
+			&file);
+	if (fd < 0)
 		goto err_delete_proxy_dev;
-	}
-
-	file = anon_inode_getfile("[vtpms]", &vtpm_proxy_fops, proxy_dev,
-				  O_RDWR);
-	if (IS_ERR(file)) {
-		rc = PTR_ERR(file);
-		goto err_put_unused_fd;
-	}
 
 	/* from now on we can unwind with put_unused_fd() + fput() */
 	/* simulate an open() on the server side */
@@ -576,13 +567,9 @@ static struct file *vtpm_proxy_create_device(
 
 	return file;
 
-err_put_unused_fd:
-	put_unused_fd(fd);
-
 err_delete_proxy_dev:
 	vtpm_proxy_delete_proxy_dev(proxy_dev);
-
-	return ERR_PTR(rc);
+	return ERR_PTR(fd);
 }
 
 /*
-- 
2.26.2


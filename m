Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67A111CB312
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 17:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728273AbgEHPgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 11:36:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726736AbgEHPgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 11:36:52 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9235C061A0C;
        Fri,  8 May 2020 08:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=84Q6+XvESATHkPDs3NezzlHWwc4KFGjN8N6drGU+t58=; b=AWoCrBmcbiNeSqG41R8zejRyGu
        q9id5MMqFDnvfrZaKfLud0DzqWzP81fdQM2386RtOX+d1YUMf/xfAOiVUr699SfUMz7BTaVNStXYL
        URpd5PGUP47QmFtYhFKrjV9Chp+yOi6JLX3053q5fnCJsoCaJC0JS55pAMk20L88eIz9rHxZgVuGV
        yjg4TCdQyTS/tDFunEk4vcDsvmGZCUFGy9Yo0DcC3s6+nRk9Or5FqCiCQQmg/86acEJlB6AwC/r2W
        ha+mGlYY+7L0ukMxEOgVwW3F6ckPe0jf7choEDgXl4CQfuHU79gbeHfvDNAxNZBTXBT7Mjx37VB6E
        BcK7J1bg==;
Received: from [2001:4bb8:180:9d3f:90d7:9df8:7cd:3504] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jX53T-0004BL-6n; Fri, 08 May 2020 15:36:51 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-rdma@vger.kernel.org, kvm@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH 05/12] io_uring: use __anon_inode_getfd
Date:   Fri,  8 May 2020 17:36:27 +0200
Message-Id: <20200508153634.249933-6-hch@lst.de>
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
 fs/io_uring.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5190bfb6a6657..4104f8a45d11e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7709,18 +7709,11 @@ static int io_uring_get_fd(struct io_ring_ctx *ctx)
 		return ret;
 #endif
 
-	ret = get_unused_fd_flags(O_RDWR | O_CLOEXEC);
+	ret = __anon_inode_getfd("[io_uring]", &io_uring_fops, ctx,
+			O_RDWR | O_CLOEXEC, &file);
 	if (ret < 0)
 		goto err;
 
-	file = anon_inode_getfile("[io_uring]", &io_uring_fops, ctx,
-					O_RDWR | O_CLOEXEC);
-	if (IS_ERR(file)) {
-		put_unused_fd(ret);
-		ret = PTR_ERR(file);
-		goto err;
-	}
-
 #if defined(CONFIG_UNIX)
 	ctx->ring_sock->file = file;
 #endif
-- 
2.26.2


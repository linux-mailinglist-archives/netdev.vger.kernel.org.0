Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C702E1CB31D
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 17:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbgEHPhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 11:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728355AbgEHPhD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 11:37:03 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F37EFC061A0C;
        Fri,  8 May 2020 08:37:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Fa8g/lJWKeJOUWpYZKXVATFBsUbfwqV0WZlzPMoN0uA=; b=Qa2htAHPQfxVvAUTYEeMqFgrdh
        GOwnTg4ulWQqLx6PIvQwXwOQ38d99ysssfAJK0A0785ViFbs5O4fMdbZzuq2dDKpS8pELW7HGvkBM
        p1nwmkCOWeGuhoWNIarZEKQnoIq2R5Ex6v5mA07Q/8cRXM1obeyxcP5oPlOnMLj/LE/DGq17tKzG5
        C72uis6BvgLT+nnvwsubs4tEk9aZUMn1y7yUC4eLB2h/N8MLIsTdMkKA9um8pxHIhYStpxq4EUKhW
        JF8NNAytHWoxkh5ov5BS8g1yn0WriNp19+/h+gp0YDDSf/AdqPHNP83wqLC7LkpEXhpV8LqMLPmdF
        xf6VlBZg==;
Received: from [2001:4bb8:180:9d3f:90d7:9df8:7cd:3504] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jX53e-0004QB-FT; Fri, 08 May 2020 15:37:02 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-rdma@vger.kernel.org, kvm@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH 09/12] rdma: use __anon_inode_getfd
Date:   Fri,  8 May 2020 17:36:31 +0200
Message-Id: <20200508153634.249933-10-hch@lst.de>
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
 drivers/infiniband/core/rdma_core.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/core/rdma_core.c b/drivers/infiniband/core/rdma_core.c
index 5128cb16bb485..541e5e06347f6 100644
--- a/drivers/infiniband/core/rdma_core.c
+++ b/drivers/infiniband/core/rdma_core.c
@@ -462,30 +462,21 @@ alloc_begin_fd_uobject(const struct uverbs_api_object *obj,
 	if (WARN_ON(fd_type->fops->release != &uverbs_uobject_fd_release))
 		return ERR_PTR(-EINVAL);
 
-	new_fd = get_unused_fd_flags(O_CLOEXEC);
-	if (new_fd < 0)
-		return ERR_PTR(new_fd);
-
 	uobj = alloc_uobj(attrs, obj);
 	if (IS_ERR(uobj))
-		goto err_fd;
+		return uobj;
 
 	/* Note that uverbs_uobject_fd_release() is called during abort */
-	filp = anon_inode_getfile(fd_type->name, fd_type->fops, NULL,
-				  fd_type->flags);
-	if (IS_ERR(filp)) {
-		uobj = ERR_CAST(filp);
+	new_fd = __anon_inode_getfd(fd_type->name, fd_type->fops, NULL,
+			fd_type->flags | O_CLOEXEC, &filp);
+	if (new_fd < 0)
 		goto err_uobj;
-	}
 	uobj->object = filp;
-
 	uobj->id = new_fd;
 	return uobj;
 
 err_uobj:
 	uverbs_uobject_put(uobj);
-err_fd:
-	put_unused_fd(new_fd);
 	return uobj;
 }
 
-- 
2.26.2


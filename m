Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 958A210E2D
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 22:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726249AbfEAUmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 16:42:01 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:58408 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbfEAUmA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 16:42:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=xjFUiKHVKRYeZR2wUaD2tSOO8e6Ya1jD8WtfOGkq95Y=; b=Wj+RkbodXdXD8te9RPXfkToEu
        SifdbqvPQeFbdZ6nsnUxyXxNblHAFtIx/QJS1Z+UfSwLVE5oK5V1GRj4WbCG3F+UfkOd3iV95MD2B
        2uiSigDEnf8eouEFLFTXfECiRstIdz81Zzy390omGT0BRP5V8pyylSVSR+gzsto2fVy2CyNTXrv8e
        2RORYRDpoqjd/ImdNawKryn1ydZ3Xr8DsBJefdaFA/zGs8ZwdoEEPyzgxSkSFB2bP8W1uTG0P0Bbc
        udFmI0pB4+NTTnB42XM9jZyDA32Yj5relRWWlae/hqBYqhVccyOgITfDQppTVADE4XobuoEEsOH14
        2iMz2+67g==;
Received: from adsl-173-228-226-134.prtc.net ([173.228.226.134] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hLw2P-0000N1-Nj; Wed, 01 May 2019 20:41:59 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     ceph-devel@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ceph: remove ceph_get_direct_page_vector
Date:   Wed,  1 May 2019 16:40:32 -0400
Message-Id: <20190501204032.26380-1-hch@lst.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This function is entirely unused.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/ceph/libceph.h |  4 ----
 net/ceph/pagevec.c           | 33 ---------------------------------
 2 files changed, 37 deletions(-)

diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
index 337d5049ff93..a3cddf5f0e60 100644
--- a/include/linux/ceph/libceph.h
+++ b/include/linux/ceph/libceph.h
@@ -299,10 +299,6 @@ int ceph_wait_for_latest_osdmap(struct ceph_client *client,
 
 /* pagevec.c */
 extern void ceph_release_page_vector(struct page **pages, int num_pages);
-
-extern struct page **ceph_get_direct_page_vector(const void __user *data,
-						 int num_pages,
-						 bool write_page);
 extern void ceph_put_page_vector(struct page **pages, int num_pages,
 				 bool dirty);
 extern struct page **ceph_alloc_page_vector(int num_pages, gfp_t flags);
diff --git a/net/ceph/pagevec.c b/net/ceph/pagevec.c
index d3736f5bffec..64305e7056a1 100644
--- a/net/ceph/pagevec.c
+++ b/net/ceph/pagevec.c
@@ -10,39 +10,6 @@
 
 #include <linux/ceph/libceph.h>
 
-/*
- * build a vector of user pages
- */
-struct page **ceph_get_direct_page_vector(const void __user *data,
-					  int num_pages, bool write_page)
-{
-	struct page **pages;
-	int got = 0;
-	int rc = 0;
-
-	pages = kmalloc_array(num_pages, sizeof(*pages), GFP_NOFS);
-	if (!pages)
-		return ERR_PTR(-ENOMEM);
-
-	while (got < num_pages) {
-		rc = get_user_pages_fast(
-		    (unsigned long)data + ((unsigned long)got * PAGE_SIZE),
-		    num_pages - got, write_page, pages + got);
-		if (rc < 0)
-			break;
-		BUG_ON(rc == 0);
-		got += rc;
-	}
-	if (rc < 0)
-		goto fail;
-	return pages;
-
-fail:
-	ceph_put_page_vector(pages, got, false);
-	return ERR_PTR(rc);
-}
-EXPORT_SYMBOL(ceph_get_direct_page_vector);
-
 void ceph_put_page_vector(struct page **pages, int num_pages, bool dirty)
 {
 	int i;
-- 
2.20.1


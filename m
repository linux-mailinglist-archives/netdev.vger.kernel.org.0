Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54C0E680879
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 10:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236201AbjA3JXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 04:23:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230335AbjA3JXc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 04:23:32 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2425A1027B;
        Mon, 30 Jan 2023 01:23:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=w4kKntDuy29BQaIkx4v+gO5Mr7Op4d5AzstW4NmjqgQ=; b=dhP5pRXPs7QKG7qsUwhXqREoym
        zFzrmsc54uPZ3WPKRuV0WfgPkfnihth42MiqynU5Q/EDc9fWWebRrTHXAwUzGN/QJoApdfPiDDX0N
        /HmkaUaiYxfZXLR3z9hdV2llYBIbYlCe2dMJ6F0EqHVStN3Uz7UWDdL6oJBZcAAt0p+6fB6iGbjPD
        Nd/Ok11pRhrv+rkkmvwJZn5tR6ROXiqwJ2nZx3e7mQ0MNb0CMx12gTe0I5RWQiaLYIPF7aZ5ee0FT
        Y0XEhRZP9VSnQWzR1IGwBoRJV/D+7pYsUL1N+aAD7VKEQrSA2/9TIqep6pIrHdjX4TAXBBgOIMZ0Y
        QNuMFv5A==;
Received: from [2001:4bb8:19a:272a:732e:e417:47d7:2f4a] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pMQMV-002nyZ-Kh; Mon, 30 Jan 2023 09:22:04 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Minchan Kim <minchan@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Xiubo Li <xiubli@redhat.com>, Steve French <sfrench@samba.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Mike Marshall <hubcap@omnibond.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        linux-block@vger.kernel.org, ceph-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        devel@lists.orangefs.org, io-uring@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 01/23] block: factor out a bvec_set_page helper
Date:   Mon, 30 Jan 2023 10:21:35 +0100
Message-Id: <20230130092157.1759539-2-hch@lst.de>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230130092157.1759539-1-hch@lst.de>
References: <20230130092157.1759539-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,T_SPF_TEMPERROR autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a helper to initialize a bvec based of a page pointer.  This will help
removing various open code bvec initializations.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio-integrity.c |  7 +------
 block/bio.c           | 12 ++----------
 include/linux/bvec.h  | 15 +++++++++++++++
 3 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 3f5685c00e360b..a3776064c52a16 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -124,23 +124,18 @@ int bio_integrity_add_page(struct bio *bio, struct page *page,
 			   unsigned int len, unsigned int offset)
 {
 	struct bio_integrity_payload *bip = bio_integrity(bio);
-	struct bio_vec *iv;
 
 	if (bip->bip_vcnt >= bip->bip_max_vcnt) {
 		printk(KERN_ERR "%s: bip_vec full\n", __func__);
 		return 0;
 	}
 
-	iv = bip->bip_vec + bip->bip_vcnt;
-
 	if (bip->bip_vcnt &&
 	    bvec_gap_to_prev(&bdev_get_queue(bio->bi_bdev)->limits,
 			     &bip->bip_vec[bip->bip_vcnt - 1], offset))
 		return 0;
 
-	iv->bv_page = page;
-	iv->bv_len = len;
-	iv->bv_offset = offset;
+	bvec_set_page(&bip->bip_vec[bip->bip_vcnt], page, len, offset);
 	bip->bip_vcnt++;
 
 	return len;
diff --git a/block/bio.c b/block/bio.c
index d7fbc7adfc50aa..71e411a0c12950 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1029,10 +1029,7 @@ int bio_add_hw_page(struct request_queue *q, struct bio *bio,
 	if (bio->bi_vcnt >= queue_max_segments(q))
 		return 0;
 
-	bvec = &bio->bi_io_vec[bio->bi_vcnt];
-	bvec->bv_page = page;
-	bvec->bv_len = len;
-	bvec->bv_offset = offset;
+	bvec_set_page(&bio->bi_io_vec[bio->bi_vcnt], page, len, offset);
 	bio->bi_vcnt++;
 	bio->bi_iter.bi_size += len;
 	return len;
@@ -1108,15 +1105,10 @@ EXPORT_SYMBOL_GPL(bio_add_zone_append_page);
 void __bio_add_page(struct bio *bio, struct page *page,
 		unsigned int len, unsigned int off)
 {
-	struct bio_vec *bv = &bio->bi_io_vec[bio->bi_vcnt];
-
 	WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED));
 	WARN_ON_ONCE(bio_full(bio, len));
 
-	bv->bv_page = page;
-	bv->bv_offset = off;
-	bv->bv_len = len;
-
+	bvec_set_page(&bio->bi_io_vec[bio->bi_vcnt], page, len, off);
 	bio->bi_iter.bi_size += len;
 	bio->bi_vcnt++;
 }
diff --git a/include/linux/bvec.h b/include/linux/bvec.h
index 35c25dff651a5e..9e3dac51eb26b6 100644
--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -35,6 +35,21 @@ struct bio_vec {
 	unsigned int	bv_offset;
 };
 
+/**
+ * bvec_set_page - initialize a bvec based off a struct page
+ * @bv:		bvec to initialize
+ * @page:	page the bvec should point to
+ * @len:	length of the bvec
+ * @offset:	offset into the page
+ */
+static inline void bvec_set_page(struct bio_vec *bv, struct page *page,
+		unsigned int len, unsigned int offset)
+{
+	bv->bv_page = page;
+	bv->bv_len = len;
+	bv->bv_offset = offset;
+}
+
 struct bvec_iter {
 	sector_t		bi_sector;	/* device address in 512 byte
 						   sectors */
-- 
2.39.0


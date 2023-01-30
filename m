Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D39136808EB
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 10:24:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236439AbjA3JYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 04:24:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236295AbjA3JXy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 04:23:54 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0606A2E0EA;
        Mon, 30 Jan 2023 01:23:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=3qeMDW+n608lQ7XRYvaqAkQtBBNz7xL+OjR215zkIbk=; b=UO1e7nwChScdGRWnt+ckYdCTpz
        cffGVwmOAr9WIi1CMtOSiggD0UKfJpw5o3aJR+6RY6f+COa5q8cd3szdKLRSmmBk/8o983U1Lg0wc
        ItPZU29NZPb3hGmbv+C9saZ2NV8isV+EyAxFRsl5oXGS+ls/Ho2UjhKpsysa46PfwsMOU8Gj7CgYM
        g6aoeD80FmRnqZoMeGySNr8FML9baX8bb5LYGaXTnEgnd2jL+LSJi2XTvT5eG07ufkWNH7IgdO+Im
        JptBCekoIOossTAp+JWcidjNg977cn+klaWqiqh63OAS82nhx4jRhacaWv23EStcOVhccFrZOwyrk
        MX6JjZ0A==;
Received: from [2001:4bb8:19a:272a:732e:e417:47d7:2f4a] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pMQN1-002oA8-Cv; Mon, 30 Jan 2023 09:22:35 +0000
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
Subject: [PATCH 10/23] zram: use bvec_set_page to initialize bvecs
Date:   Mon, 30 Jan 2023 10:21:44 +0100
Message-Id: <20230130092157.1759539-11-hch@lst.de>
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

Use the bvec_set_page helper to initialize bvecs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/zram/zram_drv.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index e290d6d970474e..bd8ae4822dc3ef 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -703,9 +703,7 @@ static ssize_t writeback_store(struct device *dev,
 	for (; nr_pages != 0; index++, nr_pages--) {
 		struct bio_vec bvec;
 
-		bvec.bv_page = page;
-		bvec.bv_len = PAGE_SIZE;
-		bvec.bv_offset = 0;
+		bvec_set_page(&bvec, page, PAGE_SIZE, 0);
 
 		spin_lock(&zram->wb_limit_lock);
 		if (zram->wb_limit_enable && !zram->bd_wb_limit) {
@@ -1380,12 +1378,9 @@ static void zram_free_page(struct zram *zram, size_t index)
 static int zram_bvec_read_from_bdev(struct zram *zram, struct page *page,
 				    u32 index, struct bio *bio, bool partial_io)
 {
-	struct bio_vec bvec = {
-		.bv_page = page,
-		.bv_len = PAGE_SIZE,
-		.bv_offset = 0,
-	};
+	struct bio_vec bvec;
 
+	bvec_set_page(&bvec, page, PAGE_SIZE, 0);
 	return read_from_bdev(zram, &bvec, zram_get_element(zram, index), bio,
 			      partial_io);
 }
@@ -1652,9 +1647,7 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec,
 		memcpy_from_bvec(dst + offset, bvec);
 		kunmap_atomic(dst);
 
-		vec.bv_page = page;
-		vec.bv_len = PAGE_SIZE;
-		vec.bv_offset = 0;
+		bvec_set_page(&vec, page, PAGE_SIZE, 0);
 	}
 
 	ret = __zram_bvec_write(zram, &vec, index, bio);
-- 
2.39.0


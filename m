Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6EFD689CDF
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 16:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233934AbjBCPIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 10:08:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233915AbjBCPHx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 10:07:53 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0D738D62A;
        Fri,  3 Feb 2023 07:07:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=2ivuZdJU66fGeGNrDCSX2XtHVJq8+h1pLMvYDbA6wQ8=; b=QSfgGBAh+EXZxzz/Xx6bibyovx
        8Nrgb07oWFXF7SI+3wqJ/enmvP8hFHc6hUi3sA6GWv5A6dP7fcYPg732hEG/Jv2/jgoMcNgX6QddE
        Klux6y3fIgLzUgx2tQwUDLRbjwR42AzjGvRy3d+zXy8gseAM9WJfDA8waCftfZvGrqDwKbb421JO+
        A7KmM+t82WMvPJd60uQmgjS17we9cGNrkQfjYtCxBhWbUJkld5d206L4xTBajgBh6O8m/iXqiwdQ5
        Cvd+cDQIEMDIlKCNI2qXlOITbs0hvvqOAEaly0PMreLcEnepGH9pQ2ba/Ud+fBJ4c0tY614+rY/Gv
        8MQKv9iw==;
Received: from [2001:4bb8:19a:272a:910:bb67:7287:f956] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pNxef-002ar9-Df; Fri, 03 Feb 2023 15:07:10 +0000
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
        linux-mm@kvack.org, Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 10/23] zram: use bvec_set_page to initialize bvecs
Date:   Fri,  3 Feb 2023 16:06:21 +0100
Message-Id: <20230203150634.3199647-11-hch@lst.de>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230203150634.3199647-1-hch@lst.de>
References: <20230203150634.3199647-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the bvec_set_page helper to initialize bvecs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
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


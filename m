Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3C3D68089C
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 10:23:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236269AbjA3JXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 04:23:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235635AbjA3JXi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 04:23:38 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 316A72B09E;
        Mon, 30 Jan 2023 01:23:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=p+yCA75hP3xTA4z0JqY98N90poOlsvGyo37k4Ap2woM=; b=i9AYlKAOZ43/SsWyYnAWPiWAuH
        wOnzstLTu84haohS93R+b3+/PFUtyvvWWjhOliCemb0tZtB/BvukLBGtdd3Qfn4AztHpMr5gPDiv9
        pykYVq16zioFYfJbJUqVapz/0j7Z9lIwlzAc3goAfS8/li6bXevI3m2oMuDgPE3R0eRL87akyah+L
        YP8S0UqhRwqk0u2hAa7aNsgUMmQdiU8H7GdpecxVRrtK2g0PJyMvxAcj0GHEEGiFPHkZlYN3Xcgrb
        Zg+hSn9E/U6Bt1mWTQkkWWRFPXtWhjWXN8hIQicH7S0OvZO+ZxtpZxRzB/wDZ4j0GKY2wY9iOJUXC
        VOKko6ag==;
Received: from [2001:4bb8:19a:272a:732e:e417:47d7:2f4a] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pMQMj-002o2F-W8; Mon, 30 Jan 2023 09:22:18 +0000
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
Subject: [PATCH 04/23] sd: factor out a sd_set_special_bvec helper
Date:   Mon, 30 Jan 2023 10:21:38 +0100
Message-Id: <20230130092157.1759539-5-hch@lst.de>
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

Add a helper for setting up the special_bvec instead of open coding it
in three place, and use the new bvec_set_page helper to initialize
special_vec.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c | 36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 47dafe6b8a66d1..277960decc104b 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -831,6 +831,19 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
 	blk_queue_max_discard_sectors(q, max_blocks * (logical_block_size >> 9));
 }
 
+static void *sd_set_special_bvec(struct request *rq, unsigned int data_len)
+{
+	struct page *page;
+
+	page = mempool_alloc(sd_page_pool, GFP_ATOMIC);
+	if (!page)
+		return NULL;
+	clear_highpage(page);
+	bvec_set_page(&rq->special_vec, page, data_len, 0);
+	rq->rq_flags |= RQF_SPECIAL_PAYLOAD;
+	return bvec_virt(&rq->special_vec);
+}
+
 static blk_status_t sd_setup_unmap_cmnd(struct scsi_cmnd *cmd)
 {
 	struct scsi_device *sdp = cmd->device;
@@ -841,19 +854,14 @@ static blk_status_t sd_setup_unmap_cmnd(struct scsi_cmnd *cmd)
 	unsigned int data_len = 24;
 	char *buf;
 
-	rq->special_vec.bv_page = mempool_alloc(sd_page_pool, GFP_ATOMIC);
-	if (!rq->special_vec.bv_page)
+	buf = sd_set_special_bvec(rq, data_len);
+	if (!buf)
 		return BLK_STS_RESOURCE;
-	clear_highpage(rq->special_vec.bv_page);
-	rq->special_vec.bv_offset = 0;
-	rq->special_vec.bv_len = data_len;
-	rq->rq_flags |= RQF_SPECIAL_PAYLOAD;
 
 	cmd->cmd_len = 10;
 	cmd->cmnd[0] = UNMAP;
 	cmd->cmnd[8] = 24;
 
-	buf = bvec_virt(&rq->special_vec);
 	put_unaligned_be16(6 + 16, &buf[0]);
 	put_unaligned_be16(16, &buf[2]);
 	put_unaligned_be64(lba, &buf[8]);
@@ -876,13 +884,8 @@ static blk_status_t sd_setup_write_same16_cmnd(struct scsi_cmnd *cmd,
 	u32 nr_blocks = sectors_to_logical(sdp, blk_rq_sectors(rq));
 	u32 data_len = sdp->sector_size;
 
-	rq->special_vec.bv_page = mempool_alloc(sd_page_pool, GFP_ATOMIC);
-	if (!rq->special_vec.bv_page)
+	if (!sd_set_special_bvec(rq, data_len))
 		return BLK_STS_RESOURCE;
-	clear_highpage(rq->special_vec.bv_page);
-	rq->special_vec.bv_offset = 0;
-	rq->special_vec.bv_len = data_len;
-	rq->rq_flags |= RQF_SPECIAL_PAYLOAD;
 
 	cmd->cmd_len = 16;
 	cmd->cmnd[0] = WRITE_SAME_16;
@@ -908,13 +911,8 @@ static blk_status_t sd_setup_write_same10_cmnd(struct scsi_cmnd *cmd,
 	u32 nr_blocks = sectors_to_logical(sdp, blk_rq_sectors(rq));
 	u32 data_len = sdp->sector_size;
 
-	rq->special_vec.bv_page = mempool_alloc(sd_page_pool, GFP_ATOMIC);
-	if (!rq->special_vec.bv_page)
+	if (!sd_set_special_bvec(rq, data_len))
 		return BLK_STS_RESOURCE;
-	clear_highpage(rq->special_vec.bv_page);
-	rq->special_vec.bv_offset = 0;
-	rq->special_vec.bv_len = data_len;
-	rq->rq_flags |= RQF_SPECIAL_PAYLOAD;
 
 	cmd->cmd_len = 10;
 	cmd->cmnd[0] = WRITE_SAME;
-- 
2.39.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B587E5718F3
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 13:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232686AbiGLLvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 07:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232675AbiGLLvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 07:51:41 -0400
Received: from out30-45.freemail.mail.aliyun.com (out30-45.freemail.mail.aliyun.com [115.124.30.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64DACB3D6C;
        Tue, 12 Jul 2022 04:51:37 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0VJ7zTJC_1657626693;
Received: from localhost(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0VJ7zTJC_1657626693)
          by smtp.aliyun-inc.com;
          Tue, 12 Jul 2022 19:51:33 +0800
From:   Wen Gu <guwen@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/6] net/smc: optimize for smc_sndbuf_sync_sg_for_device and smc_rmb_sync_sg_for_cpu
Date:   Tue, 12 Jul 2022 19:51:26 +0800
Message-Id: <1657626690-60367-3-git-send-email-guwen@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1657626690-60367-1-git-send-email-guwen@linux.alibaba.com>
References: <1657626690-60367-1-git-send-email-guwen@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guangguan Wang <guangguan.wang@linux.alibaba.com>

Some CPU, such as Xeon, can guarantee DMA cache coherency.
So it is no need to use dma sync APIs to flush cache on such CPUs.
In order to avoid calling dma sync APIs on the IO path, use the
dma_need_sync to check whether smc_buf_desc needs dma sync when
creating smc_buf_desc.

Signed-off-by: Guangguan Wang <guangguan.wang@linux.alibaba.com>
---
 net/smc/smc_core.c |  8 ++++++++
 net/smc/smc_core.h |  1 +
 net/smc/smc_ib.c   | 29 +++++++++++++++++++++++++++++
 net/smc/smc_ib.h   |  2 ++
 4 files changed, 40 insertions(+)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 1faa0cb..fa3a7a8 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -2016,6 +2016,9 @@ static int smcr_buf_map_link(struct smc_buf_desc *buf_desc, bool is_rmb,
 		goto free_table;
 	}
 
+	buf_desc->is_dma_need_sync |=
+		smc_ib_is_sg_need_sync(lnk, buf_desc) << lnk->link_idx;
+
 	/* create a new memory region for the RMB */
 	if (is_rmb) {
 		rc = smc_ib_get_memory_region(lnk->roce_pd,
@@ -2234,6 +2237,7 @@ static int __smc_buf_create(struct smc_sock *smc, bool is_smcd, bool is_rmb)
 		/* check for reusable slot in the link group */
 		buf_desc = smc_buf_get_slot(bufsize_short, lock, buf_list);
 		if (buf_desc) {
+			buf_desc->is_dma_need_sync = 0;
 			SMC_STAT_RMB_SIZE(smc, is_smcd, is_rmb, bufsize);
 			SMC_STAT_BUF_REUSE(smc, is_smcd, is_rmb);
 			break; /* found reusable slot */
@@ -2292,6 +2296,8 @@ static int __smc_buf_create(struct smc_sock *smc, bool is_smcd, bool is_rmb)
 
 void smc_sndbuf_sync_sg_for_device(struct smc_connection *conn)
 {
+	if (!conn->sndbuf_desc->is_dma_need_sync)
+		return;
 	if (!smc_conn_lgr_valid(conn) || conn->lgr->is_smcd ||
 	    !smc_link_active(conn->lnk))
 		return;
@@ -2302,6 +2308,8 @@ void smc_rmb_sync_sg_for_cpu(struct smc_connection *conn)
 {
 	int i;
 
+	if (!conn->rmb_desc->is_dma_need_sync)
+		return;
 	if (!smc_conn_lgr_valid(conn) || conn->lgr->is_smcd)
 		return;
 	for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index c441dfe..46ddec5 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -180,6 +180,7 @@ struct smc_buf_desc {
 					/* mem region registered */
 			u8		is_map_ib[SMC_LINKS_PER_LGR_MAX];
 					/* mem region mapped to lnk */
+			u8		is_dma_need_sync;
 			u8		is_reg_err;
 					/* buffer registration err */
 		};
diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
index dcda416..60e5095 100644
--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@ -729,6 +729,29 @@ int smc_ib_get_memory_region(struct ib_pd *pd, int access_flags,
 	return 0;
 }
 
+bool smc_ib_is_sg_need_sync(struct smc_link *lnk,
+			    struct smc_buf_desc *buf_slot)
+{
+	struct scatterlist *sg;
+	unsigned int i;
+	bool ret = false;
+
+	/* for now there is just one DMA address */
+	for_each_sg(buf_slot->sgt[lnk->link_idx].sgl, sg,
+		    buf_slot->sgt[lnk->link_idx].nents, i) {
+		if (!sg_dma_len(sg))
+			break;
+		if (dma_need_sync(lnk->smcibdev->ibdev->dma_device,
+				  sg_dma_address(sg))) {
+			ret = true;
+			goto out;
+		}
+	}
+
+out:
+	return ret;
+}
+
 /* synchronize buffer usage for cpu access */
 void smc_ib_sync_sg_for_cpu(struct smc_link *lnk,
 			    struct smc_buf_desc *buf_slot,
@@ -737,6 +760,9 @@ void smc_ib_sync_sg_for_cpu(struct smc_link *lnk,
 	struct scatterlist *sg;
 	unsigned int i;
 
+	if (!(buf_slot->is_dma_need_sync & (1U << lnk->link_idx)))
+		return;
+
 	/* for now there is just one DMA address */
 	for_each_sg(buf_slot->sgt[lnk->link_idx].sgl, sg,
 		    buf_slot->sgt[lnk->link_idx].nents, i) {
@@ -757,6 +783,9 @@ void smc_ib_sync_sg_for_device(struct smc_link *lnk,
 	struct scatterlist *sg;
 	unsigned int i;
 
+	if (!(buf_slot->is_dma_need_sync & (1U << lnk->link_idx)))
+		return;
+
 	/* for now there is just one DMA address */
 	for_each_sg(buf_slot->sgt[lnk->link_idx].sgl, sg,
 		    buf_slot->sgt[lnk->link_idx].nents, i) {
diff --git a/net/smc/smc_ib.h b/net/smc/smc_ib.h
index 5d8b49c..03429567 100644
--- a/net/smc/smc_ib.h
+++ b/net/smc/smc_ib.h
@@ -102,6 +102,8 @@ void smc_ib_buf_unmap_sg(struct smc_link *lnk,
 int smc_ib_get_memory_region(struct ib_pd *pd, int access_flags,
 			     struct smc_buf_desc *buf_slot, u8 link_idx);
 void smc_ib_put_memory_region(struct ib_mr *mr);
+bool smc_ib_is_sg_need_sync(struct smc_link *lnk,
+			    struct smc_buf_desc *buf_slot);
 void smc_ib_sync_sg_for_cpu(struct smc_link *lnk,
 			    struct smc_buf_desc *buf_slot,
 			    enum dma_data_direction data_direction);
-- 
1.8.3.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13A7B52688C
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 19:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383099AbiEMRfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 13:35:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382503AbiEMRfD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 13:35:03 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D0EAE0CA;
        Fri, 13 May 2022 10:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652463302; x=1683999302;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mCy2FGFmB3x1wQgWQlMD9/ovX13zp7uR7gVssmtIKwQ=;
  b=A+qpVxG8UDKgkzLIZn6gnTNyajdz5coawZK5kbpIRt9XltrgqHZaQ6Ix
   nZ8GFmH/1EoT6MPywOOt/+fofVR9P38qlqbZbw/H8a5zK5AZ2U42IYRwS
   fod08Fj0S8MG92fbBnRu9TLPKpVbPa27LnknLz5MlaGKb7mz6P8fwvvbb
   RhM7czVIiAR7uldZ5P+CnCH6RHMQH/v7EiZgcU9MWnrvi3WrysqVhPY0E
   eRe+7gC5HlFGgS2qUu62EqmGA9zDz5In7S5ewQwgVXcrAmOCh1QA1UiFS
   yfAuOmHup6705D/u65a4xOKQ0tBaRdwoA51+Q2EayhuBs2rrIGd4bTBCS
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10346"; a="250895682"
X-IronPort-AV: E=Sophos;i="5.91,223,1647327600"; 
   d="scan'208";a="250895682"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2022 10:34:15 -0700
X-IronPort-AV: E=Sophos;i="5.91,223,1647327600"; 
   d="scan'208";a="624950930"
Received: from abarkat-mobl.amr.corp.intel.com (HELO rmarti10-nuc3.hsd1.or.comcast.net) ([10.212.160.143])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2022 10:34:14 -0700
From:   Ricardo Martinez <ricardo.martinez@linux.intel.com>
To:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, andriy.shevchenko@linux.intel.com,
        dinesh.sharma@intel.com, ilpo.jarvinen@linux.intel.com,
        moises.veleta@intel.com, sreehari.kancharla@intel.com,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>
Subject: [PATCH net-next 1/2] net: wwan: t7xx: Avoid calls to skb_data_area_size()
Date:   Fri, 13 May 2022 10:33:59 -0700
Message-Id: <20220513173400.3848271-2-ricardo.martinez@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220513173400.3848271-1-ricardo.martinez@linux.intel.com>
References: <20220513173400.3848271-1-ricardo.martinez@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

skb_data_area_size() helper was used to calculate the size of the
DMA mapped buffer passed to the HW. Instead of doing this, use the
size passed to allocate the skbs.

Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/net/wwan/t7xx/t7xx_hif_cldma.c     | 7 +++----
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c | 6 ++----
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wwan/t7xx/t7xx_hif_cldma.c b/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
index 46066dcd2607..0c52801ed0de 100644
--- a/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
+++ b/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
@@ -97,8 +97,7 @@ static int t7xx_cldma_alloc_and_map_skb(struct cldma_ctrl *md_ctrl, struct cldma
 	if (!req->skb)
 		return -ENOMEM;
 
-	req->mapped_buff = dma_map_single(md_ctrl->dev, req->skb->data,
-					  skb_data_area_size(req->skb), DMA_FROM_DEVICE);
+	req->mapped_buff = dma_map_single(md_ctrl->dev, req->skb->data, size, DMA_FROM_DEVICE);
 	if (dma_mapping_error(md_ctrl->dev, req->mapped_buff)) {
 		dev_kfree_skb_any(req->skb);
 		req->skb = NULL;
@@ -154,7 +153,7 @@ static int t7xx_cldma_gpd_rx_from_q(struct cldma_queue *queue, int budget, bool
 
 		if (req->mapped_buff) {
 			dma_unmap_single(md_ctrl->dev, req->mapped_buff,
-					 skb_data_area_size(skb), DMA_FROM_DEVICE);
+					 queue->tr_ring->pkt_size, DMA_FROM_DEVICE);
 			req->mapped_buff = 0;
 		}
 
@@ -376,7 +375,7 @@ static void t7xx_cldma_ring_free(struct cldma_ctrl *md_ctrl,
 	list_for_each_entry_safe(req_cur, req_next, &ring->gpd_ring, entry) {
 		if (req_cur->mapped_buff && req_cur->skb) {
 			dma_unmap_single(md_ctrl->dev, req_cur->mapped_buff,
-					 skb_data_area_size(req_cur->skb), tx_rx);
+					 ring->pkt_size, tx_rx);
 			req_cur->mapped_buff = 0;
 		}
 
diff --git a/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c
index 35a8a0d7c1ee..91a0eb19e0d8 100644
--- a/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c
+++ b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c
@@ -151,14 +151,12 @@ static bool t7xx_alloc_and_map_skb_info(const struct dpmaif_ctrl *dpmaif_ctrl,
 {
 	dma_addr_t data_bus_addr;
 	struct sk_buff *skb;
-	size_t data_len;
 
 	skb = __dev_alloc_skb(size, GFP_KERNEL);
 	if (!skb)
 		return false;
 
-	data_len = skb_data_area_size(skb);
-	data_bus_addr = dma_map_single(dpmaif_ctrl->dev, skb->data, data_len, DMA_FROM_DEVICE);
+	data_bus_addr = dma_map_single(dpmaif_ctrl->dev, skb->data, size, DMA_FROM_DEVICE);
 	if (dma_mapping_error(dpmaif_ctrl->dev, data_bus_addr)) {
 		dev_err_ratelimited(dpmaif_ctrl->dev, "DMA mapping error\n");
 		dev_kfree_skb_any(skb);
@@ -167,7 +165,7 @@ static bool t7xx_alloc_and_map_skb_info(const struct dpmaif_ctrl *dpmaif_ctrl,
 
 	cur_skb->skb = skb;
 	cur_skb->data_bus_addr = data_bus_addr;
-	cur_skb->data_len = data_len;
+	cur_skb->data_len = size;
 
 	return true;
 }
-- 
2.25.1


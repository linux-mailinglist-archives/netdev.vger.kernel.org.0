Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9549C5F7205
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 01:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232441AbiJFXpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 19:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232415AbiJFXo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 19:44:57 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D88222E9D1
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 16:44:53 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id x1-20020a17090ab00100b001fda21bbc90so5739702pjq.3
        for <netdev@vger.kernel.org>; Thu, 06 Oct 2022 16:44:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=w872s1qBw4HRY/5SU+ndTlbJcsJOR5NsN3SDVLlFieY=;
        b=SeuNIYCUcup2mMlwYPFRTgX8p9zOZFV+AL/B3uvSeDBwUaanZo8r75FvungwHrk8QQ
         9HiegBuZDgGsQE2mwPz9V0HC/t56Jm6tFDVWxJCGGDDpa2Mq5bPOpHVfmKcRtEfVNGMJ
         ekGdl2hlbyGJNEnlTrQgugzdFpBeHKziPLkw4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w872s1qBw4HRY/5SU+ndTlbJcsJOR5NsN3SDVLlFieY=;
        b=2hGv1Mq9RxI6R8XLfx1zBp82fEqjqF6clz27XBg8m/bRnqDm8BFRM9RhCg8rGUHKEG
         Fc69SXUi2D/+H5bSSsMiV12e+b8dvZB3fDiP71PpaqVNqHGU+czgPZ01Euq3/d1FvVAU
         3PQ1h/7AB6fHeE8e+LXeIOR/OmTirgl5sqmjrX+65+IjAw6fxvhbOFb+VYEao8HQousu
         f/dAVTa6JsevH3SYQ2yzf/zZHwM4mGsYXJXuxtpcD09K1xi7xR1SDZswCYUYsbQiMZjP
         /XK4J1FuQUNcHg1orsDssIgxeXeRBYzp8bNi9TmBFSNJ13Nhm4Btr1TOM5+ZRNd9O+g2
         0F9Q==
X-Gm-Message-State: ACrzQf3chZ7PBCmvjFy+P0eLmcx51tDx25yuBxghcaQBrIiCRtKGWNc8
        +MtNcoFU73TiYktX/1r2qAlldw==
X-Google-Smtp-Source: AMsMyM5EY1fIXvRtC6TcL/Qjn7zpaAbac2QU/hQaxn8cLRA6dSx76BQ6zDS7UWnPWW47kkeQcAsTgQ==
X-Received: by 2002:a17:902:7290:b0:17f:d04b:bf57 with SMTP id d16-20020a170902729000b0017fd04bbf57mr794668pll.147.1665099893365;
        Thu, 06 Oct 2022 16:44:53 -0700 (PDT)
Received: from localhost.localdomain (c-24-6-151-244.hsd1.ca.comcast.net. [24.6.151.244])
        by smtp.gmail.com with ESMTPSA id u4-20020a631404000000b0045935b12e97sm308124pgl.36.2022.10.06.16.44.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Oct 2022 16:44:52 -0700 (PDT)
From:   Joe Damato <jdamato@fastly.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        anthony.l.nguyen@intel.com, jesse.brandeburg@intel.com,
        maciej.fijalkowski@intel.com, Joe Damato <jdamato@fastly.com>
Subject: [next-queue v3 3/4] i40e: Record number of RXes cleaned during NAPI
Date:   Thu,  6 Oct 2022 16:43:57 -0700
Message-Id: <1665099838-94839-4-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1665099838-94839-1-git-send-email-jdamato@fastly.com>
References: <1665099838-94839-1-git-send-email-jdamato@fastly.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adjust i40e_clean_rx_irq and i40e_clean_rx_irq_zc to accept an out
parameter which records the number of RX packets cleaned.

Care has been taken to avoid any changes in control flow.

Signed-off-by: Joe Damato <jdamato@fastly.com>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 14 ++++++++++----
 drivers/net/ethernet/intel/i40e/i40e_xsk.c  |  6 +++++-
 drivers/net/ethernet/intel/i40e/i40e_xsk.h  |  3 ++-
 3 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index a2cc98e..adf133b 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -2426,6 +2426,7 @@ static void i40e_inc_ntc(struct i40e_ring *rx_ring)
  * i40e_clean_rx_irq - Clean completed descriptors from Rx ring - bounce buf
  * @rx_ring: rx descriptor ring to transact packets on
  * @budget: Total limit on number of packets to process
+ * @rx_cleaned: Out parameter of the number of packets processed
  *
  * This function provides a "bounce buffer" approach to Rx interrupt
  * processing.  The advantage to this is that on systems that have
@@ -2434,7 +2435,8 @@ static void i40e_inc_ntc(struct i40e_ring *rx_ring)
  *
  * Returns amount of work completed
  **/
-static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
+static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget,
+			     unsigned int *rx_cleaned)
 {
 	unsigned int total_rx_bytes = 0, total_rx_packets = 0, frame_sz = 0;
 	u16 cleaned_count = I40E_DESC_UNUSED(rx_ring);
@@ -2571,6 +2573,8 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
 
 	i40e_update_rx_stats(rx_ring, total_rx_bytes, total_rx_packets);
 
+	*rx_cleaned = total_rx_packets;
+
 	/* guarantee a trip back through this routine if there was a failure */
 	return failure ? budget : (int)total_rx_packets;
 }
@@ -2694,11 +2698,13 @@ int i40e_napi_poll(struct napi_struct *napi, int budget)
 	struct i40e_vsi *vsi = q_vector->vsi;
 	struct i40e_ring *ring;
 	bool tx_clean_complete = true;
+	bool rx_clean_complete = true;
 	bool clean_complete = true;
 	bool arm_wb = false;
 	int budget_per_ring;
 	int work_done = 0;
 	unsigned int tx_cleaned = 0;
+	unsigned int rx_cleaned = 0;
 
 	if (test_bit(__I40E_VSI_DOWN, vsi->state)) {
 		napi_complete(napi);
@@ -2738,13 +2744,13 @@ int i40e_napi_poll(struct napi_struct *napi, int budget)
 
 	i40e_for_each_ring(ring, q_vector->rx) {
 		int cleaned = ring->xsk_pool ?
-			      i40e_clean_rx_irq_zc(ring, budget_per_ring) :
-			      i40e_clean_rx_irq(ring, budget_per_ring);
+			      i40e_clean_rx_irq_zc(ring, budget_per_ring, &rx_cleaned) :
+			      i40e_clean_rx_irq(ring, budget_per_ring, &rx_cleaned);
 
 		work_done += cleaned;
 		/* if we clean as many as budgeted, we must not be done */
 		if (cleaned >= budget_per_ring)
-			clean_complete = false;
+			clean_complete = rx_clean_complete = false;
 	}
 
 	/* If work not completed, return budget and polling will return */
diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index f98ce7e4..b1f582a0 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -378,10 +378,12 @@ static void i40e_handle_xdp_result_zc(struct i40e_ring *rx_ring,
  * i40e_clean_rx_irq_zc - Consumes Rx packets from the hardware ring
  * @rx_ring: Rx ring
  * @budget: NAPI budget
+ * @rx_cleaned: out parameter of the packets processed
  *
  * Returns amount of work completed
  **/
-int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
+int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget,
+			  unsigned int *rx_cleaned)
 {
 	unsigned int total_rx_bytes = 0, total_rx_packets = 0;
 	u16 next_to_clean = rx_ring->next_to_clean;
@@ -452,6 +454,8 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 	i40e_finalize_xdp_rx(rx_ring, xdp_xmit);
 	i40e_update_rx_stats(rx_ring, total_rx_bytes, total_rx_packets);
 
+	*rx_cleaned = total_rx_packets;
+
 	if (xsk_uses_need_wakeup(rx_ring->xsk_pool)) {
 		if (failure || next_to_clean == rx_ring->next_to_use)
 			xsk_set_rx_need_wakeup(rx_ring->xsk_pool);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.h b/drivers/net/ethernet/intel/i40e/i40e_xsk.h
index 396ed11..1089cc0 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.h
@@ -28,7 +28,8 @@ int i40e_queue_pair_enable(struct i40e_vsi *vsi, int queue_pair);
 int i40e_xsk_pool_setup(struct i40e_vsi *vsi, struct xsk_buff_pool *pool,
 			u16 qid);
 bool i40e_alloc_rx_buffers_zc(struct i40e_ring *rx_ring, u16 cleaned_count);
-int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget);
+int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget,
+			  unsigned int *rx_cleaned);
 
 bool i40e_clean_xdp_tx_irq(struct i40e_vsi *vsi, struct i40e_ring *tx_ring,
 			   unsigned int *tx_cleaned);
-- 
2.7.4


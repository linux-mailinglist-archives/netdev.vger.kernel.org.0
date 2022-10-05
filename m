Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A6E85F5BA3
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 23:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231129AbiJEVXF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 17:23:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230505AbiJEVW6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 17:22:58 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30A3E8263C
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 14:22:56 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id v10-20020a17090a634a00b00205e48cf845so2459476pjs.4
        for <netdev@vger.kernel.org>; Wed, 05 Oct 2022 14:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date;
        bh=q4JM7+U+5ija2zkoCvZioCAGm6tutm0eZk4NJurUNV4=;
        b=ScAKQ4e/26zjF3AlEMo3ibjAz8V0TQgk9Qm4zjRZTmOuN7dqjUbFgqc6mud9yu/qwJ
         WOQwHswRQH6j0NDPTiG3gZ2sN74zsBJMcXuHjTGEXK5W/TxZw//P5w4CBOhm/KUXdnKv
         zImN6+AyduYB3hf58UBCluDPaC53iVL068x7w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date;
        bh=q4JM7+U+5ija2zkoCvZioCAGm6tutm0eZk4NJurUNV4=;
        b=K3X8xiZPsCmLMlcpPS6VtEScEVNuichu3wPDD+aJeYfm5lael8zHjKHo9JxhSXZScb
         aTEPACZuihCPshsx/rTnEtvWhNRFIpTdOhdudkqHG7CmdjOC4lRtHjbi2RQdmBjc4ORy
         akpIAFP/QF/fjE9Zn1qE2ahZaYTNqx2CfaAVpv6+v+uxdaMNel1wivPn1J7nAanfQwbo
         sBMZVN/GQKFirxldN09bHJZypJx684PcvlM7V4Gd5/dYDAdMBeZK9Ke2Em6/5H5FKPCy
         q7okBPZLzW4YzmlEN6eLCMW4WwmiC3WNb+mAK++v9YGUGhvauh0VQZhCgNjV2D7IflaV
         LEiA==
X-Gm-Message-State: ACrzQf18sCODAPmxzwzvT83xZs8YUhdyhOQ3fJaEOEJ+HuggIkeG3IMM
        ZoD8DT17Ra7lltbVznMehzZkWA==
X-Google-Smtp-Source: AMsMyM7py2fT6tDqPJxN4ka6WJPXRLdCqLKRbZedN3T8VjdsRp03xHOQ4PHrp4Jhj7ndTcP/o9Uhpg==
X-Received: by 2002:a17:902:8ec5:b0:179:d8f4:cb64 with SMTP id x5-20020a1709028ec500b00179d8f4cb64mr1435841plo.16.1665004975689;
        Wed, 05 Oct 2022 14:22:55 -0700 (PDT)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id q12-20020a170902dacc00b0017f7b6e970esm2404666plx.146.2022.10.05.14.22.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Oct 2022 14:22:55 -0700 (PDT)
From:   Joe Damato <jdamato@fastly.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        anthony.l.nguyen@intel.com, jesse.brandeburg@intel.com,
        maciej.fijalkowski@intel.com, Joe Damato <jdamato@fastly.com>
Subject: [next-queue v2 3/4] i40e: Record number of RXes cleaned during NAPI
Date:   Wed,  5 Oct 2022 14:21:52 -0700
Message-Id: <1665004913-25656-4-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1665004913-25656-1-git-send-email-jdamato@fastly.com>
References: <1665004913-25656-1-git-send-email-jdamato@fastly.com>
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
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 11 ++++++++---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c  |  6 +++++-
 drivers/net/ethernet/intel/i40e/i40e_xsk.h  |  3 ++-
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index a2cc98e..8a0d4fd 100644
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
@@ -2699,6 +2703,7 @@ int i40e_napi_poll(struct napi_struct *napi, int budget)
 	int budget_per_ring;
 	int work_done = 0;
 	unsigned int tx_cleaned = 0;
+	unsigned int rx_cleaned = 0;
 
 	if (test_bit(__I40E_VSI_DOWN, vsi->state)) {
 		napi_complete(napi);
@@ -2738,8 +2743,8 @@ int i40e_napi_poll(struct napi_struct *napi, int budget)
 
 	i40e_for_each_ring(ring, q_vector->rx) {
 		int cleaned = ring->xsk_pool ?
-			      i40e_clean_rx_irq_zc(ring, budget_per_ring) :
-			      i40e_clean_rx_irq(ring, budget_per_ring);
+			      i40e_clean_rx_irq_zc(ring, budget_per_ring, &rx_cleaned) :
+			      i40e_clean_rx_irq(ring, budget_per_ring, &rx_cleaned);
 
 		work_done += cleaned;
 		/* if we clean as many as budgeted, we must not be done */
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


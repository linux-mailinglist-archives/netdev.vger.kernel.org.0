Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01E125F50D7
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 10:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbiJEIco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 04:32:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbiJEIcm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 04:32:42 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 264926D563
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 01:32:41 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id x32-20020a17090a38a300b00209dced49cfso1145091pjb.0
        for <netdev@vger.kernel.org>; Wed, 05 Oct 2022 01:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date;
        bh=5c69IeZzfgTGXU/R5PtSxXzBkuWCA8qXZSyfdvVPThc=;
        b=L0TCBdGPIONDu+M+x4v6NGulAoiFhyZLsQnUfFRZr1/uzq1c3yxaZ1dVzdpWzySKv8
         pRIiox9HBzsKp+XlESc/nv1EpxhvjDtLrSMxCGkPvdpUe3yHHTgrSHX6smI2ayRUAE4G
         dqPTD6y1eyB3293o2JoIleOzVfuptLQGDeVN8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date;
        bh=5c69IeZzfgTGXU/R5PtSxXzBkuWCA8qXZSyfdvVPThc=;
        b=ycXttoOHx3vqOM8G/MmZKDjVYB3pQBmxHKjACMnflgctGs7JbKoMUP0XUchifSgaDW
         4kaIvOnC30zRcNMTKGwS292v6QpdPiF+wYxn25qdgtIjoZOCLw/BnixjeXIqaki+SByo
         vdXyZSftvVO6hg4SiVflTkEBuiVm9QGl0ubQVmim388YvDguKISt9mLFfcpttXw5NLL8
         cXuFwJo9I0i0TmUw+ydz7ioBTjml0Eo58W0wOapI7MI+xc3sAp8eC3rpMnQP5jBUz8ZC
         ZP8CVj1iVNt0WeYGnivDN0q7D3OG8iGANiDnQiWSy8CtZnN+l+1YHCp+vVN48DqZpJm4
         oscg==
X-Gm-Message-State: ACrzQf24ydZeKDn38mBttLwMIB8GvOMtn3+Fe9MDg/SjK590V9gDg86O
        SgOezWTwC8DkVwVJXzA/n+2lzQ==
X-Google-Smtp-Source: AMsMyM5UeKKnC3PGanLBov9NeVY79Ss7qMxRT/gIE5zVzi9U8iCKOISbqaBnpa6GtqdJxMv+Ni151Q==
X-Received: by 2002:a17:903:2441:b0:178:4f51:1f78 with SMTP id l1-20020a170903244100b001784f511f78mr30089335pls.82.1664958760583;
        Wed, 05 Oct 2022 01:32:40 -0700 (PDT)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id jj9-20020a170903048900b0017ec1b1bf9fsm5899320plb.217.2022.10.05.01.32.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Oct 2022 01:32:40 -0700 (PDT)
From:   Joe Damato <jdamato@fastly.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        anthony.l.nguyen@intel.com, jesse.brandeburg@intel.com,
        Joe Damato <jdamato@fastly.com>
Subject: [next-queue 2/3] i40e: i40e_clean_tx_irq returns work done
Date:   Wed,  5 Oct 2022 01:31:42 -0700
Message-Id: <1664958703-4224-3-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1664958703-4224-1-git-send-email-jdamato@fastly.com>
References: <1664958703-4224-1-git-send-email-jdamato@fastly.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adjust i40e_clean_tx_irq to return the actual number of packets cleaned
and adjust the logic in i40e_napi_poll to check this value.

Signed-off-by: Joe Damato <jdamato@fastly.com>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 24 +++++++++++++-----------
 drivers/net/ethernet/intel/i40e/i40e_xsk.c  | 12 ++++++------
 drivers/net/ethernet/intel/i40e/i40e_xsk.h  |  2 +-
 3 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index b97c95f..ed88309 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -924,10 +924,10 @@ void i40e_detect_recover_hung(struct i40e_vsi *vsi)
  * @tx_ring: Tx ring to clean
  * @napi_budget: Used to determine if we are in netpoll
  *
- * Returns true if there's any budget left (e.g. the clean is finished)
+ * Returns the number of packets cleaned
  **/
-static bool i40e_clean_tx_irq(struct i40e_vsi *vsi,
-			      struct i40e_ring *tx_ring, int napi_budget)
+static int i40e_clean_tx_irq(struct i40e_vsi *vsi,
+			     struct i40e_ring *tx_ring, int napi_budget)
 {
 	int i = tx_ring->next_to_clean;
 	struct i40e_tx_buffer *tx_buf;
@@ -1026,7 +1026,7 @@ static bool i40e_clean_tx_irq(struct i40e_vsi *vsi,
 	i40e_arm_wb(tx_ring, vsi, budget);
 
 	if (ring_is_xdp(tx_ring))
-		return !!budget;
+		return total_packets;
 
 	/* notify netdev of completed buffers */
 	netdev_tx_completed_queue(txring_txq(tx_ring),
@@ -1048,7 +1048,7 @@ static bool i40e_clean_tx_irq(struct i40e_vsi *vsi,
 		}
 	}
 
-	return !!budget;
+	return total_packets;
 }
 
 /**
@@ -2689,10 +2689,12 @@ int i40e_napi_poll(struct napi_struct *napi, int budget)
 			       container_of(napi, struct i40e_q_vector, napi);
 	struct i40e_vsi *vsi = q_vector->vsi;
 	struct i40e_ring *ring;
+	bool tx_clean_complete = true;
 	bool clean_complete = true;
 	bool arm_wb = false;
 	int budget_per_ring;
 	int work_done = 0;
+	int tx_wd = 0;
 
 	if (test_bit(__I40E_VSI_DOWN, vsi->state)) {
 		napi_complete(napi);
@@ -2703,12 +2705,12 @@ int i40e_napi_poll(struct napi_struct *napi, int budget)
 	 * budget and be more aggressive about cleaning up the Tx descriptors.
 	 */
 	i40e_for_each_ring(ring, q_vector->tx) {
-		bool wd = ring->xsk_pool ?
-			  i40e_clean_xdp_tx_irq(vsi, ring) :
-			  i40e_clean_tx_irq(vsi, ring, budget);
+		tx_wd = ring->xsk_pool ?
+			i40e_clean_xdp_tx_irq(vsi, ring) :
+			i40e_clean_tx_irq(vsi, ring, budget);
 
-		if (!wd) {
-			clean_complete = false;
+		if (tx_wd >= budget) {
+			tx_clean_complete = false;
 			continue;
 		}
 		arm_wb |= ring->arm_wb;
@@ -2742,7 +2744,7 @@ int i40e_napi_poll(struct napi_struct *napi, int budget)
 	}
 
 	/* If work not completed, return budget and polling will return */
-	if (!clean_complete) {
+	if (!clean_complete || !tx_clean_complete) {
 		int cpu_id = smp_processor_id();
 
 		/* It is possible that the interrupt affinity has changed but,
diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 790aaeff..925682c 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -531,9 +531,9 @@ static void i40e_set_rs_bit(struct i40e_ring *xdp_ring)
  * @xdp_ring: XDP Tx ring
  * @budget: NAPI budget
  *
- * Returns true if the work is finished.
+ * Returns number of packets cleaned
  **/
-static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
+static int i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
 {
 	struct xdp_desc *descs = xdp_ring->xsk_pool->tx_descs;
 	u32 nb_pkts, nb_processed = 0;
@@ -541,7 +541,7 @@ static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
 
 	nb_pkts = xsk_tx_peek_release_desc_batch(xdp_ring->xsk_pool, budget);
 	if (!nb_pkts)
-		return true;
+		return 0;
 
 	if (xdp_ring->next_to_use + nb_pkts >= xdp_ring->count) {
 		nb_processed = xdp_ring->count - xdp_ring->next_to_use;
@@ -558,7 +558,7 @@ static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
 
 	i40e_update_tx_stats(xdp_ring, nb_pkts, total_bytes);
 
-	return nb_pkts < budget;
+	return nb_pkts;
 }
 
 /**
@@ -582,9 +582,9 @@ static void i40e_clean_xdp_tx_buffer(struct i40e_ring *tx_ring,
  * @vsi: Current VSI
  * @tx_ring: XDP Tx ring
  *
- * Returns true if cleanup/tranmission is done.
+ * Returns number of packets cleaned
  **/
-bool i40e_clean_xdp_tx_irq(struct i40e_vsi *vsi, struct i40e_ring *tx_ring)
+int i40e_clean_xdp_tx_irq(struct i40e_vsi *vsi, struct i40e_ring *tx_ring)
 {
 	struct xsk_buff_pool *bp = tx_ring->xsk_pool;
 	u32 i, completed_frames, xsk_frames = 0;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.h b/drivers/net/ethernet/intel/i40e/i40e_xsk.h
index 821df24..4e810c2 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.h
@@ -30,7 +30,7 @@ int i40e_xsk_pool_setup(struct i40e_vsi *vsi, struct xsk_buff_pool *pool,
 bool i40e_alloc_rx_buffers_zc(struct i40e_ring *rx_ring, u16 cleaned_count);
 int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget);
 
-bool i40e_clean_xdp_tx_irq(struct i40e_vsi *vsi, struct i40e_ring *tx_ring);
+int i40e_clean_xdp_tx_irq(struct i40e_vsi *vsi, struct i40e_ring *tx_ring);
 int i40e_xsk_wakeup(struct net_device *dev, u32 queue_id, u32 flags);
 int i40e_realloc_rx_bi_zc(struct i40e_vsi *vsi, bool zc);
 void i40e_clear_rx_bi_zc(struct i40e_ring *rx_ring);
-- 
2.7.4


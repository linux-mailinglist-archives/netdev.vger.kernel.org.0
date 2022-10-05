Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 799F85F5BA0
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 23:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbiJEVW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 17:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbiJEVWz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 17:22:55 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8229F82628
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 14:22:54 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id v10-20020a17090a634a00b00205e48cf845so2459398pjs.4
        for <netdev@vger.kernel.org>; Wed, 05 Oct 2022 14:22:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date;
        bh=U0EN7jLsuXZw8oNWja5MPj7Nd3Qv6VMTCazforCQivc=;
        b=FEITd7pN7m03rHGdolRifajln9xYGwZSSvrnKfKhzd21QJhaNvUa7qcWi347wgn2Sy
         6CxB4CtrQjvZj7HqTolY2fdYmzNUL/dPsTyMktZLy2E3LM7fKMyFCLy0HJ7fomV3w2Tg
         u+kRaqRCz90TLnNMOxk+FSJnJSZQMQgrxHGC8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date;
        bh=U0EN7jLsuXZw8oNWja5MPj7Nd3Qv6VMTCazforCQivc=;
        b=gBfZte4puXktr6J/3ZSGV7uLA4eH3lFue8gWgx74m5mw4VLvr1N0lC5uTEFO5aueZu
         ll4j+a8/jJ+waDZyxLAEB70a+/QD1wkHN3Kk2wgOe1Dw4GnYviUNwCc1fGDzFoGNjS7e
         isn1UrOP5XJye7BBorQwErWA2xxcy/0jYGwMl05PVPECGKvXowwrU+i1k3Y401RSTxYO
         Pp2DIjx95rZa9bZ9hyWe54HJJ0BGIp6FI0z+kRJAHEwBWqqbTq2mAYjafsuE87LDxqnh
         0pf8i8YM5MOHwFV0gRroUvTnNhM9wqW2Ne1NBZ0sPG/vhPRRy5DZeuqRNfQ0aZiTrw8J
         6K0A==
X-Gm-Message-State: ACrzQf3qQpXMJrKbhWjEWUDJFtEty7WjejWqMuLRvbrsVt4jYVZvKpOe
        8f65i457HQ4RzHyH6gauMlJbeiHgze6IEg==
X-Google-Smtp-Source: AMsMyM4aGc1TP3ffUgzMXwjgbCYlhU+t+KjxGZY6LeMaKOd3cIU1SJv1ncLlpzyWRfEtLwOkRNc3yQ==
X-Received: by 2002:a17:903:1211:b0:178:9353:9e42 with SMTP id l17-20020a170903121100b0017893539e42mr1248640plh.45.1665004974025;
        Wed, 05 Oct 2022 14:22:54 -0700 (PDT)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id q12-20020a170902dacc00b0017f7b6e970esm2404666plx.146.2022.10.05.14.22.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Oct 2022 14:22:53 -0700 (PDT)
From:   Joe Damato <jdamato@fastly.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        anthony.l.nguyen@intel.com, jesse.brandeburg@intel.com,
        maciej.fijalkowski@intel.com, Joe Damato <jdamato@fastly.com>
Subject: [next-queue v2 2/4] i40e: Record number TXes cleaned during NAPI
Date:   Wed,  5 Oct 2022 14:21:51 -0700
Message-Id: <1665004913-25656-3-git-send-email-jdamato@fastly.com>
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

Update i40e_clean_tx_irq to take an out parameter (tx_cleaned) which stores
the number TXs cleaned.

Likewise, update i40e_clean_xdp_tx_irq and i40e_xmit_zc to do the same.

Care has been taken to avoid changing the control flow of any functions
involved.

Signed-off-by: Joe Damato <jdamato@fastly.com>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 16 +++++++++++-----
 drivers/net/ethernet/intel/i40e/i40e_xsk.c  | 15 +++++++++++----
 drivers/net/ethernet/intel/i40e/i40e_xsk.h  |  3 ++-
 3 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index b97c95f..a2cc98e 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -923,11 +923,13 @@ void i40e_detect_recover_hung(struct i40e_vsi *vsi)
  * @vsi: the VSI we care about
  * @tx_ring: Tx ring to clean
  * @napi_budget: Used to determine if we are in netpoll
+ * @tx_cleaned: Out parameter set to the number of TXes cleaned
  *
  * Returns true if there's any budget left (e.g. the clean is finished)
  **/
 static bool i40e_clean_tx_irq(struct i40e_vsi *vsi,
-			      struct i40e_ring *tx_ring, int napi_budget)
+			      struct i40e_ring *tx_ring, int napi_budget,
+			      unsigned int *tx_cleaned)
 {
 	int i = tx_ring->next_to_clean;
 	struct i40e_tx_buffer *tx_buf;
@@ -1026,7 +1028,7 @@ static bool i40e_clean_tx_irq(struct i40e_vsi *vsi,
 	i40e_arm_wb(tx_ring, vsi, budget);
 
 	if (ring_is_xdp(tx_ring))
-		return !!budget;
+		goto out;
 
 	/* notify netdev of completed buffers */
 	netdev_tx_completed_queue(txring_txq(tx_ring),
@@ -1048,6 +1050,8 @@ static bool i40e_clean_tx_irq(struct i40e_vsi *vsi,
 		}
 	}
 
+out:
+	*tx_cleaned = total_packets;
 	return !!budget;
 }
 
@@ -2689,10 +2693,12 @@ int i40e_napi_poll(struct napi_struct *napi, int budget)
 			       container_of(napi, struct i40e_q_vector, napi);
 	struct i40e_vsi *vsi = q_vector->vsi;
 	struct i40e_ring *ring;
+	bool tx_clean_complete = true;
 	bool clean_complete = true;
 	bool arm_wb = false;
 	int budget_per_ring;
 	int work_done = 0;
+	unsigned int tx_cleaned = 0;
 
 	if (test_bit(__I40E_VSI_DOWN, vsi->state)) {
 		napi_complete(napi);
@@ -2704,11 +2710,11 @@ int i40e_napi_poll(struct napi_struct *napi, int budget)
 	 */
 	i40e_for_each_ring(ring, q_vector->tx) {
 		bool wd = ring->xsk_pool ?
-			  i40e_clean_xdp_tx_irq(vsi, ring) :
-			  i40e_clean_tx_irq(vsi, ring, budget);
+			  i40e_clean_xdp_tx_irq(vsi, ring, &tx_cleaned) :
+			  i40e_clean_tx_irq(vsi, ring, budget, &tx_cleaned);
 
 		if (!wd) {
-			clean_complete = false;
+			clean_complete = tx_clean_complete = false;
 			continue;
 		}
 		arm_wb |= ring->arm_wb;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 790aaeff..f98ce7e4 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -530,18 +530,22 @@ static void i40e_set_rs_bit(struct i40e_ring *xdp_ring)
  * i40e_xmit_zc - Performs zero-copy Tx AF_XDP
  * @xdp_ring: XDP Tx ring
  * @budget: NAPI budget
+ * @tx_cleaned: Out parameter of the TX packets processed
  *
  * Returns true if the work is finished.
  **/
-static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
+static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget,
+			 unsigned int *tx_cleaned)
 {
 	struct xdp_desc *descs = xdp_ring->xsk_pool->tx_descs;
 	u32 nb_pkts, nb_processed = 0;
 	unsigned int total_bytes = 0;
 
 	nb_pkts = xsk_tx_peek_release_desc_batch(xdp_ring->xsk_pool, budget);
-	if (!nb_pkts)
+	if (!nb_pkts) {
+		*tx_cleaned = 0;
 		return true;
+	}
 
 	if (xdp_ring->next_to_use + nb_pkts >= xdp_ring->count) {
 		nb_processed = xdp_ring->count - xdp_ring->next_to_use;
@@ -558,6 +562,7 @@ static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
 
 	i40e_update_tx_stats(xdp_ring, nb_pkts, total_bytes);
 
+	*tx_cleaned = nb_pkts;
 	return nb_pkts < budget;
 }
 
@@ -581,10 +586,12 @@ static void i40e_clean_xdp_tx_buffer(struct i40e_ring *tx_ring,
  * i40e_clean_xdp_tx_irq - Completes AF_XDP entries, and cleans XDP entries
  * @vsi: Current VSI
  * @tx_ring: XDP Tx ring
+ * @tx_cleaned: out parameter of number of TXes cleaned
  *
  * Returns true if cleanup/tranmission is done.
  **/
-bool i40e_clean_xdp_tx_irq(struct i40e_vsi *vsi, struct i40e_ring *tx_ring)
+bool i40e_clean_xdp_tx_irq(struct i40e_vsi *vsi, struct i40e_ring *tx_ring,
+			   unsigned int *tx_cleaned)
 {
 	struct xsk_buff_pool *bp = tx_ring->xsk_pool;
 	u32 i, completed_frames, xsk_frames = 0;
@@ -634,7 +641,7 @@ bool i40e_clean_xdp_tx_irq(struct i40e_vsi *vsi, struct i40e_ring *tx_ring)
 	if (xsk_uses_need_wakeup(tx_ring->xsk_pool))
 		xsk_set_tx_need_wakeup(tx_ring->xsk_pool);
 
-	return i40e_xmit_zc(tx_ring, I40E_DESC_UNUSED(tx_ring));
+	return i40e_xmit_zc(tx_ring, I40E_DESC_UNUSED(tx_ring), tx_cleaned);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.h b/drivers/net/ethernet/intel/i40e/i40e_xsk.h
index 821df24..396ed11 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.h
@@ -30,7 +30,8 @@ int i40e_xsk_pool_setup(struct i40e_vsi *vsi, struct xsk_buff_pool *pool,
 bool i40e_alloc_rx_buffers_zc(struct i40e_ring *rx_ring, u16 cleaned_count);
 int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget);
 
-bool i40e_clean_xdp_tx_irq(struct i40e_vsi *vsi, struct i40e_ring *tx_ring);
+bool i40e_clean_xdp_tx_irq(struct i40e_vsi *vsi, struct i40e_ring *tx_ring,
+			   unsigned int *tx_cleaned);
 int i40e_xsk_wakeup(struct net_device *dev, u32 queue_id, u32 flags);
 int i40e_realloc_rx_bi_zc(struct i40e_vsi *vsi, bool zc);
 void i40e_clear_rx_bi_zc(struct i40e_ring *rx_ring);
-- 
2.7.4


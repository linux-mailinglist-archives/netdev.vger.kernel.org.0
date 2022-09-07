Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF725B0916
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 17:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbiIGPqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 11:46:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbiIGPqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 11:46:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C736AA0F
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 08:46:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662565590;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cS7W2e1Dl56yHRp9VGJuoJDiUQXh5Ga6c6qOZmdIdE0=;
        b=A33ygBHZnkK/zUbVVv2NOcrlGA7Ag3wIXBW6RM9ve+a2Iaor8opf+OWU+fMrEqBcgmf7hP
        cnQQWHj/ml4a70Iax6rdUsCXWfUYddjz7IDAXpJ0Kowhd6edGKukinRBAJMG+jViLdbP8b
        O03XTpVsx237zY+y78vW5NQFW9NvGvw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-107-szCGiJBEP2eSDktWtJGiBw-1; Wed, 07 Sep 2022 11:46:23 -0400
X-MC-Unique: szCGiJBEP2eSDktWtJGiBw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 09AA12999B52;
        Wed,  7 Sep 2022 15:46:23 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8DB64945DB;
        Wed,  7 Sep 2022 15:46:22 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 8897730721A6C;
        Wed,  7 Sep 2022 17:46:21 +0200 (CEST)
Subject: [PATCH RFCv2 bpf-next 16/18] ixgbe: add rx timestamp xdp hints
 support
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        xdp-hints@xdp-project.net, larysa.zaremba@intel.com,
        memxor@gmail.com, Lorenzo Bianconi <lorenzo@kernel.org>,
        mtahhan@redhat.com,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        dave@dtucker.co.uk, Magnus Karlsson <magnus.karlsson@intel.com>,
        bjorn@kernel.org
Date:   Wed, 07 Sep 2022 17:46:21 +0200
Message-ID: <166256558150.1434226.3657678401785942330.stgit@firesoul>
In-Reply-To: <166256538687.1434226.15760041133601409770.stgit@firesoul>
References: <166256538687.1434226.15760041133601409770.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maryam Tahhan <mtahhan@redhat.com>

Enable rx timestamp xdp-hints for ixgbe. Similar to i40e.

Signed-off-by: Maryam Tahhan <mtahhan@redhat.com>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe.h      |    2 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |   37 +++++++++++
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c  |   82 ++++++++++++++++---------
 3 files changed, 90 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe.h b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
index 5369a97ff5ec..97b3fbd2de28 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
@@ -1023,6 +1023,8 @@ void ixgbe_ptp_rx_hang(struct ixgbe_adapter *adapter);
 void ixgbe_ptp_tx_hang(struct ixgbe_adapter *adapter);
 void ixgbe_ptp_rx_pktstamp(struct ixgbe_q_vector *, struct sk_buff *);
 void ixgbe_ptp_rx_rgtstamp(struct ixgbe_q_vector *, struct sk_buff *skb);
+u64 ixgbe_ptp_convert_to_hwtstamp(struct ixgbe_adapter *adapter, u64 timestamp);
+u64 ixgbe_ptp_rx_hwtstamp_raw(struct ixgbe_adapter *adapter);
 static inline void ixgbe_ptp_rx_hwtstamp(struct ixgbe_ring *rx_ring,
 					 union ixgbe_adv_rx_desc *rx_desc,
 					 struct sk_buff *skb)
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 0c8ee19e6d44..dc371b4c65bb 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -68,7 +68,18 @@ struct xdp_hints_ixgbe {
 	struct xdp_hints_common common;
 };
 
+struct xdp_hints_ixgbe_timestamp {
+	u64 rx_timestamp;
+	struct xdp_hints_ixgbe base;
+};
+
+/* Extending xdp_hints_flags */
+enum xdp_hints_flags_driver {
+	HINT_FLAG_RX_TIMESTAMP = BIT(16),
+};
+
 u64 btf_id_xdp_hints_ixgbe;
+u64 btf_id_xdp_hints_ixgbe_timestamp;
 
 static const char ixgbe_overheat_msg[] = "Network adapter has been stopped because it has over heated. Restart the computer. If the problem persists, power off the system and replace the adapter";
 
@@ -1797,6 +1808,8 @@ static inline void ixgbe_process_xdp_hints(struct ixgbe_ring *ring,
 	u32 btf_id = btf_id_xdp_hints_ixgbe;
 	u32 btf_sz = sizeof(*xdp_hints);
 	u32 f1 = 0, f2, f3, f4, f5 = 0;
+	u32 flags = ring->q_vector->adapter->flags;
+	struct ixgbe_q_vector *q_vector = ring->q_vector;
 
 	if (!(ring->netdev->features & NETIF_F_XDP_HINTS)) {
 		xdp_buff_clear_hints_flags(xdp);
@@ -1810,6 +1823,25 @@ static inline void ixgbe_process_xdp_hints(struct ixgbe_ring *ring,
 	xdp_hints = xdp->data - btf_sz;
 	common = &xdp_hints->common;
 
+	if (q_vector && q_vector->adapter) {
+		if (unlikely(flags & IXGBE_FLAG_RX_HWTSTAMP_ENABLED)) {
+			u64 regval = 0, ns = 0;
+			struct xdp_hints_ixgbe_timestamp *hints;
+
+			regval = ixgbe_ptp_rx_hwtstamp_raw(q_vector->adapter);
+			if (regval) {
+				ns = ixgbe_ptp_convert_to_hwtstamp(q_vector->adapter, regval);
+				if (ns) {
+					btf_id = btf_id_xdp_hints_ixgbe_timestamp;
+					btf_sz = sizeof(*hints);
+					hints = xdp->data - btf_sz;
+					hints->rx_timestamp = ns_to_ktime(ns);
+					f1 = HINT_FLAG_RX_TIMESTAMP;
+				}
+			}
+		}
+	}
+
 	f2 = ixgbe_rx_hash_xdp(ring, rx_desc, xdp_hints, pkt_info);
 	f3 = ixgbe_rx_checksum_xdp(ring, rx_desc, xdp_hints, pkt_info);
 	f4 = xdp_hints_set_rxq(common, ring->queue_index);
@@ -11665,7 +11697,10 @@ static struct pci_driver ixgbe_driver = {
 
 static void ixgbe_this_module_btf_lookups(struct btf *btf)
 {
-	btf_id_xdp_hints_ixgbe = btf_get_module_btf_full_id(btf, "xdp_hints_ixgbe");
+	btf_id_xdp_hints_ixgbe = btf_get_module_btf_full_id(btf,
+							    "xdp_hints_ixgbe");
+	btf_id_xdp_hints_ixgbe_timestamp = btf_get_module_btf_full_id(btf,
+					      "xdp_hints_ixgbe_timestamp");
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c
index 9f06896a049b..561265b2816e 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c
@@ -379,11 +379,11 @@ static u64 ixgbe_ptp_read_82599(const struct cyclecounter *cc)
 /**
  * ixgbe_ptp_convert_to_hwtstamp - convert register value to hw timestamp
  * @adapter: private adapter structure
- * @hwtstamp: stack timestamp structure
  * @timestamp: unsigned 64bit system time value
  *
- * We need to convert the adapter's RX/TXSTMP registers into a hwtstamp value
- * which can be used by the stack's ptp functions.
+ * We need to convert the adapter's RX/TXSTMP registers into a ns value
+ * which can be converted later to a hwtstamp to be used by the stack's
+ * ptp functions.
  *
  * The lock is used to protect consistency of the cyclecounter and the SYSTIME
  * registers. However, it does not need to protect against the Rx or Tx
@@ -393,16 +393,13 @@ static u64 ixgbe_ptp_read_82599(const struct cyclecounter *cc)
  * In addition to the timestamp in hardware, some controllers need a software
  * overflow cyclecounter, and this function takes this into account as well.
  **/
-static void ixgbe_ptp_convert_to_hwtstamp(struct ixgbe_adapter *adapter,
-					  struct skb_shared_hwtstamps *hwtstamp,
-					  u64 timestamp)
+u64 ixgbe_ptp_convert_to_hwtstamp(struct ixgbe_adapter *adapter,
+				 u64 timestamp)
 {
 	unsigned long flags;
 	struct timespec64 systime;
 	u64 ns;
 
-	memset(hwtstamp, 0, sizeof(*hwtstamp));
-
 	switch (adapter->hw.mac.type) {
 	/* X550 and later hardware supposedly represent time using a seconds
 	 * and nanoseconds counter, instead of raw 64bits nanoseconds. We need
@@ -433,7 +430,7 @@ static void ixgbe_ptp_convert_to_hwtstamp(struct ixgbe_adapter *adapter,
 	ns = timecounter_cyc2time(&adapter->hw_tc, timestamp);
 	spin_unlock_irqrestore(&adapter->tmreg_lock, flags);
 
-	hwtstamp->hwtstamp = ns_to_ktime(ns);
+	return ns;
 }
 
 /**
@@ -820,11 +817,13 @@ static void ixgbe_ptp_tx_hwtstamp(struct ixgbe_adapter *adapter)
 	struct sk_buff *skb = adapter->ptp_tx_skb;
 	struct ixgbe_hw *hw = &adapter->hw;
 	struct skb_shared_hwtstamps shhwtstamps;
-	u64 regval = 0;
+	u64 regval = 0, ns = 0;
 
 	regval |= (u64)IXGBE_READ_REG(hw, IXGBE_TXSTMPL);
 	regval |= (u64)IXGBE_READ_REG(hw, IXGBE_TXSTMPH) << 32;
-	ixgbe_ptp_convert_to_hwtstamp(adapter, &shhwtstamps, regval);
+	ns = ixgbe_ptp_convert_to_hwtstamp(adapter, regval);
+	if (ns)
+		shhwtstamps.hwtstamp = ns_to_ktime(ns);
 
 	/* Handle cleanup of the ptp_tx_skb ourselves, and unlock the state
 	 * bit prior to notifying the stack via skb_tstamp_tx(). This prevents
@@ -892,6 +891,10 @@ void ixgbe_ptp_rx_pktstamp(struct ixgbe_q_vector *q_vector,
 			   struct sk_buff *skb)
 {
 	__le64 regval;
+	u64 ns = 0;
+	struct skb_shared_hwtstamps *hwtstamp = skb_hwtstamps(skb);
+
+	memset(hwtstamp, 0, sizeof(*hwtstamp));
 
 	/* copy the bits out of the skb, and then trim the skb length */
 	skb_copy_bits(skb, skb->len - IXGBE_TS_HDR_LEN, &regval,
@@ -904,8 +907,35 @@ void ixgbe_ptp_rx_pktstamp(struct ixgbe_q_vector *q_vector,
 	 * DWORD: N              N + 1      N + 2
 	 * Field: End of Packet  SYSTIMH    SYSTIML
 	 */
-	ixgbe_ptp_convert_to_hwtstamp(q_vector->adapter, skb_hwtstamps(skb),
-				      le64_to_cpu(regval));
+	ns = ixgbe_ptp_convert_to_hwtstamp(q_vector->adapter, le64_to_cpu(regval));
+	if (ns)
+		hwtstamp->hwtstamp = ns_to_ktime(ns);
+}
+
+/**
+ * ixgbe_ptp_rx_hwtstamp_raw - utility function which returns the RX time stamp
+ * @adapter: the private adapter struct
+ *
+ * If the timestamp is valid, we return the raw value, else return 0;
+ */
+u64 ixgbe_ptp_rx_hwtstamp_raw(struct ixgbe_adapter *adapter)
+{
+	struct ixgbe_hw *hw = &adapter->hw;
+	u32 tsyncrxctl;
+	u64 regval = 0;
+
+	/* Read the tsyncrxctl register afterwards in order to prevent taking an
+	 * I/O hit on every packet.
+	 */
+
+	tsyncrxctl = IXGBE_READ_REG(hw, IXGBE_TSYNCRXCTL);
+	if (!(tsyncrxctl & IXGBE_TSYNCRXCTL_VALID))
+		return 0;
+
+	regval |= (u64)IXGBE_READ_REG(hw, IXGBE_RXSTMPL);
+	regval |= (u64)IXGBE_READ_REG(hw, IXGBE_RXSTMPH) << 32;
+
+	return regval;
 }
 
 /**
@@ -921,29 +951,21 @@ void ixgbe_ptp_rx_rgtstamp(struct ixgbe_q_vector *q_vector,
 			   struct sk_buff *skb)
 {
 	struct ixgbe_adapter *adapter;
-	struct ixgbe_hw *hw;
-	u64 regval = 0;
-	u32 tsyncrxctl;
+	u64 regval = 0, ns = 0;
+	struct skb_shared_hwtstamps *hwtstamp = skb_hwtstamps(skb);
 
 	/* we cannot process timestamps on a ring without a q_vector */
 	if (!q_vector || !q_vector->adapter)
 		return;
 
+	memset(hwtstamp, 0, sizeof(*hwtstamp));
 	adapter = q_vector->adapter;
-	hw = &adapter->hw;
-
-	/* Read the tsyncrxctl register afterwards in order to prevent taking an
-	 * I/O hit on every packet.
-	 */
-
-	tsyncrxctl = IXGBE_READ_REG(hw, IXGBE_TSYNCRXCTL);
-	if (!(tsyncrxctl & IXGBE_TSYNCRXCTL_VALID))
-		return;
-
-	regval |= (u64)IXGBE_READ_REG(hw, IXGBE_RXSTMPL);
-	regval |= (u64)IXGBE_READ_REG(hw, IXGBE_RXSTMPH) << 32;
-
-	ixgbe_ptp_convert_to_hwtstamp(adapter, skb_hwtstamps(skb), regval);
+	regval = ixgbe_ptp_rx_hwtstamp_raw(adapter);
+	if (regval) {
+		ns = ixgbe_ptp_convert_to_hwtstamp(adapter, regval);
+		if (ns)
+			hwtstamp->hwtstamp = ns_to_ktime(ns);
+	}
 }
 
 /**



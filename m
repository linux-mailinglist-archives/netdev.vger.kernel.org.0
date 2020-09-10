Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D02E2650E7
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 22:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgIJUfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 16:35:48 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:60476 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726920AbgIJUd1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 16:33:27 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.61])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id A0A5360107;
        Thu, 10 Sep 2020 20:33:20 +0000 (UTC)
Received: from us4-mdac16-45.ut7.mdlocal (unknown [10.7.64.27])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 9E8598009E;
        Thu, 10 Sep 2020 20:33:20 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.35])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 18EAC80055;
        Thu, 10 Sep 2020 20:33:20 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id A2CBE480064;
        Thu, 10 Sep 2020 20:33:19 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 10 Sep
 2020 21:33:14 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 5/7] sfc: de-indirect TSO handling
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <6fbc3a86-0afd-6e6d-099b-fca9af48d019@solarflare.com>
Message-ID: <96677549-bc70-9785-aab5-b55dd15ecef6@solarflare.com>
Date:   Thu, 10 Sep 2020 21:33:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <6fbc3a86-0afd-6e6d-099b-fca9af48d019@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25656.007
X-TM-AS-Result: No-5.952700-8.000000-10
X-TMASE-MatchedRID: eBAZQZ0u5KsJYlnKZc0AV3YZxYoZm58FfLNHMurfykirZHMcVOhFSJVH
        MRn1pNBttIx1NoxidIe6ycC6cIxfI3ufZC0Pz+WkqJSK+HSPY+/pVMb1xnESMnAal2A1DQms849
        Fr+w36gZ8bO6hWfRWzo9CL1e45ag4cj8zE1EjtST805SSvoAPNzVfUuzvrtymjjTDjakSEVOAGe
        f937ZbdVadb8UC/PILWxZCKdO1VZM5hou9z/6pqSMJO6daqdyWghehpAfYfg/19nHg6IhoT2GT5
        Ylhr8moGj4FOMsRiz15vd/bSQqAUtWoHrqNjinbsJribvbshQ9n+sA9+u1YLajxqhyDxmYj7vfj
        HqfMw2JbsirVWJBmMXlmcMbBU7eTSgKCSr6uFpQdmrVHa4DGTL77CQtqlp13SgweX1yjoU+bf+N
        keF/rBlQYLb/010QRC/f/BNYzJS/1fjWzduyGVsGNvKPnBgOaD6NL4tGmXzWAeF8m0ZU5hHY2Ws
        QTo6ONqiZ5g+lHKlBnTEmxZdKIcHAe/yBs2gz+lTsGW3DmpUufWMucVYsOKNuykrHhg4PdJzloW
        WMvKh0oow6ahtHoYZYOMsINllLvFcUL/pOAHTKeAiCmPx4NwLTrdaH1ZWqC1kTfEkyaZdz6C0eP
        s7A07R/88i/oAaos+WMWhs6z0O/Kr5eCP3uQmH00kRpirKulmbBvX/7XTy0=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--5.952700-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25656.007
X-MDID: 1599770000-iXX3Gg3gR-ra
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the tx_queue->handle_tso function pointer, and just use
 tx_queue->tso_version to decide which function to call, thus removing
 an indirect call from the fast path.
In efx_mcdi_tx_init(), report back failure to obtain a TSOv2 context by
 setting tx_queue->tso_version to 0, which will cause the TX path to
 use the GSO-based fallback.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef10.c           | 35 +++++++++--------------
 drivers/net/ethernet/sfc/ef100_tx.c       |  3 +-
 drivers/net/ethernet/sfc/farch.c          |  2 ++
 drivers/net/ethernet/sfc/mcdi_functions.c |  6 ++--
 drivers/net/ethernet/sfc/mcdi_functions.h |  2 +-
 drivers/net/ethernet/sfc/net_driver.h     |  5 ----
 drivers/net/ethernet/sfc/nic.h            |  4 +++
 drivers/net/ethernet/sfc/tx.c             | 14 +++++++--
 drivers/net/ethernet/sfc/tx_common.c      |  6 +---
 9 files changed, 40 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 1c1bc0dec757..c6507d1f79fe 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -2175,9 +2175,8 @@ static inline void efx_ef10_push_tx_desc(struct efx_tx_queue *tx_queue,
 
 /* Add Firmware-Assisted TSO v2 option descriptors to a queue.
  */
-static int efx_ef10_tx_tso_desc(struct efx_tx_queue *tx_queue,
-				struct sk_buff *skb,
-				bool *data_mapped)
+int efx_ef10_tx_tso_desc(struct efx_tx_queue *tx_queue, struct sk_buff *skb,
+			 bool *data_mapped)
 {
 	struct efx_tx_buffer *buffer;
 	struct tcphdr *tcp;
@@ -2266,7 +2265,6 @@ static void efx_ef10_tx_init(struct efx_tx_queue *tx_queue)
 	struct efx_channel *channel = tx_queue->channel;
 	struct efx_nic *efx = tx_queue->efx;
 	struct efx_ef10_nic_data *nic_data;
-	bool tso_v2 = false;
 	efx_qword_t *txd;
 	int rc;
 
@@ -2289,15 +2287,18 @@ static void efx_ef10_tx_init(struct efx_tx_queue *tx_queue)
 	 * TSOv2 cannot be used with Hardware timestamping, and is never needed
 	 * for XDP tx.
 	 */
-	if ((csum_offload || inner_csum) && (nic_data->datapath_caps2 &
-			(1 << MC_CMD_GET_CAPABILITIES_V2_OUT_TX_TSO_V2_LBN)) &&
-	    !tx_queue->timestamping && !tx_queue->xdp_tx) {
-		tso_v2 = true;
-		netif_dbg(efx, hw, efx->net_dev, "Using TSOv2 for channel %u\n",
-				channel->channel);
+	if (efx_has_cap(efx, TX_TSO_V2)) {
+		if ((csum_offload || inner_csum) &&
+		    !tx_queue->timestamping && !tx_queue->xdp_tx) {
+			tx_queue->tso_version = 2;
+			netif_dbg(efx, hw, efx->net_dev, "Using TSOv2 for channel %u\n",
+				  channel->channel);
+		}
+	} else if (efx_has_cap(efx, TX_TSO)) {
+		tx_queue->tso_version = 1;
 	}
 
-	rc = efx_mcdi_tx_init(tx_queue, tso_v2);
+	rc = efx_mcdi_tx_init(tx_queue);
 	if (rc)
 		goto fail;
 
@@ -2315,20 +2316,12 @@ static void efx_ef10_tx_init(struct efx_tx_queue *tx_queue)
 			     ESF_DZ_TX_OPTION_TYPE,
 			     ESE_DZ_TX_OPTION_DESC_CRC_CSUM,
 			     ESF_DZ_TX_OPTION_UDP_TCP_CSUM, csum_offload,
-			     ESF_DZ_TX_OPTION_IP_CSUM, csum_offload && !tso_v2,
+			     ESF_DZ_TX_OPTION_IP_CSUM, csum_offload && tx_queue->tso_version != 2,
 			     ESF_DZ_TX_OPTION_INNER_UDP_TCP_CSUM, inner_csum,
-			     ESF_DZ_TX_OPTION_INNER_IP_CSUM, inner_csum && !tso_v2,
+			     ESF_DZ_TX_OPTION_INNER_IP_CSUM, inner_csum && tx_queue->tso_version != 2,
 			     ESF_DZ_TX_TIMESTAMP, tx_queue->timestamping);
 	tx_queue->write_count = 1;
 
-	if (tso_v2) {
-		tx_queue->handle_tso = efx_ef10_tx_tso_desc;
-		tx_queue->tso_version = 2;
-	} else if (nic_data->datapath_caps &
-			(1 << MC_CMD_GET_CAPABILITIES_OUT_TX_TSO_LBN)) {
-		tx_queue->tso_version = 1;
-	}
-
 	wmb();
 	efx_ef10_push_tx_desc(tx_queue, txd);
 
diff --git a/drivers/net/ethernet/sfc/ef100_tx.c b/drivers/net/ethernet/sfc/ef100_tx.c
index 078c7ec2a70e..272eb5ecb7e7 100644
--- a/drivers/net/ethernet/sfc/ef100_tx.c
+++ b/drivers/net/ethernet/sfc/ef100_tx.c
@@ -38,7 +38,8 @@ void ef100_tx_init(struct efx_tx_queue *tx_queue)
 				    tx_queue->channel->channel -
 				    tx_queue->efx->tx_channel_offset);
 
-	if (efx_mcdi_tx_init(tx_queue, false))
+	tx_queue->tso_version = 3;
+	if (efx_mcdi_tx_init(tx_queue))
 		netdev_WARN(tx_queue->efx->net_dev,
 			    "failed to initialise TXQ %d\n", tx_queue->queue);
 }
diff --git a/drivers/net/ethernet/sfc/farch.c b/drivers/net/ethernet/sfc/farch.c
index bb5c45a0291b..d75cf5ff5686 100644
--- a/drivers/net/ethernet/sfc/farch.c
+++ b/drivers/net/ethernet/sfc/farch.c
@@ -415,6 +415,8 @@ void efx_farch_tx_init(struct efx_tx_queue *tx_queue)
 			     FFE_BZ_TX_PACE_OFF :
 			     FFE_BZ_TX_PACE_RESERVED);
 	efx_writeo_table(efx, &reg, FR_BZ_TX_PACE_TBL, tx_queue->queue);
+
+	tx_queue->tso_version = 1;
 }
 
 static void efx_farch_flush_tx_queue(struct efx_tx_queue *tx_queue)
diff --git a/drivers/net/ethernet/sfc/mcdi_functions.c b/drivers/net/ethernet/sfc/mcdi_functions.c
index 58582a0a42e4..d3e6d8239f5c 100644
--- a/drivers/net/ethernet/sfc/mcdi_functions.c
+++ b/drivers/net/ethernet/sfc/mcdi_functions.c
@@ -160,7 +160,7 @@ void efx_mcdi_ev_fini(struct efx_channel *channel)
 			       outbuf, outlen, rc);
 }
 
-int efx_mcdi_tx_init(struct efx_tx_queue *tx_queue, bool tso_v2)
+int efx_mcdi_tx_init(struct efx_tx_queue *tx_queue)
 {
 	MCDI_DECLARE_BUF(inbuf, MC_CMD_INIT_TXQ_IN_LEN(EFX_MAX_DMAQ_SIZE * 8 /
 						       EFX_BUF_SIZE));
@@ -195,6 +195,8 @@ int efx_mcdi_tx_init(struct efx_tx_queue *tx_queue, bool tso_v2)
 	inlen = MC_CMD_INIT_TXQ_IN_LEN(entries);
 
 	do {
+		bool tso_v2 = tx_queue->tso_version == 2;
+
 		/* TSOv2 implies IP header checksum offload for TSO frames,
 		 * so we can safely disable IP header checksum offload for
 		 * everything else.  If we don't have TSOv2, then we have to
@@ -217,7 +219,7 @@ int efx_mcdi_tx_init(struct efx_tx_queue *tx_queue, bool tso_v2)
 					NULL, 0, NULL);
 		if (rc == -ENOSPC && tso_v2) {
 			/* Retry without TSOv2 if we're short on contexts. */
-			tso_v2 = false;
+			tx_queue->tso_version = 0;
 			netif_warn(efx, probe, efx->net_dev,
 				   "TSOv2 context not available to segment in "
 				   "hardware. TCP performance may be reduced.\n"
diff --git a/drivers/net/ethernet/sfc/mcdi_functions.h b/drivers/net/ethernet/sfc/mcdi_functions.h
index 687be8b00cd8..b0e2f53a0d9b 100644
--- a/drivers/net/ethernet/sfc/mcdi_functions.h
+++ b/drivers/net/ethernet/sfc/mcdi_functions.h
@@ -19,7 +19,7 @@ int efx_mcdi_ev_probe(struct efx_channel *channel);
 int efx_mcdi_ev_init(struct efx_channel *channel, bool v1_cut_thru, bool v2);
 void efx_mcdi_ev_remove(struct efx_channel *channel);
 void efx_mcdi_ev_fini(struct efx_channel *channel);
-int efx_mcdi_tx_init(struct efx_tx_queue *tx_queue, bool tso_v2);
+int efx_mcdi_tx_init(struct efx_tx_queue *tx_queue);
 void efx_mcdi_tx_remove(struct efx_tx_queue *tx_queue);
 void efx_mcdi_tx_fini(struct efx_tx_queue *tx_queue);
 int efx_mcdi_rx_probe(struct efx_rx_queue *rx_queue);
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index ed444e1274ae..ddcd1c46e3f3 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -208,8 +208,6 @@ struct efx_tx_buffer {
  * @initialised: Has hardware queue been initialised?
  * @timestamping: Is timestamping enabled for this channel?
  * @xdp_tx: Is this an XDP tx queue?
- * @handle_tso: TSO xmit preparation handler.  Sets up the TSO metadata and
- *	may also map tx data, depending on the nature of the TSO implementation.
  * @read_count: Current read pointer.
  *	This is the number of buffers that have been removed from both rings.
  * @old_write_count: The value of @write_count when last checked.
@@ -272,9 +270,6 @@ struct efx_tx_queue {
 	bool timestamping;
 	bool xdp_tx;
 
-	/* Function pointers used in the fast path. */
-	int (*handle_tso)(struct efx_tx_queue*, struct sk_buff*, bool *);
-
 	/* Members used mainly on the completion path */
 	unsigned int read_count ____cacheline_aligned_in_smp;
 	unsigned int old_write_count;
diff --git a/drivers/net/ethernet/sfc/nic.h b/drivers/net/ethernet/sfc/nic.h
index 724e2776b585..5c2fe3ce3f4d 100644
--- a/drivers/net/ethernet/sfc/nic.h
+++ b/drivers/net/ethernet/sfc/nic.h
@@ -297,6 +297,10 @@ struct efx_ef10_nic_data {
 	u64 licensed_features;
 };
 
+/* TSOv2 */
+int efx_ef10_tx_tso_desc(struct efx_tx_queue *tx_queue, struct sk_buff *skb,
+			 bool *data_mapped);
+
 int efx_init_sriov(void);
 void efx_fini_sriov(void);
 
diff --git a/drivers/net/ethernet/sfc/tx.c b/drivers/net/ethernet/sfc/tx.c
index c0a32da357c7..ab23c7b9edc8 100644
--- a/drivers/net/ethernet/sfc/tx.c
+++ b/drivers/net/ethernet/sfc/tx.c
@@ -338,8 +338,18 @@ netdev_tx_t __efx_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb
 	 * size limit.
 	 */
 	if (segments) {
-		EFX_WARN_ON_ONCE_PARANOID(!tx_queue->handle_tso);
-		rc = tx_queue->handle_tso(tx_queue, skb, &data_mapped);
+		switch (tx_queue->tso_version) {
+		case 1:
+			rc = efx_enqueue_skb_tso(tx_queue, skb, &data_mapped);
+			break;
+		case 2:
+			rc = efx_ef10_tx_tso_desc(tx_queue, skb, &data_mapped);
+			break;
+		case 0: /* No TSO on this queue, SW fallback needed */
+		default:
+			rc = -EINVAL;
+			break;
+		}
 		if (rc == -EINVAL) {
 			rc = efx_tx_tso_fallback(tx_queue, skb);
 			tx_queue->tso_fallbacks++;
diff --git a/drivers/net/ethernet/sfc/tx_common.c b/drivers/net/ethernet/sfc/tx_common.c
index 2feff2ead955..d530cde2b864 100644
--- a/drivers/net/ethernet/sfc/tx_common.c
+++ b/drivers/net/ethernet/sfc/tx_common.c
@@ -86,11 +86,7 @@ void efx_init_tx_queue(struct efx_tx_queue *tx_queue)
 	tx_queue->completed_timestamp_minor = 0;
 
 	tx_queue->xdp_tx = efx_channel_is_xdp_tx(tx_queue->channel);
-
-	/* Set up default function pointers. These may get replaced by
-	 * efx_nic_init_tx() based off NIC/queue capabilities.
-	 */
-	tx_queue->handle_tso = efx_enqueue_skb_tso;
+	tx_queue->tso_version = 0;
 
 	/* Set up TX descriptor ring */
 	efx_nic_init_tx(tx_queue);


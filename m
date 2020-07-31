Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C604123465E
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 14:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730217AbgGaM7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 08:59:52 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:39066 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728047AbgGaM7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 08:59:51 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.144])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 58988200A7;
        Fri, 31 Jul 2020 12:59:50 +0000 (UTC)
Received: from us4-mdac16-6.at1.mdlocal (unknown [10.110.49.173])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 56DC3800AD;
        Fri, 31 Jul 2020 12:59:50 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.107])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id EBD9140071;
        Fri, 31 Jul 2020 12:59:49 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 9C27C28007D;
        Fri, 31 Jul 2020 12:59:49 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 31 Jul
 2020 13:59:45 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v2 net-next 06/11] sfc_ef100: RX path for EF100
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <31de2e73-bce7-6c9d-0c20-49b32e2043cc@solarflare.com>
Message-ID: <728de6f3-e00f-9b5e-7ded-e916deb941d5@solarflare.com>
Date:   Fri, 31 Jul 2020 13:59:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <31de2e73-bce7-6c9d-0c20-49b32e2043cc@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25574.002
X-TM-AS-Result: No-9.649700-8.000000-10
X-TMASE-MatchedRID: jsC3uNckhg5bbYRuf3nrh7sHVDDM5xAPY3cVMXznYPTRLEyE6G4DRHIo
        zGa69omdrdoLblq9S5ra/g/NGTW3MkQ5RmwcmoWTPja3w1ExF8RrTWaGefu3pN2ZK+KmhWXnoPa
        dTHh6s4Jm+7XaDgjeNoEq7HkkaFaPQJPnjsQiDp/hYA5szVVSqF8Bc+5aepuPuWYx8s2K6Roi/X
        mIrdQH6GZlD6ST2D3TYP3RSkqq8Qi2eGGESuJjBwe06kQGFaIWPFYmvSWBwkDmWHHSYEnI8X0/G
        xbBOLivyOrHSvvEufhLpKNp55CpVRuwdhbbhxE7KrDHzH6zmUWqdpuEuCeGaAMADm5EdqKWZnl3
        8LxqzrNjcPggb4+QEyOV9MQlWbAI3GeXPTl+ditoUArKobkzYn607foZgOWyw1abgzWsDaYh4kR
        7OQaWzzyfkb82lbBVeYOOY0X+EzHcovkWyF5Bb33O3F/Nshx53YSaHlnZL83g9GtYPBPdS3t383
        1UTPgKp7V+pIANDRrL769VRxHRCvFiITrxW0AT/ccgt/EtX/19LQinZ4QefL6qvLNjDYTwmTDwp
        0zM3zoqtq5d3cxkNcjN9R1Av5RdLnvUYKYQ3yNPdMALbXkeRdkVOsZTBdCU2rOjeYNAY3U=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--9.649700-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25574.002
X-MDID: 1596200390-K9lO1IKtqg0F
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Includes RSS spreading.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef100_nic.c |  25 ++++-
 drivers/net/ethernet/sfc/ef100_rx.c  | 150 +++++++++++++++++++++++++--
 drivers/net/ethernet/sfc/ef100_rx.h  |   1 +
 3 files changed, 167 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 95221b829ec4..e299c62a5012 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -260,6 +260,10 @@ static int ef100_ev_process(struct efx_channel *channel, int quota)
 		ev_type = EFX_QWORD_FIELD(*p_event, ESF_GZ_E_TYPE);
 
 		switch (ev_type) {
+		case ESE_GZ_EF100_EV_RX_PKTS:
+			efx_ef100_ev_rx(channel, p_event);
+			++spent;
+			break;
 		case ESE_GZ_EF100_EV_MCDI:
 			efx_mcdi_process_event(channel, p_event);
 			break;
@@ -482,9 +486,10 @@ static unsigned int ef100_check_caps(const struct efx_nic *efx,
 
 /*	NIC level access functions
  */
-#define EF100_OFFLOAD_FEATURES	(NETIF_F_HW_CSUM |			\
+#define EF100_OFFLOAD_FEATURES	(NETIF_F_HW_CSUM | NETIF_F_RXCSUM |	\
 	NETIF_F_HIGHDMA | NETIF_F_SG | NETIF_F_FRAGLIST |		\
-	NETIF_F_TSO_ECN | NETIF_F_TSO_MANGLEID | NETIF_F_HW_VLAN_CTAG_TX)
+	NETIF_F_RXHASH | NETIF_F_RXFCS | NETIF_F_TSO_ECN | NETIF_F_RXALL | \
+	NETIF_F_TSO_MANGLEID | NETIF_F_HW_VLAN_CTAG_TX)
 
 const struct efx_nic_type ef100_pf_nic_type = {
 	.revision = EFX_REV_EF100,
@@ -540,6 +545,16 @@ const struct efx_nic_type ef100_pf_nic_type = {
 
 	.get_phys_port_id = efx_ef100_get_phys_port_id,
 
+	.rx_prefix_size = ESE_GZ_RX_PKT_PREFIX_LEN,
+	.rx_hash_offset = ESF_GZ_RX_PREFIX_RSS_HASH_LBN / 8,
+	.rx_ts_offset = ESF_GZ_RX_PREFIX_PARTIAL_TSTAMP_LBN / 8,
+	.rx_hash_key_size = 40,
+	.rx_pull_rss_config = efx_mcdi_rx_pull_rss_config,
+	.rx_push_rss_config = efx_mcdi_pf_rx_push_rss_config,
+	.rx_push_rss_context_config = efx_mcdi_rx_push_rss_context_config,
+	.rx_pull_rss_context_config = efx_mcdi_rx_pull_rss_context_config,
+	.rx_restore_rss_contexts = efx_mcdi_rx_restore_rss_contexts,
+
 	.reconfigure_mac = ef100_reconfigure_mac,
 
 	/* Per-type bar/size configuration not used on ef100. Location of
@@ -888,6 +903,12 @@ static int ef100_probe_main(struct efx_nic *efx)
 	if (rc)
 		goto fail;
 
+	netdev_rss_key_fill(efx->rss_context.rx_hash_key,
+			    sizeof(efx->rss_context.rx_hash_key));
+
+	/* Don't fail init if RSS setup doesn't work. */
+	efx_mcdi_push_default_indir_table(efx, efx->n_rx_channels);
+
 	rc = ef100_register_netdev(efx);
 	if (rc)
 		goto fail;
diff --git a/drivers/net/ethernet/sfc/ef100_rx.c b/drivers/net/ethernet/sfc/ef100_rx.c
index 4223a38f46d3..13ba1a4f66fc 100644
--- a/drivers/net/ethernet/sfc/ef100_rx.c
+++ b/drivers/net/ethernet/sfc/ef100_rx.c
@@ -12,20 +12,156 @@
 #include "ef100_rx.h"
 #include "rx_common.h"
 #include "efx.h"
+#include "nic_common.h"
+#include "mcdi_functions.h"
+#include "ef100_regs.h"
+#include "ef100_nic.h"
+#include "io.h"
 
-/* RX stubs */
+/* Get the value of a field in the RX prefix */
+#define PREFIX_OFFSET_W(_f)	(ESF_GZ_RX_PREFIX_ ## _f ## _LBN / 32)
+#define PREFIX_OFFSET_B(_f)	(ESF_GZ_RX_PREFIX_ ## _f ## _LBN % 32)
+#define PREFIX_WIDTH_MASK(_f)	((1UL << ESF_GZ_RX_PREFIX_ ## _f ## _WIDTH) - 1)
+#define PREFIX_WORD(_p, _f)	le32_to_cpu((__force __le32)(_p)[PREFIX_OFFSET_W(_f)])
+#define PREFIX_FIELD(_p, _f)	((PREFIX_WORD(_p, _f) >> PREFIX_OFFSET_B(_f)) & \
+				 PREFIX_WIDTH_MASK(_f))
 
-void ef100_rx_write(struct efx_rx_queue *rx_queue)
+#define ESF_GZ_RX_PREFIX_NT_OR_INNER_L3_CLASS_LBN	\
+		(ESF_GZ_RX_PREFIX_CLASS_LBN + ESF_GZ_RX_PREFIX_HCLASS_NT_OR_INNER_L3_CLASS_LBN)
+#define ESF_GZ_RX_PREFIX_NT_OR_INNER_L3_CLASS_WIDTH	\
+		ESF_GZ_RX_PREFIX_HCLASS_NT_OR_INNER_L3_CLASS_WIDTH
+
+static bool check_fcs(struct efx_channel *channel, u32 *prefix)
 {
+	u16 rxclass;
+	u8 l2status;
+
+	rxclass = le16_to_cpu((__force __le16)PREFIX_FIELD(prefix, CLASS));
+	l2status = PREFIX_FIELD(&rxclass, HCLASS_L2_STATUS);
+
+	if (likely(l2status == ESE_GZ_RH_HCLASS_L2_STATUS_OK))
+		/* Everything is ok */
+		return 0;
+
+	if (l2status == ESE_GZ_RH_HCLASS_L2_STATUS_FCS_ERR)
+		channel->n_rx_eth_crc_err++;
+	return 1;
 }
 
 void __ef100_rx_packet(struct efx_channel *channel)
 {
-	/* Stub.  No RX path yet.  Discard the buffer. */
-	struct efx_rx_buffer *rx_buf = efx_rx_buffer(&channel->rx_queue,
-						     channel->rx_pkt_index);
-	struct efx_rx_queue *rx_queue = efx_channel_get_rx_queue(channel);
+	struct efx_rx_buffer *rx_buf = efx_rx_buffer(&channel->rx_queue, channel->rx_pkt_index);
+	struct efx_nic *efx = channel->efx;
+	u8 *eh = efx_rx_buf_va(rx_buf);
+	__wsum csum = 0;
+	u32 *prefix;
+
+	prefix = (u32 *)(eh - ESE_GZ_RX_PKT_PREFIX_LEN);
+
+	if (check_fcs(channel, prefix) &&
+	    unlikely(!(efx->net_dev->features & NETIF_F_RXALL)))
+		goto out;
+
+	rx_buf->len = le16_to_cpu((__force __le16)PREFIX_FIELD(prefix, LENGTH));
+	if (rx_buf->len <= sizeof(struct ethhdr)) {
+		if (net_ratelimit())
+			netif_err(channel->efx, rx_err, channel->efx->net_dev,
+				  "RX packet too small (%d)\n", rx_buf->len);
+		++channel->n_rx_frm_trunc;
+		goto out;
+	}
+
+	if (likely(efx->net_dev->features & NETIF_F_RXCSUM)) {
+		if (PREFIX_FIELD(prefix, NT_OR_INNER_L3_CLASS) == 1) {
+			++channel->n_rx_ip_hdr_chksum_err;
+		} else {
+			u16 sum = be16_to_cpu((__force __be16)PREFIX_FIELD(prefix, CSUM_FRAME));
 
-	efx_free_rx_buffers(rx_queue, rx_buf, 1);
+			csum = (__force __wsum) sum;
+		}
+	}
+
+	if (channel->type->receive_skb) {
+		struct efx_rx_queue *rx_queue =
+			efx_channel_get_rx_queue(channel);
+
+		/* no support for special channels yet, so just discard */
+		WARN_ON_ONCE(1);
+		efx_free_rx_buffers(rx_queue, rx_buf, 1);
+		goto out;
+	}
+
+	efx_rx_packet_gro(channel, rx_buf, channel->rx_pkt_n_frags, eh, csum);
+
+out:
 	channel->rx_pkt_n_frags = 0;
 }
+
+static void ef100_rx_packet(struct efx_rx_queue *rx_queue, unsigned int index)
+{
+	struct efx_rx_buffer *rx_buf = efx_rx_buffer(rx_queue, index);
+	struct efx_channel *channel = efx_rx_queue_channel(rx_queue);
+	struct efx_nic *efx = rx_queue->efx;
+
+	++rx_queue->rx_packets;
+
+	netif_vdbg(efx, rx_status, efx->net_dev,
+		   "RX queue %d received id %x\n",
+		   efx_rx_queue_index(rx_queue), index);
+
+	efx_sync_rx_buffer(efx, rx_buf, efx->rx_dma_len);
+
+	prefetch(efx_rx_buf_va(rx_buf));
+
+	rx_buf->page_offset += efx->rx_prefix_size;
+
+	efx_recycle_rx_pages(channel, rx_buf, 1);
+
+	efx_rx_flush_packet(channel);
+	channel->rx_pkt_n_frags = 1;
+	channel->rx_pkt_index = index;
+}
+
+void efx_ef100_ev_rx(struct efx_channel *channel, const efx_qword_t *p_event)
+{
+	struct efx_rx_queue *rx_queue = efx_channel_get_rx_queue(channel);
+	unsigned int n_packets =
+		EFX_QWORD_FIELD(*p_event, ESF_GZ_EV_RXPKTS_NUM_PKT);
+	int i;
+
+	WARN_ON_ONCE(!n_packets);
+	if (n_packets > 1)
+		++channel->n_rx_merge_events;
+
+	channel->irq_mod_score += 2 * n_packets;
+
+	for (i = 0; i < n_packets; ++i) {
+		ef100_rx_packet(rx_queue,
+				rx_queue->removed_count & rx_queue->ptr_mask);
+		++rx_queue->removed_count;
+	}
+}
+
+void ef100_rx_write(struct efx_rx_queue *rx_queue)
+{
+	struct efx_rx_buffer *rx_buf;
+	unsigned int idx;
+	efx_qword_t *rxd;
+	efx_dword_t rxdb;
+
+	while (rx_queue->notified_count != rx_queue->added_count) {
+		idx = rx_queue->notified_count & rx_queue->ptr_mask;
+		rx_buf = efx_rx_buffer(rx_queue, idx);
+		rxd = efx_rx_desc(rx_queue, idx);
+
+		EFX_POPULATE_QWORD_1(*rxd, ESF_GZ_RX_BUF_ADDR, rx_buf->dma_addr);
+
+		++rx_queue->notified_count;
+	}
+
+	wmb();
+	EFX_POPULATE_DWORD_1(rxdb, ERF_GZ_RX_RING_PIDX,
+			     rx_queue->added_count & rx_queue->ptr_mask);
+	efx_writed_page(rx_queue->efx, &rxdb,
+			ER_GZ_RX_RING_DOORBELL, efx_rx_queue_index(rx_queue));
+}
diff --git a/drivers/net/ethernet/sfc/ef100_rx.h b/drivers/net/ethernet/sfc/ef100_rx.h
index b5dadf741aa0..f2f266863966 100644
--- a/drivers/net/ethernet/sfc/ef100_rx.h
+++ b/drivers/net/ethernet/sfc/ef100_rx.h
@@ -14,6 +14,7 @@
 
 #include "net_driver.h"
 
+void efx_ef100_ev_rx(struct efx_channel *channel, const efx_qword_t *p_event);
 void ef100_rx_write(struct efx_rx_queue *rx_queue);
 void __ef100_rx_packet(struct efx_channel *channel);
 


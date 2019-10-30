Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1E17E9A64
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 11:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbfJ3KwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 06:52:14 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:56516 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726096AbfJ3KwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 06:52:14 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us5.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id E53344005C;
        Wed, 30 Oct 2019 10:52:12 +0000 (UTC)
Received: from cim-opti7060.uk.solarflarecom.com (10.17.20.154) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 30 Oct 2019 10:52:08 +0000
From:   Charles McLachlan <cmclachlan@solarflare.com>
Subject: [PATCH net-next v3 5/6] sfc: handle XDP_TX outcomes of XDP eBPF
 programs
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-net-drivers@solarflare.com>,
        <brouer@redhat.com>
References: <515c107e-cecb-869a-6c84-1f3c1bd3afce@solarflare.com>
Message-ID: <40f6e6c0-843a-e43b-a136-8ec1979a32e3@solarflare.com>
Date:   Wed, 30 Oct 2019 10:52:04 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <515c107e-cecb-869a-6c84-1f3c1bd3afce@solarflare.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.154]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25010.003
X-TM-AS-Result: No-4.108500-8.000000-10
X-TMASE-MatchedRID: p6Q7Lt59PFFG7jIPw/RhEDIjK23O9D33eouvej40T4gd0WOKRkwsh7Eg
        H/blGj35SjVIFO5E44DS/BAcn1sAYixppiUy9o4cA9lly13c/gFnAst8At+c3Z6fSoF3Lt+MQJC
        P6H73A+R9GsbEnvsBUmKW2rd6XT7zEvz3DwzD8N5FeAr5guIYJjVfUuzvrtymC/U4++8MvOwldt
        eCTiP2/BHEiFrpCvk4akCZKv4hI4L6qw+iIjFLzcebIMlISwjb+eBf9ovw8I0UE18jzz932vN+o
        A4oIb1d8uL7RZR2sf43ubgJEh2IPQq3zii05Ahqyf21YeIsPYYKJM4okvH5XoQdV351cqzPiZsl
        gYzLMZC61sKcsbQEeBAhCQ8O3xtvSqSDOjH8JBosisyWO3dp25wE50C6MzyIJLfQYoCQHFZ5w8z
        +NqS50VrutSJtmmUmx+hXB6JkqGjHO8eAxCOj9qubsOtSWY2QkZOl7WKIImpvmJzqtHKHjwtuKB
        GekqUpOlxBO2IcOBboYsA9rrFyz/scTLWLAR9xBimSUcqhJcIOCduab9efDskS2KppaX2NAyHMU
        ORHJ8KaWw+cKCBOrCnmEsMltFPUg5rBSfi5GcEXxY6mau8LG3IJh4dBcU42f4hpTpoBF9JqxGCS
        zFD9Mq9DVtyhkQKh
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--4.108500-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25010.003
X-MDID: 1572432733-AjaBI5E-siro
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Provide an ndo_xdp_xmit function that uses the XDP tx queue for this
CPU to send the packet.

Signed-off-by: Charles McLachlan <cmclachlan@solarflare.com>
---
 drivers/net/ethernet/sfc/efx.c | 14 +++++++
 drivers/net/ethernet/sfc/efx.h |  3 ++
 drivers/net/ethernet/sfc/rx.c  | 12 +++++-
 drivers/net/ethernet/sfc/tx.c  | 70 ++++++++++++++++++++++++++++++++++
 4 files changed, 98 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 10c9b1ede799..0fa9972027db 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -228,6 +228,8 @@ static void efx_start_all(struct efx_nic *efx);
 static void efx_stop_all(struct efx_nic *efx);
 static int efx_xdp_setup_prog(struct efx_nic *efx, struct bpf_prog *prog);
 static int efx_xdp(struct net_device *dev, struct netdev_bpf *xdp);
+static int efx_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **xdpfs,
+			u32 flags);
 
 #define EFX_ASSERT_RESET_SERIALISED(efx)		\
 	do {						\
@@ -2633,6 +2635,7 @@ static const struct net_device_ops efx_netdev_ops = {
 #endif
 	.ndo_udp_tunnel_add	= efx_udp_tunnel_add,
 	.ndo_udp_tunnel_del	= efx_udp_tunnel_del,
+	.ndo_xdp_xmit		= efx_xdp_xmit,
 	.ndo_bpf		= efx_xdp
 };
 
@@ -2680,6 +2683,17 @@ static int efx_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 	}
 }
 
+static int efx_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **xdpfs,
+			u32 flags)
+{
+	struct efx_nic *efx = netdev_priv(dev);
+
+	if (!netif_running(dev))
+		return -EINVAL;
+
+	return efx_xdp_tx_buffers(efx, n, xdpfs, flags & XDP_XMIT_FLUSH);
+}
+
 static void efx_update_name(struct efx_nic *efx)
 {
 	strcpy(efx->name, efx->net_dev->name);
diff --git a/drivers/net/ethernet/sfc/efx.h b/drivers/net/ethernet/sfc/efx.h
index 04fed7c06618..45c7ae4114ec 100644
--- a/drivers/net/ethernet/sfc/efx.h
+++ b/drivers/net/ethernet/sfc/efx.h
@@ -322,4 +322,7 @@ static inline bool efx_rwsem_assert_write_locked(struct rw_semaphore *sem)
 	return true;
 }
 
+int efx_xdp_tx_buffers(struct efx_nic *efx, int n, struct xdp_frame **xdpfs,
+		       bool flush);
+
 #endif /* EFX_EFX_H */
diff --git a/drivers/net/ethernet/sfc/rx.c b/drivers/net/ethernet/sfc/rx.c
index 644d157843c6..91f6d5b9ceac 100644
--- a/drivers/net/ethernet/sfc/rx.c
+++ b/drivers/net/ethernet/sfc/rx.c
@@ -653,6 +653,7 @@ static bool efx_do_xdp(struct efx_nic *efx, struct efx_channel *channel,
 	u8 rx_prefix[EFX_MAX_RX_PREFIX_SIZE];
 	struct efx_rx_queue *rx_queue;
 	struct bpf_prog *xdp_prog;
+	struct xdp_frame *xdpf;
 	struct xdp_buff xdp;
 	u32 xdp_act;
 	s16 offset;
@@ -713,7 +714,16 @@ static bool efx_do_xdp(struct efx_nic *efx, struct efx_channel *channel,
 		break;
 
 	case XDP_TX:
-		return -EOPNOTSUPP;
+		/* Buffer ownership passes to tx on success. */
+		xdpf = convert_to_xdp_frame(&xdp);
+		err = efx_xdp_tx_buffers(efx, 1, &xdpf, true);
+		if (unlikely(err != 1)) {
+			efx_free_rx_buffers(rx_queue, rx_buf, 1);
+			if (net_ratelimit())
+				netif_err(efx, rx_err, efx->net_dev,
+					  "XDP TX failed (%d)\n", err);
+		}
+		break;
 
 	case XDP_REDIRECT:
 		err = xdp_do_redirect(efx->net_dev, &xdp, xdp_prog);
diff --git a/drivers/net/ethernet/sfc/tx.c b/drivers/net/ethernet/sfc/tx.c
index 8a5bc500d2a1..08f093168696 100644
--- a/drivers/net/ethernet/sfc/tx.c
+++ b/drivers/net/ethernet/sfc/tx.c
@@ -599,6 +599,76 @@ netdev_tx_t efx_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb)
 	return NETDEV_TX_OK;
 }
 
+/* Transmit a packet from an XDP buffer
+ *
+ * Returns number of packets sent on success, error code otherwise.
+ * Runs in NAPI context, either in our poll (for XDP TX) or a different NIC
+ * (for XDP redirect).
+ */
+int efx_xdp_tx_buffers(struct efx_nic *efx, int n, struct xdp_frame **xdpfs,
+		       bool flush)
+{
+	struct efx_tx_buffer *tx_buffer;
+	struct efx_tx_queue *tx_queue;
+	struct xdp_frame *xdpf;
+	dma_addr_t dma_addr;
+	unsigned int len;
+	int space;
+	int cpu;
+	int i;
+
+	cpu = raw_smp_processor_id();
+
+	if (!efx->xdp_tx_queue_count ||
+	    unlikely(cpu >= efx->xdp_tx_queue_count))
+		return -EINVAL;
+
+	tx_queue = efx->xdp_tx_queues[cpu];
+	if (unlikely(!tx_queue))
+		return -EINVAL;
+
+	if (n && xdpfs) {
+		/* Check for available space. We should never need multiple
+		 * descriptors per frame.
+		 */
+		space = efx->txq_entries +
+			tx_queue->read_count - tx_queue->insert_count;
+		n = min(n, space);
+
+		for (i = 0; i < n; i++) {
+			xdpf = xdpfs[i];
+
+			/* We'll want a descriptor for this tx. */
+			prefetchw(__efx_tx_queue_get_insert_buffer(tx_queue));
+
+			len = xdpf->len;
+
+			/* Map for DMA. */
+			dma_addr = dma_map_single(&efx->pci_dev->dev,
+						  xdpf->data, len,
+						  DMA_TO_DEVICE);
+			if (dma_mapping_error(&efx->pci_dev->dev, dma_addr))
+				return -EIO;
+
+			/*  Create descriptor and set up for unmapping DMA. */
+			tx_buffer = efx_tx_map_chunk(tx_queue, dma_addr, len);
+			tx_buffer->xdpf = xdpf;
+			tx_buffer->flags = EFX_TX_BUF_XDP |
+					   EFX_TX_BUF_MAP_SINGLE;
+			tx_buffer->dma_offset = 0;
+			tx_buffer->unmap_len = len;
+		}
+	}
+
+	/* Pass to hardware. */
+	if (flush)
+		efx_nic_push_buffers(tx_queue);
+
+	tx_queue->tx_packets += n;
+
+	return n;
+}
+
 /* Remove packets from the TX queue
  *
  * This removes packets from the TX queue, up to and including the

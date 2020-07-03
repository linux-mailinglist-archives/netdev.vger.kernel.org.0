Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3AB213C9C
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 17:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbgGCPdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 11:33:41 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:39934 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726098AbgGCPdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 11:33:41 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.144])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id E283B20092;
        Fri,  3 Jul 2020 15:33:39 +0000 (UTC)
Received: from us4-mdac16-8.at1.mdlocal (unknown [10.110.49.190])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id E12FE800A4;
        Fri,  3 Jul 2020 15:33:39 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.8])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 70A2D40076;
        Fri,  3 Jul 2020 15:33:39 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 22F844C0064;
        Fri,  3 Jul 2020 15:33:39 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 3 Jul 2020
 16:33:34 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 08/15] sfc_ef100: implement ndo_open/close and EVQ
 probing
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <14d4694e-2493-abd3-b76e-09e38a01b588@solarflare.com>
Message-ID: <1cd48042-e6f4-6360-b873-d1217a3b311d@solarflare.com>
Date:   Fri, 3 Jul 2020 16:33:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <14d4694e-2493-abd3-b76e-09e38a01b588@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25518.003
X-TM-AS-Result: No-4.521000-8.000000-10
X-TMASE-MatchedRID: mhQ/o2twg+WzOUo0GrIWtD42t8NRMRfEBGvINcfHqhdLxCuBTCXaKnIw
        ECVgOanik2e/QFg32epTvVffeIwvQwUcfW/oedmqR/j040fRFpI/pOSL72dTfwdkFovAReUoaUX
        s6FguVy0GOdbFG3K/WSOnFEna2UPAl0x0e7YEDxrVHEmXVZHbc27BSyDZmAnxI0YrtQLsSUy8c0
        7ZV9N0ms9C3Lx6G+XHhevXsGDRFc0DXxxrpqrIH0V3YrpGUAoBovA/6ONsv0r5niUX8JbmBqSWt
        /+pQgb3zKDP/RWMDCBfpDE3h+Imb4E9rcJqQjkECWlWR223da4KJM4okvH5XgmZ1fM6EQx2fjcd
        X7WMS/BO5gaRckOLyM0CjKwcYFKxOlcsoX/uQ8gyIyttzvQ99/G6GRFYrbYYjY/BvSuEqb1+Dha
        0AlenCWKdY6fZcmVLGx4QOjd5HXVTFeo7QUTJGzKVTrGMDe/Dr3861brRCuZD9iPiuXvzgeBqQW
        Y7iyEe5pXRYS59WA4b3X3enKWZZWJLZpMvEKgwqjZ865FPtprDAPSbMWlGt+y9vsxhLmzeJ+BT0
        Y87CsYZ0sBcvHJB7zrxF++aeXQh3JpU1WTKccMwjFu8zcBWiPIK8gK4rjpyMv8YehqjR1XHK3DB
        P8Kopy5Em+WXAMLRfvhl4GJRMwE9p4lO1ns7qMeuFL5UpINxSWg+u4ir2NOeIlqDXRGu66PFjJE
        Fr+olA9Mriq0CDAg9wJeM2pSaRVgXepbcl7r7stAEYMTJcjWDWWfY+u20OwxYAQdxsKRIcdJjF+
        p3kTIDnzkEOSl+T5h0LEjrEtf5HS+uOGYFOOHlgWzPuIVYqpskyeHmlMngMcKpXuu/1jVAMwW4r
        Y/0WO2hZq8RbsdETdnyMokJ1HTiaosWHm9+bH7cGd19dSFd
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--4.521000-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25518.003
X-MDID: 1593790419-aNYDFDezRf_p
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Channels are probed, but actual event handling is still stubbed out.

Stub implementation of check_caps is needed because ptp.c will call into
 it from efx_ptp_use_mac_tx_timestamps() to decide if it wants TXQs.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef100_netdev.c | 143 ++++++++++++++++++++++++
 drivers/net/ethernet/sfc/ef100_nic.c    |  49 ++++++++
 drivers/net/ethernet/sfc/ef100_nic.h    |   1 +
 drivers/net/ethernet/sfc/ef100_rx.c     |   6 +
 drivers/net/ethernet/sfc/ef100_rx.h     |   2 +
 drivers/net/ethernet/sfc/ef100_tx.c     |  19 ++++
 drivers/net/ethernet/sfc/ef100_tx.h     |   4 +
 7 files changed, 224 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
index 356938104cb2..3e4e7241d9a8 100644
--- a/drivers/net/ethernet/sfc/ef100_netdev.c
+++ b/drivers/net/ethernet/sfc/ef100_netdev.c
@@ -35,6 +35,147 @@ static void ef100_update_name(struct efx_nic *efx)
 	strcpy(efx->name, efx->net_dev->name);
 }
 
+static int ef100_alloc_vis(struct efx_nic *efx, unsigned int *allocated_vis)
+{
+	/* EF100 uses a single TXQ per channel, as all checksum offloading
+	 * is configured in the TX descriptor, and there is no TX Pacer for
+	 * HIGHPRI queues.
+	 */
+	unsigned int tx_vis = efx->n_tx_channels + efx->n_extra_tx_channels;
+	unsigned int rx_vis = efx->n_rx_channels;
+	unsigned int min_vis, max_vis;
+
+	EFX_WARN_ON_PARANOID(efx->tx_queues_per_channel != 1);
+
+	tx_vis += efx->n_xdp_channels * efx->xdp_tx_per_channel;
+
+	max_vis = max(rx_vis, tx_vis);
+	/* Currently don't handle resource starvation and only accept
+	 * our maximum needs and no less.
+	 */
+	min_vis = max_vis;
+
+	return efx_mcdi_alloc_vis(efx, min_vis, max_vis,
+				  NULL, allocated_vis);
+}
+
+static int ef100_remap_bar(struct efx_nic *efx, int max_vis)
+{
+	unsigned int uc_mem_map_size;
+	void __iomem *membase;
+
+	efx->max_vis = max_vis;
+	uc_mem_map_size = PAGE_ALIGN(max_vis * efx->vi_stride);
+
+	/* Extend the original UC mapping of the memory BAR */
+	membase = ioremap(efx->membase_phys, uc_mem_map_size);
+	if (!membase) {
+		netif_err(efx, probe, efx->net_dev,
+			  "could not extend memory BAR to %x\n",
+			  uc_mem_map_size);
+		return -ENOMEM;
+	}
+	iounmap(efx->membase);
+	efx->membase = membase;
+	return 0;
+}
+
+/* Context: process, rtnl_lock() held.
+ * Note that the kernel will ignore our return code; this method
+ * should really be a void.
+ */
+static int ef100_net_stop(struct net_device *net_dev)
+{
+	struct efx_nic *efx = netdev_priv(net_dev);
+
+	netif_dbg(efx, ifdown, efx->net_dev, "closing on CPU %d\n",
+		  raw_smp_processor_id());
+
+	netif_stop_queue(net_dev);
+	efx_stop_all(efx);
+	efx_disable_interrupts(efx);
+	efx_clear_interrupt_affinity(efx);
+	efx_nic_fini_interrupt(efx);
+	efx_fini_napi(efx);
+	efx_remove_channels(efx);
+	efx_mcdi_free_vis(efx);
+	efx_remove_interrupts(efx);
+
+	return 0;
+}
+
+/* Context: process, rtnl_lock() held. */
+static int ef100_net_open(struct net_device *net_dev)
+{
+	struct efx_nic *efx = netdev_priv(net_dev);
+	unsigned int allocated_vis;
+	int rc;
+
+	ef100_update_name(efx);
+	netif_dbg(efx, ifup, net_dev, "opening device on CPU %d\n",
+		  raw_smp_processor_id());
+
+	rc = efx_check_disabled(efx);
+	if (rc)
+		goto fail;
+
+	rc = efx_probe_interrupts(efx);
+	if (rc)
+		goto fail;
+
+	rc = efx_set_channels(efx);
+	if (rc)
+		goto fail;
+
+	rc = efx_mcdi_free_vis(efx);
+	if (rc)
+		goto fail;
+
+	rc = ef100_alloc_vis(efx, &allocated_vis);
+	if (rc)
+		goto fail;
+
+	rc = efx_probe_channels(efx);
+	if (rc)
+		return rc;
+
+	rc = ef100_remap_bar(efx, allocated_vis);
+	if (rc)
+		goto fail;
+
+	efx_init_napi(efx);
+
+	rc = efx_nic_init_interrupt(efx);
+	if (rc)
+		goto fail;
+	efx_set_interrupt_affinity(efx);
+
+	rc = efx_enable_interrupts(efx);
+	if (rc)
+		goto fail;
+
+	/* in case the MC rebooted while we were stopped, consume the change
+	 * to the warm reboot count
+	 */
+	(void) efx_mcdi_poll_reboot(efx);
+
+	efx_start_all(efx);
+
+	/* Link state detection is normally event-driven; we have
+	 * to poll now because we could have missed a change
+	 */
+	mutex_lock(&efx->mac_lock);
+	if (efx_mcdi_phy_poll(efx))
+		efx_link_status_changed(efx);
+	mutex_unlock(&efx->mac_lock);
+
+	return 0;
+
+fail:
+	ef100_net_stop(net_dev);
+	return rc;
+}
+
 /* Initiate a packet transmission.  We use one channel per CPU
  * (sharing when we have more CPUs than channels).
  *
@@ -70,6 +211,8 @@ netdev_tx_t ef100_hard_start_xmit(struct sk_buff *skb,
 }
 
 static const struct net_device_ops ef100_netdev_ops = {
+	.ndo_open               = ef100_net_open,
+	.ndo_stop               = ef100_net_stop,
 	.ndo_start_xmit         = ef100_hard_start_xmit,
 };
 
diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 57e56a3f9b14..f62f3be1238b 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -135,9 +135,37 @@ static int ef100_ev_probe(struct efx_channel *channel)
 				    GFP_KERNEL);
 }
 
+static int ef100_ev_init(struct efx_channel *channel)
+{
+	struct ef100_nic_data *nic_data = channel->efx->nic_data;
+
+	/* initial phase is 0 */
+	clear_bit(channel->channel, nic_data->evq_phases);
+
+	return efx_mcdi_ev_init(channel, false, false);
+}
+
+static void ef100_ev_read_ack(struct efx_channel *channel)
+{
+	efx_dword_t evq_prime;
+
+	EFX_POPULATE_DWORD_2(evq_prime,
+			     ERF_GZ_EVQ_ID, channel->channel,
+			     ERF_GZ_IDX, channel->eventq_read_ptr &
+					 channel->eventq_mask);
+
+	efx_writed(channel->efx, &evq_prime,
+		   efx_reg(channel->efx, ER_GZ_EVQ_INT_PRIME));
+}
+
 /* efx_mcdi_process_event() may call this */
 void efx_mcdi_sensor_event(struct efx_nic *efx, efx_qword_t *ev) {}
 
+static int ef100_ev_process(struct efx_channel *channel, int quota)
+{
+	return 0;
+}
+
 static irqreturn_t ef100_msi_interrupt(int irq, void *dev_id)
 {
 	struct efx_msi_context *context = dev_id;
@@ -213,6 +241,13 @@ static int ef100_reset(struct efx_nic *efx, enum reset_type reset_type)
 	return rc;
 }
 
+static unsigned int ef100_check_caps(const struct efx_nic *efx,
+				     u8 flag, u32 offset)
+{
+	/* stub */
+	return 0;
+}
+
 /*	NIC level access functions
  */
 const struct efx_nic_type ef100_pf_nic_type = {
@@ -233,8 +268,22 @@ const struct efx_nic_type ef100_pf_nic_type = {
 	.map_reset_flags = ef100_map_reset_flags,
 	.reset = ef100_reset,
 
+	.check_caps = ef100_check_caps,
+
 	.ev_probe = ef100_ev_probe,
+	.ev_init = ef100_ev_init,
+	.ev_fini = efx_mcdi_ev_fini,
+	.ev_remove = efx_mcdi_ev_remove,
 	.irq_handle_msi = ef100_msi_interrupt,
+	.ev_process = ef100_ev_process,
+	.ev_read_ack = ef100_ev_read_ack,
+	.tx_probe = ef100_tx_probe,
+	.tx_init = ef100_tx_init,
+	.tx_write = ef100_tx_write,
+	.rx_probe = efx_mcdi_rx_probe,
+	.rx_init = efx_mcdi_rx_init,
+	.rx_remove = efx_mcdi_rx_remove,
+	.rx_write = ef100_rx_write,
 
 	/* Per-type bar/size configuration not used on ef100. Location of
 	 * registers is defined by extended capabilities.
diff --git a/drivers/net/ethernet/sfc/ef100_nic.h b/drivers/net/ethernet/sfc/ef100_nic.h
index a4290d183879..5d376e2d98a7 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.h
+++ b/drivers/net/ethernet/sfc/ef100_nic.h
@@ -21,6 +21,7 @@ struct ef100_nic_data {
 	struct efx_nic *efx;
 	struct efx_buffer mcdi_buf;
 	u16 warm_boot_count;
+	DECLARE_BITMAP(evq_phases, EFX_MAX_CHANNELS);
 };
 
 #define efx_ef100_has_cap(caps, flag) \
diff --git a/drivers/net/ethernet/sfc/ef100_rx.c b/drivers/net/ethernet/sfc/ef100_rx.c
index f06aa302e9c9..75d0e32a5871 100644
--- a/drivers/net/ethernet/sfc/ef100_rx.c
+++ b/drivers/net/ethernet/sfc/ef100_rx.c
@@ -22,3 +22,9 @@ void __efx_rx_packet(struct efx_channel *channel)
 	efx_free_rx_buffers(rx_queue, rx_buf, 1);
 	channel->rx_pkt_n_frags = 0;
 }
+
+/* RX stubs */
+
+void ef100_rx_write(struct efx_rx_queue *rx_queue)
+{
+}
diff --git a/drivers/net/ethernet/sfc/ef100_rx.h b/drivers/net/ethernet/sfc/ef100_rx.h
index 9de9c2ab9014..22222e2769fa 100644
--- a/drivers/net/ethernet/sfc/ef100_rx.h
+++ b/drivers/net/ethernet/sfc/ef100_rx.h
@@ -14,4 +14,6 @@
 
 #include "net_driver.h"
 
+void ef100_rx_write(struct efx_rx_queue *rx_queue);
+
 #endif
diff --git a/drivers/net/ethernet/sfc/ef100_tx.c b/drivers/net/ethernet/sfc/ef100_tx.c
index 0272f99b3115..daf5069e5d34 100644
--- a/drivers/net/ethernet/sfc/ef100_tx.c
+++ b/drivers/net/ethernet/sfc/ef100_tx.c
@@ -13,6 +13,25 @@
 #include "tx_common.h"
 #include "ef100_tx.h"
 
+/* TX queue stubs */
+int ef100_tx_probe(struct efx_tx_queue *tx_queue)
+{
+	return 0;
+}
+
+void ef100_tx_init(struct efx_tx_queue *tx_queue)
+{
+	/* must be the inverse of lookup in efx_get_tx_channel */
+	tx_queue->core_txq =
+		netdev_get_tx_queue(tx_queue->efx->net_dev,
+				    tx_queue->channel->channel -
+				    tx_queue->efx->tx_channel_offset);
+}
+
+void ef100_tx_write(struct efx_tx_queue *tx_queue)
+{
+}
+
 int efx_enqueue_skb_tso(struct efx_tx_queue *tx_queue, struct sk_buff *skb,
 			bool *data_mapped)
 {
diff --git a/drivers/net/ethernet/sfc/ef100_tx.h b/drivers/net/ethernet/sfc/ef100_tx.h
index dedfed5d3e53..9514edc4fb7f 100644
--- a/drivers/net/ethernet/sfc/ef100_tx.h
+++ b/drivers/net/ethernet/sfc/ef100_tx.h
@@ -14,5 +14,9 @@
 
 #include "net_driver.h"
 
+int ef100_tx_probe(struct efx_tx_queue *tx_queue);
+void ef100_tx_init(struct efx_tx_queue *tx_queue);
+void ef100_tx_write(struct efx_tx_queue *tx_queue);
+
 int efx_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb);
 #endif


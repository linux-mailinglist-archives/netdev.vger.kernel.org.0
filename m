Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09A6D65DD07
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 20:42:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240221AbjADTmI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 14:42:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240212AbjADTlq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 14:41:46 -0500
Received: from mx14lb.world4you.com (mx14lb.world4you.com [81.19.149.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 443A3184
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 11:41:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=lJ2ZlxJGyZmUhOteasDY9uOq610soQL5WVsSTT9mtUM=; b=aAijDuyk4UZzqsgedNPgpuleep
        K03rTLlE7vKzPIje7UuF0C0eARU4MQs6ZjzgHLi7GKeU2vc9Buow4qaO0uwSjtccOHdWc3TEz0d4v
        JedRnyX/jTjefOgEpgIg+0aE+9eAYwMcMswBm2liA7v4mSlbTQ+7wixXgtNMf73LvXw0=;
Received: from 88-117-53-17.adsl.highway.telekom.at ([88.117.53.17] helo=hornet.engleder.at)
        by mx14lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pD9dv-0003c2-LD; Wed, 04 Jan 2023 20:41:43 +0100
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v3 9/9] tsnep: Add XDP RX support
Date:   Wed,  4 Jan 2023 20:41:32 +0100
Message-Id: <20230104194132.24637-10-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230104194132.24637-1-gerhard@engleder-embedded.com>
References: <20230104194132.24637-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If BPF program is set up, then run BPF program for every received frame
and execute the selected action.

Test results with A53 1.2GHz:

XDP_DROP (samples/bpf/xdp1)
proto 17:     883878 pkt/s

XDP_TX (samples/bpf/xdp2)
proto 17:     255693 pkt/s

XDP_REDIRECT (samples/bpf/xdpsock)
 sock0@eth2:0 rxdrop xdp-drv
                   pps            pkts           1.00
rx                 855,582        5,404,523
tx                 0              0

XDP_REDIRECT (samples/bpf/xdp_redirect)
eth2->eth1         613,267 rx/s   0 err,drop/s   613,272 xmit/s

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/net/ethernet/engleder/tsnep_main.c | 129 ++++++++++++++++++++-
 1 file changed, 127 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index 6a30f3bf73a6..beafaa60a35d 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -27,6 +27,7 @@
 #include <linux/phy.h>
 #include <linux/iopoll.h>
 #include <linux/bpf.h>
+#include <linux/bpf_trace.h>
 
 #define TSNEP_SKB_PAD (NET_SKB_PAD + NET_IP_ALIGN)
 #define TSNEP_HEADROOM ALIGN(max(TSNEP_SKB_PAD, XDP_PACKET_HEADROOM), 4)
@@ -44,6 +45,9 @@
 #define TSNEP_COALESCE_USECS_MAX     ((ECM_INT_DELAY_MASK >> ECM_INT_DELAY_SHIFT) * \
 				      ECM_INT_DELAY_BASE_US + ECM_INT_DELAY_BASE_US - 1)
 
+#define TSNEP_XDP_TX		BIT(0)
+#define TSNEP_XDP_REDIRECT	BIT(1)
+
 enum {
 	__TSNEP_DOWN,
 };
@@ -624,6 +628,34 @@ static void tsnep_xdp_xmit_flush(struct tsnep_tx *tx)
 	iowrite32(TSNEP_CONTROL_TX_ENABLE, tx->addr + TSNEP_CONTROL);
 }
 
+static bool tsnep_xdp_xmit_back(struct tsnep_adapter *adapter,
+				struct xdp_buff *xdp)
+{
+	struct xdp_frame *xdpf = xdp_convert_buff_to_frame(xdp);
+	int cpu = smp_processor_id();
+	struct netdev_queue *nq;
+	int queue;
+	bool xmit;
+
+	if (unlikely(!xdpf))
+		return -EFAULT;
+
+	queue = cpu % adapter->num_tx_queues;
+	nq = netdev_get_tx_queue(adapter->netdev, queue);
+
+	__netif_tx_lock(nq, cpu);
+
+	/* Avoid transmit queue timeout since we share it with the slow path */
+	txq_trans_cond_update(nq);
+
+	xmit = tsnep_xdp_xmit_frame_ring(xdpf, &adapter->tx[queue],
+					 TSNEP_TX_TYPE_XDP_TX);
+
+	__netif_tx_unlock(nq);
+
+	return xmit;
+}
+
 static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
 {
 	struct tsnep_tx_entry *entry;
@@ -788,6 +820,11 @@ static unsigned int tsnep_rx_offset(struct tsnep_rx *rx)
 	return TSNEP_SKB_PAD;
 }
 
+static unsigned int tsnep_rx_offset_xdp(void)
+{
+	return XDP_PACKET_HEADROOM;
+}
+
 static void tsnep_rx_ring_cleanup(struct tsnep_rx *rx)
 {
 	struct device *dmadev = rx->adapter->dmadev;
@@ -993,6 +1030,67 @@ static int tsnep_rx_refill(struct tsnep_rx *rx, int count, bool reuse)
 	return i;
 }
 
+static bool tsnep_xdp_run_prog(struct tsnep_rx *rx, struct bpf_prog *prog,
+			       struct xdp_buff *xdp, int *status)
+{
+	unsigned int length;
+	unsigned int sync;
+	u32 act;
+
+	length = xdp->data_end - xdp->data_hard_start - tsnep_rx_offset_xdp();
+
+	act = bpf_prog_run_xdp(prog, xdp);
+
+	/* Due xdp_adjust_tail: DMA sync for_device cover max len CPU touch */
+	sync = xdp->data_end - xdp->data_hard_start - tsnep_rx_offset_xdp();
+	sync = max(sync, length);
+
+	switch (act) {
+	case XDP_PASS:
+		return false;
+	case XDP_TX:
+		if (!tsnep_xdp_xmit_back(rx->adapter, xdp))
+			goto out_failure;
+		*status |= TSNEP_XDP_TX;
+		return true;
+	case XDP_REDIRECT:
+		if (xdp_do_redirect(rx->adapter->netdev, xdp, prog) < 0)
+			goto out_failure;
+		*status |= TSNEP_XDP_REDIRECT;
+		return true;
+	default:
+		bpf_warn_invalid_xdp_action(rx->adapter->netdev, prog, act);
+		fallthrough;
+	case XDP_ABORTED:
+out_failure:
+		trace_xdp_exception(rx->adapter->netdev, prog, act);
+		fallthrough;
+	case XDP_DROP:
+		page_pool_put_page(rx->page_pool, virt_to_head_page(xdp->data),
+				   sync, true);
+		return true;
+	}
+}
+
+static void tsnep_finalize_xdp(struct tsnep_adapter *adapter, int status)
+{
+	int cpu = smp_processor_id();
+	struct netdev_queue *nq;
+	int queue;
+
+	if (status & TSNEP_XDP_TX) {
+		queue = cpu % adapter->num_tx_queues;
+		nq = netdev_get_tx_queue(adapter->netdev, queue);
+
+		__netif_tx_lock(nq, cpu);
+		tsnep_xdp_xmit_flush(&adapter->tx[queue]);
+		__netif_tx_unlock(nq);
+	}
+
+	if (status & TSNEP_XDP_REDIRECT)
+		xdp_do_flush();
+}
+
 static struct sk_buff *tsnep_build_skb(struct tsnep_rx *rx, struct page *page,
 				       int length)
 {
@@ -1028,15 +1126,19 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
 			 int budget)
 {
 	struct device *dmadev = rx->adapter->dmadev;
-	int desc_available;
-	int done = 0;
 	enum dma_data_direction dma_dir;
 	struct tsnep_rx_entry *entry;
+	struct bpf_prog *prog;
+	struct xdp_buff xdp;
 	struct sk_buff *skb;
+	int desc_available;
+	int xdp_status = 0;
+	int done = 0;
 	int length;
 
 	desc_available = tsnep_rx_desc_available(rx);
 	dma_dir = page_pool_get_dma_dir(rx->page_pool);
+	prog = READ_ONCE(rx->adapter->xdp_prog);
 
 	while (likely(done < budget) && (rx->read != rx->write)) {
 		entry = &rx->entry[rx->read];
@@ -1087,6 +1189,26 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
 		rx->read = (rx->read + 1) % TSNEP_RING_SIZE;
 		desc_available++;
 
+		if (prog) {
+			bool consume;
+
+			xdp_init_buff(&xdp, PAGE_SIZE, &rx->xdp_rxq);
+			xdp_prepare_buff(&xdp, page_address(entry->page),
+					 tsnep_rx_offset_xdp() + TSNEP_RX_INLINE_METADATA_SIZE,
+					 length, false);
+
+			consume = tsnep_xdp_run_prog(rx, prog, &xdp,
+						     &xdp_status);
+			if (consume) {
+				rx->packets++;
+				rx->bytes += length;
+
+				entry->page = NULL;
+
+				continue;
+			}
+		}
+
 		skb = tsnep_build_skb(rx, entry->page, length);
 		if (skb) {
 			page_pool_release_page(rx->page_pool, entry->page);
@@ -1105,6 +1227,9 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
 		entry->page = NULL;
 	}
 
+	if (xdp_status)
+		tsnep_finalize_xdp(rx->adapter, xdp_status);
+
 	if (desc_available)
 		tsnep_rx_refill(rx, desc_available, false);
 
-- 
2.30.2


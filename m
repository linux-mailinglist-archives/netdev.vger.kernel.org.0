Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A738663026
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 20:15:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237572AbjAITPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 14:15:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237412AbjAITPf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 14:15:35 -0500
Received: from mx14lb.world4you.com (mx14lb.world4you.com [81.19.149.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75AC78FD9
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 11:15:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Gu2+kKPwLsoBPwSWotsuyoN9qXXnApSECbFmnwqhr6o=; b=fSFpkd7WckiQU3UbTFUgNv/ugJ
        DsZmASKj3gS1rfOsMK+Bs6GjABh83D4wxmL0sz+FyVL++RWKDy+JtjacCzJtG2OXDWrFm02ITyJ9/
        x3k153DB91Ki2idtUHCbMEQ3Br52bZwwbvpjEONc1Oos0a2yQXx/z9TvqPCXG9RZB90I=;
Received: from 88-117-53-243.adsl.highway.telekom.at ([88.117.53.243] helo=hornet.engleder.at)
        by mx14lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pExcK-0007WQ-VB; Mon, 09 Jan 2023 20:15:33 +0100
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v4 09/10] tsnep: Add XDP RX support
Date:   Mon,  9 Jan 2023 20:15:22 +0100
Message-Id: <20230109191523.12070-10-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230109191523.12070-1-gerhard@engleder-embedded.com>
References: <20230109191523.12070-1-gerhard@engleder-embedded.com>
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

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/net/ethernet/engleder/tsnep_main.c | 122 ++++++++++++++++++++-
 1 file changed, 120 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index 451ad1849b9d..002c879639db 100644
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
@@ -625,6 +629,28 @@ static void tsnep_xdp_xmit_flush(struct tsnep_tx *tx)
 	iowrite32(TSNEP_CONTROL_TX_ENABLE, tx->addr + TSNEP_CONTROL);
 }
 
+static bool tsnep_xdp_xmit_back(struct tsnep_adapter *adapter,
+				struct xdp_buff *xdp,
+				struct netdev_queue *tx_nq, struct tsnep_tx *tx)
+{
+	struct xdp_frame *xdpf = xdp_convert_buff_to_frame(xdp);
+	bool xmit;
+
+	if (unlikely(!xdpf))
+		return false;
+
+	__netif_tx_lock(tx_nq, smp_processor_id());
+
+	/* Avoid transmit queue timeout since we share it with the slow path */
+	txq_trans_cond_update(tx_nq);
+
+	xmit = tsnep_xdp_xmit_frame_ring(xdpf, tx, TSNEP_TX_TYPE_XDP_TX);
+
+	__netif_tx_unlock(tx_nq);
+
+	return xmit;
+}
+
 static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
 {
 	struct tsnep_tx_entry *entry;
@@ -983,6 +1009,62 @@ static int tsnep_rx_refill(struct tsnep_rx *rx, int count, bool reuse)
 	return i;
 }
 
+static bool tsnep_xdp_run_prog(struct tsnep_rx *rx, struct bpf_prog *prog,
+			       struct xdp_buff *xdp, int *status,
+			       struct netdev_queue *tx_nq, struct tsnep_tx *tx)
+{
+	unsigned int length;
+	unsigned int sync;
+	u32 act;
+
+	length = xdp->data_end - xdp->data_hard_start - XDP_PACKET_HEADROOM;
+
+	act = bpf_prog_run_xdp(prog, xdp);
+
+	/* Due xdp_adjust_tail: DMA sync for_device cover max len CPU touch */
+	sync = xdp->data_end - xdp->data_hard_start - XDP_PACKET_HEADROOM;
+	sync = max(sync, length);
+
+	switch (act) {
+	case XDP_PASS:
+		return false;
+	case XDP_TX:
+		if (!tsnep_xdp_xmit_back(rx->adapter, xdp, tx_nq, tx))
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
+static void tsnep_finalize_xdp(struct tsnep_adapter *adapter, int status,
+			       struct netdev_queue *tx_nq, struct tsnep_tx *tx)
+{
+	if (status & TSNEP_XDP_TX) {
+		__netif_tx_lock(tx_nq, smp_processor_id());
+		tsnep_xdp_xmit_flush(tx);
+		__netif_tx_unlock(tx_nq);
+	}
+
+	if (status & TSNEP_XDP_REDIRECT)
+		xdp_do_flush();
+}
+
 static struct sk_buff *tsnep_build_skb(struct tsnep_rx *rx, struct page *page,
 				       int length)
 {
@@ -1018,15 +1100,29 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
 			 int budget)
 {
 	struct device *dmadev = rx->adapter->dmadev;
-	int desc_available;
-	int done = 0;
 	enum dma_data_direction dma_dir;
 	struct tsnep_rx_entry *entry;
+	struct netdev_queue *tx_nq;
+	struct bpf_prog *prog;
+	struct xdp_buff xdp;
 	struct sk_buff *skb;
+	struct tsnep_tx *tx;
+	int desc_available;
+	int xdp_status = 0;
+	int done = 0;
 	int length;
 
 	desc_available = tsnep_rx_desc_available(rx);
 	dma_dir = page_pool_get_dma_dir(rx->page_pool);
+	prog = READ_ONCE(rx->adapter->xdp_prog);
+	if (prog) {
+		int queue = smp_processor_id() % rx->adapter->num_tx_queues;
+
+		tx_nq = netdev_get_tx_queue(rx->adapter->netdev, queue);
+		tx = &rx->adapter->tx[queue];
+
+		xdp_init_buff(&xdp, PAGE_SIZE, &rx->xdp_rxq);
+	}
 
 	while (likely(done < budget) && (rx->read != rx->write)) {
 		entry = &rx->entry[rx->read];
@@ -1076,6 +1172,25 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
 		rx->read = (rx->read + 1) % TSNEP_RING_SIZE;
 		desc_available++;
 
+		if (prog) {
+			bool consume;
+
+			xdp_prepare_buff(&xdp, page_address(entry->page),
+					 XDP_PACKET_HEADROOM + TSNEP_RX_INLINE_METADATA_SIZE,
+					 length, false);
+
+			consume = tsnep_xdp_run_prog(rx, prog, &xdp,
+						     &xdp_status, tx_nq, tx);
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
@@ -1094,6 +1209,9 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
 		entry->page = NULL;
 	}
 
+	if (xdp_status)
+		tsnep_finalize_xdp(rx->adapter, xdp_status, tx_nq, tx);
+
 	if (desc_available)
 		tsnep_rx_refill(rx, desc_available, false);
 
-- 
2.30.2


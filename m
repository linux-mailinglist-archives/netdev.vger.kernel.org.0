Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA91641955
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 23:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbiLCWLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 17:11:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiLCWL3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 17:11:29 -0500
X-Greylist: delayed 1015 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 03 Dec 2022 14:11:27 PST
Received: from mx01lb.world4you.com (mx01lb.world4you.com [81.19.149.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 726A61C434;
        Sat,  3 Dec 2022 14:11:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=6mLp75EylkcS0zpNAr3dcPmCuuK0krLzoFoUhQH+z4I=; b=vR03Cm1oW93PCAWvF74IEVt2xT
        P0//q7CKk9Lok/+xYtZ/lH4wXoUAlDOXekR1qrdEwsmFBgpRDBCFEYy0XyQ2hadAefTcL3uySWIyx
        RyantghYPnTbsTAZXFssJG8eAaV+i3hFvPdMIuQ5VZ2stgbcLNB6fEo2lG5skfiiiAuY=;
Received: from 88-117-56-227.adsl.highway.telekom.at ([88.117.56.227] helo=hornet.engleder.at)
        by mx01lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1p1aSv-0003Ir-N5; Sat, 03 Dec 2022 22:54:33 +0100
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next 6/6] tsnep: Add XDP RX support
Date:   Sat,  3 Dec 2022 22:54:16 +0100
Message-Id: <20221203215416.13465-7-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221203215416.13465-1-gerhard@engleder-embedded.com>
References: <20221203215416.13465-1-gerhard@engleder-embedded.com>
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
proto 17:     865683 pkt/s

XDP_TX (samples/bpf/xdp2)
proto 17:     253594 pkt/s

XDP_REDIRECT (samples/bpf/xdpsock)
 sock0@eth2:0 rxdrop xdp-drv
                   pps            pkts           1.00
rx                 862,258        4,514,166
tx                 0              0

XDP_REDIRECT (samples/bpf/xdp_redirect)
eth2->eth1         608,895 rx/s   0 err,drop/s   608,895 xmit/s

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/net/ethernet/engleder/tsnep_main.c | 100 +++++++++++++++++++++
 1 file changed, 100 insertions(+)

diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index 725b2a1e7be4..4e3c6bd3dc9f 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -27,6 +27,7 @@
 #include <linux/phy.h>
 #include <linux/iopoll.h>
 #include <linux/bpf.h>
+#include <linux/bpf_trace.h>
 
 #define TSNEP_SKB_PAD (NET_SKB_PAD + NET_IP_ALIGN)
 #define TSNEP_HEADROOM ALIGN(max(TSNEP_SKB_PAD, XDP_PACKET_HEADROOM), 4)
@@ -44,6 +45,11 @@
 #define TSNEP_COALESCE_USECS_MAX     ((ECM_INT_DELAY_MASK >> ECM_INT_DELAY_SHIFT) * \
 				      ECM_INT_DELAY_BASE_US + ECM_INT_DELAY_BASE_US - 1)
 
+#define TSNEP_XDP_PASS		0
+#define TSNEP_XDP_CONSUMED	BIT(0)
+#define TSNEP_XDP_TX		BIT(1)
+#define TSNEP_XDP_REDIRECT	BIT(2)
+
 enum {
 	__TSNEP_DOWN,
 };
@@ -819,6 +825,11 @@ static inline unsigned int tsnep_rx_offset(struct tsnep_rx *rx)
 	return TSNEP_SKB_PAD;
 }
 
+static inline unsigned int tsnep_rx_offset_xdp(void)
+{
+	return XDP_PACKET_HEADROOM;
+}
+
 static void tsnep_rx_ring_cleanup(struct tsnep_rx *rx)
 {
 	struct device *dmadev = rx->adapter->dmadev;
@@ -1024,6 +1035,65 @@ static int tsnep_rx_refill(struct tsnep_rx *rx, int count, bool reuse)
 	return i;
 }
 
+static int tsnep_xdp_run_prog(struct tsnep_rx *rx, struct bpf_prog *prog,
+			      struct xdp_buff *xdp)
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
+		return TSNEP_XDP_PASS;
+	case XDP_TX:
+		if (tsnep_xdp_xmit_back(rx->adapter, xdp) < 0)
+			goto out_failure;
+		return TSNEP_XDP_TX;
+	case XDP_REDIRECT:
+		if (xdp_do_redirect(rx->adapter->netdev, xdp, prog) < 0)
+			goto out_failure;
+		return TSNEP_XDP_REDIRECT;
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
+		return TSNEP_XDP_CONSUMED;
+	}
+}
+
+static void tsnep_finalize_xdp(struct tsnep_adapter *adapter, int status)
+{
+	int cpu = smp_processor_id();
+	int queue;
+	struct netdev_queue *nq;
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
@@ -1062,12 +1132,17 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
 	int desc_available;
 	int done = 0;
 	enum dma_data_direction dma_dir;
+	struct bpf_prog *prog;
 	struct tsnep_rx_entry *entry;
+	struct xdp_buff xdp;
+	int xdp_status = 0;
 	struct sk_buff *skb;
 	int length;
+	int retval;
 
 	desc_available = tsnep_rx_desc_available(rx);
 	dma_dir = page_pool_get_dma_dir(rx->page_pool);
+	prog = READ_ONCE(rx->adapter->xdp_prog);
 
 	while (likely(done < budget) && (rx->read != rx->write)) {
 		entry = &rx->entry[rx->read];
@@ -1111,6 +1186,28 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
 		rx->read = (rx->read + 1) % TSNEP_RING_SIZE;
 		desc_available++;
 
+		if (prog) {
+			xdp_init_buff(&xdp, PAGE_SIZE, &rx->xdp_rxq);
+			xdp_prepare_buff(&xdp, page_address(entry->page),
+					 tsnep_rx_offset_xdp() + TSNEP_RX_INLINE_METADATA_SIZE,
+					 length - TSNEP_RX_INLINE_METADATA_SIZE,
+					 false);
+			retval = tsnep_xdp_run_prog(rx, prog, &xdp);
+		} else {
+			retval = TSNEP_XDP_PASS;
+		}
+		if (retval) {
+			if (retval & (TSNEP_XDP_TX | TSNEP_XDP_REDIRECT))
+				xdp_status |= retval;
+
+			rx->packets++;
+			rx->bytes += length - TSNEP_RX_INLINE_METADATA_SIZE;
+
+			entry->page = NULL;
+
+			continue;
+		}
+
 		skb = tsnep_build_skb(rx, entry->page, length);
 		if (skb) {
 			page_pool_release_page(rx->page_pool, entry->page);
@@ -1129,6 +1226,9 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
 		entry->page = NULL;
 	}
 
+	if (xdp_status)
+		tsnep_finalize_xdp(rx->adapter, xdp_status);
+
 	if (desc_available)
 		tsnep_rx_refill(rx, desc_available, false);
 
-- 
2.30.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E955E21D277
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 11:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728488AbgGMJF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 05:05:58 -0400
Received: from mail-eopbgr80114.outbound.protection.outlook.com ([40.107.8.114]:55945
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726360AbgGMJF5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 05:05:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JayMjaFjYbqDO5E05U/Eo4i9tvdC2TRb4mbjnYfdfhoO2Hm8noWiYA1N7NH3ADcSTnz0UY0x/FC2uOaCqacjOFVe6OxYHWLEQT1rWb7CjFYLSb6fcKhxjxGZDbzdmEN/vYVcZqebRl9w+WgIGPvGN4WqkhrArvhHISRdv2+Tee4PCAkPK4fVhlTEgVkTt38/sNPTeM2C3jTZv5RsOTHgefyZCDLRBU3arNUb1SipJPlFEzyifhBCMa5qH1tTAJOtn+906vQu+SYsUT0svEE1PwdBlAWCXOOcr+bW2mLC/ltPODdDnnLCLEAMJ0GX3p3hPm3pRSqgg8R9rL33qqITsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DL5L0bSxg0mOKzRdRydVFFklZj4p5/4jhvcthXJoLQo=;
 b=XiHypdgvrjK2xG9VBLkMSL1ue+PplJZFDqhpOPT0IZFPY4bXk0KbATVV1TX9qHzL3Ds9ZScCbqiAYDdXH1j5zm9ipEiNQdij4Nr4kOqfbuqgmDlrv989siG7do+d7HcibbKbi/oiWLRBn96+8yTqa7monfEsCde1ivq2jB8uLUM7YPPGkgl/cj5fZQCTRhwi1wsAbR3NKAUH9XVCz6eBwsFrMAbv92IkB6duQsWVfkIKOEXcE2FguGlebuw29eybEdxfXEA+A1x0GKxl1ZRG11VDOibtQYh58APCHxstdzcQgEjl8OqpuYNDHqr//GDdD9mL2nYkPyQ+fxX1lcSNfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DL5L0bSxg0mOKzRdRydVFFklZj4p5/4jhvcthXJoLQo=;
 b=hclJLEMnY88S2nMrQXiqOYsh+1QjfdeWt5JQSkcx0ZMC+bzcpA5dwyYCDH9C+I0fO71Mt6P9iKN7yRP9ySynWpKJR2T+8s54qec4WTmg+oS31WsDB5cdB7UbJ1hCnleac6ma6AFnfDrWzJOvn7iDC80VCLlpCZXpXJv29pkusyw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=voleatech.de;
Received: from AM4PR0501MB2785.eurprd05.prod.outlook.com
 (2603:10a6:200:5d::11) by AM4PR0501MB2609.eurprd05.prod.outlook.com
 (2603:10a6:200:67::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Mon, 13 Jul
 2020 09:05:50 +0000
Received: from AM4PR0501MB2785.eurprd05.prod.outlook.com
 ([fe80::39a1:e237:5fef:6f39]) by AM4PR0501MB2785.eurprd05.prod.outlook.com
 ([fe80::39a1:e237:5fef:6f39%11]) with mapi id 15.20.3174.025; Mon, 13 Jul
 2020 09:05:50 +0000
Date:   Mon, 13 Jul 2020 11:05:49 +0200
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     netdev@vger.kernel.org
Cc:     alexander.duyck@gmail.com, brouer@redhat.com,
        intel-wired-lan@lists.osuosl.org
Subject: [PATCH 1/1 v5] igb: add XDP support
Message-ID: <20200713090549.b7dive4cmtm4o7dq@SvensMacbookPro.hq.voleatech.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: AM0PR04CA0076.eurprd04.prod.outlook.com
 (2603:10a6:208:be::17) To AM4PR0501MB2785.eurprd05.prod.outlook.com
 (2603:10a6:200:5d::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from SvensMacbookPro.hq.voleatech.com (37.24.174.42) by AM0PR04CA0076.eurprd04.prod.outlook.com (2603:10a6:208:be::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20 via Frontend Transport; Mon, 13 Jul 2020 09:05:50 +0000
X-Originating-IP: [37.24.174.42]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 692b4058-16d9-422d-1290-08d8270bf074
X-MS-TrafficTypeDiagnostic: AM4PR0501MB2609:
X-Microsoft-Antispam-PRVS: <AM4PR0501MB26096FB83D4A6AAE8A5AF25BEF600@AM4PR0501MB2609.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1824;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g+ADUxKxvJ8IjEf/a8chf4xKlfix0Zfbjt2q9K5UqvGZhEfTJT6r+RUHkahNXW1Ig1fCv9OhtDPxpeKWi+youbESndCwdC9i8dzSzqtxVYjgXzIOedg6Dz6u7gsw7B63jhJTiF0dhTZn/VQZ/1RMOWmkHQ28AA3sLv6KtFH+jxWHxW3jtEZfo1IEeJ43XyoCwc8ppRmzclYWfG3ASOcFm0dcXogIcxF+gyJrepRA/mR+ohfkaFtnJgBCGkDBpTydUyanNdgJxeWn5YCcYP+vXL2opR6J3hH5wRKHbMyHKRU+OsqCfS1NwORiPc3N0MBm0XBl//rNRR/qHNFNadyJvXb1LaftGscd3l1sx1zxpl/rkEg28D+1OaciJmd81ROv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4PR0501MB2785.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39830400003)(346002)(396003)(366004)(376002)(136003)(66556008)(66946007)(66476007)(2906002)(6916009)(316002)(9686003)(4326008)(55016002)(83380400001)(1076003)(956004)(44832011)(30864003)(5660300002)(52116002)(8676002)(8936002)(86362001)(7696005)(186003)(16526019)(6506007)(508600001)(26005)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: EER5990VemvFlM9YjEN+daHCF3HE7aSPLdqFsSL/LkJ8jzOCxHsrSZyCaR1xh0InaeedIaglW/AT3fNnIFgDPq7uMVI6OBhxLKt2SnaBq9tcASn+y5u+YU39eLnspp2s+vZlx2pz+LWWk+PNNRxST8bu+Zi5D5ooSe+peajhjHYQluv4bY2rzmKwzdkRiT/+SSWA7ZLIpJLsdsrcNuNDoPE1ZI6kbfF9bJHKgN39xIeeULs3aNvP64ULYpkZykcRQASkppEhCpwLXsKqobjhIszHXauQcBJfnImXeYZIjeNBv30V06h5IPUpEvivO+Ozn8DTqUBaif8Balu/EbwOfV/q/wc2eeOM64qhOyLQ1BopbUtDy6+fhVQcSVl1zH/IunFPz2cu9H5fJA9flWK/FWE3i5k4wOtmxp2ZZPBFy8QW70tEtTxdi078GJ6BJ6Bo4y+xiDfVSucD1NYexxocmoH87CHYJXdGhhMya5MHk70=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 692b4058-16d9-422d-1290-08d8270bf074
X-MS-Exchange-CrossTenant-AuthSource: AM4PR0501MB2785.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2020 09:05:50.7106
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fnXLYVGZPDLso3HjkhKHDV4yUE1U8eZzt2ZEHWc5oj/6oUFbdsRJoJcIgfPB0WUI4JRt/reQAqha+1x+3urLaTFCcJo+Oii92L+yXrg4RI0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2609
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add XDP support to the IGB driver.
The implementation follows the IXGBE XDP implementation
closely and I used the following patches as basis:

1. commit 924708081629 ("ixgbe: add XDP support for pass and drop actions")
2. commit 33fdc82f0883 ("ixgbe: add support for XDP_TX action")
3. commit ed93a3987128 ("ixgbe: tweak page counting for XDP_REDIRECT")

Due to the hardware constraints of the devices using the
IGB driver we must share the TX queues with XDP which
means locking the TX queue for XDP.

I ran tests on an older device to get better numbers.
Test machine:

Intel(R) Atom(TM) CPU C2338 @ 1.74GHz (2 Cores)
2x Intel I211

Routing Original Driver Network Stack: 382 Kpps

Routing XDP Redirect (xdp_fwd_kern): 1.48 Mpps
XDP Drop: 1.48 Mpps

Using XDP we can achieve line rate forwarding even on
on older Intel Atom CPU.

Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
---
v5: resubmission with function names in patch

v4:
* use HARD_TX_LOCK in XDP xmit
* do not pass adapter to igb_setup_rx_resources
* account for timestamp in frame size

v3: igb_xdp_ring_update_tail should be static

v2: original did not apply to my dev-queue branch, so fixed the
    conflicts in the patch

 drivers/net/ethernet/intel/igb/igb.h         |  81 +++-
 drivers/net/ethernet/intel/igb/igb_ethtool.c |   4 +
 drivers/net/ethernet/intel/igb/igb_main.c    | 444 +++++++++++++++++--
 3 files changed, 491 insertions(+), 38 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb.h b/drivers/net/ethernet/intel/igb/igb.h
index 0c9282e2aaec..ce814a560129 100644
--- a/drivers/net/ethernet/intel/igb/igb.h
+++ b/drivers/net/ethernet/intel/igb/igb.h
@@ -19,6 +19,8 @@
 #include <linux/pci.h>
 #include <linux/mdio.h>
 
+#include <net/xdp.h>
+
 struct igb_adapter;
 
 #define E1000_PCS_CFG_IGN_SD	1
@@ -79,6 +81,12 @@ struct igb_adapter;
 #define IGB_I210_RX_LATENCY_100		2213
 #define IGB_I210_RX_LATENCY_1000	448
 
+/* XDP */
+#define IGB_XDP_PASS		0
+#define IGB_XDP_CONSUMED	BIT(0)
+#define IGB_XDP_TX		BIT(1)
+#define IGB_XDP_REDIR		BIT(2)
+
 struct vf_data_storage {
 	unsigned char vf_mac_addresses[ETH_ALEN];
 	u16 vf_mc_hashes[IGB_MAX_VF_MC_ENTRIES];
@@ -132,17 +140,63 @@ struct vf_mac_filter {
 
 /* Supported Rx Buffer Sizes */
 #define IGB_RXBUFFER_256	256
+#define IGB_RXBUFFER_1536	1536
 #define IGB_RXBUFFER_2048	2048
 #define IGB_RXBUFFER_3072	3072
 #define IGB_RX_HDR_LEN		IGB_RXBUFFER_256
 #define IGB_TS_HDR_LEN		16
 
-#define IGB_SKB_PAD		(NET_SKB_PAD + NET_IP_ALIGN)
+/* Attempt to maximize the headroom available for incoming frames.  We
+ * use a 2K buffer for receives and need 1536/1534 to store the data for
+ * the frame.  This leaves us with 512 bytes of room.  From that we need
+ * to deduct the space needed for the shared info and the padding needed
+ * to IP align the frame.
+ *
+ * Note: For cache line sizes 256 or larger this value is going to end
+ *	 up negative.  In these cases we should fall back to the 3K
+ *	 buffers.
+ */
 #if (PAGE_SIZE < 8192)
-#define IGB_MAX_FRAME_BUILD_SKB \
-	(SKB_WITH_OVERHEAD(IGB_RXBUFFER_2048) - IGB_SKB_PAD - IGB_TS_HDR_LEN)
+#define IGB_MAX_FRAME_BUILD_SKB (IGB_RXBUFFER_1536 - NET_IP_ALIGN)
+#define IGB_2K_TOO_SMALL_WITH_PADDING \
+((NET_SKB_PAD + IGB_TS_HDR_LEN + IGB_RXBUFFER_1536) > \
+SKB_WITH_OVERHEAD(IGB_RXBUFFER_2048))
+
+static inline int igb_compute_pad(int rx_buf_len)
+{
+	int page_size, pad_size;
+
+	page_size = ALIGN(rx_buf_len, PAGE_SIZE / 2);
+	pad_size = SKB_WITH_OVERHEAD(page_size) - rx_buf_len;
+
+	return pad_size;
+}
+
+static inline int igb_skb_pad(void)
+{
+	int rx_buf_len;
+
+	/* If a 2K buffer cannot handle a standard Ethernet frame then
+	 * optimize padding for a 3K buffer instead of a 1.5K buffer.
+	 *
+	 * For a 3K buffer we need to add enough padding to allow for
+	 * tailroom due to NET_IP_ALIGN possibly shifting us out of
+	 * cache-line alignment.
+	 */
+	if (IGB_2K_TOO_SMALL_WITH_PADDING)
+		rx_buf_len = IGB_RXBUFFER_3072 + SKB_DATA_ALIGN(NET_IP_ALIGN);
+	else
+		rx_buf_len = IGB_RXBUFFER_1536;
+
+	/* if needed make room for NET_IP_ALIGN */
+	rx_buf_len -= NET_IP_ALIGN;
+
+	return igb_compute_pad(rx_buf_len);
+}
+
+#define IGB_SKB_PAD	igb_skb_pad()
 #else
-#define IGB_MAX_FRAME_BUILD_SKB (IGB_RXBUFFER_2048 - IGB_TS_HDR_LEN)
+#define IGB_SKB_PAD	(NET_SKB_PAD + NET_IP_ALIGN)
 #endif
 
 /* How many Rx Buffers do we bundle into one write to the hardware ? */
@@ -194,13 +248,22 @@ enum igb_tx_flags {
 #define IGB_SFF_ADDRESSING_MODE		0x4
 #define IGB_SFF_8472_UNSUP		0x00
 
+enum igb_tx_buf_type {
+	IGB_TYPE_SKB = 0,
+	IGB_TYPE_XDP,
+};
+
 /* wrapper around a pointer to a socket buffer,
  * so a DMA handle can be stored along with the buffer
  */
 struct igb_tx_buffer {
 	union e1000_adv_tx_desc *next_to_watch;
 	unsigned long time_stamp;
-	struct sk_buff *skb;
+	enum igb_tx_buf_type type;
+	union {
+		struct sk_buff *skb;
+		struct xdp_frame *xdpf;
+	};
 	unsigned int bytecount;
 	u16 gso_segs;
 	__be16 protocol;
@@ -248,6 +311,7 @@ struct igb_ring_container {
 struct igb_ring {
 	struct igb_q_vector *q_vector;	/* backlink to q_vector */
 	struct net_device *netdev;	/* back pointer to net_device */
+	struct bpf_prog *xdp_prog;
 	struct device *dev;		/* device pointer for dma mapping */
 	union {				/* array of buffer info structs */
 		struct igb_tx_buffer *tx_buffer_info;
@@ -288,6 +352,7 @@ struct igb_ring {
 			struct u64_stats_sync rx_syncp;
 		};
 	};
+	struct xdp_rxq_info xdp_rxq;
 } ____cacheline_internodealigned_in_smp;
 
 struct igb_q_vector {
@@ -339,7 +404,7 @@ static inline unsigned int igb_rx_bufsz(struct igb_ring *ring)
 		return IGB_RXBUFFER_3072;
 
 	if (ring_uses_build_skb(ring))
-		return IGB_MAX_FRAME_BUILD_SKB + IGB_TS_HDR_LEN;
+		return IGB_MAX_FRAME_BUILD_SKB;
 #endif
 	return IGB_RXBUFFER_2048;
 }
@@ -467,6 +532,7 @@ struct igb_adapter {
 	unsigned long active_vlans[BITS_TO_LONGS(VLAN_N_VID)];
 
 	struct net_device *netdev;
+	struct bpf_prog *xdp_prog;
 
 	unsigned long state;
 	unsigned int flags;
@@ -644,6 +710,9 @@ enum igb_boards {
 extern char igb_driver_name[];
 extern char igb_driver_version[];
 
+int igb_xmit_xdp_ring(struct igb_adapter *adapter,
+		      struct igb_ring *ring,
+		      struct xdp_frame *xdpf);
 int igb_open(struct net_device *netdev);
 int igb_close(struct net_device *netdev);
 int igb_up(struct igb_adapter *);
diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
index 2cd003c5ad43..eaa712a6d859 100644
--- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
+++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
@@ -962,6 +962,10 @@ static int igb_set_ringparam(struct net_device *netdev,
 			memcpy(&temp_ring[i], adapter->rx_ring[i],
 			       sizeof(struct igb_ring));
 
+			/* Clear copied XDP RX-queue info */
+			memset(&temp_ring[i].xdp_rxq, 0,
+			       sizeof(temp_ring[i].xdp_rxq));
+
 			temp_ring[i].count = new_rx_count;
 			err = igb_setup_rx_resources(&temp_ring[i]);
 			if (err) {
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 8bb3db2cbd41..ee33f19843a8 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -30,6 +30,8 @@
 #include <linux/if_ether.h>
 #include <linux/aer.h>
 #include <linux/prefetch.h>
+#include <linux/bpf.h>
+#include <linux/bpf_trace.h>
 #include <linux/pm_runtime.h>
 #include <linux/etherdevice.h>
 #ifdef CONFIG_IGB_DCA
@@ -2834,6 +2836,153 @@ static int igb_setup_tc(struct net_device *dev, enum tc_setup_type type,
 	}
 }
 
+static int igb_xdp_setup(struct net_device *dev, struct bpf_prog *prog)
+{
+	int i, frame_size = dev->mtu + ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN;
+	struct igb_adapter *adapter = netdev_priv(dev);
+	struct bpf_prog *old_prog;
+	bool running = netif_running(dev);
+	bool need_reset;
+
+	/* verify igb ring attributes are sufficient for XDP */
+	for (i = 0; i < adapter->num_rx_queues; i++) {
+		struct igb_ring *ring = adapter->rx_ring[i];
+
+		if (frame_size > igb_rx_bufsz(ring))
+			return -EINVAL;
+	}
+
+	old_prog = xchg(&adapter->xdp_prog, prog);
+	need_reset = (!!prog != !!old_prog);
+
+	/* device is up and bpf is added/removed, must setup the RX queues */
+	if (need_reset && running) {
+		igb_close(dev);
+	} else {
+		for (i = 0; i < adapter->num_rx_queues; i++)
+			(void)xchg(&adapter->rx_ring[i]->xdp_prog,
+			    adapter->xdp_prog);
+	}
+
+	if (old_prog)
+		bpf_prog_put(old_prog);
+
+	/* bpf is just replaced, RXQ and MTU are already setup */
+	if (!need_reset)
+		return 0;
+
+	if (running)
+		igb_open(dev);
+
+	return 0;
+}
+
+static int igb_xdp(struct net_device *dev, struct netdev_bpf *xdp)
+{
+	struct igb_adapter *adapter = netdev_priv(dev);
+
+	switch (xdp->command) {
+	case XDP_SETUP_PROG:
+		return igb_xdp_setup(dev, xdp->prog);
+	case XDP_QUERY_PROG:
+		xdp->prog_id = adapter->xdp_prog ?
+			adapter->xdp_prog->aux->id : 0;
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
+
+void igb_xdp_ring_update_tail(struct igb_ring *ring)
+{
+	/* Force memory writes to complete before letting h/w know there
+	 * are new descriptors to fetch.
+	 */
+	wmb();
+	writel(ring->next_to_use, ring->tail);
+}
+
+static inline struct igb_ring *igb_xdp_tx_queue_mapping(struct igb_adapter *adapter)
+{
+	unsigned int r_idx = smp_processor_id();
+
+	if (r_idx >= adapter->num_tx_queues)
+		r_idx = r_idx % adapter->num_tx_queues;
+
+	return adapter->tx_ring[r_idx];
+}
+
+static int igb_xdp_xmit_back(struct igb_adapter *adapter, struct xdp_buff *xdp)
+{
+	struct xdp_frame *xdpf = xdp_convert_buff_to_frame(xdp);
+	int cpu = smp_processor_id();
+	struct igb_ring *tx_ring;
+	struct netdev_queue *nq;
+	u32 ret;
+
+	if (unlikely(!xdpf))
+		return IGB_XDP_CONSUMED;
+
+	/* During program transitions its possible adapter->xdp_prog is assigned
+	 * but ring has not been configured yet. In this case simply abort xmit.
+	 */
+	tx_ring = adapter->xdp_prog ? igb_xdp_tx_queue_mapping(adapter) : NULL;
+	if (unlikely(!tx_ring))
+		return -ENXIO;
+
+	nq = txring_txq(tx_ring);
+	__netif_tx_lock(nq, cpu);
+	ret = igb_xmit_xdp_ring(adapter, tx_ring, xdpf);
+	__netif_tx_unlock(nq);
+
+	return ret;
+}
+
+static int igb_xdp_xmit(struct net_device *dev, int n,
+			struct xdp_frame **frames, u32 flags)
+{
+	struct igb_adapter *adapter = netdev_priv(dev);
+	int cpu = smp_processor_id();
+	struct igb_ring *tx_ring;
+	struct netdev_queue *nq;
+	int drops = 0;
+	int i;
+
+	if (unlikely(test_bit(__IGB_DOWN, &adapter->state)))
+		return -ENETDOWN;
+
+	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
+		return -EINVAL;
+
+	/* During program transitions its possible adapter->xdp_prog is assigned
+	 * but ring has not been configured yet. In this case simply abort xmit.
+	 */
+	tx_ring = adapter->xdp_prog ? igb_xdp_tx_queue_mapping(adapter) : NULL;
+	if (unlikely(!tx_ring))
+		return -ENXIO;
+
+	nq = txring_txq(tx_ring);
+	__netif_tx_lock(nq, cpu);
+
+	for (i = 0; i < n; i++) {
+		struct xdp_frame *xdpf = frames[i];
+		int err;
+
+		err = igb_xmit_xdp_ring(adapter, tx_ring, xdpf);
+		if (err != IGB_XDP_TX) {
+			xdp_return_frame_rx_napi(xdpf);
+			drops++;
+		}
+	}
+
+	__netif_tx_unlock(nq);
+
+	if (unlikely(flags & XDP_XMIT_FLUSH))
+		igb_xdp_ring_update_tail(tx_ring);
+
+	return n - drops;
+}
+
 static const struct net_device_ops igb_netdev_ops = {
 	.ndo_open		= igb_open,
 	.ndo_stop		= igb_close,
@@ -2858,6 +3007,8 @@ static const struct net_device_ops igb_netdev_ops = {
 	.ndo_fdb_add		= igb_ndo_fdb_add,
 	.ndo_features_check	= igb_features_check,
 	.ndo_setup_tc		= igb_setup_tc,
+	.ndo_bpf		= igb_xdp,
+	.ndo_xdp_xmit		= igb_xdp_xmit,
 };
 
 /**
@@ -4188,6 +4339,7 @@ static void igb_configure_tx(struct igb_adapter *adapter)
  **/
 int igb_setup_rx_resources(struct igb_ring *rx_ring)
 {
+	struct igb_adapter *adapter = netdev_priv(rx_ring->netdev);
 	struct device *dev = rx_ring->dev;
 	int size;
 
@@ -4210,6 +4362,13 @@ int igb_setup_rx_resources(struct igb_ring *rx_ring)
 	rx_ring->next_to_clean = 0;
 	rx_ring->next_to_use = 0;
 
+	rx_ring->xdp_prog = adapter->xdp_prog;
+
+	/* XDP RX-queue info */
+	if (xdp_rxq_info_reg(&rx_ring->xdp_rxq, rx_ring->netdev,
+			     rx_ring->queue_index) < 0)
+		goto err;
+
 	return 0;
 
 err:
@@ -4514,6 +4673,10 @@ void igb_configure_rx_ring(struct igb_adapter *adapter,
 	int reg_idx = ring->reg_idx;
 	u32 rxdctl = 0;
 
+	xdp_rxq_info_unreg_mem_model(&ring->xdp_rxq);
+	WARN_ON(xdp_rxq_info_reg_mem_model(&ring->xdp_rxq,
+					   MEM_TYPE_PAGE_SHARED, NULL));
+
 	/* disable the queue */
 	wr32(E1000_RXDCTL(reg_idx), 0);
 
@@ -4718,6 +4881,8 @@ void igb_free_rx_resources(struct igb_ring *rx_ring)
 {
 	igb_clean_rx_ring(rx_ring);
 
+	rx_ring->xdp_prog = NULL;
+	xdp_rxq_info_unreg(&rx_ring->xdp_rxq);
 	vfree(rx_ring->rx_buffer_info);
 	rx_ring->rx_buffer_info = NULL;
 
@@ -6087,6 +6252,80 @@ static int igb_tx_map(struct igb_ring *tx_ring,
 	return -1;
 }
 
+int igb_xmit_xdp_ring(struct igb_adapter *adapter,
+		      struct igb_ring *tx_ring,
+		      struct xdp_frame *xdpf)
+{
+	struct igb_tx_buffer *tx_buffer;
+	union e1000_adv_tx_desc *tx_desc;
+	u32 len, cmd_type, olinfo_status;
+	dma_addr_t dma;
+	u16 i;
+
+	len = xdpf->len;
+
+	if (unlikely(!igb_desc_unused(tx_ring)))
+		return IGB_XDP_CONSUMED;
+
+	dma = dma_map_single(tx_ring->dev, xdpf->data, len, DMA_TO_DEVICE);
+	if (dma_mapping_error(tx_ring->dev, dma))
+		return IGB_XDP_CONSUMED;
+
+	/* record the location of the first descriptor for this packet */
+	tx_buffer = &tx_ring->tx_buffer_info[tx_ring->next_to_use];
+	tx_buffer->bytecount = len;
+	tx_buffer->gso_segs = 1;
+	tx_buffer->protocol = 0;
+
+	i = tx_ring->next_to_use;
+	tx_desc = IGB_TX_DESC(tx_ring, i);
+
+	dma_unmap_len_set(tx_buffer, len, len);
+	dma_unmap_addr_set(tx_buffer, dma, dma);
+	tx_buffer->type = IGB_TYPE_XDP;
+	tx_buffer->xdpf = xdpf;
+
+	tx_desc->read.buffer_addr = cpu_to_le64(dma);
+
+	/* put descriptor type bits */
+	cmd_type = E1000_ADVTXD_DTYP_DATA |
+		       E1000_ADVTXD_DCMD_DEXT |
+		       E1000_ADVTXD_DCMD_IFCS;
+	cmd_type |= len | IGB_TXD_DCMD;
+	tx_desc->read.cmd_type_len = cpu_to_le32(cmd_type);
+
+	olinfo_status = cpu_to_le32(len << E1000_ADVTXD_PAYLEN_SHIFT);
+	/* 82575 requires a unique index per ring */
+	if (test_bit(IGB_RING_FLAG_TX_CTX_IDX, &tx_ring->flags))
+		olinfo_status |= tx_ring->reg_idx << 4;
+
+	tx_desc->read.olinfo_status = olinfo_status;
+
+	netdev_tx_sent_queue(txring_txq(tx_ring), tx_buffer->bytecount);
+
+	/* set the timestamp */
+	tx_buffer->time_stamp = jiffies;
+
+	/* Avoid any potential race with xdp_xmit and cleanup */
+	smp_wmb();
+
+	/* set next_to_watch value indicating a packet is present */
+	i++;
+	if (i == tx_ring->count)
+		i = 0;
+
+	tx_buffer->next_to_watch = tx_desc;
+	tx_ring->next_to_use = i;
+
+	/* Make sure there is space in the ring for the next send. */
+	igb_maybe_stop_tx(tx_ring, DESC_NEEDED);
+
+	if (netif_xmit_stopped(txring_txq(tx_ring)) || !netdev_xmit_more())
+		writel(i, tx_ring->tail);
+
+	return IGB_XDP_TX;
+}
+
 netdev_tx_t igb_xmit_frame_ring(struct sk_buff *skb,
 				struct igb_ring *tx_ring)
 {
@@ -6115,6 +6354,7 @@ netdev_tx_t igb_xmit_frame_ring(struct sk_buff *skb,
 
 	/* record the location of the first descriptor for this packet */
 	first = &tx_ring->tx_buffer_info[tx_ring->next_to_use];
+	first->type = IGB_TYPE_SKB;
 	first->skb = skb;
 	first->bytecount = skb->len;
 	first->gso_segs = 1;
@@ -6257,6 +6497,19 @@ static int igb_change_mtu(struct net_device *netdev, int new_mtu)
 	struct igb_adapter *adapter = netdev_priv(netdev);
 	int max_frame = new_mtu + ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN;
 
+	if (adapter->xdp_prog) {
+		int i;
+
+		for (i = 0; i < adapter->num_rx_queues; i++) {
+			struct igb_ring *ring = adapter->rx_ring[i];
+
+			if (max_frame > igb_rx_bufsz(ring)) {
+				netdev_warn(adapter->netdev, "Requested MTU size is not supported with XDP\n");
+				return -EINVAL;
+			}
+		}
+	}
+
 	/* adjust max frame to be at least the size of a standard frame */
 	if (max_frame < (ETH_FRAME_LEN + ETH_FCS_LEN))
 		max_frame = ETH_FRAME_LEN + ETH_FCS_LEN;
@@ -7810,7 +8063,10 @@ static bool igb_clean_tx_irq(struct igb_q_vector *q_vector, int napi_budget)
 		total_packets += tx_buffer->gso_segs;
 
 		/* free the skb */
-		napi_consume_skb(tx_buffer->skb, napi_budget);
+		if (tx_buffer->type == IGB_TYPE_SKB)
+			napi_consume_skb(tx_buffer->skb, napi_budget);
+		else
+			xdp_return_frame(tx_buffer->xdpf);
 
 		/* unmap skb header data */
 		dma_unmap_single(tx_ring->dev,
@@ -7863,6 +8119,7 @@ static bool igb_clean_tx_irq(struct igb_q_vector *q_vector, int napi_budget)
 				  total_packets, total_bytes);
 	i += tx_ring->count;
 	tx_ring->next_to_clean = i;
+
 	u64_stats_update_begin(&tx_ring->tx_syncp);
 	tx_ring->tx_stats.bytes += total_bytes;
 	tx_ring->tx_stats.packets += total_packets;
@@ -7994,8 +8251,8 @@ static bool igb_can_reuse_rx_page(struct igb_rx_buffer *rx_buffer)
 	 * the pagecnt_bias and page count so that we fully restock the
 	 * number of references the driver holds.
 	 */
-	if (unlikely(!pagecnt_bias)) {
-		page_ref_add(page, USHRT_MAX);
+	if (unlikely(pagecnt_bias == 1)) {
+		page_ref_add(page, USHRT_MAX - 1);
 		rx_buffer->pagecnt_bias = USHRT_MAX;
 	}
 
@@ -8034,22 +8291,23 @@ static void igb_add_rx_frag(struct igb_ring *rx_ring,
 
 static struct sk_buff *igb_construct_skb(struct igb_ring *rx_ring,
 					 struct igb_rx_buffer *rx_buffer,
-					 union e1000_adv_rx_desc *rx_desc,
-					 unsigned int size)
+					 struct xdp_buff *xdp,
+					 union e1000_adv_rx_desc *rx_desc)
 {
-	void *va = page_address(rx_buffer->page) + rx_buffer->page_offset;
+	unsigned int size = xdp->data_end - xdp->data;
 #if (PAGE_SIZE < 8192)
 	unsigned int truesize = igb_rx_pg_size(rx_ring) / 2;
 #else
-	unsigned int truesize = SKB_DATA_ALIGN(size);
+	unsigned int truesize = SKB_DATA_ALIGN(xdp->data_end -
+					       xdp->data_hard_start);
 #endif
 	unsigned int headlen;
 	struct sk_buff *skb;
 
 	/* prefetch first cache line of first page */
-	prefetch(va);
+	prefetch(xdp->data);
 #if L1_CACHE_BYTES < 128
-	prefetch(va + L1_CACHE_BYTES);
+	prefetch(xdp->data + L1_CACHE_BYTES);
 #endif
 
 	/* allocate a skb to store the frags */
@@ -8058,24 +8316,24 @@ static struct sk_buff *igb_construct_skb(struct igb_ring *rx_ring,
 		return NULL;
 
 	if (unlikely(igb_test_staterr(rx_desc, E1000_RXDADV_STAT_TSIP))) {
-		igb_ptp_rx_pktstamp(rx_ring->q_vector, va, skb);
-		va += IGB_TS_HDR_LEN;
+		igb_ptp_rx_pktstamp(rx_ring->q_vector, xdp->data, skb);
+		xdp->data += IGB_TS_HDR_LEN;
 		size -= IGB_TS_HDR_LEN;
 	}
 
 	/* Determine available headroom for copy */
 	headlen = size;
 	if (headlen > IGB_RX_HDR_LEN)
-		headlen = eth_get_headlen(skb->dev, va, IGB_RX_HDR_LEN);
+		headlen = eth_get_headlen(skb->dev, xdp->data, IGB_RX_HDR_LEN);
 
 	/* align pull length to size of long to optimize memcpy performance */
-	memcpy(__skb_put(skb, headlen), va, ALIGN(headlen, sizeof(long)));
+	memcpy(__skb_put(skb, headlen), xdp->data, ALIGN(headlen, sizeof(long)));
 
 	/* update all of the pointers */
 	size -= headlen;
 	if (size) {
 		skb_add_rx_frag(skb, 0, rx_buffer->page,
-				(va + headlen) - page_address(rx_buffer->page),
+				(xdp->data + headlen) - page_address(rx_buffer->page),
 				size, truesize);
 #if (PAGE_SIZE < 8192)
 		rx_buffer->page_offset ^= truesize;
@@ -8091,32 +8349,32 @@ static struct sk_buff *igb_construct_skb(struct igb_ring *rx_ring,
 
 static struct sk_buff *igb_build_skb(struct igb_ring *rx_ring,
 				     struct igb_rx_buffer *rx_buffer,
-				     union e1000_adv_rx_desc *rx_desc,
-				     unsigned int size)
+				     struct xdp_buff *xdp,
+				     union e1000_adv_rx_desc *rx_desc)
 {
-	void *va = page_address(rx_buffer->page) + rx_buffer->page_offset;
 #if (PAGE_SIZE < 8192)
 	unsigned int truesize = igb_rx_pg_size(rx_ring) / 2;
 #else
 	unsigned int truesize = SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) +
-				SKB_DATA_ALIGN(IGB_SKB_PAD + size);
+				SKB_DATA_ALIGN(xdp->data_end -
+					       xdp->data_hard_start);
 #endif
 	struct sk_buff *skb;
 
 	/* prefetch first cache line of first page */
-	prefetch(va);
+	prefetch(xdp->data_meta);
 #if L1_CACHE_BYTES < 128
-	prefetch(va + L1_CACHE_BYTES);
+	prefetch(xdp->data_meta + L1_CACHE_BYTES);
 #endif
 
 	/* build an skb around the page buffer */
-	skb = build_skb(va - IGB_SKB_PAD, truesize);
+	skb = build_skb(xdp->data_hard_start, truesize);
 	if (unlikely(!skb))
 		return NULL;
 
 	/* update pointers within the skb to store the data */
-	skb_reserve(skb, IGB_SKB_PAD);
-	__skb_put(skb, size);
+	skb_reserve(skb, xdp->data - xdp->data_hard_start);
+	__skb_put(skb, xdp->data_end - xdp->data);
 
 	/* pull timestamp out of packet data */
 	if (igb_test_staterr(rx_desc, E1000_RXDADV_STAT_TSIP)) {
@@ -8134,6 +8392,79 @@ static struct sk_buff *igb_build_skb(struct igb_ring *rx_ring,
 	return skb;
 }
 
+static struct sk_buff *igb_run_xdp(struct igb_adapter *adapter,
+				   struct igb_ring *rx_ring,
+				   struct xdp_buff *xdp)
+{
+	int err, result = IGB_XDP_PASS;
+	struct bpf_prog *xdp_prog;
+	u32 act;
+
+	rcu_read_lock();
+	xdp_prog = READ_ONCE(rx_ring->xdp_prog);
+
+	if (!xdp_prog)
+		goto xdp_out;
+
+	prefetchw(xdp->data_hard_start); /* xdp_frame write */
+
+	act = bpf_prog_run_xdp(xdp_prog, xdp);
+	switch (act) {
+	case XDP_PASS:
+		break;
+	case XDP_TX:
+		result = igb_xdp_xmit_back(adapter, xdp);
+		break;
+	case XDP_REDIRECT:
+		err = xdp_do_redirect(adapter->netdev, xdp, xdp_prog);
+		if (!err)
+			result = IGB_XDP_REDIR;
+		else
+			result = IGB_XDP_CONSUMED;
+		break;
+	default:
+		bpf_warn_invalid_xdp_action(act);
+		/* fallthrough */
+	case XDP_ABORTED:
+		trace_xdp_exception(rx_ring->netdev, xdp_prog, act);
+		/* fallthrough -- handle aborts by dropping packet */
+	case XDP_DROP:
+		result = IGB_XDP_CONSUMED;
+		break;
+	}
+xdp_out:
+	rcu_read_unlock();
+	return ERR_PTR(-result);
+}
+
+static unsigned int igb_rx_frame_truesize(struct igb_ring *rx_ring,
+					  unsigned int size)
+{
+	unsigned int truesize;
+
+#if (PAGE_SIZE < 8192)
+	truesize = igb_rx_pg_size(rx_ring) / 2; /* Must be power-of-2 */
+#else
+	truesize = ring_uses_build_skb(rx_ring) ?
+		SKB_DATA_ALIGN(IGB_SKB_PAD + size) +
+		SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) :
+		SKB_DATA_ALIGN(size);
+#endif
+	return truesize;
+}
+
+static void igb_rx_buffer_flip(struct igb_ring *rx_ring,
+			       struct igb_rx_buffer *rx_buffer,
+			       unsigned int size)
+{
+	unsigned int truesize = igb_rx_frame_truesize(rx_ring, size);
+#if (PAGE_SIZE < 8192)
+	rx_buffer->page_offset ^= truesize;
+#else
+	rx_buffer->page_offset += truesize;
+#endif
+}
+
 static inline void igb_rx_checksum(struct igb_ring *ring,
 				   union e1000_adv_rx_desc *rx_desc,
 				   struct sk_buff *skb)
@@ -8230,6 +8561,10 @@ static bool igb_cleanup_headers(struct igb_ring *rx_ring,
 				union e1000_adv_rx_desc *rx_desc,
 				struct sk_buff *skb)
 {
+	/* XDP packets use error pointer so abort at this point */
+	if (IS_ERR(skb))
+		return true;
+
 	if (unlikely((igb_test_staterr(rx_desc,
 				       E1000_RXDEXT_ERR_FRAME_ERR_MASK)))) {
 		struct net_device *netdev = rx_ring->netdev;
@@ -8288,6 +8623,11 @@ static void igb_process_skb_fields(struct igb_ring *rx_ring,
 	skb->protocol = eth_type_trans(skb, rx_ring->netdev);
 }
 
+static inline unsigned int igb_rx_offset(struct igb_ring *rx_ring)
+{
+	return ring_uses_build_skb(rx_ring) ? IGB_SKB_PAD : 0;
+}
+
 static struct igb_rx_buffer *igb_get_rx_buffer(struct igb_ring *rx_ring,
 					       const unsigned int size)
 {
@@ -8332,9 +8672,19 @@ static void igb_put_rx_buffer(struct igb_ring *rx_ring,
 static int igb_clean_rx_irq(struct igb_q_vector *q_vector, const int budget)
 {
 	struct igb_ring *rx_ring = q_vector->rx.ring;
+	struct igb_adapter *adapter = q_vector->adapter;
 	struct sk_buff *skb = rx_ring->skb;
 	unsigned int total_bytes = 0, total_packets = 0;
+	unsigned int xdp_xmit = 0;
 	u16 cleaned_count = igb_desc_unused(rx_ring);
+	struct xdp_buff xdp;
+
+	xdp.rxq = &rx_ring->xdp_rxq;
+
+	/* Frame size depend on rx_ring setup when PAGE_SIZE=4K */
+#if (PAGE_SIZE < 8192)
+	xdp.frame_sz = igb_rx_frame_truesize(rx_ring, 0);
+#endif
 
 	while (likely(total_packets < budget)) {
 		union e1000_adv_rx_desc *rx_desc;
@@ -8361,13 +8711,38 @@ static int igb_clean_rx_irq(struct igb_q_vector *q_vector, const int budget)
 		rx_buffer = igb_get_rx_buffer(rx_ring, size);
 
 		/* retrieve a buffer from the ring */
-		if (skb)
+		if (!skb) {
+			xdp.data = page_address(rx_buffer->page) +
+				   rx_buffer->page_offset;
+			xdp.data_meta = xdp.data;
+			xdp.data_hard_start = xdp.data -
+					      igb_rx_offset(rx_ring);
+			xdp.data_end = xdp.data + size;
+#if (PAGE_SIZE > 4096)
+			/* At larger PAGE_SIZE, frame_sz depend on len size */
+			xdp.frame_sz = igb_rx_frame_truesize(rx_ring, size);
+#endif
+			skb = igb_run_xdp(adapter, rx_ring, &xdp);
+		}
+
+		if (IS_ERR(skb)) {
+			unsigned int xdp_res = -PTR_ERR(skb);
+
+			if (xdp_res & (IGB_XDP_TX | IGB_XDP_REDIR)) {
+				xdp_xmit |= xdp_res;
+				igb_rx_buffer_flip(rx_ring, rx_buffer, size);
+			} else {
+				rx_buffer->pagecnt_bias++;
+			}
+			total_packets++;
+			total_bytes += size;
+		} else if (skb)
 			igb_add_rx_frag(rx_ring, rx_buffer, skb, size);
 		else if (ring_uses_build_skb(rx_ring))
-			skb = igb_build_skb(rx_ring, rx_buffer, rx_desc, size);
+			skb = igb_build_skb(rx_ring, rx_buffer, &xdp, rx_desc);
 		else
 			skb = igb_construct_skb(rx_ring, rx_buffer,
-						rx_desc, size);
+						&xdp, rx_desc);
 
 		/* exit if we failed to retrieve a buffer */
 		if (!skb) {
@@ -8407,6 +8782,15 @@ static int igb_clean_rx_irq(struct igb_q_vector *q_vector, const int budget)
 	/* place incomplete frames back on ring for completion */
 	rx_ring->skb = skb;
 
+	if (xdp_xmit & IGB_XDP_REDIR)
+		xdp_do_flush_map();
+
+	if (xdp_xmit & IGB_XDP_TX) {
+		struct igb_ring *tx_ring = igb_xdp_tx_queue_mapping(adapter);
+
+		igb_xdp_ring_update_tail(tx_ring);
+	}
+
 	u64_stats_update_begin(&rx_ring->rx_syncp);
 	rx_ring->rx_stats.packets += total_packets;
 	rx_ring->rx_stats.bytes += total_bytes;
@@ -8420,11 +8804,6 @@ static int igb_clean_rx_irq(struct igb_q_vector *q_vector, const int budget)
 	return total_packets;
 }
 
-static inline unsigned int igb_rx_offset(struct igb_ring *rx_ring)
-{
-	return ring_uses_build_skb(rx_ring) ? IGB_SKB_PAD : 0;
-}
-
 static bool igb_alloc_mapped_page(struct igb_ring *rx_ring,
 				  struct igb_rx_buffer *bi)
 {
@@ -8461,7 +8840,8 @@ static bool igb_alloc_mapped_page(struct igb_ring *rx_ring,
 	bi->dma = dma;
 	bi->page = page;
 	bi->page_offset = igb_rx_offset(rx_ring);
-	bi->pagecnt_bias = 1;
+	page_ref_add(page, USHRT_MAX - 1);
+	bi->pagecnt_bias = USHRT_MAX;
 
 	return true;
 }
-- 
2.20.1


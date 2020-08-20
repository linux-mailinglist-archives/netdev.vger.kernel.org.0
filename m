Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA67124AECA
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 07:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725850AbgHTFwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 01:52:55 -0400
Received: from mail-vi1eur05on2139.outbound.protection.outlook.com ([40.107.21.139]:57847
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725778AbgHTFwy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Aug 2020 01:52:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hvlzjinYMk0DM/dZRs2SkI4JR27+VElq9YIHJiVZmBB1Q1Xq9DtXHHMB+UBHxFJDVGbo1UFQXltyXRriOwblkBeoSlGdc6DNO6ANx1UIn02tJaoc4kn8ZMXmaJ3pgwwBR06TYlKJq54M4OoaqOWg6EOt2POcKGG23Y7lJOL4/NFGsL+hreHSU21/XkM06/4VkZlYIvUg3iiCiLf29x6pJPJP4Wf1XFdPkvYefQcnC96BMhDuhDvQEoTgJsc4n52NeJDLgaihyc89BAqZt3bZEjktCeGGxwTLsq2WxFA7NOPjjU3AuGR2PTHfPBQ8CrVHNGCPSo9fecmaa/OWAEuHZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DL5L0bSxg0mOKzRdRydVFFklZj4p5/4jhvcthXJoLQo=;
 b=XTeScpkI9kbTzKRPgWiPaOlYh7iPgSVx7jGjGoR8/wwHbMtbvSTd8gHnrwFSVYTdrGkf8JJP72KTWhPTxQ6wAxmq4U2O0OhWjS7Ph75ilRuovzmMwtNtuece0RlgjJmojD9G+aIDBfsa9TU0jRmetcxvDjpSFBrA7++l8tGK+DoD8XSKXo/zxbTpPA3Zm1KBaoL8agNKRHLJxX0m15+FgHyY5LzpeT12Xsjr07DR6DxqsalbTM+cuRHoGXQ/FSpdsXfJDcUFf+7JIu9+qystVGlNJq5K5MRmW2aMNNmUqnIzV7h1uYJQf81mPOXXvmJGRrFaETGfBUtdGupZzGT9SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DL5L0bSxg0mOKzRdRydVFFklZj4p5/4jhvcthXJoLQo=;
 b=UC123SE762Yro52fNj9vWHArQNqt5BBILdjyGbHxJ2G3WakqXvWCVMN70/3J7O4vxD715YreFzP92dR2lOGNbT8ccUKHJowCza4nhxGOyKHc8hPAcDJ0K0G1BpLiYkHsDpAuWKGuhB/BzMBtKC6XDBGi/AI3ka0UH4EAT51NPJU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=voleatech.de;
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com (2603:10a6:20b:1d4::23)
 by AM0PR05MB5793.eurprd05.prod.outlook.com (2603:10a6:208:116::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Thu, 20 Aug
 2020 05:52:47 +0000
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::94b8:d700:da06:a7c]) by AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::94b8:d700:da06:a7c%4]) with mapi id 15.20.3305.025; Thu, 20 Aug 2020
 05:52:47 +0000
Date:   Thu, 20 Aug 2020 07:52:42 +0200
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Cc:     alexander.duyck@gmail.com, brouer@redhat.com,
        jeffrey.t.kirsher@intel.com, davem@davemloft.net,
        bpf@vger.kernel.org
Subject: [PATCH 1/1 v5] igb: add XDP support
Message-ID: <20200820055242.egma3hmadceuklfi@svensmacbookair.sven.lan>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: AM0PR06CA0075.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::16) To AM8PR05MB7251.eurprd05.prod.outlook.com
 (2603:10a6:20b:1d4::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from svensmacbookair.sven.lan (109.193.235.168) by AM0PR06CA0075.eurprd06.prod.outlook.com (2603:10a6:208:fa::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend Transport; Thu, 20 Aug 2020 05:52:46 +0000
X-Originating-IP: [109.193.235.168]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e54fdc35-05e8-4854-61ce-08d844cd43b5
X-MS-TrafficTypeDiagnostic: AM0PR05MB5793:
X-Microsoft-Antispam-PRVS: <AM0PR05MB5793F7B15C5E1D6BEA24B59FEF5A0@AM0PR05MB5793.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1824;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TgffS5kFgSaTV/dg5vjMgh4bpguBVT28xXUcyp3CsP2ue7nU1MBYP2xA5eez/NB7BqticplHgPrt0rdxRqvqkU4EdurZXB+9neFnRSeWBq+iW+im2qF4+hmYBIb/ePmFbJiAQBhITraWfzGSYIiead1JsqMqCKB8Uq/EOdO4Fm0OElGZ1DGxJ2ivYOk/KVuP2Xpdg8MAPNml313PqPzwQtWPWlLiX4YQpTXecSL0HgD3LfeEgZAi3cX3ezbaul1LJQmh7VSko1J/FB8oXYMInU7W8HQ1QsHJmt6C2nSl0OYOJ7DpM1l5GGG0+T7Wf+B4oK3pba+D+a7HjrSr0FCswye20Lq677lKpPIJrVrs/HlKVxwsYACPqDg9EplkP6VQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7251.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(346002)(39830400003)(376002)(136003)(2906002)(186003)(8676002)(6666004)(9686003)(26005)(316002)(16526019)(956004)(44832011)(7696005)(6506007)(55016002)(52116002)(83380400001)(8936002)(66476007)(4326008)(86362001)(5660300002)(478600001)(30864003)(66556008)(1076003)(66946007)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: Jl6navjorIj8tT9cQFHnbyC0jS5OvdvkaaCO9oIw7SqW+F70TY2mtKqiK9uLI0TFTI43+A6ihDRg/4o4Z5EklJDQk7eW61GAcgEGROklW1hbgbBoUmQbTgSlXiCvALAF/jFsg3fB9dQJ1X0KL40OPg8nbG9x+srklMmQmGaMSZqh2vrgAL4nm1EAvl2BuyxswGSJrnr31/EOyx8xKevmDvf9lhpfq5tAumlG95IKmI2CsEPfdlwBUb+f1KKUC5jvKBMQJiw5uWaHL/7LZEQI0+jr/9Z3DGlAP4bPWzKXZluWHJTUT6TLsDfIDRwzwptSDKM88Hetev0CzZAhTV0ee9k193tY9xAWLFPecSTukycrzLA2rTd0GdJ0JfpcQMvl+8NRO+5sMloxW55KDTLxteNQlcfwP4zUub8h4S4lvIZ9XVAd+Y6AQraXFpWROuBfsrFADRWewrG660EWIsrX67slELOkPR4AUGiXf4D0bKIDhLTBcGI9IomNldQ4fmPIHLAL+nIvdzZiumavcAofgPsJ8L2qOtZ91DMtc3d/4/p5kIDoHbcu20PHMxxDppUt5V777uL/yU0KhBW4aHHsteAk4mQ+kW5JjwUjWYPINHaIMW+ygCl3cIgOuxKiwopfxZnCiO68Yqwr5tLNgKHGzQ==
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: e54fdc35-05e8-4854-61ce-08d844cd43b5
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7251.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2020 05:52:47.0876
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LefYTjpTMLxZXtffHXZRlOupLAB+/5+Sc73ytR9bTPw+kHMQTaG1wlNLZvbaMGqFcViJ5wsI+WpaduGVocYA3R2JXnfUn5pDQCO3o+TsTGs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5793
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

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08C0129FAB9
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 02:49:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725372AbgJ3Btf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 21:49:35 -0400
Received: from mail-eopbgr80044.outbound.protection.outlook.com ([40.107.8.44]:45367
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725781AbgJ3Bte (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 21:49:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jPmlgD4TIuSzBEbhmA4eXORD9Vi5A1Xvur7OWzuTRT3BWxPSW4S7SVUXrc/fTx2kvSfosYfcj5uYDN3hwLlJkkZUOQ4pBC0O2B04pGMsjFAQGKLFtjde4HxHzZlV0palga0GZ/TeOpWQPnoed3wq3UAWYIJsL4pmrEj6ZHw2fPbiJXDLxtSNnjslLUEMv7fdx2QPAAPavD6f3i7SqTL0a1QmFies9XACWWirsBMH0CFm2iNpvilNf2ZycgcMgC3IpTJ6GI1QDQpDfm3dQfjvESNk/1UHpzfN/hJnTO5GVJX7wwKVRzIqfnClmJdzufSBfN58L0oMsJS/aab6Be9byQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IdrHfXGbcwfCRLw79y5Jk89Kx7qQ494ItfTqZaRWEq8=;
 b=kkqwAkA52m7rP/dhryhpOlXU4meEr6t9Ng3ndg5LDSZlWXlSNJVhcexn7oVgEq3KBmE2c5SlXTU63FwGGdCXwARz87TIc+vU34TUG4wYsiKF0hcIt9Rbb8YUrVvBt6L+VLWcR2Sw1p/9EIJc7d3h+sAkB6W+tqqTttblCiOZjkKz5ut91Izi575Tqkf/7nzMyOlzRE2Sj5I+pwZaVv4c3C8PmSG0MbTqQcpYQfN3yCQKRNMrF4Z6G1jeSvXnCeKZ5WS84tUTiIUQI5RPlAdKKCxMqnJ+kp2w3ncLQBbcFIhEcdrhbJhOBb93zQnYnSNCFhEDVyKyf9QwGx7KzqOVAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IdrHfXGbcwfCRLw79y5Jk89Kx7qQ494ItfTqZaRWEq8=;
 b=oE5ZCJ0yKR7+ywGrNnARRsuDSqzKkydVih2AkT/pF8sN76hVYjHGq79kxbE54mDLG7eS09Qf/hfpzM1dkxPS3b52K5wibeybQb/Yio3UYPZc+ttLPXDxMTrlqXKTquxmllrcMZXjw2OMt5/y0gQAhc2QJ9GObzWkxJkyizeiuI0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0401MB2509.eurprd04.prod.outlook.com (2603:10a6:800:56::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Fri, 30 Oct
 2020 01:49:28 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3499.027; Fri, 30 Oct 2020
 01:49:28 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org, Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH v2 net-next 01/12] net: dsa: implement a central TX reallocation procedure
Date:   Fri, 30 Oct 2020 03:48:59 +0200
Message-Id: <20201030014910.2738809-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201030014910.2738809-1-vladimir.oltean@nxp.com>
References: <20201030014910.2738809-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.177]
X-ClientProxiedBy: AM0PR03CA0096.eurprd03.prod.outlook.com
 (2603:10a6:208:69::37) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.177) by AM0PR03CA0096.eurprd03.prod.outlook.com (2603:10a6:208:69::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Fri, 30 Oct 2020 01:49:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: aa1ad2f4-51d1-4c68-28dd-08d87c7609a9
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2509:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB250909084E540BEB33FF55A0E0150@VI1PR0401MB2509.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6+HGroyOfWWi0vf03PsWMULT6MVrq4xCPHLOfTyLi1/ZGhXnR61hbLdw76hs7uz6Vz2FRoDgahqdhM4+hfevV/jom2Rw/zWO/1ZJvLxrLXCWAd/akQR/RLA1f5qVgIEnWC/U5Spc6g5M52mijdWMD5rn9bmzUXqqQzB8wsNC37Pyey0JfbwtoMneW9zCb3B4tmGxJfmBW2bObvQur674USrQukuQhEzkLStfKiNWb9QFvAdCznK1kuSP+Gcpb6JJYFZ7ItgAO6Ac6qR33YIH8gO09sdgqqc9pwhwk7n6A8UzgBD+MoCl1bxlrnSgosFrT98DCI77ljBPSCNdjhA1MS2U+IrNf9yHDoCu9j1CIxKPWrKLQ7PRKXbtf1mhOUu6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(136003)(396003)(346002)(376002)(366004)(5660300002)(54906003)(16526019)(6506007)(66946007)(66476007)(1076003)(316002)(186003)(8676002)(69590400008)(36756003)(86362001)(44832011)(52116002)(6512007)(6486002)(66556008)(6666004)(956004)(6916009)(8936002)(478600001)(2616005)(26005)(2906002)(4326008)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: zP7mXCaGzvqSIV+FcHymc8MG+mExbxyqjgX5pgrYcY7tejvCE+8/RveNSpsHGKGg+Zg3Im0GrBHpVqJ7r6zk50dB/fa4DVuO86MOr5n8aHevQP55cIioilyCdT4nDj796DSRm7jKFRQCTXwVmnLyakEceQKg6jP3dl0+ncijwj/IMCj1B4ETO05bI4xsTwBERfQgkfo0xqn0mMjsRVPfL74cXQKM3WYraceWgvHHajmO/5XoxS+3oXb/jHL6QFhsFuoesutvWZ4+1qY/gJgFjYy1LK6hWvm4uzqKHby4tSHYyrbjzOyAZl9ffTiVbCJaGx4CJU0v+K0TvmNOORIpZ8owSfzjjvSaKcE/wAninZ9jfoYeaopGH5YDvqs+Bo908H3EbvLODd9O3yQ2F9Wk5+RGryKDH6aaT1uV4LzHJdq84vsjEosWgkMWLia51lfXHpKfMpe0C5oGUHiEI65Xffl8VsIlcNHje18ifJmRzDvAaJcIZs0CFU2ad1ba3gVTZg5BSrcl4QntenobuowHwn8Wm1lk/Kq6U/hJWxDYidHaSlMqLnpv0sPLNtBm5K9UUYADt/4VeiQJZ5s8SBNUrpYVisTyEI4iikGKQcTpPDWZ25X/WwlrJOn3yOJaoSS6sC2pF32LzKK3QvrOdt1p1w==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa1ad2f4-51d1-4c68-28dd-08d87c7609a9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2020 01:49:28.4950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 03EQ+hCKr1eqFfHMkc3R0tEzPw4vnuV1s6rgwT2FhCoPTI9f0cs3rinSsw19h+bPjaseUK+v0zyUilB/AVacSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2509
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At the moment, taggers are left with the task of ensuring that the skb
headers are writable (which they aren't, if the frames were cloned for
TX timestamping, for flooding by the bridge, etc), and that there is
enough space in the skb data area for the DSA tag to be pushed.

Moreover, the life of tail taggers is even harder, because they need to
ensure that short frames have enough padding, a problem that normal
taggers don't have.

The principle of the DSA framework is that everything except for the
most intimate hardware specifics (like in this case, the actual packing
of the DSA tag bits) should be done inside the core, to avoid having
code paths that are very rarely tested.

So provide a TX reallocation procedure that should cover the known needs
of DSA today.

Note that this patch also gives the network stack a good hint about the
headroom/tailroom it's going to need. Up till now it wasn't doing that.
So the reallocation procedure should really be there only for the
exceptional cases, and for cloned packets which need to be unshared.
The tx_reallocs counter should prove that.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Christian Eggers <ceggers@arri.de> # For tail taggers only
---
Changes in v2:
- Dropped the tx_realloc counters for now, since the patch was pretty
  controversial and I lack the time at the moment to introduce new UAPI
  for that.
- Do padding for tail taggers irrespective of whether they need to
  reallocate the skb or not.

 net/dsa/slave.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 3bc5ca40c9fb..10be715cf462 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -548,6 +548,30 @@ netdev_tx_t dsa_enqueue_skb(struct sk_buff *skb, struct net_device *dev)
 }
 EXPORT_SYMBOL_GPL(dsa_enqueue_skb);
 
+static int dsa_realloc_skb(struct sk_buff *skb, struct net_device *dev)
+{
+	int needed_headroom = dev->needed_headroom;
+	int needed_tailroom = dev->needed_tailroom;
+
+	/* For tail taggers, we need to pad short frames ourselves, to ensure
+	 * that the tail tag does not fail at its role of being at the end of
+	 * the packet, once the master interface pads the frame. Account for
+	 * that pad length here, and pad later.
+	 */
+	if (unlikely(needed_tailroom && skb->len < ETH_ZLEN))
+		needed_tailroom += ETH_ZLEN - skb->len;
+	/* skb_headroom() returns unsigned int... */
+	needed_headroom = max_t(int, needed_headroom - skb_headroom(skb), 0);
+	needed_tailroom = max_t(int, needed_tailroom - skb_tailroom(skb), 0);
+
+	if (likely(!needed_headroom && !needed_tailroom && !skb_cloned(skb)))
+		/* No reallocation needed, yay! */
+		return 0;
+
+	return pskb_expand_head(skb, needed_headroom, needed_tailroom,
+				GFP_ATOMIC);
+}
+
 static netdev_tx_t dsa_slave_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct dsa_slave_priv *p = netdev_priv(dev);
@@ -567,6 +591,17 @@ static netdev_tx_t dsa_slave_xmit(struct sk_buff *skb, struct net_device *dev)
 	 */
 	dsa_skb_tx_timestamp(p, skb);
 
+	if (dsa_realloc_skb(skb, dev)) {
+		kfree_skb(skb);
+		return NETDEV_TX_OK;
+	}
+
+	/* needed_tailroom should still be 'warm' in the cache line from
+	 * dsa_realloc_skb(), which has also ensured that padding is safe.
+	 */
+	if (dev->needed_tailroom)
+		eth_skb_pad(skb);
+
 	/* Transmit function may have to reallocate the original SKB,
 	 * in which case it must have freed it. Only free it here on error.
 	 */
@@ -1791,6 +1826,16 @@ int dsa_slave_create(struct dsa_port *port)
 	slave_dev->netdev_ops = &dsa_slave_netdev_ops;
 	if (ds->ops->port_max_mtu)
 		slave_dev->max_mtu = ds->ops->port_max_mtu(ds, port->index);
+	if (cpu_dp->tag_ops->tail_tag)
+		slave_dev->needed_tailroom = cpu_dp->tag_ops->overhead;
+	else
+		slave_dev->needed_headroom = cpu_dp->tag_ops->overhead;
+	/* Try to save one extra realloc later in the TX path (in the master)
+	 * by also inheriting the master's needed headroom and tailroom.
+	 * The 8021q driver also does this.
+	 */
+	slave_dev->needed_headroom += master->needed_headroom;
+	slave_dev->needed_tailroom += master->needed_tailroom;
 	SET_NETDEV_DEVTYPE(slave_dev, &dsa_type);
 
 	netdev_for_each_tx_queue(slave_dev, dsa_slave_set_lockdep_class_one,
-- 
2.25.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35DDC2A20F7
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 20:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbgKATRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 14:17:04 -0500
Received: from mail-eopbgr130045.outbound.protection.outlook.com ([40.107.13.45]:31354
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726790AbgKATRD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Nov 2020 14:17:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WqMxCWss/X5xw/SmkJMtQZLhTdItysO0T0jP4jgItfislJUmAOjpI+UHejelBvZl+5QsBkNju3X91wOkGA1H0CXDOo4BsF8lHtOmNgZOv/GndC4UV5WA9CT+6tZ1WRGrwG3iunGo+qupFGhMhqVQ+9pGf/2yGtybluKSJrQoVdFtmrPgOYgfiaoCbLw9JlKAaguwwlypuYxwuMd+KJ7bl0aJg7LHVIq0AzJMyFl2mExgX+VDnXlyJHUbibDHARVZXEFkDIiKVAgPijH5RhpJeloyDgkMJ0hbgHf595m8aZv3DUvhknLYeWqOKxBmgIIFc3tWE6tFWo2DS8uZkXgecg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4bU5m3RSw3i4Y6qEcui+Wv19KyDV70q3zFtJKz8nJ8U=;
 b=Isw0AjE850SOnr90AlD264sX7EemESYAH22RzMLHKnaHNWvjocGWlyC5FlHnKDhmTfxdKNs1H4zrr/xfUTCkJBTJ4y7fHI979WWPOd+ivZboIMwi2i6vvCwYJNuFV1EYlzSv+twKBO6RrrDisyl+pRlW6kOuK3uCDGzOnkHOAtRSLjiRrY80aKBycvmZFuxCyfs+fzMkFRq2w6ML/EKPWnobXFni+Rlvvd6Xm9b/DVD9aP3V9st8/BRhM1koSKYxNtd/yAPBWILRFwOu6nu5FbA7BTDai9PLdE9/jFwqC/XncFnCKGohWytY9wLYM0uZa2XmP2iHhN/GNCkDKaik6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4bU5m3RSw3i4Y6qEcui+Wv19KyDV70q3zFtJKz8nJ8U=;
 b=A3ETfi4jd+t9171lmRvcUXCuSMoEQ8ds0GTBjGU9OenFmMPMdrJuT10t0/pZElok5G6Hs6yOJfK5Px7kv9YzevVxY/oqtM3HvYua+cwVLDe5h54V70A8rC7fHScbP58Txfm4I/W0XjzWNQC+X8H3XnzOtKTmYMJgH2fV2vNmuUI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB2861.eurprd04.prod.outlook.com (2603:10a6:800:b5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Sun, 1 Nov
 2020 19:16:53 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3499.029; Sun, 1 Nov 2020
 19:16:53 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org, Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH v3 net-next 01/12] net: dsa: implement a central TX reallocation procedure
Date:   Sun,  1 Nov 2020 21:16:09 +0200
Message-Id: <20201101191620.589272-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201101191620.589272-1-vladimir.oltean@nxp.com>
References: <20201101191620.589272-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.177]
X-ClientProxiedBy: VI1PR0401CA0001.eurprd04.prod.outlook.com
 (2603:10a6:800:4a::11) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.177) by VI1PR0401CA0001.eurprd04.prod.outlook.com (2603:10a6:800:4a::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Sun, 1 Nov 2020 19:16:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ec46672b-20b8-44bf-7eed-08d87e9ab0cc
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2861:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB28610BCC13D1BA13D413BA16E0130@VI1PR0402MB2861.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AUCmkw9I9LNXupB1S7gzu88B4MvTYbv2XpOvdlC+8rdh8t+6fg4+aFKgYVB05ZkHlxnxjU/VMESWcZWxdvL/JxaDnRNRRy1id5YBHtc9R4VUi4n5dzOgfbxr1UpIQjJ15uJsQlouI+Zp4k/SKSIgoTJMkWdzRltCSjVzkZgyG2VjjZDcBSWvo+b0wFQrlJIYUsubv2Vr5W0OpYP9GR0NDXqmYD08mngKjQudug1xl8tb7giqLJw0/80gqi28g5q+DGged7zZN8Ap75KI1uPF3FN8VcCYa7qdf9rXP48xT/2a5txUu4hLqoTPbMkS+JduRO6ETJgYlJcg/ruOm0ODOe1Dls9vP1zOTO2cpCn3CQqKHefs9/YXKubmFz5V1bY3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(39850400004)(396003)(366004)(2906002)(8936002)(16526019)(6916009)(186003)(6506007)(86362001)(2616005)(8676002)(26005)(36756003)(66556008)(956004)(66946007)(5660300002)(478600001)(66476007)(6486002)(6666004)(52116002)(6512007)(4326008)(1076003)(83380400001)(44832011)(69590400008)(54906003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 16RKIGsh7TMLct9ESfxDQonBYqgHBe3rYpM85JPQhaBVrOq4/HqJ0j8y3alligYyzaNd0KUH4yJcF/MkZEKJNPI30VI8Q7PqtjVt3TnQ2krlTX4HbncNVuLBhOPzn/RXJGpY0Qkybg4StpOXdgqqk9e/vQwWxcfomGMaq1PWYNBSAix3xYlfb7RkSwLgvcYztdxtRaF4ZbGDvAXyKXzUIIraI1wk2+yjMOONU1jNoa2p4Ovu4XcOYLtP9Owg1h8Qx2rBIwjdyqzGOATycEebF2vlUQR9+NIlrchZHPlqcqdqHTM9WLwg5J/MFdJQ7nzELhSnW0k/NBdQJThIMxVN8Sgd9ZQjj3AnvgMzroQT39StJrMlzKyqur/iXdaoZA09eulmHdvCN/L1/T+ObTv7K6gELYt82oHRMg0b3ZM/S6ppDydLeBdroY7t9C7+Bgfd83O2MqrlGhoCVUAPDe01Sb58LQdHfCTheVmD3bHdw+S+7SHgHNc2tuLXGb2Dh8E3KW5w/vBaYAiTfit9tTGeg0wVLKSleoNg0FuFth184p9Kf8m4Q313Tx5UFqzC+k9zFxFn+X1l1XVKhKw58O6vEcdALJZVS75oAvHM/rykoaDqWG1a7nkLs1bcaVUyK6XFaLhXTpLLVrsw05zh/+83GA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec46672b-20b8-44bf-7eed-08d87e9ab0cc
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2020 19:16:53.0859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yXSLW/oc2nqS4HgZv1Od57gQhdhKbJ/sxq8CCasd4aoDC4IJOVBWlIgVLHQOiPoxiVWId1e1IqY6HCwRX62Pww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2861
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

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Christian Eggers <ceggers@arri.de> # For tail taggers only
Tested-by: Kurt Kanzenbach <kurt@linutronix.de>
---
Changes in v3:
- Use dev_kfree_skb_any due to potential hardirq context in xmit path.

Changes in v2:
- Dropped the tx_realloc counters for now, since the patch was pretty
  controversial and I lack the time at the moment to introduce new UAPI
  for that.
- Do padding for tail taggers irrespective of whether they need to
  reallocate the skb or not.

 net/dsa/slave.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 3bc5ca40c9fb..c6806eef906f 100644
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
+		dev_kfree_skb_any(skb);
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


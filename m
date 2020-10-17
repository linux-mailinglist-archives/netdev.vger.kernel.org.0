Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3BE82914BF
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 23:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439608AbgJQVgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 17:36:41 -0400
Received: from mail-eopbgr150051.outbound.protection.outlook.com ([40.107.15.51]:7653
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2439571AbgJQVgl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 17:36:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f3P3DpHkQMDstxjiHjtYWH2pEXGaFly/vmjY59jDbnd6ec/VN3vi3qth/GSG6yhble3g03vU/QXbQeroVE+0VaYK69M84ITOdk95lnEMFPIk4F28U2yKfo42FNXkuRX8b1203Kc0eJl9TKyFFiYbl3xbcnCw83C7gZ00ZHNtgKcHwwwq1ktVjQSyi1lxrX2EUeoUFBFO9oHPptkYKF/lQ3NKTMpaXSC0InbvW9aYu0bPTzkMkdD54VJeMECjMLf39lkrcO3f5u24TmmTZ+rXI/a3TXJC+raOK1qmHjZV3yiBynDxxBNnaSiDKVxzbRF+GiRgahuD2D43ujjnfqIoaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b8gUOKG5Bee1pGdc9TYtEtOQoMHjhQe02Y8ArCscsKo=;
 b=EKGBATztkqMXmmwB+15ohE55KwWgOEOy9Jx0qDVEAd6Qqqnv8EUOh8VTwTvYVZ28ydi+pRRsgB7GcTEoE/geKNlRamXnwjYRNwNUNidUcEOW19/ieQwnO6lA9TNiEYZ29Qr91z2vPGrpVyLGWFY/uADDR7rotj3Inj+BWy5k9OZyxryTtlJ+Dv13NhVN1IKY8dxL9a6MmyZgYQshLAmDNu37cK+ur07n/tJQSxGjRktHUEOTSUYjTNbjTrJBae0Tmdaa+iT6DK6v6blvdcp6amC0hfIR+fa3JPYmh9BEIH8RnhRSYGErGhc6gfGOfj3/MUD71tRMwa1MrLRC5gyD6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b8gUOKG5Bee1pGdc9TYtEtOQoMHjhQe02Y8ArCscsKo=;
 b=bvE8BgVYQfye3BYL8xVOXqREFLsQ8S7ZRapEKVi4Jb+kMSa6gQ1Dc9VT0SoplB1Io26Ecgc9OJ8yMeEE6BwFOPRIvqkjw+GtlejDe2sa474HBDjiVzSTZ64hVgWuF777DVqSZnTnDjJeIIQjbDXz9WkbWJW3qo1+xEXLK5dK/HE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5854.eurprd04.prod.outlook.com (2603:10a6:803:e2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20; Sat, 17 Oct
 2020 21:36:35 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3477.028; Sat, 17 Oct 2020
 21:36:35 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org, Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [RFC PATCH 02/13] net: dsa: implement a central TX reallocation procedure
Date:   Sun, 18 Oct 2020 00:36:00 +0300
Message-Id: <20201017213611.2557565-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201017213611.2557565-1-vladimir.oltean@nxp.com>
References: <20201017213611.2557565-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.174.215]
X-ClientProxiedBy: VI1P195CA0091.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:59::44) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.174.215) by VI1P195CA0091.EURP195.PROD.OUTLOOK.COM (2603:10a6:802:59::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20 via Frontend Transport; Sat, 17 Oct 2020 21:36:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4e97035c-cd77-4242-2b44-08d872e4b8a0
X-MS-TrafficTypeDiagnostic: VI1PR04MB5854:
X-Microsoft-Antispam-PRVS: <VI1PR04MB58542A9CC3C4FC12D47DE92BE0000@VI1PR04MB5854.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ICK65aeyGC1AkOKS4VkfH7SOakPd5lMByZCCYbuv698VjsgaFKw/YcjbbZsVJ/Hgb0NZozWzS6B+zAahlpis2MM5PuBsVduherD4ECI10G99NB9qeH27WL/2M/sZrZlk0wsL1pa7VNIqkpFmtntiSDGTfr08ISzdoBmfabo6e6dPjyhmRHA0qCfnJwqSJb+WQ17OAYkhIEClgixZ3zqywknRsBmDgHrHAppArifVhADBIX9NC4DwjroEeXpu2Lt7zvL3m9T9cKIp2WNtylsHNYOxYtJ4UeZbwKEibQv4LOfZ3MjjuPv/LrWUck0XCqLWDEY2E2nThCL1XMNQDmFdTC6iP63y9WlqYP7LYYvm9bMzDpV1EqnOi03iutOHd+Af
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(136003)(39850400004)(376002)(86362001)(2906002)(6506007)(66556008)(26005)(6666004)(16526019)(186003)(66946007)(1076003)(8936002)(66476007)(69590400008)(36756003)(5660300002)(316002)(4326008)(2616005)(54906003)(6916009)(52116002)(8676002)(478600001)(956004)(44832011)(6486002)(83380400001)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 09H2hoeAy9xUlPZx5a6vV5Icq1O+aVyZWN02oEBdoE0Gz6ZWO/y50/BU36TI1gYy4j7eM/KJXtWsM9YveUCNyOQODlRn5Cq6yqjYlqSFLuqCDsZjbq2utLnqHnhC1W4+7rjH89J5opZqAM1LM5WJAtoGgI3Z9VIqqmYyBauYhwmUinkdjfTKBzn16CVd9nXafUC1CXkJjvKhbaOJ7UYrE4BdcLGuVeR9GoFiVaGwqBZQiSCjnrIgvtmJjhdmOIfU9qYvhDglvg+G6FpF4ddUE6CAf7zqJoHHrTkWrv5M0LBJI88tCdSNqDxE14C2IkynR1+9BELUU0ILlV4/kL4A2QlIPN58LIubHmhN4E25ADF+MiUPfwkgpFoy8UoTvQm7wcRyoQAEZnE+/skYbZ+1b0hQwr1G++vdmu182kLV7CWPGS5s+iI7t5NCDvjjCdtyqgrZWsWslyHKDtKSjCvAZMKTXr4XZO70eriAipiTttoyzvdg89orwpewNqAl8ZLHVDmttGsY1G9xAhnKJ3HViNFMVfdMFFrrC8B5lSVNJ+I/3a7qJXo31Xkvu+WQ0FX7vwpbW27GDNTBRSOHJBCbMOj3uzjXuikigCVKwBGIEqGKS0dl8AxtpL1Q05R3kZGomj2s0zL0L9hSjUqCd8lhwA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e97035c-cd77-4242-2b44-08d872e4b8a0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2020 21:36:35.2487
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: atxCPOWRrEFILgvmJsPqwSwzjxC8jxSqAJOpckZkTbtpOLBbeE7jncMVRogjYYwI3zLxD4m7XkRXGBtw1m6ngA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5854
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
---
 net/dsa/slave.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index d4326940233c..790f5c8deb13 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -548,6 +548,36 @@ netdev_tx_t dsa_enqueue_skb(struct sk_buff *skb, struct net_device *dev)
 }
 EXPORT_SYMBOL_GPL(dsa_enqueue_skb);
 
+static int dsa_realloc_skb(struct sk_buff *skb, struct net_device *dev)
+{
+	struct net_device *master = dsa_slave_to_master(dev);
+	struct dsa_slave_priv *p = netdev_priv(dev);
+	struct dsa_slave_stats *e;
+	int headroom, tailroom;
+
+	headroom = dev->needed_headroom;
+	tailroom = dev->needed_tailroom;
+	/* For tail taggers, we need to pad short frames ourselves, to ensure
+	 * that the tail tag does not fail at its role of being at the end of
+	 * the packet, once the master interface pads the frame.
+	 */
+	if (unlikely(tailroom && skb->len < ETH_ZLEN))
+		tailroom += ETH_ZLEN - skb->len;
+
+	if (likely(skb_headroom(skb) >= headroom &&
+		   skb_tailroom(skb) >= tailroom) &&
+		   !skb_cloned(skb))
+		/* No reallocation needed, yay! */
+		return 0;
+
+	e = this_cpu_ptr(p->extra_stats);
+	u64_stats_update_begin(&e->syncp);
+	e->tx_reallocs++;
+	u64_stats_update_end(&e->syncp);
+
+	return pskb_expand_head(skb, headroom, tailroom, GFP_ATOMIC);
+}
+
 static netdev_tx_t dsa_slave_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct dsa_slave_priv *p = netdev_priv(dev);
@@ -567,6 +597,11 @@ static netdev_tx_t dsa_slave_xmit(struct sk_buff *skb, struct net_device *dev)
 	 */
 	dsa_skb_tx_timestamp(p, skb);
 
+	if (dsa_realloc_skb(skb, dev)) {
+		kfree_skb(skb);
+		return NETDEV_TX_OK;
+	}
+
 	/* Transmit function may have to reallocate the original SKB,
 	 * in which case it must have freed it. Only free it here on error.
 	 */
@@ -1802,6 +1837,14 @@ int dsa_slave_create(struct dsa_port *port)
 	slave_dev->netdev_ops = &dsa_slave_netdev_ops;
 	if (ds->ops->port_max_mtu)
 		slave_dev->max_mtu = ds->ops->port_max_mtu(ds, port->index);
+	/* Try to save one extra realloc later in the TX path (in the master)
+	 * by also inheriting the master's needed headroom and tailroom.
+	 * The 8021q driver also does this.
+	 */
+	if (cpu_dp->tag_ops->tail_tag)
+		slave_dev->needed_tailroom = cpu_dp->tag_ops->overhead;
+	else
+		slave_dev->needed_headroom = cpu_dp->tag_ops->overhead;
 	SET_NETDEV_DEVTYPE(slave_dev, &dsa_type);
 
 	netdev_for_each_tx_queue(slave_dev, dsa_slave_set_lockdep_class_one,
-- 
2.25.1


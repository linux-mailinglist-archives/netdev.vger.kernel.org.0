Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5C9279C28
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 21:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730219AbgIZTdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 15:33:16 -0400
Received: from mail-eopbgr130053.outbound.protection.outlook.com ([40.107.13.53]:17545
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730191AbgIZTdO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 15:33:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L45IN5QcYZr2CZEd0HO+I2ORPFyFrM/Noa00bMUQlNFW33TTV3QSrDgL+tYHHZr4/F06llPGsFV4Qi79mtFezvNC4BTOz9DG6UyH9wJnhOOdQLU9eYD4sRZpKEtd3y4XIT7DIpoTV0I1dVpTxhLZCTY2VLRrJ92wbOxQ5LO+Piq/9FuL96b5L36ZV62jT2AYAByTmjBIi7fttjlxrUm2Fia4PL4wpSXu6e/Ym8XvXCOd3NOCOgS6NAayT7mq03HDIrC2RwOUyVMjdUsAjUIUo9gXx+HwgA0dhVbariphiUg8rRbaixRtWBssJpBxEAud224EVQoz0t9aDtqNmRvzvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bfFdGBg8E4Rxtf+YUyYZQ5bglO2ciazKkHU12h/Kk1c=;
 b=Hn+50QIqUykAajeFNb8dk7d6p/UgCqRKKdDItsnJ0v5QhimtrhbaL8tG6jG9PfFN9HBcPUfAeGt68gentkLMNkwYtdGu4r0byGWvcm6HLGn9KxX8Iqh6iYPdGuVwNW7eRb1W+cozwomAt3hp6HVymD3FdEkZnqHf/qRRfZCRPWQnDO4+ZKs1WKKssBY1nEz6JkF59/kIVzi3hDr8ppig2w1u2JsK2BFEWZxw6ntpFIx3gF2+ygMfwBGbgsHM9oLuXpGiXfekevSJzZXt1E2XG8QCIiJNIt6F60U0DrLkXYmW8SFosSZCb5UxVw068kCYVHQTSrhjBPNNJuv7ZmA03g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bfFdGBg8E4Rxtf+YUyYZQ5bglO2ciazKkHU12h/Kk1c=;
 b=PNgm7hmNAQxh08GTB0EdTk4HMJfMJs9JGH4inaCFOb1eFpSGsAw0IMTkXw+eg2kl13ES/774Rnw3RYZhbv7Nkk3OFMeBemDSTbyViDKcVsinA9zqkKvjo1Sz++E5kM0WHHdnIPvNf2rGAX1/Y3wfmhif1dtkb8u8dXUeLbB3qFA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5295.eurprd04.prod.outlook.com (2603:10a6:803:59::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22; Sat, 26 Sep
 2020 19:33:03 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.024; Sat, 26 Sep 2020
 19:33:02 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org
Subject: [PATCH v3 net-next 04/15] net: dsa: tag_ocelot: use a short prefix on both ingress and egress
Date:   Sat, 26 Sep 2020 22:32:04 +0300
Message-Id: <20200926193215.1405730-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200926193215.1405730-1-vladimir.oltean@nxp.com>
References: <20200926193215.1405730-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4P190CA0017.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::27) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.217.212) by AM4P190CA0017.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.21 via Frontend Transport; Sat, 26 Sep 2020 19:33:01 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7521ef5b-61ef-408b-7402-08d86252fb94
X-MS-TrafficTypeDiagnostic: VI1PR04MB5295:
X-Microsoft-Antispam-PRVS: <VI1PR04MB5295E91A47DD4D2714FF156CE0370@VI1PR04MB5295.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jT22nvflA0sr4SHH4Y9cHPxcl7uLe//1zv7eZktueBam6JKLIhqNAvXoQ0hBvOx94+Z+UOToJrgUFMHuWIsl30GbQy7yNr4iLrxdI9aIULwyw1fF8dIq9gzq007SXFaj0vhZNXmoBz47eCTrdC0eeWUYMsNHUWeMDgqWDNWkH4QRvG4btfw3uS2sIYoDw+g5vF+lB4x7YA4KhN9L0ThtYE1PHbdQ1SkUc0mMZgMS4xZfPsanbQLwiZiHoTIcbr+x0fxNyi+eG8yptkjee7POZFmMbbiR1rYkIgbnUb9OpVH3SFwaf+CyDFcWve/0+WHUG5bjHW7yYWsKGfRkYAYtjVawdjT4H3SIq/FnR8+GX088cc4fKbeoz3uBp/oKn52AkK2VgdKbG+1YzJDWZ5lNkdyyyoQwGIBLCCU/BAPwZi25C8zAkiRJPI/baLo4CDE9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(376002)(346002)(136003)(66476007)(6486002)(52116002)(66556008)(2616005)(956004)(8676002)(44832011)(6512007)(26005)(2906002)(478600001)(16526019)(186003)(6506007)(36756003)(86362001)(8936002)(1076003)(83380400001)(4326008)(69590400008)(66946007)(316002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: VgsLv3P+jibAqiehh0x0/uP+7LB34o9WMF11x11DfgcP4IHAMYMpyZ3sQ/uNBfsKeYb9r1W04y6NyZAlwZE+i8tB7OZ37F4Q+4xpwlac1OpX1e+CcuJF5YS1WB8Fg1Z6q4MFGhCzhtdZByYm4rcfQovT/FgzRpgVHjR8JJ8MWcs9kpH73XRe/BWj4X3G/ulimbQEa5StovsOaHmxay8gRSsTszV+wxQ4OYTh3U1SumP6bAwMXyKFkiqRc6N/jS7UZncYulI+SppxIeuiaif1FlNdyu9rh3LLtnljjpInJ/QYt/xlylw7+1kkuU57jzEzSlf9nyDs+5t24w7TukfPRr4Ev7AycQGkQGl/WxQepQkGea3d35qvqkRm84WGkm82o/ePq4FA94tl7qOT8n/Uib5g8A3YJlQrSTLNBbkWJC+I+CKgR6ouifGvXDMkiOhw5kyAqD3KUQINDTzwttAKSfmWrASMPT/4I/9gL4wBmMNVU748CvgZecL22u+ppuo+FrS0JOezYoJPG+ZqG1CIMeJ5+NcwlcrxbK6pbzXfCuzbl5UJr9fuBw/Tyr6eOAmB8RfnZntVOrKomqeMJlle+QYN7iBGPLt0UT8e/WKLBMlZVcBs20/0/v5vzL9KZNlYl2wy/9PnpljHHXOtuN3Bdg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7521ef5b-61ef-408b-7402-08d86252fb94
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2020 19:33:02.2844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: crw10QdQVrFepMxyWpOZlmfZGgprDAl72QQde3fI85TOqXJHHLhwDccAAojWENdhU//zvCk6RX/i0MTmos3DVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5295
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are 2 goals that we follow:

- Reduce the header size
- Make the header size equal between RX and TX

The issue that required long prefix on RX was the fact that the ocelot
DSA tag, being put before Ethernet as it is, would overlap with the area
that a DSA master uses for RX filtering (destination MAC address
mainly).

Now that we can ask DSA to put the master in promiscuous mode, in theory
we could remove the prefix altogether and call it a day, but it looks
like we can't. Using no prefix on ingress, some packets (such as ICMP)
would be received, while others (such as PTP) would not be received.
This is because the DSA master we use (enetc) triggers parse errors
("MAC rx frame errors") presumably because it sees Ethernet frames with
a bad length. And indeed, when using no prefix, the EtherType (bytes
12-13 of the frame, bits 96-111) falls over the REW_VAL field from the
extraction header, aka the PTP timestamp.

When turning the short (32-bit) prefix on, the EtherType overlaps with
bits 64-79 of the extraction header, which are a reserved area
transmitted as zero by the switch. The packets are not dropped by the
DSA master with a short prefix. Actually, the frames look like this in
tcpdump (below is a PTP frame, with an extra dsa_8021q tag - dadb 0482 -
added by a downstream sja1105).

89:0c:a9:f2:01:00 > 88:80:00:0a:00:1d, 802.3, length 0: LLC, \
	dsap Unknown (0x10) Individual, ssap ProWay NM (0x0e) Response, \
	ctrl 0x0004: Information, send seq 2, rcv seq 0, \
	Flags [Response], length 78

0x0000:  8880 000a 001d 890c a9f2 0100 0000 100f  ................
0x0010:  0400 0000 0180 c200 000e 001f 7b63 0248  ............{c.H
0x0020:  dadb 0482 88f7 1202 0036 0000 0000 0000  .........6......
0x0030:  0000 0000 0000 0000 0000 001f 7bff fe63  ............{..c
0x0040:  0248 0001 1f81 0500 0000 0000 0000 0000  .H..............
0x0050:  0000 0000 0000 0000 0000 0000            ............

So the short prefix is our new default: we've shortened our RX frames by
12 octets, increased TX by 4, and headers are now equal between RX and
TX. Note that we still need promiscuous mode for the DSA master to not
drop it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
None.

 drivers/net/dsa/ocelot/felix.c           |  6 +++---
 drivers/net/dsa/ocelot/felix_vsc9959.c   | 13 ++++++++++---
 drivers/net/dsa/ocelot/seville_vsc9953.c | 13 ++++++++++---
 include/soc/mscc/ocelot.h                |  1 +
 net/dsa/tag_ocelot.c                     | 20 +++++++++++++-------
 5 files changed, 37 insertions(+), 16 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index b8e192374a32..ab3ee5c3fd02 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -439,8 +439,8 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 	ocelot->vcap_is2_actions= felix->info->vcap_is2_actions;
 	ocelot->vcap		= felix->info->vcap;
 	ocelot->ops		= felix->info->ops;
-	ocelot->inj_prefix	= OCELOT_TAG_PREFIX_NONE;
-	ocelot->xtr_prefix	= OCELOT_TAG_PREFIX_LONG;
+	ocelot->inj_prefix	= OCELOT_TAG_PREFIX_SHORT;
+	ocelot->xtr_prefix	= OCELOT_TAG_PREFIX_SHORT;
 
 	port_phy_modes = kcalloc(num_phys_ports, sizeof(phy_interface_t),
 				 GFP_KERNEL);
@@ -511,7 +511,7 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 			return PTR_ERR(target);
 		}
 
-		template = devm_kzalloc(ocelot->dev, OCELOT_TAG_LEN,
+		template = devm_kzalloc(ocelot->dev, OCELOT_TOTAL_TAG_LEN,
 					GFP_KERNEL);
 		if (!template) {
 			dev_err(ocelot->dev,
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 3ab6d6847c5b..2e9270c00096 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1155,6 +1155,8 @@ static void vsc9959_xmit_template_populate(struct ocelot *ocelot, int port)
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	u8 *template = ocelot_port->xmit_template;
 	u64 bypass, dest, src;
+	__be32 *prefix;
+	u8 *injection;
 
 	/* Set the source port as the CPU port module and not the
 	 * NPI port
@@ -1163,9 +1165,14 @@ static void vsc9959_xmit_template_populate(struct ocelot *ocelot, int port)
 	dest = BIT(port);
 	bypass = true;
 
-	packing(template, &bypass, 127, 127, OCELOT_TAG_LEN, PACK, 0);
-	packing(template, &dest,    68,  56, OCELOT_TAG_LEN, PACK, 0);
-	packing(template, &src,     46,  43, OCELOT_TAG_LEN, PACK, 0);
+	injection = template + OCELOT_SHORT_PREFIX_LEN;
+	prefix = (__be32 *)template;
+
+	packing(injection, &bypass, 127, 127, OCELOT_TAG_LEN, PACK, 0);
+	packing(injection, &dest,    68,  56, OCELOT_TAG_LEN, PACK, 0);
+	packing(injection, &src,     46,  43, OCELOT_TAG_LEN, PACK, 0);
+
+	*prefix = cpu_to_be32(0x8880000a);
 }
 
 static const struct felix_info felix_info_vsc9959 = {
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index b0ff90c0ae16..e28dd600f464 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1003,6 +1003,8 @@ static void vsc9953_xmit_template_populate(struct ocelot *ocelot, int port)
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	u8 *template = ocelot_port->xmit_template;
 	u64 bypass, dest, src;
+	__be32 *prefix;
+	u8 *injection;
 
 	/* Set the source port as the CPU port module and not the
 	 * NPI port
@@ -1011,9 +1013,14 @@ static void vsc9953_xmit_template_populate(struct ocelot *ocelot, int port)
 	dest = BIT(port);
 	bypass = true;
 
-	packing(template, &bypass, 127, 127, OCELOT_TAG_LEN, PACK, 0);
-	packing(template, &dest,    67,  57, OCELOT_TAG_LEN, PACK, 0);
-	packing(template, &src,     46,  43, OCELOT_TAG_LEN, PACK, 0);
+	injection = template + OCELOT_SHORT_PREFIX_LEN;
+	prefix = (__be32 *)template;
+
+	packing(injection, &bypass, 127, 127, OCELOT_TAG_LEN, PACK, 0);
+	packing(injection, &dest,    67,  57, OCELOT_TAG_LEN, PACK, 0);
+	packing(injection, &src,     46,  43, OCELOT_TAG_LEN, PACK, 0);
+
+	*prefix = cpu_to_be32(0x88800005);
 }
 
 static const struct felix_info seville_info_vsc9953 = {
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 349e839c4c18..3093385f6147 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -101,6 +101,7 @@
 #define OCELOT_TAG_LEN			16
 #define OCELOT_SHORT_PREFIX_LEN		4
 #define OCELOT_LONG_PREFIX_LEN		16
+#define OCELOT_TOTAL_TAG_LEN	(OCELOT_SHORT_PREFIX_LEN + OCELOT_TAG_LEN)
 
 #define OCELOT_SPEED_2500		0
 #define OCELOT_SPEED_1000		1
diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
index d1a7e224adff..ec16badb7812 100644
--- a/net/dsa/tag_ocelot.c
+++ b/net/dsa/tag_ocelot.c
@@ -141,10 +141,12 @@ static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
 	struct dsa_switch *ds = dp->ds;
 	struct ocelot *ocelot = ds->priv;
 	struct ocelot_port *ocelot_port;
+	u8 *prefix, *injection;
 	u64 qos_class, rew_op;
-	u8 *injection;
+	int err;
 
-	if (unlikely(skb_cow_head(skb, OCELOT_TAG_LEN) < 0)) {
+	err = skb_cow_head(skb, OCELOT_TOTAL_TAG_LEN);
+	if (unlikely(err < 0)) {
 		netdev_err(netdev, "Cannot make room for tag.\n");
 		return NULL;
 	}
@@ -153,7 +155,10 @@ static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
 
 	injection = skb_push(skb, OCELOT_TAG_LEN);
 
-	memcpy(injection, ocelot_port->xmit_template, OCELOT_TAG_LEN);
+	prefix = skb_push(skb, OCELOT_SHORT_PREFIX_LEN);
+
+	memcpy(prefix, ocelot_port->xmit_template, OCELOT_TOTAL_TAG_LEN);
+
 	/* Fix up the fields which are not statically determined
 	 * in the template
 	 */
@@ -187,11 +192,11 @@ static struct sk_buff *ocelot_rcv(struct sk_buff *skb,
 	 * so it points to the beginning of the frame.
 	 */
 	skb_push(skb, ETH_HLEN);
-	/* We don't care about the long prefix, it is just for easy entrance
+	/* We don't care about the short prefix, it is just for easy entrance
 	 * into the DSA master's RX filter. Discard it now by moving it into
 	 * the headroom.
 	 */
-	skb_pull(skb, OCELOT_LONG_PREFIX_LEN);
+	skb_pull(skb, OCELOT_SHORT_PREFIX_LEN);
 	/* And skb->data now points to the extraction frame header.
 	 * Keep a pointer to it.
 	 */
@@ -205,7 +210,7 @@ static struct sk_buff *ocelot_rcv(struct sk_buff *skb,
 	skb_pull(skb, ETH_HLEN);
 
 	/* Remove from inet csum the extraction header */
-	skb_postpull_rcsum(skb, start, OCELOT_LONG_PREFIX_LEN + OCELOT_TAG_LEN);
+	skb_postpull_rcsum(skb, start, OCELOT_TOTAL_TAG_LEN);
 
 	packing(extraction, &src_port,  46, 43, OCELOT_TAG_LEN, UNPACK, 0);
 	packing(extraction, &qos_class, 19, 17, OCELOT_TAG_LEN, UNPACK, 0);
@@ -231,7 +236,8 @@ static const struct dsa_device_ops ocelot_netdev_ops = {
 	.proto			= DSA_TAG_PROTO_OCELOT,
 	.xmit			= ocelot_xmit,
 	.rcv			= ocelot_rcv,
-	.overhead		= OCELOT_TAG_LEN + OCELOT_LONG_PREFIX_LEN,
+	.overhead		= OCELOT_TOTAL_TAG_LEN,
+	.promisc_on_master	= true,
 };
 
 MODULE_LICENSE("GPL v2");
-- 
2.25.1


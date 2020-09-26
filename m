Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE5F6279B70
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 19:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730056AbgIZRcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 13:32:11 -0400
Received: from mail-eopbgr40081.outbound.protection.outlook.com ([40.107.4.81]:45635
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726305AbgIZRcJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 13:32:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c3lx20ajJuXEhtE2LIHb3z/hpxTAOw4zk2bSDGNI3sqrp0yWlFHQtibUdaguopFceh7YAr3hwWqJb1dyxYXFX5BAzKs9d5a9ekdM91wVQuCItlzQ4ECna5ENJt1bf5mDgFQulZqY3xx0NuEw6mBqeBkvJG9XVLWOOFjsXWxf6tjq9Cn49uGURPj+0Tc1YvMfXrqkSZDb6NT/YmIGkMt3FA/0DwL7HYtH2whVjV/SRXOTsusCsjOAqdJ5sa1ircOMw+hHdH/tZ7AXJ4jVhf0WseOqindq7gQHmfqIZGuCiMjnotgjjDsYq/FEyVfBkaAOi8UmR8XOoxuDBPj6LjVDIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eKaeQuAVUUN7wyI3hy+osCNig7dhct7zrBtnjTFlDis=;
 b=kFSsovoVbZPtsc3mxe2rE55+3JWGqGdPeksfd6iXAhnxLvdX1BhFdwvfcbg7nLMTI0KxyJj93T6QRxFFEkYs1n3CpImYeS0HTljS0wUrMYPTLDHuvWhSvZ51q5b5vfnulc+8keqas3IhFmpJ5q48gLXn+zcRCwkLJ0NzmNdsLgevqiwQ4pc+1c34m45084w96DoU2MkrwcaOr2SHCBZSbL4vDoJwddDHaXrM3nJDn5621Pbc83ztKACX/kkWFjIris3QgbkuyvbfS+UsJbcZ5ePzxO3hjWhxFWCWl1N9WjFLyMfFsbcDFph3yqWnbOWFOSZ7jCPbBQOUImJwr/KrVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eKaeQuAVUUN7wyI3hy+osCNig7dhct7zrBtnjTFlDis=;
 b=RCV7YfFVrKAM1Yaw+tipiKa0BgCVIe//KIZerDHnVlVCHB+UqOXDdfp/9nJp1tWGVLQT+b1YL79mR5QBNIeR6ZJ+IfVFWABgbi8OYdqrVSg6WzNBHDPC8MShepDv7ytglauKvznm/+tebkKUjaXRG2DZ0nXR37e8ntOxmlxoDFE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB6640.eurprd04.prod.outlook.com (2603:10a6:803:122::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Sat, 26 Sep
 2020 17:31:24 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.024; Sat, 26 Sep 2020
 17:31:24 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org
Subject: [PATCH v2 net-next 04/16] net: dsa: tag_ocelot: use a short prefix on both ingress and egress
Date:   Sat, 26 Sep 2020 20:30:56 +0300
Message-Id: <20200926173108.1230014-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200926173108.1230014-1-vladimir.oltean@nxp.com>
References: <20200926173108.1230014-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0095.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::36) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.217.212) by AM0PR01CA0095.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22 via Frontend Transport; Sat, 26 Sep 2020 17:31:23 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5a9e357c-2f36-4448-50e5-08d86241fda6
X-MS-TrafficTypeDiagnostic: VE1PR04MB6640:
X-Microsoft-Antispam-PRVS: <VE1PR04MB6640DD4CF685408EDA19BA83E0370@VE1PR04MB6640.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zR2vA8c6TylmqUQ+DEUuKaPA1fvMSQdzaiZjggNi15BTk8Xr1qg3ro6cbUvXhGsKVVTEFyo8lf6nnB2ng5MhXpCWLvVOLPPGKL+bXzt1/O60eD8rtKXimDzlrRX6sgEk6+eUpyP5Cw+9IMNOtzxzLFQ69mJTmPvzAGzgJSoMcGHf/zjSwhqwzbwcVAsM0KtytqlTOR6TlCixkvG0oaWB1aUTuV4mqVsm6lu4MoAFXZfKc+ZR9xK/UGRsM8M2hIEaE/On+T24lKsj3TaB3fpRyKjct0HcRZAy1HjhcdQJ+uhGssDQRsttdbRVSEuY/Cw6YAO4wvKkNVs96olgnzP7zPsr0IZdjZVDDhFCm1FAGbEP3YkbRlwdw2fjZM47I4aTfWC5x28ATxVKbmX9PNpgIQtIPJhTrCVRrEh3Uja+VhATu1AeJvvEohTwSlq8+LHB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(376002)(346002)(136003)(956004)(8936002)(1076003)(6486002)(4326008)(5660300002)(52116002)(26005)(6506007)(66556008)(66476007)(2906002)(8676002)(36756003)(6666004)(44832011)(66946007)(316002)(16526019)(186003)(2616005)(478600001)(83380400001)(86362001)(6512007)(69590400008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 4Ne6hoQRopECXm9kNCTsOkvLHbma87Ic4FxrTzcCZfH1so4zlKuV7ikevQEJv8pVqVDreDVb1/ZIGY9gZwAJI1uufw8ACLln8BTiKugXlkJ00dpMOdn/uC49TYfzPpFvvSr5DiWBbt+zEPAEa2RS8J5XMW0yBwIJh7eM+fGHZh4q8dOCZshUF7X/Wp4ioK9njr8nvi5nYRvvX/wuSh2ZWdZR+wPww51nAW5gtEiQPzZC+CCL/GsRLOQDaZySSXLCNFkfzFQZAacvObCyIFxjpGZzUqlhf5PfdRr9aYDAZxwueiwhGKnvY56WZvIYpONvIrA3ZCEMDYhht9UjJ5uZNMoCVl+WUa2fzFENh5FpNIqUZnCIv30KqT3LNC0s1QBJxX4ZzQLxo3jlARqmCllsnRtWeXzkyBs8k4DKatPSrnz2RP4CNRLP2It5gX7uHNgAPxpVPk5PZ0ZnLkdYI4+uc8Z2ELSufAZ6JglBMSAkDu7w9z7IupF2CZ7X+O1+DXlPPBR07lhzg/uitPA3KTsr2dqFheiEVrAbpTkMel3++/CqVgfuRd139Fxh3BAFRGchojkQHAwSRrrLw8N2kBnvDqcjTzWkvNEXPB8qI/67CvTpj/pchhLFKTNlXFvrjLnMale7dbX/B7GPHso7zzJzng==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a9e357c-2f36-4448-50e5-08d86241fda6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2020 17:31:24.2755
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ++rMJ91HUatc/tdZujkzXTJBmXdJJ695WIsWEk4u+W5qhXEXBPlQhIxl+/j30hz7JelkGl8j++MYjkHihgJi0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6640
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
 drivers/net/dsa/ocelot/felix.c           |  7 ++++---
 drivers/net/dsa/ocelot/felix_vsc9959.c   | 13 ++++++++++---
 drivers/net/dsa/ocelot/seville_vsc9953.c | 13 ++++++++++---
 include/soc/mscc/ocelot.h                |  1 +
 net/dsa/tag_ocelot.c                     | 19 ++++++++++++-------
 5 files changed, 37 insertions(+), 16 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index b8e192374a32..897e013d89eb 100644
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
@@ -618,6 +618,7 @@ static int felix_setup(struct dsa_switch *ds)
 				 ANA_FLOODING_FLD_UNICAST(PGID_UC),
 				 ANA_FLOODING, tc);
 
+	ds->promisc_on_master = true;
 	ds->mtu_enforcement_ingress = true;
 	ds->configure_vlan_while_not_filtering = true;
 
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
index d1a7e224adff..fb6d006eb986 100644
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
@@ -231,7 +236,7 @@ static const struct dsa_device_ops ocelot_netdev_ops = {
 	.proto			= DSA_TAG_PROTO_OCELOT,
 	.xmit			= ocelot_xmit,
 	.rcv			= ocelot_rcv,
-	.overhead		= OCELOT_TAG_LEN + OCELOT_LONG_PREFIX_LEN,
+	.overhead		= OCELOT_TOTAL_TAG_LEN,
 };
 
 MODULE_LICENSE("GPL v2");
-- 
2.25.1


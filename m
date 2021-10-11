Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC8E24298DC
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 23:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235290AbhJKV2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 17:28:48 -0400
Received: from mail-eopbgr40088.outbound.protection.outlook.com ([40.107.4.88]:16861
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235294AbhJKV2q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Oct 2021 17:28:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UfOuacJrdXsb9ArkAJXYCbzjbp04UgYgShSnwTNohoMRzlvPh9ZopCzHzAO2i+qza5oTmSYbDW6O2nmN7MKPWzWbUg9SRjevy252CosleR/HFQ9uutWnYFyl8DAqTsrZv4EFZINZVaZRcygQyoNq64BFAk4uMve51NPR1p1Zn3mBYG1BTK+ylZ1f3pAQwXTLjcWKbiKRHCQheBR4vuKu6a7vOX3znMix4i0dVvlp8A7tQRb1o4NDBhXwvN6RNR5cM/zeCB6oRGYFJ5tvhyR0QEwu/z2uCXe+jwGY+P7+hW8FKeE9tLOT9IKXPwTUur+Ky0g+Puh9JhRZ41VDRSZHfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vzULDl1yeV1OWZavdm7Q/atwx1EtLKgL2p1rJrAtI1c=;
 b=W3y7iWf9F9hXFe3/oDDs8pki0+bhyPGAeiM9CHmNvGa5jPEomo2DGy6mvHLbIg9AVEhCGDC4nc22LmwBzFh25puuccD1LeXhFfIW/pJvEzIQSvRe8MZI7Mdw902V8N34aYlk5uSCvvimvPkyduYQtIBCxeHF/i7zv7ExrSsAxksQyZwFt4krYVSbuQOSUoOIcs01D9sYYwIEPd1WhjLWaReE8bIHms8q7vMO5VWTO/fL3llyYazd8X0ZTuCwsHr3TcPOjrOvmgEPBROZy1C9URQXFVEsdlswY0HxQJ8eCqIbGA9R+rO/Q14dqKjLuGwwqFN8KLUmz50ce5PLF53l2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vzULDl1yeV1OWZavdm7Q/atwx1EtLKgL2p1rJrAtI1c=;
 b=MoDQkyUXVEMcgmgKb6+iqQouPbUW6kWKNom6K18VWyntVgcpK9yhji0LijmdsIXKYXQZQst6HSv1yh5W4gcuujwkitR7Thcz/5Tm8BPb4I8tD2Vs+Upf8Ydy/ASLr5MuLRceobQMHOL6AsWoy831fLRHo+wolvhdSUAl72gf2Ns=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (20.177.49.83) by
 VE1PR04MB6703.eurprd04.prod.outlook.com (10.255.118.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.25; Mon, 11 Oct 2021 21:26:37 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4587.026; Mon, 11 Oct 2021
 21:26:37 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, Po Liu <po.liu@nxp.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Rui Sousa <rui.sousa@nxp.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net 06/10] net: dsa: tag_ocelot: break circular dependency with ocelot switch lib driver
Date:   Tue, 12 Oct 2021 00:26:12 +0300
Message-Id: <20211011212616.2160588-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211011212616.2160588-1-vladimir.oltean@nxp.com>
References: <20211011212616.2160588-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0260.eurprd07.prod.outlook.com
 (2603:10a6:803:b4::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.53.217) by VI1PR07CA0260.eurprd07.prod.outlook.com (2603:10a6:803:b4::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.4 via Frontend Transport; Mon, 11 Oct 2021 21:26:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a6d3cfa-2188-45b1-d6b9-08d98cfdce94
X-MS-TrafficTypeDiagnostic: VE1PR04MB6703:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB6703342176B5B889D353E662E0B59@VE1PR04MB6703.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1013;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XnbQv8a1qRsgLkF8uJNJRAnzqID6PUCT1pWAQ+C1ak6BwkkGSvOOTnYUGxOy0Gs1k3f+uziwtMjJimdtsInt8h2GFig7+VGsu1Hhb82gzFfKcsfp3dAj2WQqN6dUuvziGDuVLQRjpS+SCzDpT+qmnWuNAYc9eCWTwvXhSf/mcCiy9yRxFeVmGwyTn9vGCk2sNYE2xQjOA/UNlUupRk1O8C5Q2WKOE+4JF23fXd08YXjG7H3KbxwE1DaAcAY+HlNlpnTmaKDRpHeDol5ws0TatrwqvwfeCcbrIo7mDW3H1O0jLsYLsYzzmfhSRl5EjD7BbtX0cMtjlIB1+oyQSee8RFlMVCm3zlTN1cg7vPHgd/xD+l/mux+XcJc0/51JNm8Ne1kDQGlRMI2CeDcbXRaPd69GAhcFFDowv0hiXja+CotKPRcM6Kc/ZrTByLslQcIGMD6ImuKt39lWoIppTwJEYoDbw5WnsuYHx4Pv4GTardVYcD3ULb7IXthAHZai5yKcWu1sMjrnRrFk7lmazy7D2K09USudMUI2bML+u6oAL+ToqqtTPnjNnr6BpYV1v8trtZ9syV5STaKXVUxxKvlCKKnoDGkkmQ3/9YgxU0OlC1w9/Niy3VirHuMYc9adB5m89GOe8zdJkoPVpI3KS4Sj1yck5smHywSILJu94V8B/9HmimxCjDsQplAs+Ss/Vo4/bPwQmZJVpkAf9ce8vtyX+qA+XqO9jHUH8ySjT6SjVjveaQ4dC8V4eaAofh2CJUFOqDm4FPmEwkdMSejYPQ1GVeK8nMkbWsZx6dOQJlP+j4g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(52116002)(36756003)(1076003)(2906002)(6636002)(86362001)(66476007)(66556008)(8936002)(7416002)(6506007)(966005)(6486002)(66946007)(6512007)(508600001)(6666004)(2616005)(8676002)(5660300002)(38100700002)(38350700002)(4326008)(316002)(956004)(26005)(54906003)(110136005)(44832011)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?l0ALS5Bi3UgVVQXBHJxqHs2CUWlawxi6DrjhXPQJDYVjQbcani/5QGFX8t0I?=
 =?us-ascii?Q?g7Xa/EMHg4s46AOOBCODGmTX8aq0q4Jlv09ycFyadG9rWRz4Ef55njIUH9Go?=
 =?us-ascii?Q?fME/TRsMprJkad6agWqfHDATO5RJs7tNEJRWH4jyR4JNT28XoSv8hPxVgAuT?=
 =?us-ascii?Q?ICPe8NuYD3ryX6jePfL/2gdNCjgP9slr3zOD3nkORX/BJs/e/hzSsO5eSyOs?=
 =?us-ascii?Q?o63Alu2o8ZGFMrwoT9FbKPkJcl71MkrjxEJegbJkriHIwq45YNzx8y+jWgxN?=
 =?us-ascii?Q?sQxzgf86bnQkHFqp/G0TBI5FJLq0ZYHi3yADIc9N6ZkUt2IEmAfSspHGSA+P?=
 =?us-ascii?Q?lfPQfw44/zKjLh+y0u7XXuzFKCx8dfPpamcPLHhrKTV7T3eMe0vrogjMvc4G?=
 =?us-ascii?Q?axE2+VLAink8mhaGIOXP+rK8b0GaIR5NmXs+hT9Zpn5O2MLXu4SRHEVxTpfU?=
 =?us-ascii?Q?zwfslOdqDQfl4l0X/BxhCTZdKetcNat0ZG9/oTLs8Qt8G9ncofaa5cifHLMl?=
 =?us-ascii?Q?C2rcN2KRs8MUW9l2RJ+tWd3ZMjAsQ4sjkcoABDPZpQ6AnqN7SorSUKezHB5i?=
 =?us-ascii?Q?qoNzFdMXfAOrimT4XcWfBbmPLvMCQWViIerrZ19jYogDi0UkHJKHAB2BnggO?=
 =?us-ascii?Q?elVoPUtdx92OxLHy7Qmwyj/6ZlskDj4XdADFPPKoZF4e3jylC09kD+wkAVHi?=
 =?us-ascii?Q?VcGUMS0qqjvruVpwGZjU3zQpeyzOwCLDAhxYBHdy01MGMOjBYUmStk99Rl23?=
 =?us-ascii?Q?kLqryKzZqsnBnMgc3xGExd5joJsmLIzn1WtkBZE/sdCLe6iQ59KPlcQnWxpM?=
 =?us-ascii?Q?lf/jkKBjpxowHXgjtAMyY2hRYa/j007NggdRV4xNxqyUiB0sum4wMJGGrbO6?=
 =?us-ascii?Q?KuBtf0bo7G7buSDduIrP6A3o/aZ9114ozoIfuJTJp7VjNHTZr5vqYDW3P57D?=
 =?us-ascii?Q?s9FI5JI3IRKhNDaB4clJriM4da1O1rv95gZ/7fBeNe1AdsYwi+AruVUHB5lK?=
 =?us-ascii?Q?1OLBADEbVj/KDNS6/L9NfBHu5lBrkm79EGkzC5Lag0GUIBvTVRADOQddxqBG?=
 =?us-ascii?Q?WJWR18TngoY6dmfYACzXLb4Qq+N62Dez08CdDd4Ogkvzykm7v4bKv2MLa6wY?=
 =?us-ascii?Q?fOIdHj20/urC1JL2QW3IIBCQBuLNUbesMXQfk359xBh+Z4WofdCyNGDjHCGH?=
 =?us-ascii?Q?jVuVnZuXyV3watd075erftPM5LZN0v+YDit/H3YbFZR3o8etEglC+jD8qEwD?=
 =?us-ascii?Q?ylTEcP4h216x0iDr+2tYaiuS78FSRjZV6vN9rPMdNWMXLwD5YxXZeXhrwQcx?=
 =?us-ascii?Q?mzkJnsASVkxqfcABwOGDlwb1?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a6d3cfa-2188-45b1-d6b9-08d98cfdce94
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2021 21:26:37.1690
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WESYRcKqc6J2s1hlAXeLSFWRLZIT7e5aiTGAYnJWiH6GkfknpesByMiCt961LmfUmQTz7oP/2kk+K5km/2XPbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6703
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As explained here:
https://lore.kernel.org/netdev/20210908220834.d7gmtnwrorhharna@skbuf/
DSA tagging protocol drivers cannot depend on symbols exported by switch
drivers, because this creates a circular dependency that breaks module
autoloading.

The tag_ocelot.c file depends on the ocelot_ptp_rew_op() function
exported by the common ocelot switch lib. This function looks at
OCELOT_SKB_CB(skb) and computes how to populate the REW_OP field of the
DSA tag, for PTP timestamping (the command: one-step/two-step, and the
TX timestamp identifier).

None of that requires deep insight into the driver, it is quite
stateless, as it only depends upon the skb->cb. So let's make it a
static inline function and put it in include/linux/dsa/ocelot.h, a
file that despite its name is used by the ocelot switch driver for
populating the injection header too - since commit 40d3f295b5fe ("net:
mscc: ocelot: use common tag parsing code with DSA").

With that function declared as static inline, its body is expanded
inside each call site, so the dependency is broken and the DSA tagger
can be built without the switch library, upon which the felix driver
depends.

Fixes: 39e5308b3250 ("net: mscc: ocelot: support PTP Sync one-step timestamping")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c     | 17 ------------
 drivers/net/ethernet/mscc/ocelot_net.c |  1 +
 include/linux/dsa/ocelot.h             | 37 ++++++++++++++++++++++++++
 include/soc/mscc/ocelot.h              | 24 -----------------
 net/dsa/Kconfig                        |  2 --
 net/dsa/tag_ocelot.c                   |  1 -
 net/dsa/tag_ocelot_8021q.c             |  1 +
 7 files changed, 39 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index cf9c2aded2b5..c4171ca30ceb 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -601,23 +601,6 @@ static int ocelot_port_add_txtstamp_skb(struct ocelot *ocelot, int port,
 	return 0;
 }
 
-u32 ocelot_ptp_rew_op(struct sk_buff *skb)
-{
-	struct sk_buff *clone = OCELOT_SKB_CB(skb)->clone;
-	u8 ptp_cmd = OCELOT_SKB_CB(skb)->ptp_cmd;
-	u32 rew_op = 0;
-
-	if (ptp_cmd == IFH_REW_OP_TWO_STEP_PTP && clone) {
-		rew_op = ptp_cmd;
-		rew_op |= OCELOT_SKB_CB(clone)->ts_id << 3;
-	} else if (ptp_cmd == IFH_REW_OP_ORIGIN_PTP) {
-		rew_op = ptp_cmd;
-	}
-
-	return rew_op;
-}
-EXPORT_SYMBOL(ocelot_ptp_rew_op);
-
 static bool ocelot_ptp_is_onestep_sync(struct sk_buff *skb,
 				       unsigned int ptp_class)
 {
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index e54b9fb2a97a..e7fe5dbd8726 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -8,6 +8,7 @@
  * Copyright 2020-2021 NXP
  */
 
+#include <linux/dsa/ocelot.h>
 #include <linux/if_bridge.h>
 #include <linux/of_net.h>
 #include <linux/phy/phy.h>
diff --git a/include/linux/dsa/ocelot.h b/include/linux/dsa/ocelot.h
index 435777a0073c..50641a7529ad 100644
--- a/include/linux/dsa/ocelot.h
+++ b/include/linux/dsa/ocelot.h
@@ -6,6 +6,26 @@
 #define _NET_DSA_TAG_OCELOT_H
 
 #include <linux/packing.h>
+#include <linux/skbuff.h>
+
+struct ocelot_skb_cb {
+	struct sk_buff *clone;
+	unsigned int ptp_class; /* valid only for clones */
+	u8 ptp_cmd;
+	u8 ts_id;
+};
+
+#define OCELOT_SKB_CB(skb) \
+	((struct ocelot_skb_cb *)((skb)->cb))
+
+#define IFH_TAG_TYPE_C			0
+#define IFH_TAG_TYPE_S			1
+
+#define IFH_REW_OP_NOOP			0x0
+#define IFH_REW_OP_DSCP			0x1
+#define IFH_REW_OP_ONE_STEP_PTP		0x2
+#define IFH_REW_OP_TWO_STEP_PTP		0x3
+#define IFH_REW_OP_ORIGIN_PTP		0x5
 
 #define OCELOT_TAG_LEN			16
 #define OCELOT_SHORT_PREFIX_LEN		4
@@ -215,4 +235,21 @@ static inline void ocelot_ifh_set_vid(void *injection, u64 vid)
 	packing(injection, &vid, 11, 0, OCELOT_TAG_LEN, PACK, 0);
 }
 
+/* Determine the PTP REW_OP to use for injecting the given skb */
+static inline u32 ocelot_ptp_rew_op(struct sk_buff *skb)
+{
+	struct sk_buff *clone = OCELOT_SKB_CB(skb)->clone;
+	u8 ptp_cmd = OCELOT_SKB_CB(skb)->ptp_cmd;
+	u32 rew_op = 0;
+
+	if (ptp_cmd == IFH_REW_OP_TWO_STEP_PTP && clone) {
+		rew_op = ptp_cmd;
+		rew_op |= OCELOT_SKB_CB(clone)->ts_id << 3;
+	} else if (ptp_cmd == IFH_REW_OP_ORIGIN_PTP) {
+		rew_op = ptp_cmd;
+	}
+
+	return rew_op;
+}
+
 #endif
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index cabacef8731c..66b2e65c1179 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -89,15 +89,6 @@
 /* Source PGIDs, one per physical port */
 #define PGID_SRC			80
 
-#define IFH_TAG_TYPE_C			0
-#define IFH_TAG_TYPE_S			1
-
-#define IFH_REW_OP_NOOP			0x0
-#define IFH_REW_OP_DSCP			0x1
-#define IFH_REW_OP_ONE_STEP_PTP		0x2
-#define IFH_REW_OP_TWO_STEP_PTP		0x3
-#define IFH_REW_OP_ORIGIN_PTP		0x5
-
 #define OCELOT_NUM_TC			8
 
 #define OCELOT_SPEED_2500		0
@@ -695,16 +686,6 @@ struct ocelot_policer {
 	u32 burst; /* bytes */
 };
 
-struct ocelot_skb_cb {
-	struct sk_buff *clone;
-	unsigned int ptp_class; /* valid only for clones */
-	u8 ptp_cmd;
-	u8 ts_id;
-};
-
-#define OCELOT_SKB_CB(skb) \
-	((struct ocelot_skb_cb *)((skb)->cb))
-
 #define ocelot_read_ix(ocelot, reg, gi, ri) __ocelot_read_ix(ocelot, reg, reg##_GSZ * (gi) + reg##_RSZ * (ri))
 #define ocelot_read_gix(ocelot, reg, gi) __ocelot_read_ix(ocelot, reg, reg##_GSZ * (gi))
 #define ocelot_read_rix(ocelot, reg, ri) __ocelot_read_ix(ocelot, reg, reg##_RSZ * (ri))
@@ -765,7 +746,6 @@ void ocelot_port_inject_frame(struct ocelot *ocelot, int port, int grp,
 int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp, struct sk_buff **skb);
 void ocelot_drain_cpu_queue(struct ocelot *ocelot, int grp);
 
-u32 ocelot_ptp_rew_op(struct sk_buff *skb);
 #else
 
 static inline bool ocelot_can_inject(struct ocelot *ocelot, int grp)
@@ -789,10 +769,6 @@ static inline void ocelot_drain_cpu_queue(struct ocelot *ocelot, int grp)
 {
 }
 
-static inline u32 ocelot_ptp_rew_op(struct sk_buff *skb)
-{
-	return 0;
-}
 #endif
 
 /* Hardware initialization */
diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index 548285539752..208693161e98 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -101,8 +101,6 @@ config NET_DSA_TAG_RTL4_A
 
 config NET_DSA_TAG_OCELOT
 	tristate "Tag driver for Ocelot family of switches, using NPI port"
-	depends on MSCC_OCELOT_SWITCH_LIB || \
-		   (MSCC_OCELOT_SWITCH_LIB=n && COMPILE_TEST)
 	select PACKING
 	help
 	  Say Y or M if you want to enable NPI tagging for the Ocelot switches
diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
index 8025ed778d33..605b51ca6921 100644
--- a/net/dsa/tag_ocelot.c
+++ b/net/dsa/tag_ocelot.c
@@ -2,7 +2,6 @@
 /* Copyright 2019 NXP
  */
 #include <linux/dsa/ocelot.h>
-#include <soc/mscc/ocelot.h>
 #include "dsa_priv.h"
 
 static void ocelot_xmit_common(struct sk_buff *skb, struct net_device *netdev,
diff --git a/net/dsa/tag_ocelot_8021q.c b/net/dsa/tag_ocelot_8021q.c
index 59072930cb02..1e4e66ea6796 100644
--- a/net/dsa/tag_ocelot_8021q.c
+++ b/net/dsa/tag_ocelot_8021q.c
@@ -9,6 +9,7 @@
  *   that on egress
  */
 #include <linux/dsa/8021q.h>
+#include <linux/dsa/ocelot.h>
 #include <soc/mscc/ocelot.h>
 #include <soc/mscc/ocelot_ptp.h>
 #include "dsa_priv.h"
-- 
2.25.1


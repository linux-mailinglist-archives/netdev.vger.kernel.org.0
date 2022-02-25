Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4791A4C4157
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 10:24:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239021AbiBYJXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 04:23:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239010AbiBYJXo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 04:23:44 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70078.outbound.protection.outlook.com [40.107.7.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7023B1A6F8B
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 01:23:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QJ+r9AhdanpmDsaiPbzWyjUnUTAt9k0VsQSTid5iL6WqMIXOrmovkbydX56Kuvusna/NKYYrIxiYigFHf8DrKBOf2teAiW2AfYO6W4UQtWXgqeklNVuk3t6rGD3o3moVYeC1wJ4+wKWXBPlTT/m0VF9mbvVeNhKy0BtGs314l1P0o1BAEnjHPizcwwgoQx2r8HfBBRtblCs2F4Xig0pUvnDTMll5Bn+NT5gceC+f6P+s2R2eGgOuqLvxLynLy1n2dMYv/w4YHnnO4C62Lyc+H/eadjI/7CigqdZdbZT/TauyivUoJK4lzpzufaNquB2JsQt1jdo+R4ECeytqTjeUMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0UYswjJ/crog+znskhqBwv25GOyoUm+n0+Tg+/Jtrag=;
 b=Ca/FTlY0ieTZJIRl5p1d08JwuMHvRTSpQPLECKYKBnJRYPB1mSMSxBL45Z65X+2ORBCCttQbCW0EsSzEXKcJGHaTude+izZOyWXsIGYVl6jeXk80KVD1Sl50Z8VauDaFhAnkF8pF3v2La8LxpOOPEOCL+xOUjNXShqV9xuru0cW7vmA9iGGnW5orPFFmqYpur3RrCh+vUPPzY9oKGugLbm7LnMoxokyRkMl36iDqh678JRsPt1lyYUVgbojcgV9pG3cihC7TgyN/k/8cbR6bGfh44Ag7twVb5BhRA8qC1JL96n/yAr2oXhyWcyydlrRz5ZsYGl9HeDZC/yBstFmGuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0UYswjJ/crog+znskhqBwv25GOyoUm+n0+Tg+/Jtrag=;
 b=VBrrtgeEWIvsGqaKjcgEbYCMOh5na9FSDYTgdY/VAtlNi7yyqDHrhDSJ8+VBIVTSj1RKM+J5kvPBxnWq/Mc4hsVtLwdbrao8ZcKkSXPF1TdoEnbh+mI+Ytr43mkV6ILPgWlV0rQDLvkIrouCmXv2YOTRkI9NU+dc/30sFjzxZAo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DBBPR04MB7658.eurprd04.prod.outlook.com (2603:10a6:10:20d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.25; Fri, 25 Feb
 2022 09:23:07 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Fri, 25 Feb 2022
 09:23:07 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH v2 net-next 06/10] net: dsa: tag_8021q: rename dsa_8021q_bridge_tx_fwd_offload_vid
Date:   Fri, 25 Feb 2022 11:22:21 +0200
Message-Id: <20220225092225.594851-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220225092225.594851-1-vladimir.oltean@nxp.com>
References: <20220225092225.594851-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR02CA0065.eurprd02.prod.outlook.com
 (2603:10a6:802:14::36) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3a44c6a4-ccbe-4fcf-eff1-08d9f8406e9b
X-MS-TrafficTypeDiagnostic: DBBPR04MB7658:EE_
X-Microsoft-Antispam-PRVS: <DBBPR04MB7658E5F6EB63E4BBA62899ADE03E9@DBBPR04MB7658.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O2RvPhTumY2GBKL2zozSpKkjHWSQdVlUF+AVVkaKlxuMgFFwXRfw65+weSjIHutL6t0Ce6+IOlsK5kUrxzPVeTizQJ/iPfhn+cHPvvTUq1dlaAXp8qRZJQkOeQXgrJlp6Ba+rMI0M4YtV9pTwhg7YfxtdcaxwBnOKRwTrvViWFzTyLxw3mrXmud9Rxm0aJpdQdG1ZMUykKJ1M2vlU6tK3EjLyo44lBRljBomAWPRfyxzA6N3ct1zE2+VZSeyClXN6HmKtLgS9peo2niNbwfTQlBxSIvg4ITzuxtelpFEV45fj4UsfeqtdihrWEIZHoPufr7R87BlhHbv+eAIP1yELZ2jLp/g1RJ2TxHXd9ZMODMbDvtJX31M1SK9YsfNouFHzCL+tf+UkV9BvMFfhnbILC5xDtxls1Gi0fE6DT4eYC/8xkDx7PDD+eOhwS1581DQBHQ+72/VddPkKPJr2J/UzJwP4sSFG8Q0bOJJTQTrsiL/R9opt5zRh+U8OEWACVyhf2Nu4xpKPm1cWHoxMrbDarcPmgwc4KrREd+mA73h4ICk2gou5z49696GTOIepIudTOS5L6BZ9WEBWV0BV45lTz6vnWc6nHCWrhDyoDDx1x27cb9eu3RX6u76ZwjT6exfBflr7WUYavbIgJjuYJK5mhhkRiXpxWfqGpYyWFl3l1G0KM4jnbkZgFLrD7l73EVnwPfLeJ/HUQpfDcjseJOD/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(54906003)(4326008)(316002)(38100700002)(8676002)(110136005)(6486002)(6666004)(38350700002)(86362001)(8936002)(6506007)(52116002)(36756003)(66946007)(7416002)(26005)(186003)(66556008)(66476007)(1076003)(6512007)(44832011)(83380400001)(5660300002)(2906002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3yvwCbB3ohGULwroj2CqxeA0oSAvLU+ZQeHjxmqrcBAF3UR+uOiIiIY0cEVG?=
 =?us-ascii?Q?0bafClVTvEz+5UdLPmzTBVGrhPKtx9X5Nfyr1pWx1cx+gNYl2jsUd+y5c4Q5?=
 =?us-ascii?Q?YvN1A4nAyAVac1VwJrmOxqor+8KizukfEVKpXqfzAqRUIf32PHOaEki4EeKn?=
 =?us-ascii?Q?YokrPdRkPOsEIhvAHswCYhbYLNBEJ5KAaZ2TL884wZnCVU9lCuiUPnSfqhBg?=
 =?us-ascii?Q?79JJhDD8xxHuxpKYiEGuaePxKinoEXH6Oa1TDw0KukoYhBvsZB/Sk2I2fUJa?=
 =?us-ascii?Q?eoWhx2LFwhx+cVNBQ4bi/uOhlTsXOyAH80tvQFGPfuvy6WceORJQH4AFZYBE?=
 =?us-ascii?Q?HONRss5zOYpWiC+0OPWjg29MH4n5RAeX2iFIz8V2z4wRVhtXUGp5NjjeSPOr?=
 =?us-ascii?Q?qnh370CV/JYTCjpR9vUkHjFMeQy/4Y2mLhvTrc+Fehlk+QmOzS9WhkQ3fksg?=
 =?us-ascii?Q?b08bUE4yZTWmXc9qozGqGX3eAWK3g/sjZRJROYC1yqODmqcMQwslVnSHDpyL?=
 =?us-ascii?Q?Kf6KAgLltoiFqCKTB+4V0gVdwXjtbnGrGIsTkOEVTG4+S6+Q0LD5f0DWU9LJ?=
 =?us-ascii?Q?eQQkLCawgfKiCp9qZ1BM5KBDReC2OiJFVPpWp4bJegtCF2rPa3w1Lm+2mSp5?=
 =?us-ascii?Q?ym5ujAj4vwOQWyIO/DlUrz9jRaNlF7fjtHBCNVqNJAQ7R02ZJ3uij0bwBpDI?=
 =?us-ascii?Q?wOPg322svN2e7vL/j0xv6F9B/KrRzpLmlIXFeaYQXpOx8iClbGZPKrWGz/Zm?=
 =?us-ascii?Q?ow3yiWDwnGywzc0tJISOd6kanaNzjQvmFPd48HXFNWyMPzQMc6sDXHPW9mFL?=
 =?us-ascii?Q?wW6W3jBfyruH7sqQaxatMuNA2jZKaM1o+FyOSVjsrgALNmNkM7LsUP20kdtt?=
 =?us-ascii?Q?exyA9ejazuZ8Xp/TtUadxj122+yy2WNaE5f4nWQ8EHiSxS3j07vJBuajLFW2?=
 =?us-ascii?Q?Xb08pLa0YukpdKmq9VZcp1e95g5eXFs7ZVNbGSqX/AT2+MMgaP0KeGlYEq6c?=
 =?us-ascii?Q?0+YE5uzwKYvIdctx9Hey0POxnWCBJXx2p57IByaBpN+wXFPczwMm/iwwBa8r?=
 =?us-ascii?Q?FralErM2B0/Dy5DOfn415eBocO/magC5CO2kzEbI1fmwjtB0o56UiGR5rATK?=
 =?us-ascii?Q?v3N39tPcFeSKqGfF3pBUp+n3BBHb3xV4R/QlvZAR4BUZTkRi44u/3Bv2k17Z?=
 =?us-ascii?Q?bb6R1Bytehil6V+9qxkFg0wt65ovoISMSfkhKtFKuR55v+Q55wDkCeAbAxga?=
 =?us-ascii?Q?g5O16EPIE0UVrdX7BhzfiymOgnBqOlOxWQl7O/bcdUTYduOr9WPnoSBhuCpg?=
 =?us-ascii?Q?4cQWxhBw95io1kgRPBMuZ06WMmrKSQhgGzoPOPx5kxw3gzCyfBVX6tnga35o?=
 =?us-ascii?Q?NXZvdvGJlVrKYxymI7i0OKP8mPj5LrA67jZSJzx6AnhkAA6gK++xUzZLH+iQ?=
 =?us-ascii?Q?ujCoLzhgOB0g+JLOxH3gUPkys9ZPIApGGEUPKvdSkbHoioj9tyNOrT0PQZoy?=
 =?us-ascii?Q?5543YwWwQcL8p6Wvz65s4ElQGQUslU2In0Re4Jmx6cyGnsSFvmXY7tiGRi3N?=
 =?us-ascii?Q?b2Tju4UJXDiwPUEm6SlH+LUec0yvs/CP6LjBkHMhrAhMaWO6sKH9iK0+bQOC?=
 =?us-ascii?Q?DfOEy2jEYSP22fANHkYq49M=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a44c6a4-ccbe-4fcf-eff1-08d9f8406e9b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2022 09:23:06.9600
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jecMXOE9wGe7VBduiAmZFiOwl+bOVuP/OEAdrG/ZTDyN4ZthGoDIshnxHWPvw5kLdR1leYB+XF/o+SAObOVvGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7658
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dsa_8021q_bridge_tx_fwd_offload_vid is no longer used just for
bridge TX forwarding offload, it is the private VLAN reserved for
VLAN-unaware bridging in a way that is compatible with FDB isolation.

So just rename it dsa_tag_8021q_bridge_vid.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_vl.c | 2 +-
 include/linux/dsa/8021q.h            | 2 +-
 net/dsa/tag_8021q.c                  | 8 ++++----
 net/dsa/tag_sja1105.c                | 2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_vl.c b/drivers/net/dsa/sja1105/sja1105_vl.c
index 1eef60207c6b..b7e95d60a6e4 100644
--- a/drivers/net/dsa/sja1105/sja1105_vl.c
+++ b/drivers/net/dsa/sja1105/sja1105_vl.c
@@ -306,7 +306,7 @@ static u16 sja1105_port_get_tag_8021q_vid(struct dsa_port *dp)
 
 	bridge_num = dsa_port_bridge_num_get(dp);
 
-	return dsa_8021q_bridge_tx_fwd_offload_vid(bridge_num);
+	return dsa_tag_8021q_bridge_vid(bridge_num);
 }
 
 static int sja1105_init_virtual_links(struct sja1105_private *priv,
diff --git a/include/linux/dsa/8021q.h b/include/linux/dsa/8021q.h
index b4e2862633f6..3ed117e299ec 100644
--- a/include/linux/dsa/8021q.h
+++ b/include/linux/dsa/8021q.h
@@ -47,7 +47,7 @@ void dsa_8021q_rcv(struct sk_buff *skb, int *source_port, int *switch_id,
 struct net_device *dsa_tag_8021q_find_port_by_vbid(struct net_device *master,
 						   int vbid);
 
-u16 dsa_8021q_bridge_tx_fwd_offload_vid(unsigned int bridge_num);
+u16 dsa_tag_8021q_bridge_vid(unsigned int bridge_num);
 
 u16 dsa_tag_8021q_standalone_vid(const struct dsa_port *dp);
 
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index eac43f5b4e07..a786569203f0 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -62,14 +62,14 @@
 #define DSA_8021Q_PORT(x)		(((x) << DSA_8021Q_PORT_SHIFT) & \
 						 DSA_8021Q_PORT_MASK)
 
-u16 dsa_8021q_bridge_tx_fwd_offload_vid(unsigned int bridge_num)
+u16 dsa_tag_8021q_bridge_vid(unsigned int bridge_num)
 {
 	/* The VBID value of 0 is reserved for precise TX, but it is also
 	 * reserved/invalid for the bridge_num, so all is well.
 	 */
 	return DSA_8021Q_RSV | DSA_8021Q_VBID(bridge_num);
 }
-EXPORT_SYMBOL_GPL(dsa_8021q_bridge_tx_fwd_offload_vid);
+EXPORT_SYMBOL_GPL(dsa_tag_8021q_bridge_vid);
 
 /* Returns the VID that will be installed as pvid for this switch port, sent as
  * tagged egress towards the CPU port and decoded by the rcv function.
@@ -289,7 +289,7 @@ int dsa_tag_8021q_bridge_join(struct dsa_switch *ds, int port,
 	 * bridging VLAN
 	 */
 	standalone_vid = dsa_tag_8021q_standalone_vid(dp);
-	bridge_vid = dsa_8021q_bridge_tx_fwd_offload_vid(bridge.num);
+	bridge_vid = dsa_tag_8021q_bridge_vid(bridge.num);
 
 	err = dsa_port_tag_8021q_vlan_add(dp, bridge_vid, true);
 	if (err)
@@ -312,7 +312,7 @@ void dsa_tag_8021q_bridge_leave(struct dsa_switch *ds, int port,
 	 * standalone VLAN
 	 */
 	standalone_vid = dsa_tag_8021q_standalone_vid(dp);
-	bridge_vid = dsa_8021q_bridge_tx_fwd_offload_vid(bridge.num);
+	bridge_vid = dsa_tag_8021q_bridge_vid(bridge.num);
 
 	err = dsa_port_tag_8021q_vlan_add(dp, standalone_vid, false);
 	if (err) {
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index f3832ac54098..83e4136516b0 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -226,7 +226,7 @@ static struct sk_buff *sja1105_imprecise_xmit(struct sk_buff *skb,
 	 * TX VLAN that targets the bridge's entire broadcast domain,
 	 * instead of just the specific port.
 	 */
-	tx_vid = dsa_8021q_bridge_tx_fwd_offload_vid(bridge_num);
+	tx_vid = dsa_tag_8021q_bridge_vid(bridge_num);
 
 	return dsa_8021q_xmit(skb, netdev, sja1105_xmit_tpid(dp), tx_vid);
 }
-- 
2.25.1


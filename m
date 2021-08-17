Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FDB33EEEDD
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 16:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237975AbhHQO7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 10:59:36 -0400
Received: from mail-eopbgr150048.outbound.protection.outlook.com ([40.107.15.48]:54181
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232705AbhHQO7f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 10:59:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H5whrBKtKcPz8RKbDXstLHel8fj5FJQ6LQi6+/fuFPOKQqVDLyT1Bs15nh9FIHMjziLRaRKgBgF/woxa6sjKC1615csGzBzJuEmvMadw/6o/pC34A52bMwtPXV+ReJuJlxe8JOf9C1/r63V6HmLMO1qnNIWZaor+CV9v/3JPgwxv89B0H1VLF12qpW5Ywu1id3HdJPrdZeAiG98H0dGDr3PRuhOyVjvWl3eODrojhb8MGCaNCMUA73my3Ux49cPQSDR6O7Fy13DFw4pymDYPkZRb3v0U5NOPfSTqyblKuUVozBiz+BK9NsuDSV896GnLN7mw50t7a4D4JGuIhZrSjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NCjTro4fSBmQrf2UxtDvEsF4FHRNRdDlIndqFq1B55Y=;
 b=gC72OI6itYqwlemDRNA6cVMyhnbo2npsks4IPn3+kJ04IIjjU8gCqpioTHub9M/Ea+Y5qAIcqVicTx1urPXQeWVR7tYSLunaKu5g9hd+n902ZFl6qv3iqiEvxYGgUhgScZFYE/9+/1ViRnT3w/xrHjeCs+C3ZSfXlJY1t6Q2+X26DsXM2ClztLDcSK1zCzZZTfG6bvIjs/9piMczzO04jRSquoAIJkGwF/pFhPplFqH76lXqRAGGiWF9bFx+qZDvVJigtEb0hMmsB0YjY1nn6preOgGkdNfi+PicpT44/mSRmpE+wAkND+J6D/2Vl+8FQ1nCX5hRzbhPD2azD2eg2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NCjTro4fSBmQrf2UxtDvEsF4FHRNRdDlIndqFq1B55Y=;
 b=Z30iY227QU7/5IpaJzQpkceXbGA45wjdabiLdRmL+v6eHHC7VC8tEoRxMcblOqhY1C8cOTdz/fWuv4Pf++3m+EDBmap1XlAkVfII+LCCsdFUmVjlOw/hZacHv3CoN7sK9SNiHShdue7+zJZJOqiRg4rp3VY0PrP5f+xyTyNNKUs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7327.eurprd04.prod.outlook.com (2603:10a6:800:1ac::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Tue, 17 Aug
 2021 14:59:00 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4415.024; Tue, 17 Aug 2021
 14:59:00 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net-next] net: dsa: tag_sja1105: be dsa_loop-safe
Date:   Tue, 17 Aug 2021 17:58:47 +0300
Message-Id: <20210817145847.3557963-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0902CA0056.eurprd09.prod.outlook.com
 (2603:10a6:802:1::45) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by VI1PR0902CA0056.eurprd09.prod.outlook.com (2603:10a6:802:1::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.15 via Frontend Transport; Tue, 17 Aug 2021 14:58:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3ee1c558-7bfb-4705-ef3a-08d9618f8b8f
X-MS-TrafficTypeDiagnostic: VE1PR04MB7327:
X-Microsoft-Antispam-PRVS: <VE1PR04MB7327DF911B0F9F75BF2A6150E0FE9@VE1PR04MB7327.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jkW+Ds2E07lMPNcNFmC2+K9fEKrnfZy/+63KbpZgx00UYx+nuJ52TE3ZfGQlJWKRnjU1U6z2ocrc1inmH1JrxbbLx9PjMgHNhOny/zv6RESDM4PZHumGruLovBuU3I+X+Eq+HXkNrExYvr0PofOHZDNN2wtgAWEtthSKuXpy7c8uv+aKDnzZcNiQwr/wtGFgiXgf0ESRWnhkWeBNtxM0dx3keerd7CGZ1IMWRAGSDWTNRGkn0mYp4e+jsbCcpOqhXt1qxvoTKQ4QBYjFLdLE62XtbkuwUVHllhCbSFn2O9Vf0+qaRVj4jpgKrsBew9RsDW8g6O7IXcU7lR4NAxMu/IMqEkWnvy996il2zugQCzBHnt7N6Co/LH0+KjV/r4iSwxBPK833/zhiONgDsb44VHeAGMpUHEpYZdVk48OwtLvG0cQrq3AZ//GxFzeS/bvz0B9sk9O7E0CkGws3EdfZOEgwhR8ez715NGwziSJpCJgDD5Y9LvfATOktx93Zv93RvQVlXztIJbGaNffqX8JnyvmGvRgnGdVl2tyqdciidTrgw+g+ENkKY4h3ZjxmI0FujyXGMD8WSowAVYefBOudRJl1WycdJ0L3J34K6NVExmrIR/nNaiwY5jlAKA7ipTOfYnRdNjbhFMlWptKT3tfrgtd83srq0VY9oMQXs3hogqQ7fZJ8/cCgCEGVzfinHk12PKOI0oga0MSNJhpuVmfUeg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(346002)(39860400002)(366004)(66946007)(66556008)(66476007)(54906003)(110136005)(8676002)(956004)(1076003)(316002)(52116002)(6506007)(26005)(44832011)(2616005)(2906002)(8936002)(38100700002)(38350700002)(6666004)(36756003)(6512007)(6486002)(478600001)(186003)(86362001)(4326008)(5660300002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+Q8vWrmMXzjsrtvGdMt5SDDa/E5JFNqmJplb5zWSd90K5cVscPWeuiB6l6DN?=
 =?us-ascii?Q?/P1G1/KzBgADj8AJU/6akZiKvkIPIdXkHey0laCcoaqHSgrXU2dnAt3j+avA?=
 =?us-ascii?Q?YDsnc6vp3ZMNVI9/Ohz7juO9pcLdaEQitT9xoeljdyknrx3aGGwOoYTdQirV?=
 =?us-ascii?Q?ReJwZGFpR1sCuq90NEvp/vPTdQvFRs2jrWBPSbt4tpCAU53gAaKPQIVmOTbD?=
 =?us-ascii?Q?+S7EsP0jRH//NuFdkM4hWehV+8gBxSMhZSGrJDPdagyvd0OtNrARs8TTU9I9?=
 =?us-ascii?Q?PYcurME+FiHnxHKSQx/BDH/gz+nHXz7f1lx/k8f7pdEYNXXlP1tFh/8273Mf?=
 =?us-ascii?Q?HsBL2CV44H4GEmersul4J91DgtRuTkOmRJmTxm3xudLzcLU/H4+x6N3Wb8s4?=
 =?us-ascii?Q?0q4jGKXv/ddxb6ntSYaIfxdXgJiQsub8tmTGJnc98u6ufjl+WhsxecQcE8n4?=
 =?us-ascii?Q?6+CBv4gbYVEGBndnerbPUEGc73+e7A7/wZ0drzryKh6KBIxQTN+hcb2jAwQ8?=
 =?us-ascii?Q?Kkl6TMmJkQOR8/wbVNhXwlSwuqYBx6lsJWVN74NE0BpfyAmEsyaAeHPosRmb?=
 =?us-ascii?Q?m/CV2ZtUWqwkEKUlN7ugY0qxPb1Q9Mxl7u1OvKlGlOFBfV6VxNcJyPRUo9zw?=
 =?us-ascii?Q?6EUG6gdHiIk5QRs8YT3NCEbbNsZf6/MQgHYkzKZh5C2lMaz6ySkQ7CUDsFRg?=
 =?us-ascii?Q?WvFjfAX2eRDItA+18X6dNwyJPeQxffNtcVfMXJOaB6d8wF41eIvhS5yiqeNf?=
 =?us-ascii?Q?7RwPaTt9qsSWGURb2un9Ri/YKTEAlpzSPD2gwvpTridL9HV/1jEqIHmVBIw3?=
 =?us-ascii?Q?Xx9e/b4SarXtgLYDq9jI6lOw/2zVpVwShpBbpCwcztkVS3P1c+EgjbnAWzlM?=
 =?us-ascii?Q?3UGSCYiUwEcaMwp7PGQS6a1AID3l/DllmFvi1HSk/7LMDU4st3q0CXrTv12H?=
 =?us-ascii?Q?TMaEojR/OGXImma2ou0EeTjO6dJKeNGOeFKNnxjYqhvf4CMzmSmrAteg7zgT?=
 =?us-ascii?Q?blgKUW1LyJfRd1b6gLp78OIP7RgWRBSqYGbyIw4LKwhDgB6v/0AUkgbIDAE0?=
 =?us-ascii?Q?qBQ0rCZBJjFfuLXejpEAFom7QlT8ok2M1mP91Z+lj2y8hocG2GgbFv7OMFmp?=
 =?us-ascii?Q?dVjxrbdNvbOgyeq4+IxsxpTTJ7HU3R4QkfYsK9PKA4QhyNwcW7ohUxD+ilR1?=
 =?us-ascii?Q?mYjmgQfl9lCcXpAe6RMK45luy8H7NwHHuISY8nK5aFa7ottx4uRU+lWyYg+u?=
 =?us-ascii?Q?oq9uMBI8mgoDhIpsiK/NtNTvCsMSQ0KQmnoxQY7TKDJecsq7ZiAPleguyFU/?=
 =?us-ascii?Q?SbLTj59wfdPF4ktgFtzwFa9K?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ee1c558-7bfb-4705-ef3a-08d9618f8b8f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2021 14:59:00.0508
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /UzotQrvIuseSNDft2MWTGzhtX6v4mx9ELv6G1OLORjiX90PaPaaMQIA8dcuIyrZTXtjui/2XvRs4ZXhNXfXDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7327
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for tag_sja1105 running on non-sja1105 DSA ports, by making
sure that every time we dereference dp->priv, we check the switch's
dsa_switch_ops (otherwise we access a struct sja1105_port structure that
is in fact something else).

This adds an unconditional build-time dependency between sja1105 being
built as module => tag_sja1105 must also be built as module. This was
there only for PTP before.

Some sane defaults must also take place when not running on sja1105
hardware. These are:

- sja1105_xmit_tpid: the sja1105 driver uses different VLAN protocols
  depending on VLAN awareness and switch revision (when an encapsulated
  VLAN must be sent). Default to 0x8100.

- sja1105_rcv_meta_state_machine: this aggregates PTP frames with their
  metadata timestamp frames. When running on non-sja1105 hardware, don't
  do that and accept all frames unmodified.

- sja1105_defer_xmit: calls sja1105_port_deferred_xmit in sja1105_main.c
  which writes a management route over SPI. When not running on sja1105
  hardware, bypass the SPI write and send the frame as-is.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: drop RFC tag

 drivers/net/dsa/sja1105/sja1105_main.c |  5 ++--
 include/linux/dsa/sja1105.h            | 18 ++++++++++++
 net/dsa/Kconfig                        |  2 +-
 net/dsa/tag_sja1105.c                  | 39 ++++++++++++++++++--------
 4 files changed, 48 insertions(+), 16 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index fe894dc18335..05ba65042b5f 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -28,8 +28,6 @@
 #define SJA1105_UNKNOWN_MULTICAST	0x010000000000ull
 #define SJA1105_DEFAULT_VLAN		(VLAN_N_VID - 1)
 
-static const struct dsa_switch_ops sja1105_switch_ops;
-
 static void sja1105_hw_reset(struct gpio_desc *gpio, unsigned int pulse_len,
 			     unsigned int startup_delay)
 {
@@ -3100,7 +3098,7 @@ static void sja1105_teardown(struct dsa_switch *ds)
 	sja1105_static_config_free(&priv->static_config);
 }
 
-static const struct dsa_switch_ops sja1105_switch_ops = {
+const struct dsa_switch_ops sja1105_switch_ops = {
 	.get_tag_protocol	= sja1105_get_tag_protocol,
 	.setup			= sja1105_setup,
 	.teardown		= sja1105_teardown,
@@ -3149,6 +3147,7 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.port_bridge_tx_fwd_offload = dsa_tag_8021q_bridge_tx_fwd_offload,
 	.port_bridge_tx_fwd_unoffload = dsa_tag_8021q_bridge_tx_fwd_unoffload,
 };
+EXPORT_SYMBOL_GPL(sja1105_switch_ops);
 
 static const struct of_device_id sja1105_dt_ids[];
 
diff --git a/include/linux/dsa/sja1105.h b/include/linux/dsa/sja1105.h
index 0eadc7ac44ec..6b0dc9ff92d1 100644
--- a/include/linux/dsa/sja1105.h
+++ b/include/linux/dsa/sja1105.h
@@ -88,4 +88,22 @@ static inline void sja1110_process_meta_tstamp(struct dsa_switch *ds, int port,
 
 #endif /* IS_ENABLED(CONFIG_NET_DSA_SJA1105_PTP) */
 
+#if IS_ENABLED(CONFIG_NET_DSA_SJA1105)
+
+extern const struct dsa_switch_ops sja1105_switch_ops;
+
+static inline bool dsa_port_is_sja1105(struct dsa_port *dp)
+{
+	return dp->ds->ops == &sja1105_switch_ops;
+}
+
+#else
+
+static inline bool dsa_port_is_sja1105(struct dsa_port *dp)
+{
+	return false;
+}
+
+#endif
+
 #endif /* _NET_DSA_SJA1105_H */
diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index 970906eb5b2c..548285539752 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -138,7 +138,7 @@ config NET_DSA_TAG_LAN9303
 
 config NET_DSA_TAG_SJA1105
 	tristate "Tag driver for NXP SJA1105 switches"
-	depends on (NET_DSA_SJA1105 && NET_DSA_SJA1105_PTP) || !NET_DSA_SJA1105 || !NET_DSA_SJA1105_PTP
+	depends on NET_DSA_SJA1105 || !NET_DSA_SJA1105
 	select PACKING
 	help
 	  Say Y or M if you want to enable support for tagging frames with the
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 1406bc41d345..5b80a9049e2c 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -116,9 +116,14 @@ static inline bool sja1105_is_meta_frame(const struct sk_buff *skb)
 }
 
 /* Calls sja1105_port_deferred_xmit in sja1105_main.c */
-static struct sk_buff *sja1105_defer_xmit(struct sja1105_port *sp,
+static struct sk_buff *sja1105_defer_xmit(struct dsa_port *dp,
 					  struct sk_buff *skb)
 {
+	struct sja1105_port *sp = dp->priv;
+
+	if (!dsa_port_is_sja1105(dp))
+		return skb;
+
 	/* Increase refcount so the kfree_skb in dsa_slave_xmit
 	 * won't really free the packet.
 	 */
@@ -128,8 +133,13 @@ static struct sk_buff *sja1105_defer_xmit(struct sja1105_port *sp,
 	return NULL;
 }
 
-static u16 sja1105_xmit_tpid(struct sja1105_port *sp)
+static u16 sja1105_xmit_tpid(struct dsa_port *dp)
 {
+	struct sja1105_port *sp = dp->priv;
+
+	if (unlikely(!dsa_port_is_sja1105(dp)))
+		return ETH_P_8021Q;
+
 	return sp->xmit_tpid;
 }
 
@@ -155,7 +165,7 @@ static struct sk_buff *sja1105_imprecise_xmit(struct sk_buff *skb,
 	 */
 	tx_vid = dsa_8021q_bridge_tx_fwd_offload_vid(dp->bridge_num);
 
-	return dsa_8021q_xmit(skb, netdev, sja1105_xmit_tpid(dp->priv), tx_vid);
+	return dsa_8021q_xmit(skb, netdev, sja1105_xmit_tpid(dp), tx_vid);
 }
 
 static struct sk_buff *sja1105_xmit(struct sk_buff *skb,
@@ -174,9 +184,9 @@ static struct sk_buff *sja1105_xmit(struct sk_buff *skb,
 	 * is the .port_deferred_xmit driver callback.
 	 */
 	if (unlikely(sja1105_is_link_local(skb)))
-		return sja1105_defer_xmit(dp->priv, skb);
+		return sja1105_defer_xmit(dp, skb);
 
-	return dsa_8021q_xmit(skb, netdev, sja1105_xmit_tpid(dp->priv),
+	return dsa_8021q_xmit(skb, netdev, sja1105_xmit_tpid(dp),
 			     ((pcp << VLAN_PRIO_SHIFT) | tx_vid));
 }
 
@@ -200,7 +210,7 @@ static struct sk_buff *sja1110_xmit(struct sk_buff *skb,
 	 * tag_8021q TX VLANs.
 	 */
 	if (likely(!sja1105_is_link_local(skb)))
-		return dsa_8021q_xmit(skb, netdev, sja1105_xmit_tpid(dp->priv),
+		return dsa_8021q_xmit(skb, netdev, sja1105_xmit_tpid(dp),
 				     ((pcp << VLAN_PRIO_SHIFT) | tx_vid));
 
 	skb_push(skb, SJA1110_HEADER_LEN);
@@ -265,16 +275,16 @@ static struct sk_buff
 				bool is_link_local,
 				bool is_meta)
 {
-	struct sja1105_port *sp;
-	struct dsa_port *dp;
-
-	dp = dsa_slave_to_port(skb->dev);
-	sp = dp->priv;
-
 	/* Step 1: A timestampable frame was received.
 	 * Buffer it until we get its meta frame.
 	 */
 	if (is_link_local) {
+		struct dsa_port *dp = dsa_slave_to_port(skb->dev);
+		struct sja1105_port *sp = dp->priv;
+
+		if (unlikely(!dsa_port_is_sja1105(dp)))
+			return skb;
+
 		if (!test_bit(SJA1105_HWTS_RX_EN, &sp->data->state))
 			/* Do normal processing. */
 			return skb;
@@ -307,8 +317,13 @@ static struct sk_buff
 	 * frame, which serves no further purpose).
 	 */
 	} else if (is_meta) {
+		struct dsa_port *dp = dsa_slave_to_port(skb->dev);
+		struct sja1105_port *sp = dp->priv;
 		struct sk_buff *stampable_skb;
 
+		if (unlikely(!dsa_port_is_sja1105(dp)))
+			return skb;
+
 		/* Drop the meta frame if we're not in the right state
 		 * to process it.
 		 */
-- 
2.25.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AACD3ED15A
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 11:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235465AbhHPJ4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 05:56:20 -0400
Received: from mail-eopbgr50082.outbound.protection.outlook.com ([40.107.5.82]:5518
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235336AbhHPJ4T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 05:56:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FWxMF4RPN5iRkaR/MdzFCDfK714u1JrrI5NxnDURd5JP22JvnZ+ycVPsJu1VEptak5UWF32sC9R3PqD2K5B1k2QqSkvNfMZS11JK5MD84DnGtHARMz1BbQcJAZBY8AtCptdn9xZki+nHlONm6ColK4LxdK+B51QYbrkaMN67mpWq9DSnIdRIq8CeUFFVEiQIEwTZM6lycjUtbufVVnxh4XU/fTG8gkk61CZj0cBahXkY7HU+HtHQ73hxDNxv53Z/buPkYNjXxxvnzCTsmZ7X59Cr2fhM1VOuNIo4f1FtAtRWmVG47DGXu3m0CIpHKTjnuYIFKxd0nlf0q+ZoeobFxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZymE2zpjqz6Ktue7Czqt0mm0GO61RoDTPM4yKtWrxOc=;
 b=XNC/xA+w5+h+WTtRoIiml+7CcqvLNmfXwx8wpYvdzIqfmRj9yrNnMvUOH6OPq4W0V3sJvrDFJdh/XGlR+u4OsOktIOmsrnWvWy9Nu7NLHG5R/8OSc+SBRqYzbkW7VNg1H08uA/ta6afcp72H+TuKPHFCjw/HkkSp/G3bgcZJy9M+1NLYb8AAEq+CFp804aNN7+GUyLt61fd5TsW5AIqQjnU9hQEbqbRBpRt6yETKqN3uWe3MR6SjivGNVYUDaAYxt2NQtHVHBRc3ZA9V6YjB4xqZDsL7lRibuFbsHBTxDO/U6c/4CC6OgufM72MqvO0wIAgizvJFf0hJt1nmKsYnqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZymE2zpjqz6Ktue7Czqt0mm0GO61RoDTPM4yKtWrxOc=;
 b=fX9CxUNE+JXGXOlM+irKl2wjkVcDK0J08dDORubQjV/AUJXg5Hj69Vuh/51RVxSA5zwDGb334tXtlwW/VbIsPqOGr8i3N70yEuqqqVVoW2CdhQfucJTXNPpJclCkA4HXpeR/L+5HdD7lYqh5hxKXsZkM0/UWmUcfRxYFf5saPA4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2302.eurprd04.prod.outlook.com (2603:10a6:800:2b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.19; Mon, 16 Aug
 2021 09:55:46 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4415.023; Mon, 16 Aug 2021
 09:55:46 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: [RFC PATCH net-next] net: dsa: tag_sja1105: be dsa_loop-safe
Date:   Mon, 16 Aug 2021 12:55:33 +0300
Message-Id: <20210816095533.1626944-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR03CA0044.eurprd03.prod.outlook.com
 (2603:10a6:803:118::33) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by VE1PR03CA0044.eurprd03.prod.outlook.com (2603:10a6:803:118::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.13 via Frontend Transport; Mon, 16 Aug 2021 09:55:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 10bdf2ff-40fa-47d9-b80e-08d9609c0482
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2302:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB23027C579A9969636466A1FEE0FD9@VI1PR0401MB2302.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XhNNDuarMsI1iV8Zp3R1aUeeOGQCj9krULqZ4YyaAuARbTMnGrljWlrAZNOt2SwJ3VIYoVKsgUUoTDiiRq9ePdKOHARc3pT2srbWmS+WzC2k7bIdF13cgFVacSw4uB9kpaeentNsg1Cl8RMSGsC8DbrP6Gpiv6ZZdj3i9iscE3MemX1u/1fxkcrnswSpqGce2jrNDlsG2oCyrEjgkh0cnnnlMHFTTJTOZVWkhYZImMZSiDFypu2zsuyr/hnPTbMgnZEYXrgniRLK7vN3fBAjc+QFS8S/e+8uefg1HaVqYXIcr59q8V8umpOdYnJRQv2L27lz56P2q+g4aVVPDmH40DVkBoNk0iopyFGpiTfescJh4HRQZqJ3YhGGy5tDECNI5IyZ/Yg1pQnC97nBB4SQGjaDWY82U75IJ0pBL+8/kGqNLTunzr3HdnfL+wcIT2z+/DhjQORKNEoC/22HEtBqgBF14kRLeumTfcrBX9Axm8uMX9amlV+gQldYbhYNv/cYwuEwQUOBWXzi9MlqdA+j0QKsagG4SvEvul4qK/OBlI/1jsO7wGwE0h83pdVJg5P0fA2tjTBjJbMhcaJku+P8c8H0zkh/PmxQIEq3JAPXMdBFOd16s9TSUXQlq7EDW69SoywRre5djv/3FRSeOLr66zRBEGZuGT80oHiy3VpXjlCV30VUXgpUNSBjgsNgQpq1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(1076003)(8676002)(8936002)(44832011)(86362001)(6486002)(110136005)(316002)(2906002)(54906003)(38350700002)(38100700002)(4326008)(52116002)(66946007)(83380400001)(2616005)(66556008)(66476007)(5660300002)(6506007)(6512007)(186003)(6666004)(956004)(508600001)(26005)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QBMvCi7tNXlsrCFjii8HlYOLt4ks6N0a0svWBlMxCf6pAQOfl7/SWgsVgw6A?=
 =?us-ascii?Q?29yOArVvrqG7X21AwOXMmT6EAWICA/IeHYvSRMJrEg7j635k80vRJi26i4sP?=
 =?us-ascii?Q?X78fFFAlC5HZdQEfI5tAx83+spcwWIebTw3C/sLWXVSnD+aYwSoR2OTyN6lm?=
 =?us-ascii?Q?ZrO/emNJj08eyLTXCnBNA7AttRx4tRdlSbwpgwyvZKTi7oXoMLzozWFPgpRm?=
 =?us-ascii?Q?mqhQyB6a7FVlCBPcicoqL6qspjAYCreG1DusxTjkIyjrFUeG1rn4I5GC94aX?=
 =?us-ascii?Q?rcnHVHFDuAyKMtpYENHq2U2/wTd9wGXzLQ6owyMh8PoeImOCIHaLVnlUCKgE?=
 =?us-ascii?Q?2RYSGEMeyZKfq4ExwdApvxpNCOYXP0YaVOxlN+CuvFhju39iV8ym0RS4Cq62?=
 =?us-ascii?Q?mHS/YaSrAmak+1lCi+FERSaGXXDtXBL/q83M5BzJuw1OvNWevPG64KwIvaTk?=
 =?us-ascii?Q?C++LQg9A5WpChTd+CVucVEH0ONwrTPDdzsVYq2m20rs1m5rdUBSKkqI5Zv6S?=
 =?us-ascii?Q?8VCJe0USBLmRoW1wSlJMq3TlwRVXV8mfwrfulvZywSkdIb5Ld8gx7ffAo36f?=
 =?us-ascii?Q?rNLK+jFBv6mU6H3XZUoDywPrL6Hma0DZpswM0mY2w10V0OcwQIgXws5IRE0Y?=
 =?us-ascii?Q?bzZHjAYvvz+4ktBextJCLtPYLpoccPtRgWsJS1+okjHEpoqAm+dBRpdkKzON?=
 =?us-ascii?Q?24zjN83qr63V34bdg+jqbFyKP0pCb8w7N1YLMjos8DqpMMda8mQof4vuiSkL?=
 =?us-ascii?Q?22tDSvMdM8OEJpTAYl5zVnGf4XUQdF4XvEGwB8GM018+rvuuOqefIJ79UgAw?=
 =?us-ascii?Q?S5JwML/7Vrp3NiBeFWH0S9Ja09xaLaYMvwz8ZNusmE2u+aJVdK4ZnyIH9cF8?=
 =?us-ascii?Q?6SzbYuTkNwzCpDa7xR27iCShZYe+QG//KxvjpclkSPTCc6gWdZST69j1AG7V?=
 =?us-ascii?Q?+DQPd/mj+aMX9mZJgrHO/oBNZHVV8FOOSTe4E3/lMcjDTlnuCST/MebWHgQO?=
 =?us-ascii?Q?2F8PUrzG56/4ew8RcgY3yjD+yKuNc1EGrYifKFticnYXgUBtmQOFnMYQBrJA?=
 =?us-ascii?Q?ziuyj+2p9a2ijqLpKGroi4jSyUx5lFx9mfPjxtCekCnM795CkTfD0rl9eB6j?=
 =?us-ascii?Q?STBHgN5TLHCNRuQi9AoZSlDlCP0SxmxvitSiDoZAFoZqdF/4/QHg/UhgdAUi?=
 =?us-ascii?Q?sjAPbMGaAULfjtSGs//teMeo3HbbenUH1OYZtcCQlsdWkFCAP8qj5so1t8g0?=
 =?us-ascii?Q?gozTqPrFDNqdxfc+MG43yFb9EPL47dCuTfq/oh58mlhK63UyGKAnaMVc6k+Q?=
 =?us-ascii?Q?kmbn+k1/87Y4MgLI7QJ7zYKw?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10bdf2ff-40fa-47d9-b80e-08d9609c0482
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2021 09:55:45.8115
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wAdYiWjM5Yf++TBJCaFqaZV00ulPJfXc4PsSG3Nv1mpiZ2ThOzBeBOGHAR/Yx6G2Sqi4bNP63EsV0AtnOq7asw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2302
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
 drivers/net/dsa/sja1105/sja1105_main.c |  5 ++--
 include/linux/dsa/sja1105.h            | 18 ++++++++++++
 net/dsa/Kconfig                        |  2 +-
 net/dsa/tag_sja1105.c                  | 39 ++++++++++++++++++--------
 4 files changed, 48 insertions(+), 16 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 7074b00fb9e7..1a041fa7fa86 100644
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
@@ -3120,7 +3118,7 @@ static void sja1105_teardown(struct dsa_switch *ds)
 	sja1105_static_config_free(&priv->static_config);
 }
 
-static const struct dsa_switch_ops sja1105_switch_ops = {
+const struct dsa_switch_ops sja1105_switch_ops = {
 	.get_tag_protocol	= sja1105_get_tag_protocol,
 	.setup			= sja1105_setup,
 	.teardown		= sja1105_teardown,
@@ -3169,6 +3167,7 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
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


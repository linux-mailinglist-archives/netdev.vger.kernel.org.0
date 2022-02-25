Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D49F54C414D
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 10:24:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239013AbiBYJXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 04:23:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234461AbiBYJXj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 04:23:39 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2086.outbound.protection.outlook.com [40.107.22.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD751A8049
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 01:23:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PZvgMV5oG56wCwR9HwTo5jGCA8lVdDS274HNkihRmHET8N5XTvUS244hFZkPquzVWn8kGp4OTdJ0oiYkNHhOZdl8xDSy3rYLzVFiS3V4VMaUj2+KZoacpqJ5Q5fmEVHpqmVLDvk95kNXx13r4KlFiRVNuQ+GeKV1L4KUScw7sKfrjLNYP8P4r8Un3SyZ+6zNCXBRBEGzv5oV78L9j6QFS3tYNMMl88kgp6KwPUzG5j6Y5a7IjwqsUZVkjAA/7nAyJ3w5WD6CjPOOb1L7W9AqvRQlSWyUIqsfAruZtabERnnYARv7I8jO7nHTg0MNgWMVKS0QTQiffCEa3C5lGjaXxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ECj2C4myhJ3OIg+gZyVldxvj+ugczFeLwyBOtQi7Yk0=;
 b=H0MDB0W8BfCzui+q/sXUCTrcIMWVh9ZaKa/bilvOyIZFc2PzQIoCFTExH3WVpjvgz5gy8GTrILrXCm7a37MXclcOAKn4Z/QmivCq5dnIfZ0PwbM1NeMfikpLjvXSxntP5Bs06TqhPEm901oAyuu53dytKKRJyuTapDvSpTuAnWg4A1Qbrl5jGvK+CnAC7VjQ2Lptx6sApCzpknFHnBA8qd50Xa2INW4DshpbGWFQJOLKDplLMttd3R4+Ek8KIMrP8EGOEjZO5WPaZNXBK2RRabER0+FPKf5Ii3dYvOkuTOneD5Wpjw8VE+jpfRxxdgoeIKMIWztQHYQMYM7+1dT+MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ECj2C4myhJ3OIg+gZyVldxvj+ugczFeLwyBOtQi7Yk0=;
 b=nASRW4tHJ959hbebyxSq1XTAB9CUe6VK8y/T9bLw3pwOg3TwK3Ghv7eHrqHulupCbBM6qxvUiMYkS3EjjO2y4PVK9bZDI1uIqhvnJr8eWsfhqOsgKNYLpXxy27vYzmaV7iSVcpfRJ1gbw++KRFt7axK44PvGvM4ddRz85qAGUwA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5008.eurprd04.prod.outlook.com (2603:10a6:803:62::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.25; Fri, 25 Feb
 2022 09:23:02 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Fri, 25 Feb 2022
 09:23:02 +0000
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
Subject: [PATCH v2 net-next 02/10] net: dsa: tag_8021q: add support for imprecise RX based on the VBID
Date:   Fri, 25 Feb 2022 11:22:17 +0200
Message-Id: <20220225092225.594851-3-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 5e2c4341-10cd-4799-5336-08d9f8406c2b
X-MS-TrafficTypeDiagnostic: VI1PR04MB5008:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB50083BCA3755C17A9E197C1FE03E9@VI1PR04MB5008.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RA856zvcXQRQTsYBYEaQEQTWLovHZ0wbRnewurUIchFj4e1Wbhv4CdknHfRjhzMZher8S0MQdSxr3RNR8YSCOSjpyl0zYArZvk+HTRav2yAcB8enP7wuwcghJ0rOM8LZ4uFnWhDE2IEq1J28pNIInlVupL/XEY08z8RW1CQDYaUv8VfCyKOIiSRExtdUjaFkspKUralHRfRsS5IFldiorf/z5xhSuWs2E8KDA13XxKIeDkLr6kC0bTG4ZCoAbwuX/1lXS3uAKbZMUgbo7c2mCVLiQC4Dv9zK9lWR21OfVXM8vI2Ihw+s1iyZlgnaLeY94JgjPC8WgHzr071Aor3ep20ymf49Fw7cN9YoIlfvlDBf7n+KtQOYVS5+yTWpriAjBji/S92Wu5j3lXIkBj2uO238PPQc39scmPdBtwK0kMwU8IF7uO3JVgIUcv6FLgCTps2jsxHKK58QfgmbaAu4kcJ0P5qWpReQGshmt4l+vwOmIPG3aQK/1izk1ezK4T5+WFWhODQdycKljRxMFOu3cpNrzEZykK9aoqjErDOBdulOXE3klK/M52TPNh/H942+iNR5azv4266Sy2dlnmbNqrKHsYY1GqSx4iM3LBsXYj1KeIusR2A3XRz7t2Xr6GYPc4IzDlecKKeKtMtMXQaW2ljXbwscpG+ZLn8UzO7I094kF0eKX4abGjbUpMSVM6Uc9ARD7Z7zSki5IsKIxkPQhw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(6666004)(38350700002)(38100700002)(54906003)(83380400001)(508600001)(6486002)(110136005)(36756003)(5660300002)(52116002)(6512007)(7416002)(6506007)(8936002)(44832011)(316002)(2906002)(2616005)(1076003)(26005)(186003)(86362001)(66946007)(8676002)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?g+vgzaQDiN1ZKgXcW6ZNLRm2ciyu57DtBC6EFwo3jCfObg3sSvr7mpGCOWd0?=
 =?us-ascii?Q?Kq+UGoWpvj/ydsjOWYCkHUE8KVUpjsJis/FnZVU1ytdD9TI2a37RGv1uWCux?=
 =?us-ascii?Q?2VpU5PEeOMoYllNYtZmSLhewpODRy9dYeezh+Z9f+u/mTXcdO62+hr9UIKGK?=
 =?us-ascii?Q?uTTXoQZRpK679FJNrx8pzGEMKabCn4OOYM2y3kPI66BaAuojG+3BYpTO7zIS?=
 =?us-ascii?Q?T3Cch571a+Q54Fm12QhiNiaYMQVZmbyJ6qHQFubqLSTqy2roU1dTAjx+Jj/m?=
 =?us-ascii?Q?i3fcPIIyQWZUCumzZ7hXfYYqZRGwdy1LWgKbuf+62bsXCLNpEUekyPt/hl4t?=
 =?us-ascii?Q?RriS0Dgol+HaOBy3GiUJrbDBASYC7eCYM0WRDGzUF26HgbfqP73qzOdkT/jh?=
 =?us-ascii?Q?t8tCalEoEZKKN8okfoaDo3XEqJ4ughlVhJekvge5eKpveybyw2Z1h2yammhN?=
 =?us-ascii?Q?gDvHFwThnJnP5Z29QbYmo+yeHuS0smMhOJoFJD5g8iNf0OUFVgl8j7thh3Oq?=
 =?us-ascii?Q?CKY/L006QUVHTutINpr76bwYbevCsvllg1/T050gn4MGoE8XTbzEYvoIfI1j?=
 =?us-ascii?Q?PNkoxUbQrInTDahm4nq6layao2q8KyW0poMdT9j0mnk/3OPuwv0R/GoJuBPr?=
 =?us-ascii?Q?/vg4V33SFDraxWzoatlssS1zqAM6rtT4f3MCOYoirl2pLfzgm514L1sRY4Bf?=
 =?us-ascii?Q?nrsBJEIqitfHT02l/kNQgw7XV0nslFqZQpw6PqbS+aW+/uc2D4ASEMM28c2Q?=
 =?us-ascii?Q?Apdzem0YGGla8pWxjodfKV+QhpRb0Y5EEBe/szPKRdxP8uJ+kd6M2TDcVKvt?=
 =?us-ascii?Q?gxB+kwyrn/hvXkV0tpwMYqKYDz5TxsG3nO1RCiOJYLSIeXnmia/gRxXaPVFR?=
 =?us-ascii?Q?oHcSHmS4FA7N0G0b8/nAx/yS1Dic8J4EXLN6gJTLD6JN+MAXD/ljqIx/fA94?=
 =?us-ascii?Q?fZKU+Ly9Ei/bK63L4bbi5ezQNEpun6ncNEWro1dJxSCOF3kLgQNTvNe3KSSc?=
 =?us-ascii?Q?NjJdTtB7qjI48Uc+M6jcSXAFS4sd6I9uHSxYMAw8VhmGT3ZqCSg1pPOHSPxD?=
 =?us-ascii?Q?rCrejXk3wXeQumlptEeKDYeuz7WWQSZs0U7oA/y8YUnxV7vlA1HI6pY+8RR9?=
 =?us-ascii?Q?zzg1lrMhAXTGq+RTMzXjl4YvUOHunJ2ny5QSGyOapUEMoPDjybKsHQbc4Ok3?=
 =?us-ascii?Q?0+Xnc65SSPTqpEBjiRjIbWXMVekm10ImhAgMGhJAWzQUcNjjxvsJSeuFe1Bj?=
 =?us-ascii?Q?vZVJNghYbyiyIh7qHZRPeejPEN/xIInl81AneL7r+H0CNgfrHrJk9LbsCR+O?=
 =?us-ascii?Q?GaAjyIcW6xqjhUrHw9k37fY4uZm85Eo+2gdqYqDlSwIB+Ip35PttCDGajljW?=
 =?us-ascii?Q?2b4FhATuuUqnlEv6YvJNa0UmiL+oU8pURJOa8xg8vb4WE2qGKWQDrsn9D5np?=
 =?us-ascii?Q?vWtvSRqKv6S+R/1FAfJhmTSxjCYvhW1FfPGtUqtbypXU5A9An5Qs3o89LK99?=
 =?us-ascii?Q?CjmhA0p7/Oztmnxn5EuPOVzBb1qxwOA+AR+AHEDbwIj+AQsKDCFRb6XJ1E4K?=
 =?us-ascii?Q?YTmvftyEby0JEAY/pDBMJggDWdr42T4Qvf88YZ821nGH32gM3TXSHojXxiw3?=
 =?us-ascii?Q?LEyTQnbeR1l9AoLuSQZwsso=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e2c4341-10cd-4799-5336-08d9f8406c2b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2022 09:23:02.7728
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aln1On9BAZLNgYiS/wTiy/Z3WBM9RZjQIkpXOIR5HfkrC9omThKLqjUwepIZOGwayQHAcd2Y3G+4O5lIXOyUSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5008
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sja1105 switch can't populate the PORT field of the tag_8021q header
when sending a frame to the CPU with a non-zero VBID.

Similar to dsa_find_designated_bridge_port_by_vid() which performs
imprecise RX for VLAN-aware bridges, let's introduce a helper in
tag_8021q for performing imprecise RX based on the VLAN that it has
allocated for a VLAN-unaware bridge.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/linux/dsa/8021q.h  |  6 +++++-
 net/dsa/tag_8021q.c        | 38 ++++++++++++++++++++++++++++++++++++--
 net/dsa/tag_ocelot_8021q.c |  2 +-
 net/dsa/tag_sja1105.c      | 22 +++++++++++++---------
 4 files changed, 55 insertions(+), 13 deletions(-)

diff --git a/include/linux/dsa/8021q.h b/include/linux/dsa/8021q.h
index f47f227baa27..92f5243b841e 100644
--- a/include/linux/dsa/8021q.h
+++ b/include/linux/dsa/8021q.h
@@ -41,7 +41,11 @@ void dsa_tag_8021q_bridge_leave(struct dsa_switch *ds, int port,
 struct sk_buff *dsa_8021q_xmit(struct sk_buff *skb, struct net_device *netdev,
 			       u16 tpid, u16 tci);
 
-void dsa_8021q_rcv(struct sk_buff *skb, int *source_port, int *switch_id);
+void dsa_8021q_rcv(struct sk_buff *skb, int *source_port, int *switch_id,
+		   int *vbid);
+
+struct net_device *dsa_tag_8021q_find_port_by_vbid(struct net_device *master,
+						   int vbid);
 
 u16 dsa_8021q_bridge_tx_fwd_offload_vid(unsigned int bridge_num);
 
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index c6555003f5df..1cf245a6f18e 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -32,7 +32,7 @@
  * VBID - { VID[9], VID[5:4] }:
  *	Virtual bridge ID. If between 1 and 7, packet targets the broadcast
  *	domain of a bridge. If transmitted as zero, packet targets a single
- *	port. Field only valid on transmit, must be ignored on receive.
+ *	port.
  *
  * PORT - VID[3:0]:
  *	Index of switch port. Must be between 0 and 15.
@@ -533,7 +533,37 @@ struct sk_buff *dsa_8021q_xmit(struct sk_buff *skb, struct net_device *netdev,
 }
 EXPORT_SYMBOL_GPL(dsa_8021q_xmit);
 
-void dsa_8021q_rcv(struct sk_buff *skb, int *source_port, int *switch_id)
+struct net_device *dsa_tag_8021q_find_port_by_vbid(struct net_device *master,
+						   int vbid)
+{
+	struct dsa_port *cpu_dp = master->dsa_ptr;
+	struct dsa_switch_tree *dst = cpu_dp->dst;
+	struct dsa_port *dp;
+
+	if (WARN_ON(!vbid))
+		return NULL;
+
+	dsa_tree_for_each_user_port(dp, dst) {
+		if (!dp->bridge)
+			continue;
+
+		if (dp->stp_state != BR_STATE_LEARNING &&
+		    dp->stp_state != BR_STATE_FORWARDING)
+			continue;
+
+		if (dp->cpu_dp != cpu_dp)
+			continue;
+
+		if (dsa_port_bridge_num_get(dp) == vbid)
+			return dp->slave;
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(dsa_tag_8021q_find_port_by_vbid);
+
+void dsa_8021q_rcv(struct sk_buff *skb, int *source_port, int *switch_id,
+		   int *vbid)
 {
 	u16 vid, tci;
 
@@ -550,6 +580,10 @@ void dsa_8021q_rcv(struct sk_buff *skb, int *source_port, int *switch_id)
 
 	*source_port = dsa_8021q_rx_source_port(vid);
 	*switch_id = dsa_8021q_rx_switch_id(vid);
+
+	if (vbid)
+		*vbid = dsa_tag_8021q_rx_vbid(vid);
+
 	skb->priority = (tci & VLAN_PRIO_MASK) >> VLAN_PRIO_SHIFT;
 }
 EXPORT_SYMBOL_GPL(dsa_8021q_rcv);
diff --git a/net/dsa/tag_ocelot_8021q.c b/net/dsa/tag_ocelot_8021q.c
index bd6f1d0e5372..1144a87ad0db 100644
--- a/net/dsa/tag_ocelot_8021q.c
+++ b/net/dsa/tag_ocelot_8021q.c
@@ -77,7 +77,7 @@ static struct sk_buff *ocelot_rcv(struct sk_buff *skb,
 {
 	int src_port, switch_id;
 
-	dsa_8021q_rcv(skb, &src_port, &switch_id);
+	dsa_8021q_rcv(skb, &src_port, &switch_id, NULL);
 
 	skb->dev = dsa_master_find_slave(netdev, switch_id, src_port);
 	if (!skb->dev)
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 72d5e0ef8dcf..9c5c00980b06 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -509,7 +509,7 @@ static bool sja1110_skb_has_inband_control_extension(const struct sk_buff *skb)
  * packet.
  */
 static void sja1105_vlan_rcv(struct sk_buff *skb, int *source_port,
-			     int *switch_id, u16 *vid)
+			     int *switch_id, int *vbid, u16 *vid)
 {
 	struct vlan_ethhdr *hdr = (struct vlan_ethhdr *)skb_mac_header(skb);
 	u16 vlan_tci;
@@ -519,8 +519,8 @@ static void sja1105_vlan_rcv(struct sk_buff *skb, int *source_port,
 	else
 		vlan_tci = ntohs(hdr->h_vlan_TCI);
 
-	if (vid_is_dsa_8021q_rxvlan(vlan_tci & VLAN_VID_MASK))
-		return dsa_8021q_rcv(skb, source_port, switch_id);
+	if (vid_is_dsa_8021q(vlan_tci & VLAN_VID_MASK))
+		return dsa_8021q_rcv(skb, source_port, switch_id, vbid);
 
 	/* Try our best with imprecise RX */
 	*vid = vlan_tci & VLAN_VID_MASK;
@@ -529,7 +529,7 @@ static void sja1105_vlan_rcv(struct sk_buff *skb, int *source_port,
 static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 				   struct net_device *netdev)
 {
-	int source_port = -1, switch_id = -1;
+	int source_port = -1, switch_id = -1, vbid = -1;
 	struct sja1105_meta meta = {0};
 	struct ethhdr *hdr;
 	bool is_link_local;
@@ -542,7 +542,7 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 
 	if (sja1105_skb_has_tag_8021q(skb)) {
 		/* Normal traffic path. */
-		sja1105_vlan_rcv(skb, &source_port, &switch_id, &vid);
+		sja1105_vlan_rcv(skb, &source_port, &switch_id, &vbid, &vid);
 	} else if (is_link_local) {
 		/* Management traffic path. Switch embeds the switch ID and
 		 * port ID into bytes of the destination MAC, courtesy of
@@ -561,7 +561,9 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 		return NULL;
 	}
 
-	if (source_port == -1 || switch_id == -1)
+	if (vbid >= 1)
+		skb->dev = dsa_tag_8021q_find_port_by_vbid(netdev, vbid);
+	else if (source_port == -1 || switch_id == -1)
 		skb->dev = dsa_find_designated_bridge_port_by_vid(netdev, vid);
 	else
 		skb->dev = dsa_master_find_slave(netdev, switch_id, source_port);
@@ -686,7 +688,7 @@ static struct sk_buff *sja1110_rcv_inband_control_extension(struct sk_buff *skb,
 static struct sk_buff *sja1110_rcv(struct sk_buff *skb,
 				   struct net_device *netdev)
 {
-	int source_port = -1, switch_id = -1;
+	int source_port = -1, switch_id = -1, vbid = -1;
 	bool host_only = false;
 	u16 vid = 0;
 
@@ -700,9 +702,11 @@ static struct sk_buff *sja1110_rcv(struct sk_buff *skb,
 
 	/* Packets with in-band control extensions might still have RX VLANs */
 	if (likely(sja1105_skb_has_tag_8021q(skb)))
-		sja1105_vlan_rcv(skb, &source_port, &switch_id, &vid);
+		sja1105_vlan_rcv(skb, &source_port, &switch_id, &vbid, &vid);
 
-	if (source_port == -1 || switch_id == -1)
+	if (vbid >= 1)
+		skb->dev = dsa_tag_8021q_find_port_by_vbid(netdev, vbid);
+	else if (source_port == -1 || switch_id == -1)
 		skb->dev = dsa_find_designated_bridge_port_by_vid(netdev, vid);
 	else
 		skb->dev = dsa_master_find_slave(netdev, switch_id, source_port);
-- 
2.25.1


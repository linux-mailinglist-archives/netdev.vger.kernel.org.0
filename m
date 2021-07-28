Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBC273D97E5
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 23:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232163AbhG1VzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 17:55:07 -0400
Received: from mail-eopbgr80074.outbound.protection.outlook.com ([40.107.8.74]:44933
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232105AbhG1VzE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 17:55:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MFz8WJ+7p0VslFpioOZ6J17x6sbg4kW+41mgLERW7i5PV7dXlWSscL1bTAS0iOH4l5yGakRH1HItrvC7yR+DyrTeaixpblgKpk6ey6OIxhTdqSIRbH9JYOB3CcvAUkIGVSZ/RrGnbleTjEbArQZ3GrWU319VnYIm8i5UQoWUS8OGZ6QxKUeThTtN42r2Hb4bJ1ZyPiWnF25EMkuDUC5OF8AE3a9F9bRlzFHHzBpMNVXbhdbcbwhcmRx4W9tdFLgrpSimfk/d1jNtcf2oVHR10xVoflQu71Y3flKC5fYk9KBilk+6aqtvIYe0tj4NDuaVwiRLbzoVCs+ubi2ysrWxWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jJm7eEQZOay5O3nbeepwlLz01m38N4QObNs35l+mDGA=;
 b=XXdBp5Rpkz3gS+pqzBtp3jgw+5BedUXGe4MZDCTMQJBk2ltCDBbOzKM/JKIRkUJS+Eb7vjon7bqbOliMBHeTEQkWgfrAd0AU+LV3kdBSKRdJs2v+5gx1DCY6UcDejE1PofbPgy1YGhGseq/CXoyfXJxv/EehH79ZlKMMvPSJwyv4+UbKydwJMPTeAttun4ZjMWPNuA75wDZtEdGAdgDscdHT5KYFNrAPYPlkaAbk0/bFYEuOgi+aHJaFOiw2AzMJjGz9QxxiUmpNy2afXu3eHkapSleWJmDcjXlBY4NWNwGb9NaOhbQe5/k/YTlv95f2sCnknywQ+NiLGKEufQSjYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jJm7eEQZOay5O3nbeepwlLz01m38N4QObNs35l+mDGA=;
 b=TLaUad/Z19TteqtVxNxKreM/fVrBUhe3SqJdYs2lyMhnrm0uQOfYiY+TmL1/nVLfkcfzrpJppI4Wy0ueIs8PGFFnpkREPp9OiB+wdxd9IBtp92kzSqJNqBg+Veee7vG0GXdcLpkrZGGrADKTy6LeoNs/AS60n3s+7PKk3iWPbgg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AM0PR04MB4564.eurprd04.prod.outlook.com (2603:10a6:208:74::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17; Wed, 28 Jul
 2021 21:54:55 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::8f3:e338:fc71:ae62]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::8f3:e338:fc71:ae62%5]) with mapi id 15.20.4373.018; Wed, 28 Jul 2021
 21:54:55 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 3/3] net: dsa: tag_sja1105: fix control packets on SJA1110 being received on an imprecise port
Date:   Thu, 29 Jul 2021 00:54:29 +0300
Message-Id: <20210728215429.3989666-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210728215429.3989666-1-vladimir.oltean@nxp.com>
References: <20210728215429.3989666-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P191CA0015.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:21a::20) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM8P191CA0015.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:21a::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21 via Frontend Transport; Wed, 28 Jul 2021 21:54:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 02f70db7-d9bc-42ba-4a0d-08d9521255f5
X-MS-TrafficTypeDiagnostic: AM0PR04MB4564:
X-Microsoft-Antispam-PRVS: <AM0PR04MB4564D9808D0016C9C41DC293E0EA9@AM0PR04MB4564.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i8r1fQKj4x4dPsiP58KCXU+dFhdFY6/G7+i2RQIX2jjsdXm5OjN9/Bst8OcXrGaWFqevSQjeI7ezSsm81KWCVDbyxDp8vSAI6eQvwZ/piK/0S2M3rImAwwHBcNdcnrxh20vVrtZ9Jj+xS3LAOE2zBZtV2QYuz3SSprmyARvD3Zk16eb8gjbHwFdahH/4gvKKOUgl8I2VWJzrzDqmJxpm9pXmJoTgjtpIhM1SGkosgzPvTypB0WV1DovyDyBFYxZuPy3IOG5S2eUswQTvgCk7y5gR/XwPl4YcIgJ9//wUgd98tTFFNi655Lczn3NHsIN6NyHHSjLGPGuqQr3t7Kykj6YJ3pJ0nR1zWStNSPntOSSPS6RKkDNYzP6IVvxCT+BDMhDth2PsXoVLCmSYsQWOYG4XF9xhBJ2S/FfO1MQG+YEchUBfosVtfrYbi45ryn00BKLKVMNbzmMneY6IxYomfYRnJqukg2Op4ScViJnSmAFa9BVDz4ptBBK6GRQx1Vf7DC3iedj2y/hKZCZjDXtaT9WyELLnvBipKErTjfaLy8igW1SE6JfLz6UIiMf8DFgSoW4OrEo/5cG+rnnCM5pzROqljmkzwEulLisMwQfWa/qKbZwBlgWEQu3yZbxCSk05fGJLlxjoT8YDs3Xis70RMBK/pq/L/P1RRidKUPeQ2VUgegoJ4+z69apLClwnSfFnoGYrMMg05h+L/vvo40g3jg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(83380400001)(6486002)(86362001)(110136005)(36756003)(66946007)(4326008)(316002)(8676002)(54906003)(66476007)(66556008)(6512007)(2616005)(956004)(44832011)(2906002)(6506007)(1076003)(8936002)(186003)(38100700002)(38350700002)(508600001)(52116002)(6666004)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7F6sHOyijJGVUfmEJdzU8/6m2ULRYnz2n5i2Wq3bPS3vdccZftX6l9cLg2pp?=
 =?us-ascii?Q?iVfVF1W83Z/xw9uH5DSHdkw9+mmrch8rjva51Spu/ueSdfueyTXUVT3R6lIk?=
 =?us-ascii?Q?XgCQDacy37UjVx9pvo6ijboWPqyc+uu9XxIiV+P6IGOYEMPMuDNaXLTz22iQ?=
 =?us-ascii?Q?NoOSxh/NuMKmJyQmrPhlLJOmEtORN5fCKSBnC+Sl3wnTAarOK6j5VphppyX8?=
 =?us-ascii?Q?CT9Yn6xQWk5fPw2DzskXRLg1aXb0NcM9V6/SYBIfwqpY7OGT03KIJWCRouX4?=
 =?us-ascii?Q?O871eFL5oTlEZ8/v4rhN43ENcw/2jm3S25H46B4DX5XFfErvapiTLYqcZg8g?=
 =?us-ascii?Q?sQgHN0EYR3lOgWpkWs4ChIIlvMfYlVv6Zl2NqlokhFaHsMmmCIm7bfSEswqC?=
 =?us-ascii?Q?/QN4kJjV+KbMpbxqMSn3mSvUESgBhSLIG2RuPgznZFx/AIY3vCKwNO87OvrQ?=
 =?us-ascii?Q?tZl/4RQTz802l6b/F0y3dnegJjwFO4GbdLxFS8n8fcAWYbuL899czjuH61/0?=
 =?us-ascii?Q?vUdrqVHf2xejKhsu8TRC8fcxbnF1JjmjmPqeN7M5fRORx3pVRXpcjNU7OefE?=
 =?us-ascii?Q?2lEtTx2Sv+MMcBvm1Pg0FiqiqGArUFbKFGYDCDTHIfzFNDmhcV0mi3VmpIi0?=
 =?us-ascii?Q?bjXF38lWw0MbfMOx1zP1zI6+P9+QFLRcpQmXTgKldmD+uuBBAiifYBIloiqy?=
 =?us-ascii?Q?Yo39Qw1I87Zuc9/7nlygu37wp/t5ag+PXtKTSbC4e5h8cE4VgTcJj2uAN7nk?=
 =?us-ascii?Q?FZmdD9FzkzfMk01pTSm1QOL0nrrezcAuAZAIhKiyC+envucnVa0v5TJz8JhP?=
 =?us-ascii?Q?tTdGt8UQpNFdliISg/XoN/+YPJCL1KeSW2ZDUhYyWdw+noJtEPi0UtAFBD4d?=
 =?us-ascii?Q?0dCZaC40J0JF37Vh6rxdNC+r+wlyfid9MiSsA2Jd2TyFIWRZ1GZNAU6gle3W?=
 =?us-ascii?Q?kq1637LzcARXM3Dmam9UQxhf2XEUWQSoZKG5Hp6PlueaXVntu6WmuF125448?=
 =?us-ascii?Q?8izfZw5sXN0Em4Iwj3jrM+yTSydZmOk0dHdNcRB+MamynymYLzy2Oq0WFHbZ?=
 =?us-ascii?Q?QoTUFbgxZ7X96DtyPR3xUHZmsSDYHL7rPv6GYU24PtkJA1KJJD5NcIs9PEi5?=
 =?us-ascii?Q?+yWJYXCqJcGjojHgs7HgjSmfE9julnmKGSLVnKKvVIWElWCty9fihWOAGSUY?=
 =?us-ascii?Q?DfyBf1f3rSkON6enKP6nMo/fEu++o4wwRmzRQBFFB/AozJ+33ZnaJgeLeO7P?=
 =?us-ascii?Q?6YnrDrSpSdFdOiKUTQTPJ0yOSIQiI7fwsorppWizWax2WwHli1fUzevkJAnu?=
 =?us-ascii?Q?mRsQ/yBxUnr8eUqLNRsnMohv?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02f70db7-d9bc-42ba-4a0d-08d9521255f5
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 21:54:55.6582
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jZifxiGHEmViLrfw+37qFltDw3lOB8zH0TjdBPy9cUsr601hWhXI0hx/2K/FY0YCvFNUNeKZe6NtKtWIt/lrbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4564
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On RX, a control packet with SJA1110 will have:
- an in-band control extension (DSA tag) composed of a header and an
  optional trailer (if it is a timestamp frame). We can (and do) deduce
  the source port and switch id from this.
- a VLAN header, which can either be the tag_8021q RX VLAN (pvid) or the
  bridge VLAN. The sja1105_vlan_rcv() function attempts to deduce the
  source port and switch id a second time from this.

The basic idea is that even though we don't need the source port
information from the tag_8021q header if it's a control packet, we do
need to strip that header before we pass it on to the network stack.

The problem is that we call sja1105_vlan_rcv for ports under VLAN-aware
bridges, and that function tells us it couldn't identify a tag_8021q
header, so we need to perform imprecise RX by VID. Well, we don't,
because we already know the source port and switch ID.

This patch drops the return value from sja1105_vlan_rcv and we just look
at the source_port and switch_id values from sja1105_rcv and sja1110_rcv
which were initialized to -1. If they are still -1 it means we need to
perform imprecise RX.

Fixes: 884be12f8566 ("net: dsa: sja1105: add support for imprecise RX")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/tag_sja1105.c | 27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index cddee4b499d8..c1f993d592ef 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -368,10 +368,11 @@ static bool sja1110_skb_has_inband_control_extension(const struct sk_buff *skb)
 	return ntohs(eth_hdr(skb)->h_proto) == ETH_P_SJA1110;
 }
 
-/* Returns true for imprecise RX and sets the @vid.
- * Returns false for precise RX and sets @source_port and @switch_id.
+/* If the VLAN in the packet is a tag_8021q one, set @source_port and
+ * @switch_id and strip the header. Otherwise set @vid and keep it in the
+ * packet.
  */
-static bool sja1105_vlan_rcv(struct sk_buff *skb, int *source_port,
+static void sja1105_vlan_rcv(struct sk_buff *skb, int *source_port,
 			     int *switch_id, u16 *vid)
 {
 	struct vlan_ethhdr *hdr = (struct vlan_ethhdr *)skb_mac_header(skb);
@@ -382,15 +383,11 @@ static bool sja1105_vlan_rcv(struct sk_buff *skb, int *source_port,
 	else
 		vlan_tci = ntohs(hdr->h_vlan_TCI);
 
-	if (vid_is_dsa_8021q_rxvlan(vlan_tci & VLAN_VID_MASK)) {
-		dsa_8021q_rcv(skb, source_port, switch_id);
-		return false;
-	}
+	if (vid_is_dsa_8021q_rxvlan(vlan_tci & VLAN_VID_MASK))
+		return dsa_8021q_rcv(skb, source_port, switch_id);
 
 	/* Try our best with imprecise RX */
 	*vid = vlan_tci & VLAN_VID_MASK;
-
-	return true;
 }
 
 static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
@@ -399,7 +396,6 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 {
 	int source_port = -1, switch_id = -1;
 	struct sja1105_meta meta = {0};
-	bool imprecise_rx = false;
 	struct ethhdr *hdr;
 	bool is_link_local;
 	bool is_meta;
@@ -413,8 +409,7 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 
 	if (sja1105_skb_has_tag_8021q(skb)) {
 		/* Normal traffic path. */
-		imprecise_rx = sja1105_vlan_rcv(skb, &source_port, &switch_id,
-						&vid);
+		sja1105_vlan_rcv(skb, &source_port, &switch_id, &vid);
 	} else if (is_link_local) {
 		/* Management traffic path. Switch embeds the switch ID and
 		 * port ID into bytes of the destination MAC, courtesy of
@@ -433,7 +428,7 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 		return NULL;
 	}
 
-	if (imprecise_rx)
+	if (source_port == -1 || switch_id == -1)
 		skb->dev = dsa_find_designated_bridge_port_by_vid(netdev, vid);
 	else
 		skb->dev = dsa_master_find_slave(netdev, switch_id, source_port);
@@ -550,7 +545,6 @@ static struct sk_buff *sja1110_rcv(struct sk_buff *skb,
 				   struct packet_type *pt)
 {
 	int source_port = -1, switch_id = -1;
-	bool imprecise_rx = false;
 	u16 vid;
 
 	skb->offload_fwd_mark = 1;
@@ -564,10 +558,9 @@ static struct sk_buff *sja1110_rcv(struct sk_buff *skb,
 
 	/* Packets with in-band control extensions might still have RX VLANs */
 	if (likely(sja1105_skb_has_tag_8021q(skb)))
-		imprecise_rx = sja1105_vlan_rcv(skb, &source_port, &switch_id,
-						&vid);
+		sja1105_vlan_rcv(skb, &source_port, &switch_id, &vid);
 
-	if (imprecise_rx)
+	if (source_port == -1 || switch_id == -1)
 		skb->dev = dsa_find_designated_bridge_port_by_vid(netdev, vid);
 	else
 		skb->dev = dsa_master_find_slave(netdev, switch_id, source_port);
-- 
2.25.1


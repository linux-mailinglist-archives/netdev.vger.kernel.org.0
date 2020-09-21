Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF7A2718C5
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 02:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgIUALr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 20:11:47 -0400
Received: from mail-eopbgr130085.outbound.protection.outlook.com ([40.107.13.85]:17287
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726427AbgIUALk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Sep 2020 20:11:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iYWb+B09iuhJCxR3lQVEUaspYLMJ6G2tVfDohs2FnDj4DukLdtx2LRpliun81BNHlBQ2HJGY0be7H8V+bS003cjPmHoJWppzGtQdTJnBbd9PIj6GxvdCVDKtccyKO7q/wzKvSEOv1gJB+q919xY2EcxxTokNYOcOLfkMUpYP8CK3UUfL90Vyq7CKmlDDe3I/MHwq/GKMSJFyQdX9VsOCDK1vIidbmtrEso99kd7zFS1NScgdMiXzpKp5CogcspD8xzt28NP5xuCpCNHYi+xufevkFQf5xm0caR29uoSHNEiucgVIV6jbcp4EUH1GpOUhFK19oWocGv+lIpT8kSRE9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uKh8TtT0g6mPckEHQgioM1VBb9dRzcUW3eQMhbHI8Ak=;
 b=QY/3sybhvmmLO2Xx7oQiiXpIzC84Rssognc5/6K3bWhQzLlHtLOXCE7Ugi2lRK+bs7RyTRpVfrNzqK0jbcViED8zT6lEH8RQgWnyxV6fhssOe9sPVXxXN1T6quC/0Y/tAzODj3NaiI6PG2uhgOreW3XDPeOYewr5oUIzt92UnIiaIP2EZj9Glbd7hmsCl9Qtb2BaCtaY5pdF6sLXfeH4XBuigt9oiaYCL73tcBbnGYWua6yzJJnEDdwcVzueZ13CyoVCqYyc57T5GyNeBhZsAplxInAT38THQXH2Ueq9LoLsK1lxqVxTt7LYE96964EuH3LkSeM3ctHQS/TBl5E3Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uKh8TtT0g6mPckEHQgioM1VBb9dRzcUW3eQMhbHI8Ak=;
 b=PylFsbe5eU31oYrBrxuc56APAENG47T5+C6u596MKtB4/ASz1KIFWwH7Iizq8/lKcb1AfQ7l9MmNPPAgmndOCt+V37gvfwvkR8K3lBWdF5fK/ehAA6pxzDT0xN6SO8O9lYm8Btc1zbq8uYaZz0xRPs0ekkZJlzmbrmY665hEalk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5501.eurprd04.prod.outlook.com (2603:10a6:803:d3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.15; Mon, 21 Sep
 2020 00:10:53 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3391.014; Mon, 21 Sep 2020
 00:10:53 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        idosch@idosch.org, jiri@resnulli.us, kurt.kanzenbach@linutronix.de,
        kuba@kernel.org
Subject: [PATCH v2 net-next 9/9] net: dsa: tag_sja1105: add compatibility with hwaccel VLAN tags
Date:   Mon, 21 Sep 2020 03:10:31 +0300
Message-Id: <20200921001031.3650456-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200921001031.3650456-1-vladimir.oltean@nxp.com>
References: <20200921001031.3650456-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0048.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:5a::37) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.217.212) by VI1P195CA0048.EURP195.PROD.OUTLOOK.COM (2603:10a6:802:5a::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14 via Frontend Transport; Mon, 21 Sep 2020 00:10:53 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6e94ce82-2bc9-469c-5140-08d85dc2cdf5
X-MS-TrafficTypeDiagnostic: VI1PR04MB5501:
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-Microsoft-Antispam-PRVS: <VI1PR04MB550163D8AB5F6E5E973F0893E03A0@VI1PR04MB5501.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +g1mBv8rSOqyQaqgDRYtn6N6SITwAieY/y1oXbt6Y/fwnFm03+m1nOePnE0+y3OQtAI7n5iCegQXpYA599QrWcnyS1manv8TETQ1ypeVqgDJCIQP5iHHpDJIoXx4NtHcAv2UQ8OO+Ba355OCbqJBl4ilRxxI+Z8XMB/SZWiktvE32IsMIldM+Dac0R7UugeXq/K7VWR/zDc5qTMvfCTyFk1IrRlOXpLDhT+V87f2IDbQJwUYgPDMdNCw7mpghozqI2ynfpOyEewVpgPWHH62V6ajvdq6nXcCYu0bnXX4iDt7S9R1TpSe0jS4+E0uv5Pu1IE/EKD+QySeJlIKm8yYotfgyUiTzCCaZ2eHO7z1NpbAh91vpvON3L7aLPgl9RHw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(366004)(376002)(39860400002)(16526019)(26005)(6666004)(186003)(44832011)(316002)(8676002)(5660300002)(8936002)(1076003)(6512007)(83380400001)(66556008)(66476007)(66946007)(86362001)(4326008)(956004)(52116002)(6486002)(36756003)(2616005)(2906002)(6506007)(69590400008)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: fxRjO1Fs5/bO5zjLV/qhYDo8Rl4C87FByh0eDIaWCReVIPoqk6cUggYkaeGGgqywpp4WjqSQ/nkM/V5lJ67fcB/XTU2/ilrnsHAik2pNFJDClnmJZ8yj7gGHK80tFqSgnH+NpGBDsYyErIrCPoWdlPWwM05quaN8unfzGEMWF9v/3yO3Tm34x7fnFkc82uLS9CMd+Ey+GtH8tERcRQw7eQdckrArJO8rMFAdLsZWEric7XiN47etdE5QTxgtiEPlflhpY6Wv7sFw192ItxGJfkbcHZ6eiT9RKdAgJRF74BBkSk+4qeppm50BB9AOvknWFJGpPClQvRlR3GHu0vF+zIYzX0q60nIN+TXssJT1wQRPT1B/JtMMeyDfeWdV8sEnYnQPueWhm/JAErkOo4+9u3aHdtPzYwPkMeCQCTo1MpU4BQ3ikRztRANFv9vIOX4C5eBUSNdWhRBkRdEF6Rk3KnCGqkVpqEDM/+ZmtGNE1hecfkH7VGHWo8+N45BipuHJvLO6CzZVXHpdNcKZOp3xpIXE8T+aNlUeAf1AtDMoIKqWGZfMM0FXm2V/YPVk2I3Xp//EfzZtr9kGQ94w0jgOcT4VTznhskbH63Esr7N8Po6W3J6yckmKEphRJdmiGuhqh6O7KD6dyLpUq9bsBXyxyw==
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e94ce82-2bc9-469c-5140-08d85dc2cdf5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2020 00:10:53.5179
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sONwichCaT/QwP6XAvK8iQgQyPJhFiumZl46QDgweOmlbqFQb/a2CNCaa41f7JJ6pm5SymUueSJX+0dI1Cnxcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5501
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Check whether there is any hwaccel VLAN tag on RX, and if there is,
treat it as the tag_8021q header.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:
None.

 net/dsa/tag_sja1105.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 9b4a4d719291..3710f9daa46d 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -72,14 +72,21 @@ static inline bool sja1105_is_meta_frame(const struct sk_buff *skb)
 static bool sja1105_can_use_vlan_as_tags(const struct sk_buff *skb)
 {
 	struct vlan_ethhdr *hdr = vlan_eth_hdr(skb);
+	u16 vlan_tci;
 
 	if (hdr->h_vlan_proto == htons(ETH_P_SJA1105))
 		return true;
 
-	if (hdr->h_vlan_proto != htons(ETH_P_8021Q))
+	if (hdr->h_vlan_proto != htons(ETH_P_8021Q) &&
+	    !skb_vlan_tag_present(skb))
 		return false;
 
-	return vid_is_dsa_8021q(ntohs(hdr->h_vlan_TCI) & VLAN_VID_MASK);
+	if (skb_vlan_tag_present(skb))
+		vlan_tci = skb_vlan_tag_get(skb);
+	else
+		vlan_tci = ntohs(hdr->h_vlan_TCI);
+
+	return vid_is_dsa_8021q(vlan_tci & VLAN_VID_MASK);
 }
 
 /* This is the first time the tagger sees the frame on RX.
@@ -283,7 +290,8 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 
 	hdr = eth_hdr(skb);
 	tpid = ntohs(hdr->h_proto);
-	is_tagged = (tpid == ETH_P_SJA1105 || tpid == ETH_P_8021Q);
+	is_tagged = (tpid == ETH_P_SJA1105 || tpid == ETH_P_8021Q ||
+		     skb_vlan_tag_present(skb));
 	is_link_local = sja1105_is_link_local(skb);
 	is_meta = sja1105_is_meta_frame(skb);
 
@@ -292,7 +300,12 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 	if (is_tagged) {
 		/* Normal traffic path. */
 		skb_push_rcsum(skb, ETH_HLEN);
-		__skb_vlan_pop(skb, &tci);
+		if (skb_vlan_tag_present(skb)) {
+			tci = skb_vlan_tag_get(skb);
+			__vlan_hwaccel_clear_tag(skb);
+		} else {
+			__skb_vlan_pop(skb, &tci);
+		}
 		skb_pull_rcsum(skb, ETH_HLEN);
 		skb_reset_network_header(skb);
 		skb_reset_transport_header(skb);
-- 
2.25.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6CA02711B9
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 03:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbgITBsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 21:48:33 -0400
Received: from mail-eopbgr80081.outbound.protection.outlook.com ([40.107.8.81]:45178
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726880AbgITBsc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Sep 2020 21:48:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HtEgiD+3XQZz+e9pBtH6vkamjk7d5sTmAxtWffi6Mm/PaVPJOuYZJjbZ4xrvUfvGKpOTZ+mSWk47r1GNKR0lLKq0zur1i4aMDbjaljAFw+mLXVYdK+WJjtofGfaB1wh6B29naIu4suGyaYjmTDTBt+eY/vKkpIEpcIB/c5KFrTCeSv3EMkLtl2VSRuxDF686ZcIAhegx5RUGBOVUsuJQ2HnYvVUCecQ/Es0B2zV1vhPP3cQjg7T1C1DlWnk3rsbbUyMTD1Lo6xsw1qywQ2DHLR3JLEkbk4IFIvqiNto7mBzXmdD2zFJ1iH+TMO/UWA1qDINd6ZHoggeYEw3Vpi6ICw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a/yyx0a8lgafPyWgqZd0m2oGo7QlisWaCB8gQnAkzN4=;
 b=PCcPrCJ0M/+EXQEVL59icaZZCL4FJsVgZSfyCyNzvL6WxAp8Z5ViriiYIC1YI1pKr4Fd0gvDEGrtQjmrBg/0NzXFscziRb5dNoBX1FpfZiuu2fs+HH/cBovPZ3pCq9qIitGWS2teDnKfqc/tUDNSH6NY95rWIBbjIqaa79c4aOSIuqJLlGucqSluFGw5aP2q0z2tiIKkWj8eKAZ9uqHmmS8ZaRpohoED7KxQR1Phjlv/AXxt0q+rKAXqMkBgQdzM9wm/+4b8+9KG0MaKjxRuNTorkNlGhILHjg7puaCwBkxL401Us1Hc2lmmoOb1/GMbMcnJ97ecagfS/uND0cYUkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a/yyx0a8lgafPyWgqZd0m2oGo7QlisWaCB8gQnAkzN4=;
 b=Hts052Ca/DWsBce73+k51UgjMLQeCcNuUBlYsidKJZc3S04iJVpqx3eAG7dUQB3hdDaEbsGIKB7CVPHDGfP6/iJJrRaovRtiYzTR6CRXVv+o2B9lCxl26Wj2fLAeS6aQlfCdARKvjpF6zCnDtgFb1vReO9osRC4Etj3hWe7VSkE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0401MB2686.eurprd04.prod.outlook.com (2603:10a6:800:5b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.15; Sun, 20 Sep
 2020 01:48:14 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3391.014; Sun, 20 Sep 2020
 01:48:14 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        idosch@idosch.org, jiri@resnulli.us, kurt.kanzenbach@linutronix.de,
        kuba@kernel.org
Subject: [RFC PATCH 9/9] net: dsa: tag_sja1105: add compatibility with hwaccel VLAN tags
Date:   Sun, 20 Sep 2020 04:47:27 +0300
Message-Id: <20200920014727.2754928-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200920014727.2754928-1-vladimir.oltean@nxp.com>
References: <20200920014727.2754928-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4P190CA0014.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::24) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.217.212) by AM4P190CA0014.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11 via Frontend Transport; Sun, 20 Sep 2020 01:48:13 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8ff61b3d-1ee0-4558-a23d-08d85d073cfd
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2686:
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-Microsoft-Antispam-PRVS: <VI1PR0401MB26865A98B7DAA73D7C8BCAD5E03D0@VI1PR0401MB2686.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: esktbXqsL5B/38WOGXtUtSiqsnIL8b1ru4zV0pGU1Zftt7SlW/mkolPfImwlH1XbdMOmF9Lx+79YVxzUUXBQ9HQQXYl/sfN4w3k6Bh+lSDKF6ySpEPbed53H3USaR3D32hnoSLaiLcPzMMOrprC2FDy0oShMcL+nBRJiRPvHGI7WgIgsi3gU0xItomvP77SpN4kpwYETrMG5+GrXTBv7PhtEgWXuijYuCsIsLVtMveOHQAb+gqJEttyoFhsOW5RbX+yZVSpAYruvXEDLuTAqbaF9TBLkxw4gjWJVd9HvDHg4JGlm19yHq0XMaVfuymS8uvJxr24BB2M2Pf7bEgpYDIVIS9U/ba8IMLHLjLFurnRUoE6gfzu/c5l5zaXsclIk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(366004)(136003)(346002)(396003)(4326008)(69590400008)(86362001)(66476007)(66946007)(66556008)(83380400001)(6506007)(2906002)(478600001)(2616005)(956004)(36756003)(6486002)(52116002)(8676002)(44832011)(186003)(16526019)(6512007)(26005)(1076003)(8936002)(6666004)(5660300002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: YNZH7rkhkjds9kcEfHS1QIeHvzErJynW5B5+FBNITkY2AQqFsx5jlfIcMsLQNLVn5o2p1jEp0gHuX98QUxyXlGTTIh26a2VuT1gPPrhxAnHTzIuOEEbOoNAWjoLZtka4mPnn5A4HMiKPchqpvzr+eBgYWeoWHUGu6vRjMmhYpEmYWXZFFhf5TDKsziMDkhQ+zHEKAloI4cQ924G0XomXhNdATIShWgbXR/0Rd91oTOmUo1sP+Lhjb96d91jtCYw8oGuaGamZOsMfXLt9xzB0O2NFtd100mtLqafSieCwlyD423+npNdmba7WwZ8nXcT11Vlns4jGZm39lIqhm0WwDaNeAPBknXitkJ7cOkvR/gKrfPbFPnijGzCNAnJ7mHwMBlNzrcOP+Wc9BKC/7qNboKXYSsbUdcHYiGRcvjoFjWpYaj5nreQWVMgol2yqJmOXcU7IPtJEhAp5Eb7Wm9oi7IGYqU1WHPpqSXqzMUj8qZouOLbBp3aNgzOkGeoMg626J/krdIH5OQqlcbtbTWp0MeknLzfnCLVXpKWT+h5VdKTm4J3brz1QtOd7P5Sz1VEosBZznSHa5UBkGTaqCFyI/gBVDqhovYQg6ASz5CGbU9wV7iD+F8CG+FOPY+rtjJgg7xPiYU8b5X4NNEPUHFIRdg==
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ff61b3d-1ee0-4558-a23d-08d85d073cfd
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2020 01:48:14.4313
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wzFihsiY3L1Gdl21UUz+BI4h219xf65L0U0UWUvw7Fb7diZJ/u862MgL4yQhoTZiNkyvosadqreqtatHW5xMqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2686
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Check whether there is any hwaccel VLAN tag on RX, and if there is,
treat it as the tag_8021q header.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
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


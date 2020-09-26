Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC37C279C2B
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 21:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730233AbgIZTdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 15:33:25 -0400
Received: from mail-eopbgr130041.outbound.protection.outlook.com ([40.107.13.41]:63047
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730222AbgIZTdU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 15:33:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c/oL4xXbA01gynlYiVsR/iimitVklBYKFqyLHvyhPIyVhHq2wUSQ5TRTp3YT1bV5e+dpzfVVJ3FS2blfy+NrSQoamyrwXLpI4ccnI5hd+nf+QZCVNeTrEr/SkKXm2CL50vTvGD2X3hbmfeqZaKENsTTIjkCweaao96yVmdPcZWBlDb+/gU/Pgp5wZFzTs/vKtBGfO4PFhNRS1tYzwv/kEfG/J/irnnPzJlOHLkNMCMz+DIGujPZyGyuwCJPvY9zq9zB9IanEtu5GLFx8FmF4z1/faTsdOM5jR7gAivKIeMH+x+qE0l5CqdO+3tM2ELu6juotpdFAO+nPwJazlO5XrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UclgL1A6XNDQKFQWZf35aspVvfsbEgz6oWB2qNL0bSo=;
 b=keI23d2Q8X9IFmwfAvso63vVjsek+YP41jp+wKeX3No/bQe6zK3XXaGquCgXGIw1ElD0M1pBhzxYKMTh/BV+eWX/8E8jhVzDgLWG4HvlX4ifhH6JiChd4jNNEwV65M0WXPY7UmejBDnQkhUQFMOwmbDT3JqQjmrQRF330vje2HGcDpTdw2n2Hso1KVOWGePfiwv6zgCMotIEtr/SJQxnfWNCJct4TbnKZjDKR0rywxPTQ1+zfZ26k5w4dFFqzWlEris49lADJpQ53zbmuzm5uhTzBKtM6zDiLBdICvnB926FkWrJmTSOqY3yJNPrWLJ1LQxxy/LIDTLx7bMXin5U7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UclgL1A6XNDQKFQWZf35aspVvfsbEgz6oWB2qNL0bSo=;
 b=ohev18b5v2ZrmkwpnHaM5XAUMvrswdlQMJ8f68wSar990V4I6S6RFRrcgFA8Z4qnKN9QfDEF7DRmoXl92EsFCP2l5U8KMDHLO8higXVqWb7CQVQWXPkFVaNFAt6SAcLji87mKJgED+DhfabIER+u0gvzADV6buEOEhO/w22jmNU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5295.eurprd04.prod.outlook.com (2603:10a6:803:59::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22; Sat, 26 Sep
 2020 19:33:07 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.024; Sat, 26 Sep 2020
 19:33:07 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org
Subject: [PATCH v3 net-next 09/15] net: dsa: tag_brcm: use generic flow dissector procedure
Date:   Sat, 26 Sep 2020 22:32:09 +0300
Message-Id: <20200926193215.1405730-10-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.217.212) by AM4P190CA0017.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.21 via Frontend Transport; Sat, 26 Sep 2020 19:33:06 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1135b93e-1fee-43a2-5b41-08d86252fe85
X-MS-TrafficTypeDiagnostic: VI1PR04MB5295:
X-Microsoft-Antispam-PRVS: <VI1PR04MB5295622F55B4F16B38F8FD1EE0370@VI1PR04MB5295.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XPHg2qZSDyA6WzAN2Zk7hERAgsOIv7MYb0Q9rHNKLuAG11IdzXagLGEV0pVm3oL5AiMvZzpZy6JWCvYa/JAqakAPz/93Dj4AEOFlWVFpShIu8Ia/okapdWqTafwBc4VwUPxAeN8BhLu+QQIskB7U0WerZu4+IAP3NX2y9bWHfu6Q5+kVk0TBEK9TaEv5bqq7a3Kj56qjsfF10HPyoCwgdzGFOFsj3nA98apVLxwcLgggSFLOvxFMey29+PBkMbHfo1Ryj4m4W6Cs1tEqy2+r+y9fN1naedrdYNLLsATJM6ctLNMJ6uqHFn2kX+ne1n2Sq4qRvcRB8H6QFxmQuSkyPrDZKhxI7Ghh4yC23m8EfwXHjnXGokcikz3kLya2egl4ZvSyPRZhNfBsJxhT9WH4v2CICxG0Ce0RmevjZJVtJui8qQKfWrFaKa4hBTBqS8Hxkzi3OQSO5SBO9anDEeiu7Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(376002)(346002)(136003)(66476007)(6486002)(52116002)(66556008)(2616005)(956004)(8676002)(44832011)(6512007)(26005)(2906002)(478600001)(16526019)(186003)(6506007)(36756003)(86362001)(8936002)(1076003)(83380400001)(4326008)(69590400008)(66946007)(316002)(5660300002)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: UWv27nOnpT6LzSD//DkzI6aHsKom1BJYklVjjlxmLifjbJmyQJi8/XG/iqwdwzr12Lsr7hxVrlhdrMzutVUaTylYvGNJoj4f8ggmSrhS0lSXQneaIj473CkSJGYEWD3UC56R6CnVhnJ1KKqWyhT4Oeu/URKzDjNgYj0owopHWy+wx4IqA8CnSrNwFqSFAVv3kp1vmiYkpz4+/KY28UuCcXE8m1c9w3h3jOiy9rFidL1vK9oScYGryu4nR0yts5H+p/P2I7nR7h3y2jykZc8/6QPh1+/kfCfJ+/FLWeTh/nc/fBFeRZOilqjwMNztYRgw+aqKwrWFFiZ4H8CFg4DrE1DlXKPomWpSOB6Eys7Xz4bYRt3Jn2Bddb6Pq959VdVhbWQTb+KTuhTkvJeMgVnHej2lTitDRi/F2Ce7Hn+HZdRxmZ4tNYafCB9wio2O9ZFwXhotiPBrDkIzPVSQGQ/vcU3283EQtXFFaUMGTK/GIgCLq18EQ6dkIG5rur4V7r1/e6mV7PIyalltJKHYncwbVA2ZIr41248DUF38YFIb+iBmFbyqJW6LGHgCnf9z9QyvVo+XiAjv8I2fV6+HF9RP/Y0fwIM1OAmMtNVrg8IKJFjLAzE0/ZCEjwGl4wC4v/DVhY2bnrt7tohP+q34gxS7aQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1135b93e-1fee-43a2-5b41-08d86252fe85
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2020 19:33:07.2236
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m5xZyC2u23fPSgXhcL72zp3bntFL+R7uZpcosoJ9LeAET0p18VCWvFco0p5ws7KhYxXyDLN/0ZCPSsCS7XO+DQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5295
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are 2 Broadcom tags in use, one places the DSA tag before the
Ethernet destination MAC address, and the other before the EtherType.
Nonetheless, both displace the rest of the headers, so this tagger can
use the generic flow dissector procedure which accounts for that.

The ASCII art drawing is a good reference though, so keep it but move it
somewhere else.

Cc: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
Remove the .flow_dissect callback altogether.
Actually copy the people from cc to the patch.

 net/dsa/tag_brcm.c | 34 ++++++++++++----------------------
 1 file changed, 12 insertions(+), 22 deletions(-)

diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
index 610bc7469667..69d6b8c597a9 100644
--- a/net/dsa/tag_brcm.c
+++ b/net/dsa/tag_brcm.c
@@ -107,6 +107,18 @@ static struct sk_buff *brcm_tag_xmit_ll(struct sk_buff *skb,
 	return skb;
 }
 
+/* Frames with this tag have one of these two layouts:
+ * -----------------------------------
+ * | MAC DA | MAC SA | 4b tag | Type | DSA_TAG_PROTO_BRCM
+ * -----------------------------------
+ * -----------------------------------
+ * | 4b tag | MAC DA | MAC SA | Type | DSA_TAG_PROTO_BRCM_PREPEND
+ * -----------------------------------
+ * In both cases, at receive time, skb->data points 2 bytes before the actual
+ * Ethernet type field and we have an offset of 4bytes between where skb->data
+ * and where the payload starts. So the same low-level receive function can be
+ * used.
+ */
 static struct sk_buff *brcm_tag_rcv_ll(struct sk_buff *skb,
 				       struct net_device *dev,
 				       struct packet_type *pt,
@@ -149,26 +161,6 @@ static struct sk_buff *brcm_tag_rcv_ll(struct sk_buff *skb,
 
 	return skb;
 }
-
-static void brcm_tag_flow_dissect(const struct sk_buff *skb, __be16 *proto,
-				  int *offset)
-{
-	/* We have been called on the DSA master network device after
-	 * eth_type_trans() which pulled the Ethernet header already.
-	 * Frames have one of these two layouts:
-	 * -----------------------------------
-	 * | MAC DA | MAC SA | 4b tag | Type | DSA_TAG_PROTO_BRCM
-	 * -----------------------------------
-	 * -----------------------------------
-	 * | 4b tag | MAC DA | MAC SA | Type | DSA_TAG_PROTO_BRCM_PREPEND
-	 * -----------------------------------
-	 * skb->data points 2 bytes before the actual Ethernet type field and
-	 * we have an offset of 4bytes between where skb->data and where the
-	 * payload starts.
-	 */
-	*offset = BRCM_TAG_LEN;
-	*proto = ((__be16 *)skb->data)[1];
-}
 #endif
 
 #if IS_ENABLED(CONFIG_NET_DSA_TAG_BRCM)
@@ -204,7 +196,6 @@ static const struct dsa_device_ops brcm_netdev_ops = {
 	.xmit	= brcm_tag_xmit,
 	.rcv	= brcm_tag_rcv,
 	.overhead = BRCM_TAG_LEN,
-	.flow_dissect = brcm_tag_flow_dissect,
 };
 
 DSA_TAG_DRIVER(brcm_netdev_ops);
@@ -239,7 +230,6 @@ static const struct dsa_device_ops brcm_prepend_netdev_ops = {
 	.xmit	= brcm_tag_xmit_prepend,
 	.rcv	= brcm_tag_rcv_prepend,
 	.overhead = BRCM_TAG_LEN,
-	.flow_dissect = brcm_tag_flow_dissect,
 };
 
 DSA_TAG_DRIVER(brcm_prepend_netdev_ops);
-- 
2.25.1


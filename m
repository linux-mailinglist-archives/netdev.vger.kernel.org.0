Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 578756C5A93
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 00:39:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbjCVXjF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 19:39:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbjCVXiw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 19:38:52 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2048.outbound.protection.outlook.com [40.107.8.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 901B82B9E1;
        Wed, 22 Mar 2023 16:38:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b8ZIpwmGpyTRR9b/4DI/oT/EU1Lt01Sde/O1h0JJ+ZWdSshJPuVEF0PCawQAQikTa/5MT3XwRkH8cpL3n/GoPgGhRW5ZeQ795CWGgA3VKu6FCtvhy3xSEQLkriJ0L6fGD8BKfVc+2k9Kv6vMJC+TjI4P7hdHWoLSHMM/vTwGYz1QprMjsKWpmPHxUCnBx5BGexzBqt6a1+MU7AajckF+RykQUwqcOlx+YcjQQNLL2LV98hJNz/cj3Jt2M+1gzOrC+liThsrsnh2EernCSPGMjVl/CDd8DMsRRDA4qnDU6igT/scFHtw2Fg2EXNvOFI/EKRMxlBC7YGtzvw0dBHI4fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hd/5oYgaxvpHfDjM/kbGG6yPnjs27J4T7oS5QnTeMXA=;
 b=IlY16sRmBkKY9DrZPw367QbdvQuxPzlerUk1CwJQ8tgKDdVJbdcUNNQjH553sgy+0b0tyxafJZwnipzjGFHEsfo9gwAO55XT9ZAho8B5c0u7+gpfrFKFuyPsA/rDB0jpSEZCkJUUH3U+8Qc+5lGCx9tj9WfFqSlywcnC5ZLwCB+z5X8CbWU9EwvVwF5vE/A/CerRb4WX6VFVsKUTNm2RQajY6WUdKO17Y4cKEd1sTTOecqpoZeyrBKzC0c4b9p4pZyjMxs8RsOI31UKjFmMTrFEBXbzjkXnGVRgdQSPoL02AUmzA9YaCC1ziR0o+LPbBL8f8f8EqtUZTGMdyR1jjtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hd/5oYgaxvpHfDjM/kbGG6yPnjs27J4T7oS5QnTeMXA=;
 b=N6uNlSoT1ztnE/6GPg13MyG1WjzTjWDmxfIxHvWK0ekJTVIhQ2a5iV0ysq9TsfQbxI/mKp0xAkoFWooZ7ZhjFvWXOD7+lmf2oTWScLQ+lqD+3X/i3wVRF5O6UxCz414wGGH7OrsiZCeicDwu6K9msF0tcLwOpjvAT3Hj0TtAxvc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by VE1PR04MB7263.eurprd04.prod.outlook.com (2603:10a6:800:1af::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 23:38:40 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8%7]) with mapi id 15.20.6178.038; Wed, 22 Mar 2023
 23:38:40 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 5/9] net: dsa: tag_ksz: do not rely on skb_mac_header() in TX paths
Date:   Thu, 23 Mar 2023 01:38:19 +0200
Message-Id: <20230322233823.1806736-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230322233823.1806736-1-vladimir.oltean@nxp.com>
References: <20230322233823.1806736-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0081.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9a::8) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|VE1PR04MB7263:EE_
X-MS-Office365-Filtering-Correlation-Id: 798b6d7f-d903-4ce5-0f91-08db2b2e90a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k21tdOphDvuzhUxRrHBsXGh/TDj/qsz0XInkHqEld271PflsLswgqT14ayPzyY9PwpGMT8W60Ksgu8euk25yaEYdtWkhRWNvr6/2sw3ubovE2+Y4MToQy/rDSuamakJU4AJ170TqlXxB3WeXGRMEsngTUtPF1cEioY9F8LLoy7lO73ZKOUvw4QMdByRTQt1zrskKfzgKpgS5U8HZvpkQg/mkm10B4Sa/o5jY2P9s9d2ls8mqn0H+6/r27ietyUF1KLD6w5VqfXfdGjcqykJ3CYDN4hNgnhxQ9ZzKcezmC1PDTIYVrzgxmYc/OTtyWzxbnm324fTMntAVqurAM6ZxLM+RxDc83567+eBty4pls2me8vAs4DE+G9tlbjhThDyDS+GFJqhSg7ywLDHq0bfbFRQastP/WCIe+vvWjn4vpQ+UU5nPPOHcunm0IiyTDJ3j7GiDLO3WReqsXhY4sm0pzMANIpgORGaKrDAgKWb4cB+Xq7G0eCfv3+i4g1AhCQYFONjXASYONKE5djwtfmA0nXrnnyrTpnM70OjTyN+0g1/b1wgqGDxNDbaXG8jRN77Uwnb5vOGNXfPq2q6ksGuaHt+aiCL8Rw8DElFGXoEIAtpKfj0ESUVvQxcC5njkiPcqBFl6jHTYbR/hroYI3Rsykbo3aJ7xCt9klxYshKnTPzqVYrUQG5Tl2hvF6xSZLCNc7NsfK82OGUftaJqCD+zGAI+tsWLCkpiq3YhMbd+r7TxKelX2kpIEL+IEE69sJc0P
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(39860400002)(136003)(366004)(396003)(451199018)(54906003)(66556008)(6486002)(6916009)(316002)(66476007)(8676002)(66946007)(478600001)(6666004)(4326008)(52116002)(41300700001)(6506007)(1076003)(6512007)(26005)(8936002)(186003)(44832011)(5660300002)(2906002)(2616005)(36756003)(83380400001)(38100700002)(38350700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BSQNfs9N8YCoC/EPAiNueapYRO7JCAbUo6YWnGwQNoTLWrn54Nt2yCFgtq7D?=
 =?us-ascii?Q?lFNKCv2stwB6nX1ddm1L7sn8OS2hVAGG3D6DUBItAWrkGXnNTEIqOCiYVcRK?=
 =?us-ascii?Q?no77ntYu6YdJ42LXD7JgHZfMk1SHf60ZQ7+sLYykXPJ9jsobuG7fHwOsfs2H?=
 =?us-ascii?Q?CS7TR0TkhQVGOPAjjqfw7kTvAVqnfTYDWzIjlpGZttwIgRy1Dt5akW8xVTRX?=
 =?us-ascii?Q?LiEiY25FTjRiTRqwo13q2ACbJsxIzjMAHhfHiGT9vLRTWbzJGjY4j/b9ufeZ?=
 =?us-ascii?Q?/IwmFbaiPN9D8ZeK8+/sizJWXUD6hiWCeplVZyPdV1JVutAmzlHX0d3DLzG/?=
 =?us-ascii?Q?26+3VWSRK8jQekwvnPBrMCpvqsWNL0z1MCwY+m3RzOKw/V5CmAhpqWnMRf2Q?=
 =?us-ascii?Q?6NZOcWXgjayJ9i8UhC15hPth0q74vKaP2z6RZvu0vUsfJ+oFRpF4JBVTiya7?=
 =?us-ascii?Q?8Xt8d8nlR8caHIowGzo+83WyD7us5zLg8E/ec/3ap7eIeqPi8y2uESCZbQUT?=
 =?us-ascii?Q?AtPXQPgREbcvqD3k6Nl2aRWAo9TYdxXiX9iylwh8u4pp/oYaMpo6WLJnnTQq?=
 =?us-ascii?Q?YKRV9W/Ku9qbbaYKBOZgM4XgKbRHerRV+rCnpriUV6U7hr7z2FxBvKcF8fNV?=
 =?us-ascii?Q?N6Kzdw7GaZfC+sv8aNPUFB2tWDtsGxGqsuHJNprT4+g6PwnPXMK23uENQJIG?=
 =?us-ascii?Q?t+tS5oXFnnBZTpc6BtW95i6LxBOrsBulx0K1MSNai66x/d57CGyU847UVwz7?=
 =?us-ascii?Q?a8weMg0aZb419su7U5+QjrA3MJOmRK+mOl7hCCSOaxN4EVIUs6UFzb0gwS7v?=
 =?us-ascii?Q?HscxgVsQPHgvJO7Ev+cYErEnLxuW/mvSvM5+mOaaCgKla9TQ92pZlYTfLIbH?=
 =?us-ascii?Q?W3DAGg0eTiRNcTUz4+WVT8bDssyYyLBULeCBkCqDB611S8Mx5EnFWC8zzjZR?=
 =?us-ascii?Q?F/VW+8JB0oHwwC4JsrtTAAGorg59lrTK4VfNUZrKx/eJD8h3idcEIWgQBFyM?=
 =?us-ascii?Q?O9z1Ghj79JH7Lv3+wB9jF9j57bW0LnslmtGMFFaJTaP3FSkWn9wQvYyrzzxn?=
 =?us-ascii?Q?kJydBoqg0fUu1S7blYcmzLkhSn7gCZNqTfUy2r9zMqjP18RhHxtNjhH02G9A?=
 =?us-ascii?Q?mg8sp4BDX8Wu0KmBeU8gsKrXsySymJwi1EISTuQhwfqfCp5xepTCz7++ouMu?=
 =?us-ascii?Q?RYjZ/2m0UoWW+heG/0OYqQfGjznnAw2n+wd3uWi1bUVYbv/T+mJIRqPfUd6R?=
 =?us-ascii?Q?7dO9Wh/i5EW8RNsNjFLvOQOKNhEs6jj3KBA6lJnUUFn+oqU556Zinuukt5jA?=
 =?us-ascii?Q?ZbohnMvcTaG8rVnklajh0wLT7IGQPXVZyXCL//AzHN/KViKfqnxE36iHXxWv?=
 =?us-ascii?Q?zB9v2XK8jOTROYE9sgP6UghomqpidjCTlIqeAjY+WjfoPS0srzsWpaE2Xc7e?=
 =?us-ascii?Q?6uHhCf5yBE++u64D62/zKs1806QbVeah8dPEwg+19P5MSL36zxgFphDcJrzj?=
 =?us-ascii?Q?OpgqxujCOTVUaJ38FVQaIMyCnbJcb/9j2Jo5HqDjbdUWQXtU3DF2/3cjoZPw?=
 =?us-ascii?Q?a9d6MrWPICprKWSKIqN7uuRm0n7a6rb6mFuRWZ78QkEbYfjoy4vfCldA6H0R?=
 =?us-ascii?Q?4w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 798b6d7f-d903-4ce5-0f91-08db2b2e90a0
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 23:38:39.9518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nQx29gAAWjr7iRt5JqVzAz3r4XGqMzS74O6sFbFPafJP20ug/OpuTnQYgF691cT+IQaLMrffEPUJ5zSdYB1PNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7263
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

skb_mac_header() will no longer be available in the TX path when
reverting commit 6d1ccff62780 ("net: reset mac header in
dev_start_xmit()"). As preparation for that, let's use skb_eth_hdr() to
get to the Ethernet header's MAC DA instead, helper which assumes this
header is located at skb->data (assumption which holds true here).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/tag_ksz.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index 0eb1c7784c3d..ea100bd25939 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -120,18 +120,18 @@ static struct sk_buff *ksz_common_rcv(struct sk_buff *skb,
 static struct sk_buff *ksz8795_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct ethhdr *hdr;
 	u8 *tag;
-	u8 *addr;
 
 	if (skb->ip_summed == CHECKSUM_PARTIAL && skb_checksum_help(skb))
 		return NULL;
 
 	/* Tag encoding */
 	tag = skb_put(skb, KSZ_INGRESS_TAG_LEN);
-	addr = skb_mac_header(skb);
+	hdr = skb_eth_hdr(skb);
 
 	*tag = 1 << dp->index;
-	if (is_link_local_ether_addr(addr))
+	if (is_link_local_ether_addr(hdr->h_dest))
 		*tag |= KSZ8795_TAIL_TAG_OVERRIDE;
 
 	return skb;
@@ -273,8 +273,8 @@ static struct sk_buff *ksz9477_xmit(struct sk_buff *skb,
 	u16 queue_mapping = skb_get_queue_mapping(skb);
 	u8 prio = netdev_txq_to_tc(dev, queue_mapping);
 	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct ethhdr *hdr;
 	__be16 *tag;
-	u8 *addr;
 	u16 val;
 
 	if (skb->ip_summed == CHECKSUM_PARTIAL && skb_checksum_help(skb))
@@ -284,13 +284,13 @@ static struct sk_buff *ksz9477_xmit(struct sk_buff *skb,
 	ksz_xmit_timestamp(dp, skb);
 
 	tag = skb_put(skb, KSZ9477_INGRESS_TAG_LEN);
-	addr = skb_mac_header(skb);
+	hdr = skb_eth_hdr(skb);
 
 	val = BIT(dp->index);
 
 	val |= FIELD_PREP(KSZ9477_TAIL_TAG_PRIO, prio);
 
-	if (is_link_local_ether_addr(addr))
+	if (is_link_local_ether_addr(hdr->h_dest))
 		val |= KSZ9477_TAIL_TAG_OVERRIDE;
 
 	*tag = cpu_to_be16(val);
@@ -337,7 +337,7 @@ static struct sk_buff *ksz9893_xmit(struct sk_buff *skb,
 	u16 queue_mapping = skb_get_queue_mapping(skb);
 	u8 prio = netdev_txq_to_tc(dev, queue_mapping);
 	struct dsa_port *dp = dsa_slave_to_port(dev);
-	u8 *addr;
+	struct ethhdr *hdr;
 	u8 *tag;
 
 	if (skb->ip_summed == CHECKSUM_PARTIAL && skb_checksum_help(skb))
@@ -347,13 +347,13 @@ static struct sk_buff *ksz9893_xmit(struct sk_buff *skb,
 	ksz_xmit_timestamp(dp, skb);
 
 	tag = skb_put(skb, KSZ_INGRESS_TAG_LEN);
-	addr = skb_mac_header(skb);
+	hdr = skb_eth_hdr(skb);
 
 	*tag = BIT(dp->index);
 
 	*tag |= FIELD_PREP(KSZ9893_TAIL_TAG_PRIO, prio);
 
-	if (is_link_local_ether_addr(addr))
+	if (is_link_local_ether_addr(hdr->h_dest))
 		*tag |= KSZ9893_TAIL_TAG_OVERRIDE;
 
 	return ksz_defer_xmit(dp, skb);
-- 
2.34.1


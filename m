Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA8B74B0F07
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 14:45:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242369AbiBJNpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 08:45:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242355AbiBJNpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 08:45:12 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70053.outbound.protection.outlook.com [40.107.7.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E7D0CF6
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 05:45:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eZW17U2EezQPXBZgF2DTuX+eT2kEkm3/vYPbte9Wc3TR0ikQxjY6xVOyAJsL5v+HulvGSj+5uqnRiPHy9Ho9KtehOEEP4mN9xysPh7QNfGJkKi2TyVjxccFfPlPgRdXDJ2P9Zk6HRUU5cDmdKfLSW/JB2kwmtppgkgJ97p8bpnkWvSMf7EVUDDWTS3Gf4zHqmKYJmYUSae56CBJNHP+LgbmbsUoP8kxNpQi16sY2xwfVwvtuAnXpNGE4T5GQ5n7vQIvd3sEVfRKgJinEDXe1C+If0mnVKQFcQJ1Ilwf00+AP+znMBH6ffoSRdkZyTqAulNrn0lHqrAv3jjJBV9heIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xphy4wvgsfv1Af5BHNqSSsJPl4RH52mnhdXgKeWwDc8=;
 b=bS8uWa0Xza2RmYrXS3UzYO2IeAoPDi9U0LBb61feHx+V0elr5pdbW90ZIFsCX0E+juP8M5/G43Q5FPPUPjTTu6nwv3Vm1hnYsV68KdwrP2jQcUtICY0Gduh+YQwJXb3YQvbwB9Ann/ccVA58YyXjxyVqWLHEDUBt4DM5YDFZh9aaZ4568sZVpy3BwG6ywi//C7cZ0TFmTemkKm4jDdrv6nM7hI5eU/RSA0b/zqqkSGFzl62lSSfTJasrG0ClB6ELAeoExP5dsh6ZjA0azfpHnPEalGCo+ksncyT/10+rCSN18TAwccMsUqRiRk7yrMdD+45PVfuJR//cjf6P+jSOWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xphy4wvgsfv1Af5BHNqSSsJPl4RH52mnhdXgKeWwDc8=;
 b=BoJWsUcJD1L4rQ33dV+DUGoO5DMqClxBLvbQqYhLhi+TOHTDRhJH0HHsoSvlIJrA7JeAhO/pFzrv9thz1mzpDIh3WTFaoUAVwNbdP8x9WkgRHEXJKE4Xhh+0wRywL7uBuu/g7JNr9UiaWS5TVqnL5DiNeTcPu8oTno7kbCtQjTI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2493.eurprd04.prod.outlook.com (2603:10a6:800:58::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Thu, 10 Feb
 2022 13:45:10 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Thu, 10 Feb 2022
 13:45:10 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH v2 net-next 1/3] net: dsa: remove ndo_get_phys_port_name and ndo_get_port_parent_id
Date:   Thu, 10 Feb 2022 15:44:58 +0200
Message-Id: <20220210134500.2949119-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220210134500.2949119-1-vladimir.oltean@nxp.com>
References: <20220210134500.2949119-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0097.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::14) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e4b1b3e2-67e7-4b24-49d4-08d9ec9b8e8d
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2493:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2493346091E118F8BF4282AAE02F9@VI1PR0401MB2493.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6ewn05JobtkOoRbw3TVMGlv5cuMM+6YZebSJL5TUvQ33jcmir6chRdJ0De5GGhJRRuI0tiFILN/Y4inrESBbS1WJ15gZmZHWTQtGkSFNmjqoYmDuznnJd00hBmX6kWnlkOfWQ+oBp5EiPOtnwXku028VocCXktHy58+pohdCUn0x0juG+QR4VH2YT7cam6POKa/s60gRyhzP9B5Xqk+4SUaQHlCfFdhFUXt500dEYP9b1LcBFzO3e52eId0Fu2xYdSPTTaUrDYiVwpbajW8ZPiwH+jukerAN1A3q4NR+/5iBbZcfLz3ZB/ybUpn7y0eIykmuaqxkpyHtIUXkPzH/TQ1OgzbZmmajqc3ds4Y6759y1pBbQ5bKyGKTVHF2uG6V2bYpg0UDx+MUUlAm9woY2inxvqAPOSYO+zRVjKNbQqN5uAetwh+yKXQv1HBICQPpfCsFAXIAm8he12XZlc1P7dfa9Gw/OXoe1XuLWnCOZ3MbtJxXJmTYi1bfNAoFK8EGn2trzlsxIHMJksEmIqZ4VgE4hC3Hk3+DMt8LcstVFXvSnfBlnMkkQ6arduPPZ7/vYg5v4mE9fvDHtNOXBmOtywmlYQioZ+cw7FM7KBiiraV7Rgp42mvYfdkHxeTu5Cxm6j2RBNmjTLZCH/enk5Cp9poyx/aGDlXMmKUScoHkLdxoOQS+X1oTm6gWLiiz5oXSymF9XtJtoUfnW696MeEEWQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6666004)(316002)(8936002)(52116002)(36756003)(6512007)(2616005)(54906003)(6506007)(6486002)(6916009)(1076003)(508600001)(2906002)(86362001)(83380400001)(26005)(186003)(66476007)(66946007)(4326008)(66556008)(44832011)(8676002)(5660300002)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?udNVp0zg0ri+iRdFkvRmkmUSgHji4ZIM9NU5FyXKM+OKVoqrNOEyTtmWEXOd?=
 =?us-ascii?Q?+uioZmwTiqn0GqP76BkqSWlTvyJh8WLewRIbsoarb4UiNY3Y8tPFTHCGf19e?=
 =?us-ascii?Q?MvT4JZr+O5M2uhAFDusxN2iJGVu5AjZDHE9cEmdbb46pyEWZqph0AePKyOKG?=
 =?us-ascii?Q?VxFvqmvkVSs5Yqlb8aYILJdKdU09S4gHwtwZs/GKgWTgXWbnw+QhOI1ZEHll?=
 =?us-ascii?Q?YrktIwZLrmIQKb+dx9iacweS17bZkCl1HsBZT7/pjf9QslCh3DMbikgekCLK?=
 =?us-ascii?Q?Iu+9gILMxZkfcUn1v/LfxbSH75F0rBNgipCEb8pHmoh0N8r+J2EoeMYdxmZI?=
 =?us-ascii?Q?x5JsjhRBsK9O95nksapP6+i/Ug2GWyJvhzyuADOgzUT52keKcmfNdy3z2BLY?=
 =?us-ascii?Q?JexIvoAYvcflHX6HjrThvCpm3L8mzCdPQ+c9luLWwMxae35FVrdCa7yK6m1m?=
 =?us-ascii?Q?FDX+badhJQ64RcFO5qKvLlEYXKDc8oKeRqqWADnTHiHhOXE3oeou42zlZmt5?=
 =?us-ascii?Q?IKCmNx/r7FTEMevk8oN/Wi1ns2SnMbSZCpnDlrmRgh5kdUbDA2YTfgTi3Cjs?=
 =?us-ascii?Q?2FqLVqcsnw/OnW4QIHHa1gHhuxucZcbzcqdhoar+eFk4W4maNqcUU5+GMB8/?=
 =?us-ascii?Q?ZVRsAm42AZfNU6w9TR252F55Pnd4/fuAwgdYMcNrh1LBz1snTxi3d1W5Rq9m?=
 =?us-ascii?Q?T0n/lyc/+rBOs8vS7s+l9RgnDEhJoBz3ljjmIFSAR5LPzaufp8wweznQznTh?=
 =?us-ascii?Q?fCpJi1aMwnSawY4VlYWNKQFioZsogas+72vYsvkZ6nK0RiMh3cQQG9kA+d01?=
 =?us-ascii?Q?oXrH0WfafV9sCiD2vQ4+Lb1hBhVIYn8HuD9vBlQOG6Wwkex1Cuj6dxJS+MdT?=
 =?us-ascii?Q?pXnHNHhrfTj2xDsznTDXbvmSghDi16XBjzPcBrb24Gkg1DjMDO62ujbQ+KUf?=
 =?us-ascii?Q?buQ8MUQ9W8elLYVu5DSUIj1lfgundEa+2XwZfev4CcsuTkdFK7l4hh2BgcU4?=
 =?us-ascii?Q?nSvsX0hQT6OTv+9geXLJIm+FDOJQQEnR0ny3LryBmzt8iS4c/f+blwUfaz3i?=
 =?us-ascii?Q?7cJB4tAHdXBCQbKiudfMm6Evocl8XtnzXFKpP3BdI8wYD74TprBjhNlIrBSV?=
 =?us-ascii?Q?zqEpz6YSlYzifNhULuJp40pWjqgEYsGU3j+1jRoWVzYkid+rt53EJx5RFk/y?=
 =?us-ascii?Q?w8mOqnPsTa7zl85KUFHcmjAu0i2XRQ2x1upvT/T/7p8s5yc6Dl6HCnXv+Wvn?=
 =?us-ascii?Q?1EfN+ZaRG+4qa6HIqKxKMA57umjBQCAJqAUQ303+iXeTTPM/fIMSG/DZqhod?=
 =?us-ascii?Q?1kjVb84jGl9U35J8dOpkyM7LpLF/qC8uSfbENS1IWzKm7tngNTW/swaFIqV9?=
 =?us-ascii?Q?+wGtECNTS5joP1NvGsFQ+EUWIKQGoIASvZCyEcC8H1fNacuHPVkBU+WN0cpf?=
 =?us-ascii?Q?/lIO0FcIUAhsV6KfG65qtJ+r86tZ0X+UxUXOppR3OLur0RQn7UL4Zc4k4Z2+?=
 =?us-ascii?Q?ZQNcvCU0hWBbOZRkyL3dDnWv60anAh94kQDreZw17mPw42C65yzWMkMYw21X?=
 =?us-ascii?Q?1YzDzxLmXynnWf/u9/TQAkb3llqaUtzPTXySqkAIc8KXOfOHXrPBJ6utxDum?=
 =?us-ascii?Q?szvtTT1iTwGNo6SLYgyt9tg=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4b1b3e2-67e7-4b24-49d4-08d9ec9b8e8d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 13:45:10.7062
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j816nH9CSFdN+FCJ90RK3nGW9InSuHKGczNf4u5fU+Z4uf3OIAlvK6AYQGUfAAqB86dGj+s7BnEKKSxVlc4Jgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2493
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are no legacy ports, DSA registers a devlink instance with ports
unconditionally for all switch drivers. Therefore, delete the old-style
ndo operations used for determining bridge forwarding domains.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Tested-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 net/dsa/slave.c | 42 +-----------------------------------------
 1 file changed, 1 insertion(+), 41 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 2b5b0f294233..62966fa6022f 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -515,26 +515,6 @@ static int dsa_slave_port_obj_del(struct net_device *dev, const void *ctx,
 	return err;
 }
 
-static int dsa_slave_get_port_parent_id(struct net_device *dev,
-					struct netdev_phys_item_id *ppid)
-{
-	struct dsa_port *dp = dsa_slave_to_port(dev);
-	struct dsa_switch *ds = dp->ds;
-	struct dsa_switch_tree *dst = ds->dst;
-
-	/* For non-legacy ports, devlink is used and it takes
-	 * care of the name generation. This ndo implementation
-	 * should be removed with legacy support.
-	 */
-	if (dp->ds->devlink)
-		return -EOPNOTSUPP;
-
-	ppid->id_len = sizeof(dst->index);
-	memcpy(&ppid->id, &dst->index, ppid->id_len);
-
-	return 0;
-}
-
 static inline netdev_tx_t dsa_slave_netpoll_send_skb(struct net_device *dev,
 						     struct sk_buff *skb)
 {
@@ -973,24 +953,6 @@ static void dsa_slave_poll_controller(struct net_device *dev)
 }
 #endif
 
-static int dsa_slave_get_phys_port_name(struct net_device *dev,
-					char *name, size_t len)
-{
-	struct dsa_port *dp = dsa_slave_to_port(dev);
-
-	/* For non-legacy ports, devlink is used and it takes
-	 * care of the name generation. This ndo implementation
-	 * should be removed with legacy support.
-	 */
-	if (dp->ds->devlink)
-		return -EOPNOTSUPP;
-
-	if (snprintf(name, len, "p%d", dp->index) >= len)
-		return -EINVAL;
-
-	return 0;
-}
-
 static struct dsa_mall_tc_entry *
 dsa_slave_mall_tc_entry_find(struct net_device *dev, unsigned long cookie)
 {
@@ -1747,7 +1709,7 @@ static struct devlink_port *dsa_slave_get_devlink_port(struct net_device *dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 
-	return dp->ds->devlink ? &dp->devlink_port : NULL;
+	return &dp->devlink_port;
 }
 
 static void dsa_slave_get_stats64(struct net_device *dev,
@@ -1792,10 +1754,8 @@ static const struct net_device_ops dsa_slave_netdev_ops = {
 	.ndo_netpoll_cleanup	= dsa_slave_netpoll_cleanup,
 	.ndo_poll_controller	= dsa_slave_poll_controller,
 #endif
-	.ndo_get_phys_port_name	= dsa_slave_get_phys_port_name,
 	.ndo_setup_tc		= dsa_slave_setup_tc,
 	.ndo_get_stats64	= dsa_slave_get_stats64,
-	.ndo_get_port_parent_id	= dsa_slave_get_port_parent_id,
 	.ndo_vlan_rx_add_vid	= dsa_slave_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid	= dsa_slave_vlan_rx_kill_vid,
 	.ndo_get_devlink_port	= dsa_slave_get_devlink_port,
-- 
2.25.1


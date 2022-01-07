Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2BCC487C6D
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 19:48:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbiAGSs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 13:48:58 -0500
Received: from mail-eopbgr150075.outbound.protection.outlook.com ([40.107.15.75]:58571
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230051AbiAGSs5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jan 2022 13:48:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PmdIq7Fu83MzwcJQSGb0B7mO0r9gOPG9/SOnVZucgCeUy2PX2yGq7o/4PxWbD1ro/162j0SJKb3wyWaF/8bBzqIaSR7sudWdYOhqvTlLawF4KiB555cs1Ty96aluBA/g/e6uMqLpjYRvCzg+tG6xogJTWQwQxDjL6XRxcwZ0l5quz+deSGltTUORNiVc1fur82wOGFSv1YNW/NjvHw77uUgHXVXb4NTduMIg33GCUEdZ9qi1r+pJqMiRErXD5f0ViuKxgilo6p3VzMPpzmCxHywy00v5yv4+LWQ8Do/tbVD+qSZFh1lSZ9XLCaqIlhvdwxxlfpz6ZkyCHQRhkbti9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=snBsrWoallY8g2Rl3qCZWTeskEFBz0dOfCLajBxNV1c=;
 b=do0wY0P2+fHbm1JhOpjXZUDvKdvmx3LX8aZ5vCuaXwSAPuTwVDQwxmdQoiDYM5sB8ks01itw/V+411AIbqoj9UfUn+EZu+8XLBn/CHLy10jXqfeRWGYZmSHZ+QxKJL3B9zWhxarPMoXbQfQoIzWDn3zWQFB+nVhTGpcFnDf8S5TiDe4G9ijcczBk1R6/iNVUgw1NSvuGvSwS5KTNSl64cWql71ndhIIwPxwWbHXBZHuPscdcgGjF/NG9XaMrTZ6Z5KTWzfqC+WpMp3DK3bQOXfWHaWO7IaH978bgUumegVgFJqG4hk80UkuogiDsMz8w3wJ5LX7jstjv2BHzKUAIaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=snBsrWoallY8g2Rl3qCZWTeskEFBz0dOfCLajBxNV1c=;
 b=n1/bDNmNstfbfatb5f2EpTshe9RywpAt++D0Ls02xDOebHRSdmZ4VmplSHdsHTPCGeLY8AxWmZMD3lBaqTK0HWK9ql6UR27dGtC0dGylWaXcQNEoY49vzkpKk+mxaY6C1+z8Ufl7O63QDzo+sRJjoEiNUXp9FkJcuQuHK1u850I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7470.eurprd04.prod.outlook.com (2603:10a6:800:1a3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11; Fri, 7 Jan
 2022 18:48:54 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.017; Fri, 7 Jan 2022
 18:48:52 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [RFC PATCH net-next 1/2] net: dsa: remove ndo_get_phys_port_name and ndo_get_port_parent_id
Date:   Fri,  7 Jan 2022 20:48:41 +0200
Message-Id: <20220107184842.550334-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220107184842.550334-1-vladimir.oltean@nxp.com>
References: <20220107184842.550334-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6PR0202CA0058.eurprd02.prod.outlook.com
 (2603:10a6:20b:3a::35) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1a3c4911-599f-492b-997a-08d9d20e59c2
X-MS-TrafficTypeDiagnostic: VE1PR04MB7470:EE_
X-Microsoft-Antispam-PRVS: <VE1PR04MB7470BFB092049FDB0077E8D1E04D9@VE1PR04MB7470.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cGQByQZNsi5tYzScIx9CtEyTqZiKSNl+dGv7B7WvzEq2VTRGgluo5RhknirbzJo3Ct3KdKWXLcTIpn7EaNlLKMSXdJuALutFMbrYr+5n9oNOPlHfRvy8GWedjae3hhERIz+8tO+OEJ6GLDahH0uIBH7zHUytF/yzZueYqoOcgTfdzDDM/HqO1Xg3havRglupueRapsq7xseT7YKkgqzwl8CaCO+WHkgHF07OuoT6+u2pA4hfvxbhKqszvf8KZsnyizNi3nbpg8e5CQitMBYuvbPC4fzRM8P6j4uV+kwVG6q8tiMqPhtldAK+WU5nv62nB16oda7aPIPdAY17Pz66+toe2npixNjfuMevQm5vpBDB5O8AYIHkaxFWx/CZKQTOC9rkCzMkcu83d/EB45tiIk/BPnAxBEOt/hsz4FK1SHBQY+qYiQe3EMtKLTqd9cdVGDR446SksF5fUP9kJbtEGOGGnW46IgZvlWbrgRzFHcR4yWCMLCovet/pENORzDH+N46yP3GZkpApUBQ3R3PUugsUT8h0WUHIsP2TFs1uhAjP9F6BPefRrrCHLeoq3AnQ43vDXRyAzWxC4iGCdRzoHNewOpUy46KYKJTuFoVdOebY8z4jzMsuQvyuqFH0db2qmcMkkqhHOqHPID8smMyT8XSxP3G+jrcW4bGdVEDIeO6pe2BFcAZkK8LXoOTOANbW2Vna/vpj2BqSkUaOuMLFkA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(2616005)(83380400001)(86362001)(6916009)(4326008)(52116002)(316002)(38350700002)(54906003)(8936002)(38100700002)(8676002)(6486002)(6666004)(66946007)(1076003)(66476007)(66556008)(44832011)(508600001)(36756003)(186003)(6506007)(26005)(5660300002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D6XAMT3J829Eaawye+B68Of5NOGhLR22ihegZ2hFUogrtwlxUu+ju5r4wWdY?=
 =?us-ascii?Q?3B/54FU5aBMXld2ZPkUo6kbP8wtf+dR+zhUXsN2ovfru9172UYVrgMw9sMpM?=
 =?us-ascii?Q?HVw09rwdJvmog4eT/NFoTrktvTEmT0yjA/Fvg8sK0cqtuCA8tsabA/7oJUXP?=
 =?us-ascii?Q?8svM1AY7ItTq/zfRKzZwZ7ywJq3Z8Jj4BSeemwrN1USbhIZHGg6Vk8o06bw7?=
 =?us-ascii?Q?3vAmnHNypuy8dhb6SwXH7E3ZXOIMoAN1nKxo5XX8wxcEnOUdrwcaCYlaj5/m?=
 =?us-ascii?Q?x1ZWTdUi0tqHZmVe8ibxcTi+266kHUlJD4vHvdkwt9EmoXT4NRgipapEIt7J?=
 =?us-ascii?Q?qHzXotHzjOwFpgADRc6+UiW/qVaWTPD2nUyIUH0WNNXclsgHvPHFVbca7cvP?=
 =?us-ascii?Q?rYvfN4XcMQaxo6/ADpD3LBVfm89H4NyG1MUXKcemtfvvsrbShHLxbaBGqQLj?=
 =?us-ascii?Q?Ybd+cZxodo8rlhS+QxkwYe7ZkuM/Ho6VxGcUCHNdbLIS6ya/3Nr3Y6JoxbCd?=
 =?us-ascii?Q?ne8Y5Gv+zBw45cyCF+uV07ZrNTpSF88Nawl4ar7Sxeqm3Wbnf+tOrelJ2V9u?=
 =?us-ascii?Q?UWmD9rPMHraFdRYENWJrXO1PSB5StoauLsw7V1Mshu4dCcwLImQVOQhKgiEM?=
 =?us-ascii?Q?10W3CybGNkHbe2PGGwO6cM+/b0TBuZVrY0JDtatUjl8fUywOHzdXYiDwWq2a?=
 =?us-ascii?Q?+Z59IvKnPxx3anW9TQRakhB5rqsvcbBs4t/DZ37LjGEtBvE/5Ec0F6GN0799?=
 =?us-ascii?Q?yqsWz2rn6yY5pF5hToruPIdbcFriOf9ex+XnfmcXsyvV4B/WQ3A/zfI+bDD6?=
 =?us-ascii?Q?6cxoji4umcFWKOGs8VqexfSUXR4YV3D5uo7eGG83AFwi2E/7ScAOCaUihfHM?=
 =?us-ascii?Q?14xJg3VMWpNsWRrw0f+xbo99LyMm0D3eom8beFT6ZSIDyDzACGdobfFuhgA9?=
 =?us-ascii?Q?DPEzNGfFOSl+Kq/KP2qwtOqY6YRK//ex6tuO8C8MIw6xLGuRybbxcuo5sXak?=
 =?us-ascii?Q?SXKfDAiGnq2FbXBXFKYkK4hKRcbIQhrm5XFEmklcJTMgA/DQ2jkLrLEbX/3v?=
 =?us-ascii?Q?8CJAWaFNGV60wYb/u3rowbdS/gV2yiU41+keLZYU1T0FS/J08mcZFbs1FIPR?=
 =?us-ascii?Q?HqJwmxNRcDFqItScVMX9/G11xXJygu7mmPuOfNxcyomGAZrriZ9ath2yg0I7?=
 =?us-ascii?Q?hcxxQaVsZk92HuolM2CqToNCKJ7qvbmechxzmXG0subiiD9PXkr4arXsoNbF?=
 =?us-ascii?Q?ozqOg5bYX3DYHaPHRuJ0/vlkAcj4pB9p3ZTiPRUa4v4AdyaPVtyUxNcOEgMO?=
 =?us-ascii?Q?dUFrny2qj58/bdssQbQWq2iwqx7qWWKtA/w+uJASLcWMCxq6vm+ap10aWxx1?=
 =?us-ascii?Q?AZV9RvRgVq+d8drBtYWNaOn/1KRtpS2i48Gqo4baUGtrQdIDc/4UDIvIgcpm?=
 =?us-ascii?Q?SxpvzyBo58sKmCR115D6FnHCtVRMuQ6HnFeHeYnx5Lq72O3K1vM+kx2gGr30?=
 =?us-ascii?Q?/OzDdpodIN4e+NPApvkpRoGw/+ZMOFDYUcNTPvFS1tueUYnmBjUO5wChAyqX?=
 =?us-ascii?Q?UBR9u07zCY7djGL1SwJAHAh1my4aP/nkwStDut9c72l/lVfbghByD+cRnIZG?=
 =?us-ascii?Q?NGhwOfEYHr0OCfoFc90Z80s=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a3c4911-599f-492b-997a-08d9d20e59c2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2022 18:48:52.8654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fWVLxQAE40FEnYCdQAANshrmJGFA7FqcSF9xCOAairZydjtzZVfu5R9UCWrAABIvzJ+HbS5Ge3+mCmx5k14dNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7470
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are no legacy ports, DSA registers a devlink instance with ports
unconditionally for all switch drivers. Therefore, delete the old-style
ndo operations used for determining bridge forwarding domains.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 42 +-----------------------------------------
 1 file changed, 1 insertion(+), 41 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index eccd0288e572..3acb2a2db473 100644
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


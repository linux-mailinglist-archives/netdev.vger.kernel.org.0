Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F30F66E5F88
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 13:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231421AbjDRLPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 07:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231326AbjDRLPY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 07:15:24 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2045.outbound.protection.outlook.com [40.107.104.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1393128;
        Tue, 18 Apr 2023 04:15:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BJcRmxgOVhfo68pDKy/kdQ9K5yh+bcHTYlhTEE6DqPhC8ML0nepSn36yoFPHAw6L24MA67CIiVNGy5W9eAGAwTZ8mMkV1pp3weaORqCUUBssfahmVOut9D5NMw7+Xnrr4tcE3qKn2z0IvoS09BXJ0LKNGaDlbtJGTqWlkLw0gt49czPmRG2QkX/P9XU9CWkVnfOTS1ylHPHWIntNYlHzZbMLj91FNxpUpp9wfxZWr9nHFoZ6fj/4tsdGFjgT6ac/iKgT9FQHFO31MGL1fNx0FhvKTFbRc73Jkb7GQPpcvaTlDyA9Pvsm2ZR/oNIAXhpkobyRzn/rWt9gPZvFmlKGfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ov0QUbtEK2+jpxZgdRkTqB1XbAcXl+/wK52Cx6aAgbY=;
 b=NyS4JNnyIoy01QHyDIHVN2vSvI6SE92h10J7s8bCCoNFWWVnrd7+eBb3citHH1naQ1Ye64+YXYz8i1qhhs9Ik+wuKlEPcImydbK6f0TPgtM+7qy8wrcfoRs0HP9VV0+2+deNqIb+8F7VOc6ZOkX38psd6yfgZwkntyAocwxt8UxJnALu+tXmphszfzQHas6gPN7ntIRmpbLDMtRnM26C39t/RYg6KLlqI16I6TYIu92b11n4NbsT0o6Ws4H/0F2M4RTReZnrSisVRDMHYwVcsLj+WNjiiiZ4OwrdjvGxtsv9AhTbfNre3K+BAjK3J6gr6iBLDd6i72JK+WVYFH/LRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ov0QUbtEK2+jpxZgdRkTqB1XbAcXl+/wK52Cx6aAgbY=;
 b=NhcDov3rq43xobkT4XgYvXLEzUZtPIZPA4SJbajMiJnpccBVOzooeqXbqPkWg3GhsxZx7WMrog7yCU7NFgiCLdVW3QJ0YYLXxKI43311jC2oRsk83fsv+I/vmHZOVmyCtvw614c++2Qtp6GDqvN83Psggcmp6adaUORIJRuwYfM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS8PR04MB8659.eurprd04.prod.outlook.com (2603:10a6:20b:42a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 11:15:19 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Tue, 18 Apr 2023
 11:15:19 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Petr Machata <petrm@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Aaron Conole <aconole@redhat.com>,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 3/9] net: enetc: only commit preemptible TCs to hardware when MM TX is active
Date:   Tue, 18 Apr 2023 14:14:53 +0300
Message-Id: <20230418111459.811553-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230418111459.811553-1-vladimir.oltean@nxp.com>
References: <20230418111459.811553-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0152.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:98::19) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS8PR04MB8659:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a074e68-5599-4049-73ad-08db3ffe31e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TJEgqDhc81OMoFYy9d20mMTOfGTsrCx0az60CiVff+mOIIP4jDts6iLJbDC2qgP9mqMMzTyzqA+BDbvhPCEUnKu95xFVJzfYbHwwfGzSTIRxhQmxI0f3OzqWoR/v0/2XznvsWQysZ/yNh0hsOQ/quExkj/ZxIIsNYOzsENnwupTOIZZfX1xyrW6h9JSlmU0eV9+9pODOX51mh/pGIIaTQ1rsSAY9AFiXQ6BLYixqN69sJ7A66QsfrSBVSHzDqZnIaxWv5cRvNDU06d/3pAtPVvBuV9MpztlBf4UIqMeUaAzDoIDpMjk1CdxGU9iyAEvDW04GBvTYIuMVBPBQ7OS1paOktv6xl9c4+dQxl4FIiPqqQh6aZaA6MaGtIYhex68ASSRj4xCGGLTvqfxZruQAfHQ6RKHVHHBMJU2aIaTDhK2tz9SByLdfbivtOCGHE9ra564JOYenmNOjEQHJfTqIwp26eEqXYTxvwo5ifQJM7sswNKxAQDtXXhFzV8D3MOHZadeD79UDRAbtC0pVYl3x9THN2n7YdHfItJWSsMmEj2nREDrtGDmJmAa/njMBqLX5hsgDgZ2Wi/ajjPD2V5wIhI8om/LmAlHpvkUwwWQOjuiY3AwTUzzUJ8ZEA7onf5jr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(346002)(396003)(39860400002)(366004)(451199021)(6666004)(6486002)(478600001)(86362001)(2616005)(36756003)(26005)(83380400001)(6512007)(1076003)(6506007)(186003)(38100700002)(38350700002)(52116002)(66556008)(66946007)(66476007)(316002)(2906002)(4326008)(6916009)(8936002)(5660300002)(8676002)(7416002)(44832011)(41300700001)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?N2PJAoe/IMHj2lPwwTDxNC54Oep7KTCvUrX6b/m9rEqswhvzVXKAPJyUkVjd?=
 =?us-ascii?Q?DDUd9wnGL09SQSwDApXRAz//UP5WQ4L9TCtWgNOThbEl/QUMLbmTbLJ2d9Vj?=
 =?us-ascii?Q?+SddJypyWSm3slbY02yOs9PTTnu3IADA77eUZTP/yOrlJUjKN65O/WeGrNAq?=
 =?us-ascii?Q?XGDyIsIctm1vHfkAx2DOltKFScPxHJiMjyR5oipUYPxv+AY2dZnWXl46orNe?=
 =?us-ascii?Q?Z/wddgp8L5wMcW34ZKdJduQs8hEk9v4qelPPyrb8k0E4QlXbRJtVDC9S4o8k?=
 =?us-ascii?Q?MUtSe0l+tzk/HZ7Wy2q6p2irRL6RRj8FWesYoNC7FLz6Nd6AjphlTW/RmKks?=
 =?us-ascii?Q?7hON8pFbCdEW2J4Qv1E6U4+diSOI1nsegIEBqpLjmaCxDHHZ4yN99jlaCzc1?=
 =?us-ascii?Q?rDt2dhJdz+dbB8PVx8EWaIZrFwoCzbJPqVLHRMkcCGJTw4Qqs5eiFxsRQwTW?=
 =?us-ascii?Q?IMtG/fHPvEDleu8FjZsC1JVo/haJVcQy8AgZH5kNUPAVE0/cDXtvss2bnwlQ?=
 =?us-ascii?Q?o+rcqPK/LRHadPsG8NlQWnunX1QzHqL/t0Q+otPTpRYiiKCV+o4OoRXrUqIY?=
 =?us-ascii?Q?hjo6Yd/fQs66IWLAWGU6xIXiGYlwHQrRudwNoECeKVwn7Kd0aN7ULh35BbFj?=
 =?us-ascii?Q?SrZqnwiEz60+XjflLz+fWkQztKTgJ10J2g3LT7Ii9I+Q7UepDd5JtR9lw7lu?=
 =?us-ascii?Q?sNd1xajLfoQCqJ+wrGVyIUIrYYRzQwqfVimtEmdmXSKUUtGZhxEfzWDUtMub?=
 =?us-ascii?Q?916K8bzMMml8ZyrGFXVVHXwy25Mso9z9EqoAmwjTEX6hTIMPmuM3OvSiqZFH?=
 =?us-ascii?Q?wcsWcBabbP04tgMJa5IlzeNmFb9vlXrO7yheYn33tbsvgj35/twvex/cSkRc?=
 =?us-ascii?Q?7FgMu4gRQSTZWVQmAGtZM3/NOLR+SLQeq01oAcQTovkEQ6KkPKBc4GToc2bK?=
 =?us-ascii?Q?eh1f9xa4TzdZgMqcjDbPufiNGJbBA0XinqUSs4VOZn618BF5Nb5zxmFs/eWW?=
 =?us-ascii?Q?6/29FZM+NbGZPMak+jX/GyLwQi+Ob/XlzBDZiIS3SglzfAHGaWgO4tzF9P9R?=
 =?us-ascii?Q?up+itpMx2m4GKTkKzN/w6K6MP+f0+CLSwj5gAejOKr+4C6etDetEX9FZY2hQ?=
 =?us-ascii?Q?e3A3oGeiodx3AZwwteTAQI8crWTPPYaxUeCYxwpgeHLFYBZmUwpO6mj3yiSZ?=
 =?us-ascii?Q?YkEWi/itHVzj0MdkAroQyBAMzrAOzC1fIZIvRvmjkdFHiVcsi3lUqZqXcc3h?=
 =?us-ascii?Q?pIhFZeBVwGL6NStgduY2vC3ED6BrttAuJl3bdE3BxE7oTllqAQ2e07XRgXxk?=
 =?us-ascii?Q?zgzxDsC3d23i5ujvrzKer93eQxr41yGwywOKifs9yvJlxAo4MTEmQLzIJCkB?=
 =?us-ascii?Q?4e1NhRBBlx3qG5Wo3T3VTUe6TTwIGcsxRfqQvOwX05xiO/W/KXUowDXG9ATo?=
 =?us-ascii?Q?xnV0/1TKBA7tZUO0Rockgyqc0TXmn51RbMnC+7L88bahjXjLYzolLPy+bh/j?=
 =?us-ascii?Q?ytIZU0VzlzIsiaHsiniS0L8cAxxy9wrxRQptowzbqAHostKxkmEEtrHmj4CA?=
 =?us-ascii?Q?iOAh3ZNUv6jZk7vnij5LLjruETDBlKuH8nXpcc0a6UDiBX9qTK7g8u8zN/Dh?=
 =?us-ascii?Q?xA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a074e68-5599-4049-73ad-08db3ffe31e3
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 11:15:19.5864
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D96hlKf9OMNWuVcMGWJK2+c12nTT66ZSO1nrH6Z9J3lWCjMCWtVqeKYSXORALlYYMCtGO9Lfg5E8eGRV77lAPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8659
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This was left as TODO in commit 01e23b2b3bad ("net: enetc: add support
for preemptible traffic classes") since it's relatively complicated.

Where this makes a difference is with a configuration as follows:

ethtool --set-mm eno0 pmac-enabled on tx-enabled on verify-enabled on

Preemptible packets should only be sent when the MAC Merge TX direction
becomes active (i.o.w. when the verification process succeeds, aka when
the link partner confirms it can process preemptible traffic). But the
tc qdisc with the preemptible traffic classes is offloaded completely
asynchronously w.r.t. the MM becoming active.

The ENETC manual does suggest that this should be handled in the driver:
"On startup, software should wait for the verification process to
complete (MMCSR[VSTS]=011) before initiating traffic".

Adding the necessary logic allows future selftests to uphold the claim
that an inactive or disabled MAC Merge layer should never send data
packets through the pMAC.

This change moves enetc_set_ptcfpr() from enetc.c to enetc_ethtool.c,
where its only caller is now - enetc_mm_commit_preemptible_tcs().

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: patch is new

 drivers/net/ethernet/freescale/enetc/enetc.c  | 23 ++-----
 drivers/net/ethernet/freescale/enetc/enetc.h  |  5 +-
 .../ethernet/freescale/enetc/enetc_ethtool.c  | 62 +++++++++++++++++++
 .../net/ethernet/freescale/enetc/enetc_hw.h   |  3 +
 4 files changed, 75 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 41c194c1672d..3c4fa26f0f9b 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -25,23 +25,12 @@ void enetc_port_mac_wr(struct enetc_si *si, u32 reg, u32 val)
 }
 EXPORT_SYMBOL_GPL(enetc_port_mac_wr);
 
-void enetc_set_ptcfpr(struct enetc_hw *hw, unsigned long preemptible_tcs)
+static void enetc_change_preemptible_tcs(struct enetc_ndev_priv *priv,
+					 u8 preemptible_tcs)
 {
-	u32 val;
-	int tc;
-
-	for (tc = 0; tc < 8; tc++) {
-		val = enetc_port_rd(hw, ENETC_PTCFPR(tc));
-
-		if (preemptible_tcs & BIT(tc))
-			val |= ENETC_PTCFPR_FPE;
-		else
-			val &= ~ENETC_PTCFPR_FPE;
-
-		enetc_port_wr(hw, ENETC_PTCFPR(tc), val);
-	}
+	priv->preemptible_tcs = preemptible_tcs;
+	enetc_mm_commit_preemptible_tcs(priv);
 }
-EXPORT_SYMBOL_GPL(enetc_set_ptcfpr);
 
 static int enetc_num_stack_tx_queues(struct enetc_ndev_priv *priv)
 {
@@ -2659,7 +2648,7 @@ static void enetc_reset_tc_mqprio(struct net_device *ndev)
 
 	enetc_debug_tx_ring_prios(priv);
 
-	enetc_set_ptcfpr(hw, 0);
+	enetc_change_preemptible_tcs(priv, 0);
 }
 
 int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
@@ -2714,7 +2703,7 @@ int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 
 	enetc_debug_tx_ring_prios(priv);
 
-	enetc_set_ptcfpr(hw, mqprio->preemptible_tcs);
+	enetc_change_preemptible_tcs(priv, mqprio->preemptible_tcs);
 
 	return 0;
 
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index 143078a9ef16..c97a8e3d7a7f 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -355,6 +355,9 @@ struct enetc_ndev_priv {
 	u16 rx_bd_count, tx_bd_count;
 
 	u16 msg_enable;
+
+	u8 preemptible_tcs;
+
 	enum enetc_active_offloads active_offloads;
 
 	u32 speed; /* store speed for compare update pspeed */
@@ -433,6 +436,7 @@ int enetc_xdp_xmit(struct net_device *ndev, int num_frames,
 /* ethtool */
 void enetc_set_ethtool_ops(struct net_device *ndev);
 void enetc_mm_link_state_update(struct enetc_ndev_priv *priv, bool link);
+void enetc_mm_commit_preemptible_tcs(struct enetc_ndev_priv *priv);
 
 /* control buffer descriptor ring (CBDR) */
 int enetc_setup_cbdr(struct device *dev, struct enetc_hw *hw, int bd_count,
@@ -486,7 +490,6 @@ static inline void enetc_cbd_free_data_mem(struct enetc_si *si, int size,
 
 void enetc_reset_ptcmsdur(struct enetc_hw *hw);
 void enetc_set_ptcmsdur(struct enetc_hw *hw, u32 *queue_max_sdu);
-void enetc_set_ptcfpr(struct enetc_hw *hw, unsigned long preemptible_tcs);
 
 #ifdef CONFIG_FSL_ENETC_QOS
 int enetc_qos_query_caps(struct net_device *ndev, void *type_data);
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
index deb674752851..838a92131963 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -991,6 +991,64 @@ static int enetc_get_mm(struct net_device *ndev, struct ethtool_mm_state *state)
 	return 0;
 }
 
+static int enetc_mm_wait_tx_active(struct enetc_hw *hw, int verify_time)
+{
+	int timeout = verify_time * USEC_PER_MSEC * ENETC_MM_VERIFY_RETRIES;
+	u32 val;
+
+	/* This will time out after the standard value of 3 verification
+	 * attempts. To not sleep forever, it relies on a non-zero verify_time,
+	 * guarantee which is provided by the ethtool nlattr policy.
+	 */
+	return read_poll_timeout(enetc_port_rd, val,
+				 ENETC_MMCSR_GET_VSTS(val) == 3,
+				 ENETC_MM_VERIFY_SLEEP_US, timeout,
+				 true, hw, ENETC_MMCSR);
+}
+
+static void enetc_set_ptcfpr(struct enetc_hw *hw, u8 preemptible_tcs)
+{
+	u32 val;
+	int tc;
+
+	for (tc = 0; tc < 8; tc++) {
+		val = enetc_port_rd(hw, ENETC_PTCFPR(tc));
+
+		if (preemptible_tcs & BIT(tc))
+			val |= ENETC_PTCFPR_FPE;
+		else
+			val &= ~ENETC_PTCFPR_FPE;
+
+		enetc_port_wr(hw, ENETC_PTCFPR(tc), val);
+	}
+}
+
+/* ENETC does not have an IRQ to notify changes to the MAC Merge TX status
+ * (active/inactive), but the preemptible traffic classes should only be
+ * committed to hardware once TX is active. Resort to polling.
+ */
+void enetc_mm_commit_preemptible_tcs(struct enetc_ndev_priv *priv)
+{
+	struct enetc_hw *hw = &priv->si->hw;
+	u8 preemptible_tcs = 0;
+	u32 val;
+	int err;
+
+	val = enetc_port_rd(hw, ENETC_MMCSR);
+	if (!(val & ENETC_MMCSR_ME))
+		goto out;
+
+	if (!(val & ENETC_MMCSR_VDIS)) {
+		err = enetc_mm_wait_tx_active(hw, ENETC_MMCSR_GET_VT(val));
+		if (err)
+			goto out;
+	}
+
+	preemptible_tcs = priv->preemptible_tcs;
+out:
+	enetc_set_ptcfpr(hw, preemptible_tcs);
+}
+
 /* FIXME: Workaround for the link partner's verification failing if ENETC
  * priorly received too much express traffic. The documentation doesn't
  * suggest this is needed.
@@ -1061,6 +1119,8 @@ static int enetc_set_mm(struct net_device *ndev, struct ethtool_mm_cfg *cfg,
 
 	enetc_restart_emac_rx(priv->si);
 
+	enetc_mm_commit_preemptible_tcs(priv);
+
 	mutex_unlock(&priv->mm_lock);
 
 	return 0;
@@ -1094,6 +1154,8 @@ void enetc_mm_link_state_update(struct enetc_ndev_priv *priv, bool link)
 
 	enetc_port_wr(hw, ENETC_MMCSR, val);
 
+	enetc_mm_commit_preemptible_tcs(priv);
+
 	mutex_unlock(&priv->mm_lock);
 }
 EXPORT_SYMBOL_GPL(enetc_mm_link_state_update);
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index 36bb2d6d5658..1619943fb263 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -3,6 +3,9 @@
 
 #include <linux/bitops.h>
 
+#define ENETC_MM_VERIFY_SLEEP_US	USEC_PER_MSEC
+#define ENETC_MM_VERIFY_RETRIES		3
+
 /* ENETC device IDs */
 #define ENETC_DEV_ID_PF		0xe100
 #define ENETC_DEV_ID_VF		0xef00
-- 
2.34.1


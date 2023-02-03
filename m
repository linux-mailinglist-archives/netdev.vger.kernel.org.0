Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E75EF688B81
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 01:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233471AbjBCALp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 19:11:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233470AbjBCALk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 19:11:40 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2055.outbound.protection.outlook.com [40.107.21.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A0977B79B
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 16:11:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fi4NTli+gQpVRWZ5xCd4XH1Jbqd3xRwvqIiK9KCYN2kkaVwwDl6Fp998sYffgw6laEESUYqbCRcmSBWl3uhEU6SorXoUAyvLrHTNlBIXGqHgOfFiG7hMRL5Tt+yVgAkL7dYi0GC3s4eto2MoZSRvRIlogPJZaxLeC8mxeQXwHqOGVHxHd3JfRAoJ/vfdF88MYsn0ZGj0Y1NndtLjViRL+7l11ywP/r+Srm/y23li8BnXJOcxKhFRZ+Jdl9VgSBurygU0Pd9En6G3PqlcSq/jJrtyBn8A/dhJshUJsCAC8Azgp+zIHZkNBmAiTDgU9VC/JPf0D5SHWg3584JLzE/nUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h5fzf246pkf1FIfyJnDTy33anmVXDyCpk3OEdn3M1WA=;
 b=lWgoinENRsV25tcflVNt47tuj5rSgJ2o1olXdbiKzehhAuWufgSoMj4rtZj0dR/AnKwM07io2E+Mtqh2V4oY5Vf+TbMjDSd4zg3YQnXA8ZUb/FxRf4sMmOBxYX3zoAqkek2MJL642QcmSGbAQZ5rB/ALW1egFb2I2M3UySoXY1ARBxLXa41j8vmCq9zl3nF4eP97GwTvHyBzqE2hL8XbtJqRirEMjtpinsWNdxzv2wYFWle1QeIkKgWON3+S+3XDI/e2uJdZC//u9OUv6LS3vx2pCE0gqrrWtQfElcSVUmCxDnLx+t8dSf90DzpiQcZXBWbGc/Tp8kMYSj7BwHJrRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h5fzf246pkf1FIfyJnDTy33anmVXDyCpk3OEdn3M1WA=;
 b=TBxqj/bnXPM6Qx6enEEhXNwbppR1ba/B22UOc2PAY+hGluhdzLLfWfXkU42txbmsgvD/fn5ypiHk2AGvzBXklFy4Z5Ejh/A0gFu+kb6hhITnFvEg8r714K1GBcmVnZb/o7RCDe+R1+sO4KF0lxB/EyQgrJgXsFuZi4m27EYvlR8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM7PR04MB7190.eurprd04.prod.outlook.com (2603:10a6:20b:115::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.23; Fri, 3 Feb
 2023 00:11:36 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6064.027; Fri, 3 Feb 2023
 00:11:36 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 4/4] net: enetc: ensure we always have a minimum number of TXQs for stack
Date:   Fri,  3 Feb 2023 02:11:16 +0200
Message-Id: <20230203001116.3814809-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230203001116.3814809-1-vladimir.oltean@nxp.com>
References: <20230203001116.3814809-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0118.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::35) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM7PR04MB7190:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c441aa1-a775-46c1-1379-08db057b36ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xM/cHyd0pXbVctHx//toUD6PNibqn8iTkZ53iVsdRUSQUG7j5H21S+KYO/WWCY7lR7kPpReH8ZWeVr54VPmbqzLmMVqvlkXrtO0xjpgKiErVewxfMFt/DMDmLn9FPuWzHPDTLfLcNT8cEwH0ei0bqzGGZNLWBooDIQRc96E7jgRFqCBIjoVTvgVSJCcvl1GjRb5ezJnHuJb7j3QiSSNk9bv++gOhQTBTKJ86vgXuQwWjoiJxbF+alkVOLDyYKWhJ9oRcpp2Rsj8qkKMY2B9kVJDk1kx6c4cMCbRWJEWVWl+TKg+yoYHBCAdBvEHyKid30BOVs8SrHEN1jEIoeyPeZRUumVpeF2eVtdV89o6TbreujQ2K9uYf40iykS5osJCNzHO4Nxyq/3rnzf3JivmGgs8tH7YJxTEOKWnW/c+fy+TxHDbl+fsLPzB6yjsHfB5HbRsU3zdQVD7nbNlHI7098cZrgeUTWukO7GPEbm6PTXiNBXoZ5ITu9/NGjwAPCs1kCfmBMWWMiy2nfZXOz0Vnm5MrkWyDxkUrO4QywB8NF+MDtYcNswUcguI5loZ58zxEuPuOzdUQPDBIWyzFPIEGH+jR9Eiaq1AoG/+RJTUWCFlhSg7EeolsEA2SQvZuq5z7Kib8lvlO+27FKRr7gZipBy7wBwIq8XEa2Ycq/id9TTFhBdA9oeXcQdDmqAU8Yfj8Oo/0YgA/pPEZZFzZ11hdwQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(366004)(396003)(346002)(136003)(376002)(451199018)(38350700002)(6512007)(52116002)(36756003)(6486002)(44832011)(186003)(41300700001)(478600001)(38100700002)(316002)(6916009)(4326008)(54906003)(8676002)(66476007)(86362001)(66946007)(66556008)(8936002)(26005)(6506007)(5660300002)(6666004)(1076003)(83380400001)(2616005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PI+hlGaGDheJKzU/+YVr6odSICbtlrNlRh6Bbaz5kbK72P4tcASd/WkZKogJ?=
 =?us-ascii?Q?p5pBIga186zbakfUeUxx0lo5Jfl/2qGeDqmPeLwUwQ6YhnXKPLoxft6xRoff?=
 =?us-ascii?Q?gSI/Vdbj2SNyqW3Q1j33dlh38J8PY2+8MVSwNSIDe6mjNIgJD5BPEodF1v32?=
 =?us-ascii?Q?y4BTAVuRGZ/6HZuQiSILClTUhNNv+NLOaEkj3CguI8JB2v1YkzNVZcILd6uN?=
 =?us-ascii?Q?xEAoIpPxouxO6CdIn7ERK3TW3N0n62n+CyhYlU9BzW7tGvhQiEVmGoEVgVvp?=
 =?us-ascii?Q?UC+uqwHyfYiahKvcLStmc59ecWErOdVAMBBCVFKuuw2sJ2s1+fEx9XFrPc7d?=
 =?us-ascii?Q?7Ubt7iPR9z9kWWrt9U6GOe0Hv44JanAIiahgAN2YEJg9ncGoqQIgziyzXcJV?=
 =?us-ascii?Q?SPBt/P1Y0MBwTga661PTq+eSUEKkxcPj4xnkPI0R0IK97jW7zt1s8l2Hy4W8?=
 =?us-ascii?Q?G6ZpE/zfYXK8jj+LMifevFx8AOEkeWbMx1o+pxUm2vaJ37vuhjcoPJzdm4po?=
 =?us-ascii?Q?RcPYmDHBVi2a2RjOQebtvzfMEhgI99ICTpMiNh7gb+pPDbd0Pm/aR7MPLAxP?=
 =?us-ascii?Q?o4H3bmzVhLWcW7sCwqbqmZjzdywdkaFYOzreieIcM788Y3VeksHVpwtjRHiQ?=
 =?us-ascii?Q?CRpRb9cr4qqtv02eUn6H6bMPd6Kv+0eWmSz85Fcqw4700H/mSYiGB6K4exvu?=
 =?us-ascii?Q?8mRsNR7QMldVzgPKZaY/x2D/V+N+AbIiRvI+eSl9aoQ1gfJJdy7oDGXtX4ko?=
 =?us-ascii?Q?B2x35P8eeP52zNoKxut1CaCl+ytFbsJX3hWkVNMqDfon3LqTeH5qhw4GQmdJ?=
 =?us-ascii?Q?7OD3j/cu/s3+sGA2Xz93AGVdAI8lW86hCRCmTLqS98t+uGiImFY0yG5vdU2p?=
 =?us-ascii?Q?WE8m+UxAjf0k+DwUzGQdvo7Mn6B+5VmO4KfPKHFRj0HMlTA9IwpWYqGu+O+e?=
 =?us-ascii?Q?PkkYJm7o2+hjrUofBeH9U8PJytWB4Vx/D7FttAPcpIOqBYqfaSyK70Yg/jwq?=
 =?us-ascii?Q?D5Blq1JyHiQ3N4OdnKUXnS2XOChuuo25e1XKJksVFcFbhNOQSDCSQmTcOXah?=
 =?us-ascii?Q?C4VZJi8rENcm91czzEf9Ln+AAJ45jWxSuvmrW/m/bpkyTaNMve8JUx8luXvT?=
 =?us-ascii?Q?swZ0dGfE8qZk/v6HgZBIDEb9Z9ydrYYyWbhZ8zRNKt1/h/b6TWkM6/codXGS?=
 =?us-ascii?Q?ITBTKixEQwbcLdtYgOA40BDxejs8MRK4KM8VLYzm+/kkPCYXIgo3ojVL3EsQ?=
 =?us-ascii?Q?pkUJe0hfoNactLsA837WaXMX0vTt/qN+rZTjSPtSDsXp/S0lUBOAS/WmH9Ri?=
 =?us-ascii?Q?eK0+yRED214EM/7AQS9+bbYAo0uwUh4zmt//l6RipNFEddW70zr7er6hPE9W?=
 =?us-ascii?Q?EpUiJ2E4dqsmYGF/phyCFwK4ExiJXI6Q51CYGBc1mxisfqNBvBp7C9UXIBOo?=
 =?us-ascii?Q?IhXUMEvYX7sh1m3LKFk3ftuxkmdDWH3UPWiCRV+JYV/2121PCiFXYB2mTWGK?=
 =?us-ascii?Q?Ob4cTsO7r32zf6T6wi8pLU96mlpDFiVaNcn0CVhwKaWzJlOhF8FhKbfNDezY?=
 =?us-ascii?Q?W68VrNMZMDe+3pXPT67wDaTDQLxkT4/vIXxfIGsqmaLicX1KcSjXAB3Ko0ZG?=
 =?us-ascii?Q?bA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c441aa1-a775-46c1-1379-08db057b36ed
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 00:11:36.6492
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f20ztp8h78cBCW20HCRTFavYuIVpRnYPkztSXSV/X36JkOMJXMYfKHt7l38sGpIdntFhvlqOeCqDPCuqnOwi1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7190
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently it can happen that an mqprio qdisc is installed with num_tc 8,
and this will reserve 8 (out of 8) TXQs for the network stack. Then we
can attach an XDP program, and this will crop 2 TXQs, leaving just 6 for
mqprio. That's not what the user requested, and we should fail it.

On the other hand, if mqprio isn't requested, we still give the 8 TXQs
to the network stack (with hashing among a single traffic class), but
then, cropping 2 TXQs for XDP is fine, because the user didn't
explicitly ask for any number of TXQs, so no expectations are violated.

Simply put, the logic that mqprio should impose a minimum number of TXQs
for the network never existed. Let's say (more or less arbitrarily) that
without mqprio, the driver expects a minimum number of TXQs equal to the
number of CPUs (on NXP LS1028A, that is either 1, or 2). And with mqprio,
mqprio gives the minimum required number of TXQs.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 14 ++++++++++++++
 drivers/net/ethernet/freescale/enetc/enetc.h |  3 +++
 2 files changed, 17 insertions(+)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index e18a6c834eb4..1c0aeaa13cde 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2626,6 +2626,7 @@ int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 	if (!num_tc) {
 		netdev_reset_tc(ndev);
 		netif_set_real_num_tx_queues(ndev, num_stack_tx_queues);
+		priv->min_num_stack_tx_queues = num_possible_cpus();
 
 		/* Reset all ring priorities to 0 */
 		for (i = 0; i < priv->num_tx_rings; i++) {
@@ -2656,6 +2657,7 @@ int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 
 	/* Reset the number of netdev queues based on the TC count */
 	netif_set_real_num_tx_queues(ndev, num_tc);
+	priv->min_num_stack_tx_queues = num_tc;
 
 	netdev_set_num_tc(ndev, num_tc);
 
@@ -2702,9 +2704,20 @@ static int enetc_reconfigure_xdp_cb(struct enetc_ndev_priv *priv, void *ctx)
 static int enetc_setup_xdp_prog(struct net_device *ndev, struct bpf_prog *prog,
 				struct netlink_ext_ack *extack)
 {
+	int num_xdp_tx_queues = prog ? num_possible_cpus() : 0;
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	bool extended;
 
+	if (priv->min_num_stack_tx_queues + num_xdp_tx_queues >
+	    priv->num_tx_rings) {
+		NL_SET_ERR_MSG_FMT_MOD(extack,
+				       "Reserving %d XDP TXQs does not leave a minimum of %d TXQs for network stack (total %d available)",
+				       num_xdp_tx_queues,
+				       priv->min_num_stack_tx_queues,
+				       priv->num_tx_rings);
+		return -EBUSY;
+	}
+
 	extended = !!(priv->active_offloads & ENETC_F_RX_TSTAMP);
 
 	/* The buffer layout is changing, so we need to drain the old
@@ -2989,6 +3002,7 @@ int enetc_alloc_msix(struct enetc_ndev_priv *priv)
 	if (err)
 		goto fail;
 
+	priv->min_num_stack_tx_queues = num_possible_cpus();
 	first_xdp_tx_ring = priv->num_tx_rings - num_possible_cpus();
 	priv->xdp_tx_ring = &priv->tx_ring[first_xdp_tx_ring];
 
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index 1fe8dfd6b6d4..e21d096c5a90 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -369,6 +369,9 @@ struct enetc_ndev_priv {
 
 	struct psfp_cap psfp_cap;
 
+	/* Minimum number of TX queues required by the network stack */
+	unsigned int min_num_stack_tx_queues;
+
 	struct phylink *phylink;
 	int ic_mode;
 	u32 tx_ictt;
-- 
2.34.1


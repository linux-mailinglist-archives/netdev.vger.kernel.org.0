Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BFE84B8E79
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 17:48:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236634AbiBPQsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 11:48:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236616AbiBPQs0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 11:48:26 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80072.outbound.protection.outlook.com [40.107.8.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AC68280EDB;
        Wed, 16 Feb 2022 08:48:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NP42f1bzbYtHGKSMJl+3aUh4jGe3f2fLO9TNjob8rivNNRQqQvNN3swWI8b9TbDnHrPdG1Ff9x3qNyOaMcVMbWzFHzmW+tVhYnzJ4BpEB2CZSNZeFL5oKgw7cdenWlErokbzPUQNoO/p8w0GTtdRSDqTnWmuwJkVAVBO8kOtXCBjNVcS/TVJyR/Qwf7ifpn/CCqb4Mk6Ormn1t3FA/wAjfX/88hquxaYsA7BDCUAufDEMGfzeJKyEwXwyoQmT8TYay487YU10VZgO6QXZnJe/C+P6r5Tzxr3OKlbqcsyJkfHLVLVCcXpH07b3EL+X7XjG2QLWIxxSXyTZqkusn0WZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j1iCwwhYTW1FZIg5b+BwBVsYSv1fwvjw+4eL8QeQtjI=;
 b=kbEapjJTTkQOyrPv0NkQNZDzoGuN/3ch2Tsdk3qSbJzm168jRbtM4yO7ykdcpCas+fxRLYr68iMitimPtpKMhdL8mgA2kcHVdBH3I0AN8OwiFd5k983ZJYgh/fSt3YFEy3OzQmlEByaN0oqaYaCSx+I83plDwMC+t7hnJHRWDJ34GYC9imw6gJ2tHGsP7pcrBAqdElhI7JB/afeIIUKy9vMxIWniSQ7b5R8Sp+U+hofH71+69ri6/mcRWwYiIoVlwgPtXrt8K7Xi2Q+gZtt7bb8NX6nGB07FqImEVv3b8L9BRoPx1brMGI67q5KRoqE1MZkV6NfCwmAKkh/ipYqHGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j1iCwwhYTW1FZIg5b+BwBVsYSv1fwvjw+4eL8QeQtjI=;
 b=B5guQx0n6zQiRO3wjz9cnFD2LrQIt0iIrMPRgPkTwszuLMPd0hyb6jPcX/tY6v83g/A2n+O67esulkp/oJJfmcmoZoggjt5jghmLdRKlDiKceHVXSaHGsKHjeXe/hItaOGrVnwN9gsQvkU87S4KVOPq6R415E0PDeYrh+oqoA4Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB7PR04MB4091.eurprd04.prod.outlook.com (2603:10a6:5:1e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Wed, 16 Feb
 2022 16:48:11 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Wed, 16 Feb 2022
 16:48:11 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        linux-omap@vger.kernel.org
Subject: [PATCH net-next 3/5] net: sparx5: remove guards against !BRIDGE_VLAN_INFO_BRENTRY
Date:   Wed, 16 Feb 2022 18:47:50 +0200
Message-Id: <20220216164752.2794456-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220216164752.2794456-1-vladimir.oltean@nxp.com>
References: <20220216164752.2794456-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0302CA0009.eurprd03.prod.outlook.com
 (2603:10a6:205:2::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 392f5bb2-52db-4a51-204e-08d9f16c1e1c
X-MS-TrafficTypeDiagnostic: DB7PR04MB4091:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB409125BFFB30E8DC38CF0053E0359@DB7PR04MB4091.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2043;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hACYuG9GGNlDF9CxY+ez1lH8Jit4XVxCw4txthN3EDdBsT7VcvBJxZSV1ODPdYKLI5H2gzf+rj5otk3TxW1V7xyswOlribFiO2gu+qM+tqc739tDtxqp+0e0NysvMU/Ne3SNpVQ1CG87I0nlJABfdQzmyxZ5cjCEeZHIH5hb+byHeu17g1i31vEhIB+rvvYtSGFLZTEIUV3twgFVBxvzFR0d4NAMye52v9xVrB2f93nj4SoZrWp3LgUCuYj6uJcJpx06fvTKE3PLvSMuoXEOe5U91emMW5fMnaoGRspP8+uyXed/D0Ys4Ikrr2UY/1RAklQyj3CD679rScgdVPBNnR/uRy/MqZ0z51dYi+1YHQWDeJfXikX9PHr1U0XOAGx+bsrKJwJ2At95qgp6o2TWNce813SSXcc+ffER9R5hJ9bg5NrHst9l7/c97Hxi7o7tBeI4Kjw6LtwSq9NrC9pqfx4MxPe2LmXHlgiUZNnaez3XLy+O6uIBkJ/OGF8bYc9CQE4Z7l5bnP5ri0etQAO6t2Bg/CUMs70cwiMNZuBvgoqUoTonMwMjPO3paQ7N8jX1lsdXwPBBzWpH2krwf5ALCMgvXAurGkpWkcfDPt1gf0qJmHjRBBtg8GZySFk9kEJ1vKWSNrtBHgp7Wz7629p4ZOLyAfVfYrJxX78S4dUpDkCaE1D/iN2nmGgCYteeT+f2J+AFcns+5XeSKOqCHurlpw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(44832011)(6916009)(5660300002)(8676002)(52116002)(186003)(7416002)(36756003)(26005)(66476007)(6512007)(1076003)(86362001)(2616005)(8936002)(38350700002)(6666004)(83380400001)(316002)(38100700002)(2906002)(6486002)(66946007)(66556008)(508600001)(6506007)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+FgJ6BP3auvtospjjTkZ4z+sOWlSBNsO12jCaV7MDWUpWvtRSmDZ5h//jcnR?=
 =?us-ascii?Q?M1290SNV3hWsKtxTw1PUrF3UgtwiYITacXgf93M7nuMHHmFxiI+k/OcqZmEV?=
 =?us-ascii?Q?PPSLPvvPPE894fRqblCugiORU9rGoGIgjl0YDkFWdWVrwCkF3xpD5/ORjP/E?=
 =?us-ascii?Q?HH7A74HKtPfIdVVH4fqYSo4PfvyDY/ojXbqMNTQaXZsJgVaiXgmh1GfRwrMr?=
 =?us-ascii?Q?3wpy/BgCdi7P1btc63i/vLt8MAwYLOf2jhUy4nNm6hAs+4W9IP+J5wACxmRH?=
 =?us-ascii?Q?+qxSNAjfX7gba5sodjYBK7ESF61smJ4ePSt7TRA3h9PRu4q9xjNPhTLtxdnN?=
 =?us-ascii?Q?Y2LabHL7oFolaNKaJctWHMeuv2bmikJpGQZXmcvVMDbYqQ288FOXq/Zh7k0p?=
 =?us-ascii?Q?cFi3KenX2rEA5l46rKsE5PxVza1RB7fzThIy3iOpNILRvSaEt/RbOUMhjHoM?=
 =?us-ascii?Q?ZVB0MpwyVq8zMo23f7vcA73ySCto2DO4OPW/Lq/FkBua7mrnu513ZJGt8DwZ?=
 =?us-ascii?Q?o6aQQhydq62p5SSWJbjAlQUwGQMy/wySJc97ixfqi30hb5v0PdzBNnXu1WP8?=
 =?us-ascii?Q?/oXV6muzA7Wmr5qi50FcoAIJuUCZDW2N4Di2ktY4ixqeqKncRQV1xvfPySlK?=
 =?us-ascii?Q?apIWBUKcabKQgjvfjI6nOTCLM77DOAfNnzA3tYhdj616UYomP510hiEaSauK?=
 =?us-ascii?Q?jkAs4I7SxwdOhMcqaUka9ee9LQT/7OK004gZOx6gP9rmUSYwP4URGTXHuALY?=
 =?us-ascii?Q?hzEFrh5OOxBFB41aeLC4/awzeZkJ0xczQQEml/KmAK3XhGn1IGYTwPY5Ee1u?=
 =?us-ascii?Q?xo3SebOxU95qxl1tqbKn/HQd1NPJ4Hm+k27fLcQTQJ704YW0ePQG2bt5dHeT?=
 =?us-ascii?Q?skHRHYhfRWLuW2FnBGJ7DDHqdkzr0qwZ5Ovfo6jy2S3vGAGpfb6ztGfxVE1V?=
 =?us-ascii?Q?1reSTIL/nC0v+IdKeE3ZPfI3ratccOT6wkpYNFJeSAEZXffmE0dz4nam/avS?=
 =?us-ascii?Q?/aesoZ3K6J9dZ5urUeg13xo7mTa/asOkDrlbD0HocVHMudVRmH4lfIAVxd2t?=
 =?us-ascii?Q?S2M58pYp2mc/XOX1J5tBTLpmyZ0ool2+ZrjdM3MgIjnKLC4rHgp82HiE9gtM?=
 =?us-ascii?Q?+3Rah2ez2EuAS9WMQ2xhHOW7gSXz6L3uHkKwhi0WXKVk7X0xCXotNgNmY+Tb?=
 =?us-ascii?Q?O/CLNFFEHZNZmu34h+9+WuCNHAyAyWjg7TXcl1Pk/ByhbUTrEJZbpvkRx5+K?=
 =?us-ascii?Q?cwezMODVT2kbMw1K7gvZN2jTWGSjErq4fwXURxiDl6Ar4T7ULQlXmEIWLDUm?=
 =?us-ascii?Q?9+Le7jN8HRJxYmgblwWfnRaJWa9/GEw+qCqjtWqNIKuRBlZKJmZN0d4wmmY4?=
 =?us-ascii?Q?mujpm6HFwWCWjk0y9Hw4bt+dBrH2biA0GupTvjKlsXrlxXzkC20mDV0wbeMD?=
 =?us-ascii?Q?YPoMaYimuqiGSZyWrnxnzzxkFd2ORcPoYe09yYa19HYZX+Ibt3VaWnAaj6+B?=
 =?us-ascii?Q?v1F4lowNA9OLvzyI9pN+wOgRrCxiA1whKh1xMJrFIZqdTwO0f6Py4+d2kCuA?=
 =?us-ascii?Q?861MJuhRHsNQ4F7aFjMp5FtxTSLECWc/bhV58vpJE4DaoxUB5HKqY6+qrKoX?=
 =?us-ascii?Q?RkWgyxMyMccFr/WLk8SP9jY=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 392f5bb2-52db-4a51-204e-08d9f16c1e1c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 16:48:11.5432
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qnp1YWsiyp0wtUCzb4ioDKq4ibGHBag348muvRXBtrwrA8Wx0T7Mp3SdyCQ4vFc+du/Rai+/nR/1tHMHAvCpCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4091
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 3116ad0696dd ("net: bridge: vlan: don't notify to switchdev
master VLANs without BRENTRY flag"), the bridge no longer emits
switchdev notifiers for VLANs that don't have the
BRIDGE_VLAN_INFO_BRENTRY flag, so these checks are dead code.
Remove them.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../net/ethernet/microchip/sparx5/sparx5_switchdev.c   | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
index 649ca609884a..f5271c3ec133 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
@@ -369,13 +369,11 @@ static int sparx5_handle_port_vlan_add(struct net_device *dev,
 	struct sparx5_port *port = netdev_priv(dev);
 
 	if (netif_is_bridge_master(dev)) {
-		if (v->flags & BRIDGE_VLAN_INFO_BRENTRY) {
-			struct sparx5 *sparx5 =
-				container_of(nb, struct sparx5,
-					     switchdev_blocking_nb);
+		struct sparx5 *sparx5 =
+			container_of(nb, struct sparx5,
+				     switchdev_blocking_nb);
 
-			sparx5_sync_bridge_dev_addr(dev, sparx5, v->vid, true);
-		}
+		sparx5_sync_bridge_dev_addr(dev, sparx5, v->vid, true);
 		return 0;
 	}
 
-- 
2.25.1


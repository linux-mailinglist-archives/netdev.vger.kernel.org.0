Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1EF95366E6
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 20:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352096AbiE0SYo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 14:24:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235449AbiE0SYn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 14:24:43 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2126.outbound.protection.outlook.com [40.107.244.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FCD413CA2F
        for <netdev@vger.kernel.org>; Fri, 27 May 2022 11:24:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RjoKIEq/5Y6JOwVVE8j7P8aUnNDYLDhH1e83/tcsSLsIugXou+U61hS8CBhTDTMs3Ulm81OE9ERdrcKRi+X0pch4qpAoGhYbpzAQfMFVY4eLVws8+zLu8wXfw4soZ8yo8MNz1W55yhxMIhzgtuX47byOp+0FsSurfbSP752aVkwnMEJXTDJ8ebieuojfonfA266ZNoy0ReiZ78m+LAkOD5ptDYj6jKiOcYS/GnZKqm8H96s1SXD01CLTAiDI+3GIsCnV6Z+xJQDZMVyk3M95JNY5kMSYuyxNFihU1iSxrRQSjAL8M5qBxZhsGWKRfgkZNOP1yeiv6cPBIf6cjZscOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HtE89wLNAICQkpwuqsuGKgeLiu4pr96yrDYk2ZdvFmw=;
 b=Y3CiXcPFCMVELTkoXg9p0x/f5grpaGH7b7739iTAMnMcDeaEl7sBk8JHlHfeTLfOjh2PUf06pqIMkaaHwPeQjqgIkbNmqAbp9CHmCLSpOO75NNVo6M8IE9iEgaPWgdLDbdRm3cg67JaWu3ISVuMuD79BecvpHMsQ9NsF020Wp7GSz7lr9C3WsKgMOBGtKLrAFLqFcD8iOeC4psbZ5x2mZeI9vME81rsLWGdFqxgMjeeKVlvVl3v5gcxeAW/gtDGa4eTLmiVZ0KB1ru/NpuJ5kIZl/f4LiUZXzzhVQv3slBPLMRRyYW8EIFSkJKYqfo3GvuHxki0nBhkW/ZzuXDEqAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HtE89wLNAICQkpwuqsuGKgeLiu4pr96yrDYk2ZdvFmw=;
 b=BEZeeTM+UOMPUzx16Ipx7fSweaswLB65FwVOp2p7t/+PGvKwLJoCS0iR/JDmqGJ6jEi26cAz0HE14roaXPMgGpQN9/shQ7m4H1tGQPIz75wYuLJK7yucCW5x5KV6obP3ZsVMss4ddFWQaYPOwsCnO/5PhR/fbsTzQv9K3x0x+qU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BYAPR13MB2710.namprd13.prod.outlook.com (2603:10b6:a03:f8::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.6; Fri, 27 May
 2022 18:24:39 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::b18b:5e90:6805:a8fa]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::b18b:5e90:6805:a8fa%7]) with mapi id 15.20.5314.005; Fri, 27 May 2022
 18:24:39 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Yu Xiao <yu.xiao@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net] nfp: only report pause frame configuration for physical device
Date:   Fri, 27 May 2022 20:24:24 +0200
Message-Id: <20220527182424.621275-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0302CA0004.eurprd03.prod.outlook.com
 (2603:10a6:205:2::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ea5b1222-1146-41af-4396-08da400e28e4
X-MS-TrafficTypeDiagnostic: BYAPR13MB2710:EE_
X-Microsoft-Antispam-PRVS: <BYAPR13MB2710A743DD9F751BF9B8F7E9E8D89@BYAPR13MB2710.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zN6/LTy3A5bqEJJAbaSAD/rtdBYT9r9XuZNj4GgojesO2MLtXPIvzq80xkDG3Ayjz7HfXT4Lnta//oHNYFxCPdVgmFvHVYbg146a1FxWEGmncwQfa9+LWKtD38EpG6DYDCRC8ngU1GpMSJguhb1J4Me4M7ZeWiUeUtIBOB0JTRlEgqVJ1fmm0D1bGobSg8ka5Po6maJpwaPegACxKtwBxHCtzYxHtBqjaYSup4g4Wgxry3txagRauxNLjCX2JzMLg2NNfswzuXV8cOBDVs4WsIncKxE+zKLAXi1sRxNwtuAdNJ2ED3rw07ayav33O4Gg/dn5QHfXVoCCYkFBo8UsB17F9h4JKOpNbvSOGGRjgYUPAUhhCPvsYer0iPN95D3pwAss+pZHPIYTCZ60IYIjrE8CVERV2BLL9uGjIRJVSGrFsCpCmxpGst/y8OfFSRfOsNr0+LhNj2UvrsUwjVgXw6QALI1Rdj3IyumYqmKQQi5Z2MnBqpMMQy2CqFPjxiwAp7ba2uGM13KoWsnCIw8TES2nCZ0ijzUq5U0eB+AXuq+hilWkW2GRtdlSjjBxYxEWc5xApvsOPthIZ12Aa+ZvsTWRCYNlqzaFORNuVTK7OGeEP9EVlbuDXM4Qz0htE3Gb8NmXQcw21s46pqEr9Dqr5Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(376002)(346002)(39830400003)(136003)(396003)(366004)(54906003)(186003)(4326008)(86362001)(6506007)(107886003)(52116002)(44832011)(6512007)(2906002)(1076003)(316002)(41300700001)(6486002)(38100700002)(2616005)(83380400001)(6666004)(36756003)(8676002)(66556008)(66946007)(110136005)(66476007)(508600001)(5660300002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9uYJPDc4eRnpfenfInU+Jpnx3CKh5E3haDXFlHNVuArFAABp6BJFjO/li6Vi?=
 =?us-ascii?Q?AVS0QokOkKqpyZydeTK8fdVIoHOvX8p48jAbWQqjOalibIA+5iufQq0+/omV?=
 =?us-ascii?Q?9xijJuUS19k5S3BE+XuBFm6jYEJudL3yNWhA2fhbmR+EVxhbgjBh9BIEwRQq?=
 =?us-ascii?Q?ql4BYjimHyfvPddbVpeVjkugfYgBePAvMpfe9eRZhgM2l0y0WNO65NwOAg/o?=
 =?us-ascii?Q?FT8qa+MdrgfGZhnm4aaYTDIrEaxQRtXU+8Aeu6ArVyxXWABxEAboBSzxS8+M?=
 =?us-ascii?Q?xtDKL8+mde3dO0yxa2qhNB2zCek17qgDLID0uSkfWJDIdZDigWxyjPAH9sKb?=
 =?us-ascii?Q?qAgHJsIRhH0UuCmlKfmVF3xmzX6s6cro9ZI6VqW5H2ydgfXjqmItV7UGMVpc?=
 =?us-ascii?Q?x8rOdR2VFpc9wkL2sXxN+Y0QTa7ys9gZDvP7W1L9V1+SEYRhxYXDa+j25epy?=
 =?us-ascii?Q?sdcxP9MABmsH0OL3X24Z/BgYVXlxes3NdsehA3LTmpA8vgsIHTDbiy/oJgpD?=
 =?us-ascii?Q?yomaeYSDFeTa/+PFjU6PBPD3VoQ7s/rVkJIFMiaEpdXjzQx5u1qR/mxmIT+h?=
 =?us-ascii?Q?/c/jMOhdcyAuGXDkJ6IQwPKfLZnq8EKzjkPcfxFxSoVwKXV8uhzixT2p+0pq?=
 =?us-ascii?Q?LtfzPHaDvVwqoGFfPRUu1bBJ/uev+LD2F+R0aKn3Fqpl/WmRFmUGb77vgYHq?=
 =?us-ascii?Q?ssm5jo9kKeF9fjB6nthc4OPj0wwiEHz2iy6tEcc1xjNDiuJkXJ2L8ds5RBbS?=
 =?us-ascii?Q?WYUxcLAbMVkWr8oSMfaqj3o1SdVlJo4H/ZqdCKwaBLavaw+YOhGG5rYMB6pj?=
 =?us-ascii?Q?8EW5KMczv9qyOsEP5SaT5zjIqHRFjkFBYHxJqMHNZUlESlCDpYR/l0IYcVj8?=
 =?us-ascii?Q?u/FBLa/Hz7NzK0WgsuhpXb14rGyQso+dC7B2pw3yuH6YsNJwlK+HJkFyzxtt?=
 =?us-ascii?Q?7zppo+NnlPVCCAerZgPN6Nc82ZaHXEgyZOt5Pob0sYGT9z0nqKGukV6ZcX7P?=
 =?us-ascii?Q?v60cZzDssiWCAG6+TCh+wa3vHMBdKow0FnzgqkoaNnp87tSKwZI3/vCxntvQ?=
 =?us-ascii?Q?In4UzzlR9/MT6G0ep0pDTkuFdsRhWEIzg+4YbkYnj2sPf3duiuDHgojyJMZz?=
 =?us-ascii?Q?8tAlnsEHi6RqRxSDiVQ6WTGU6XsTgYjlrjn/6YzRw0SdvaNyvuxJ7sCRDege?=
 =?us-ascii?Q?iuRThJDBTOLH4R1wunjkJqpqzGzhwCzyRnMQSRcLI5TUu+PCG72MGEB1+hG9?=
 =?us-ascii?Q?LdUDTiz9zLfvJ2TtYYPMDGCIuckANYmVCuE9m0OjH+AiXY1wJUd1e52NfD44?=
 =?us-ascii?Q?NT6QZr6uLIyt/vfuAfuhA4qH03Q6vCpJb29nyDrVoRbVFyuy28sYL1x85ZAd?=
 =?us-ascii?Q?58obKacpaPjj5EN5dLfIiUqzEVUeSHdmj7zXdw/mdHg9ummFYA34M5rEesC3?=
 =?us-ascii?Q?3ZWmf2wtnJxl1HrxKazuKkr+2r8jqwsyeqMRaZEZbHBWCDr3QOLZ7Y4U3dIt?=
 =?us-ascii?Q?yt5kGXlnSNHo39vMVarF0ecT3FbBCs3ssfy54A8tzfskn5aiZ4t/gMr35BDI?=
 =?us-ascii?Q?PihIPQ+GZmRaD2G8kXywNkeD7W7lvEPTyOd0gjCb5aGTRbwioUrLpVYSRzFd?=
 =?us-ascii?Q?/pcR27QKvS6oG9r+lwpJll4+Wlfn7Xw1WZg1C6dAOxL2I1W1tDonXOjUk0bk?=
 =?us-ascii?Q?3ZbrwSl6QSKetfpb0AB+N2zOM0mHdbzubgmxUKVOmSX7IjDEobKJg2JUhvBh?=
 =?us-ascii?Q?Wa83b889Z8HN4xCMHbdALgASPlOX0zRtrHmsG8lXPtNfKcyfeISCQcJwf8TZ?=
X-MS-Exchange-AntiSpam-MessageData-1: iXR5kNzYwC57Y1hznoYvS8uuGJyMFSWy/rM=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea5b1222-1146-41af-4396-08da400e28e4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2022 18:24:38.7520
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eMfg3Hm5h2xHkUgPqhBDp3p3TPiYrErYBIceP1W4Q1f5XP2lwL+KNFL0GOY86yA1d5S65VH50Of//Qh55PS6ujRpVNGEL65c/Bx7fbuYdzU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR13MB2710
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yu Xiao <yu.xiao@corigine.com>

Only report pause frame configuration for physical device. Logical
port of both PCI PF and PCI VF do not support it.

Fixes: 9fdc5d85a8fe ("nfp: update ethtool reporting of pauseframe control")
Signed-off-by: Yu Xiao <yu.xiao@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index 61c8b450aafb..df0afd271a21 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -289,8 +289,6 @@ nfp_net_get_link_ksettings(struct net_device *netdev,
 
 	/* Init to unknowns */
 	ethtool_link_ksettings_add_link_mode(cmd, supported, FIBRE);
-	ethtool_link_ksettings_add_link_mode(cmd, supported, Pause);
-	ethtool_link_ksettings_add_link_mode(cmd, advertising, Pause);
 	cmd->base.port = PORT_OTHER;
 	cmd->base.speed = SPEED_UNKNOWN;
 	cmd->base.duplex = DUPLEX_UNKNOWN;
@@ -298,6 +296,8 @@ nfp_net_get_link_ksettings(struct net_device *netdev,
 	port = nfp_port_from_netdev(netdev);
 	eth_port = nfp_port_get_eth_port(port);
 	if (eth_port) {
+		ethtool_link_ksettings_add_link_mode(cmd, supported, Pause);
+		ethtool_link_ksettings_add_link_mode(cmd, advertising, Pause);
 		cmd->base.autoneg = eth_port->aneg != NFP_ANEG_DISABLED ?
 			AUTONEG_ENABLE : AUTONEG_DISABLE;
 		nfp_net_set_fec_link_mode(eth_port, cmd);
-- 
2.30.2


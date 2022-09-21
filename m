Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 166485BFD88
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 14:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbiIUMMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 08:12:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiIUMMv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 08:12:51 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2092.outbound.protection.outlook.com [40.107.94.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D849568D
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 05:12:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FprykDPvH+Iz02L7NT0+zvPdmqhhVPXJe0lQMOQB21B+QpsWXUI6aMr7xL7Q+9/i/nKHXgR8M+ehP2stNiHr0hY8XzLIR1pK8suZ5IIGI9h01rqPLW3wW3V5djewevsA7Ew5Yj156hQArOxngqLr7zuV2xiBEx+/ARlAKkXiDXmzRh15UEECaCR9sx3VdWayjjMxq/d8xmbLsgWkBwkQlNi3wE64atoRdIKIS3QwjbfKPgIP0VBhFiKDBdqaffY0pGhB3khAxI2/BHFC8cEeaVTTc0N1Ezt7MslPzMfYYpdOb3pqmS7pxDfSzxCbRuczw8I3F9CkNkSiEaoxfAQZcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sDkuK1tk2xi9EU0z0lQ7C9iQ+mr1LtDemhL3kCkgrbQ=;
 b=jTLmKNWm46t1oTVVVl0Z24+Wna7ilikhXHYf7QqdD/1Ky4NipgsbFsbrOBeQPhBsALpQzWuAdQKLPHYNocP0v6DgZDSBLwRbZBziU/Kh9lVMR85ZUKe+3aEms3pv737QltLHuiBHRiU7HS7fnpz1Lh+iSUHT+6w4DkHrKLjwQup5cSfLrhpNnziq0ZltXhw4sO+3tH8L6/7k5CRUmD+gTvMqy5y6uaytmgf240tkO8a3dguxVNS/G31fJTUzahFlLnjcrFwzySVW0GMKS4Ylh4u9fGQgk/gPunsMPNc/n2hJT0M+T3rEztAzq5wO9f5uEzYKruxZdt3wWvGFTM9jVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sDkuK1tk2xi9EU0z0lQ7C9iQ+mr1LtDemhL3kCkgrbQ=;
 b=iD9uA+FdCkMSDxjfZOFxPZ7Slb1D3wfzBq+HidCJR4mfoMvHrUyMNjYCTMJjAmz8Q2ABe90oDkeZipyn8eTOigIp8IW91gzvrRiiz5px5Xr7YWHFcltcDAuJS7v86tDGQBfHLYguQQ5zV40ekuNZ+Fu1C21D1luDAncNdjihTXk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL3PR13MB5210.namprd13.prod.outlook.com (2603:10b6:208:341::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.14; Wed, 21 Sep
 2022 12:12:49 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::2cbf:e4b1:5bbf:3e54]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::2cbf:e4b1:5bbf:3e54%4]) with mapi id 15.20.5654.014; Wed, 21 Sep 2022
 12:12:49 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Fei Qin <fei.qin@corigine.com>
Subject: [PATCH net-next 1/3] nfp: add support for reporting active FEC mode
Date:   Wed, 21 Sep 2022 14:12:33 +0200
Message-Id: <20220921121235.169761-2-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220921121235.169761-1-simon.horman@corigine.com>
References: <20220921121235.169761-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0049.eurprd04.prod.outlook.com
 (2603:10a6:208:1::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL3PR13MB5210:EE_
X-MS-Office365-Filtering-Correlation-Id: 9cf14220-ee4f-433c-cf19-08da9bca99a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aJmYNDwDc3P75bSVsJ8F6wC5efYEfE09xuuOONQiZ1CCU99lPUWffZqOhl+QTxq5y3g2xdgQATMjPR6JCYElZtvyjeLYAZHoDkAruW7v+nOf7x5MDNMwAIV9hiy7GkIOoGKYfiMPPDxmG61OLQkQeQKgmRTScBMrhABBCiIfi8wrXaYyc9IVCyBmrLnepwiBCxCFf1l4Gov5CFvPYqcnmIYtGAqL6/RLHWNYpAoVTcsdQGIkkacRT3wV71ju6fr3VCKwCzh5l2Pb6TDePB0FRLXPqH+jPo3znQfo/QGAB8qUUIQt5YjZcHtMJliZCbjatoGTZ5M6lHAHMvjh8qz5qRTb7+FRm5HCbhxtnChORPatFG+7Gco/Ux/Cms26Fdru+hOZn3tGdYDXAN2oa0FP1Ha4FEeiBl4f6jTrM6PChIDGk71/WHkPvlWqCNBY4jWLT1YvPNEDMesVucJ8kZEZNZu4CxtfbY7Q0XSBdpGrCbxWOlF/ddDGaguMtwwwd09FYvvs6auXiicvoheMQ/GGn9UQxGt1yyg86rsu3DK8GhRCYIiA7LdCis/5eTRokX5JROs11IHnD/li3kR1wC475VpY/PtMsFVS4BKNgc3UoTwvOtbx5vQl51ThUgYVap7q+ziX2JstToL3nTbltPzox15yTxww1Rvmn+rRAQD5V0/urHj7j3sV44sWJWUrXRBVqu9Ouein81a0on3cTDNNug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39840400004)(366004)(136003)(346002)(451199015)(107886003)(86362001)(41300700001)(6666004)(5660300002)(44832011)(8676002)(478600001)(110136005)(4326008)(316002)(66946007)(6486002)(66556008)(66476007)(8936002)(38100700002)(2616005)(1076003)(52116002)(6506007)(6512007)(186003)(83380400001)(2906002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7R810MdeAmu5s/Uk3ewX5+yhMVdvcKOrTcZk9Cdn188MUnFAf56EXUy7glPe?=
 =?us-ascii?Q?TgbHEG1lprgY6tokAT4W8F4ldhLDIQ20DO9ock1E2ZaZEYDaqKPtDYNUKJlO?=
 =?us-ascii?Q?9+uI5L6H/LWDK+E56yZFSLW6QdS82jardiqA1Pd0B4w8meVr1k7pQ57OMGUr?=
 =?us-ascii?Q?6l/H1/+Z2UHguJgfzP2GIuMp7skONsH6cWnlTKlQVz81sWrW1EcxiTAMVveu?=
 =?us-ascii?Q?OY/6cL/wS7bLphdGHg05Hfmq1/XJ8WkPLe3JzYiVnP+cpNqaxMQtuTji98LU?=
 =?us-ascii?Q?db6zBDMf4z8NSgej/fcBApixBAuEV4s8zje5EHyPWeOBPMBfSebp+MhD//nv?=
 =?us-ascii?Q?oBHpN/8ilF/d5xgMRK0phLiZIuYBtBliVEdst/SO858JMADQNPK75NEbR6ji?=
 =?us-ascii?Q?p0YE93suzaPdGpzj8zQC28/DrfpXlElsK2dHSjT0SUU1rE8M4Xdh1GihbZ+L?=
 =?us-ascii?Q?dEua+4QX5NhJZwltIh+Qpjo8C2yLp6PYGMi+HAf196Ni7+jKE4vje6B05c5g?=
 =?us-ascii?Q?EnGlStxLe69DUvhAOtjWpyTX+0MCr/CfLaFR4Ax+uidAQkfvxJRWR9VeuGFr?=
 =?us-ascii?Q?47uwhC7ENODiN8dKoIiBjjQpQoV7+d2PBHjVY3OowLoexuwdjCcSIrI0Hbvn?=
 =?us-ascii?Q?o2Luuy3RtaRamPPibO/auzC5XpJrc51sZk3c49zqrLYiPuzZAo17Ncee/sXD?=
 =?us-ascii?Q?ZH1/9G+GaMfWhhUGBTf9qJwTFtg2TU+l9ZHfeIQ2zfq7Z5UQXRaCScn1qNaD?=
 =?us-ascii?Q?wlX8jMvK4UtK64g6LOhaIXLMhy6EPYcMia4iXu1jadbaoVuTC9kpUlTRuKmf?=
 =?us-ascii?Q?F9frBL3ppLbeUuH+LROlq+Wuxn3SbznOtKxZr+bLCYikmaQGfaGAqZVfxi8n?=
 =?us-ascii?Q?UfBUn+7FIYh+p7dCJi6D7pdjx5sRmi0F1hOHRwwN+LY4x4KqteBHsD6H/ISb?=
 =?us-ascii?Q?JfFIOrQ77oIq4kG9zkNCqNP/8CgjnJUSj5mylMWDLxOGQs288V7VCxxR6NOI?=
 =?us-ascii?Q?W92PkJRq5xXNuoz90IG6f/nK35OiK/f628+QTLm3AK3GhKBhXcg3/ffzJRef?=
 =?us-ascii?Q?3aPHCjnAB+lR/vuH7FIR1s8CM2F0kWzWIa8dQMHPTap7EKQvsh2TPf8Gm3th?=
 =?us-ascii?Q?biOedYy9YgjgjjZCA62GdMePNwOMRAeh+LCTAQyEwctlubzsGnQRoP5gk2gp?=
 =?us-ascii?Q?TrZAqkdHsQ3VgZHwEAZswtQiz7J951FDAufIlqB6Lp3VbAO9iYJrT1xaXEGq?=
 =?us-ascii?Q?OD2CPySQ4Ru6OUqXKgMzufHyq3JYbDmQcLI1EyAHnJR2hEYQAWLK7+JaBFzw?=
 =?us-ascii?Q?wsMGFAGIvjmhhzf7NxAGVBVLCSIxmatl6zJS410+u5rxYaEESUOmk+FKFo0U?=
 =?us-ascii?Q?JRA1QcxAS/YgQgFoHQ/PQxiMnmo4Z0+7cciX4H2jECRl8sUnmaoEQfklbLrt?=
 =?us-ascii?Q?9bhq8FJvMRg8phTUliv2U08m+8PoU5+Rcuz9qrcJ98BikY0pDTEkteBDemLi?=
 =?us-ascii?Q?0wAyKfc52QuG1KIHE6kacOhglw38U7wfyKloSuho9YSvedqitydB4P78ihNp?=
 =?us-ascii?Q?jn/fK1ie1GrDaS9G1YdbP5lXRYRHSvw3BpKRWYJzLfLo8WgTIM/OYxdzqDLg?=
 =?us-ascii?Q?DEg2C2UHqRX7dGBY7eaTptRZB4YHyXfOxyw3mcN3Ik/SaChiJn+K6Z0NzHH3?=
 =?us-ascii?Q?vkS8/w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cf14220-ee4f-433c-cf19-08da9bca99a9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 12:12:49.1181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E6JWoOn6rjNQAYYZlIXQnWz70cFWxJty7A2SW+HiCp6JtLq779WTZQyRBl6NhI/0v39yoNU6nVfOkevf3Yvc0/vdv5f6RWONCAKV9x5ih74=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR13MB5210
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yinjun Zhang <yinjun.zhang@corigine.com>

The latest management firmware can now report the active FEC
mode. Adapt driver accordingly so that user can get the active
FEC mode by running command:

  # ethtool --show-fec <intf>

Also correct use of `fec` field.

Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c     | 2 +-
 drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h     | 2 ++
 drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c | 9 ++++++++-
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index db58532364b6..d50af23642a2 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -996,7 +996,7 @@ nfp_port_get_fecparam(struct net_device *netdev,
 		return 0;
 
 	param->fec = nfp_port_fec_nsp_to_ethtool(eth_port->fec_modes_supported);
-	param->active_fec = nfp_port_fec_nsp_to_ethtool(eth_port->fec);
+	param->active_fec = nfp_port_fec_nsp_to_ethtool(BIT(eth_port->act_fec));
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h
index 77d66855be42..52465670a01e 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h
@@ -132,6 +132,7 @@ enum nfp_eth_fec {
  * @ports.interface:	interface (module) plugged in
  * @ports.media:	media type of the @interface
  * @ports.fec:		forward error correction mode
+ * @ports.act_fec:	active forward error correction mode
  * @ports.aneg:		auto negotiation mode
  * @ports.mac_addr:	interface MAC address
  * @ports.label_port:	port id
@@ -162,6 +163,7 @@ struct nfp_eth_table {
 		enum nfp_eth_media media;
 
 		enum nfp_eth_fec fec;
+		enum nfp_eth_fec act_fec;
 		enum nfp_eth_aneg aneg;
 
 		u8 mac_addr[ETH_ALEN];
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c
index 4cc38799eabc..18ba7629cdc2 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c
@@ -40,6 +40,7 @@
 #define NSP_ETH_STATE_OVRD_CHNG		BIT_ULL(22)
 #define NSP_ETH_STATE_ANEG		GENMASK_ULL(25, 23)
 #define NSP_ETH_STATE_FEC		GENMASK_ULL(27, 26)
+#define NSP_ETH_STATE_ACT_FEC		GENMASK_ULL(29, 28)
 
 #define NSP_ETH_CTRL_CONFIGURED		BIT_ULL(0)
 #define NSP_ETH_CTRL_ENABLED		BIT_ULL(1)
@@ -170,7 +171,13 @@ nfp_eth_port_translate(struct nfp_nsp *nsp, const union eth_table_entry *src,
 	if (dst->fec_modes_supported)
 		dst->fec_modes_supported |= NFP_FEC_AUTO | NFP_FEC_DISABLED;
 
-	dst->fec = 1 << FIELD_GET(NSP_ETH_STATE_FEC, state);
+	dst->fec = FIELD_GET(NSP_ETH_STATE_FEC, state);
+	dst->act_fec = dst->fec;
+
+	if (nfp_nsp_get_abi_ver_minor(nsp) < 33)
+		return;
+
+	dst->act_fec = FIELD_GET(NSP_ETH_STATE_ACT_FEC, state);
 }
 
 static void
-- 
2.30.2


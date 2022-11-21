Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB8263207A
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 12:25:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbiKULZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 06:25:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiKULZ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 06:25:26 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2118.outbound.protection.outlook.com [40.107.93.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65639A6A14
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 03:21:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LgxSq4KfktPILzA8gMYovguP7WRZ2w9nVhBroJlb1FZ6qnXDqyzpLkfW+JHSkWMt/uUQPhRvJ+pteydT2Dc0KqpTk8m9R+Urs4EldB04td0CXYz6wBBfPU+afDwsrGcff75eICEHeG73MZXQrs2pRB6B850h8bmTIjXKA+Mv4IWgb4iZ6sX4nBrGOQA5NaV8qU0m6eV2E3hPgtcgojkYlQJ6Mr4Dc4ygAIdRfdrdH88vjg0dccoQuUmpGaVjyw2RppMcbafQ+9Zc2zzlG0H4ZMhCi3pJ2RFRDGh59E6X/T/Ho6fqC8fQAcO4pOqVY48stvwQ5a6UAwb6jDN6hc1MZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZIxXJ2pkGSHY1tvPGswRjmDObGm1D1M5PS725rXjXXo=;
 b=NpVkpY288Xv34Mz5E6fv4eagWHfmO4DjNcnu0bnraus3y+/LHsVch4BL+ikWV2vrjFXyAH2MzfuFXFs+kbGV4B59OT/0XxBCFAIDs1LILQ5yrHtfwjeRotPK4O0tDGSYchgx60hrVoic3Vg8SB4npuay/xO8ur93fERC1IMqkkLr7q9iezx5rhfhzKNhcCujcy47gndhzVdMPPyJ5/M0nkvw3n1PiGm7EDgtt/E0oKRzQ/T3+HzOPn1A0QVGWSpJDFBL8OfK+ivOLU2cJQC1TDoTLFxCvvZwnsyacfaoYlBK2joCjCaCPaOQkuaReR5JLueZ6j0uVsvTtflFaSnhgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZIxXJ2pkGSHY1tvPGswRjmDObGm1D1M5PS725rXjXXo=;
 b=k9n2BcC1vP3eHut8AoqW8aSIVp/slFDJewTO/fOMilO0a/6qK3dHroefFjjOLZZSP3kHRfRD9vXPQOVY7wJSslvGVhY1o6JfV0iEhpND+XxGHEg2hw0H59B/jPPxRUHTb+UzgPsmUX6wZlx6R14wmrH9FiaZa5jQjdaO+MHWj9o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB4665.namprd13.prod.outlook.com (2603:10b6:610:c6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Mon, 21 Nov
 2022 11:21:01 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30%8]) with mapi id 15.20.5834.015; Mon, 21 Nov 2022
 11:21:01 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Yu Xiao <yu.xiao@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next] nfp: ethtool: support reporting link modes
Date:   Mon, 21 Nov 2022 12:20:45 +0100
Message-Id: <20221121112045.862295-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P191CA0025.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:21a::30) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH0PR13MB4665:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c20d32a-42cf-433b-ef5d-08dacbb27772
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JFdqfN445WH/t28Kse5MTstvA9r0gk4T/h8ZBYMWVhOQDqRaQph7VO1ql2NRtnKC6RqYYLFq82ALNU0GdzszMNQybuU7sGCtNxJuNKaPMy+rH7s6ylo9PkJc5Cg4J3dB3X9UNyv9ZMW50kwLQUCmQ92el6WFXUkb5WGc0Tx7SxhrdDVKM69t3uURqDLNpswD9hVD8uVA/oss8EGA68vw2dHgmaomjGvfZ8CPgFJcZtIMwWuIeNJcAdVKZmTac1n1Gq0vzbAQvYYzaVeRIaWc4CXpRugQHT7dxnXJsnHK1Dr3YuzuV0x3jmsnRMmgx51iqPvsq4XDRj4JHeCsOT9CTF2Ejr1O9el1uZFMtOzdQuElGGjXKIkIaOVssBhE/cWeYoYvsZZ0PLb1H3h0re5wVK0+O7WsZT2j2K4DwUrspRPSs+imlga5EUk4duvsr07p3+c1aqdG1KQ7qFU6Uplct8TqKzPNmhsWBmJMrRFwqaKSbyIPxn3U3/nRpwS2YUzFjJ4uyyhoXJEUzWQwWuPCldx9iaByvKUh1vdjQrU2HOhr3V3HUB8URAQMsOROMCjXJHfzwcdbhbkOlxlEuZefk1wjuwRwLN3F/m4OBMkMAKtzmLliLoBAfptuccWQVCWHWpMWisPvtls/dX6bj+pvaC1kZojAziJKtycgA1H9+YwWJO1bR0Ocx2dXQ/uAbWsI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39830400003)(346002)(366004)(396003)(136003)(451199015)(86362001)(36756003)(4326008)(44832011)(8936002)(41300700001)(5660300002)(66946007)(107886003)(8676002)(66476007)(66556008)(52116002)(83380400001)(6666004)(6512007)(110136005)(54906003)(6506007)(6486002)(316002)(478600001)(2906002)(1076003)(186003)(2616005)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?q8002bOWUm7kprtj1vQELljqou1jcWWhFwjCNctXcKaTpm/B2fDxvzZL8RMA?=
 =?us-ascii?Q?3JyUGMrdQH74uW436gNAr8i7vw0+968eyAKxpw3ZxPfk1C08x8rwXO6Md1I8?=
 =?us-ascii?Q?j7Wemag5g8YoQYus5BoIAPbzYQYHsNeY5ZnNjBYa3P0aIrBFSUPc1FbKpiI9?=
 =?us-ascii?Q?lOC41S10rcgyJUm9kg0UrBxLxL4y0baeZ7HaM5J6ESRAkm7zb4eilWKbb8IE?=
 =?us-ascii?Q?Vx5xp6/50C3zJUqitbA8rprPC3Ern9MyLF99n3XSluNWu+xQxRjZtrx/RK1R?=
 =?us-ascii?Q?Ga0fYpHHYpL1tuz5AEGrEumeQbJGIT0VGFkwHPdE21RPt2DL1nc5bhBS7vCQ?=
 =?us-ascii?Q?TabzzHj/i77vDczOGsztwUQfQfJyGMS7UK5XeGAICChOumAp34bl7gDHrMup?=
 =?us-ascii?Q?+kj2hqqKt/1TvoYE8RnplusBWqaBCOUEQJlzmx6cbxVH923ooX4SO5ze7xkL?=
 =?us-ascii?Q?9WXndV1alri9eLMx9eeEO5EbNgesUC1ehY6XC1QePnAzRLfgyXC/TvxyASuh?=
 =?us-ascii?Q?MBNY47qfizQ+mafqZQed0PyJQnJQ43RWqFLs+uV8ITf1y88F0ChULWPlXYNO?=
 =?us-ascii?Q?8FQMEUVhdkL799UoMGTxCz75S2cXmrqpzuMZMIkxzDrlfW90gxvO7HjyaxO7?=
 =?us-ascii?Q?Et4MrwsDwQyOE/tU0u64J/PCXo0ktXHPxUR3d7CxsVPC2z9RFAxpiNTFDSLH?=
 =?us-ascii?Q?8IN65Z16PAH8MfpC2Y9s7wJsunYeIy1+aJu29qLtu/m6gLT1Xazdwb0YY7Ep?=
 =?us-ascii?Q?chx55d8x4oUeT28w04pp3ebpEU2/3bHujKe+uC7pdExKT+ULzR9yL0Dc23Gz?=
 =?us-ascii?Q?yIau7CRFbt7P5/Ue6djptqI4wPzQ3Buhq+u2OoR1ZJk6afdofS3z9UGJG7fh?=
 =?us-ascii?Q?A44f8QsGpzCMo8Fcyo/VFv/yJgODRfF/zzZg1hSM56OVWbMpE9iFP6y+SLL3?=
 =?us-ascii?Q?VxsTnZls1Rt8PhyCq6Rmesn6198/YuiWgTYZJ1wDtHMnp18MPchoCkT2AXDZ?=
 =?us-ascii?Q?fYcEaPAV8SWoNkMIlhgEZwLHQgagASYkFFxtHyjwH1l8Gfz3T+0XETTC6FmV?=
 =?us-ascii?Q?AgHnpMJ342J8dtPKIAlaf6x4uNYtoIRfP7IXcAFtVoL7dQkPTSgQhSTYHwDh?=
 =?us-ascii?Q?+wLJj7kACRDYAbNhWjWh6eQ7EFzXidXGZoz4W00bAv7wV9PZvY6hqN3lNsu+?=
 =?us-ascii?Q?YHTCExJPiz4s47GYtHLSkYiimrrkUehDlqoNtJKRqjld/OY7GoU9o0IFxghx?=
 =?us-ascii?Q?dvvrQ4LGYB9Wh8+3yhdYqGLx9uXm45zER80NdqWDMbkiFX/t93IbnCXQ3pWV?=
 =?us-ascii?Q?97KLKNYjkRoACo9IR8yI1/b1WFega9L1aS/DclVfSkjWUKtkDDU35O+bPtqH?=
 =?us-ascii?Q?5XKH1t6+BQlPazoxKhBjccGf2msd403h7KS57brkFmyuw8KMr65ymeh5v/c3?=
 =?us-ascii?Q?N784M/zVUvelf5tc7tGQQ8NZlE4U51zToP3qHAPpZ/hN88HzX82C+kgMwi60?=
 =?us-ascii?Q?PRLUCXzN79Hz1dd2HeKxRvOZqxEkMO56laYHA0nGGITLaAnytnmOkiztcRgv?=
 =?us-ascii?Q?H7zWisLfvIncF6VDY9pH3MB7jP+CueD2nCnmQW0brOlndtREuaxvj4P0GKYz?=
 =?us-ascii?Q?TRaGIhqShZ1qA0xXt3hoBhi64n/mgvcZcsPxAhR8L03vkegZpNeW1PJT85rt?=
 =?us-ascii?Q?GuS22A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c20d32a-42cf-433b-ef5d-08dacbb27772
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 11:21:01.0008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q6NNFlZFtJrD255IR/RlJ4Dn05pG25YTdoG5Axp5WGqGY4PF3yBHpQlQbwZvIM4kAFOagHo14jawrphZuDpwshFS/nLSrAXhZqZU2SVFZEI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB4665
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yu Xiao <yu.xiao@corigine.com>

Add support for reporting link modes,
including `Supported link modes` and `Advertised link modes`,
via ethtool $DEV.

A new command `SPCODE_READ_MEDIA` is added to read info from
management firmware. Also, the mapping table `nfp_eth_media_table`
associates the link modes between NFP and kernel. Both of them
help to support this ability.

Signed-off-by: Yu Xiao <yu.xiao@corigine.com>
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_main.h |  1 +
 .../ethernet/netronome/nfp/nfp_net_ethtool.c  | 56 ++++++++++++++++++
 .../ethernet/netronome/nfp/nfpcore/nfp_nsp.c  | 17 ++++++
 .../ethernet/netronome/nfp/nfpcore/nfp_nsp.h  | 59 +++++++++++++++++++
 .../netronome/nfp/nfpcore/nfp_nsp_eth.c       | 27 +++++++++
 5 files changed, 160 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_main.h b/drivers/net/ethernet/netronome/nfp/nfp_main.h
index 5a18af672e6b..14a751bfe1fe 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_main.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_main.h
@@ -27,6 +27,7 @@ struct nfp_hwinfo;
 struct nfp_mip;
 struct nfp_net;
 struct nfp_nsp_identify;
+struct nfp_eth_media_buf;
 struct nfp_port;
 struct nfp_rtsym;
 struct nfp_rtsym_table;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index 0058ba2b3505..be434b01b724 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -293,6 +293,59 @@ nfp_net_set_fec_link_mode(struct nfp_eth_table_port *eth_port,
 	}
 }
 
+static const u8 nfp_eth_media_table[] = {
+	[NFP_MEDIA_1000BASE_CX] = ETHTOOL_LINK_MODE_1000baseKX_Full_BIT,
+	[NFP_MEDIA_1000BASE_KX] = ETHTOOL_LINK_MODE_1000baseKX_Full_BIT,
+	[NFP_MEDIA_10GBASE_KX4] = ETHTOOL_LINK_MODE_10000baseKX4_Full_BIT,
+	[NFP_MEDIA_10GBASE_KR] = ETHTOOL_LINK_MODE_10000baseKR_Full_BIT,
+	[NFP_MEDIA_10GBASE_CX4] = ETHTOOL_LINK_MODE_10000baseKX4_Full_BIT,
+	[NFP_MEDIA_10GBASE_CR] = ETHTOOL_LINK_MODE_10000baseCR_Full_BIT,
+	[NFP_MEDIA_10GBASE_SR] = ETHTOOL_LINK_MODE_10000baseSR_Full_BIT,
+	[NFP_MEDIA_10GBASE_ER] = ETHTOOL_LINK_MODE_10000baseER_Full_BIT,
+	[NFP_MEDIA_25GBASE_KR] = ETHTOOL_LINK_MODE_25000baseKR_Full_BIT,
+	[NFP_MEDIA_25GBASE_KR_S] = ETHTOOL_LINK_MODE_25000baseKR_Full_BIT,
+	[NFP_MEDIA_25GBASE_CR] = ETHTOOL_LINK_MODE_25000baseCR_Full_BIT,
+	[NFP_MEDIA_25GBASE_CR_S] = ETHTOOL_LINK_MODE_25000baseCR_Full_BIT,
+	[NFP_MEDIA_25GBASE_SR] = ETHTOOL_LINK_MODE_25000baseSR_Full_BIT,
+	[NFP_MEDIA_40GBASE_CR4] = ETHTOOL_LINK_MODE_40000baseCR4_Full_BIT,
+	[NFP_MEDIA_40GBASE_KR4] = ETHTOOL_LINK_MODE_40000baseKR4_Full_BIT,
+	[NFP_MEDIA_40GBASE_SR4] = ETHTOOL_LINK_MODE_40000baseSR4_Full_BIT,
+	[NFP_MEDIA_40GBASE_LR4] = ETHTOOL_LINK_MODE_40000baseLR4_Full_BIT,
+	[NFP_MEDIA_50GBASE_KR] = ETHTOOL_LINK_MODE_50000baseKR_Full_BIT,
+	[NFP_MEDIA_50GBASE_SR] = ETHTOOL_LINK_MODE_50000baseSR_Full_BIT,
+	[NFP_MEDIA_50GBASE_CR] = ETHTOOL_LINK_MODE_50000baseCR_Full_BIT,
+	[NFP_MEDIA_50GBASE_LR] = ETHTOOL_LINK_MODE_50000baseLR_ER_FR_Full_BIT,
+	[NFP_MEDIA_50GBASE_ER] = ETHTOOL_LINK_MODE_50000baseLR_ER_FR_Full_BIT,
+	[NFP_MEDIA_50GBASE_FR] = ETHTOOL_LINK_MODE_50000baseLR_ER_FR_Full_BIT,
+	[NFP_MEDIA_100GBASE_KR4] = ETHTOOL_LINK_MODE_100000baseKR4_Full_BIT,
+	[NFP_MEDIA_100GBASE_SR4] = ETHTOOL_LINK_MODE_100000baseSR4_Full_BIT,
+	[NFP_MEDIA_100GBASE_CR4] = ETHTOOL_LINK_MODE_100000baseCR4_Full_BIT,
+	[NFP_MEDIA_100GBASE_KP4] = ETHTOOL_LINK_MODE_100000baseKR4_Full_BIT,
+	[NFP_MEDIA_100GBASE_CR10] = ETHTOOL_LINK_MODE_100000baseCR4_Full_BIT,
+};
+
+static void nfp_add_media_link_mode(struct nfp_port *port,
+				    struct nfp_eth_table_port *eth_port,
+				    struct ethtool_link_ksettings *cmd)
+{
+	struct nfp_eth_media_buf ethm = {.eth_index = eth_port->eth_index};
+	struct nfp_cpp *cpp = port->app->cpp;
+	u8 i;
+
+	if (nfp_eth_read_media(cpp, &ethm))
+		return;
+
+	for (i = 0; i < NFP_MEDIA_LINK_MODES_NUMBER; ++i) {
+		if (test_bit(i, ethm.supported_modes))
+			__set_bit(nfp_eth_media_table[i],
+				  cmd->link_modes.supported);
+
+		if (test_bit(i, ethm.advertised_modes))
+			__set_bit(nfp_eth_media_table[i],
+				  cmd->link_modes.advertising);
+	}
+}
+
 /**
  * nfp_net_get_link_ksettings - Get Link Speed settings
  * @netdev:	network interface device structure
@@ -311,6 +364,8 @@ nfp_net_get_link_ksettings(struct net_device *netdev,
 	u16 sts;
 
 	/* Init to unknowns */
+	ethtool_link_ksettings_zero_link_mode(cmd, supported);
+	ethtool_link_ksettings_zero_link_mode(cmd, advertising);
 	ethtool_link_ksettings_add_link_mode(cmd, supported, FIBRE);
 	cmd->base.port = PORT_OTHER;
 	cmd->base.speed = SPEED_UNKNOWN;
@@ -321,6 +376,7 @@ nfp_net_get_link_ksettings(struct net_device *netdev,
 	if (eth_port) {
 		ethtool_link_ksettings_add_link_mode(cmd, supported, Pause);
 		ethtool_link_ksettings_add_link_mode(cmd, advertising, Pause);
+		nfp_add_media_link_mode(port, eth_port, cmd);
 		if (eth_port->supp_aneg) {
 			ethtool_link_ksettings_add_link_mode(cmd, supported, Autoneg);
 			if (eth_port->aneg == NFP_ANEG_AUTO) {
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c
index 730fea214b8a..7136bc48530b 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c
@@ -100,6 +100,7 @@ enum nfp_nsp_cmd {
 	SPCODE_FW_LOADED	= 19, /* Is application firmware loaded */
 	SPCODE_VERSIONS		= 21, /* Report FW versions */
 	SPCODE_READ_SFF_EEPROM	= 22, /* Read module EEPROM */
+	SPCODE_READ_MEDIA	= 23, /* Get either the supported or advertised media for a port */
 };
 
 struct nfp_nsp_dma_buf {
@@ -1100,4 +1101,20 @@ int nfp_nsp_read_module_eeprom(struct nfp_nsp *state, int eth_index,
 	kfree(buf);
 
 	return ret;
+};
+
+int nfp_nsp_read_media(struct nfp_nsp *state, void *buf, unsigned int size)
+{
+	struct nfp_nsp_command_buf_arg media = {
+		{
+			.code		= SPCODE_READ_MEDIA,
+			.option		= size,
+		},
+		.in_buf		= buf,
+		.in_size	= size,
+		.out_buf	= buf,
+		.out_size	= size,
+	};
+
+	return nfp_nsp_command_buf(state, &media);
 }
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h
index 992d72ac98d3..c5630fe88a66 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h
@@ -65,6 +65,11 @@ static inline bool nfp_nsp_has_read_module_eeprom(struct nfp_nsp *state)
 	return nfp_nsp_get_abi_ver_minor(state) > 28;
 }
 
+static inline bool nfp_nsp_has_read_media(struct nfp_nsp *state)
+{
+	return nfp_nsp_get_abi_ver_minor(state) > 33;
+}
+
 enum nfp_eth_interface {
 	NFP_INTERFACE_NONE	= 0,
 	NFP_INTERFACE_SFP	= 1,
@@ -97,6 +102,47 @@ enum nfp_eth_fec {
 	NFP_FEC_DISABLED_BIT,
 };
 
+/* link modes about RJ45 haven't been used, so there's no mapping to them */
+enum nfp_ethtool_link_mode_list {
+	NFP_MEDIA_W0_RJ45_10M,
+	NFP_MEDIA_W0_RJ45_10M_HD,
+	NFP_MEDIA_W0_RJ45_100M,
+	NFP_MEDIA_W0_RJ45_100M_HD,
+	NFP_MEDIA_W0_RJ45_1G,
+	NFP_MEDIA_W0_RJ45_2P5G,
+	NFP_MEDIA_W0_RJ45_5G,
+	NFP_MEDIA_W0_RJ45_10G,
+	NFP_MEDIA_1000BASE_CX,
+	NFP_MEDIA_1000BASE_KX,
+	NFP_MEDIA_10GBASE_KX4,
+	NFP_MEDIA_10GBASE_KR,
+	NFP_MEDIA_10GBASE_CX4,
+	NFP_MEDIA_10GBASE_CR,
+	NFP_MEDIA_10GBASE_SR,
+	NFP_MEDIA_10GBASE_ER,
+	NFP_MEDIA_25GBASE_KR,
+	NFP_MEDIA_25GBASE_KR_S,
+	NFP_MEDIA_25GBASE_CR,
+	NFP_MEDIA_25GBASE_CR_S,
+	NFP_MEDIA_25GBASE_SR,
+	NFP_MEDIA_40GBASE_CR4,
+	NFP_MEDIA_40GBASE_KR4,
+	NFP_MEDIA_40GBASE_SR4,
+	NFP_MEDIA_40GBASE_LR4,
+	NFP_MEDIA_50GBASE_KR,
+	NFP_MEDIA_50GBASE_SR,
+	NFP_MEDIA_50GBASE_CR,
+	NFP_MEDIA_50GBASE_LR,
+	NFP_MEDIA_50GBASE_ER,
+	NFP_MEDIA_50GBASE_FR,
+	NFP_MEDIA_100GBASE_KR4,
+	NFP_MEDIA_100GBASE_SR4,
+	NFP_MEDIA_100GBASE_CR4,
+	NFP_MEDIA_100GBASE_KP4,
+	NFP_MEDIA_100GBASE_CR10,
+	NFP_MEDIA_LINK_MODES_NUMBER
+};
+
 #define NFP_FEC_AUTO		BIT(NFP_FEC_AUTO_BIT)
 #define NFP_FEC_BASER		BIT(NFP_FEC_BASER_BIT)
 #define NFP_FEC_REED_SOLOMON	BIT(NFP_FEC_REED_SOLOMON_BIT)
@@ -256,6 +302,19 @@ enum nfp_nsp_sensor_id {
 int nfp_hwmon_read_sensor(struct nfp_cpp *cpp, enum nfp_nsp_sensor_id id,
 			  long *val);
 
+/* The maximum number of link modes can be added */
+#define NFP_NSP_MAX_MODE_SIZE	128
+
+struct nfp_eth_media_buf {
+	u8 eth_index;
+	u8 reserved[7];
+	DECLARE_BITMAP(supported_modes, NFP_NSP_MAX_MODE_SIZE);
+	DECLARE_BITMAP(advertised_modes, NFP_NSP_MAX_MODE_SIZE);
+};
+
+int nfp_nsp_read_media(struct nfp_nsp *state, void *buf, unsigned int size);
+int nfp_eth_read_media(struct nfp_cpp *cpp, struct nfp_eth_media_buf *ethm);
+
 #define NFP_NSP_VERSION_BUFSZ	1024 /* reasonable size, not in the ABI */
 
 enum nfp_nsp_versions {
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c
index bb64efec4c46..0996fefd6cd9 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c
@@ -647,3 +647,30 @@ int __nfp_eth_set_split(struct nfp_nsp *nsp, unsigned int lanes)
 	return NFP_ETH_SET_BIT_CONFIG(nsp, NSP_ETH_RAW_PORT, NSP_ETH_PORT_LANES,
 				      lanes, NSP_ETH_CTRL_SET_LANES);
 }
+
+int nfp_eth_read_media(struct nfp_cpp *cpp, struct nfp_eth_media_buf *ethm)
+{
+	struct nfp_nsp *nsp;
+	int err;
+
+	nsp = nfp_nsp_open(cpp);
+	if (IS_ERR(nsp)) {
+		err = PTR_ERR(nsp);
+		nfp_err(cpp, "Failed to access the NSP: %d\n", err);
+		return err;
+	}
+
+	if (!nfp_nsp_has_read_media(nsp)) {
+		nfp_warn(cpp, "Reading media link modes not supported. Please update flash\n");
+		err = -EOPNOTSUPP;
+		goto exit_close_nsp;
+	}
+
+	err = nfp_nsp_read_media(nsp, ethm, sizeof(*ethm));
+	if (err)
+		nfp_err(cpp, "Reading link modes failed %d\n", err);
+
+exit_close_nsp:
+	nfp_nsp_close(nsp);
+	return err;
+}
-- 
2.30.2


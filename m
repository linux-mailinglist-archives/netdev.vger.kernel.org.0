Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B743F6E32EC
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 19:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbjDORgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 13:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbjDORgo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 13:36:44 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2045.outbound.protection.outlook.com [40.107.15.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC2D24EFE;
        Sat, 15 Apr 2023 10:36:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bu8umIQjjvwLIpmNbUKO4fRbBVSOwM9Gvf2MNyKe6sZCmIhxqUN/Tg3eI0l94izeGs701+GtrTsuePGYe/nPMM1X1XCtfRLLf0qqL34fQHQELdPcD8976pJf7aTeINfyVDmEAfJ4xgYWTOOa+LSx/ABvi+te7SREJt6R6EAR20NKU9EZywTdl3AnjdVzVj4t0cw9ym5JN20M9nFq5aD610kOtFryN2cmVyhZS8x1uHDPJbDbO8Gp/KHkr7a/VXMM82iQAUwiRkUFHmZND5H3cuCy94BZE4u1VmP7lTwbpbqtOdGQbQgH1omnrCfHlNz43F9d0a7BnLxWTTgmN/z4zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YqnotxNxZOo9YwZtR+TTEGTKUyCvcJSIimwo/xu5G80=;
 b=XcPr6pnCDrbFKJ9s4AQ18aruVkswhPlXEc637tkmU+DINmTF2TI0psLRP3QoS5QmUy9UFLnHQoUNIeHjtyOGFtNE5HV3tEj7hlMA0dP95bjI6sYHln3MoTq80iKomJMeMrcNpFG4ihdPcuHwIABRVcx9OTiktCG4iVUOTdNnHT3s50Dv3noMWZTqx2pGumP3+ERGuy8ks+AZ1MdSpbNJIXmLjnspvgeF97pR4mcQNXjd+QlC+TyWqn0xRvU6EPOOyDFWX1YMBoFTqwOGhPo2z9PNJfp2ksNJbxKi7IAL17clVyHJKBph+SN3TZZSa7AXLH7+TuysQ6H4G7MJDnh2Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YqnotxNxZOo9YwZtR+TTEGTKUyCvcJSIimwo/xu5G80=;
 b=BqbLK4uTFeqmxNfA4iiWEuWRVvfglDbe5rrvX6Li9oRNKCoahYiDDnR2dFCtHxoQR/+bojtdwZHhgh4FnTIChbhRUJUb6B9pDabKMp3WsHc057+xrKpzR3aR36SdUn1P2I0Fjc9S+/r0JYqpM3vSfp6yl6vDY5qpgQVRX83Bc9I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM9PR04MB8322.eurprd04.prod.outlook.com (2603:10a6:20b:3e3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Sat, 15 Apr
 2023 17:35:57 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Sat, 15 Apr 2023
 17:35:57 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/2] net: ethtool: mm: sanitize some UAPI configurations
Date:   Sat, 15 Apr 2023 20:34:54 +0300
Message-Id: <20230415173454.3970647-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230415173454.3970647-1-vladimir.oltean@nxp.com>
References: <20230415173454.3970647-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0156.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a2::17) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AM9PR04MB8322:EE_
X-MS-Office365-Filtering-Correlation-Id: d13484b8-864f-43ed-586a-08db3dd7df3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: moCyl5yxWfcQP6YfFQaHUkmKM1CPTYYNexJLb4r45iiC28if9tfUoVTnbkLwheDymfaBn5UMElQMB9VSlsgQ5P3heCtJJewfrXkl30zC/iMaHprSbk8m+KNL0et/RlD/MrR2gs7Nf1eyu3cxwX7hQv2MSX4yfeJ8Qt0s76+7FL3U5qRR/LmNtHPYh1tqhA293plLssqVA6wlckP0/vE9OcUnOAAjgWcGXYVsVAaOO6idrcg9ZGtNBesIS4Oi/viGliyG4mfZdNaOdPSPmYj5f2kXu9JqdH1aIWuJpUOM0JQEbgb1IgVgpv8QdbLbPhq/0R5e7g7/up/DVGR5v1jmhN1XaVDul6aBSq7fMp12S2qYZWMVK4REVWIFrx9GGs4nf9aEpsHq0H5M0Wu2H89G7y8VanUxnrCpcb0F3JB3JK7ZQxdW28gKsusRi4n8xGZ0uDOSNqHPHodW3xmzetieVZlZ2Ik1hPfBaMEHB+AZSbNHVFZ9VMYdrEV0e/QzEQQgEkcF8TaqInRCM2HA11D0e8v0cCIJk0Fv+HR3Sr/YytHiEe2E7YGJl8xN54v+oaz2Vb7VxbtiSBBGntYRfL6rS+UEPGzKTiTPm702K+DAzm8jaqLZHBtQqjqzZ+XaljAh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(346002)(396003)(366004)(39860400002)(451199021)(54906003)(478600001)(83380400001)(1076003)(2616005)(6506007)(38100700002)(186003)(36756003)(6512007)(26005)(38350700002)(86362001)(6486002)(6666004)(2906002)(41300700001)(66476007)(316002)(66556008)(66946007)(4326008)(6916009)(44832011)(8676002)(8936002)(52116002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Qw+2zvcqj2vEjfjaYOeGbt3E+omC/1wTdmTeDn+WTnCFXQqsiWUBlAYoQncv?=
 =?us-ascii?Q?bVVrxXoyDznVWCjj7zTe1UTfFMGCaDz14Q+c70hcNGm5G3qsunUJf/MqcBAv?=
 =?us-ascii?Q?v0XBwAc+h4ETfLfQFj0rb1tCn0xiSAkFHYklVQfq1GKkoT4NfCRsQ9dLmx0H?=
 =?us-ascii?Q?FUHQrnII6K+FFZt7dPS6gN6dk81FwYYKV+IeZsY3mPRIcmhWQnKgYaYBH7kr?=
 =?us-ascii?Q?xxR8DXNyDhm2Z3bm19JS7vXhMm+IfAPzs+yJkoMuv33qk9plgj21y1A6tKmO?=
 =?us-ascii?Q?J+HTZ4UKkvKHdwbMpIDpe8XF7F+d0OEpIKavE0xBX8URrVnjwQdZ4N9GxYfH?=
 =?us-ascii?Q?xFA733U5tfu/oD59DxFZjmuEZbZpi9mxvwocNEoZXSjN3OrQcJ8SltRoGOyB?=
 =?us-ascii?Q?ZSrjgLBOuFbBW30ZUblGHxdcN4VjS1QExJx/+y9dV1ZCy4JmbmmsoVqF3kSn?=
 =?us-ascii?Q?0p354UdvQLgtVLCmsCyPxs0fp6ESMx2VeWP9iNWEFu6mfZj0r2L4EJpGmNxg?=
 =?us-ascii?Q?8dMJrbsO0O/VLhuw/jFxBJF1qPp3K0cIyrgKDqhRjDYifNMnBSBmGVeLM54h?=
 =?us-ascii?Q?2rSxr4TphFu6idAGmEOf5AgxFvhk6uDvoccQO5+0CNF7Ypa0bLpqvQe7mlDG?=
 =?us-ascii?Q?fFWhH6iFv0TiFJ2ZN1wSImu3klnDFpS2bYIXsOnWsFDoWGXu1d0DvxEvwAxH?=
 =?us-ascii?Q?O+TovakTLvjT75GucTX2jXI06HXG6ta3H5jLcUuV1y6ZkMAVy+iu1hUpEoeX?=
 =?us-ascii?Q?qC5fmgvl4uxOwWvqmBQtZgHfS2arKughb33Gln8QZgpg9Nv/ddr5GlOenOTU?=
 =?us-ascii?Q?cKpA7gC1AO5Uc1nnT6Z+kAw/eMkSN5qwaAs5sdyf/ve/mJ7HihoDAs9R9V50?=
 =?us-ascii?Q?3sVqTxzLntNR2QQCYeL8IrJ9ES33LaL72xh033NeRwSg2IkT5h07wWouPlM1?=
 =?us-ascii?Q?Fq92UklVDjIHBLKWDBWuoBdohT9zzHet3tP2Kefi/obccYIwCFLCK5+wuCgi?=
 =?us-ascii?Q?EDRDfKcDuMQ41ZkWCb0FaIxd3v6rnrx4B33fzLVi00tXxdJutKRcH/yLpWTy?=
 =?us-ascii?Q?Hojd3B3hDzqWnMx8yuOZGcqPDYgiFeT3pBzFggM1EXa9613LHpc7XDfpEDZh?=
 =?us-ascii?Q?y1HcQrksp4ncu2zUU9LJiF5YKyAY7HYIfhenoj9bdc0TFeoBMcRUDAEJa+1A?=
 =?us-ascii?Q?qlFl4cWEnPdW5X11lRpuBZZ5pa3EvLDTJAh9WsOqutdv5aFJ5b5kOIHANX7C?=
 =?us-ascii?Q?iPMaaCthwWCRxpc4CKGmHG2iYSosw2DlM4a1O7nwAUrjFxgAtqZykgtDhPni?=
 =?us-ascii?Q?6uZoCtlGti2n+oEDTokAmqyi7BgLmtL+k5uS4qYQC56ictCW7ROcpGjZhF8K?=
 =?us-ascii?Q?vM0zF/HGu6bnYJdCw7i9pYmLJv3tgDDES8n/R/Ce9zuuogwZmgALFNOJ41XC?=
 =?us-ascii?Q?FjpmsOJGFNP2pWCcF76CcxRI/Vc/KuDAMU4tEHjIFrYuVARMHXjHt5YhE+zu?=
 =?us-ascii?Q?TnPRJ0s7aCEJ/t9/LsXrgfDiy7ma3HSIjOccH/hbfVCqa/D3el0oKKWkHHZC?=
 =?us-ascii?Q?sufvNVaoLg9Gmd9a3aaYICW/n6+KJZQxEW6O1tkrKcTb28mnlZXGxoIqxVSI?=
 =?us-ascii?Q?1w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d13484b8-864f-43ed-586a-08db3dd7df3e
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2023 17:35:57.7631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NTenl4cxetSBhhhyiDC3M2Kb1mZc6SNXJcV7S3ZtRjtX1dzghiMF9L6toLVcLyfHvRECu4hvIJgx1T8wyNUPkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8322
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The verify-enabled boolean (ETHTOOL_A_MM_VERIFY_ENABLED) was intended to
be a sub-setting of tx-enabled (ETHTOOL_A_MM_TX_ENABLED). IOW, MAC Merge
TX can be enabled with or without verification, but verification with TX
disabled makes no sense.

The pmac-enabled boolean (ETHTOOL_A_MM_PMAC_ENABLED) was intended to be
a global toggle from an API perspective, whereas tx-enabled just handles
the TX direction. IOW, the pMAC can be enabled with or without TX, but
it doesn't make sense to enable TX if the pMAC is not enabled.

Add two checks which sanitize and reject these invalid cases.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/ethtool/mm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ethtool/mm.c b/net/ethtool/mm.c
index e00d7d5cea7e..0eb81231f342 100644
--- a/net/ethtool/mm.c
+++ b/net/ethtool/mm.c
@@ -214,6 +214,11 @@ static int ethnl_set_mm(struct ethnl_req_info *req_info, struct genl_info *info)
 		return -ERANGE;
 	}
 
+	if (cfg.tx_enabled && !cfg.pmac_enabled) {
+		NL_SET_ERR_MSG(extack, "TX enabled requires pMAC enabled");
+		return -EINVAL;
+	}
+
 	ret = dev->ethtool_ops->set_mm(dev, &cfg, extack);
 	return ret < 0 ? ret : 1;
 }
-- 
2.34.1


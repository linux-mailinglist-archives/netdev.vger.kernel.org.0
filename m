Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68DE462DC84
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 14:21:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239932AbiKQNV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 08:21:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239931AbiKQNVW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 08:21:22 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2121.outbound.protection.outlook.com [40.107.223.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14A1959870
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 05:21:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hOsXlRk05nX1Gog9LI6hnukmDaA2Q5ZG7rg6jemkrR+frFe4HI70+A+evwZh9YTYP3aSy4TaDjkSDBKCbv38bq0pPnhVEH3iaaU0rEiU9VA0rDUT9nv20MESL3jhIYXNfbMeskhxWlrpiuNgm8p+aoiVMH8escrJMAL5jEbtwSTBfChthAStiATBOpWSiFTgNWC52WA9omcWbl8reSRv93W4gRdF7Xc55g+IUZhD7z5KzHuhJqxXGj+mLvBzC7rvvvaYe42/cb6eDJFi6XRHRC4uLaHZxKqV9x8s7bHSGcovBU5qyMzQuWXfh9eLmM+GgZ12UnMBOczp/PrRNxuRYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xsIVr38qDYKrJk+1YYESOS511KfkmaA5FCpPgJUQutg=;
 b=LZ4NPNCmBIRpsavBM5vz+SM7//dZiXwFsRNqi1wSLB5GNZPNRJVrxLoYTSBSL/Dux7IsJGRhRu8adcIq/jWkFnfpSSK6aL4B5DDjVyM0ulYG2/S3wJjyBCE3qoDrrVkeVTQqGwkP/3sAlntJ+1UNg7YeFWJIZPSCLVyW0XR2WkVgOHACfcxr3DdEf2io405ByHzWc1E3KE9UrvTQ7tADifd3MqgaHQ+3IGAV2OE1zSEU1SZVVmF1+nCn8/VZpGZ0mGx+X7TXSVD1Jl+g7ahL+627hjskwhDMoPIDUXJx2LbJfjRkfTVxtH63tQx3WgZc6IZOip4wIPcyUpEm2sptOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xsIVr38qDYKrJk+1YYESOS511KfkmaA5FCpPgJUQutg=;
 b=oFgKeRJyU+0I6rsKvZS62tBWKjMt+eT59Kst6MiMakMblEVk7ynyTryf3FU/34c4SSJvM1wCEUrRIB880d7+qdqcQzdycusFRPIaVmcPM5xEp27aatFWt56YkTPqGaKY3+XNPJFbu1ULWx9vnqKlHv6heSJsByZ4U1jtX90J6/U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB3792.namprd13.prod.outlook.com (2603:10b6:208:1e8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.18; Thu, 17 Nov
 2022 13:21:19 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30%8]) with mapi id 15.20.5813.018; Thu, 17 Nov 2022
 13:21:19 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Leon Romanovsky <leon@kernel.org>,
        Chentian Liu <chengtian.liu@corigine.com>,
        Huanhuan Wang <huanhuan.wang@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Louis Peens <louis.peens@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com
Subject: [PATCH net-next v4 0/3] nfp: IPsec offload support
Date:   Thu, 17 Nov 2022 14:20:59 +0100
Message-Id: <20221117132102.678708-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0101.eurprd03.prod.outlook.com
 (2603:10a6:208:69::42) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB3792:EE_
X-MS-Office365-Filtering-Correlation-Id: 91c9529f-16b0-45d4-441c-08dac89e9cc4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P58mQx7OA4jZt+/mbRKQ7nuR1wGGEywOSxEzB8dg1+93zXtdwh7pGNEv35xICtqVU6xEsS+tqjH3q+zdVU3iEa0IsLtRftDvzl+Ouc05i5axPCJu91oULykz1vKZMv4AuE4ZTJNvprVWSMsT64zAn3T9fSVy5Xx1FPnPS3r9+W/xASCcoCjfhZ2BB72X2ys0kFJyzfZAbGYnYwUn1Ecl3isG63ooHk+AzkPT7WF4NSBONLUtFoQ+rv7KH2DJjY1rp9/EZy04TrIImw+THqZwOLhDnVXaOybOlo4mZe96xQ88GCD7hhzx6XJJGqOQAGikSGlnXMm4hXaLf3MDW3iBvWv2V4L2mawrNQymAU9/GKQhMriEQUHLSF2sIOXg5P0qkdqW3FzOdpuD+Nek0rDcnngjRNmhmQWJUH0FSj/P4SJSsmrw6lYGZoXygy5ReYO2ENyRDPz5kQOQa10XKsY/yPRCLY5+m7udAdyHv2JapwFidfabBNkbLobElVBp7tx8aCaGii1qbDoVEQo/td2JtKqv98KdTxwNYFtv74Ww5/vbUJ9eD2AJi1r+KJ54jIiFtDxYLwc7qLs9fSlz0AI0YG4BBt2m38V9u7Q/KJdFHLqzhwdKAYa8ZUylDA5PPDMLa7uFIjnyAgGAUD54ABUd8Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(346002)(39840400004)(136003)(366004)(451199015)(44832011)(2906002)(5660300002)(41300700001)(8676002)(66476007)(66556008)(316002)(66946007)(54906003)(6486002)(110136005)(4326008)(6506007)(6666004)(107886003)(86362001)(478600001)(2616005)(83380400001)(186003)(6512007)(52116002)(1076003)(8936002)(38100700002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f9xe/59xYX6HN2U6KHaMWjcYAPqnTL1VCL/rJTuOEtO57Pt9xdEZX27yzgP0?=
 =?us-ascii?Q?dPx3z2lrfHUPySdmwUCukR+dnyFq8Mirqm2hDAdwADFKnUMLKZOXJ2YMKYBs?=
 =?us-ascii?Q?2icMunndKhl0f6n26qWYWEgFLxzHM6BJvxTI4pDG5Pl1CHC55ZCFy/tozKB+?=
 =?us-ascii?Q?23ezYLKJwGH1nWeGONI+A+w/mJnG54Jyputi++imYSWYS7MXrBKQfNzMW+oL?=
 =?us-ascii?Q?dHZXMDR5GPdAEjkyWjFORqshEnEywEFAtGlAx66ty6XwrnDhyVFhp0yhmCNl?=
 =?us-ascii?Q?NjUnllm073ulmaMMpW3OKuRsmfRKWmWluvgDcFiCaS5PtxXyWdxdnLfwsCgx?=
 =?us-ascii?Q?9c7MuWaBXyLV+BHccoqoDHTj1acUt0WuiYDFKVraJbL37FBhdAyq3CJ6/L4P?=
 =?us-ascii?Q?PujYNku+YjgBncoY7JeCpAAgWUTvUXXsmR2d7rwlzeUwP+4bkCFrXxy62Kb0?=
 =?us-ascii?Q?ujAAKyx3TfRYA6aFwyT25CM9G033LD8mu4i/LREZjfcBaaGeY4Zod8QhQ2iX?=
 =?us-ascii?Q?OJK14zx0a7ZSrpQanFb8xXzIYT299SWYlDxO5OiL9sqeadPbUhPVt6PftSaA?=
 =?us-ascii?Q?CNdHVefsB4mnkMaEpiKL8k9dIudrUY//nyT9ryorh3XeW2YcjTlwNc+Z638N?=
 =?us-ascii?Q?8NaY2Gnb6nf2LK44q79+qQLb1T29OEQwC0gg82sWjZR51bntvsBROzZRpENQ?=
 =?us-ascii?Q?XOuyjimA6xNMkB4VaANeTn1m8qnaY2mnkLtbec16UmB+qRE/jjVyodDdmlPV?=
 =?us-ascii?Q?H0LApieR/xQxNDs75RKyp3omyyVUcUgwUlDFGo899KicJhM+OPBRTTd8NayI?=
 =?us-ascii?Q?AFl4G8nqMbq92B7bIgVjW3nt/gu2fcDNimyxCNsMlY0JYmoLOJELpp1NYYlT?=
 =?us-ascii?Q?WdHGJZ7mKPZtneGG3XAkUp/OtANK33jw7v/DQUYui2DIiUvoXzByNMtxY0g+?=
 =?us-ascii?Q?xf+uFj3tLSbz6A7C5hl0JFQJLR6nG/H6fgKyG33OlL1sFhXDRiYEnIwCYypC?=
 =?us-ascii?Q?V5Kf4/RYqJ15HMP2M34AWZy2lUj96RUOZPJa0G5+hoVNE1BhK/z08AA8FEW3?=
 =?us-ascii?Q?KcAg4U0rCyvuBntm4QiRi5by1x3sF8NOmRNBZyUe5Pr9iCiZBVfAJJC5aFYC?=
 =?us-ascii?Q?wYgXB989qPThAhmuiVjc4Mk5pVz+FRUnWiVvSqkwi+AIwFaW7EgRe9bT12mm?=
 =?us-ascii?Q?q2P1RqBUjOyHXUKNmofAJfPPCESqkfR+EkoX3Hc/l3XwuDhV6AqdH0ICkaU4?=
 =?us-ascii?Q?NRXR9jqNvk09JpX3czvyyNRz8hQ1ZjH0XNSkc5Re3w7WhXv4WOGVOd+rcV2D?=
 =?us-ascii?Q?H9MVnAY+hUkfNUKDYLGtJTGUwl6ztsv6FcZ4vWx6Nud5xZs6e0Pls/KVVQ6/?=
 =?us-ascii?Q?H9LMaPDPuQpjFKczDo8QkD/MT8k5oGwts8y9jVDdkSWlPT9TnQkxxcXDr1uQ?=
 =?us-ascii?Q?bgkFa6dkrs/y7MSCmXuRx6fcvXpVFhG4qw9NijaiMdBvtuy+eSmCkQzF8FBu?=
 =?us-ascii?Q?eK+C0M4c+4/04MVrE8Trl3QAfK4oFSPsNJylGWCQH4vMv4nypznxg0MroIHb?=
 =?us-ascii?Q?p3G6v+ZubSw6OqTBmAKoda6fHshiRWGZTwaFD3QDbNRXddTTM8m6HmkdzK5R?=
 =?us-ascii?Q?2isC95WKZkRLhrG+ZFO/eyFD8LiTbwSX+1wnaTLrB/90MmF7H+WSJvAy+GJQ?=
 =?us-ascii?Q?eOdMfQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91c9529f-16b0-45d4-441c-08dac89e9cc4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2022 13:21:18.8228
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VT/nj7y5egBh8T6SQFX/Zi3tZExUI4luEH7BmPodHQ1tQ41MnkD44xyWxP8yFwBXk6hutLXiKlXqD6RxdQyNps1tS/Z/34b3NUnUHU2Ts9w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3792
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Huanhuan Wang says:

this series adds support for IPsec offload to the NFP driver.

It covers three enhancements:

1. Patches 1/3:
   - Extend the capability word and control word to to support
     new features.

2. Patch 2/3:
   - Add framework to support IPsec offloading for NFP driver,
     but IPsec offload control plane interface xfrm callbacks which
     interact with upper layer are not implemented in this patch.

3. Patch 3/3:
   - IPsec control plane interface xfrm callbacks are implemented
     in this patch.

Changes since v3
* Remove structure fields that describe firmware but
  are not used for Kernel offload
* Add WARN_ON(!xa_empty()) before call to xa_destroy()
* Added helpers for hash methods

Changes since v2
* OFFLOAD_HANDLE_ERROR macro and the associated code removed
* Unnecessary logging removed
* Hook function xdo_dev_state_free in struct xfrmdev_ops removed
* Use Xarray to maintain SA entries

Changes since v1
* Explicitly return failure when XFRM_STATE_ESN is set
* Fix the issue that AEAD algorithm is not correctly offloaded

Huanhuan Wang (2):
  nfp: add framework to support ipsec offloading
  nfp: implement xfrm callbacks and expose ipsec offload feature to
    upper layer

Yinjun Zhang (1):
  nfp: extend capability and control words

 drivers/net/ethernet/netronome/Kconfig        |  11 +
 drivers/net/ethernet/netronome/nfp/Makefile   |   2 +
 .../ethernet/netronome/nfp/crypto/crypto.h    |  23 +
 .../net/ethernet/netronome/nfp/crypto/ipsec.c | 587 ++++++++++++++++++
 drivers/net/ethernet/netronome/nfp/nfd3/dp.c  |  58 +-
 .../net/ethernet/netronome/nfp/nfd3/ipsec.c   |  18 +
 .../net/ethernet/netronome/nfp/nfd3/nfd3.h    |   8 +
 drivers/net/ethernet/netronome/nfp/nfp_net.h  |  11 +
 .../ethernet/netronome/nfp/nfp_net_common.c   |  10 +
 .../net/ethernet/netronome/nfp/nfp_net_ctrl.h |  22 +-
 10 files changed, 735 insertions(+), 15 deletions(-)
 create mode 100644 drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfd3/ipsec.c

-- 
2.30.2


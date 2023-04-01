Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 916CD6D2F3C
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 11:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbjDAJMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 05:12:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjDAJMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 05:12:50 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D891DFB1;
        Sat,  1 Apr 2023 02:12:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C1DMbEXNZiiLoEK19Z44wiIBV5l1rgr5EatUCCVlR7oN/0pp8ty5uzmmJuY9AIEyML1vm19Het4VuTdKq+4eW4K7tQsr4NnKLEvKvPuBzDjWmkUYoV89UaB1az8GESd9ebJm8hOSHbIDL/qSSmf+Oh6Ui/pf/biHgrOecdG8yv/AYTWLAp34mLaxK2rBcC6y4e+YYdcSG7tbD45mHCQPcSs4bGiyN/M7VPvp1d89Uf6OGtx3/xoUhdsN52Xm2xkzbOFMqjcfCmGkcNuue+tNReSpIYTXAvBtYBdziBnuWJbUpsWBC31wIUqIwrafvLpBw/kH8y7kIKspZEIVqbi5tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jl6Tsr+xsRKDvBZ+ctbDENHXgzggvKnaOXcQzsNrg2Y=;
 b=ABf9v0sUl4RE0A5GXvbh3e6HRjwAN25SUUnPn4Bc0TRIfE+azj93Cb0ersLjRjQGTIJmvZo6c6199A0JiCfpTGxvgOppA01iJCPgMz9lgPHX6avj+cpAU8cvhKpMxF23nCUEXd5f6DNRl0/wuOa6zi7XC7dyMeOUWc2XWv5dF4rBTHcnIjgG4dcnhM9xJuaJ/yl5OBtZq2FyFJyjyNTIVJ6/mmZPekb/nwElqH1EDMKRB6q6Sr7pZcI73qhf9dCqO5TSPhRmUTbL2JANKOHKzhpYJOyKP06h6K2AOACQd02aKz2LqHYtzdXTWGow0RDoxEUFXxMygL4d/s1/A7slyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jl6Tsr+xsRKDvBZ+ctbDENHXgzggvKnaOXcQzsNrg2Y=;
 b=bxdEfNiHJgoukTyLl6/KeWPDAukBq2+v2xzPfgBvM3PWUIJ83+Hec1Tjd6457S//ARYoFvAi8j0S0YFZIz0hQsYzY4vCrohV62RY6jvMYy+fkoxcakPzK5U37TqdHzG5BAwh6T0PXAg9VsMtGDrK5Zxe1zZub5VZltxDW5AazW4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN0PR13MB4680.namprd13.prod.outlook.com (2603:10b6:408:12e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.35; Sat, 1 Apr
 2023 09:12:42 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.021; Sat, 1 Apr 2023
 09:12:42 +0000
Date:   Sat, 1 Apr 2023 11:12:36 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Tom Rix <trix@redhat.com>
Cc:     jes@trained-monkey.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, nathan@kernel.org,
        ndesaulniers@google.com, linux-acenic@sunsite.dk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
Subject: Re: [PATCH] net: alteon: remove unused len variable
Message-ID: <ZCf1hHTu5AzcH1gU@corigine.com>
References: <20230331205545.1863496-1-trix@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230331205545.1863496-1-trix@redhat.com>
X-ClientProxiedBy: AM3PR05CA0150.eurprd05.prod.outlook.com
 (2603:10a6:207:3::28) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BN0PR13MB4680:EE_
X-MS-Office365-Filtering-Correlation-Id: 43094787-c495-4791-89ad-08db32913fcf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z9uHqSvJF7Zhisvq6cRX21JNAXJqcn3H8XiOrTvWym8m7K3caA3GjJXvOV/GzA0wQzxYPOIvETvjTNyDkMsOXr/qe3TXlnjIJYWx/X0+OMtbtvnQCIF83hV2BazdmQ8cshzS4KQbPgt0s5jal+mLI6/ePROv5SgMPbFsO1UXFOglzvwxoS9aHB14maGyRQ+FVV1kgHBxt+exC7m6rWoMYp/R0aKheyBsVKOin2FRtcRqnAPXubWtdMcS9ERPLKpMh2JEGNXZTL9eDcuRXpf9guZkbTc8+vQcL20oL7EcIMQCsRBhy8rc0fUNDPrfQACOLvCcZlbxYxHGEOpdmPxm0gymg4tgFDK58J2d5psTqfgSIRqyCw+W9ADLIxomaHy2lhrhqEFPJJaPudW84s2QHUUZv7o2LHen9pDFuK5qIzejg93FoK5r+dnBOgydpp2f/xG5dU+tkJhDKrumKIGtZ7CKUdQxXHp8pZnqmoOP3P+0YYxe0yl/K/u1w27rI//Ej3wMKQvV5XdFJplWmuvtIaWlPTdazh/2sXquE+ddgnDvTEACvBFgXDYrcll5cJ9v
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(366004)(396003)(376002)(39840400004)(451199021)(2906002)(4744005)(66476007)(2616005)(5660300002)(44832011)(6916009)(7416002)(6666004)(186003)(41300700001)(36756003)(66946007)(316002)(66556008)(6486002)(8676002)(4326008)(478600001)(8936002)(86362001)(6506007)(6512007)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ziqb4j6LkjzfgWoTvsiJEroXacUctJ6Wi/I6qTbNw+MF4cy0IIfvAWFyZyr1?=
 =?us-ascii?Q?AqoDgWUt+BnMDVsAeSY/X0RtIGMlRpNK92ZN476+Qty725R6jP02ZpnaYwMs?=
 =?us-ascii?Q?K/LWPYW76KV5kQUkGry380/Q2opcFWwj8O5oBmhGkPI5k+f5xz5ogaxODfK8?=
 =?us-ascii?Q?cVFYJHpQSvM9+b+8dt/TvCphMfVg05x3bbSQNiH+Uo/g0ESwK6LJn+nMSVcS?=
 =?us-ascii?Q?uqHfjoHDkh24Q46N5wxCas4Bq3Wmde3ys9IkPyNlds3o5IF2FDb1vxcJE7qF?=
 =?us-ascii?Q?OyNPlviry5CaK2VQJgyoF4zVyV9uDRJ+KNmHOnby0U0eAQsZUy3akGekGG3P?=
 =?us-ascii?Q?jbqBBb6KnSAhoHRscsr72ZoT1bYMUfeVoU4gQh9l8c35bUAn8gLhiaYWGP6s?=
 =?us-ascii?Q?NAWKILqxm0nSGGsNHU6VBoiryVp/YJklQxdOoFVq0VT9z4exVK2t+JtyRatg?=
 =?us-ascii?Q?Vs7+vih6jJN4jtA23z6K2zb5LcRzOrIUlAmMME0QYpoBYY8MJy+mFiuSuz1G?=
 =?us-ascii?Q?NFGMNu+pwjro0ZiBORnoN8WpiTR0NC1y4NVe43ItbCaRwgvujLFd0tUiLdKX?=
 =?us-ascii?Q?4BouUpCCpt1tj8qPvHNqniHWqV/l7VQexsS2lFy2ErOFiPfRkTDAva3mPfzd?=
 =?us-ascii?Q?bhRdWu6H7zOLxjfyDOT2UtH8mLVCjjrePBnvURFVOMHln76HHGaoMRyWk8q0?=
 =?us-ascii?Q?aTZzCazDIO4ezpG6KgafJW0xHxR76l6xZc00e0HSCkrkPmyzXWIfbofpUEyz?=
 =?us-ascii?Q?dJ2Zu1i81ppiHpFhONBkg8nXOJv/VaoBslExuAxQUUw293a9K15DgllJYPq+?=
 =?us-ascii?Q?KCkYA6eZhfkXyUl7XKBEPJ257Djvl+XYeLClaOrDDaQuY+rla3UdQOKa4btj?=
 =?us-ascii?Q?ZtjX9Bwb3DaJlwLa17739XRpsvJvAkIw2CxhS98nnm7d5BLg4y24dxZ2WdFI?=
 =?us-ascii?Q?rqFqyTFZ4O7lkPFoRI+NLIBNdeOeBTsnE3DQuJuO0HJXPbAWtXfRDTfV5sTk?=
 =?us-ascii?Q?Gy+lXB5D8tCXI9TXgzOEQpofMPrTjV93InfxheBVGGNhDm9109Pr8ZyoaVgn?=
 =?us-ascii?Q?S9nKInUy6atkAkj6ne2WG0yMN1hgENvpIopzDcImkvnLYBdA6xsrsMwZYdox?=
 =?us-ascii?Q?idiZ+lkBwKFgOiVz0UgyO7ZAXcR0J4i82IrSY8n70VUye4CGeXZ8MYwZkCec?=
 =?us-ascii?Q?ffBCYWf7hXaOXsii9oCOzqhbcc9RkMN6yR7U+Rj/ak2yUBIPIcNwg6lt0yY6?=
 =?us-ascii?Q?363/UzSjHNxPvhJEAW3MWlwrbn5Gc+QRYNT6CbkK3+dE7MHImTaG/3rQ7JR8?=
 =?us-ascii?Q?gN77JpIFf3AJhUQ8/sVKbOExXzN08bEsqtRkdxh4VKSpVZDqKuaRaWbEM+cD?=
 =?us-ascii?Q?F4Cb2rG05zclD9ZQwfUguNx2PxCk93ProSmQQULrxCuhvT8JCv0fPX6Eq0NZ?=
 =?us-ascii?Q?IF18jaw5eXcvYTAXd5hTSuNstAAG1jiljmbDSevYd2o9Krw9mQd8vasmEnk0?=
 =?us-ascii?Q?1onWdaq+s7obTuzW47WwyqN6A0EmhFfRCcGAOobfrq/ACgosy0x5fm3wv5QT?=
 =?us-ascii?Q?bnM08n4kPgRcmAU1cmJL1GrN4hpISq/M2V2ByN9kuAU/fNAthteOiWoMWnHC?=
 =?us-ascii?Q?60pzJ+voqlbg5FT8HEjRTxVXCkkMkDNbMkxfzzgrSHKkdvzp5bIEv7Hg3oHA?=
 =?us-ascii?Q?So4J+Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43094787-c495-4791-89ad-08db32913fcf
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2023 09:12:42.6859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aOUn9BbRuPl+tDLiUv7kUWbw1p39AXU8UEalHukF/46TN0cEnZWO7HSqrodC3D4SsI7vso//HuUcOAQsUZzpMEYwKoJeDhDsuUTEFhs7exs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB4680
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 04:55:45PM -0400, Tom Rix wrote:
> clang with W=1 reports
> drivers/net/ethernet/alteon/acenic.c:2438:10: error: variable
>   'len' set but not used [-Werror,-Wunused-but-set-variable]
>                 int i, len = 0;
>                        ^
> This variable is not used so remove it.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

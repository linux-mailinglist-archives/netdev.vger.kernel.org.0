Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCC736E4A07
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 15:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbjDQNg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 09:36:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbjDQNgU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 09:36:20 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2132.outbound.protection.outlook.com [40.107.95.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AF7A76B9
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 06:36:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NSvUfJLjKN+qoqo7Twh+sciJz0vPBRDn9/AUDvx/6Dw11fV4NrvwSKpjfeVOTsQotzWtijdSl39UhdfPpNyrCjQvMhsv5Zb3yA3qR12rxvExPU8rsGkWxPNSCJaywBAg2gM6QgqAkrIRyHCca9Yw4H7BYeD4ayJboOKlKNmKxA1bMKOll+iwpmbs+GLEvWF/6t/EJdAz2s/NTN6/6in0YxdtTYjl+5PFBlolLEzFGnMYtKWwFn570QcURuQ1SdUxTDBLZ8WKH+xHNAxfUUOek9qRlynWPLAwYYi3FCJXnWD2wTXpeAGBQixlQtJ7Pe4HJAd1D6TfT3hwvHO4RqWFKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ATznCxu8FretKWQb6sYlWfi4WyZGJZTRyPWHbW4yefI=;
 b=KkglTLumK+8UFvlui04kcycm2MfvVzgNr7/CY8PO/CHV+vpiiIjRqH+nW27iOMy4gqdZwyA8OnwcfVr+96nPFeog8poOhYsigRPIscDRC+ltt9UPgbDYuLVyLY+bNYG2Vzw/8ukM/OEv46z4iauQctWuIe/jjr6kIorqKqez1f8kde/bKg98N1Sb39J3V8TZnvPztY/SlVEoU/IeqJf8D2QScgEK6vfEycI2YZZrdHOA6oKVz+7CFwKEV2ev663Hv68rQ0+4obyImsyqUz1CdY2FM137H30tCWu7c6Sz39GFBBS2K8JlVbIr1CycMZJjmBhO9FNd9fvqIlf3+aeKuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ATznCxu8FretKWQb6sYlWfi4WyZGJZTRyPWHbW4yefI=;
 b=KFGmnPt59gIJtQbRLj9IUOBs3XobZCqftpq6YzRR+vV/FaaIPsgWfHTViN6InWYcf+9DhFyDUJgzpo1twuMVkvBsW9v+tikLeOBLlLhPC4riQxz7NHWsp8tiperCUBPYcpRutC+m6B1rZbLG1FKvUYtQqZsKUhc03QFLUrcq7AU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM4PR13MB5857.namprd13.prod.outlook.com (2603:10b6:8:44::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6298.30; Mon, 17 Apr 2023 13:36:12 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6298.045; Mon, 17 Apr 2023
 13:36:12 +0000
Date:   Mon, 17 Apr 2023 15:36:06 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Emeel Hakim <ehakim@nvidia.com>
Subject: Re: [PATCH net-next v1 10/10] net/mlx5e: Accept tunnel mode for
 IPsec packet offload
Message-ID: <ZD1LRjz5SOuHuOFl@corigine.com>
References: <cover.1681388425.git.leonro@nvidia.com>
 <03b551b18ed893d574c566204373499817e345ff.1681388425.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03b551b18ed893d574c566204373499817e345ff.1681388425.git.leonro@nvidia.com>
X-ClientProxiedBy: AM0PR04CA0087.eurprd04.prod.outlook.com
 (2603:10a6:208:be::28) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM4PR13MB5857:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d847138-9c98-4f14-6e3b-08db3f48b5dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zdzDfrVA7ZPEUnqjp3ma7jcb7QEeG8YyGwd1ZiydGqbTeCyvcw2YSR2W7/KrWNh8h3zgAiT/eLRHNlpQncdaYF3yuV+Z6cYGDqahmQ8l3Nz0xJp/bJbLhbCUjoYpcjaUffc0sP1lvmsv5uhZOR1RiAeY25wumX+o39OjzAjM/T4nMlgcz7Pfnl435pJprwj5QYyrgLMQ4So/Bs+CqUGgNeOaTdjTE192SPnPCH5rUl3Qlh+Qwzi7f8CZTe8dXMvaNBRy83rG+C8mBW+DIigu77gLhYX1YOeZAVJ1GWUyZR1qVIMLUJMyYFevnmlqPnwyPanovmyeOpklrhSjulN50VHIeIJpQ/d0DHEkP2LhDOQaFIYzSGqpjcrEBAnytap4wIm1L4m34zNoDz/P8VnYkJOl3eJBH3/8QBaC7NXqbgYp74I6s9/3KWad4D8LNX+cfsFVTs8eBTKNVqwPXbTCY3VizrHSUcIKKRB+zfwz85CxbmIuMaCBqdMsfS7b1+G9iSIhvDF1AB4Q1dc603kJA646VYNNAcoxVyhKZ22jj6bdq3DGZMDM9iau3vdoiyha
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(346002)(136003)(366004)(39840400004)(451199021)(5660300002)(6486002)(6916009)(66476007)(66556008)(2906002)(4326008)(66946007)(36756003)(558084003)(44832011)(7416002)(86362001)(8936002)(38100700002)(41300700001)(478600001)(6666004)(8676002)(316002)(54906003)(6506007)(6512007)(2616005)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PCu3KpZfdAI23bCgcGFSp6DcCCouTWLWq9eTLM7Pt9MudFDWADvcMR17PLYk?=
 =?us-ascii?Q?vOiSB2D3gRpm2Fx6X5rpZ+2wGDgbg8nWpq6cibBnooIAgayIMtbiKY0GMxVK?=
 =?us-ascii?Q?EROamo+a0SlnJK0x6Z5psQhm7CvHBSmFxUFiwI/ZGtUaoLaFUyESB833xttg?=
 =?us-ascii?Q?OirME8sby02UtwvylnG4Tji4jh9KFAz38ep0+ReOvciKI9aHM1qsBUjrMg9g?=
 =?us-ascii?Q?yKrzTPEqT1qPwWGoCVPi6hhl0ZsWf8bYRXOn5oFqCcZ59ZtsWdxQ6xZfOE7o?=
 =?us-ascii?Q?03KuG3uleYet0+k6zTnLLwQUsMGqvioN29rl1GD+I0LEnnFBAwraUAEAAfqw?=
 =?us-ascii?Q?lQI3/RR463Y9DRvM5gK+YN2QZocQXQm15WvAaM9vCAkpiWfTVzkRDSf8H2OJ?=
 =?us-ascii?Q?MfiL+xGV1QkgtcPeXp2J3OK/O8K/hlT0LC9vyJO9Mlu2pXm0lV/kVJrbuHEp?=
 =?us-ascii?Q?jYesaKHitEcCzEPpO3pzq+iE2vn8Shn221yWiI3ZG4btrOci5VZ/Gjaz6g62?=
 =?us-ascii?Q?HR9b9Y1tWnF4ajZD3cOuPaHeOl8GR3wM/zyiAeHsowjZeDBQzNAIkIrFpoV8?=
 =?us-ascii?Q?rspw1YWWvc+bcJa74u5zeMYqqRyAN1+t0PeadnwmESoKkYNetP/tpjGdYMLj?=
 =?us-ascii?Q?nbL+tTsM+ZXSdALxTjbX+oycrJ014O+2LvW9gzJyT5hIigHWRYBAo/zN2Ihn?=
 =?us-ascii?Q?8OyTMTC01YcS7bcNKHp5yuVr+f8vF+j8L6/7nHQ2TIFbZtAyJWt8TBiCjP9A?=
 =?us-ascii?Q?DHIRhtlo6H2/mTfhmfmca/XRp8wuRaNQmKVh3Q9nJCRS63+xLF0o6CVgFIMZ?=
 =?us-ascii?Q?vOEAwGFhWTBbpPHdbA71EBLHKpf9L8tUpDku9RTXNZEfR9VDEyPL5J9pG27a?=
 =?us-ascii?Q?/Nogi+7ZWPVNUqlIf4U1b+OLN/aA9+Ct9t2v6edxwrfytbU6UEu/X4Uqvj2n?=
 =?us-ascii?Q?2nPG5WzrFwIWiIj7mSqzMAGNq0Mpno/99DyEMHyVuaW9+0nmc3eXbAN3qdxm?=
 =?us-ascii?Q?rg51T1EQYZpsVPsFOY+kbzgxzhV1egpaB+nsLibPtDew9gj6NMxPv5bBTTGT?=
 =?us-ascii?Q?TDx7yK3jGYbEGmP0ToqJ9MkqPukhuZPhJehOq2T/y0VqEXcK1PBTt/omXgt/?=
 =?us-ascii?Q?B7PKLjAG/X37o4XxcZUvnEBN+iReq83B4yeQCfvBMYTt52R1zapUsW3Qp+Oy?=
 =?us-ascii?Q?oVsk8oH00oTGHq6H+uhaJqEXVpiXnaq7Ex0BylOAs0/mDfUAZaYpS1ngp135?=
 =?us-ascii?Q?r62QO4+Tn0RiXpQW8tgGHYidgGefZlByBr5rohOVEb3xi7w7SxGO/McfPmeP?=
 =?us-ascii?Q?ac2yN6pdp12n/m6P4XrsuYW9NzE33BK529iJB32Jw0smQYZWIhLhbQJEopXM?=
 =?us-ascii?Q?WqJLNdJ7XDpHibn8Uz9rgLJ6N/RkHM317k5wTs9mlaXLPGqj9+onk+EmBMpw?=
 =?us-ascii?Q?tTk0kaclLrSVIviCqjI9JjAX/niRn5jFgVxf9gqdHFFUn9wTGTtfWEUvF/cl?=
 =?us-ascii?Q?yh0G6dRvniSq2g1Y2X+Co15g5r+2+yjw75e5rDslyU7NocS3lM9kIyf11F4O?=
 =?us-ascii?Q?pTHM4wpnKzaDOFg4CPCDSvCBQ9IBknZ9Q6ABOCxdzvZzNlpi0Eeiofy/htnl?=
 =?us-ascii?Q?wnZDcu50RiVg4UGhnuEv+c+j0J15gSSYhKwZz+Si4ADPs18DcfHhppI3yjTn?=
 =?us-ascii?Q?o3YFCw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d847138-9c98-4f14-6e3b-08db3f48b5dd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 13:36:12.5729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xh/htoioqHnf8CCsTY5eqz/IdZFDzCGCI/JhMvY/+WHA4497C04/ckYdMd3dwlcy5OMzvtcXjULHbl5kdwhsI22vZCUhcd2iqJjj9UgG8xk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR13MB5857
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 13, 2023 at 03:29:28PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Open mlx5 driver to accept IPsec tunnel mode.
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


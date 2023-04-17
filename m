Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98ABC6E497F
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 15:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbjDQNLq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 09:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbjDQNLb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 09:11:31 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2070f.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8a::70f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EFA6BB88
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 06:10:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J1gBR/uqHCXrrBReyxyUH8oMEGogHt3ilFIRRaUiXKFREZMWxD1uvDMD1pT5F5h1c79oOr/jey+dWBymYq+gzm7H7riuxraXRlWpAnZZD5tHHrtfK5/arVFuiBoeTx7rVuuOO9irvCJ+N2yHz1kKzPKvHxnnjISSFt7vSjZSPlkwcGuQt1ED5RkhDEE+QlWrwgfZBJe1niznNLY3WNfWGBSJGxMvIhdG1PrLmKVqb0+yb573sN8r8IMzx3aqdld7s+Km2k+6aLNiL73xxBhsyJ+iJZFdqRSc02bkboNO/LvZnePbcrkmSU1tsNt+olJvFUK85u8Y0PXXJAjdlgWJiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o9jRo7LMXF//xValNw3mxgKSg4ni/bFjrBClh5+xS0E=;
 b=n33k/Zo8kqf5GVzTpzLFIQlixc1EfO9Emmh19ueWDBKPZdZ9q61HjiqR+0Z8AYdC9NIt4BTmSdS3sMfN26u2JALSZ+k0MavzvFg5iiT0lGgf4UbPHrM6YtTXpNEDroUEUPV5KYmGh0ygQGgPN2pP/abwo11KgLzH5yxcHVX8rmi20T8OMuTC0HUtbjkW/yMcSK996Gt70+h1Xkcw+8CvG/KBGguPNX5VGwJIktnoYMNdhaIP6aKQyNP/m6tbnmgpcK4mPjhI51JzweErVw1NCBqukKyxpsqo8wnQUE2pH2ombUGqRen6N+6mQNt3qhzW3Y/eG5GY4FN6nvlhzBTVBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o9jRo7LMXF//xValNw3mxgKSg4ni/bFjrBClh5+xS0E=;
 b=tjNqm5mtoRfpl8rHaZFZ2G2AjxGD9xH0P3nUS3Zhuun+AQaB0Dx8XQTOZhsO2aZHDQwdxdRHsyEn/2FSekp3lT3/vGMKwN0aNjwC3p73bE5OkKP56YR8GMijNbOn4ec0WWezrQ5wzWhf+O9J5e1e7Y8hmf5Bfo8KjsaB1MmRmps=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3781.namprd13.prod.outlook.com (2603:10b6:610:9a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Mon, 17 Apr
 2023 13:10:33 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6298.045; Mon, 17 Apr 2023
 13:10:33 +0000
Date:   Mon, 17 Apr 2023 15:10:11 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Emeel Hakim <ehakim@nvidia.com>
Subject: Re: [PATCH net-next v1 00/10] Support tunnel mode in mlx5 IPsec
 packet offload
Message-ID: <ZD1FM0g+KWo5GtlA@corigine.com>
References: <cover.1681388425.git.leonro@nvidia.com>
 <20230416210519.1c91c559@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230416210519.1c91c559@kernel.org>
X-ClientProxiedBy: AS4P251CA0002.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d2::8) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3781:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b47d691-3e81-49d4-e8d7-08db3f452084
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: djYdUUK0ZeaCeb5ppDjHkk9fA31197dJWSwtVxgL3T9Y8bao6D7P/notuekG+vKjusZtAA9zBVyDaTsYbW1ji17fWzC75ycgzZfoU9PNZ95y9odRZ+fVu+FG1VJHPQKu0t+6lhr4i2KA2NL6/SqFu0R8fG6msNhX2734v8b+wQGQ2AOpUg87KPhivRoiXAAZpdVHQVBINFsddtYZqcbK1veSSvt4AjTQqc8aIYhddEzUBrQwSfCpvwacQNh+2s5eG3nuoscdCjv+eJpYKTnH7qqVGcXlYdk1bQdUEaFa5PWH3dYK0w30YO9gejSb/ameTZx/QfbFMt5vwlTgKoA11X35EjcOul7syMX7byKE75XWUOPlDnFihQR1NKaWg/a9anOVme8MI/Dk8C6apcu1F9b5goUm/1AXeQnuxI4zBB2ESM+jn4ou4WVEJzmsUwEW6StLqst88ToHFq2b1WMbq+EkrJGTSYp4bzGz/iu0NS0PFl+8e/VZntCo6Q0nxvg2jbTvkp0ybawFEb6d3veTRucAs7FbH006e1il1FFDQL6xYDdY+L5IceLgVXymp241ieO7Z0EzyK/e4kxpF2dfkgj8tJ0Sw9p77lPEFbdOeMo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(366004)(136003)(376002)(39830400003)(451199021)(36756003)(44832011)(7416002)(2906002)(4744005)(5660300002)(8936002)(8676002)(41300700001)(86362001)(38100700002)(478600001)(54906003)(2616005)(6506007)(6512007)(186003)(6666004)(966005)(6486002)(6916009)(4326008)(66476007)(66556008)(66946007)(316002)(83380400001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CES7he2TZdWlqaj6dO6HNULnCQbYq73M6mrKiVLpX3YAF/ERit7aPU+1jtnR?=
 =?us-ascii?Q?ASU8ShBSVKtbGfCtvUB/dL0jMDLndFcq8LouCGcck8/OknGVoPQ9A2VCGK9U?=
 =?us-ascii?Q?Zs7vrbKwTHNpJsxkD6mCm32BQhb7MUaJGSf5Wd3yoQXgH1AZNfensNJF2aN1?=
 =?us-ascii?Q?4EaGBjizTAwFnSIqJ3vNIkuo+nORHLt9S6+pkjc7qKRzyk7X+NInRc26fmAV?=
 =?us-ascii?Q?ZKesHt+63TrFqcDWa8kM41ygpNxcQmaWwZG0qeXQsWjg7mJykKhjvMuCIw/1?=
 =?us-ascii?Q?UTuFlSFTNfHZTYh7y8f5NFEvLudWeNNuWCY1pjiTUZN6UjcO3oI5/m+T3l/j?=
 =?us-ascii?Q?8RIV3vnBE1i4FqqtNLw9skG2ESs23o2P4/zA9yG31hydO8AXneoPUGKD31oT?=
 =?us-ascii?Q?1y40gBjscsvSENReMUXUgowe9mpXuUBkkb/hzrYvTZRea5Il2SrOpozJT8O0?=
 =?us-ascii?Q?CP7uBMtARWQaFxBIeIp4zBByl7meTOmt4aMxRtnVQNYFsKmum3R/oUwvGCEv?=
 =?us-ascii?Q?+5bY7j0xRRQS1HJ06CzeN7XdEuvN6HEdZqFdXUb1cy9nchWd++Uamsof/z/u?=
 =?us-ascii?Q?LbA2orb6qNWlG6JMAGs7WKixRmL6hH6zYEdeplxxfY1rtwxC2Y0fhTrPMeFX?=
 =?us-ascii?Q?UPRjYm/UOzzrvXOPiYEtBbthn2hN5TdtXVgyqPOe5hguW1ol7Qtx40hLWl+i?=
 =?us-ascii?Q?2IGoOtu3ozRQ3Bnl1fiefWlgSgy+VunmVOc5lU5oYgiTJk+vPl2jVh6I/00R?=
 =?us-ascii?Q?fcVr6jsOaO6Td927aC5uzTdKm43gV5WMjZ0B1knKLgbnQuIr0BoAymtPTuuF?=
 =?us-ascii?Q?OuYzRFQN8gmYGA4UsooCV7jO8kENHezl11UUvjeN9MuB341iPAz5CCTCLuNt?=
 =?us-ascii?Q?4WMSqrrsJ627QitGbPc9chGY0oL0r91YnTKFNlFDf01vIITk8eraz9vY+7jl?=
 =?us-ascii?Q?LW0pdVNovxazn6D9cS4ayzQ2t49+4ACJTLR/FCRp/8WpUQIPOk1Cb4xJXlPH?=
 =?us-ascii?Q?0yxpMqoiSjmUathvNROle33xpghsoF6ouvtrHbZRYfw+9My2U2unuaDxJITi?=
 =?us-ascii?Q?EDJVrOrGanXf0G2yP8+pIZR8xTH1l0LTsct2rQpV3DUsLrcUH4O7szXJ1tof?=
 =?us-ascii?Q?VBaaxb31iX2o+yVdyVptvJbsQ2tAjz/sxxE1j+DnmJwgq7pBIn0zCxCFxUrC?=
 =?us-ascii?Q?91H++pvOUTVW5W7SeXuadrb4BJ9q5p79aEerETqG/vPYQMucI0gAOmM2e4Be?=
 =?us-ascii?Q?mcmTj8L/uVDAZb4scL4mxnQO8mIv/BrX8cJlZ8V4ABsx9S5lZ+zIVVNuqBm7?=
 =?us-ascii?Q?TRes05bmswwKe3Vi6MbT7O7f5OhFXf9smd1o+Dj7P4ImmrrHqRKSLhYFq+Go?=
 =?us-ascii?Q?hdXgiEaHOmroJcMMdtnv5nHKXX89jWd3D7jiyDSdviy1IceDFpsdRMTB0kb4?=
 =?us-ascii?Q?L3X3uCW5vWzJ5q9xB94Vq0haBCLJhOhwAdOvpFmw8H1OFlKwcokMOgp4E4VE?=
 =?us-ascii?Q?VOHLPFjvKwkWuc6e4ecswR9OiItusJUeA7PdsPTIgUzqTQ79CcQkThmIWbMb?=
 =?us-ascii?Q?eWJPxn0MeDYqwvXT/Nzwb2OdzOwGsqIAdV6BpK4bDyIINwMWfb2YIQm3qV/t?=
 =?us-ascii?Q?+L1IMxeRRKjLt43eZflvrwxeCMTuLGt/DPfu/0Sz85WgFhqgJNFRwiz9dId7?=
 =?us-ascii?Q?05uWOw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b47d691-3e81-49d4-e8d7-08db3f452084
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 13:10:33.5308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: za0EF01XVLT8bS3aygcOSklqhlNdZA/YegNnbArX3FVg7Ai9q1FCuwMfob988YKgZyBv4NzNybRyHa1weCf9nZIpbnmw7ljZ7pW/4NhBTuQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3781
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 16, 2023 at 09:05:19PM -0700, Jakub Kicinski wrote:
> On Thu, 13 Apr 2023 15:29:18 +0300 Leon Romanovsky wrote:
> > Changelog:
> > v1:
> >  * Added Simon's ROB tags
> >  * Changed some hard coded values to be defines
> >  * Dropped custom MAC header struct in favor of struct ethhdr
> >  * Fixed missing returned error
> >  * Changed "void *" casting to "struct ethhdr *" casting
> > v0: https://lore.kernel.org/all/cover.1681106636.git.leonro@nvidia.com
> > 
> > ---------------------------------------------------------------------
> > Hi,
> > 
> > This series extends mlx5 to support tunnel mode in its IPsec packet
> > offload implementation.
> 
> Hi Simon,
> 
> would you be able to take a look in the new few days?
> I think you have the rare combination of TC and ipsec
> expertise :)

Hi Jakub,

certainly, will do.

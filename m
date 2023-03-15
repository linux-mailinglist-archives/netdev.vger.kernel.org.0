Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0526C6BB8E1
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 17:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233003AbjCOQAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 12:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232800AbjCOQA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 12:00:29 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2072c.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8d::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0EF424BC1;
        Wed, 15 Mar 2023 08:59:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AbGK64u4uIot0HHS3fO80h/F7DwkvIqHCn028dv6Nc51xhFRBAbd6MfpFP80bqaXuYKo/G9EEccumBVLr4yxX0vY3tphFgpkUtsnbLcSpICCn10yLcwjEPwVzeji0unYIecEtaXy9cJxPHAMtqJ9Bdpin2+5EGuQPGhfl2frp/q0MBuGmBve8FzvQS7u+XiPcHwginXQli3fa4EHMCV4bu5mzj+o4sxrATq0BSqxtwdefFPJrIYMGnnsLLCcbrCRjeYlIrMU0tZjKGzPcCCZkIKx/teybof6Y4LsA9Ep5kOc7f5gl6bbQXK0UqHqyl5jTqIZiyd2HukZIeb1PRDY4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MrlltfBB+6fiFRuVhTtn93wtMG7gfkb1JRrT4JdHZ5Q=;
 b=BK6bDtQw5X1ZZIhCVhCeOKFZVSIvPKEtSV9ocbahn7YnIsnzz1iY1UfVNWh+I6VOq8SnywmyEf77YSQ00ZyXV1d6KN1mCqg02niQ0gS7Z1Rq13DV7NDbyTNy/e54eccap9kDHRrLDgJEr9qiZkALe6X6kXMilbMzVTfv5W/6E3hDsiR/iN48VtLZnhwBkaqEQ/J904LVEeGUj3/2Q2Rx5oNNsvdiir4KTDqoSnb8GDkZDOr7eSBX/Q6gSvaYzfGIzsUf1RKjyxpamGQnpLEQ8HFBUsRbB1BaHj1QQ5/NLjy1LDg0EuodVSIJojY307PsrauLY7ojmCC20J/U6HhAwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MrlltfBB+6fiFRuVhTtn93wtMG7gfkb1JRrT4JdHZ5Q=;
 b=wbkLTsuuUAPyQYiWoARgQjk3iCAriVFbpkDdyyKGM1xlZNYkOLA6VwaK+hCvmbzY7bgs7FAw7x1bo849PqEWC9ZbtVnO1Klowreh+NmZ9zVwUiQt1KWQ9+VdFWqFGRxAAsN1VYLMCGOvCTG9+gfTaXLryxzjT0LC7z1S4yuMzoU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB5037.namprd13.prod.outlook.com (2603:10b6:806:1aa::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 15:59:25 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.030; Wed, 15 Mar 2023
 15:59:25 +0000
Date:   Wed, 15 Mar 2023 16:59:19 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Sean Anderson <seanga2@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 3/9] net: sunhme: Unify IRQ requesting
Message-ID: <ZBHrVz18X00K88S8@corigine.com>
References: <20230314003613.3874089-1-seanga2@gmail.com>
 <20230314003613.3874089-4-seanga2@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314003613.3874089-4-seanga2@gmail.com>
X-ClientProxiedBy: AS4P190CA0044.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d1::8) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB5037:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e08d4eb-65ba-433e-12b7-08db256e401e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WQ38Zer6M4vb2no+4jd4OktQM+RhFiprO5pdtqMSQLztHsqcB6/maqw2qBw2qwvyEeveDrIcIybg47QxcgE1gCxaJxwB71eO9+EcPpYetaGRZlNQRkscsjsBAtQscqkenCURi3DT2glf0JHp+LkEeEiCNJz8d069QvqImLp9PVLd+XBr9R2iHFlTvl1cvul/FXMzAlLrRgnAZS89d/eDPuSjI8DkowGAmtTegXj0gA5FTAh2h4zotawlK1aHryIE72SMMQnFHksEnsqMQ5IaDe1+GuLJyDF+ic2O8VE41wrQwrngo02z4014PL4vHZmp2S0ET8wp5TWa+LT8pGG9OzVMYuIOcZb6p1pFwSsmBcW/jbb7rM1V0KJcVopXhSZbKFdN0SvA/gM1V5cdqp2aec6h1ScLh/U4EpzCSy840BrbDbliTpNK6DYni5ezCmQmxJemPDOA1NfuwjeFJPJg4sxm0HflM4F9LVzL2/AYzKBt1RxpqsJyG03jJ+x+JohxDle7rkFqJiJl6a0sSn+mNsF0PmFBqdOhPh/+ezbdGAQjW/jpV2Eruz6hy9Sd5bPy5O0lrVXJxZgGi/XWb27wWgX1n8SODOAcl94qZPsI3jPFXhZkLddBJg8fo7Nd1SX/UO4QXy252tFljLOtO4j7Mg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(136003)(366004)(376002)(39840400004)(451199018)(8676002)(6916009)(4326008)(66476007)(66556008)(41300700001)(2906002)(66946007)(38100700002)(8936002)(5660300002)(4744005)(44832011)(6666004)(6486002)(6506007)(6512007)(86362001)(186003)(36756003)(2616005)(316002)(54906003)(83380400001)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8gGtWujEYawG17YtEm0IRZo4QFbz75+/Ro5/N5ClZaVN8bnvJS7hTr+vEDfw?=
 =?us-ascii?Q?qTo0h4uuR8WDbPRvSeXV4mMikk9paEZm1m9+CB9kIPXflOUwjwSZNRXLCL5c?=
 =?us-ascii?Q?hfiNiEtv9GciWPp8hGyYtS354gicw102Ksuu84WfJmOHwdmYiyfh2mdaqhgh?=
 =?us-ascii?Q?dmSJ7W5ktLicr9KZlcAb9jt9/K0+zWf/4iNifL9Cnwlm1ZlYuZ3QvjvvYU6H?=
 =?us-ascii?Q?X5uo+/jDLra/5dOSgAcWD8YwdQDTGRM9FxPBN1oKS/39pg22VCO8k8iwW7km?=
 =?us-ascii?Q?7whzbcw6CDVzwWxPLy9GH3gL2ArX6PPslKT7lm54hSRlZICz9rg649aJUyl+?=
 =?us-ascii?Q?rg6bN0ZD0Isnmrejl/q0tC0J0BiUVQJqL0kRav6TsDW/rcRoLiZjvSMasKqq?=
 =?us-ascii?Q?rm7Hw1qkWeaedF0LnoCyczNmDo+7SGk0TbgdV8A/nDJhLEBWr9s0ICPN6FyX?=
 =?us-ascii?Q?7+T+Z4yuR9ETQYxl5s8DKcVhJxZypyCLC55VLzVHWumk9ZSUUpZdfpCij36c?=
 =?us-ascii?Q?RziqsP8UQnC4/RUtOqY315iEEzqD+yYYMVtDhD/WnJCnsbz1PtjlU3EPqueu?=
 =?us-ascii?Q?0DpBTzeYuVzEMoVj5Xwnt7HnebxBVboN2e4C8dJZK+FB+lWFatu0He6g2u3y?=
 =?us-ascii?Q?xG+pzAjUIFgPBa1tAs8r+FiYTLa3pzzXvDifQFgQFyKYeY4Fxgl2S3R3yjkU?=
 =?us-ascii?Q?FD6W4neuRQJZUa+rmyqAVxUPgPQ97hE3bkhmtxctzd1i1nOxo1mAwNvITNNu?=
 =?us-ascii?Q?c14IFQHHiRv/dlILx2xmZXDIforulBNPPR0+lTvbffqWt5WvzbjUT8twptir?=
 =?us-ascii?Q?PyrXjyg0SaJRqMfiTUGXQyeVZDqM8XUbbhjjwBmS+RQ3yh23jBvsQT4H8nHH?=
 =?us-ascii?Q?ejvVRekpGSphCsc/icuLrGZAxZrCAfWRw/2iyISRP544Oc73ljx79WF/mIag?=
 =?us-ascii?Q?Fw/oqGU8HabKqLldBxjTxN699VX6PzY6go4lfSGXQmteHQj6o1XUAWZJuOxB?=
 =?us-ascii?Q?JFTwFzMAhebyp/DI377tkivHrTsiJinW3ynNVWTcpxdnMkq9ODuaaXRfz1/F?=
 =?us-ascii?Q?Jz3XkyaO3DDx+H0pIqO3EQslnDducq0De58lv/TebcSuQr7WEYJWzQba7k/H?=
 =?us-ascii?Q?G4oSdjqxIARBwzE11vS4U4t9aT7IlYkTgFOVuEfONsnWKcs9tE7RKIbmaV3u?=
 =?us-ascii?Q?AWXxbIgeAqoBTsSm+DEOA1fv8XIO5++gono3qtFq0y771NHbz67Sg4GVaotB?=
 =?us-ascii?Q?bExcjSWOpP0hJpAF8DFKr2rbt/wVsIa+MRat2eR4da2swHZu3MYNhhufpsuk?=
 =?us-ascii?Q?yVyj3nk5IwX2R86mYA/8b8ZV6j6WojQdWWEFw3U3R9wWwnf8fVcHw3UWfU17?=
 =?us-ascii?Q?QHnQzbJbzFJSQUULztyOEnuJzkPcyV9YBqWbKm/jnmi8KTaA+6ZQ5w7EEBi+?=
 =?us-ascii?Q?Z/CnaNNzpnzSOB8Fxy47R4DREklKgSKM338t8Qf3zZ1Mrp7OhsxVo/nS5vDs?=
 =?us-ascii?Q?u2eYre+qxm4Mc8xG6RRShlJ7pLaaB9bLeisFU6g97hRSa9syKKW5uHiPFdO1?=
 =?us-ascii?Q?ZOS0/VragV59Ix8nY3802UsL1jfhOCbOgvfkcKdzrM85XvmZe9w2I2VxAZej?=
 =?us-ascii?Q?31SYw/efYreSTrSz5LuTAXhx+H6Sju/lfcMVft4fafa0r8cFOvLudG1aVtDs?=
 =?us-ascii?Q?8WQ0uA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e08d4eb-65ba-433e-12b7-08db256e401e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 15:59:25.6649
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P0oryEUmFTTL5CLTIox3gYxMwqKgSxMHvEsF5Ucbp5gwUKvlK/Dt1y/opPpn3M/GtRvJUbo+1a34H0jQ6X7RcxdxVCtbdhpO0JbOD5fK0hY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB5037
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 08:36:07PM -0400, Sean Anderson wrote:
> Instead of registering one interrupt handler for all four SBUS Quattro
> HMEs, let each HME register its own handler. To make this work, we don't
> handle the IRQ if none of the status bits are set. This reduces the
> complexity of the driver, and makes it easier to ensure things happen
> before/after enabling IRQs.
> 
> I'm not really sure why we request IRQs in two different places (and leave
> them running after removing the driver!). A lot of things in this driver
> seem to just be crusty, and not necessarily intentional. I'm assuming
> that's the case here as well.
> 
> This really needs to be tested by someone with an SBUS Quattro card.
> 
> Signed-off-by: Sean Anderson <seanga2@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


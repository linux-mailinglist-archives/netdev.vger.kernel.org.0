Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC3006332C3
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 03:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231661AbiKVCKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 21:10:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbiKVCKx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 21:10:53 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on20716.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::716])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0CD3E223D
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 18:10:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OviDVV4i/9ocoH0H25XLratkqtBKND25w2iIQKs/gyPKYPPAsUmAz4ZQvIKcAUbFK/3ylR461CqH46ij4RtF04DYADIK8nxyLbRlG5zwSCaVp6Z2B5b/3siTS/GpSjhwIzUn9uLMefRB79qDzD8NdBKv68v9b5ylLMQODCEMcpDuPr88sBTsllwyobnhjAQjkJ37mCDs8wuKmjpp4jR59XVjnDFvSBzXkCKKoecuuZiNe+O9HCgE6+iLLpWxbmDRUCFu+giwKiFly7NUIVNDO5gNm8U1wi6LU+GyNjmylB0NvDRALNh4DR0Rdhp1Hj7uEGTVZ+RYlrTs4hq7SNfrKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tq1UeYh6j8omKeHTvpdiyLcSH5BBZbAYlPSBlGlrnJE=;
 b=d7inSoQgOsKWJ6fhP0YibUBwFk/zi/4DpdjrmPxgxbncYNu8s0rKI581/+kBgXu2A7t9n134L4deWy5scDmVzFko7LG3W7THG3QjJaZSdAi2v/OxTy3IoYyUKQ9h2c1DJr+v/V5oTCdW88SW6KLeYnE1YAVobaC6bi87phi/W0gfLhuv1idZ1K+dIEsKaydv2cIqxACRD4kJFHh8/QDfK3KM4N5Y6s5Gi8IeivkGkr93RiZDBpEdveuUD2meGz8J6ScnRuQHAREkOgotoQeX1xwYt3JI9GkLh9m6TjKBIJs28fJxkm7rlCQHIH4Jm5krxfdGZfaO+QOTWSM/j0ng2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tq1UeYh6j8omKeHTvpdiyLcSH5BBZbAYlPSBlGlrnJE=;
 b=d5AYCo/GNoKlplD7keUj1UnQK/yyAe1K3PnUnLRqtjkiJTAKKApq8rMtGfRTnO3gRKtAa7k1rp/Xex3Ym2c3teHBzLYGLvBfMBQVEHoVJP8wev5+sY4usLmGlaznB543Gc1cXesqCJHa3Z1DnaEUEnVP4tASUXAjh29kC5pXbQk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB3705.namprd13.prod.outlook.com (2603:10b6:5:24c::16)
 by PH0PR13MB6006.namprd13.prod.outlook.com (2603:10b6:510:d8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Tue, 22 Nov
 2022 02:10:47 +0000
Received: from DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::a82a:7930:65ba:2b83]) by DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::a82a:7930:65ba:2b83%7]) with mapi id 15.20.5834.009; Tue, 22 Nov 2022
 02:10:47 +0000
From:   Yinjun Zhang <yinjun.zhang@corigine.com>
To:     andrew@lunn.ch
Cc:     davem@davemloft.net, kuba@kernel.org, louis.peens@corigine.com,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        pabeni@redhat.com, simon.horman@corigine.com, yu.xiao@corigine.com
Subject: Re: [PATCH net-next] nfp: ethtool: support reporting link modes
Date:   Tue, 22 Nov 2022 10:10:42 +0800
Message-Id: <20221122021042.35236-1-yinjun.zhang@corigine.com>
X-Mailer: git-send-email 2.29.3
In-Reply-To: <Y3wdH/RBQ/gVdq1q@lunn.ch>
References: <Y3wdH/RBQ/gVdq1q@lunn.ch>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0015.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::28) To DM6PR13MB3705.namprd13.prod.outlook.com
 (2603:10b6:5:24c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR13MB3705:EE_|PH0PR13MB6006:EE_
X-MS-Office365-Filtering-Correlation-Id: de23d215-2c72-4eb4-02c5-08dacc2ec4f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PPCI7GrnGY8SkriCHxn8ojRr97rJlhiPf3K9spEH5PenDZJmWyqscc7P8yC3MxwQ4FdcVZoXWdfEtgjDSJKIP89cwMMWHJRfhVpVJkxK5dm/tEWBnEDogvsb8Aeldbte6R/clbt4KcKh1ENuk7cfsFziHhyLWoaVVFTqvUsjThd8Ou0tXINLyx89aSCujllMCT6ODPGFA6PgKRh9MAcTUduJbsuy7C4DV+gFu6r6gnOlKxG2Rk+co91tbvM1mfp+kcUvTqUuIaSTCyP9qEfgNwEuq/VLWo+HauqehaQ6GV1chkuG/306Ojf/LFRh6efgN0aZ/PBRgKMZnH1KBum/a7r3yXC9468WF27n4e906wI9yOk1Y3fAuxsQXNE4z/e/5fWxM2y6S9KsFg+BgCD/NC4WR43+HsQulQd88ufpHNnXpG3a7+F74XYcu1ApxNGgQnBU6yV67/gV9TryeToH0vPBjS2DdMdT+bg9BZ3Sy3eeLx7Lqiryeystt40BX0Qgbo3U2z9O8PVsgEk0i9HKfijjV/MZ40MDfsIhCbWPrA6yeI+cl7Diy0fOo3G8UTYDRbuR8d/gBg4F4Bo0t/zE5havkO6gKFhlhsZfvo1oJYJBEgh1bRqcDuZgd/+ZfchfqeP9uwpkCgHc8dcZFdiN+j+ic8BxFOdiIUlQWcx4HSZxLVLmi2HJmanRUkE3jQG1paN8SejSl8rpjLHSj27ZKYBucRlO0DtB3N3phKTqr3DdjASzXvhvAopO2ce7yHth
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3705.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(366004)(346002)(136003)(39830400003)(451199015)(36756003)(86362001)(52116002)(4744005)(5660300002)(44832011)(2906002)(26005)(1076003)(2616005)(186003)(6512007)(38100700002)(38350700002)(6916009)(66556008)(107886003)(6486002)(6506007)(41300700001)(8936002)(66476007)(66946007)(4326008)(478600001)(8676002)(6666004)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zWok42fCfPbOy2GAkzpqHJoxCrmHioPI9IPLP2tAEO6cQYdj6y8TTvKEAqNB?=
 =?us-ascii?Q?3sXogvsN3VRdtvX0u4M+oHsX5OUy2GKxHlXWub5OSxXYG8AGxJZv5D/TO19N?=
 =?us-ascii?Q?b06PnRrKkYRZMddO18WmZKOgEMmhxh1kbikjJhIHDiDDcdBygdwnjVy3dgr6?=
 =?us-ascii?Q?Se7iY181qHT9slfZKCr1hnlIh13G39JGMQbeKZqg3HDSi1knvgwBRLH4d7qu?=
 =?us-ascii?Q?D2HCw+mCuiGOHr//Duftox2AwyWkVDd+mj6jEO6yipd2WL9zHxF+xnaxKBup?=
 =?us-ascii?Q?Jwi8m+kgZ+pEQn7MTJe2qKZI4UsFvM+rZzDffHaJ/FBsbnZTByvWc4wSALJR?=
 =?us-ascii?Q?Jv5L4xN5R4gFfFy7EqZi9wmFgBNhl5D+RgIjRBeGU8RQ/VL15YC61ryz8QGI?=
 =?us-ascii?Q?LnZ6CPJjeIDAf0/1FxoFMvyXhlxGXp7c/DVHKP+ekJK+/WlbN2aCqRgGJm7d?=
 =?us-ascii?Q?1P2Fqg60RvwAI9a2AG+kZt6QK707iBpNEH8oyvgAoOXFnnNO10oEjAXsNWWv?=
 =?us-ascii?Q?jXKdXnFgoYJOBzzWMZIW6eJVKBUPjSzoMnby/XYL7LIlA+Qn94f4gMH03m7K?=
 =?us-ascii?Q?U/cXrSm0DrJZC0J70mxKkKhOpho9Nl+P/+5rBhyeJK9eZ/BIz8QbWgunp7SY?=
 =?us-ascii?Q?Zj9VgYvAXth92ZCdJBYgi4eFzzi9ImtGFPEYpm1U4OGmY8kP/GqMmkz//CTj?=
 =?us-ascii?Q?mF3wcdZeuVWbXLUE5D1n7ng6lmadKrcX6XyV/X3bLAdZuzFkRz+YB7S1PGjk?=
 =?us-ascii?Q?TF2seMygVRR3Kb15vOa01DkrkU4LGHz9DBFNGb5O+o0obzJwRdFKeJ4PmBp5?=
 =?us-ascii?Q?6aV1SxptzRqwv+d/Z0Tpwe/jWbzjaWhgpqyOMnxpqg+bAdMktA1sTg+I5hC9?=
 =?us-ascii?Q?Xt2g15pR8fhy8KJRcpChtZmiVU5lcfGCSw+ef0ZOYhBqoMq6poC0XvrnBs0e?=
 =?us-ascii?Q?hVFpgswXUJ72XMZ2K5FqxJ3W7u8j9sl1RM47Gz+KWT13TjKGBA+3N+jiYuGH?=
 =?us-ascii?Q?PUswKF+Z9UY6M3UTUcD1kjPEDwzaCctB+EY4jDWP+jASlU+CWxacf/PwftWi?=
 =?us-ascii?Q?4jPht2IaiTJ6WRxhQ68W3MwcZv9ePkgQg4jpC0Ihy16Ht/eIrb13l4Iz5NLV?=
 =?us-ascii?Q?QoySR50hVC/rDCHCWKFrChHTv4yHnuubLmKmwfQ1StuaXpajZDeDWJ+TFn3f?=
 =?us-ascii?Q?yMzySdLB9aFQgUhFIm8buEAoywri1DO/t8nGItAuIqSlsJYHG3MhR1s1d34V?=
 =?us-ascii?Q?k7A4H3bxwdk7twYcg6XkNgbTPsOCJPHvsxqHakRqZypFiLmEBAkklYDKx95q?=
 =?us-ascii?Q?PD9zi8y/OSGs80p2pwWsPV+Vb3vNJOCpzprfNENERckfEzLU24Grk1PyAFu8?=
 =?us-ascii?Q?ho3vUQiTDpnNk1Uk6pkuGlHYUalBw1PMOT19+JV6w8zu2kLQ75tTZlhgXSF8?=
 =?us-ascii?Q?kHRxaTqXBlXPGCK+1uVO5TudyJd60822wQM42LmU3E98PLZjSPCZLIFk4gKW?=
 =?us-ascii?Q?/jZaE0+FfPAdvigwGIxdjOGMJKD5kCu9y5yyoZ5DfrF/moO4JazvCzUPhwfU?=
 =?us-ascii?Q?BeJTfH4OxYfHMIXJfGMcL9uZYvuqv9LM6mTAgofHjHq2UygVa/d+rIF4HSgt?=
 =?us-ascii?Q?eg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de23d215-2c72-4eb4-02c5-08dacc2ec4f1
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3705.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 02:10:47.3068
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uFZlZKdlLTp70L6OgUgc2TuHWgQInpPVQCu8vr9/5zsvL6RRHBfPbcFlOUnyyyTYXskgIJx3G0ivOEEVYkY/ynz8iBEMFFDQOF206U6mzTY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB6006
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SORTED_RECIPS,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Nov 2022 01:51:43 +0100, Andrew Lunn wrote:
> On Mon, Nov 21, 2022 at 12:20:45PM +0100, Simon Horman wrote:
> > From: Yu Xiao <yu.xiao@corigine.com>
> > 
> > Add support for reporting link modes,
> > including `Supported link modes` and `Advertised link modes`,
> > via ethtool $DEV.
> 
> Does the firmware support returning the link partners advertised link
> modes? Knowing what the other end is advertising is often the key to
> figuring out why a link has ended up on a specific link mode.

I'm afraid it's not supported yet. Anyway thanks for the info, we may
consider to schedule it sometime.


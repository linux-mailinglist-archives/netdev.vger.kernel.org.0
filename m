Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 551A56C4B96
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 14:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbjCVNV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 09:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbjCVNVY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 09:21:24 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FB426286B;
        Wed, 22 Mar 2023 06:20:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VhtADZO8APuKAJoqoF0T6NzFyLjyPvz6TZ5jviBEzPyCYHIW4jJ+FhIxwEOh9/SCwA/a9PDW+vUZGOpUTCi/poPOb5/gADHc0nyHu+H6iGR8Lc5NwJvgGWk7Ug0V19idPEsZ7zaygTUv+89W3JECm4ClZcZ+tCKNyNd7W5HRmBS0RPnWQI/Ft875rPaeI2vswRLWXuoHm5G5mo4g/geC34ZUl2dqLr2h8DMvl37wzAnOyPXEA7HgQXCjcGdOP4Piabv/qbcdj24iZITmxcE4BJagDcZM4t6VUsYHU8LhV2C9hGmznUSo1g4Es9fJ10lpqBsZJnZW7IcxLkZ5LSyg+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Xgts+bCfPlvupjEPS7v90+Rkp9rJuyCY/YdKaOcFDo=;
 b=YrJHtHCzrgaUT7xL9EArWYu3VTwew9c4IMeTZort0oSc/+3OIhSMFO8r3VCaXKJ2m83Txup+AAqYcAicw9mgkcy7b0gRiqDeTsT8U1QVQaWSH4yDTslHaDuby18YW//KPmakerNKwCwDcBP9LCX/DTAEJ3bH9m47rcIiWkL949G3sm78/cJ6lfEJuhI28s+62ws0tUFSQlmmP3U7ZXlh9f8aUy9VAc3fzoAnSWEYroQa5Cnqer9VCL5+OC3Z/8vsAicvTztj6mPBR1XwTBpL1NYr1pJzsZOjuYk98mzUQMWM0q19QJzF/upQBG8Xhia+KRjS8AsWk41/BWnO3qcQAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Xgts+bCfPlvupjEPS7v90+Rkp9rJuyCY/YdKaOcFDo=;
 b=EW6CzcF3MFda8FONWKUXTZ5VEiCcem0JP9clHPISNvHC2M3ETqFDY2QiqjBllWL7xJNsEsZQVgzNu4fpKRbChSsMFTukLiwi150dl0UhiGZdhg1IaL+C4JDXSqk4a+SEe7TNCOOnek+wYTwBB2EruO9rVW9IIQUuU2qfl7hxanw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3878.namprd13.prod.outlook.com (2603:10b6:610:93::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 13:20:53 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 13:20:53 +0000
Date:   Wed, 22 Mar 2023 14:20:46 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Tom Rix <trix@redhat.com>
Cc:     isdn@linux-pingi.de, nathan@kernel.org, ndesaulniers@google.com,
        kuba@kernel.org, alexanderduyck@fb.com, yangyingliang@huawei.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
Subject: Re: [PATCH] mISDN: remove unused vpm_read_address function
Message-ID: <ZBsArtzFkgz+05LK@corigine.com>
References: <20230321120127.1782548-1-trix@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321120127.1782548-1-trix@redhat.com>
X-ClientProxiedBy: AM9P195CA0026.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:21f::31) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3878:EE_
X-MS-Office365-Filtering-Correlation-Id: 5962337b-f35e-4456-5145-08db2ad8434f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sOfIAiB/7Gl/4JhhkVNjvxEpsdagiv8qNy0j3OBq8ETU/iHarq+ZijYSdARm2oDCgyH04EFpUYBh5gUpF6PRvKcyIfgLP7t6LfmVxCcdrIUSDmTfGagSl+8Nn6B34IaFYfluKz+vCDIP55l4H7zhn1qWajazGfef8p1n6EBbDu3z7jCrCZTnh4wmVIWnKMjI8sQYhDLws7IUolHOBo4jKOoOiXBWTKtv6Hl6K7FX6eSrWTeAaephJuUOjGWS7qK2eCBvmc6C7f2IILDpN1MOqY6IKT0sQ8U2l/hSxew59iKNDxNw+UiPWdm678ygMWZCiU630F6cRDx9h70coO9QwHdQnF6KTaQUUN1uQuxKZEET2xSqDcGs6Bd02w57iAh55n/QjqSGZ2XFz0mwYS2zNWlD+Ase5GNrOQTolDcRXFH9UTKmJvvyEI9xjjXPa+M4ITaxL5vREDuX3yspwYY6ZlAU3IpoouOKV9N3UcoC6W7cHMZU0tSisCm7GNk2oUr9rfEpstFkqWBylFtvzPW1D2L5llbzOpL19ScqSNtWUriOvYyCPuf50oubRpMJUJzI3T4jteWMGp908yv5Yoi2nDAe8cA9fWNVSq2rtaUwdQ0DNZ9J5HACAEA08LyHPaIVhR4WUkLZrjkS4HnEjN7naNkzXzWdAmkqJH2ef0PFlyabyNZxSP0eeuzI8U+yfh9yElrfF84A+dXV0yX8vgKUxUJ3diah2tp5ZmvuLrwJFtenVVGy29FHJkVUGnGtAZfL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39840400004)(366004)(346002)(376002)(136003)(451199018)(66556008)(6512007)(2616005)(6506007)(186003)(6486002)(4326008)(8676002)(6666004)(316002)(6916009)(66476007)(478600001)(66946007)(7416002)(4744005)(8936002)(5660300002)(2906002)(44832011)(41300700001)(86362001)(38100700002)(36756003)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XThWeFtnqriwHhzwWijVGGe6jVj+dkWSVa41co4gYA11BiKNtSuXk2lcw7lb?=
 =?us-ascii?Q?7ohZ/u2ud0kFgOcDBE1gxecKz1K9BHEyDpW8Gz86KtKjCsrKS4lewv8m3UT7?=
 =?us-ascii?Q?dzwmeHRQk3UxVSfd7AdAf3oZqPKtPmGZqNQ3DFRlkT+0ABiGVOcF1QoOXHcY?=
 =?us-ascii?Q?W7y8iEOXTKjIZYsfOhar0CNi15AaAO8MrZU376LVS15x1jf92T2iZbK5E0Mb?=
 =?us-ascii?Q?fK1AXjc/xonxZ+Ii90ol+vRrATtJlTHdm6eOFL6miPQZLnqxEgxB3hjEFkbV?=
 =?us-ascii?Q?xPFwcp7zPKKJgMoYsUqBcwDFmm6WgQuPv2ufCjQzB/kf8p8C/IBvsj5UakYy?=
 =?us-ascii?Q?9ljqnsc8TPZez8bcR5/XTiE9rYEh5IID7P1x64+TNU6lt18IPt8OE29Kwy2i?=
 =?us-ascii?Q?jRIktT4RfBuk2lKB0U9txxzlro6m2RQPxtTY4Zf2P3e0ejSXAhcrz9P/Q4W3?=
 =?us-ascii?Q?no76N2RFvYk7WnfmY+tDGdJRTSWC3ltAALLO7kbp/yog08KUfMM/8TYXyJe5?=
 =?us-ascii?Q?r9f+XKFM8iGoQlZlSZVqF6UBUEbB+SadYsZYyE2sou/5NFjK/sjE7oE0QnUn?=
 =?us-ascii?Q?A6h5b7m/DNdfokCdtTfEramzWqCEctiWczVTfXUnVB7p3Z5nu8E2vuSwbF5M?=
 =?us-ascii?Q?BfgXJujTafs0TjCFoG3v3MEX/S7eL/XnxvpdU+ml/+DZhYg/sXcfLQea0kOm?=
 =?us-ascii?Q?9xZUCWCBSbcGXQ/OpqtqW/erKsT6r1GiC6STy3MttqYD7Ko9IIutCWQfdzUj?=
 =?us-ascii?Q?GqpiFQlVf8mrdSHJCG4aRpui/NpqYBqS4UwNvKH/InD3oc6VEOEPhU73HnJV?=
 =?us-ascii?Q?ZhIo5mDeWUjqsvK1dOvC90xOd/nv8LHcVcDSvfDbbxOK35PY42iKSRHLg9l/?=
 =?us-ascii?Q?guOU4vbaoQG4AW/5EhQrcTVm7LY46Lsc92hDD0hFK6DP1WkDQ8opRo915fY/?=
 =?us-ascii?Q?X5afsd9Kl49bDLasOCz604RHhcovhlTeGoBiP7f+y1jY9aIDjmWcgmTSj9dJ?=
 =?us-ascii?Q?aTvQSXA+qwuAM0zQUeFlMOo7pXxzEbW9MTyJtm1DxkxDDkk48/emQWng/8Z5?=
 =?us-ascii?Q?xnbWIgXzSJP6hqUoOIubQP/vWrl+rzubvBitcnlB2s9RD7/+XJwUH79H+AOc?=
 =?us-ascii?Q?irqvZKWQFUzTcl88q7e/HfPyM/oQsoI6xx0tcOT/wkjCMVNu10wBmVz3F/R9?=
 =?us-ascii?Q?b4/xbyae4KNVDJALKELOb4RWOljMUrSBKPA4IKKz6ZbtpXXtOZYPjIStnJIw?=
 =?us-ascii?Q?DnJct1enVVyC3aghPEB1iP9Fl5i50jED49/OIGmNvDn6o0zghIOTzLuEImvS?=
 =?us-ascii?Q?QaIvNfzisiPjaG9Bhz8Hl+3pbLXFRHMaYBrGp7plrHb6qP6MN1nEBwWlTZZm?=
 =?us-ascii?Q?x4q1c6oGhhDya1bcjs/fiDPcremcjJ6BZFXvey8wGCpM/k4OBWNrwhVtuhyN?=
 =?us-ascii?Q?LeT+KfefrNLT0GPOJ1zsREHKNvxJA+BBCFsPw8IswZEuRCwVnaqZgrOK1czC?=
 =?us-ascii?Q?x+/CbqtwkQZkiEFmmA0brpnxBogbGm5n1uomSL3HrN8MiHsLKSkoaF9jM206?=
 =?us-ascii?Q?qrCkqbWTembcO7cELTQW8K6RsgnkQEdcjI7OPlIgquyv8NuCXyTK7DGnrwAR?=
 =?us-ascii?Q?0bNra90pfCEL4z80CKMeythI3BVBVUflY3nAkPbd9hCMPKAlyT+ktv1Z5Rvq?=
 =?us-ascii?Q?3Q40Zg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5962337b-f35e-4456-5145-08db2ad8434f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 13:20:53.6148
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fN+1SujG2YVcu78XifloGGA89RBErSGoRV3bgcW4duquJS9UF8aKbaBtr3Mb7LP8hytDAfVAsXDKxnS9X7hZ7JuO1kt2KiMBs7E0EUo30fM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3878
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 08:01:27AM -0400, Tom Rix wrote:
> clang with W=1 reports
> drivers/isdn/hardware/mISDN/hfcmulti.c:667:1: error: unused function
>   'vpm_read_address' [-Werror,-Wunused-function]
> vpm_read_address(struct hfc_multi *c)
> ^
> This function is not used, so remove it.

Yes, agreed.

But with this patch applied, make CC=clang W=1 tells me:

  CALL    scripts/checksyscalls.sh
  CC [M]  drivers/isdn/hardware/mISDN/hfcmulti.o
drivers/isdn/hardware/mISDN/hfcmulti.c:643:1: error: unused function 'cpld_read_reg' [-Werror,-Wunused-function]

So perhaps cpld_read_reg should be removed too?

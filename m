Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64D6D6D4C84
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 17:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232478AbjDCPuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 11:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232545AbjDCPuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 11:50:11 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2110.outbound.protection.outlook.com [40.107.223.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2118D2D7C
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 08:49:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j1OIRWJVQidHVLndfcMKmDMDPfwI+ykKL4cKdhq/FFHlD90T7uiJBKr3HrZOMQJkGDEZdjxSFdsfvYXNmXxBPeZ4t1kzzXhVl/vCGXr9n/ptYunG3KjcigCQ/AlSUjnEsEeimOCTFngBwHMBD3xkI3bNN8/PXEZYlPHwH4i9vgs87krOzXtadNjzdqCcW21n2kGkcfuISIvJdnTZo7In7WlVXwIA4OKiCZALMgUcWazzH2TSv8Snvbk9vOGl1AlMDU8vD+ykVCAMiC2I4rGxLuH/V0WJ3Ndp3q2Ag9UzvNDAb8NdGHaBixjnVE5Gx1VEs86aylBt8xu0xPWEkRGFhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1X5z1J32qgnGfRs4kS8wAp1aMLppq0jaxzPbIfT1NAM=;
 b=AnJ5bM0l76Swny5Ez1GaTLP80vN8JRNK/3z/VeQ8jRPdgO2KblcoA7I9kESXtrR5BGDbbmj0ziCAv+Uwbcu7rzhoJzDiNHsbIj0Utk9vcio5PlDfwNfBX6WMmYkKCK8iiapMPaI3zGt+69OUcV7qOv92MW1gzOdMbsi6WOXtHUasRlZJGGWPRz5pklnwPjsOapWmdt9PjPDtXA70cZ5fIKZ/zvFoCFehYWd0gN9RoC8jc3rAECjKrK56QB6la9cggUfF3p1mF0TptCcT3wR4gJcKQs2VqjW+gzZjWSyPJXRW1Au7O6XWsVZZ/1yfXbu3fSGjdt4uzai42DNO/MRevQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1X5z1J32qgnGfRs4kS8wAp1aMLppq0jaxzPbIfT1NAM=;
 b=cWdBKSetn8Fn41nCpBA4t2m5K2CKVkDTYfkH4TOFhtvi6PHC49mLlkjBzVHfF0pyxgeV8cLCj0DCGSBC/rIOnuWzKsFgh6rUtd0cGgP1HJRn7J19YxQCKbsvSssBGJhXx4HK2Mi4sVUimCDM1S/uPMe7Ee3R5KQCDJyGER+v73c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5880.namprd13.prod.outlook.com (2603:10b6:303:1cb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.26; Mon, 3 Apr
 2023 15:49:50 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.030; Mon, 3 Apr 2023
 15:49:50 +0000
Date:   Mon, 3 Apr 2023 17:49:42 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc:     Vinod Koul <vkoul@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Subject: Re: [PATCH net-next 06/11] net: stmmac: dwmac-qcom-ethqos: Convert
 to platform remove callback returning void
Message-ID: <ZCr1lrYueapt5rXW@corigine.com>
References: <20230402143025.2524443-1-u.kleine-koenig@pengutronix.de>
 <20230402143025.2524443-7-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230402143025.2524443-7-u.kleine-koenig@pengutronix.de>
X-ClientProxiedBy: AM9P193CA0006.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:20b:21e::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5880:EE_
X-MS-Office365-Filtering-Correlation-Id: 96f6ec0f-758b-454e-4424-08db345b0eef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fgLT2xDQCctlxAaRpFWGzpQ3Zcobx0Lp9N+eOdKk2dZSzY/6A5VTThzTpqF2yjtSxvQtP0DpeIgPwU+CH8yLuyqv/cyZOUDPj0mwkG/0w3p/84Xtt2QcB9/rqa5vt+LjmAy/cQ5YLMLoHBX+1iqYE4hGHtPALR46MYED5Vog+/+xLmU16Jz0ACMSuuCAtQz7VIdNRnqfQGdWV353HdQwanfdhDhsGTBI2XwOSmirM1w2pheZC5Ec4VM51AIZp5frL2FO7Kbt1ydF9aI43tzNIZ+UKticXOsB2mVkBb2pj80mAKK5Bwg2HKXlHbu+LUXbJXP3aTvucR9bLXuMF4AurA+JX9zRUM8yTgeG5zX7lHdOF/VXMmrpmFvSt0F/m8WHHOcPDPqEc+Sxr+LIL7WdLWtojkbDIgG6/sUBO+FjJ1A76tSC0n2ZPMXBiv7Uk8qWTPzzZhwiZ3kjfuyiY11m0MOzOE43dLSkSf2JqKgZYmArQKUEC1PHIotnCMkKm/jJLwK7p5xeTMAjbcaaFj/QvBeRoMZqTDBOLsHA38nmhomwB/kjGjPvokSDwQucGoOoIuI+leQauvgR86y/sWw/ng7MGFw4KmoWGZSYi1mQ1qQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(366004)(39840400004)(346002)(136003)(451199021)(36756003)(8676002)(66476007)(66556008)(6486002)(4326008)(316002)(66946007)(54906003)(6916009)(478600001)(5660300002)(8936002)(41300700001)(2906002)(7416002)(4744005)(44832011)(86362001)(2616005)(186003)(6666004)(6512007)(6506007)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a1B6ZzRRTm1LQUg5b0w4VWQ3RStTMFVHTkkxUFNmR3VEVVJiTTJ4clhLcmFK?=
 =?utf-8?B?NzJJSjNJTWQ5c2N1SEtObnViY2l1cmJTdXpOUWpwS3NKbjVHSVJYRXd3dVZm?=
 =?utf-8?B?YVN4YldlejgvaXpnei9BaDdwNlRjbjd4VjJSNU53Lyt0Y1RtZkQ5ajZyZ1Z4?=
 =?utf-8?B?clBZMVFQWWhEa0ZtZUlVcGM0Nys0ckxldUhiTEg0MTlONVpsanhDVjhzdlFB?=
 =?utf-8?B?NE1XaktVZjhlcE1Na290ZXYzeWtBNlpUb0VBSDdvd0FraTJ3dStYR2h4L1lK?=
 =?utf-8?B?T2tJeVVrUkh0cytrNVVvYlZZaUV0ZHZYNXJWYnVmNFdSNXI0eXpZWHFGLytq?=
 =?utf-8?B?a0x1cUxjYTdRaVJmOVBKNStKeUROcmVGd2JVZFJnQjhwL0FLWDZmUHFsVzls?=
 =?utf-8?B?dEVOR0FndEZjdWo4MXFoRjBLcEphOFJNM0M0TnNzQytTZUliRmo2eThDYWp6?=
 =?utf-8?B?aGFENTViVnh1NllTaW1MYjdCVTlza3VwZW5TakhWNUorSUZGV0p1UWtPRXI1?=
 =?utf-8?B?OG5zMUFmZC9IemxYN2FINDF2aCtOdGJyK1lXOEVNVTZWWDB0d1BaYkg5QUFQ?=
 =?utf-8?B?Mm1nUHBMNGl5SVZFTm9XeHFLSjBCMWE3cUtybXNobUFGamRCVXcyM2lmY0JO?=
 =?utf-8?B?QkVZK0V5dmhnK09hTk9nNmQybExZYUJsVCtKa2xoMzlPUXhPRVJZR1k3SXpF?=
 =?utf-8?B?c0h2MksxTDhUWDMvMG9MVi9GVmdMT0NYbGxKVG1Ob2dhenRLbFdsZFIvRzl3?=
 =?utf-8?B?TjZFTlJJbm91bHU5bDJ6ZmQrZ2ZYdTUvZ0RVdFc3M1lrS3huOE1JS0pPMXNi?=
 =?utf-8?B?cnZBb2xPaUZSMHBYd2VKQVZGZEJERk91MmpCeVFMamg3YitCanlWR3h4TlJ2?=
 =?utf-8?B?TjZzY1F3NHkwVk9uMVNDaSthM3VhRVZIcTMxdTZpOGdINGY2dlF0dFAybnlq?=
 =?utf-8?B?UHIzM2lwZ29zZXhxV0FNZUxhRnhEVFVrMXVaTGdhY3FBNW41aFVnVmZoZkc1?=
 =?utf-8?B?c2lJNGVENXFGRFltUG1NYlF5VnVZRWNUcEVtZVFJYmdVRXlWRWc2ZXl1c2dq?=
 =?utf-8?B?Nnk5WEJvUWo1eFRiakxxcDc1NFdJMUdoQ1pIMkpSdVF1NENQdDRNTEtINGg3?=
 =?utf-8?B?c3cyWHgrelZQR2lZa2tLbmZQRk16YzFoVjdUZ3BjbnFQa29NSmlnU2tRUFdN?=
 =?utf-8?B?N3JzVW1oLzZKL0k5QjljaXBWUUVYdytPWkpEVXpialNvVi9zc3BnR1RDdXlU?=
 =?utf-8?B?M3FCaHVONVFNeVZXc3Jja21rZ3h5OXZlK0pxdFRSRVk5bnZpWlJoVzZvSldl?=
 =?utf-8?B?VTNHS3ZNZi9Ja3RIcisvRjRieWxnaGcxWGJnNzRETDZmWjdmQmlXVVg4R3N1?=
 =?utf-8?B?ZVZRWGFFeEwvejNyQ0czbmt4K2dBaU4zQ09uOTMwOWhyVlRLd2Z2b3BuQ1J3?=
 =?utf-8?B?ZDJMVG5QR21aQ1d6WHZjMG9XRUVnV3ZJLzNoNXlZTlNzOXVBaXRYREFUaHht?=
 =?utf-8?B?cGRkaERrNzdEbG50WmQ0Qy9TSDI4UE5OdklHWW94N2ppaXNPU2MwNHBmNHpX?=
 =?utf-8?B?RzI4SEM2TUJhOG1XRjgwTnY0UUM5MjV1UkpCb2J2M1dEdTdaQWVMWW5BU21Z?=
 =?utf-8?B?aDVlT2ZnR3ZaY3ErTVJadjc2TWd4MEExcENhSVZySTNXdWx1aU1DR2V6THpz?=
 =?utf-8?B?cW1pVlNGMm4xbFBRVnRIbTdtVWJqMzFMYWc0RUxYQnFaVUV2bW1nZWdVdi83?=
 =?utf-8?B?cGhrN3UweG8xQ2pJVlh1cVBpNUNNa2NFYmo1dExoQUFZUHRDQy9rd1dGalRy?=
 =?utf-8?B?QjA4dmRtUFZiZlN0eXU0UUdWMWgrVkQrS2ovV0RtU0E5cWtkVVRnN1lVY1RN?=
 =?utf-8?B?VnNJcGEwQlRZQk5sVmd6bzJBaVE2YUx6Q0phdmd0c24yN3gwR2Q1MG8wOTFw?=
 =?utf-8?B?Nkt3clNCdjkvbjF4STZmT1F5M0xSYmkvZUVad0FFQlNpSWdaNU9JK0RxSDlk?=
 =?utf-8?B?a1lrWStJT3ZoSFB1VlAvOURDbG1hc3lJd3VsblJYNVNQZ1IxMDkvSURlR0tE?=
 =?utf-8?B?YmdMRWJxOFNrWG5LSFpSTWE5clpjMGxOMGRWU0phY0NVZUdpQzFFRlRkTkZ6?=
 =?utf-8?B?SjBWWnR5cWt4ejdvc0VaemhiTUllWmRiZ2VIa3BJWTZiMVZqRnRBSDlEc2ho?=
 =?utf-8?B?elMxNFFNRzdtSkpiMTJiTmNQbUdYWmw4SlIvNjhnVFJ4Z2E1WStEaUx1ZGFy?=
 =?utf-8?B?ZkgveUtjOGY5TWQrTG1VUHhXRGtnPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96f6ec0f-758b-454e-4424-08db345b0eef
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 15:49:50.2370
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2Uy45WOAbj8ikuews+8VK4Qx6DonUFf38nzEvgL7olV6QRGVjAaJxGweFtfhBsG9sgroiiUdYivcALYo4YAeERH6aiIl37O3XcdMs6bBwGA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5880
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 02, 2023 at 04:30:20PM +0200, Uwe Kleine-König wrote:
> The .remove() callback for a platform driver returns an int which makes
> many driver authors wrongly assume it's possible to do error handling by
> returning an error code. However the value returned is (mostly) ignored
> and this typically results in resource leaks. To improve here there is a
> quest to make the remove callback return void. In the first step of this
> quest all drivers are converted to .remove_new() which already returns
> void.
> 
> Trivially convert this driver from always returning zero in the remove
> callback to the void returning variant.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


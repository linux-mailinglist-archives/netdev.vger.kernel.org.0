Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 750D85B219D
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 17:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232846AbiIHPJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 11:09:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232827AbiIHPJF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 11:09:05 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2108.outbound.protection.outlook.com [40.107.93.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ABD7E3D77;
        Thu,  8 Sep 2022 08:09:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZPrCwfBcaameQoMN3G8tEFQio3IKgeHqNPNfI5xAc0rk5l4XwQ7ke0VQljbvZ5pgQQgFI3jWH758YZwr5ME2pfNW1BQgs+/6WXNaECGKoCNtlaaWarR8hufWc463E+YoaC5b5kGq1YmqqihOMrm7/oBFzKlVBo89U1LzfszWBL1NGmUU8Gt4W2MUljYhwcEhuqh65jVpxt+56W/SaT5w0SXnxlHGtOurDHjaKiOSe5qONdX/XMnVPQjXue5a8HxjD9vV7zpPq+4KuwnwRTUzknzQg8z9uRjfxbttcy5RP4ltnJgZTT0qe3bT5OEDiSFaQXQG7ojL/nQcM9SgoDOWVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/DCQSLqs/Y6WJJSRw6cXsTM5CBWjex0ZDDWh3a1asZ8=;
 b=AsUccpgD+IA6Q3R9iQItcM7dvvQ9SnABJEuy3X+tFXS5gbhPU2LqBmrRzaCXfaAzl5yz8CpWTPgY0D40FlEgly2/0qbA78xYo41TiQbsbgB12Ue4quMS+ib9x3DBDMcQvt+XpZiYjhncqJ0pql2dP2JQ6WSMiQOC1uYS6warxNOc7d1gDBdOKYcR81dJ7uN+EfjFJsg8xVtRnCljURgWnencFTzCGaX9SY388KuTAxCfOxA3Bo4mm/Ri0JSC8syA9Ups7M53ByBPEfCY5ALb2LauJYQBbY+AV6DlEYRMsKV87MztS4kHlW6EDrPJUYrvKQuBk73g22UaAR5+9m8X8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/DCQSLqs/Y6WJJSRw6cXsTM5CBWjex0ZDDWh3a1asZ8=;
 b=fofWNkNmu6k2o6O8U3803k8S7QkBRkc9ANgezFn3CyDceKtX34S3j0hUAoFxwo8q6NdJS5T1sjan3tWXksS/1hXr8bTcSACAHerFpypZo7tdxsa3g87GMDA16WeQzxxoYb5ml/KiWJX4aouUZNvlHzkr1p06FNprHPSlvqb2uSI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BN0PR10MB4982.namprd10.prod.outlook.com
 (2603:10b6:408:12c::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Thu, 8 Sep
 2022 15:09:00 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1%7]) with mapi id 15.20.5588.020; Thu, 8 Sep 2022
 15:08:59 +0000
Date:   Thu, 8 Sep 2022 08:08:55 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Lee Jones <lee@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Terry Bowman <terry.bowman@amd.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        UNGLinuxDriver@microchip.com,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, katie.morris@in-advantage.com
Subject: Re: [RESEND PATCH v16 mfd 1/8] mfd: ocelot: add helper to get regmap
 from a resource
Message-ID: <YxoFh7J93f5QPcn2@colin-ia-desktop>
References: <20220905162132.2943088-1-colin.foster@in-advantage.com>
 <20220905162132.2943088-2-colin.foster@in-advantage.com>
 <Yxm4oMq8dpsFg61b@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Yxm4oMq8dpsFg61b@google.com>
X-ClientProxiedBy: MW2PR2101CA0009.namprd21.prod.outlook.com
 (2603:10b6:302:1::22) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ecd6510e-6117-4543-92ac-08da91ac0ed7
X-MS-TrafficTypeDiagnostic: BN0PR10MB4982:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J3Fkg55c4JxLaPXJ0lUryfWZgZG7S9lg6T8KZkxPo0L7yPSVWajmpVsfLRK74k76lrT1m44o8LUbQJu5OWgoIdE0im71sc1drN3Zx7iAl22SC0are5ram1fexOYguw7Nx9hjmSOjrEj7mMgWrEAn6WrOCTr21AQQWkNGFDZQ5lMAVZxRUQ6Hcfd8E2H3Ypr0UwyhZWsX6LGN/YGFISBSORgTNi/vJqwdA8xUhlE0HlxPOKQOSOK2ABYZ1209OOHs5QEEz+RnrAmUg0J+QprmhX24ZGUnAomv7Ax77lnORrxWtkgGq/G6KLDut9+6dJeC6obpgDnzjLiX3tD2Vcl9AkX/kijAYpKwLkOnrC+vbk0bd6ocjdbQPv/x76/+zTQZWLfYYUeqM5AV33jDKEntVV3BTthLJJwjrrWSNFnjwSZWvdjGJ6JKonAYRPSJktCpej7JENgJdtLvgmnwygrvcRZGYeLFLLNzAJhqqPh1SVcDEyXlKe09HnruTNcDMjoqXBw3FNDDwYAvv0NiJpiev1uuX3udfKPfoT1mCt8liE9cWDOUR1iRHF6taoHbbRjupMI81kcgMWRtWcdngSa140LLGd45iFTAFtas0VxkJTa+vPqWYJLLP7adLVi4Yi47wlXpmDpPOiKAQZWABGHvKitRnQogWDFRkoOWB1m32SiOqaYxXh6sdwxA08rtl8rZWDmEAtEkPW39O3lxSK0mAw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(136003)(376002)(346002)(396003)(366004)(39840400004)(186003)(4326008)(44832011)(5660300002)(478600001)(8936002)(66946007)(66556008)(66476007)(8676002)(6506007)(9686003)(558084003)(6512007)(41300700001)(6666004)(107886003)(33716001)(6486002)(26005)(7416002)(86362001)(2906002)(6916009)(54906003)(38100700002)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TVNXekxWdjhlRDBEZm1OU0VtZzlyMHYzS0xWb2FjV1YwTVdqbEZCNVc2dUk0?=
 =?utf-8?B?MXN3KzhlT2JXU0xiU1g4SlhWUnZCN2cvY0pxVzhpbm94SE9ROVlxSUpoRmtz?=
 =?utf-8?B?MUE3YUVVMS9PU0NPMGJsRW1OUHRKdzh5a25wd09CVjVkYzhZYnJMTmNDZkdo?=
 =?utf-8?B?Y2NsRmtJSFZac3Z2U2YrNW0zUEpEQzBsUEhPdWZzR04ydVl4NVRVZWFncGd2?=
 =?utf-8?B?Mkg0NTRJMDlteTlwU0gxYzBLNm9DOGJhZEk1UGsrb1hkV3RwaHE2eXpmcDNp?=
 =?utf-8?B?K0dtS29PR3JFQUFveWEreGRCaHovRi9zUlNBZDhJTnhZaThOeitnTXlObW5M?=
 =?utf-8?B?QitJaHl2c0x6YzhpU2k3Ny9jaldaRXdPTFFWeFJxUnl2MDVoKy9nbjRtR09y?=
 =?utf-8?B?QXJ3UlZYTDA3RUdUc2Iyd3dSTmt1d3dYMGR3ZTBYMlNWbmJybW4vU01haDNk?=
 =?utf-8?B?MmhoOUVueS9TcUFPN3pDRzYzMEdqc1o5VlRnWFROM0JHNEdmTnJSYU9wck9L?=
 =?utf-8?B?d3NYbWs5dGVxbXlxN0NnVGJ4MDRoV3BSWnVCdkNxVWdiUlV2U0prVHR5UU9p?=
 =?utf-8?B?ODBWNGg4Rk1WUjFkZFJ5czVkWm9ScjRHdXdBSEJMQmQ3MnViQXY5cGFNRlV0?=
 =?utf-8?B?c1M3aDRsc3J3ZU0wYlBZZ2IxeTc0MWJWbmMzTkFHc2VoQkpiMlpBR1RiWEpM?=
 =?utf-8?B?SU8vOGd3ZE44UUFsUFJ1bUE2M25mUW9jUkE3d0ZKZVFwYnVUQVdwUFMyZGY5?=
 =?utf-8?B?cUYvNlNla0JTQ2Yxd29aRlUxRWpIZC9iRmlJc2lqNzN0dXBYcHJGUmtndUZJ?=
 =?utf-8?B?R0twVU9kaVlwLzBBOWF5Q1VGMlFhSDQ0TTNkaXorTEdLQjFDSmZwaXNPckRy?=
 =?utf-8?B?d3lpelNHTDN6bEt3aFRpWHBvQ3dFN1ZPd0Mwc0hCbHQxUm1VTjFhZFFuUWdQ?=
 =?utf-8?B?RzNYT2Z1UDh2WFVMNU4yZm5hVEI0Nk53cUJLZTJDT1U5YkZOOVhGblRzaXhh?=
 =?utf-8?B?T0pkemx3RHZkbHBqRFlpRVljUGlxT1YvYkxLV2pZSUdPWkwwbU12RGpoclc0?=
 =?utf-8?B?dnRYRWJXaVREMFZiSW9xelhDSXFRL3pRdFVHWjhZY3pQMjlkSnNmMzZXZGc3?=
 =?utf-8?B?Rmx4N1hCOGRFMi8rUFBvNGVZakQvaVhDNy9KVC9CSWZMSGZMclZXYkRzM2RW?=
 =?utf-8?B?bmwxRmtYZnRoL2E0QllXeWt4UGZTYm81YjROTTY1cFZUeTI3U0lIa2p1R1Y5?=
 =?utf-8?B?YzdnM3RlZ2p3SnZwVXlsQ1k0TzBWWmI3WmZ4ZEZYeFNoNzVzRHQ1cFRXZldi?=
 =?utf-8?B?OTlEOVVsOGZYa1FMbHgvWUo4VTFic2dRTkRPczk2cWsyei9tMXNyUDE3RXFW?=
 =?utf-8?B?ZnRFZUg0aEtReWczblpNa2pMSjJZZmdzbkhsVDVqckUwQ0RReU1oRGJTdWRJ?=
 =?utf-8?B?dWlGTU43NUtIOWhKT2Q4alFnZCtkb2dOS2NRV1QwMldZVVBML2psaXp2cjRE?=
 =?utf-8?B?dW9wMXpZSElXUWVzeEFUOEUwYkNTMW9QYXhPZmJqelNlbVBwN3BUbDNOM0d1?=
 =?utf-8?B?WmR1OFdiaGpTYXVuMUtWQ3k2R2JBNlBacnNnWlB6NGc5MWl6VU54OUlEaUh6?=
 =?utf-8?B?OUxwQWllYTQ3RVd1WG90TWJsbVc4WWl3VEI1blJyeDRwMFlNOU5UL3NRTE1w?=
 =?utf-8?B?aG95cFdmWjd0K1JDblJ3VEFJeGxwK2NqVFZWL0JSU29SdlhxVk5MblI3eUtQ?=
 =?utf-8?B?dTFnYm91bFo2UWR3WEtzQkdLeDBVcWRCbXA0ZHZLQjJWMms0dmpvcVIyTlZK?=
 =?utf-8?B?WkEyMHJqU3gvcEVEcE9KR0pIS0xsUXdQeWw3MWd3RHFaS2JTZWdiZEdNNkxK?=
 =?utf-8?B?dDVFaFRvb3g3UnFWNGgrZ00zRXd2T3FLRjdKZm1VYm5SS1k5OFZzV3dOTzVE?=
 =?utf-8?B?MCtId2xSNytwN0tzdDVxc2xaY1UxVjQvTkc2RnNNRDNHeklHU0Q5Rms2emNx?=
 =?utf-8?B?UmlYZGZNRG5VZjhZSnJ0VllRTHY5N200Um1IS1k0Rkc4QytEWVF0dTVLZ3JI?=
 =?utf-8?B?NTROajVXSVVEQXdJY3hQT1E2ZlVUOU5NQ3JSNnBFWVR1WHNFN0xUNm1BZGg2?=
 =?utf-8?B?ZHN3TExvSGxVVHlxem9GaUUvd3d0QUVXM0JrOW96Q2trcjRRaGgrZUpueWpl?=
 =?utf-8?B?T1E9PQ==?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecd6510e-6117-4543-92ac-08da91ac0ed7
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 15:08:59.7320
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q/WNW7kWxHZr8PBhnTwARcXmXWDnFXE2CYrunOye094XFPcxXp+EU/bYsTXaE2+98NsQjSKyvznVSukRf2qd1HRqI8JpB0Si2ig6YIF0iGw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4982
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 08, 2022 at 10:40:48AM +0100, Lee Jones wrote:
> On Mon, 05 Sep 2022, Colin Foster wrote:
> Applied, thanks.
> 
> -- 
> Lee Jones [李琼斯]

Thanks Lee! I'm looking forward to adding the rest of the functionality
soon!

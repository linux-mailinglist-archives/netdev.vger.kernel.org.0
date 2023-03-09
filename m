Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 350316B25A1
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 14:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbjCINk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 08:40:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbjCINky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 08:40:54 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2107.outbound.protection.outlook.com [40.107.243.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E1FEBFAF;
        Thu,  9 Mar 2023 05:40:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h2bHRrDeF9FD8XxJbGa+AJgC4/lRt54Cwf4oofJxnjIx3uy16NUcpGQCxAvkYFx9J5dj50GWcm0b0kHfw/nLVuPXdRse1rVtciq/i2v7WDojXpLdAY7uStqn1Pw3T+A0fYpBYccoIRPFsZZWmkUiF/9Vgl3ffydD5wRN5ecRCW2U03/WFTs7gQs9iMkeKYNWNIsOgiBZcktHw59pGCPZcGeeNfFKEJgm1VzlQcGfPEQO+IQAiKTigXXDzFZwfeS22jStBLRPehOWeM1XHI3QCYBJL+xcoKK8OZNJojytMSf+AKZeYEwHfs+O/TZysetx5TDKJQTJ2Tblc7BEPShDdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eAoiYdj5XO5HY8fbXMDjjrjbKvQFDLqr4nM16eeJphA=;
 b=NRGRE7K65nU00NMnJvdhGeJkdrUEs6PS/Hs3GXmjx/ZsTMZjr0K7pKe1iZZ+7S6rQ9OLFcm+RclyR3VhjVGuHpsGKfEDnfqtUzorXsgvhNbBhpzTi2ZAM74r8NS+12NnNQ/CW4eP3VvZGa3lssue0ID0pI22nGjaHPI5kRp55evU9BcGePmhX4e7+FmII7/haDdpVfGhukTkWmE1bSMSZlfqG0JGIRNMLAWcKI2zHhZUQCYbEH+Y+d0F2dLZ4t25hXJHWa25xpyrRGHmglH60ceITStAVkvxGDmEaNev11DFTpQgLXdNiWWbgKGNOebYCtuNE76XU1l9GjD9K1q2pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eAoiYdj5XO5HY8fbXMDjjrjbKvQFDLqr4nM16eeJphA=;
 b=XOT3uNl6gKHB/cE5JtaRjt027I467yzPP/mrHm5uRt/t1bFf3BSvN9+J9sLlwvYkL0JyO/RpLPh9eoOHzzvZEPqhq4JGUBVrJd8mtcaLXH4JZUs7BN1W9575QHb0b33HVtjaKBRSAYXbS2vkHQcdMGh4kihD5UwC8p66rCSismI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB4412.namprd13.prod.outlook.com (2603:10b6:610:61::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.16; Thu, 9 Mar
 2023 13:40:41 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.019; Thu, 9 Mar 2023
 13:40:41 +0000
Date:   Thu, 9 Mar 2023 14:40:33 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Leesoo Ahn <lsahn@ooseel.net>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH net-next] net: stmmac: call stmmac_finalize_xdp_rx() on a
 condition
Message-ID: <ZAnh0TGtDkVUl/1m@corigine.com>
References: <20230308162619.329372-1-lsahn@ooseel.net>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230308162619.329372-1-lsahn@ooseel.net>
X-ClientProxiedBy: AM8P190CA0006.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB4412:EE_
X-MS-Office365-Filtering-Correlation-Id: 18f7af00-7026-4cb8-a1d8-08db20a3dfbe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Urh7pR8EZzKSmRKAgdH+FNzyVQ3zqPoMZ3pRqKgRLSoWlaRtgimq7mM8Whc4ko+7rezqOQaUYDqHdiGJC+eiXbngHwe3FB/Qh1O/GGGzDp9cKw7Y32VY3u48g8ED59iKp/nFuVTSwtyQxDzNm1tKJw+glu45jcLKPj8NICOr8MC7EUHdXuSMMA8VV0wN6AYWC2GXvHlj2t5SioFdgK5S50h+ziqn9H/7IltWyhEmLIsuYCHIWma0x2R2BCIaZCwk9jwusNdMRibklN9phyeedU2tRGJgtDK4fqPbu1YI4Vi2YgxNZcDSCjvPMZC4qQRfqDqZILeBa0SN+tJuvUuJ1Cw+gbsIDS65255L/0TOvQw7T5Mf33tPF0sZLVxy260SWjLcfu4T8lb+Tcqwbwjbk6/+duxBWZS5QRFUVJ+m40V5YK6g1UB0OTbthGhtKvgdeF+LsfHboUlses7EbT0M6dKqpbbL85xWIPXGk+7kho8604Fn1sfw7ApiQXUdENSEwnxlCECT7bdzXYYKx6gm55vxMd3roQg29Ms2aPHatSAmUZ/pQchsuwTAGf4ulfux4xOvlaFoTbt9dMyWr9oSMe71AOQcMQGRwyWwwWCc3Huzea+mDD17FrGAnIxr6giD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(346002)(366004)(39840400004)(376002)(451199018)(2906002)(6486002)(38100700002)(186003)(966005)(6666004)(6512007)(6506007)(86362001)(66946007)(41300700001)(66556008)(66476007)(4326008)(8676002)(54906003)(478600001)(6916009)(316002)(2616005)(7416002)(44832011)(36756003)(8936002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NmttajZFa1kwM05JQjFidlAzVzJTMUU5MlltdU15QmN5eENiQWdLdnlmYlAz?=
 =?utf-8?B?dHlDWklnOGxEak4vZnl3ZnFZeHV5ZlBCNU9aYnlISWFrT3BrUmJSNmFHZEVK?=
 =?utf-8?B?S0JSejlEZHR1TkxCZTRzUWhzTXc3d2dsSW5RdlFDa2ZEaXU4eWRuSHg0dm1y?=
 =?utf-8?B?SWFXanEvZEpGeEhPdFhuZHVCZXlWWWRZb1VLaVhpd1pYZThlQlZxTVVVZTVS?=
 =?utf-8?B?aC83VlFlbnZIcjg0Q0tLa0lTb2x1QlF5bFJ4N1BkNkMvQnhIZ3AxUFlVc0o5?=
 =?utf-8?B?SGw0SExZdG9Hc1JnWklDdWhocnVsSnllcUdsME9Zbk5uaHJSSksyMEdMN3ZF?=
 =?utf-8?B?d3E0MDRGaUFNWStYOUJ3RHBISzBocExHWmhvS1VGMjgxc3IxREwwMWc1b2Jn?=
 =?utf-8?B?Y1FSWTB3aG1SZ2JVdENiT1FXZmE1ekZ3RWRVejZFU1dGUy9jbm55Syt2bkl5?=
 =?utf-8?B?UDNWYWxidjdJVFBxZXo2ZGc5NHlXUVJDZEFqSlM1OXhJUkFjSk1JTXdsUkMy?=
 =?utf-8?B?Nk1XQ05pdi9NZ1BlYzZ6QTdZQ3ZoL2xEUTB6ejdCbVpRTGlrOGw2emZyQStT?=
 =?utf-8?B?dVpJSmJlbitjNnFoWTQ2THE1UldJcG5Oejd6OTU3M0FacS9SaGZ1WXdHY25k?=
 =?utf-8?B?enVEVW5DZVpKajJtVHhvVFFYbzFOK0lyd2FndXVwdTIwNW5wSHlGdUEySjRR?=
 =?utf-8?B?T0ZGMytVQ3RSOCtFNWFIbTA3RU9VcGhsa3FqUHZSeThwakEzY1RLWHFIZEhD?=
 =?utf-8?B?d3VtWHZ6WU1LNFRZNVB0d29lK2xhVmJwUUV1VHVLemxQNWNKWWJTdm81RkdE?=
 =?utf-8?B?TENDVDhxa3RYaEZPMVVwekhDTVNoYXNnbWRQaXVDcURhRk1KRFQ4eHZkbXJn?=
 =?utf-8?B?eGg1SDJRZUFsN1p4a1Fnci9NdUZEQUthVkQ4dERHam9vYnd3M0hDNmxWYk9h?=
 =?utf-8?B?OWpXUU0wazZDSSttRm1ubWY5YnoxN05ReUt3dGwrM090cEp4RUpLdDV1bExD?=
 =?utf-8?B?MjRycWMwMVRjRkF3dWJBUHVlVE41VGVTVU5UZWJvSlY1T2RVUkVBRURLdGZU?=
 =?utf-8?B?aitGQVZ2cnhvaU55MkQyS0xudlBHWDJoN2xMUVdvR3dSaFZxVE1pYTVPRlEr?=
 =?utf-8?B?ZTh6VHozTExDUlJSL0lKNGh2K3BOOHV5TERUTUJkY25sbGh3T3pWNk1lL0FH?=
 =?utf-8?B?OFpha3M4SmhJd011YWJDdFoxVEhYK2lBSGU4ajBXVm84a2tqeWRuNEl6cFYv?=
 =?utf-8?B?ekNwZ0FsQkc4V0orSmxXSnluQ25OMXFBNTk1TWRtSHUyTVBwSytkNENqRmFm?=
 =?utf-8?B?ZCthSzFCU3pJOWNLcUFOZTlCYkRrNWQ2QTYxRW9nT2pBNXBLUTZ3WHdwNFRU?=
 =?utf-8?B?YnM0a2RNYmJtUkRZQTJaUmlwNmV0M2tTZWNnWmhhamZWeXlqd0RpZjJndFhS?=
 =?utf-8?B?RlJNcHcyQ05yRkMvVXo2aW8yR3pObmJ1eTBjZENZMmR5UjZQdFVIbUZFQTJr?=
 =?utf-8?B?YlpqZktpL2xvdFc4ZUlvd1ZOZE9KTHVIRTNqUW85UmJqdHVkRWNXTDNQSEtN?=
 =?utf-8?B?SndMV1RMYlB1MVRCTnRlNDhONVU0elRFaVR2V3p0MTZvNDUxVFozeVArRjVx?=
 =?utf-8?B?dzlvc1Z3SU9XSXEvRi9TckhtQXZQcGZKdGpiN0pKa2JIR3dmMjh6VkRQVnFz?=
 =?utf-8?B?emZFNDVUeHIvZnZRK2tNN1VaMHQwRE1COXRPU1owaTZqQ2sraTZsVmRKamFu?=
 =?utf-8?B?TGVCU0dhUkdDOXdmbDRjREN0ZWd4cWVFb3dydFI4M3A5T3JSblJ0bzZFWi8x?=
 =?utf-8?B?cVNhNDM2cC90ODZUa21rYnQ1MTltZ1o2TzJXTUoybmpWWUVQVjg3WkF5aDlm?=
 =?utf-8?B?cUoya29FVlZYUlBsOVFDMnRmZEVwZWxoTjZxY3lha29sWW0rQW1uOWJzcUFr?=
 =?utf-8?B?eEduMTJDMHczVGw3VjMycEdVOTZGUHh5Vk50dDVuTXR0MzJ4eDNOMWM5VEF2?=
 =?utf-8?B?U0dwQ0lOQldpVVAzTWczZmYvOGo5RFZVLzBaVWM5d3Z3ZkJoZnNBT3M3SUxU?=
 =?utf-8?B?SUVIdFdEWGN4QlB2NW9IdjJ0L2lCQnpXait2S09EVXFyYTlaK2lZa2Y4dEN3?=
 =?utf-8?B?K0k4MzlkcThOT2plckZpamJ2Rk92aldwYjFnNldHdnJPVXRoK3hzYmRPM1NM?=
 =?utf-8?B?dmpPQUcyWFRDa0ZwTDI4Rmx6Z1pXa2k0bWRrbEFZSUU1K1JrYlAxZDcrTjNT?=
 =?utf-8?B?WnN2eHhvMDBOSW5udTVYM2Z3czFnPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18f7af00-7026-4cb8-a1d8-08db20a3dfbe
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 13:40:41.0346
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WQ44CydNN2c/fEzcPKfamF42PPCc68wSYwUVa5WnLEpyZZ058Onmeb1E1CEeWUZF+d4v8hZSKF3Kz3avh1bJGxPx/wWlgHTR6Rr+cAohEhg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB4412
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 09, 2023 at 01:26:18AM +0900, Leesoo Ahn wrote:
> The current codebase calls the function no matter net device has XDP
> programs or not. So the finalize function is being called everytime when RX
> bottom-half in progress. It needs a few machine instructions for nothing
> in the case that XDP programs are not attached at all.
> 
> Lets it call the function on a condition that if xdp_status variable has
> not zero value. That means XDP programs are attached to the net device
> and it should be finalized based on the variable.
> 
> The following instructions show that it's better than calling the function
> unconditionally.
> 
>   0.31 │6b8:   ldr     w0, [sp, #196]
>        │    ┌──cbz     w0, 6cc
>        │    │  mov     x1, x0
>        │    │  mov     x0, x27
>        │    │→ bl     stmmac_finalize_xdp_rx
>        │6cc:└─→ldr    x1, [sp, #176]
> 
> with 'if (xdp_status)' statement, jump to '6cc' label if xdp_status has
> zero value.
> 
> Signed-off-by: Leesoo Ahn <lsahn@ooseel.net>

Hi Leesoo,

I am curious to know if you considered going a step further and using
a static key.

Link: https://www.kernel.org/doc/html/latest/staging/static-keys.html

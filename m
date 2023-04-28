Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE556F1F20
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 22:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346481AbjD1UIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 16:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbjD1UIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 16:08:30 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2092.outbound.protection.outlook.com [40.107.102.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E99B326BF
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 13:08:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bwJBqE8Na3vv7IApt55d/13tnB/ZZ6teFdNLMX+Wh6O2D38OGq2oFMyI9G+9csZyLx9UBNZlos19wRA9HQRJzbm2wYNGymewtqGKb1ZZN+LbvK5ztqutJ6Lt1wNz7jJNvIY0LbsQ3z1NV2I/NCjIEJ4/sgTbE0wy2BdnarcddrVY1u8a0EZlv9J0OPoB5DHUTKk3h54v8q5hUBvKuTgF+V89Vb6VjTCXRDZD73QExWNAk5muuAqwHERihzOH6WrcE+1FhmJQt4bQiO1hqbZYqqFmQX/NvmsvjupDzHk4UKykg9bxX/PA/ao7MkqKszGNS3j/FB1LG+2J3vpf4N3wDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rxAmHPJRsX2TzQlFsKb59YA36nOQHakl8LnS3vLXvPI=;
 b=dAClvmubMd+nzkbd8zL5SqPdzl8iUcp+gdLvNghidLJr55v0cqyFsImt0avVGV8GjJAcpIojdEowIeWAjyXNnNZ0K922oPOE0lwMvrMwx/DdCJPPSL3sSZBAAtnPndJOokAnbsU74dCqexDUgHDXU5kxJzfvijPNs2NLz0Wh7ij+aN7nexn5yrPhLomdYHBGHeC9WmYQaWnx8dgNYoX27H51nB5WrvxhewVIdET2no6StyQoyB9mdR9id84H6wMipsSRHBSmREBXVNoEG/kHl9wm/2xUJPRAaydAkwltbeg+FW6EbNn0Yn+AeLQaqRzk0J3nYe7zLnL8sp1Th2Umew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rxAmHPJRsX2TzQlFsKb59YA36nOQHakl8LnS3vLXvPI=;
 b=uEUvnXYh8tO3UXt7b5bED84p2imL3sUXHE0auAuOKX9TzQxyMjGFC21q/fjNGvnWuK8mBkASPMlZq9IjoBrjfzFg5WlAOWk1jQUah8TQggtRT5JBRVQeZlTuz2Is2yqttP9F8Hl3se60MKWm/Hk4RZXZ5JYmK9pFXukl352VK7s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB4697.namprd13.prod.outlook.com (2603:10b6:610:c8::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.22; Fri, 28 Apr
 2023 20:08:15 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6340.022; Fri, 28 Apr 2023
 20:08:15 +0000
Date:   Fri, 28 Apr 2023 22:08:08 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Liang Li <liali@redhat.com>, Vincent Bernat <vincent@bernat.ch>
Subject: Re: [PATCHv2 net 3/4] selftests: forwarding: lib: add netns support
 for tc rule handle stats get
Message-ID: <ZEwnqMyZjJJy3ZNg@corigine.com>
References: <20230427033909.4109569-1-liuhangbin@gmail.com>
 <20230427033909.4109569-4-liuhangbin@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230427033909.4109569-4-liuhangbin@gmail.com>
X-ClientProxiedBy: AM9P193CA0024.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:20b:21e::29) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH0PR13MB4697:EE_
X-MS-Office365-Filtering-Correlation-Id: 1257da8a-0120-42ba-9e13-08db48244ce8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kkDAnQrpNbJEKfPKa8fR1XF8ESKUn4Huvd+SJHX/puRIgpvpXQhYF1JJ17TKcu/rkDg+rqci19idMqjuXiFOuLbkjM+B04V6L5MuvxHNjLrgx+aMRHrQmH6jBCuVdMnurUKF/UIYqngr79OjAZ8KUCCGSVgL01JL9p9tjP0cJNN09vaiA4qHeUHbLBzfTJFIP+u+gEQs5Cux/86WRo1ec8HzFBFuCD6R3bgNpt1MEcD2ZRZ+V03274YXBdeAZbY8+cx9UHCKz45YuKWK8APyRYgrN1a1D28oVw0voCAIT2i6LtNQTGZ0lgt5uKxf1XVk1fb1xIISI6gf/N1JLw91kcxj4GyZJ/xSOvWARiA43jD36jGNo0sdrpJ2tzjTE1XwXaPGZfj3h/A46UIDVNb6Vs8yqzLE3rGKU2ITu1aNUvXK4XXgeaOl9Rm/4DPa4wNIgNEGP7vjyqExhV63x1c8S9VthHSynBx2fRDnRg/efOUuZuHvlXdQ97FTM3kn6lPLA6enTGkcgyJDi8NLbXh6+QpiQUxaOmEsUbmydCUVjKfqW61rgKqz3qhSCmlKNBhL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39840400004)(396003)(136003)(366004)(346002)(451199021)(6666004)(2616005)(36756003)(86362001)(38100700002)(83380400001)(186003)(6506007)(6486002)(6512007)(6916009)(4744005)(66946007)(66476007)(66556008)(4326008)(2906002)(316002)(5660300002)(8936002)(8676002)(41300700001)(44832011)(478600001)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cNEi+u8/UL/H9mp1f1Jses2LV0TQry/uv1/unBnLEtLoMKmJwA+sfgukRG87?=
 =?us-ascii?Q?uSOHPTZikJGedKQM6ZOBpGbqjjPjgn75CZYUOkmyIrtekdsvg5L0wvjDPKyc?=
 =?us-ascii?Q?bmvD3pX6DoTPl4GfBTCWEXOiqDH2m56ebJ+KSLgT/oBWhPxnIeOPgkzDS6oI?=
 =?us-ascii?Q?qx29iZudmmTeE+2awdU1oauQxhb6ceuNqR6P8Zree98kF0qsslKayxf4K1uv?=
 =?us-ascii?Q?068Y8+r0eOf8M09ngjcar0DgG2wJqDQ/9a/ih5RYGJPw6OCOeSruxVJ8UadS?=
 =?us-ascii?Q?l6CJ61hZk7lNPdUYpYhAxkIFMdhdf7F1AIxS6G8H65eCb+oVuE2aZIZwA+4b?=
 =?us-ascii?Q?2X3pPCaHVWVQlDrvwD4roqrafkPJ9CbFhZuXXFV4WGL/tzUkWvsr8h4ljUYF?=
 =?us-ascii?Q?gCqSQhQ/lbXDtyF9uiTQs3s9XaG9MjWlo94pTD+nynqhlp6uTa2GC1w/ldeW?=
 =?us-ascii?Q?35KvclatALuMTksWoelE+Sbc9WeLKzooSuWmrOCTR9px7DQGqa79mCsn+F/K?=
 =?us-ascii?Q?uqXpnDC5N880wakj2qOFLOg03EBCX7z+HTAtDMiAIEVIKcp0F8Smys0SCi9s?=
 =?us-ascii?Q?AFyAN3xvopRm7MDpU4yPCBZ1ECKCk+TwNGsYXyq+SiECjSCZAy8ZoOjLwOvq?=
 =?us-ascii?Q?33x02SDPGJsaLciThm6NkmSEX9eVP98l5TgUOt0yOj9z5SCyQZXGtG/zADlt?=
 =?us-ascii?Q?bhwkEvPMJZSPIaxJGNUfFvtWDG058H4aBJMcV6A94OWwSit3VoSxP90IFOo/?=
 =?us-ascii?Q?UBlS1H8qUfSkcoh0yuT8cyoFJI4Tu7UvaXP5g6QohVgyPjd5gsV1bxIgQPxP?=
 =?us-ascii?Q?19PcQNJSLYtuDK14OZXwtW6VZCp5kFD2iyWOIdRNBKB5MaX7f5CprazzOgoW?=
 =?us-ascii?Q?0Y6fuiul2DfZoWGbDI1rjVokLiPRe+aie70geqhrpoflm6B91kTKTqKgCpYj?=
 =?us-ascii?Q?7bdV1QVfhdx86o+kduPkyAMP1URPfxLEIv0JlJS+hzU/P6h4bGeO6dcO6rAU?=
 =?us-ascii?Q?0agbHq6lfSC2qhidO0N/GAHdEQX3MxiR5SaICcnJl5HzvrlQXrw+0qSTEe7H?=
 =?us-ascii?Q?ZImvb8UkWFryxKaLZur3djFTj5PuYC1Wj62qzY7M/u8HDXlxB32a7H9and50?=
 =?us-ascii?Q?7jNM7AFB/+zuYc240UWZFALRVqeh8bxoKidE0B/9r9UDHyVvR47MeriY/Sf5?=
 =?us-ascii?Q?tBEO5etnm9HD6DkASWArWyLKoiG6S0rcebpxReTMlsU1n493rIFW0dDIrTiI?=
 =?us-ascii?Q?xEg7qRSGPz3+lp0+2dllvA3Do6oPxJ6hGXXI28iWL44k7LtchK2ovJrd4MFH?=
 =?us-ascii?Q?2iUSgvTRFnSL2ALN9afz90mktpJKJKAyJCgwy4sNU3Ij1bEwSihiFFUA1ZS0?=
 =?us-ascii?Q?Z4Hi4cfv9mjzR1bs97EtD7yCnxyeVkW8+GgguOtp/IebCSkxE9Bf+XfTlV1F?=
 =?us-ascii?Q?TZksnDthgItLdlc4mgd5COGJITypndGwAwjqAVmrdWBdpwS0OnH5WCU8W2Mz?=
 =?us-ascii?Q?TuIzHJVU7gYrQfo75Xy+ua4mDorDcsC7i0McRPLTo9R21rSd7e2hr5EV/xAB?=
 =?us-ascii?Q?AKrTQ58aA+9r12acWkbR5HdKa0m71IfQXikv1thm/YrER9IHNWjhKf3V4OXZ?=
 =?us-ascii?Q?vgjOv4kFEtqpmLDQxUH5oV5JClxgCvqRfIE6ku3UOPL5SZU7ewGaKCGKiHaw?=
 =?us-ascii?Q?gIeKYQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1257da8a-0120-42ba-9e13-08db48244ce8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2023 20:08:15.0938
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +fVnpGsAs2hxe4dSeD9BaOzaLd3UycBRtgmdWVtfCtub1xWAG8XYCfC4Nvbp4/MHP0BXQ+cf065fqX+N7UXAYEhkLghdBSmHwWFPzhNOGEg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB4697
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 27, 2023 at 11:39:08AM +0800, Hangbin Liu wrote:

Hi Hangbin,

a commit description should go here.
F.e. explaining why this change is being made.

> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  tools/testing/selftests/net/forwarding/lib.sh | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
> index d47499ba81c7..426bab05fe0a 100755
> --- a/tools/testing/selftests/net/forwarding/lib.sh
> +++ b/tools/testing/selftests/net/forwarding/lib.sh
> @@ -773,8 +773,9 @@ tc_rule_handle_stats_get()
>  	local id=$1; shift
>  	local handle=$1; shift
>  	local selector=${1:-.packets}; shift
> +	local netns=${1:-""}; shift
>  
> -	tc -j -s filter show $id \
> +	tc $netns -j -s filter show $id \
>  	    | jq ".[] | select(.options.handle == $handle) | \
>  		  .options.actions[0].stats$selector"
>  }
> -- 
> 2.38.1
> 

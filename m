Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9CD963D751
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 14:57:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbiK3N5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 08:57:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiK3N5V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 08:57:21 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2102.outbound.protection.outlook.com [40.107.220.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D19E4A5BA;
        Wed, 30 Nov 2022 05:57:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I3S5uh52fQlyYgQrStqd0f+ziA8XpdRZA5fwyM08mdQD40idNV1meypd27xPJ20PFn9kxfNeaVyedckkAbo2Zof1+PAipxEZH5drYmI6tBwfFPr83jhV4jKTzPJ5JLjd2YNkmIB5CmB9kPt9PzuWNSYH96BiBmXAKdlj/VX8dqO0No48cM8cNcF+kxyPbGxcGwb0oo6eiUMeB6Sh0D9VYFDkzbxnTr5M/CzHmUyBkneuvDhuSGM9FLdTFXGh4x8BMWvsT7MEKMU3qj5AKn83yCWYACa2JxJEwf669n8hQsuY/X4VCV3oJGaVUtSBNSbtBtWewG8IixksdHVQxoDNuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SimhOmgQ4eIVzie6zAStncGw/jX2asNiOELttGYvsvs=;
 b=kDnqJAlMIkiRmX4ie0JvIFTc4JCsJNJrynZa8ezI9KPweCo07mgC+RHEfjZ/rKYMvs41qQvouchpI1PHEOU31Tbjfg4F89FZ91oI4ZSgZV4T18kr8oiRe6zkQtJlolTzzFOKPjweDQhyKyewTfLiu/R1HU+xmINhkWRDDQ9gYfjpNvX5yYAMMxMt4dFoJdZHZU4JqHadBf1DXp/a/rS2icEbTdc6QAn2jEVeqK2ZyeTLWN7uZn2ah2endMZ8g68IYJdrDox/Lfm8hoyB8nU0Flw2q5wVeOJkXQT7uTkvvjsfoNIsbpiF6ZaLh6mFpC/8vVL/HMph3k1GZKdd9xHTIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SimhOmgQ4eIVzie6zAStncGw/jX2asNiOELttGYvsvs=;
 b=ky6TOZbdTGgeTf8FsmcuU3Xhr905YLUpM2A3SO38PNdjw2on0KlXz4wf2NA5IqENTnpYAaxrlXcqTed9Z7/6XoNFjjLSKYYP52fN/NV/gB+JW4xdXdXHCWmmbC0bmF2fMGolNBg5DPDB6yyBrHRBS9iSsJu2aunutLPXdWjUeOo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW4PR13MB5483.namprd13.prod.outlook.com (2603:10b6:303:181::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 30 Nov
 2022 13:57:13 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30%7]) with mapi id 15.20.5857.023; Wed, 30 Nov 2022
 13:57:13 +0000
Date:   Wed, 30 Nov 2022 14:57:06 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     zys.zljxml@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yushan Zhou <katrinzhou@tencent.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-tegra@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] net: tun: Remove redundant null checks before kfree
Message-ID: <Y4dhMhPswo5Y7DuU@corigine.com>
References: <20221129084329.92345-1-zys.zljxml@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221129084329.92345-1-zys.zljxml@gmail.com>
X-ClientProxiedBy: AS4P190CA0017.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d0::7) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW4PR13MB5483:EE_
X-MS-Office365-Filtering-Correlation-Id: 63301554-6244-4050-0c21-08dad2dac826
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YgNUaki81BR9xd/WTGFojZ/lSkMg2zRcifDVEn7FKZWXvlFhQgUQe6+HTWXnbEBSN4qtzUQLw0+MJyt2ykbjbwfqL6fPhAxmRy0PwV/lUG3hwIzRgGJ8iHpM2VBwSiIkMXWhBjzXi+6H+PPUMj2qcdibDWqzaWYGISDcNUnJ05Y5Uuil02/FCFv69SQbqzEFSQEG3PfIB1YTHvodTMBbfKALVIQRPkK7kH6qYDQGsaSLO3SBhtBD/OcXa/3niNp28T6OuDtbJLQCV89f2CbRioTOjNYnRMG7rXIre1pTKK7iPIF2xDB23ukLH26+Y0cU6qC6nEjSLdBILkYWVArl9GA8fi7iF6WXKvm8NeiEYffbL7sCLevXCHAIw8VFgevlpD3jsmtGcqUxR2AvKM0jUfvM4Pf7Q4Mgf1XXkwhaWDeRIGEB5OEoMv6FDc4MjxubJsqreibFG7CUxWGMgISE+4gvSxIPKojHkYb0NZE7ull7Fih2tjya9efIl0wY2GIUxiyog4f/l4S5xUJrq1c1P36Jj1ks869uu1EQNda1sLS/gro1ax1F3kNVSnU2bLoZ64Kphmhl6ej0T3olXwsq+JyNkKWq94EtsnFrEpB85GzqEmdGFEw9oArmA6JIx3ZJQErO21zPr3fN+YRXVExDjIANZRe42grg5sZ3bn6VAKAg1+05S87H0Y4ZvTfelFUV1ibP4b2F6DLNOdr8HOWXDPHIxp3h8RV51Pr7PiUV2vg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39840400004)(396003)(346002)(376002)(136003)(451199015)(86362001)(316002)(966005)(6486002)(478600001)(6916009)(54906003)(38100700002)(36756003)(6506007)(6512007)(186003)(83380400001)(2616005)(6666004)(66574015)(2906002)(44832011)(5660300002)(66946007)(7416002)(8936002)(4326008)(8676002)(66476007)(41300700001)(66556008)(357404004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dHpQcXoyWDhIQVVKQllOTU8zRVlqSFFFNDlOeXFvNDlNM0RraDFldmhrdExJ?=
 =?utf-8?B?ZGkxT3JVc3BxWDlIcTJhb25XRDVkQ1h1eXA5YTRkOGNxVlp6NVQ0a2FNZnFK?=
 =?utf-8?B?aWEwWURiRFN0bjJLMFd6MGZldFNLdGc4aUdQSFRhU0xzamcxVEVMZXJKUkVq?=
 =?utf-8?B?N1Z4cS9uSlZacmxGUkQxSkxKaWp1Wng2MFo3N3NxTUVFOXQzOWxXd3VGQTdK?=
 =?utf-8?B?MTFyeGZHa0J1emd4K3R4UFhvY293Z0ZqWk1KU0c0M2JnMXIwa0VrYWFPckEy?=
 =?utf-8?B?VWRXNzlPZWJ5Y0NEaTZmcmpnUXRpUkdvQW5BUlRLaFRlV1cyUXNNRFM1bkNi?=
 =?utf-8?B?eElkV3BXSGNtVWZ5RDdlZm51bmk4L0RJYlVhVGM2cUlvSy81Yk5VYzh2ak9M?=
 =?utf-8?B?NnRxOG9PK1dDSmVEVUZ4VFhpYlZnaVRjZFF1OG4zK1JBVGhvejUrdGYweUsw?=
 =?utf-8?B?anBqSHloMU41L2lFNnQvNHIzREt1S3Qyem13cWZ5RVlqVEYwdHpPV3RrVU5s?=
 =?utf-8?B?N3VDWE9lLzByVFBBc0lyRzZzY1hPank0WEhVVGtJaEJIamMwYXgwU2VBNytS?=
 =?utf-8?B?TkV0eTdvMm5Ga1k1ZndhSytDaC9YSjFBOGlBTDd0S0R0SDdOUitpeDZVVG1t?=
 =?utf-8?B?SlJHY2xybEg5NHV6QUpIYkdBamZwWDRDR2tWMzNENkRsYy8yMllhaEI0QmtG?=
 =?utf-8?B?UGpvMWdJWllJajZEL0t5SmhCN3AxdWMzWjB3YUdRdm1XaWNSNGhLeWRKZmlI?=
 =?utf-8?B?S01tS2JUblBhMFgzV0hIc1dCZTJUUno5eXFlWlQ5NnFuZTZXT2xYdnJHdXdp?=
 =?utf-8?B?U2lQR25rNzd0aERNc1ljRWtZUURGQ2hUOGg5OUNmSlIxaUtFVmZGVjJ0Tk05?=
 =?utf-8?B?NGpjK1prb2pXYjF1SUoyMmZlcUxsS2ZUdzludnhnbU1LV0hxcmRvMG1YNGhq?=
 =?utf-8?B?NUo1NTVBcGRRa1VHL2lHZ1U0a2VHUzZzc28xdk92MzNoaGlTNk1iZ0VsQzND?=
 =?utf-8?B?ODRMb3M4bFRTNUNHeWlheHloT1duY2x3WktLdHlhQWxhL09jaTg3eHMxYmRn?=
 =?utf-8?B?c1dVYU9XQ3VZQ1BCRzRyeTM1a0RsdjBoY2haL3g2WXRCbTVuUEgvSjVZM1do?=
 =?utf-8?B?dTNxL0ZHUHd1eFByWUU5VzhTRXdoQUJuS2VRMEkrVW5iaXNPZG10VVJqOUM5?=
 =?utf-8?B?UzRiVUZSU0Yrbm1CTDBpOGVrMEdzNUNmODZoWFcrRm1BdXRjTmw5NzBLelVX?=
 =?utf-8?B?UE1qMlcvTHdKeTV2cUhwdnhRZGQ2amhGTkJsWkdKR1FmQ0xQSXFwZnBtcTNB?=
 =?utf-8?B?MWJrdkVES3pYRGxsblBOSTN2T3p3aGdCczFucTVxN1RDejlMNWliT3RtMWE4?=
 =?utf-8?B?cWFBWVl4NEdrRE45dUUzWVJQUjdtK0w5dFlqSGJxRFlna2lUcFdRNlBZeWh1?=
 =?utf-8?B?dW8zdWFxSytsZkJYY3BnYWJGcHRFOEl3WWlJWWY1TGduamh4eGdmQzVEblpU?=
 =?utf-8?B?MUQrem5OeGVGeUpuVHg0OHo1NnE3Z0Jabm1ETlh3c0Q4ZUNZemh4TWlleDZW?=
 =?utf-8?B?eDdQNmhxQW9KdmpRejdaZk5ZM203QkV4N2gyS0lLeDg2SExOUEdqK3F1WEZW?=
 =?utf-8?B?VUxtZm1iOE1EOVZaeFpvM20yV3hNcWxvWXIyMmhGbmF1d2Rud3hXU2pyZVV4?=
 =?utf-8?B?emNvb0V4VWZ3bUwrTWxBOWI0c1FqSW5UNldlR1JodEZINnFxQkpSNmNrb3RF?=
 =?utf-8?B?Mkp0WXoxWWlXN0FKWDNqbGhUYzBWSnR2UlZEZlBSNGh5aThwOXJYc3cvZFJG?=
 =?utf-8?B?cDJldnlWV3pyRVlNbU81Y3RKMjFhSWFkYk4zUVpEZW4yNGhwYVI1ajRNd08w?=
 =?utf-8?B?SkE1SmlXWWpZNzdPR2kya0hLN1hOeG9URFVBNDBONzU4QWVXeWNiN2lhaG9E?=
 =?utf-8?B?NCtNUngrM3lnV1ZJaXAxckdCVUtzZWdGaEF2ZXNYQjhUYjRCcXQ3VWhGNnFR?=
 =?utf-8?B?VWRSbGlUWFM3K1dsaHZrY0k1OGFtTG91eGwrZjJaQWVyV0JMSnBkRVpqU3Rr?=
 =?utf-8?B?MDZpZ1FwN0tuVXY1MTdObmJvQVlBaHYzaCtnd21QbERTanNzcllkNFJYK3Ra?=
 =?utf-8?B?UUo4WWU0UU8rZXkzNlNQeGQxU3VHY1RiOFRzcEowSGNnUWlEVDRRLzFqTm1O?=
 =?utf-8?B?UmpLaVU1TjY4Nk1yNlVqenR4aGp1c0pPbEF6MUN4ZEFZc3JJdWRacENPcFhU?=
 =?utf-8?B?VVRHRHpabzRtN2NjcEpNdk8rNGFBPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63301554-6244-4050-0c21-08dad2dac826
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2022 13:57:13.0873
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: leSMybdwpiAfB9AddVZiKEVUu4aIczNI+GUjGiVZ+lMxiXuNyXhtnQcYusprXF68Lq3HasZDwzaWBYN2X1RR9yiP2zZ5pvw/4EMsSZScbBI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR13MB5483
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,T_SPF_TEMPERROR autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ Thierry Reding, linux-tegra, dri-devel

On Tue, Nov 29, 2022 at 04:43:29PM +0800, zys.zljxml@gmail.com wrote:
> From: Yushan Zhou <katrinzhou@tencent.com>
> 
> Fix the following coccicheck warning:
> ./drivers/gpu/host1x/fence.c:97:2-7: WARNING:
> NULL check before some freeing functions is not needed.
> 
> Signed-off-by: Yushan Zhou <katrinzhou@tencent.com>

Hi,

the change in the patch looks good to me.
However, it does not appear to be a networking patch,
so I think you have sent it to the wrong place.

With reference to:

$ ./scripts/get_maintainer.pl drivers/gpu/host1x/fence.c
Thierry Reding <thierry.reding@gmail.com> (supporter:DRM DRIVERS FOR NVIDIA TEGRA)
David Airlie <airlied@gmail.com> (maintainer:DRM DRIVERS)
Daniel Vetter <daniel@ffwll.ch> (maintainer:DRM DRIVERS)
Sumit Semwal <sumit.semwal@linaro.org> (maintainer:DMA BUFFER SHARING FRAMEWORK)
"Christian König" <christian.koenig@amd.com> (maintainer:DMA BUFFER SHARING FRAMEWORK)
dri-devel@lists.freedesktop.org (open list:DRM DRIVERS FOR NVIDIA TEGRA)
linux-tegra@vger.kernel.org (open list:DRM DRIVERS FOR NVIDIA TEGRA)
linux-kernel@vger.kernel.org (open list)
linux-media@vger.kernel.org (open list:DMA BUFFER SHARING FRAMEWORK)
linaro-mm-sig@lists.linaro.org (moderated list:DMA BUFFER SHARING FRAMEWORK)

And https://lore.kernel.org/dri-devel/39c44dce203112a8dfe279e8e2c4ad164e3cf5e5.1666275461.git.robin.murphy@arm.com/

I would suggest that the patch subject should be:

 [PATCH] gpu: host1x: Remove redundant null check before kfree

And you should send it:

  To: Thierry Reding <thierry.reding@gmail.com>
  Cc: linux-tegra@vger.kernel.org, dri-devel@lists.freedesktop.org

> ---
>  drivers/gpu/host1x/fence.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/host1x/fence.c b/drivers/gpu/host1x/fence.c
> index ecab72882192..05b36bfc8b74 100644
> --- a/drivers/gpu/host1x/fence.c
> +++ b/drivers/gpu/host1x/fence.c
> @@ -93,8 +93,7 @@ static void host1x_syncpt_fence_release(struct dma_fence *f)
>  {
>         struct host1x_syncpt_fence *sf = to_host1x_fence(f);
> 
> -       if (sf->waiter)
> -               kfree(sf->waiter);
> +       kfree(sf->waiter);
> 
>         dma_fence_free(f);
>  }
> --
> 2.27.0
> 

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E21F56B3E85
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 12:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbjCJL5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 06:57:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbjCJL5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 06:57:31 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2119.outbound.protection.outlook.com [40.107.223.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC6EDE41FF;
        Fri, 10 Mar 2023 03:57:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fx/heQZbjg6K+F05oUUENuz2ehDksE7FREYqfYMsi5gZBTKsJ33ww9KTW8JQ6gG+7HkwqlNevbhUQXPvNErvVtUdziawKHi6f0al8CT0uBfEtFopuR+xjnS7ptfNCbcSb69cb+6xsg8OoF2H7zbeaaAjEp8b5ojawKDuqA7xO/veFqFZGmJziUfhOt754RC9vSlAT8c9W4w+AIl4gHH5mTf2sUx2eeEtRT7ldfn+nV8o7vvjkRu5uqWPs0LsAX+MEMK1RIX4HKLAiFCmFiQ9Yx+gjQwDAUvxnx/zREts9LuhtTcA02c/8TPkymrVIf09tQ0WO1g/FP7Yi078vT4TYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H/hFWaW5iKI9o+blHT06OKo4Yi0nloTnJ7Ou4+f0Sds=;
 b=bBD33wPzFusbDYevHW3dNh/6BJt+mv5d2ucHvUj1kZogy1TNW98XNZIyRyoODxl9R+xMKLgkuiC7Moi/u5zsXdWUoMkQSbC/kmgDBXn50SS2PGZZlg4I1bCIsdOGswh69k6vxY01WjcWdy53pTiBjnFze8142HVp1HHjvr4xIS8Du/Ae6k98JF5I9yMKlc2g595FOaRGNtnLuATxhHtWUe9Q+r86qag+vLSCrLtIK7nHcwOKvVyjI++59WnICCtw9zFaE85/d87/FoHAF4YIG5m0SM5HwXsZzTH9eVmrXnjPK5vTsVFFAkO/xdztzz5NcT6TugP0V2AG5koPEWqxcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H/hFWaW5iKI9o+blHT06OKo4Yi0nloTnJ7Ou4+f0Sds=;
 b=hipU680Q/EZTTlZulcIiC9QgN5w2rT4koADFU7KOTk0qX5/rJQXCOI1Aqc+It1xzogm5Kg5ZO7+/rlyMyjFe6D93/Ek+jwl2nBsk4e6tCnYj2o3oNh9Lx7hLtqKJXeNWxlHKjIieV2HPWdk/dLU4X58yKMrhUvIMBXARYkMPnVA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB3633.namprd13.prod.outlook.com (2603:10b6:a03:220::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.20; Fri, 10 Mar
 2023 11:57:27 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.020; Fri, 10 Mar 2023
 11:57:27 +0000
Date:   Fri, 10 Mar 2023 12:57:20 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Fedor Pchelkin <pchelkin@ispras.ru>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Minsuk Kang <linuxlovemin@yonsei.ac.kr>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org,
        syzbot+1e608ba4217c96d1952f@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] nfc: pn533: initialize struct pn533_out_arg properly
Message-ID: <ZAsbIB4fk8KhhTpF@corigine.com>
References: <20230308183035.0fb2febd@kernel.org>
 <20230309165050.207390-1-pchelkin@ispras.ru>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230309165050.207390-1-pchelkin@ispras.ru>
X-ClientProxiedBy: AM0PR08CA0032.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::45) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY5PR13MB3633:EE_
X-MS-Office365-Filtering-Correlation-Id: e3e48997-0b74-4934-2b0d-08db215e9e99
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cCpG6z3s5C4faGUb3Ll73Tg4Ow32Jnr80oqi/qKQgAG+IWlLTCIy4oLQ702AU+yZmF7CuoJB6QZFfs1gbB6PU4y9wkON0Opm2P3q3ehdF/i6mi63Aaej8JBwaBIan+gVBwU0nZY5CxXGgN9Q1bQ1Px7cdnOEvx1BKpGivKOfHMe7rsio4c043LBnMJRi9PeAixdGitZWzjwQKGu3cd0mNIAM1/YEJNiSh7eUHk+fxGE8J1QedwKdrPDO32rlrEo/BW73OpZB0l8u/vAS7TPyhm/7w1BYm6yoEVGySClZa3jnHBSi8MuRGUdU1HTnIenQuphkQncX7wFrIQ9jPi0Y/nph7K8/IW+BYnGgJ328BngJx4OULlQcBwYYMmLqsHvGCruhQqRjNyFaYBdorK+fWW5uVfA8fSti6zXJtyaVtnwOiu9b9VkYyXkBR4qFf3cK55TMfDtcxBgmpdL1sJzaXsuDxSWEACxXWTiIs7genW2ZvtVXBz6AKaho2u5PUDdQzKS28Ipb/ZA33bLHG6LlDbMlfiL7VA0tai1AIciMBFeLnpWXGBjGnLCUS3CUGNcrQJY7FopNvlnETQoBo3HdGCyZGUaNs31XYPgkM8yVvr4eyo/DYAS+6JhDkyuU+101rwDVVjv3/xRDpih0FW8SsNdNd33rBWxoMW9xZ6zFmgIs+SCIKlabPVJTShXB9CYs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39830400003)(396003)(366004)(346002)(376002)(451199018)(6666004)(83380400001)(36756003)(478600001)(54906003)(316002)(38100700002)(6486002)(2616005)(6506007)(6512007)(186003)(7416002)(2906002)(5660300002)(44832011)(8676002)(66476007)(66556008)(6916009)(41300700001)(8936002)(66946007)(4326008)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?o7rPQmxfCzMWWRg1pvFb8Ij5KzVCWDPa0ZLCbqUTnNDCpu+1FlY4JoYXELhq?=
 =?us-ascii?Q?udQ856jXlFnVISCou/jN6mV3P37c1IN0tkAiJg7FXOT3EtUj87LqLc0bjNuP?=
 =?us-ascii?Q?/K5+S2zOu++qW50bAjFFnnL1u1lQBtmrhIKtw5XdB2u/WLMSMGn4Ffhc2nAW?=
 =?us-ascii?Q?zTivHHmYM5SlfmXEHlwO3RtBMH6rm2J1h1dQM33p/XMgWJcHefYiSNzFYTzA?=
 =?us-ascii?Q?c6RCmxaDNAFI1514JGdws/oB16TOJoAhx22fmfSEZO2DDV/zihEjLvxoQOfc?=
 =?us-ascii?Q?18/XehzU+Orw151vtTbwvF5TDBEckc/IskZBig7slWqTFY6PbVoTZD/LFlod?=
 =?us-ascii?Q?3t3xiKH/TvZpoKq+0nfMk0SZ1p7FP4Lof2k7pwClGAHTfggUj+29ZzK5eaCI?=
 =?us-ascii?Q?gzOKBZtgV4C+GcTMN9gkJmh3LvD/gv+JN/DaAuUWWBacgBOqnySUxRSRxkYv?=
 =?us-ascii?Q?yZUzTbMhA2f5gIbeDcr92AkoumyHE1nLKVqXVTtaqNQ86II0vIL14lHqO7K8?=
 =?us-ascii?Q?BpI+Ybgtrhfvqsuj/dAPHp2QNqXG9ascCA2EpvdAzNvEF6pSTZPL555Z+tTp?=
 =?us-ascii?Q?UnRw4evEro/v22WwmlymeD3CT553s+uypDZbdcjCfDjwY7uWMrhiJKz9Szg7?=
 =?us-ascii?Q?1/Gi5bR9dAFl1BkA07dtUineJklSfosmOoBei6W964tvbGcmG4QzKRZMjfea?=
 =?us-ascii?Q?4kRg64YN5HSUH0JBdrrMZ6QY2AuGghPVogb0UhWrSfCrXiVaPJpGxK0D7oGw?=
 =?us-ascii?Q?DskPL5K+lENNTyAtsJX072k4WhGuqQURAkl0mfzvrxvESptroErifVQHXurC?=
 =?us-ascii?Q?6ouwei/FszEsQSXXaZ8w+/s8O8lVsVxAEJN6ZNSXauqOstUwi5uMyanxP/Va?=
 =?us-ascii?Q?+whyNfotlGZU0OosfGyyG1ZVlcjia0XJ5rxb0Hc5WM2J927DBCIoulxtc+GI?=
 =?us-ascii?Q?fFxoJHZrsGHkAbuTmn32WzDm8keUomESJmmhW66/tiI7Xd3uBhA3NKg5Vm8S?=
 =?us-ascii?Q?3qZgLSDlDcAoEAW2uL+sKXSmT/BFowhmiv6lWKGQlrzrpWBlhFAE60ks64WV?=
 =?us-ascii?Q?MXQBYt8C0Dh2gLXkuqT93aEJd8zcnw5VaSBmRxqkxZ+gJEgZH7njHlZAmEnh?=
 =?us-ascii?Q?MIIGvI5Qwdo/eHcx5TbRKrF2qFMbLPqfmhMJczo1Q3E1loKzzP2A6g/vf2sF?=
 =?us-ascii?Q?xnr2HLFHmGMzfYlTUwsAj2hvdXYFkoESwSfPFYoG8TOZZcAxguPzVbBSZI1o?=
 =?us-ascii?Q?Pb+eJRdMw+KJA6qHcjrNs2Fr5kcfCY3NOvAG5x2+3ml7tPWFQ//b4t88chOv?=
 =?us-ascii?Q?UKYOK24Gz1ugcQ5oFk9Dd/24L4P5DeqzCERMBcKjrPXdGMWx8ukwkaJLPYhu?=
 =?us-ascii?Q?7q5u2vRtORQsIU8E9vE18RQBBV0OMJ/u164TDqKuw3qFMMnftxQlZoPCehtR?=
 =?us-ascii?Q?OrtFCx4K3yy87fcIftszbQvzfLt7c0pYARi+v7mgWV/4wajRRO3nUc8dDSGY?=
 =?us-ascii?Q?DiDPjTjGjOZ9hEaBS7gbIw6JQuDuBUHaZWSn+4w0vce7kDjemICU52YbrwA7?=
 =?us-ascii?Q?QN0OtacFptxb7/3cmDXeTJoUjiSXf0ove4PKvLWKoh7aJScZTaGb5M394O6q?=
 =?us-ascii?Q?zKB/vRPu3i4Eothwk9ofiZkSEx4MT1tGdHhLWBV9DZSeyQJzKlhcEA1YrzCg?=
 =?us-ascii?Q?lJrTbA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3e48997-0b74-4934-2b0d-08db215e9e99
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 11:57:27.6412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yfTSVkf4iVZ5/YiO6Jtm2AMh30XrR9PGQrjMnTrEDZJPKbBUSkoIDCmHf6RLDNF0p7l9gtNL4Wl1FlILK0l5ujOmQhbSXHcs/2qjrYnID5c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3633
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 09, 2023 at 07:50:50PM +0300, Fedor Pchelkin wrote:
> struct pn533_out_arg used as a temporary context for out_urb is not
> initialized properly. Its uninitialized 'phy' field can be dereferenced in
> error cases inside pn533_out_complete() callback function. It causes the
> following failure:
> 
> general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> CPU: 1 PID: 0 Comm: swapper/1 Not tainted 6.2.0-rc3-next-20230110-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> RIP: 0010:pn533_out_complete.cold+0x15/0x44 drivers/nfc/pn533/usb.c:441
> Call Trace:
>  <IRQ>
>  __usb_hcd_giveback_urb+0x2b6/0x5c0 drivers/usb/core/hcd.c:1671
>  usb_hcd_giveback_urb+0x384/0x430 drivers/usb/core/hcd.c:1754
>  dummy_timer+0x1203/0x32d0 drivers/usb/gadget/udc/dummy_hcd.c:1988
>  call_timer_fn+0x1da/0x800 kernel/time/timer.c:1700
>  expire_timers+0x234/0x330 kernel/time/timer.c:1751
>  __run_timers kernel/time/timer.c:2022 [inline]
>  __run_timers kernel/time/timer.c:1995 [inline]
>  run_timer_softirq+0x326/0x910 kernel/time/timer.c:2035
>  __do_softirq+0x1fb/0xaf6 kernel/softirq.c:571
>  invoke_softirq kernel/softirq.c:445 [inline]
>  __irq_exit_rcu+0x123/0x180 kernel/softirq.c:650
>  irq_exit_rcu+0x9/0x20 kernel/softirq.c:662
>  sysvec_apic_timer_interrupt+0x97/0xc0 arch/x86/kernel/apic/apic.c:1107
> 
> Initialize the field with the pn533_usb_phy currently used.
> 
> Found by Linux Verification Center (linuxtesting.org) with Syzkaller.
> 
> Fixes: 9dab880d675b ("nfc: pn533: Wait for out_urb's completion in pn533_usb_send_frame()")
> Reported-by: syzbot+1e608ba4217c96d1952f@syzkaller.appspotmail.com
> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


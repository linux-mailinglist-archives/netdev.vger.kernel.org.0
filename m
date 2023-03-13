Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4706B8234
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 21:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbjCMUHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 16:07:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbjCMUH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 16:07:27 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2101.outbound.protection.outlook.com [40.107.93.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D02F5D466;
        Mon, 13 Mar 2023 13:07:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VACqJaFP2RXQyBM/lbqSK4sGHr6A2NbiYLYNY8U/PKZZ4xUVdaUAP/u33Euslfbk+K+1XVXnTREE8xFJPSLL4rnoaknvFdJLftfG2y18j30ZhJ3RqlqrkIHXqNgHT5yRPUWncW2E2va74n3a5u4cISMYSTxN9v7eNIMSq2brBqc5cSty6+4gRNIiIRBLwfY4Od1zF1569dj1NlC7XKcytrIxTN3OmbpTg09nxexhf5AWl529cCHyRm1Kx9y30RebUoMDWw6mnTr6OMm2+o67iA9lP9MV4pp194YDyHpS1z69bUPYDPr0kD5B9R652elcPRL+yVkYquhKXu5V4FPAvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5+YeJ2uLbjq1GybEmunfFZX0z0OiOiBoGmPNCohxB8c=;
 b=KQASdKzhQodqQRBXLSNjMF8EDj1hGOj7QZzXGUAAyDg9P+wPCCwMhPjmgxtokiSo3o1OD6m5VrFxIIWMSL0IHiMt8gmM1vUjmWL9Ml35LFni+lmnWNsm+tLM3hDLmukJSLrzV7ytuRPnfk37AQVIRC6MA66pvzg1AcCV5HALXRzpSzCSm878XvHhCR4PfGq/xQIYjXSvjTaREFAjcPQmw7tbvghkpiPrmZAGmRKpgnak8V7Wi+D/paYEfBHni0Ygv0UTWu8RQIWTHXlLxIUTS5hMwiQ6TuFbxpqfDgaEdWmJDkB8d7IGMdJzkI8kAWLCPIYNwkM2yQeigHvdPUtJZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5+YeJ2uLbjq1GybEmunfFZX0z0OiOiBoGmPNCohxB8c=;
 b=Fe+nNkY3sO6b1AYLcFPkGeafJoR7lalGPilEGJlbp0iSCeofGbXjyqS8EhXZdN4d97YOwxFiBKf8MQjPu1KufFpyrXDLn1VK8ei9ehbf5lyc7BZlt2AL7YjffozU8YTJRTY2QNQDcbtemVLlxRdlP/bILJlLnREZ6koW3ScgoJE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5320.namprd13.prod.outlook.com (2603:10b6:a03:3dc::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 20:07:21 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 20:07:21 +0000
Date:   Mon, 13 Mar 2023 21:07:11 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jason Xing <kerneljasonxing@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, kuniyu@amazon.com,
        liuhangbin@gmail.com, xiangxia.m.yue@gmail.com, jiri@nvidia.com,
        andy.ren@getcruise.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Xing <kernelxing@tencent.com>
Subject: Re: [PATCH net-next] net: introduce budget_squeeze to help us tune
 rx behavior
Message-ID: <ZA+CbyVQxsKQ4BLp@corigine.com>
References: <20230311163614.92296-1-kerneljasonxing@gmail.com>
 <CAL+tcoAwodpnE2NjMLPhBbmHUvmKMgSykqx0EQ4YZaQHjrx0Hw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL+tcoAwodpnE2NjMLPhBbmHUvmKMgSykqx0EQ4YZaQHjrx0Hw@mail.gmail.com>
X-ClientProxiedBy: AM0PR04CA0066.eurprd04.prod.outlook.com
 (2603:10a6:208:1::43) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5320:EE_
X-MS-Office365-Filtering-Correlation-Id: 9858bbb3-470c-4ce0-ae43-08db23fe8d9d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QJ3PVb2lqLlNxKpdlkFt/j8cKrZ52CzLE8i6MQlONu3fBVTSfsmJdgK4AlMR/j+9pflZ6JeruNw357PE0to4NEjev09ISp9TR66dvvCFBGuyung5+NRcSPFVdW+ne9yg9QGlx7KJZ4Gi8mD4FH5Vfj4usFL+acZDQJqEcig9bfBArSXWPkCcrEdxInmA5Dlg9lBN2MDwopeHE9XtUEkZd/eqZC+XfmKjykI0IoBfapVjRVE0BTterUZjg07QHnAD5fis/0d3bh0eeygXup9s5jEx+vT9qRWolxK7kI5/zCE3XFNnDfOUaL9GZH1/eYsdiCZ3y3pWFGJES7lKac71RQYSLKOOhAN6IIoHvwZ1DCKZ/HOt17vLux48Id99Yb58HBkg07MuxneetBGr4VZ6iRiX6d+2SkrtC8+JZqgFa8NSmJYA/D8j+Ow7CwQ30oNF9JdU6LoVR5FusP8VsEfHV2cG9jRtbJpI8Q4dABGTl8nMMYYYyMBQayC0Oc11s+HHCeMLMu+F+5zoAIrIzGn+sYMRq8Qt3TNmV7vqcBZyo99GIh6F+usO+hFhZU6eIMXJScZfyt0jprOBlvapO0i13vcd18UVkmqrBkHcw9Z6higmnLIdH3+Fb2z0qUX/ERa8mF3UllWS8OWDUzXjq191dadQ+8y1bIxqx/TzwxMcdIK67xCweAvTITLsu3Gx8Fu3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(39840400004)(376002)(396003)(136003)(451199018)(8936002)(478600001)(41300700001)(8676002)(66946007)(66476007)(6916009)(66556008)(4326008)(86362001)(36756003)(38100700002)(6506007)(6512007)(186003)(53546011)(6666004)(966005)(6486002)(2906002)(7416002)(44832011)(5660300002)(316002)(83380400001)(2616005)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Titwam9HOTlIN0hkcDZDM28wVUtuOExUUEFLSlk1cEd0TzBZZVQ0M0dyVHNj?=
 =?utf-8?B?ZjYyenVxOXIwcERrazlLS2tqaGc1Qk5aMmgvNWh2ZEZtb1RCR3o3SkJVc0Ny?=
 =?utf-8?B?K0RPWUFCdjhITC9OdkdiRjVOaVZjQWx5aU9JTWl5WXUyd1BQYm03SE5GemtF?=
 =?utf-8?B?Z1ZWcitRUm9kTWtrdStoSnB1Qy9zckk1NVRjOXp4MDIvc3VvcGt6R3VsWnRw?=
 =?utf-8?B?d08wMEVoTVBacno1UTNvU0dObEZqd0kwSlBITExlbksrQitoWllkMHZqZk1Y?=
 =?utf-8?B?b2ZhRUtsNzBOdkJyV2JLT2kwdEhtaVhuNG9lU1lsaVJrZnlySEtSR1NpSFlO?=
 =?utf-8?B?RU96dGxsNWh1L0syQnN6NlY2OGd2K01IZ3NKWWFqbGN6bW1YVkRueXp0MUla?=
 =?utf-8?B?RkpvUTY3REUrUk9QWWNqa2JEMitZd0xQVFVBSUN3N0E0eE44RFJVU3FpckM0?=
 =?utf-8?B?TUlqOVBsZ2FpWjV6NytEODJwRFUyOVdYODM1eTZubGQ4U1JJSnRBS1lLMkdP?=
 =?utf-8?B?b1BtRGxsRXNZbUpna3N6ZlhoQzZFZk5MdnRyZUVIYm96dnVvcU9xL0U5dy9v?=
 =?utf-8?B?ZXhsQ294TUdZazhnWExWNEI2UDNPNWtuTU55TmthZGxCVFA5ajBDREJSRTc3?=
 =?utf-8?B?K1VZYVhIdzhHUW9SaXNXKzJTeXg1a1AwSkhrVE1GMFFKVkExaGMwNDMySSta?=
 =?utf-8?B?Q292Unhha3hTMGJ2Mmt2Sk1mSjJHQmJjOWFBMTRQVnlHa0JXQjJMMlJUdzRF?=
 =?utf-8?B?VDA3Z0YxV3JwSzZ6WFZkcCs3YmVUUnN4ZHl1cUpkSXpTWE50R1dFbnVQcVBu?=
 =?utf-8?B?clY4cVUvdWY4S0pxcjMzWWJFYlhhUzdXdU0wSFdMaTBDS3lqY2dDTEI4STVL?=
 =?utf-8?B?Y2ZJNVNwSHl2SmlBYm43RnVpTnVFeTJWcTluQ21wQXJqOTlsU2Z6aTFTWWtE?=
 =?utf-8?B?WjY3UXdKUWdpQjFrUUl6VDhRWkJVOEFwMGFEeHJETmlZOE00Q3M0dnYyNy9r?=
 =?utf-8?B?aFQ2d3Z6am4veGVrYlludHc5QndtdXNpRk1yQnZUSmJHSmdWMHNoVEEyMnEy?=
 =?utf-8?B?TkwrN2tXSDdtZGIvdUl4MlgrYUNlY0JpTHdNQ0x1MXJrckd0SkRObXZRZnBx?=
 =?utf-8?B?bWh6ZXAwZVZMNlE0eGhEK21iUmRzdE9WYmgwRS9YdGNGekJNRG9EUG91elFY?=
 =?utf-8?B?ZmRtdmVxTkQ2Z1Z0T3JPd3kxVmd4NHNTOFowQS92K0JFWFBLRW1CQ01BRGRv?=
 =?utf-8?B?bS9IeGFYNjhhZnI2TXd4djhVSlRkWDdZMkwwa3JoZi9uMGZZTzhldzJsaEY2?=
 =?utf-8?B?UDdHZFBHYit0b0IzSU5ySW5odlRjT3JxczFsQlg4ZXBjM2p0YlJNYXVmZXNm?=
 =?utf-8?B?V3VUTzB3RGd1UGhzR3RLbzFUOFM3b2ljQ1FlQmxkdmZzcWU5bXo3RTZnRjds?=
 =?utf-8?B?dHZ2TThOdWtvT2srcVNJa1g4YXlzYlBPRCtEQld0RDJ4M0d6TExmaGdPQmF5?=
 =?utf-8?B?bjFXVkdodUhaVkp3WFlaWHk5UTYwZDUveXMzd002MFpEaDltZ2VuZDBGV0Fk?=
 =?utf-8?B?YUcrdmRPRFVCNmVBRjBUbE9KNmZkQVozdWV3b003ZUJQVTR4cTF6WksxQ0h5?=
 =?utf-8?B?UjY0dmE0emxaYWpuNUNzTHZ4KzJTUkowanFvUnBPZ28rM0hKM2grdmZZRzF2?=
 =?utf-8?B?SE5PVlFEbkRmZXcydmxwalZqOHcvaHpsUlp4SDBhd2Iyd0JYL3FyOTRsL3Zn?=
 =?utf-8?B?K0IzSzlHVXRtNHk0VWlLdGVtR1lub0xiY095SWd2SW1ldi94bmx6NVZpdjhV?=
 =?utf-8?B?WkdiMzBSRk5LaWUvYUhUVWNQa29lSS9TeFlubkhUMW1tek40ZWxkK00yUEtw?=
 =?utf-8?B?ZHFEeVh1OUgrY0U2bVdZQzg5cEEwNnZROVhlWTFsU3dNdlpuSldYN3JoNEhn?=
 =?utf-8?B?RmtTQWtETzBpelhtVm1jalhnQjBuRHQrZjlTbjBoNW9TeWJ1dm9vWWorbTFG?=
 =?utf-8?B?VE1IbTEySXpqYVVQUXIyOHFGZHBhSDVhcFhYaGEvai9lblpMR1hJWG4xVkgv?=
 =?utf-8?B?ZGJXZUh0TDYxeUttZTJ0Y0IrN1RXYzN1dllmVGhjLzBZeEpBVnovRDJHTEwx?=
 =?utf-8?B?T2NWc2JubXFzSkRtaXB2T1I3ekNleWZ1TlBnS1R1dXVJNHg2YzVFN01raDQw?=
 =?utf-8?B?MEVSN0c1UUJRam93eWk5cUJKb2wxMFZtUTZpSGpIL0ROWWtqUzA4UVllU0RY?=
 =?utf-8?B?NHpPZGlZUlVXdHNMSzBXOExJWk5RPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9858bbb3-470c-4ce0-ae43-08db23fe8d9d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 20:07:21.1465
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h02FrQ4AXHF7wYyYzz+CcXbjU6vNAdcO25cpA+/Ko9g46WUIP1dTfM7Qq3gWuWGjZqnn4zh6bk6XzXUQudXShq0GAVImNFBiEJDNnIwMAP0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5320
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 10:05:18AM +0800, Jason Xing wrote:
> On Sun, Mar 12, 2023 at 12:36 AM Jason Xing <kerneljasonxing@gmail.com> wrote:
> >
> > From: Jason Xing <kernelxing@tencent.com>
> >
> > When we encounter some performance issue and then get lost on how
> > to tune the budget limit and time limit in net_rx_action() function,
> > we can separately counting both of them to avoid the confusion.
> >
> > Signed-off-by: Jason Xing <kernelxing@tencent.com>
> > ---
> > note: this commit is based on the link as below:
> > https://lore.kernel.org/lkml/20230311151756.83302-1-kerneljasonxing@gmail.com/
> > ---
> >  include/linux/netdevice.h |  1 +
> >  net/core/dev.c            | 12 ++++++++----
> >  net/core/net-procfs.c     |  9 ++++++---
> >  3 files changed, 15 insertions(+), 7 deletions(-)
> >
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index 6a14b7b11766..5736311a2133 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -3157,6 +3157,7 @@ struct softnet_data {
> >         /* stats */
> >         unsigned int            processed;
> >         unsigned int            time_squeeze;
> > +       unsigned int            budget_squeeze;
> >  #ifdef CONFIG_RPS
> >         struct softnet_data     *rps_ipi_list;
> >  #endif
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 253584777101..bed7a68fdb5d 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -6637,6 +6637,7 @@ static __latent_entropy void net_rx_action(struct softirq_action *h)
> >         unsigned long time_limit = jiffies +
> >                 usecs_to_jiffies(READ_ONCE(netdev_budget_usecs));
> >         int budget = READ_ONCE(netdev_budget);
> > +       bool is_continue = true;
> 
> I kept thinking during these days, I think it looks not that concise
> and elegant and also the name is not that good though the function can
> work.
> 
> In the next submission, I'm going to choose to use 'while()' instead
> of 'for()' suggested by Stephen.
> 
> Does anyone else have some advice about this?

What about:

	int done = false

	while (!done) {
		...
	}

Or:

	for (;;) {
		int done = false;

		...
		if (done)
			break;
	}

> 
> Thanks,
> Jason
> 
> >         LIST_HEAD(list);
> >         LIST_HEAD(repoll);
> >
> > @@ -6644,7 +6645,7 @@ static __latent_entropy void net_rx_action(struct softirq_action *h)
> >         list_splice_init(&sd->poll_list, &list);
> >         local_irq_enable();
> >
> > -       for (;;) {
> > +       for (; is_continue;) {
> >                 struct napi_struct *n;
> >
> >                 skb_defer_free_flush(sd);
> > @@ -6662,10 +6663,13 @@ static __latent_entropy void net_rx_action(struct softirq_action *h)
> >                  * Allow this to run for 2 jiffies since which will allow
> >                  * an average latency of 1.5/HZ.
> >                  */
> > -               if (unlikely(budget <= 0 ||
> > -                            time_after_eq(jiffies, time_limit))) {
> > +               if (unlikely(budget <= 0)) {
> > +                       sd->budget_squeeze++;
> > +                       is_continue = false;
> > +               }
> > +               if (unlikely(time_after_eq(jiffies, time_limit))) {
> >                         sd->time_squeeze++;
> > -                       break;
> > +                       is_continue = false;
> >                 }
> >         }
> >
> > diff --git a/net/core/net-procfs.c b/net/core/net-procfs.c
> > index 97a304e1957a..4d1a499d7c43 100644
> > --- a/net/core/net-procfs.c
> > +++ b/net/core/net-procfs.c
> > @@ -174,14 +174,17 @@ static int softnet_seq_show(struct seq_file *seq, void *v)
> >          */
> >         seq_printf(seq,
> >                    "%08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x "
> > -                  "%08x %08x\n",
> > -                  sd->processed, sd->dropped, sd->time_squeeze, 0,
> > +                  "%08x %08x %08x %08x\n",
> > +                  sd->processed, sd->dropped,
> > +                  0, /* was old way to count time squeeze */
> > +                  0,
> >                    0, 0, 0, 0, /* was fastroute */
> >                    0,   /* was cpu_collision */
> >                    sd->received_rps, flow_limit_count,
> >                    0,   /* was len of two backlog queues */
> >                    (int)seq->index,
> > -                  softnet_input_pkt_queue_len(sd), softnet_process_queue_len(sd));
> > +                  softnet_input_pkt_queue_len(sd), softnet_process_queue_len(sd),
> > +                  sd->time_squeeze, sd->budget_squeeze);
> >         return 0;
> >  }
> >
> > --
> > 2.37.3
> >
> 

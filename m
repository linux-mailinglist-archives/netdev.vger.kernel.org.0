Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD1A60E7BD
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 20:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234113AbiJZS7Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 14:59:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233753AbiJZS7Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 14:59:24 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2123.outbound.protection.outlook.com [40.107.22.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8CE2EA9F6;
        Wed, 26 Oct 2022 11:59:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VExQL7dbnC1hkJqnZAovYTMWdI434v2IuCmwA+Hb0rnzqA22ARo7vkg2UMkOzcqwjJiwZ0VtuLO4Vf3sBjptWCcTiLgWrclwiyydxFKL5yhbi+djpH7grxF2oKhpMnviu9ZJQLg6spRaFWHOsk31M7FBNL3K/gYGxjlTZ79lQSdMoI/r/rPZ/ceUhkqiYnOrPzhcHdWltDJHXHUq41YGoyS05qYSByVJRWcnq6mekCWYC+llEJY0pMIZqEelv4yqz2NCRhY00GMP6JtVbdrg9ozuXyMfH/oVT+knD10dqwD/nMbkcSjvdbG5OGuO9U+jig8VfFhKTP1PdFqbPifqAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CdZM105xdaEAe+DZn5ADBpQY1P68iMVENcsdAmpX+4I=;
 b=PM++67E1E36fLvfolGZhsuoRg+sbp5tn3oIfPZHuPd7ZTpMp9cQOZiibANz6aCkujgbXRUySqC3q4Dc+tepEo+AYBnjeByzK6CHlZy4N+/HwXf0fSP++IDUkFvNiiQ6Mpze/KKkTHZowbsX5GOXtUlb1I9PnS5+E2SpMGBfHzcBW2ywB5gsoMIdbDdXe+4pDb+SlaVmUYjeT6C6hlpWfauF8JWHNm2PhY4sq0gHYoiooX42Slm2U6DLNQDk7DjTKwJAD6yPNWyRZuj+ERcUjDwBnz5zLGC5UdUuYwrGacQ3nNm3g+vEzgVpulja0G5EOuz+mGC3/ixpODu9DssDE5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CdZM105xdaEAe+DZn5ADBpQY1P68iMVENcsdAmpX+4I=;
 b=bbUkRcS4veG5Rhn1Lp4urSaADHqEU37Z1DUK9Ksn2ok6rSoXgEfB5C7zT1BhEhJrgEzG2tmsYxnrr5mjVrHbTR5kUaAZNO7DsCxQSBzlzNc+Al4zeDCCvIbRLF2PGdZGtyae02NOuHtd2/4mhnjb9VY93leJ7BNdFfMbwZVeo12Ngj6IyBCgErdKIirpPxTTEmHUxMw2dYHdlXyTLBLwMWP3ANGdHjkuVbmyl/aZukAJSDkugloXmPpTPPz6cKOZRWtubZG7v5rhUyJIOfWdzJMvEXlktnDgvrAF2wewPgtUENyySb1CHROGqyGXpp24SVDBT6nl1dun8ZxoLsvTfw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from PAXPR08MB6956.eurprd08.prod.outlook.com (2603:10a6:102:1db::9)
 by AS2PR08MB8264.eurprd08.prod.outlook.com (2603:10a6:20b:553::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Wed, 26 Oct
 2022 18:59:20 +0000
Received: from PAXPR08MB6956.eurprd08.prod.outlook.com
 ([fe80::93c5:d0f9:9e1a:c499]) by PAXPR08MB6956.eurprd08.prod.outlook.com
 ([fe80::93c5:d0f9:9e1a:c499%7]) with mapi id 15.20.5746.028; Wed, 26 Oct 2022
 18:59:20 +0000
Message-ID: <fd9abfe4-962e-ceef-5ab8-29e654303343@virtuozzo.com>
Date:   Wed, 26 Oct 2022 20:59:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH net] tcp: reset tp->sacked_out when sack is enabled
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>, Lu Wei <luwei32@huawei.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Pavel Emelianov (Gmail)" <ovzxemul@gmail.com>, avagin@gmail.com,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
References: <20221026151558.4165020-1-luwei32@huawei.com>
 <CANn89iJQn5ET3U9cYeiT0ijTkab2tRDBB1YP3Y6oELVq0dj6Zw@mail.gmail.com>
 <CANn89iLcnPAzLZFiCazM_y==33+Zhg=3bGY70ev=5YwDoZw-Vg@mail.gmail.com>
From:   "Denis V. Lunev" <den@virtuozzo.com>
In-Reply-To: <CANn89iLcnPAzLZFiCazM_y==33+Zhg=3bGY70ev=5YwDoZw-Vg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR03CA0062.eurprd03.prod.outlook.com
 (2603:10a6:803:50::33) To PAXPR08MB6956.eurprd08.prod.outlook.com
 (2603:10a6:102:1db::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR08MB6956:EE_|AS2PR08MB8264:EE_
X-MS-Office365-Filtering-Correlation-Id: 203eab7b-9506-4120-60b0-08dab7843039
X-LD-Processed: 0bc7f26d-0264-416e-a6fc-8352af79c58f,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Nj1sGI/7UVGhrNYL0x/OifuwetgvCIUTrpKRv1wo5f+tJmHLS22MUJTCtScOo9fPH+2iQ20KvdFNLA02P0uty2njFv0ItjeNpKZTmJh2CTKqwWrPChQqpTa/uqFREvvmcK3eJjFsukKNPpzD1qw6xsMpXNMDc3pg3olFWZ15TIE6B9JXKNoW7OoZjQeGxigeght6G+iO8WadjvpBiMybZsbZ60tRQb2+S18s+8XSSPIzQejsk96QpQye6XQXBs5f93xtFs2r8j9I0JiJGlLVPMAwxhFJnhFc5auBQhunDkLWuAQzsQuGK1dU4CEhqLYsQULtNZuKcMMzkLrmPSao/UOZsP6W9aBlOIKl6XpyrGK++LAns4dAxaojQEgnpDtY+Mg/tVthFmIdAm+gTJYO9eR4632+JQDR1J99+PoAwRsMGq52DVcQGfs4OfuKEbA+8RG6L4GAfall5uCrrVR4mOIbpw/TDHan4NdPSqzMjEM8X4Vympj3XsyAjk11q6LmhINR248lPSqPA7VyilKr+EpG90JZsBaF7rpCMC6qeOzzGhU22LE2e5/GAhk9SUIZgTGrdz9b84jESGM/lX3cWaPrmupnBw1bqOHe3mhNhXL7jJS4Ib7ZK2RDcYF8CHUbhQg+W5RgHJ8/De8nwf7r2wOsOtnZD7OMosRXBu+LE9En0O3bHpcre6CHepnltwjbQIxnAk7Uu9OAuNYs18eE8UzGuu+ZzbddD2C+WUEfA/mkSazpIuYsRZG/hMAGMaxIutNNpw77juohCaRvw7KRpi3aDz6iooAjxYiw/OVjW2fSwyMT0VLHUDXzBe34GVQJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR08MB6956.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(136003)(396003)(39850400004)(376002)(451199015)(478600001)(966005)(31686004)(107886003)(6486002)(36756003)(6512007)(26005)(6506007)(53546011)(2616005)(7416002)(86362001)(8936002)(41300700001)(4326008)(66946007)(186003)(66476007)(38100700002)(66556008)(8676002)(110136005)(5660300002)(2906002)(31696002)(54906003)(316002)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MmVxVlBKTTdQMzlndldUaWRJa3BaMUhKUWJuc285TGdPdGN5ZHo5SjFKYXdP?=
 =?utf-8?B?UG5qbFVWV1BhUWZMRk1TM2JjR2lRTXNYNVJoRjk2d2MwV2hXK2ZjWWRMWndV?=
 =?utf-8?B?a3JtOWNMUXZmRTVZTUVSdlpiOWsrMTc5cG8rSFZBVkhqSzVGcWsxRlVnSUFM?=
 =?utf-8?B?akE0eGhWek5GcWVHcm4zeW1qeTVvcHlaVVdHMk1RQ09KOUk2NVZnR3hVdDY0?=
 =?utf-8?B?M2pBd3RFVjRSelNEUzFIbHRyY3l5MDFYdHBuUFpscjNpcndSZWFhQWJvWmRy?=
 =?utf-8?B?VVhrb2RiRU1MRHhDRE00NUFBaURrVlFURXRvb09yeU5scHduQlF4K0ZXUGtW?=
 =?utf-8?B?YU9UMUszVWh4L2NsZStNOHZUNDBvZnhwQitYKzFEaTJIcTlrTlA3MFJXMWg4?=
 =?utf-8?B?M2FUK2ROOVRyTGVkcTRTYXNSTDE0d3VvczJEQTY5OHc5UVpLRzZCTjU4Q2cw?=
 =?utf-8?B?WkM5TGRwSDBOekRRK1AyYjlnb3VINXc2V2gxWDdDZm1SRlJqQTFJRkRycE5q?=
 =?utf-8?B?bG9YbGVUTkE1VDZVUFhQSGhOMnRxaUdmQmlPdGMramNwdlA2SWVTNzEvMjNO?=
 =?utf-8?B?WTZLemUvcU9HVG90RTRjR0FPYkJuaktudG15YWViRjZPQ0pUT2JMNnM1d2VP?=
 =?utf-8?B?aVVYN0hOdGJ3c0pyeDVvcG5oMFZaSStGZnhlcXJHNkR2c2Q2SHBvYVdUOTZy?=
 =?utf-8?B?MnJKVkg1ZEZZeHh2WmhrT2pmN2ZtZHRyaEhsRmdlZGF6MDBhOFdlbjBFN2xy?=
 =?utf-8?B?VUQyVWlLNVN0TDNTeTBidkVHVVJYdXdoSXN0MlE1VDVQdXVUc05jVHl4UlhO?=
 =?utf-8?B?S25UMkgrTm9NVlRmV0pkM214elFWbHRpZDdyazQwdzNuNU9TZ3pBekUyNlBp?=
 =?utf-8?B?VHJFdmtTcXVUc0FYdnY3VW5Fd1RnRnFmRWJsd2poc2wvZXBlMHpjMjVaWnhI?=
 =?utf-8?B?Tk9mVnZhWEJQeGZkUkU1N1oxYzUvWk54UzA2aENGR3pvaHVPU2J3QkZ3c0lQ?=
 =?utf-8?B?QUV0NE94a1o1emd0Z2NYUE55bjdSdHI2eGNyemk2dldCUElDeDBObEdzQ2RJ?=
 =?utf-8?B?dTR0VWJQSUMydHRDUWJMbEFsZS9MV1NLMTJnUGRKaVdza3cwYUpBdStpay9p?=
 =?utf-8?B?RThSbFhzalI1UjlySWovdSs5b2hzZmRzRkowczd4OXhJMnF5NjBqaGk5ZkV5?=
 =?utf-8?B?UzBtdllDNE0wOW1vN3Yzdm5FRUhqL08xZnJWUEJnNGVHa2g4QU50UnhST3Jp?=
 =?utf-8?B?ZlN6cnVmNlNUMGQyeW5NTXRMeExmNXJHTDVkVlMwb2tPdVNPaUd2UE1QRkQ0?=
 =?utf-8?B?YkQ2ZkxTM3E2MHFnM0gzbGNhNEd1eStIaUZtem9VcXhWZkl2YkxPMEVsclJE?=
 =?utf-8?B?VU1lb05rbTlabVVmTGR6b0hwOEJjZ2UyMEF3ajc5eXJBVHp5QlkrOW5qNUFD?=
 =?utf-8?B?TmR3STFJbll3NnhHQzQ4MlQvODYxOUxIOHFwU0RzdDlJZ1RSemh6OVQwTlNX?=
 =?utf-8?B?RXl3c3pNSjhhWDFkN0FSRzkwV1hRNTFvVnliWVorU0MwVmZGeG5aaHFmVHZk?=
 =?utf-8?B?bDcrWEtoeDJUeWs2Tkk4QVc2TktuNU43QlBjRmxlUHdLWndrWml5YTI4K245?=
 =?utf-8?B?U2R4NGdNaDgrVmhKL3hXUHBUYkMzVS9SZ3dyUlZacFRGQmZOTU1XUUhDZkJj?=
 =?utf-8?B?YURDdmNXWEpDTzZQUWY0VnBHNGNMMWhiWlZPaUpOZDZBNGFsSWxMVTA1WG9R?=
 =?utf-8?B?OGM0enUzMm50VWtoVWpWWk1naWtFSEhvZE9weFpDcURXYSsxZ2hDTXlMN3Yw?=
 =?utf-8?B?OU4rMFhmNjJTb3BPMEtTdGRNRC9HeStHUmdNL3FzL2w4WUxwM2paam5FZUdp?=
 =?utf-8?B?Y2ltNGlmQngydG1NRDNGM3RMbU5XU2tudldUNW45VDE1SlA1dmd2VEF5UVVI?=
 =?utf-8?B?M0sxZEMvdHlYWk1qcnpKRHFKVnJPbi9PelJZdFNudFlLdFU2bTZVK0FYN1N6?=
 =?utf-8?B?dm9aaTZOdlhmK1BHU2ZiSDZDV0N3NDNFQS8vdmRvdkpjMzh2LzJhVkQ4T1FR?=
 =?utf-8?B?SitkeVpmd0FTaWZ1TFUzdVFFS2NnU2hDeFFRRGQxczl4MjZ3TlFYcGJzQTVr?=
 =?utf-8?Q?qyEaTBAVmk1erhE29h03fa7Yf?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 203eab7b-9506-4120-60b0-08dab7843039
X-MS-Exchange-CrossTenant-AuthSource: PAXPR08MB6956.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 18:59:20.0541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +Hhh7vTq4fh3qOq0TNmajd1KdzCS2lfr4N/G8jYAhM1ThWgoSuDCl3H4rr1CgWNYMsq+WBf0px0wPu8D0hxL4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB8264
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/26/22 16:33, Eric Dumazet wrote:
> On Wed, Oct 26, 2022 at 7:30 AM Eric Dumazet <edumazet@google.com> wrote:
>> On Wed, Oct 26, 2022 at 7:12 AM Lu Wei <luwei32@huawei.com> wrote:
>>> The meaning of tp->sacked_out depends on whether sack is enabled
>>> or not. If setsockopt is called to enable sack_ok via
>>> tcp_repair_options_est(), tp->sacked_out should be cleared, or it
>>> will trigger warning in tcp_verify_left_out as follows:
>>>
>>> ============================================
>>> WARNING: CPU: 8 PID: 0 at net/ipv4/tcp_input.c:2132
>>> tcp_timeout_mark_lost+0x154/0x160
>>> tcp_enter_loss+0x2b/0x290
>>> tcp_retransmit_timer+0x50b/0x640
>>> tcp_write_timer_handler+0x1c8/0x340
>>> tcp_write_timer+0xe5/0x140
>>> call_timer_fn+0x3a/0x1b0
>>> __run_timers.part.0+0x1bf/0x2d0
>>> run_timer_softirq+0x43/0xb0
>>> __do_softirq+0xfd/0x373
>>> __irq_exit_rcu+0xf6/0x140
>>>
>>> This warning occurs in several steps:
>>> Step1. If sack is not enabled, when server receives dup-ack,
>>>         it calls tcp_add_reno_sack() to increase tp->sacked_out.
>>>
>>> Step2. Setsockopt() is called to enable sack
>>>
>>> Step3. The retransmit timer expires, it calls tcp_timeout_mark_lost()
>>>         to increase tp->lost_out but not clear tp->sacked_out because
>>>         sack is enabled and tcp_is_reno() is false.
>>>
>>> So tp->left_out is increased repeatly in Step1 and Step3 and it is
>>> greater than tp->packets_out and trigger the warning. In function
>>> tcp_timeout_mark_lost(), tp->sacked_out will be cleared if Step2 not
>>> happen and the warning will not be triggered. So this patch clears
>>> tp->sacked_out in tcp_repair_options_est().
>>>
>>> Fixes: b139ba4e90dc ("tcp: Repair connection-time negotiated parameters")
>>> Signed-off-by: Lu Wei <luwei32@huawei.com>
>>> ---
>>>   net/ipv4/tcp.c | 3 +++
>>>   1 file changed, 3 insertions(+)
>>>
>>> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
>>> index ef14efa1fb70..188d5c0e440f 100644
>>> --- a/net/ipv4/tcp.c
>>> +++ b/net/ipv4/tcp.c
>>> @@ -3282,6 +3282,9 @@ static int tcp_repair_options_est(struct sock *sk, sockptr_t optbuf,
>>>                          if (opt.opt_val != 0)
>>>                                  return -EINVAL;
>>>
>>> +                       if (tcp_is_reno(tp))
>>> +                               tp->sacked_out = 0;
>>> +
>>>                          tp->rx_opt.sack_ok |= TCP_SACK_SEEN;
>>>                          break;
>>>                  case TCPOPT_TIMESTAMP:
>>> --
>>> 2.31.1
>>>
>> Hmm, I am not sure this is the right fix.
>>
>> Probably TCP_REPAIR_OPTIONS should not be allowed if data has already been sent.
>>
>> Pavel, what do you think ?
> Routing to Denis V. Lunev <den@openvz.org>, because Pavel's address no
> longer works.
>
> Thanks !
Hi, guys!

This code is used in CRIU. I have added CRIU maintainers
Andrey Vagin, Pavel Tikhomirov and new address of Pavel
Emelyanov to CC list.

Here is the quote from Pavel Tikhomirov on the topic.
"We do setsockopt with TCP_REPAIR_OPTIONS in CRIU just
after calling connect to the socket here
https://github.com/checkpoint-restore/criu/blob/18c6426eaeebc5fe7d0f9ca0acb592a3ec828b0c/soccr/soccr.c#L566 

and before libsoccr_restore_queue.

So it seems there should be no data sent in this socket at
the moment, so I believe it is safe to prohibit
TCP_REPAIR_OPTIONS if data was already sent.

Though I'd recomend running some CRIU tests after this
change just to be sure that we don't break it.
E.g.: "zdtm/static/socket-tcp*" or just
"./test/zdtm.py run -a --keep-going --ignore-taint".

Thank you in advance,
     Den

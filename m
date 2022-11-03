Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53B04617409
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 03:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbiKCCL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 22:11:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbiKCCL0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 22:11:26 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6689713D1F;
        Wed,  2 Nov 2022 19:11:25 -0700 (PDT)
Received: from kwepemi500015.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4N2nDc6bvXzRnsN;
        Thu,  3 Nov 2022 10:06:24 +0800 (CST)
Received: from [10.174.178.171] (10.174.178.171) by
 kwepemi500015.china.huawei.com (7.221.188.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 3 Nov 2022 10:11:22 +0800
Subject: Re: [patch net v3] tcp: prohibit TCP_REPAIR_OPTIONS if data was
 already sent
To:     Neal Cardwell <ncardwell@google.com>
CC:     <edumazet@google.com>, <davem@davemloft.net>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <xemul@parallels.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20221102132811.70858-1-luwei32@huawei.com>
 <CADVnQy=uE68AWKuSddKEt3T2X=HUYzs0SQPX31+HgafuysJzkA@mail.gmail.com>
From:   "luwei (O)" <luwei32@huawei.com>
Message-ID: <ef5c0948-1a40-e4b7-5b1b-629cfcad1c37@huawei.com>
Date:   Thu, 3 Nov 2022 10:11:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CADVnQy=uE68AWKuSddKEt3T2X=HUYzs0SQPX31+HgafuysJzkA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.171]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi500015.china.huawei.com (7.221.188.92)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/11/2 10:46 PM, Neal Cardwell 写道:
> On Wed, Nov 2, 2022 at 8:23 AM Lu Wei <luwei32@huawei.com> wrote:
>> If setsockopt with option name of TCP_REPAIR_OPTIONS and opt_code
>> of TCPOPT_SACK_PERM is called to enable sack after data is sent
>> and before data is acked, ...
> This "before data is acked" phrase does not quite seem to match the
> sequence below, AFAICT?
>
> How about something like:
>
>   If setsockopt TCP_REPAIR_OPTIONS with opt_code TCPOPT_SACK_PERM
>   is called to enable SACK after data is sent and the data sender receives a
>   dupack, ...
      yes, thanks for suggestion
>
>
>> ... it will trigger a warning in function
>> tcp_verify_left_out() as follows:
>>
>> ============================================
>> WARNING: CPU: 8 PID: 0 at net/ipv4/tcp_input.c:2132
>> tcp_timeout_mark_lost+0x154/0x160
>> tcp_enter_loss+0x2b/0x290
>> tcp_retransmit_timer+0x50b/0x640
>> tcp_write_timer_handler+0x1c8/0x340
>> tcp_write_timer+0xe5/0x140
>> call_timer_fn+0x3a/0x1b0
>> __run_timers.part.0+0x1bf/0x2d0
>> run_timer_softirq+0x43/0xb0
>> __do_softirq+0xfd/0x373
>> __irq_exit_rcu+0xf6/0x140
>>
>> The warning is caused in the following steps:
>> 1. a socket named socketA is created
>> 2. socketA enters repair mode without build a connection
>> 3. socketA calls connect() and its state is changed to TCP_ESTABLISHED
>>     directly
>> 4. socketA leaves repair mode
>> 5. socketA calls sendmsg() to send data, packets_out and sack_outs(dup
>>     ack receives) increase
>> 6. socketA enters repair mode again
>> 7. socketA calls setsockopt with TCPOPT_SACK_PERM to enable sack
>> 8. retransmit timer expires, it calls tcp_timeout_mark_lost(), lost_out
>>     increases
>> 9. sack_outs + lost_out > packets_out triggers since lost_out and
>>     sack_outs increase repeatly
>>
>> In function tcp_timeout_mark_lost(), tp->sacked_out will be cleared if
>> Step7 not happen and the warning will not be triggered. As suggested by
>> Denis and Eric, TCP_REPAIR_OPTIONS should be prohibited if data was
>> already sent. So this patch checks tp->segs_out, only TCP_REPAIR_OPTIONS
>> can be set only if tp->segs_out is 0.
>>
>> socket-tcp tests in CRIU has been tested as follows:
>> $ sudo ./test/zdtm.py run -t zdtm/static/socket-tcp*  --keep-going \
>>         --ignore-taint
>>
>> socket-tcp* represent all socket-tcp tests in test/zdtm/static/.
>>
>> Fixes: b139ba4e90dc ("tcp: Repair connection-time negotiated parameters")
>> Signed-off-by: Lu Wei <luwei32@huawei.com>
>> ---
>>   net/ipv4/tcp.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
>> index ef14efa1fb70..1f5cc32cf0cc 100644
>> --- a/net/ipv4/tcp.c
>> +++ b/net/ipv4/tcp.c
>> @@ -3647,7 +3647,7 @@ int do_tcp_setsockopt(struct sock *sk, int level, int optname,
>>          case TCP_REPAIR_OPTIONS:
>>                  if (!tp->repair)
>>                          err = -EINVAL;
>> -               else if (sk->sk_state == TCP_ESTABLISHED)
>> +               else if (sk->sk_state == TCP_ESTABLISHED && !tp->segs_out)
> The tp->segs_out field is only 32 bits wide. By my math, at 200
> Gbit/sec with 1500 byte MTU it can wrap roughly every 260 secs. So a
> caller could get unlucky or carefully sequence its call to
> TCP_REPAIR_OPTIONS (based on packets sent so far) to mess up the
> accounting and trigger the kernel warning.
>
> How about using some other method to determine if this is safe?
> Perhaps using tp->bytes_sent, which is a 64-bit field, which by my
> math would take 23 years to wrap at 200 Gbit/sec?
>
> If we're more paranoid about wrapping we could also check
> tp->packets_out, and refuse to allow TCP_REPAIR_OPTIONS if either
> tp->bytes_sent or tp->packets_out are non-zero. (Or if we're even more
> paranoid I suppose we could have a special new bit to track whether
> we've ever sent something, but that probably seems like overkill?)
>
> neal
> .

I didn't notice that u32 will be easily wrapped in huge network throughput,
thank you neal.

But tcp->packets_out shoud not be used because tp->packets_out can decrease
when expected ack is received, so it can decrease to 0 and this is the common
condition.

-- 
Best Regards,
Lu Wei


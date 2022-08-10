Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2A358E7D5
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 09:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbiHJHZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 03:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiHJHZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 03:25:15 -0400
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B1A4C63B9
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 00:25:11 -0700 (PDT)
HMM_SOURCE_IP: 172.18.0.188:53488.305847795
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-110.80.1.46 (unknown [172.18.0.188])
        by chinatelecom.cn (HERMES) with SMTP id A517528008F;
        Wed, 10 Aug 2022 15:25:04 +0800 (CST)
X-189-SAVE-TO-SEND: liyonglong@chinatelecom.cn
Received: from  ([172.18.0.188])
        by app0023 with ESMTP id 59137238c5604953b3822515e00a2da9 for ycheng@google.com;
        Wed, 10 Aug 2022 15:25:07 CST
X-Transaction-ID: 59137238c5604953b3822515e00a2da9
X-Real-From: liyonglong@chinatelecom.cn
X-Receive-IP: 172.18.0.188
X-MEDUSA-Status: 0
Sender: liyonglong@chinatelecom.cn
Subject: Re: [PATCH] tcp: adjust rcvbuff according copied rate of user space
To:     Neal Cardwell <ncardwell@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        dsahern@kernel.org, kuba@kernel.org, pabeni@redhat.com,
        Yuchung Cheng <ycheng@google.com>
References: <1660034866-1844-1-git-send-email-liyonglong@chinatelecom.cn>
 <CADVnQykvc1oXP=jLeimcRuZRHoN+q7S9VPFky7otYdbEedom7w@mail.gmail.com>
From:   Yonglong Li <liyonglong@chinatelecom.cn>
Message-ID: <85cad11e-7007-1066-d586-ab2c5ca2d731@chinatelecom.cn>
Date:   Wed, 10 Aug 2022 15:24:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <CADVnQykvc1oXP=jLeimcRuZRHoN+q7S9VPFky7otYdbEedom7w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/10/2022 5:28 AM, Neal Cardwell wrote:
> On Tue, Aug 9, 2022 at 4:48 AM Yonglong Li <liyonglong@chinatelecom.cn> wrote:
>>
>> it is more reasonable to adjust rcvbuff by copied rate instead
>> of copied buff len.
>>
>> Signed-off-by: Yonglong Li <liyonglong@chinatelecom.cn>
>> ---
> 
> Thanks for sending out the patch. My sense is that this would need a
> more detailed commit description describing the algorithm change, the
> motivation for the change, and justifying the added complexity and
> state by showing some meaningful performance test results that
> demonstrate some improvement.
Hi Neal,

Thanks for your feedback. will add more detail in next version.

> 
>>  include/linux/tcp.h  |  1 +
>>  net/ipv4/tcp_input.c | 16 +++++++++++++---
>>  2 files changed, 14 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/linux/tcp.h b/include/linux/tcp.h
>> index a9fbe22..18e091c 100644
>> --- a/include/linux/tcp.h
>> +++ b/include/linux/tcp.h
>> @@ -410,6 +410,7 @@ struct tcp_sock {
>>                 u32     space;
>>                 u32     seq;
>>                 u64     time;
>> +               u32     prior_rate;
>>         } rcvq_space;
>>
>>  /* TCP-specific MTU probe information. */
>> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
>> index ab5f0ea..2bdf2a5 100644
>> --- a/net/ipv4/tcp_input.c
>> +++ b/net/ipv4/tcp_input.c
>> @@ -544,6 +544,7 @@ static void tcp_init_buffer_space(struct sock *sk)
>>         tcp_mstamp_refresh(tp);
>>         tp->rcvq_space.time = tp->tcp_mstamp;
>>         tp->rcvq_space.seq = tp->copied_seq;
>> +       tp->rcvq_space.prior_rate = 0;
>>
>>         maxwin = tcp_full_space(sk);
>>
>> @@ -701,6 +702,7 @@ static inline void tcp_rcv_rtt_measure_ts(struct sock *sk,
>>  void tcp_rcv_space_adjust(struct sock *sk)
>>  {
>>         struct tcp_sock *tp = tcp_sk(sk);
>> +       u64 pre_copied_rate, copied_rate;
>>         u32 copied;
>>         int time;
>>
>> @@ -713,7 +715,14 @@ void tcp_rcv_space_adjust(struct sock *sk)
>>
>>         /* Number of bytes copied to user in last RTT */
>>         copied = tp->copied_seq - tp->rcvq_space.seq;
>> -       if (copied <= tp->rcvq_space.space)
>> +       copied_rate = copied * USEC_PER_SEC;
>> +       do_div(copied_rate, time);
>> +       pre_copied_rate = tp->rcvq_space.prior_rate;
>> +       if (!tp->rcvq_space.prior_rate) {
>> +               pre_copied_rate = tp->rcvq_space.space * USEC_PER_SEC;
>> +               do_div(pre_copied_rate, time);
>> +       }
>> +       if (copied_rate <= pre_copied_rate || !pre_copied_rate)
>>                 goto new_measure;
>>
>>         /* A bit of theory :
>> @@ -736,8 +745,8 @@ void tcp_rcv_space_adjust(struct sock *sk)
>>                 rcvwin = ((u64)copied << 1) + 16 * tp->advmss;
>>
>>                 /* Accommodate for sender rate increase (eg. slow start) */
>> -               grow = rcvwin * (copied - tp->rcvq_space.space);
>> -               do_div(grow, tp->rcvq_space.space);
>> +               grow = rcvwin * (copied_rate - pre_copied_rate);
>> +               do_div(grow, pre_copied_rate);
>>                 rcvwin += (grow << 1);
>>
>>                 rcvmem = SKB_TRUESIZE(tp->advmss + MAX_TCP_HEADER);
>> @@ -755,6 +764,7 @@ void tcp_rcv_space_adjust(struct sock *sk)
>>                 }
>>         }
>>         tp->rcvq_space.space = copied;
>> +       tp->rcvq_space.prior_rate = pre_copied_rate;
> 
> Shouldn't that line be:
> 
>    tp->rcvq_space.prior_rate = copied_rate;
> 
> Otherwise, AFAICT the patch could preserve forever in
> tp->rcvq_space.prior_rate the very first rate that was computed, since
> the top of the patch does:
> 
>  +       pre_copied_rate = tp->rcvq_space.prior_rate;
> 
> and the bottom of the patch does:
> 
>  +       tp->rcvq_space.prior_rate = pre_copied_rate;
> 
sorry. I get a mistake...

> best regards,
> neal
> 

-- 
Li YongLong

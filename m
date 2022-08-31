Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7F45A7763
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 09:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbiHaHUA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 03:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbiHaHTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 03:19:47 -0400
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CEB783B969
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 00:19:42 -0700 (PDT)
HMM_SOURCE_IP: 172.18.0.48:58870.1349745694
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-27.148.194.74 (unknown [172.18.0.48])
        by chinatelecom.cn (HERMES) with SMTP id 3FB6E28008B;
        Wed, 31 Aug 2022 15:19:36 +0800 (CST)
X-189-SAVE-TO-SEND: liyonglong@chinatelecom.cn
Received: from  ([172.18.0.48])
        by app0024 with ESMTP id 13f74051e6284f95b4ae9e190b5c5753 for ncardwell@google.com;
        Wed, 31 Aug 2022 15:19:40 CST
X-Transaction-ID: 13f74051e6284f95b4ae9e190b5c5753
X-Real-From: liyonglong@chinatelecom.cn
X-Receive-IP: 172.18.0.48
X-MEDUSA-Status: 0
Sender: liyonglong@chinatelecom.cn
Subject: Re: [PATCH] tcp: del skb from tsorted_sent_queue after mark it as
 lost
To:     Yuchung Cheng <ycheng@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        Neal Cardwell <ncardwell@google.com>
References: <1661761242-7849-1-git-send-email-liyonglong@chinatelecom.cn>
 <CAK6E8=dJzNC7GFTikanKM48Uo5DFZBZGSUVoMy1dCfV0ttNe+g@mail.gmail.com>
 <CAK6E8=eNe8Ce9zKXx1rKBL48XuDVGntAOOtKVi6ywgMjafMWXg@mail.gmail.com>
From:   Yonglong Li <liyonglong@chinatelecom.cn>
Message-ID: <43b8a024-2ab8-157d-92c2-7367f632c659@chinatelecom.cn>
Date:   Wed, 31 Aug 2022 15:19:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <CAK6E8=eNe8Ce9zKXx1rKBL48XuDVGntAOOtKVi6ywgMjafMWXg@mail.gmail.com>
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



On 8/31/2022 1:58 PM, Yuchung Cheng wrote:
> On Mon, Aug 29, 2022 at 5:23 PM Yuchung Cheng <ycheng@google.com> wrote:
>>
>> On Mon, Aug 29, 2022 at 1:21 AM Yonglong Li <liyonglong@chinatelecom.cn> wrote:
>>>
>>> if rack is enabled, when skb marked as lost we can remove it from
>>> tsorted_sent_queue. It will reduces the iterations on tsorted_sent_queue
>>> in tcp_rack_detect_loss
>>
>> Did you test the case where an skb is marked lost again after
>> retransmission? I can't quite remember the reason I avoided this
>> optimization. let me run some test and get back to you.
> As I suspected, this patch fails to pass our packet drill tests.
> 
> It breaks detecting retransmitted packets that
> get lost again, b/c they have already been removed from the tsorted
> list when they get lost the first time.
> 
> 

Hi Yuchung,
Thank you for your feelback.
But I am not quite understand. in the current implementation, if an skb
is marked lost again after retransmission, it will be added to tail of
tsorted_sent_queue again in tcp_update_skb_after_send.
Do I miss some code?

> 
>>
>>
>>>
>>> Signed-off-by: Yonglong Li <liyonglong@chinatelecom.cn>
>>> ---
>>>  net/ipv4/tcp_input.c    | 15 +++++++++------
>>>  net/ipv4/tcp_recovery.c |  1 -
>>>  2 files changed, 9 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
>>> index ab5f0ea..01bd644 100644
>>> --- a/net/ipv4/tcp_input.c
>>> +++ b/net/ipv4/tcp_input.c
>>> @@ -1082,6 +1082,12 @@ static void tcp_notify_skb_loss_event(struct tcp_sock *tp, const struct sk_buff
>>>         tp->lost += tcp_skb_pcount(skb);
>>>  }
>>>
>>> +static bool tcp_is_rack(const struct sock *sk)
>>> +{
>>> +       return READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_recovery) &
>>> +               TCP_RACK_LOSS_DETECTION;
>>> +}
>>> +
>>>  void tcp_mark_skb_lost(struct sock *sk, struct sk_buff *skb)
>>>  {
>>>         __u8 sacked = TCP_SKB_CB(skb)->sacked;
>>> @@ -1105,6 +1111,9 @@ void tcp_mark_skb_lost(struct sock *sk, struct sk_buff *skb)
>>>                 TCP_SKB_CB(skb)->sacked |= TCPCB_LOST;
>>>                 tcp_notify_skb_loss_event(tp, skb);
>>>         }
>>> +
>>> +       if (tcp_is_rack(sk))
>>> +               list_del_init(&skb->tcp_tsorted_anchor);
>>>  }
>>>
>>>  /* Updates the delivered and delivered_ce counts */
>>> @@ -2093,12 +2102,6 @@ static inline void tcp_init_undo(struct tcp_sock *tp)
>>>         tp->undo_retrans = tp->retrans_out ? : -1;
>>>  }
>>>
>>> -static bool tcp_is_rack(const struct sock *sk)
>>> -{
>>> -       return READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_recovery) &
>>> -               TCP_RACK_LOSS_DETECTION;
>>> -}
>>> -
>>>  /* If we detect SACK reneging, forget all SACK information
>>>   * and reset tags completely, otherwise preserve SACKs. If receiver
>>>   * dropped its ofo queue, we will know this due to reneging detection.
>>> diff --git a/net/ipv4/tcp_recovery.c b/net/ipv4/tcp_recovery.c
>>> index 50abaa9..ba52ec9e 100644
>>> --- a/net/ipv4/tcp_recovery.c
>>> +++ b/net/ipv4/tcp_recovery.c
>>> @@ -84,7 +84,6 @@ static void tcp_rack_detect_loss(struct sock *sk, u32 *reo_timeout)
>>>                 remaining = tcp_rack_skb_timeout(tp, skb, reo_wnd);
>>>                 if (remaining <= 0) {
>>>                         tcp_mark_skb_lost(sk, skb);
>>> -                       list_del_init(&skb->tcp_tsorted_anchor);
>>>                 } else {
>>>                         /* Record maximum wait time */
>>>                         *reo_timeout = max_t(u32, *reo_timeout, remaining);
>>> --
>>> 1.8.3.1
>>>
> 

-- 
Li YongLong

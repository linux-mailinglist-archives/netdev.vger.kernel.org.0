Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4759D56B0AC
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 04:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236180AbiGHCks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 22:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbiGHCkr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 22:40:47 -0400
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DDD8845079
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 19:40:44 -0700 (PDT)
HMM_SOURCE_IP: 172.18.0.188:48762.1598721774
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-110.80.1.46 (unknown [172.18.0.188])
        by chinatelecom.cn (HERMES) with SMTP id DF6482800A7;
        Fri,  8 Jul 2022 10:40:38 +0800 (CST)
X-189-SAVE-TO-SEND: liyonglong@chinatelecom.cn
Received: from  ([172.18.0.188])
        by app0023 with ESMTP id 31ab580430294dfe8c67648029498951 for pabeni@redhat.com;
        Fri, 08 Jul 2022 10:40:40 CST
X-Transaction-ID: 31ab580430294dfe8c67648029498951
X-Real-From: liyonglong@chinatelecom.cn
X-Receive-IP: 172.18.0.188
X-MEDUSA-Status: 0
Sender: liyonglong@chinatelecom.cn
Subject: Re: [PATCH] tcp: make retransmitted SKB fit into the send window
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <1657189155-38222-1-git-send-email-liyonglong@chinatelecom.cn>
 <CANn89iLW5sbPkyySPYCGzAOcTFy24dL4T9xcN7cQ8Nf0MqCX_Q@mail.gmail.com>
From:   Yonglong Li <liyonglong@chinatelecom.cn>
Message-ID: <c4aceb54-520b-09d0-ded1-d39b817c913c@chinatelecom.cn>
Date:   Fri, 8 Jul 2022 10:40:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <CANn89iLW5sbPkyySPYCGzAOcTFy24dL4T9xcN7cQ8Nf0MqCX_Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/7/2022 8:17 PM, Eric Dumazet wrote:
> On Thu, Jul 7, 2022 at 12:50 PM Yonglong Li <liyonglong@chinatelecom.cn> wrote:
>>
>> From: liyonglong <liyonglong@chinatelecom.cn>
>>
>> current code of __tcp_retransmit_skb only check TCP_SKB_CB(skb)->seq
>> in send window, it will cause retransmit more than send window data.
> 
> This changelog is confusing. I understand the check is already done ?
> 
> I think it would be better to explain how a receiver can retract its window,
> even if TCP RFCs specifically forbid this.
> 

Hi Eric，
Thanks for your reply.
I simulate this case by using packetdrill.

22:14:25.340439 IP 192.168.226.67.55188 > 192.0.2.1.8080: Flags [S], seq 2685051498, win 65535, options [mss 1460,sackOK,TS val 316430404 ecr 0,nop,wscale 8], length 0
22:14:25.393232 IP 192.0.2.1.8080 > 192.168.226.67.55188: Flags [S.], seq 0, ack 2685051499, win 6000, options [mss 1000,nop,nop,sackOK], length 0
22:14:25.393278 IP 192.168.226.67.55188 > 192.0.2.1.8080: Flags [.], ack 1, win 65535, length 0
22:14:25.393343 IP 192.168.226.67.55188 > 192.0.2.1.8080: Flags [.], seq 1:2001, ack 1, win 65535, length 2000: HTTP
22:14:25.393348 IP 192.168.226.67.55188 > 192.0.2.1.8080: Flags [.], seq 2001:4001, ack 1, win 65535, length 2000: HTTP
22:14:25.393350 IP 192.168.226.67.55188 > 192.0.2.1.8080: Flags [P.], seq 4001:5001, ack 1, win 65535, length 1000: HTTP
22:14:25.393353 IP 192.168.226.67.55188 > 192.0.2.1.8080: Flags [.], seq 5001:6001, ack 1, win 65535, length 1000: HTTP
22:14:25.445239 IP 192.0.2.1.8080 > 192.168.226.67.55188: Flags [.], ack 4001, win 1001, length 0                          // client retract window to 1001
22:14:25.557222 IP 192.168.226.67.55188 > 192.0.2.1.8080: Flags [.], seq 5001:6001, ack 1, win 65535, length 1000: HTTP    // now send windonw is [4001,5002], and tlp send 5001-6001
22:14:25.816255 IP 192.168.226.67.55188 > 192.0.2.1.8080: Flags [P.], seq 4001:5001, ack 1, win 65535, length 1000: HTTP

>>
>> Signed-off-by: liyonglong <liyonglong@chinatelecom.cn>
> 
> This probably needs a Fixes: tag, even if targeting net-next (which I
> prefer because this kind of patch is risky)
> 
> 
>> ---
>>  net/ipv4/tcp_output.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
>> index 18c913a..3530d1f 100644
>> --- a/net/ipv4/tcp_output.c
>> +++ b/net/ipv4/tcp_output.c
>> @@ -3176,7 +3176,7 @@ int __tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb, int segs)
>>             TCP_SKB_CB(skb)->seq != tp->snd_una)
>>                 return -EAGAIN;
>>
>> -       len = cur_mss * segs;
>> +       len = min_t(int, tcp_wnd_end(tp) - TCP_SKB_CB(skb)->seq, cur_mss * segs);
> 
> I think it is unfortunate to not align len to a multiple of cur_mss,
> if possible.
> 
> Also this might break so-called zero window probes.
> We might need to send some payload, to discover if the ACK the
> receiver sent us to re-open its window was lost.
> 

you are right. I miss "zero window probes" case. this patch will get it doesn't work.

> 
>>         if (skb->len > len) {
> 
> What happens if len == 0 ?
> 

if len == 0, it will return in pre-check:

         if (!before(TCP_SKB_CB(skb)->seq, tcp_wnd_end(tp)) &&
             TCP_SKB_CB(skb)->seq != tp->snd_una)
                 return -EAGAIN;

> 
> 
>>                 if (tcp_fragment(sk, TCP_FRAG_IN_RTX_QUEUE, skb, len,
>>                                  cur_mss, GFP_ATOMIC))
>> @@ -3190,7 +3190,7 @@ int __tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb, int segs)
>>                 diff -= tcp_skb_pcount(skb);
>>                 if (diff)
>>                         tcp_adjust_pcount(sk, skb, diff);
>> -               if (skb->len < cur_mss)
>> +               if (skb->len < cur_mss && len >= cur_mss)
> 
> This seems to be weak.
> 
> I suggest to do it properly in  tcp_retrans_try_collapse() because
> there is already a related test there :
> 
> if (after(TCP_SKB_CB(skb)->end_seq, tcp_wnd_end(tp)))
>       break;
> 
> But this seems not done properly.
> 
>>                         tcp_retrans_try_collapse(sk, skb, cur_mss);
>>         }
>>
>> --
>> 1.8.3.1
>>
> 

-- 
Li YongLong

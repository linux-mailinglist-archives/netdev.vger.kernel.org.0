Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7519756FE95
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 12:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbiGKKOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 06:14:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbiGKKOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 06:14:00 -0400
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D4C697AC08
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 02:34:11 -0700 (PDT)
HMM_SOURCE_IP: 172.18.0.218:39622.1018751414
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-110.80.1.46 (unknown [172.18.0.218])
        by chinatelecom.cn (HERMES) with SMTP id E417F2800D7;
        Mon, 11 Jul 2022 17:34:07 +0800 (CST)
X-189-SAVE-TO-SEND: liyonglong@chinatelecom.cn
Received: from  ([172.18.0.218])
        by app0025 with ESMTP id f7ad3ce5bcda41368238527836a9c21d for pabeni@redhat.com;
        Mon, 11 Jul 2022 17:34:09 CST
X-Transaction-ID: f7ad3ce5bcda41368238527836a9c21d
X-Real-From: liyonglong@chinatelecom.cn
X-Receive-IP: 172.18.0.218
X-MEDUSA-Status: 0
Sender: liyonglong@chinatelecom.cn
Subject: Re: [PATCH v3] tcp: make retransmitted SKB fit into the send window
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <1657525740-7585-1-git-send-email-liyonglong@chinatelecom.cn>
 <CANn89iJ-ca3u1JRKm=H4+rR3MFrdXxXTDUftNUzF20YTUM3=rg@mail.gmail.com>
From:   Yonglong Li <liyonglong@chinatelecom.cn>
Message-ID: <d69cf438-9c91-a174-6856-4ff4d680737f@chinatelecom.cn>
Date:   Mon, 11 Jul 2022 17:34:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <CANn89iJ-ca3u1JRKm=H4+rR3MFrdXxXTDUftNUzF20YTUM3=rg@mail.gmail.com>
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



On 7/11/2022 5:06 PM, Eric Dumazet wrote:
> On Mon, Jul 11, 2022 at 9:56 AM Yonglong Li <liyonglong@chinatelecom.cn> wrote:
>>
>> current code of __tcp_retransmit_skb only check TCP_SKB_CB(skb)->seq
>> in send window, and TCP_SKB_CB(skb)->seq_end maybe out of send window.
>> If receiver has shrunk his window, and skb is out of new window,  it
>> should retransmit a smaller portion of the payload.
>>
>> test packetdrill script:
>>     0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
>>    +0 fcntl(3, F_GETFL) = 0x2 (flags O_RDWR)
>>    +0 fcntl(3, F_SETFL, O_RDWR|O_NONBLOCK) = 0
>>
>>    +0 connect(3, ..., ...) = -1 EINPROGRESS (Operation now in progress)
>>    +0 > S 0:0(0)  win 65535 <mss 1460,sackOK,TS val 100 ecr 0,nop,wscale 8>
>>  +.05 < S. 0:0(0) ack 1 win 6000 <mss 1000,nop,nop,sackOK>
>>    +0 > . 1:1(0) ack 1
>>
>>    +0 write(3, ..., 10000) = 10000
>>
>>    +0 > . 1:2001(2000) ack 1 win 65535
>>    +0 > . 2001:4001(2000) ack 1 win 65535
>>    +0 > . 4001:6001(2000) ack 1 win 65535
>>
>>  +.05 < . 1:1(0) ack 4001 win 1001
>>
>> and tcpdump show:
>> 192.168.226.67.55 > 192.0.2.1.8080: Flags [.], seq 1:2001, ack 1, win 65535, length 2000
>> 192.168.226.67.55 > 192.0.2.1.8080: Flags [.], seq 2001:4001, ack 1, win 65535, length 2000
>> 192.168.226.67.55 > 192.0.2.1.8080: Flags [P.], seq 4001:5001, ack 1, win 65535, length 1000
>> 192.168.226.67.55 > 192.0.2.1.8080: Flags [.], seq 5001:6001, ack 1, win 65535, length 1000
>> 192.0.2.1.8080 > 192.168.226.67.55: Flags [.], ack 4001, win 1001, length 0
>> 192.168.226.67.55 > 192.0.2.1.8080: Flags [.], seq 5001:6001, ack 1, win 65535, length 1000
>> 192.168.226.67.55 > 192.0.2.1.8080: Flags [P.], seq 4001:5001, ack 1, win 65535, length 1000
>>
>> when cient retract window to 1001, send window is [4001,5002],
>> but TLP send 5001-6001 packet which is out of send window.
>>
>> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
>> Signed-off-by: Yonglong Li <liyonglong@chinatelecom.cn>
>> ---
>>  net/ipv4/tcp_output.c | 36 ++++++++++++++++++++++++------------
>>  1 file changed, 24 insertions(+), 12 deletions(-)
>>
>> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
>> index 18c913a..efd0f05 100644
>> --- a/net/ipv4/tcp_output.c
>> +++ b/net/ipv4/tcp_output.c
>> @@ -3100,7 +3100,6 @@ static bool tcp_can_collapse(const struct sock *sk, const struct sk_buff *skb)
>>  static void tcp_retrans_try_collapse(struct sock *sk, struct sk_buff *to,
>>                                      int space)
>>  {
>> -       struct tcp_sock *tp = tcp_sk(sk);
>>         struct sk_buff *skb = to, *tmp;
>>         bool first = true;
>>
>> @@ -3123,14 +3122,18 @@ static void tcp_retrans_try_collapse(struct sock *sk, struct sk_buff *to,
>>                         continue;
>>                 }
>>
>> -               if (space < 0)
>> -                       break;
>> -
>> -               if (after(TCP_SKB_CB(skb)->end_seq, tcp_wnd_end(tp)))
>> +               if (space < 0) {
>> +                       if (unlikely(tcp_fragment(sk, TCP_FRAG_IN_RTX_QUEUE,
>> +                                                 skb, space + skb->len,
>> +                                                 tcp_current_mss(sk), GFP_ATOMIC)))
> 
> What are you doing here ?
> 
> This seems wrong.

I think we can collapse more data if skb->len < avail_wnd. If you think doing this is wrong
I will remove it.

> 
> Can we please stick to the patch I sent earlier.
> 
> If you want to amend it later, you can do this in a separate patch,
> with a clear explanation.
> 
>> +                               break;
>> +                       tcp_collapse_retrans(sk, to);
>>                         break;
>> +               }
>>
>>                 if (!tcp_collapse_retrans(sk, to))
>>                         break;
>> +
>>         }
>>  }
>>
>> @@ -3144,7 +3147,7 @@ int __tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb, int segs)
>>         struct tcp_sock *tp = tcp_sk(sk);
>>         unsigned int cur_mss;
>>         int diff, len, err;
>> -
>> +       int avail_wnd;
>>
>>         /* Inconclusive MTU probe */
>>         if (icsk->icsk_mtup.probe_size)
>> @@ -3166,17 +3169,25 @@ int __tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb, int segs)
>>                 return -EHOSTUNREACH; /* Routing failure or similar. */
>>
>>         cur_mss = tcp_current_mss(sk);
>> +       avail_wnd = tcp_wnd_end(tp) - TCP_SKB_CB(skb)->seq;
>>
>>         /* If receiver has shrunk his window, and skb is out of
>>          * new window, do not retransmit it. The exception is the
>>          * case, when window is shrunk to zero. In this case
>> -        * our retransmit serves as a zero window probe.
>> +        * our retransmit of one segment serves as a zero window probe.
>>          */
>> -       if (!before(TCP_SKB_CB(skb)->seq, tcp_wnd_end(tp)) &&
>> -           TCP_SKB_CB(skb)->seq != tp->snd_una)
>> -               return -EAGAIN;
>> +       if (avail_wnd <= 0) {
>> +               if (TCP_SKB_CB(skb)->seq != tp->snd_una)
>> +                       return -EAGAIN;
>> +               avail_wnd = cur_mss;
>> +       }
>>
>>         len = cur_mss * segs;
>> +       if (len > avail_wnd) {
>> +               len = rounddown(avail_wnd, cur_mss);
>> +               if (!len)
>> +                       len = avail_wnd;
>> +       }
>>         if (skb->len > len) {
>>                 if (tcp_fragment(sk, TCP_FRAG_IN_RTX_QUEUE, skb, len,
>>                                  cur_mss, GFP_ATOMIC))
>> @@ -3190,8 +3201,9 @@ int __tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb, int segs)
>>                 diff -= tcp_skb_pcount(skb);
>>                 if (diff)
>>                         tcp_adjust_pcount(sk, skb, diff);
>> -               if (skb->len < cur_mss)
>> -                       tcp_retrans_try_collapse(sk, skb, cur_mss);
>> +               avail_wnd = min_t(int, avail_wnd, cur_mss);
>> +               if (skb->len < avail_wnd)
>> +                       tcp_retrans_try_collapse(sk, skb, avail_wnd);
>>         }
>>
>>         /* RFC3168, section 6.1.1.1. ECN fallback */
>> --
>> 1.8.3.1
>>
> 

-- 
Li YongLong

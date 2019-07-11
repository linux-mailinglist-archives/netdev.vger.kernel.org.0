Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D465D653AB
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 11:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728027AbfGKJTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 05:19:51 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53208 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727595AbfGKJTu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 05:19:50 -0400
Received: by mail-wm1-f68.google.com with SMTP id s3so4913670wms.2
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 02:19:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=emLFRRzBmB+DAVqphji8EOQ+lQatStBjMQ50i0gBRak=;
        b=JaYX/ggMuMN2bOGKgEmtRvgU87Ha8SbRgJ35WNI5zgUMDP+gBrr2sT3sNxtWbkXLc1
         PE+lVRsX7obar6X8+3Oz/64l2A+x+3VeI2BAFhjQD3M/Z087eKpolbYnz55uJZd1szbN
         0zb0n7ngq/hlVgnfHLALW0IOhlDp9+4OXDRQumSEw80jYGzet5skkiIb3JRlnjgHvjLl
         2twCCpyiFymX1KdmCrvCtOppL8bz+E1Gi/ANQla+BCtXiP8NMr7pVN0PGNszBD4/8AnR
         OIHEqjYKgxPGfGlG9YBUzLhBex0hVyxBG7IbGtS2Xee4ujsUC1oW+3xFURNr61qOwuJD
         Y1+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=emLFRRzBmB+DAVqphji8EOQ+lQatStBjMQ50i0gBRak=;
        b=OFX1j84c1D4HuIJBKfyu9QnOIqo+LUduOjO2ogQpb2aR2KxY6KZNXOQe7gyvObrENu
         AdC1u1bZJpLZjRSrjNt6zNLcqBALGOJfYicdzZL0IJE8/dgafft2Ixx2KHxqGN6tir37
         QxN13zufJu/buy9zHHqrpR1bWGr2mQLjtU8tiJdoK7PBtg3M/OcRXaQP3+C1AUiV0El/
         /lOg7skRMZdfqKN6NgHdfpayd1pOeBgIcu5iF+68JL9j511bGez+18N/1m9Y40RB8IdJ
         hgmsSq8sgzYWrMk+tTVVCw2SWyzezt5VbdU9LrKB1Ahg4eTcMfnRzZ+p5kcXkJ27BioB
         yTpA==
X-Gm-Message-State: APjAAAVAqAh0iSKDYWq5r6wuO7mi5Gn28aDiD+8TEfeWRlyrA373/yUY
        Cpu6X+p0gp0k43Ko3z4e0RPOlV7t
X-Google-Smtp-Source: APXvYqzSqZARNy/7SemmdjGwhdCmPGMFtqOo4Z7dPBufx1YqSvY7t38c3V1fWoOGZStMvM6VK0N9mA==
X-Received: by 2002:a05:600c:212:: with SMTP id 18mr3058921wmi.88.1562836787719;
        Thu, 11 Jul 2019 02:19:47 -0700 (PDT)
Received: from [192.168.8.147] (143.160.185.81.rev.sfr.net. [81.185.160.143])
        by smtp.gmail.com with ESMTPSA id l8sm8476677wrg.40.2019.07.11.02.19.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 02:19:46 -0700 (PDT)
Subject: Re: [PATCH net 2/4] tcp: tcp_fragment() should apply sane memory
 limits
To:     Christoph Paasch <christoph.paasch@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "Prout, Andrew - LLSC - MITLL" <aprout@ll.mit.edu>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Looney <jtl@netflix.com>,
        Neal Cardwell <ncardwell@google.com>,
        Tyler Hicks <tyhicks@canonical.com>,
        Yuchung Cheng <ycheng@google.com>,
        Bruce Curtis <brucec@netflix.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Dustin Marquess <dmarquess@apple.com>
References: <20190617170354.37770-1-edumazet@google.com>
 <20190617170354.37770-3-edumazet@google.com>
 <CALMXkpYVRxgeqarp4gnmX7GqYh1sWOAt6UaRFqYBOaaNFfZ5sw@mail.gmail.com>
 <03cbcfdf-58a4-dbca-45b1-8b17f229fa1d@gmail.com>
 <CALMXkpZ4isoXpFp_5=nVUcWrt5TofYVhpdAjv7LkCH7RFW1tYw@mail.gmail.com>
 <63cd99ed3d0c440185ebec3ad12327fc@ll.mit.edu>
 <96791fd5-8d36-2e00-3fef-60b23bea05e5@gmail.com>
 <e471350b70e244daa10043f06fbb3ebe@ll.mit.edu>
 <b1dfd327-a784-6609-3c83-dab42c3c7eda@gmail.com>
 <B600B3AB-559E-44C1-869C-7309DB28850E@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <eb6121ea-b02d-672e-25c9-2ad054d49fc7@gmail.com>
Date:   Thu, 11 Jul 2019 11:19:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <B600B3AB-559E-44C1-869C-7309DB28850E@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/11/19 9:28 AM, Christoph Paasch wrote:
> 
> 
>> On Jul 10, 2019, at 9:26 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>
>>
>>
>> On 7/10/19 8:53 PM, Prout, Andrew - LLSC - MITLL wrote:
>>>
>>> Our initial rollout was v4.14.130, but I reproduced it with v4.14.132 as well, reliably for the samba test and once (not reliably) with synthetic test I was trying. A patched v4.14.132 with this patch partially reverted (just the four lines from tcp_fragment deleted) passed the samba test.
>>>
>>> The synthetic test was a pair of simple send/recv test programs under the following conditions:
>>> -The send socket was non-blocking
>>> -SO_SNDBUF set to 128KiB
>>> -The receiver NIC was being flooded with traffic from multiple hosts (to induce packet loss/retransmits)
>>> -Load was on both systems: a while(1) program spinning on each CPU core
>>> -The receiver was on an older unaffected kernel
>>>
>>
>> SO_SNDBUF to 128KB does not permit to recover from heavy losses,
>> since skbs needs to be allocated for retransmits.
> 
> Would it make sense to always allow the alloc in tcp_fragment when coming from __tcp_retransmit_skb() through the retransmit-timer ?

4.15+ kernels have :

if (unlikely((sk->sk_wmem_queued >> 1) > sk->sk_sndbuf &&
    tcp_queue != TCP_FRAG_IN_WRITE_QUEUE)) {


Meaning that things like TLP will succeed.

Anything we add in TCP stack to overcome the SO_SNDBUF by twice the limit _will_ be exploited at scale.

I am not sure we want to continue to support small SO_SNDBUF values, as this makes no sense today.

We use 64 MB auto tuning limit, and /proc/sys/net/ipv4/tcp_notsent_lowat to 1 MB.

I would rather work (when net-next reopens) on better collapsing at rtx to allow reduction of the overhead.


Something like :

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index f6a9c95a48edb234e4d4e21bf585744fbaf9a0a7..d5c85986209cd162cf39edb787b1385cb2c8b630 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2860,7 +2860,7 @@ static int __net_init tcp_sk_init(struct net *net)
        net->ipv4.sysctl_tcp_early_retrans = 3;
        net->ipv4.sysctl_tcp_recovery = TCP_RACK_LOSS_DETECTION;
        net->ipv4.sysctl_tcp_slow_start_after_idle = 1; /* By default, RFC2861 behavior.  */
-       net->ipv4.sysctl_tcp_retrans_collapse = 1;
+       net->ipv4.sysctl_tcp_retrans_collapse = 3;
        net->ipv4.sysctl_tcp_max_reordering = 300;
        net->ipv4.sysctl_tcp_dsack = 1;
        net->ipv4.sysctl_tcp_app_win = 31;
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index d61264cf89ef66b229ecf797c1abfb7fcdab009f..05cd264f98b084f62eaf2ef9d6e14a392670d02c 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3015,8 +3015,6 @@ static bool tcp_collapse_retrans(struct sock *sk, struct sk_buff *skb)
 
        next_skb_size = next_skb->len;
 
-       BUG_ON(tcp_skb_pcount(skb) != 1 || tcp_skb_pcount(next_skb) != 1);
-
        if (next_skb_size) {
                if (next_skb_size <= skb_availroom(skb))
                        skb_copy_bits(next_skb, 0, skb_put(skb, next_skb_size),
@@ -3054,8 +3052,6 @@ static bool tcp_collapse_retrans(struct sock *sk, struct sk_buff *skb)
 /* Check if coalescing SKBs is legal. */
 static bool tcp_can_collapse(const struct sock *sk, const struct sk_buff *skb)
 {
-       if (tcp_skb_pcount(skb) > 1)
-               return false;
        if (skb_cloned(skb))
                return false;
        /* Some heuristics for collapsing over SACK'd could be invented */
@@ -3114,7 +3110,7 @@ int __tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb, int segs)
        struct inet_connection_sock *icsk = inet_csk(sk);
        struct tcp_sock *tp = tcp_sk(sk);
        unsigned int cur_mss;
-       int diff, len, err;
+       int diff, len, maxlen, err;
 
 
        /* Inconclusive MTU probe */
@@ -3165,12 +3161,13 @@ int __tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb, int segs)
                        return -ENOMEM;
 
                diff = tcp_skb_pcount(skb);
+               maxlen = (sock_net(sk)->ipv4.sysctl_tcp_retrans_collapse & 2) ? len : cur_mss;
+               if (skb->len < maxlen)
+                       tcp_retrans_try_collapse(sk, skb, maxlen);
                tcp_set_skb_tso_segs(skb, cur_mss);
                diff -= tcp_skb_pcount(skb);
                if (diff)
                        tcp_adjust_pcount(sk, skb, diff);
-               if (skb->len < cur_mss)
-                       tcp_retrans_try_collapse(sk, skb, cur_mss);
        }
 
        /* RFC3168, section 6.1.1.1. ECN fallback */

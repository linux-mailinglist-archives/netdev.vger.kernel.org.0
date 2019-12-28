Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA86812BC74
	for <lists+netdev@lfdr.de>; Sat, 28 Dec 2019 04:29:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbfL1D3E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 22:29:04 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41573 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbfL1D3E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 22:29:04 -0500
Received: by mail-wr1-f65.google.com with SMTP id c9so27736587wrw.8
        for <netdev@vger.kernel.org>; Fri, 27 Dec 2019 19:29:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kP69/GOil7ccDA8OxqKmN8mEis7niKSi1kk3zJFqrdI=;
        b=ercDmmIvk8ioY4AD/rbLUE/fGU+CnCfa1sZ2SJKFE7HcthzNv30VSPUxOIacHEhBhU
         Qg6YG62zj1VXdJnrN5n46KhvNcdQTPtvmC7NRZ4J5GR0ASsY7dvrgN5Jd1mkborCzC73
         uJS/5eNXKjBUm22CDRYgSRfJAPmyTzJCOIPjR38nO57o9V+fxj+IF71Xr6Uji3yFP5vX
         ktM+smlDmFOpplHIhTmQlLJiW29H0MNiuXGLB54H1H3oP7YbcXV6hINbdErRAkZqkXRr
         b0DRY+KY02PkoYLTQUVGduyGAebkAF2q/e5d7nItGvULCWBIwJaQF+cDQWLYNEEjxt9g
         pGOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kP69/GOil7ccDA8OxqKmN8mEis7niKSi1kk3zJFqrdI=;
        b=pYw51zE7q2GV+v4zrLVByJl0aI0x15LfK4gJFXBonkLsyWIKcblANRwMRN0uIuOdT5
         QBiLxVRCnQsZ9QvmL9ZYnuzrMem2vSKSglHxIgtgoRca9OPjM+Tk02F4kv39enXwZQqz
         Ltcm2FrzMPuLPujOD7Pj6oyMrX9nTNETZpIQaaYqo6pAcKRsJwXJ9a4dQGbZ0dI0WfDj
         ewY9a+BBc6nLZVlBe+zETnE38ePP+Cc/zUet1kG9vAvHarCzc8nM1QyjVD1TyCH8VQ+s
         v2qby3VqBdnw+O5LlVY+OuVXmPsTquSLWprrBhIi/YfNE63zaxNM7IwaGN3fMKPsg1w0
         8IEg==
X-Gm-Message-State: APjAAAW3xxsNwgngyzrbJX4j5dOFBQuEpTrgx4eC/qtxQ7hEHaBTAv40
        R0m7XU9qv5MYNfS9WQaGNwv714J7
X-Google-Smtp-Source: APXvYqw19WN8AMOuwsL/Zmic0kZngzmSfjNDGQWB+oapAO+DtFN7X34s8EuBC0Rj56KgqV48y6PT2w==
X-Received: by 2002:adf:f1d0:: with SMTP id z16mr51818890wro.209.1577503741935;
        Fri, 27 Dec 2019 19:29:01 -0800 (PST)
Received: from [192.168.8.147] (252.165.185.81.rev.sfr.net. [81.185.165.252])
        by smtp.gmail.com with ESMTPSA id q3sm12885426wmj.38.2019.12.27.19.28.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Dec 2019 19:29:01 -0800 (PST)
Subject: Re: [PATCH] tcp: Fix highest_sack and highest_sack_seq
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     Cambda Zhu <cambda@linux.alibaba.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Yuchung Cheng <ycheng@google.com>,
        netdev <netdev@vger.kernel.org>,
        Dust Li <dust.li@linux.alibaba.com>
References: <20191227085237.7295-1-cambda@linux.alibaba.com>
 <e90fd3b5-037b-276a-f217-56da56354d8d@gmail.com>
Message-ID: <bdb42c0b-2d84-9a49-3ac4-34109ff4224a@gmail.com>
Date:   Fri, 27 Dec 2019 19:28:35 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <e90fd3b5-037b-276a-f217-56da56354d8d@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/27/19 4:49 PM, Eric Dumazet wrote:
> 
> 
> On 12/27/19 12:52 AM, Cambda Zhu wrote:
>> From commit 50895b9de1d3 ("tcp: highest_sack fix"), the logic about
>> setting tp->highest_sack to the head of the send queue was removed.
>> Of course the logic is error prone, but it is logical. Before we
>> remove the pointer to the highest sack skb and use the seq instead,
>> we need to set tp->highest_sack to NULL when there is no skb after
>> the last sack, and then replace NULL with the real skb when new skb
>> inserted into the rtx queue, because the NULL means the highest sack
>> seq is tp->snd_nxt. If tp->highest_sack is NULL and new data sent,
>> the next ACK with sack option will increase tp->reordering unexpectedly.
>>
>> This patch sets tp->highest_sack to the tail of the rtx queue if
>> it's NULL and new data is sent. The patch keeps the rule that the
>> highest_sack can only be maintained by sack processing, except for
>> this only case.
>>
>> Fixes: 50895b9de1d3 ("tcp: highest_sack fix")
>> Signed-off-by: Cambda Zhu <cambda@linux.alibaba.com>
>> ---
>>  net/ipv4/tcp_output.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
>> index 1f7735ca8f22..58c92a7d671c 100644
>> --- a/net/ipv4/tcp_output.c
>> +++ b/net/ipv4/tcp_output.c
>> @@ -72,6 +72,9 @@ static void tcp_event_new_data_sent(struct sock *sk, struct sk_buff *skb)
>>  	__skb_unlink(skb, &sk->sk_write_queue);
>>  	tcp_rbtree_insert(&sk->tcp_rtx_queue, skb);
>>  
>> +	if (tp->highest_sack == NULL)
>> +		tp->highest_sack = skb;
>> +
>>  	tp->packets_out += tcp_skb_pcount(skb);
>>  	if (!prior_packets || icsk->icsk_pending == ICSK_TIME_LOSS_PROBE)
>>  		tcp_rearm_rto(sk);
>>
> 
> 
> This patch seems to keep something in the fast path, even for flows never experiencing
> sacks.
> 
> Why would we always painfully maintain tp->highest_sack to the left most skb in the rtx queue ?
> 
> Given that tcp_highest_sack_seq() has an explicit check about tp->highest_sack being NULL,
> there is something I do not quite understand yet.
> 
> Why keeping this piece of code ?
> 
>     if (tp->highest_sack == NULL)
>             return tp->snd_nxt;
> 
> Defensive programming should be replaced by better knowledge.
> 
> Can you provide more explanations, or maybe a packetdrill test ?
> 
> Maybe some other path (in slow path this time) misses a !tp->highest_sack test.
> 
> Thanks.
> 

Or maybe the real bug has been latent for years.

(added in commit 6859d49475d4 "[TCP]: Abstract tp->highest_sack accessing & point to next skb" )


diff --git a/include/net/tcp.h b/include/net/tcp.h
index e460ea7f767ba627972a63a974cae80357808366..32781fb5cf3a7aa1158c98cb87754b59dc922b1f 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1843,12 +1843,9 @@ static inline void tcp_push_pending_frames(struct sock *sk)
  */
 static inline u32 tcp_highest_sack_seq(struct tcp_sock *tp)
 {
-       if (!tp->sacked_out)
+       if (!tp->sacked_out || !tp->highest_sack)
                return tp->snd_una;
 
-       if (tp->highest_sack == NULL)
-               return tp->snd_nxt;
-
        return TCP_SKB_CB(tp->highest_sack)->seq;
 }
 

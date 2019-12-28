Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C021712BC0C
	for <lists+netdev@lfdr.de>; Sat, 28 Dec 2019 01:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbfL1Ati (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 19:49:38 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54853 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbfL1Ath (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 19:49:37 -0500
Received: by mail-wm1-f67.google.com with SMTP id b19so9374506wmj.4
        for <netdev@vger.kernel.org>; Fri, 27 Dec 2019 16:49:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Kq+J+YF9HyPK4HGpV7A/qqz2f0xFkR6pIP3PSUz+g+Y=;
        b=AjYGYJCFfMbkqvRK2fzRoxhTRorDHrjiJkS5NeZl3aiidrzr5DXv3oeYkGQMs+LcYJ
         /mTJLkLvFQ+uoX0dbjT55gsbkyJX0mgMDhB+tthX2ex1/T5582G8eAEin2jnkYDTBcWi
         NOSU0eFv1et6QKkvp6ZYD3uhkp0Y0KOVTIcWTHM+Hp7xrsRp//W3kijJA/QYy5h7F6lV
         sncb03K6oyMKjNGBzeOs0pJuwvEnOaRlAIM2YTiovlerdI46Ds/Xwa6/iipoOm4NoJ0w
         /Y0y7TrhP58r90f3T7SKXqYGmzxuXj45+IKWMudcsMWSOy2kbuuBrbRyX7CIFftvXi87
         Yjqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Kq+J+YF9HyPK4HGpV7A/qqz2f0xFkR6pIP3PSUz+g+Y=;
        b=s4L2Fio6xA5hH9aM9/JRu/DuYGq/bv8uZE98gfEJpOIKBlnA+Tnay2hiKgCJji8Et8
         uEjQ7WlivY3jOim2b3TRMe9zzAXJnaGNpjYy50K8cAWoj2etiP6MT3tNxKQQOYhtz4ZD
         1di0/kFj/Q+9JVMLIKMoJVJqtW/4b86aCnS/7z2zfpzN4Dh82aHRNJvxiF8CR1YEzK/g
         9PoIkCqEf2P3eiINqiw1yK5n3KfFLv+pD4fYVV8vard3IoAB6hZuKMzvVzXDl7oa78Y/
         F0uuH/XUytFNmhNaxYWxJ8D4h6URuUEiSD7KqjuxPugkkObHzgnuLpaElKkflISqQNiy
         g+xw==
X-Gm-Message-State: APjAAAUgIPuQKWiSzces4ha0M5f987DjRK4Z6LP6TGxTugRr4LSb07gQ
        xRfBsNg/n89ga4HkAK6rzdJ32jTi
X-Google-Smtp-Source: APXvYqw7Cgdb4yrCdwu1n64ZRs0gegJRXtzs+1tKsBl7XYULHvx0Cjk05DghPzffhEHsKEeHd0UBhQ==
X-Received: by 2002:a7b:c3d7:: with SMTP id t23mr22005564wmj.33.1577494175479;
        Fri, 27 Dec 2019 16:49:35 -0800 (PST)
Received: from [192.168.8.147] (252.165.185.81.rev.sfr.net. [81.185.165.252])
        by smtp.gmail.com with ESMTPSA id a14sm38805726wrx.81.2019.12.27.16.49.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Dec 2019 16:49:34 -0800 (PST)
Subject: Re: [PATCH] tcp: Fix highest_sack and highest_sack_seq
To:     Cambda Zhu <cambda@linux.alibaba.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Yuchung Cheng <ycheng@google.com>,
        netdev <netdev@vger.kernel.org>,
        Dust Li <dust.li@linux.alibaba.com>
References: <20191227085237.7295-1-cambda@linux.alibaba.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <e90fd3b5-037b-276a-f217-56da56354d8d@gmail.com>
Date:   Fri, 27 Dec 2019 16:49:33 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191227085237.7295-1-cambda@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/27/19 12:52 AM, Cambda Zhu wrote:
> From commit 50895b9de1d3 ("tcp: highest_sack fix"), the logic about
> setting tp->highest_sack to the head of the send queue was removed.
> Of course the logic is error prone, but it is logical. Before we
> remove the pointer to the highest sack skb and use the seq instead,
> we need to set tp->highest_sack to NULL when there is no skb after
> the last sack, and then replace NULL with the real skb when new skb
> inserted into the rtx queue, because the NULL means the highest sack
> seq is tp->snd_nxt. If tp->highest_sack is NULL and new data sent,
> the next ACK with sack option will increase tp->reordering unexpectedly.
> 
> This patch sets tp->highest_sack to the tail of the rtx queue if
> it's NULL and new data is sent. The patch keeps the rule that the
> highest_sack can only be maintained by sack processing, except for
> this only case.
> 
> Fixes: 50895b9de1d3 ("tcp: highest_sack fix")
> Signed-off-by: Cambda Zhu <cambda@linux.alibaba.com>
> ---
>  net/ipv4/tcp_output.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index 1f7735ca8f22..58c92a7d671c 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -72,6 +72,9 @@ static void tcp_event_new_data_sent(struct sock *sk, struct sk_buff *skb)
>  	__skb_unlink(skb, &sk->sk_write_queue);
>  	tcp_rbtree_insert(&sk->tcp_rtx_queue, skb);
>  
> +	if (tp->highest_sack == NULL)
> +		tp->highest_sack = skb;
> +
>  	tp->packets_out += tcp_skb_pcount(skb);
>  	if (!prior_packets || icsk->icsk_pending == ICSK_TIME_LOSS_PROBE)
>  		tcp_rearm_rto(sk);
> 


This patch seems to keep something in the fast path, even for flows never experiencing
sacks.

Why would we always painfully maintain tp->highest_sack to the left most skb in the rtx queue ?

Given that tcp_highest_sack_seq() has an explicit check about tp->highest_sack being NULL,
there is something I do not quite understand yet.

Why keeping this piece of code ?

    if (tp->highest_sack == NULL)
            return tp->snd_nxt;

Defensive programming should be replaced by better knowledge.

Can you provide more explanations, or maybe a packetdrill test ?

Maybe some other path (in slow path this time) misses a !tp->highest_sack test.

Thanks.

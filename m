Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 078A43B0BD3
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 19:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232301AbhFVRvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 13:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbhFVRvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 13:51:04 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA06C061574
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 10:48:47 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id y7so24553456wrh.7
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 10:48:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=N6z2ZrvUWLw7+T/916O6sBaQFCNlzoYvsE49LHRnvqU=;
        b=L9EHXhQCzxAO3n9cfNGBV96IJwQK5qDKcOMZf1WZvAlpS3H0Vexo6ht1snjVSnSlXd
         sA96ul4EZA3HZRgnkZ2IXHPIan7h0n/N+Je2EF1XWs9/1d8NYintxa8ILuLXVdospWJo
         BK4eqTXS/QQmemCLbzCbBn8Xtxsy9rY8wU0Da2iS4dgZbwoBFVvsDDNFcyCqUGcUoFNa
         WSM6vZh1p0v7gv1h9nWAoiRbmGUFASJmmTTAEQWtRL/IRVoKBeFuuSVz3On77AHUjVdu
         ucwUr/E10COttcuk0Uaa7K1NcOPdAj5ffHOHa4Icxo8/UFoWMAOe8O7EpWOvH79hkLOA
         cJlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=N6z2ZrvUWLw7+T/916O6sBaQFCNlzoYvsE49LHRnvqU=;
        b=tTFQyV9GffFr3/NFTr5Z+MMYqTgAzwG+LcZshdMpCn/NfdFr3zAuCk3nqwLBtqZCTL
         s+nat3agGlt+c2S6CEAKUpTKswMzilovSA2DWOSNGFcPvTno9MAr35n+S61dmiFIBo3M
         Hm06JCRAfI7UP6yfAkTG7fkpaVtnITsURDRxo/N6RTA0ajFippAzWw7ANaK0cbSGFkea
         1h0if3a97Od873JWyVrMtqDLcm27IXxGndoYv975wD7e3Spq5E2dFYLHfQhka9WRyUDs
         0kikpITDWmZhY+9HW7w7O2k5cCzvR0dRojJbA54Md02ubPtx+ES3CWIYxl8gdbeeIkCs
         sYlg==
X-Gm-Message-State: AOAM5333itP36u7LW+tiw71ukXCRmycc4qqDym4XW93OL96NPoahxqla
        u0k84338W4QmpBmI70TY3Qk=
X-Google-Smtp-Source: ABdhPJyP34WSPEQcS1I1T49/0KejcId3HorE31GgCzmm5juYEJcX+jYzBqNHf4xQa8A6nS+L0d3mww==
X-Received: by 2002:a5d:5919:: with SMTP id v25mr6179049wrd.319.1624384126309;
        Tue, 22 Jun 2021 10:48:46 -0700 (PDT)
Received: from [192.168.181.98] (15.248.23.93.rev.sfr.net. [93.23.248.15])
        by smtp.gmail.com with ESMTPSA id z6sm73740wrl.15.2021.06.22.10.48.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 10:48:45 -0700 (PDT)
Subject: Re: [PATCH net-next] ip: avoid OOM kills with large UDP sends over
 loopback
To:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, willemb@google.com,
        dsahern@gmail.com, yoshfuji@linux-ipv6.org, Dave Jones <dsj@fb.com>
References: <20210621231307.1917413-1-kuba@kernel.org>
 <8fe00e04-3a79-6439-6ec7-5e40408529e2@gmail.com>
 <20210622095422.5e078bd4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <462f87f4-cc90-1c0e-3a9f-c65c64781dc3@gmail.com>
Date:   Tue, 22 Jun 2021 19:48:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210622095422.5e078bd4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/22/21 6:54 PM, Jakub Kicinski wrote:
> On Tue, 22 Jun 2021 16:12:11 +0200 Eric Dumazet wrote:
>> On 6/22/21 1:13 AM, Jakub Kicinski wrote:
>>> Dave observed number of machines hitting OOM on the UDP send
>>> path. The workload seems to be sending large UDP packets over
>>> loopback. Since loopback has MTU of 64k kernel will try to
>>> allocate an skb with up to 64k of head space. This has a good
>>> chance of failing under memory pressure. What's worse if
>>> the message length is <32k the allocation may trigger an
>>> OOM killer.
>>>
>>> This is entirely avoidable, we can use an skb with frags.
>>>
>>> The scenario is unlikely and always using frags requires
>>> an extra allocation so opt for using fallback, rather
>>> then always using frag'ed/paged skb when payload is large.
>>>
>>> Note that the size heuristic (header_len > PAGE_SIZE)
>>> is not entirely accurate, __alloc_skb() will add ~400B
>>> to size. Occasional order-1 allocation should be fine,
>>> though, we are primarily concerned with order-3.
>>>
>>> Reported-by: Dave Jones <dsj@fb.com>
>>> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
>>> +static inline void sk_allocation_push(struct sock *sk, gfp_t flag, gfp_t *old)
>>> +{
>>> +	*old = sk->sk_allocation;
>>> +	sk->sk_allocation |= flag;
>>> +}
>>> +  
>>
>> This is not thread safe.
>>
>> Remember UDP sendmsg() does not lock the socket for non-corking sends.
> 
> Ugh, you're right :(
> 
>>> +static inline void sk_allocation_pop(struct sock *sk, gfp_t old)
>>> +{
>>> +	sk->sk_allocation = old;
>>> +}
>>> +
>>>  static inline void sk_acceptq_removed(struct sock *sk)
>>>  {
>>>  	WRITE_ONCE(sk->sk_ack_backlog, sk->sk_ack_backlog - 1);
>>> diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
>>> index c3efc7d658f6..a300c2c65d57 100644
>>> --- a/net/ipv4/ip_output.c
>>> +++ b/net/ipv4/ip_output.c
>>> @@ -1095,9 +1095,24 @@ static int __ip_append_data(struct sock *sk,
>>>  				alloclen += rt->dst.trailer_len;
>>>  
>>>  			if (transhdrlen) {
>>> -				skb = sock_alloc_send_skb(sk,
>>> -						alloclen + hh_len + 15,
>>> +				size_t header_len = alloclen + hh_len + 15;
>>> +				gfp_t sk_allocation;
>>> +
>>> +				if (header_len > PAGE_SIZE)
>>> +					sk_allocation_push(sk, __GFP_NORETRY,
>>> +							   &sk_allocation);
>>> +				skb = sock_alloc_send_skb(sk, header_len,
>>>  						(flags & MSG_DONTWAIT), &err);
>>> +				if (header_len > PAGE_SIZE) {
>>> +					BUILD_BUG_ON(MAX_HEADER >= PAGE_SIZE);
>>> +
>>> +					sk_allocation_pop(sk, sk_allocation);
>>> +					if (unlikely(!skb) && !paged &&
>>> +					    rt->dst.dev->features & NETIF_F_SG) {
>>> +						paged = true;
>>> +						goto alloc_new_skb;
>>> +					}
>>> +				}  
>>
>>
>> What about using 	sock_alloc_send_pskb(... PAGE_ALLOC_COSTLY_ORDER)
>> (as we did in unix_dgram_sendmsg() for large packets), for SG enabled interfaces ?
> 
> PAGE_ALLOC_COSTLY_ORDER in itself is more of a problem than a solution.
> AFAIU the app sends messages primarily above the ~60kB mark, which is
> above COSTLY, and those do not trigger OOM kills. All OOM kills we see
> have order=3. Checking with Rik and Johannes W that's expected, OOM
> killer is only invoked for allocations <= COSTLY, larger ones will just
> return NULL and let us deal with it (e.g. by falling back).

I  really thought alloc_skb_with_frags() was already handling low-memory-conditions.

(alloc_skb_with_frags() is called from sock_alloc_send_pskb())

If it is not, lets fix it, because af_unix sockets will have the same issue ?



> 
> So adding GFP_NORETRY is key for 0 < order <= COSTLY,
> skb_page_frag_refill()-style.
> 
>> We do not _have_ to put all the payload in skb linear part,
>> we could instead use page frags (order-0 if high order pages are not available)

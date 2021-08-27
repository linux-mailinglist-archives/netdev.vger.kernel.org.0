Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A59E3F9CBE
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 18:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232649AbhH0QsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 12:48:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbhH0QsS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 12:48:18 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1782C0613CF;
        Fri, 27 Aug 2021 09:47:29 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id x16so2638708pll.2;
        Fri, 27 Aug 2021 09:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AjSSclyFHkSUvuli5hojcHuEUsW5eq3tyDoeI7pev60=;
        b=ZtvNXE+pxrodw94Sa8YOhfAEnXSUQKz/3fqCCc2ZHGzF18IwbmZ3v8YACu9oruXIWR
         eKlz7tQ/GNQEISZuKdNa7t8bB4PHR7o3PM1gdQFHOKPKIyqrzro6b5G+3SJ4KHCUf9d3
         9TRqgTMVZAxY0BdTTX2ZIQ1xZ0/QFk2jHjUWGwJTpcAt1luLIfDHa68MEIxGKIJ7ohlN
         0Twy5YnUBfZtI8nU+stPniN4fBphWJ/67N56nuuV4wxSaUHN/seJC82aWqgo4k3icjeD
         ykL6rIqU36ZzUg51zGFX6F+zKevDQylnUZ8sprPxyIGT1usP7fzpBqm8U5f71brC8W0h
         8Ssw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AjSSclyFHkSUvuli5hojcHuEUsW5eq3tyDoeI7pev60=;
        b=BFGyZoJcLvPjkc6PJuJPrgTKqDjhZkT5ka8HSSZlwvWgStRY6xH5O2djkfmd6vBeoK
         KkQZKsLIrhM3tGSRTRj+926pRN7oC3zbbnbnHa5TlB6U9LltNfIzjkF+rQGRc7kiczfW
         y6gaDC3+P2x/NJOQEYALM+sQktc+ZO7Qc9xndwWPek7Rg6bWedhkewB9ALlfKoyNf2yi
         WmDhCW3GZlxsWEcseTRFuACxKVbL3iYRn77X612/8sJh8r5JE8GUkvmRviPCRN2nUyoS
         ZDQoc31mQ+3kWuY8vWp8ABpGXI8RUdBHO4Q3LAmB5BtngxP7YPQofPpzbCGHEmkXdwQn
         BE0w==
X-Gm-Message-State: AOAM531bbBCWAoKrmD3sX3a6oC+Iu2mHcaoqnltC6SW79vhIarYK8c/B
        RWfr/W4uWBcUKs5QApg+qWw=
X-Google-Smtp-Source: ABdhPJw8iOhlM6b6XkGy2ASQBwmO0pxaVZ+ejWFRApKMEMAe+iW21KjQrWrjudIWTeVDdzErW7V2+Q==
X-Received: by 2002:a17:902:a9c7:b029:12b:349:b318 with SMTP id b7-20020a170902a9c7b029012b0349b318mr9498362plr.13.1630082849260;
        Fri, 27 Aug 2021 09:47:29 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id s16sm6494473pfu.108.2021.08.27.09.47.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Aug 2021 09:47:28 -0700 (PDT)
Subject: Re: [PATCH NET-NEXT] ipv6: skb_expand_head() adjust skb->truesize
 incorrectly
To:     Vasily Averin <vvs@virtuozzo.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Christoph Paasch <christoph.paasch@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, kernel@openvz.org,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
References: <6858f130-e6b4-1ba7-ed6f-58c00152be69@virtuozzo.com>
 <ef4458d9-c4d7-f419-00f2-0f1cea5140ce@virtuozzo.com>
 <CALMXkpZkW+ULMMFgeY=cag1F0=891F-v9NEVcdn7Tyd-VUWGYA@mail.gmail.com>
 <1c12b056-79d2-126a-3f78-64629f072345@gmail.com>
 <2d8a102a-d641-c6c1-b417-7a35efa4e5da@gmail.com>
 <bd90616e-8e86-016b-0979-c4f4167b8bc2@gmail.com>
 <7a6588ad-00fe-cfb9-afcd-d8b31be229cd@virtuozzo.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <478ae732-161d-c692-b60a-6df11c37ac2c@gmail.com>
Date:   Fri, 27 Aug 2021 09:47:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <7a6588ad-00fe-cfb9-afcd-d8b31be229cd@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/27/21 8:23 AM, Vasily Averin wrote:

> I asked Alexey Kuznetsov to look at this problem. Below is his answer:
> "I think the current scheme is obsolete. It was created
> when we had only two kinds of skb accounting (rmem & wmem)
> and with more kinds of accounting it just does not work.
> Even there we had ignored problems with adjusting accounting.
> 
> Logically the best solution would be replacing ->destructor,
> set_owner* etc with skb_ops. Something like:
> 
> struct skb_ops
> {
>         void init(struct sk_buff * skb, struct skb_ops * ops, struct
> sock * owner);
>         void fini(struct sk_buff * skb);
>         void update(struct sk_buff * skb, int adjust);
>         void inherit(struct sk_buff * skb2, struct sk_buff * skb);
> };
> 
> init - is replacement for skb_set_owner_r|w
> fini - is replacement for skb_orphan
> update - is new operation to be used in places where skb->truesize changes,
>        instead of awful constructions like:
> 
>        if (!skb->sk || skb->destructor == sock_edemux)
>             skb->truesize += size - osize;
> 
>        Now it will look like:
> 
>        if (skb->ops)
>             skb->ops->update(skb, size - osize);
> 
> inherit - is replacement for also awful constructs like:
> 
>       if (skb->sk)
>             skb_set_owner_w(skb2, skb->sk);
> 
>       Now it will be:
> 
>       if (skb->ops)
>             skb->ops->inherit(skb2, skb);
> 
> The implementation looks mostly obvious.
> Some troubles can be only with new functionality:
> update of accounting was never done before.
> 
> 
> More efficient, functionally equivalent, but uglier and less flexible
> alternative would be removal of ->destructor, replaced with
> a small numeric indicator of ownership:
> 
> enum
> {
>         SKB_OWNER_NONE,  /* aka destructor == NULL */
>         SKB_OWNER_WMEM,  /* aka destructor == sk_wfree */
>         SKB_OWNER_RMEM,  /* aka destructor == sk_rfree */
>         SKB_OWNER_SK,    /* aka destructor == sk_edemux */
>         SKB_OWNER_TCP,   /* aka destructor == tcp_wfree */
> }
> 
> And the same init,fini,inherit,update become functions
> w/o any inidirect calls. Not sure it is really more efficient though."
> 

Well, this does not look as stable material, and would add a bunch
of indirect calls which are quite expensive these days (CONFIG_RETPOLINE=y)

I suggest we work on a fix, using existing infra, then eventually later
try to refactor if this is really bringing improvements.

A fix could simply be a revert of 0c9f227bee119 ("ipv6: use skb_expand_head in ip6_xmit")
since only IPv6 has the problem (because of arbitrary headers size)



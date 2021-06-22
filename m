Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 125D93B0D30
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 20:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232418AbhFVSuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 14:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbhFVSuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 14:50:18 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA431C061574
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 11:48:00 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id d11so22456138wrm.0
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 11:48:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iAITes+Jo71idw2S0QBWHuXUwCSrq9cK57h7PnnnYf4=;
        b=X1Dakbuapi5D3kXJdZpcon1q/b2GXOa8DDUAsXVbb2Ut95DB2yZ4cJ0JJ5qocsMniJ
         Kd1LpbNb/dM8Hm6YHNsYF3bqkH7L+AJL+uEP8D5NS6Tr80pI6IKNDd7ebbCmHFkhS1lw
         h1wAekphlEmpLRIU7SYoSL1kAoMh1zOxn6nKKAIuEVDqQ1QgQqYu1Nf/5zAAJJJ7TCTy
         4EBRmXuZBZdBxbXw1hG6Pvw4lhLGADoh3ffUpjTV9qIjsr8TUS+uNwWrRvML0RPvchPA
         8kbMgTtwUoir+X390DCHj2uhs9cz6LjnaiWyREh5ZLwQjxcnuTQqvh6WrtIJLXPmmcUE
         kLSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iAITes+Jo71idw2S0QBWHuXUwCSrq9cK57h7PnnnYf4=;
        b=J5+1ckz44i1i/JynyMk7ZkkgqKgqfgidCGWTyx3Qc24Wk49/cLJ7lRXUoENqxD7/Mx
         ygLv1RDhYzIpOEssnAEGq9Z/y7dyswTjOXniMO2fT1/uuLBqLIA0ar+joxOPLOwCttSr
         vmdrooVGbVC+wO0YJPreK13Tx+4nq7FM34b8OoTJdmxL5NkbffytI1+2punKx/YuvhBG
         rK5/fUB6T8iJnFWRbn/1wB2Jgfjk3dKbCIlSaE9X5Tl4Xqi9JYHpfya2XiKZAl2cm5gJ
         iq2ffZ3L9gvtEu9mDrDOdo8Pkk50l51v7+1a6TWWfUzCPWs7CrWI86gjCAebTQjKCCpY
         u5ow==
X-Gm-Message-State: AOAM530ZbfEpvH/kuL5V0weuaPJCzvkCfhO6v7xRaVZQF17cbS0n/SL5
        Y7Z2UGIG70ecTLGh7jox1VM=
X-Google-Smtp-Source: ABdhPJzB8JLxHK5LTxI1oNV3fZgIu7v4MgpuKu8NWDdCb+fqLbSCYFXyZ3URSytr7pfOCFc1/kJCCQ==
X-Received: by 2002:adf:f1d0:: with SMTP id z16mr6761184wro.307.1624387679514;
        Tue, 22 Jun 2021 11:47:59 -0700 (PDT)
Received: from [10.0.0.15] ([37.164.53.25])
        by smtp.gmail.com with ESMTPSA id m184sm3368013wmm.26.2021.06.22.11.47.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 11:47:59 -0700 (PDT)
Subject: Re: [PATCH net-next] ip: avoid OOM kills with large UDP sends over
 loopback
To:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, willemb@google.com,
        dsahern@gmail.com, yoshfuji@linux-ipv6.org, Dave Jones <dsj@fb.com>
References: <20210621231307.1917413-1-kuba@kernel.org>
 <8fe00e04-3a79-6439-6ec7-5e40408529e2@gmail.com>
 <20210622095422.5e078bd4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <462f87f4-cc90-1c0e-3a9f-c65c64781dc3@gmail.com>
 <20210622110935.35318a30@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <d4e2cf28-89f9-7c1f-91de-759de2c47fae@gmail.com>
Date:   Tue, 22 Jun 2021 20:47:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210622110935.35318a30@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/22/21 8:09 PM, Jakub Kicinski wrote:
> On Tue, 22 Jun 2021 19:48:43 +0200 Eric Dumazet wrote:
>>>> What about using 	sock_alloc_send_pskb(... PAGE_ALLOC_COSTLY_ORDER)
>>>> (as we did in unix_dgram_sendmsg() for large packets), for SG enabled interfaces ?  
>>>
>>> PAGE_ALLOC_COSTLY_ORDER in itself is more of a problem than a solution.
>>> AFAIU the app sends messages primarily above the ~60kB mark, which is
>>> above COSTLY, and those do not trigger OOM kills. All OOM kills we see
>>> have order=3. Checking with Rik and Johannes W that's expected, OOM
>>> killer is only invoked for allocations <= COSTLY, larger ones will just
>>> return NULL and let us deal with it (e.g. by falling back).  
>>
>> I  really thought alloc_skb_with_frags() was already handling low-memory-conditions.
>>
>> (alloc_skb_with_frags() is called from sock_alloc_send_pskb())
>>
>> If it is not, lets fix it, because af_unix sockets will have the same issue ?
> 
> af_unix seems to cap at SKB_MAX_ALLOC which is order 2, AFAICT.

It does not cap to SKB_MAX_ALLOC.

It definitely attempt big allocations if you send 64KB datagrams.

Please look at commit d14b56f508ad70eca3e659545aab3c45200f258c
    net: cleanup gfp mask in alloc_skb_with_frags

This explains why we do not have __GFP_NORETRY there.

> 
> Perhaps that's a good enough fix in practice given we see OOMs with
> order=3 only?
> 
> I'll review callers of alloc_skb_with_frags() and see if they depend 
> on the explicit geometry of the skb or we can safely fallback to pages.
> 

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0A8E2AC00B
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 16:39:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729843AbgKIPj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 10:39:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726691AbgKIPj2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 10:39:28 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC886C0613CF;
        Mon,  9 Nov 2020 07:39:27 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id k2so5773732wrx.2;
        Mon, 09 Nov 2020 07:39:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MIC9xtdEfUk9GCC22X4+Zzg2XIu8aFShc9zTKSGRy5o=;
        b=jj0OYesOC4bghByHFhacOiHwne1SwqAgKpJetmE9X437Z45juQ90SyEwRgs/zFXOjS
         af5JPqPpOIVxFhPKOZlIy51b5INeK8dCaejapCzxPzO5ptdbnAx/jsCaOQ1JiNt6KUeY
         y0NgWnUqD3LnOiIVmd4RDnG/oAnCAB4ZUmVaYGq43E/aKSPWnuIwWdwz+RGYvFdba72T
         kQygppLs+kDvRNDDz9otzC3JZhZbvdoddfH2yb1m3uZ0kLyxdXVxq0tCq0aOBQajk8su
         ITlVN3UkIzBqmMQdRusBs7MNaetqQi1uX4Bbm/bi+Ba20mY9a4GQnDO6N2bKYthfdQG1
         NJhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MIC9xtdEfUk9GCC22X4+Zzg2XIu8aFShc9zTKSGRy5o=;
        b=bSSwOWjzPe+GSTulLHJndljx70mfOEDdTM0NV4vgcOXqEI2FbP7/sELlNgMsZ+Jfsf
         rn/CM1Cbor1yxXj+ZqOUQRifSHrvuWOwx3aADuuBI/4dBFWNNKkRnYemI0D7yVHuOX9o
         2nI4EFarbkcQ24QtwMxEtp7IEmunqmQBYwUoLKfV0OTFvRQxLWmgZ0IPsEa77tHThPpI
         g88WpTsaEultmp+hO7IOfATB+D5k0y10FDD/bXMBVHhBnmUEWuLEmlteksIJaRaxM99L
         Onw27t0jV0UY8fb7uQGcjxJk6OKC0fhgQNpJ3umZPHoxkgOAvCnDCJodp1JW7LXtH8+M
         sgMA==
X-Gm-Message-State: AOAM5301MHfOYd6xODalUWnZmVki2lV9fxzEcsutQeAIuoFqpyy7qjMI
        gAOmEc/kHtxnDJB+OA140zI=
X-Google-Smtp-Source: ABdhPJz+yoFlZke7o+COe1FiZyEj6mB9rrELKvWcZ0I7es4x8Tjg98W+tMwrirxY7rqR1p1j8jOnhw==
X-Received: by 2002:adf:93e1:: with SMTP id 88mr17901739wrp.37.1604936366733;
        Mon, 09 Nov 2020 07:39:26 -0800 (PST)
Received: from [192.168.8.114] ([37.170.121.171])
        by smtp.gmail.com with ESMTPSA id a17sm13859156wra.61.2020.11.09.07.39.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2020 07:39:26 -0800 (PST)
Subject: Re: [PATCH] net: tcp: ratelimit warnings in tcp_recvmsg
To:     Menglong Dong <menglong8.dong@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Menglong Dong <dong.menglong@zte.com.cn>
References: <5fa93ef0.1c69fb81.bff98.2afc@mx.google.com>
 <CANn89iJNYyON8khtQYzZi2LdV1ZSopGfnXB1ev9bZ2cDUdekHw@mail.gmail.com>
 <CADxym3bP=BRbVAnDCzmrrAyh3i=QO3gAWnUwpU==TskFY-GHYg@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <0ccc35a7-3d19-e37d-52d1-7e900091cc1b@gmail.com>
Date:   Mon, 9 Nov 2020 16:39:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <CADxym3bP=BRbVAnDCzmrrAyh3i=QO3gAWnUwpU==TskFY-GHYg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/9/20 3:48 PM, Menglong Dong wrote:
> On Mon, Nov 9, 2020 at 9:36 PM Eric Dumazet <edumazet@google.com> wrote:
>>
>> I do not think this patch is useful. That is simply code churn.
>>
>> Can you trigger the WARN() in the latest upstream version ?
>> If yes this is a serious bug that needs urgent attention.
>>
>> Make sure you have backported all needed fixes into your kernel, if
>> you get this warning on a non pristine kernel.
> 
> Theoretically, this WARN() shouldn't be triggered in any branches.
> Somehow, it just happened in kernel v3.10. This really confused me. I
> wasn't able to keep tracing it, as it is a product environment.
> 
> I notice that the codes for tcp skb receiving didn't change much
> between v3.10 and the latest upstream version, and guess the latest
> version can be triggered too.
> 
> If something is fixed and this WARN() won't be triggered, just ignore me.
> 

Yes, I confirm this WARN() should not trigger.

The bug is not in tcp recvmsg(), that is why you do not see obvious
fix for this issue in 3.10


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4548453B2E
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 21:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbhKPUsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 15:48:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231330AbhKPUsS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 15:48:18 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D844FC061570
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 12:45:20 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id o4so1188399oia.10
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 12:45:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=nAZDxCcXTbTi4vQVlLkjRALMnFrMjvIgn23gy0EjPTc=;
        b=cBRgkuJbzeqP2xCxkwpHxaTTbh78/Qdvp9oPfoFNyeJr1cHrF6fThNiS/OziwH0eYM
         JdnVQbXqfifpITQTZYDGnxjp7lH6gxqpclB3dzrymndue4LG+oU22RxF29wiFSyjNyhs
         i7BvUS71BXNTa77Skw9o00fpdyxTjqxDTNt0QvLJ3fcvv0YN7Q2PgF+Kg8AVsXWmPqyf
         gua5Zke6viODJ8aHbUeeoLyFGWv33LFFifOehbNDFtU4czCVQfGtzX++0jy2QxEyBKSf
         9pF9Y2BvGaTyGQswA9piy9XDyOAPwOJjt7wZ5Q4V/1A5MHx01iiqhAAQpUTY14N5kNo7
         iTwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nAZDxCcXTbTi4vQVlLkjRALMnFrMjvIgn23gy0EjPTc=;
        b=2fDFlQY8pAFUlZcPnEP90SM3ruTEQMGvfeD+gcRrYXTahs7JF+Du8Ykffjm0/ukiZm
         zwQtdNSwDSP1qH9iskcu+M5iv64bl1rZg/h1DLp9/sQMTqthA/yvBrgkAVEjyRqUQM/C
         y8HqwMXhHe7xzulif5LhDgh+MRDnMBdFtVcbmIDFKuCQ24dZ8bksFENN4ulqzhfWm4nI
         tpo/j9xY7tqClXZ0hRIbhGAbB4N3T2FefJ/yuLrbStlC8SQ7rAOmuvyxJRNE9tZPrgGW
         gYRGfRvrp1hxzjvTcYqBsWStaAgW5onDHTkC09Bn5XYyICR9xFQa0npU0CCdEm7H4TM5
         MwaQ==
X-Gm-Message-State: AOAM5304PW1msPe99B3JPhxywYfd0c0ZBIsMaLxLBV0+R3ZDntsp+Dg1
        W0ZYfvmWowprhO3MwuK+oGkhlJ2mGns=
X-Google-Smtp-Source: ABdhPJxNg4Fwmfrz6JTeKYaA3PVPqegmz2nWfKNSDUmilGB1YOOYceUIYfOBGY+Ar+V4wHbxnq4TKA==
X-Received: by 2002:a54:4102:: with SMTP id l2mr26993368oic.87.1637095520283;
        Tue, 16 Nov 2021 12:45:20 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id l9sm3295109oom.4.2021.11.16.12.45.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Nov 2021 12:45:19 -0800 (PST)
Message-ID: <c0ad5909-85ba-3c15-ba5f-c5e257069f8b@gmail.com>
Date:   Tue, 16 Nov 2021 13:45:18 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.1
Subject: Re: [PATCH net-next 17/20] tcp: defer skb freeing after socket lock
 is released
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Arjun Roy <arjunroy@google.com>
References: <20211115190249.3936899-1-eric.dumazet@gmail.com>
 <20211115190249.3936899-18-eric.dumazet@gmail.com>
 <20211116062732.60260cd2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89iJL=pGQDgqqKDrL5scxs_S5yMP013ch3-5zwSkMqfMn3A@mail.gmail.com>
 <CANn89iJ5kWdq+agqif+72mrvkBSyHovphrHOUxb2rj-vg5EL8w@mail.gmail.com>
 <20211116072735.68c104ee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89iJb7s-JoCCfn=eoxZ_tX_2RaeEPZKO1aHyHtgHxLXsd2A@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <CANn89iJb7s-JoCCfn=eoxZ_tX_2RaeEPZKO1aHyHtgHxLXsd2A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/16/21 9:46 AM, Eric Dumazet wrote:
> On Tue, Nov 16, 2021 at 7:27 AM Jakub Kicinski <kuba@kernel.org> wrote:
>>
>> On Tue, 16 Nov 2021 07:22:02 -0800 Eric Dumazet wrote:
>>> Here is the perf top profile on cpu used by user thread doing the
>>> recvmsg(), at 96 Gbit/s
>>>
>>> We no longer see skb freeing related costs, but we still see costs of
>>> having to process the backlog.
>>>
>>>    81.06%  [kernel]       [k] copy_user_enhanced_fast_string
>>>      2.50%  [kernel]       [k] __skb_datagram_iter
>>>      2.25%  [kernel]       [k] _copy_to_iter
>>>      1.45%  [kernel]       [k] tcp_recvmsg_locked
>>>      1.39%  [kernel]       [k] tcp_rcv_established
>>
>> Huh, somehow I assumed your 4k MTU numbers were with zero-copy :o

I thought the same. :-)

>>
>> Out of curiosity - what's the softirq load with 4k? Do you have an
>> idea what the load is on the CPU consuming the data vs the softirq
>> processing with 1500B ?
> 
> On my testing host,
> 
> 4K MTU : processing ~2,600.000 packets per second in GRO and other parts
> use about 60% of the core in BH.

4kB or 4kB+hdr MTU? I ask because there is a subtle difference in the
size of the GRO packet which affects overall efficiency.

e.g., at 1500 MTU, 1448 MSS, a GRO packet has at most 45 segments for a
GRO size of 65212. At 4000 MTU, 3948 MSS, a GRO packet has at most 16
segments for a GRO packet size of 63220. I have noticed that 3300 MTU is
a bit of sweet spot with MLX5/ConnectX-5 at least - 20 segments and
65012 GRO packet without triggering nonlinear mode.


> (Some of this cost comes from a clang issue, and the csum_partial() one
> I was working on last week)
> NIC RX interrupts are firing about 25,000 times per second in this setup.
> 
> 1500 MTU : processing ~ 5,800,000 packets per second uses one core in
> BH (and also one core in recvmsg()),
> We stay in NAPI mode (no IRQ rearming)
> (That was with a TCP_STREAM run sustaining 70Gbit)
> 
> BH numbers also depend on IRQ coalescing parameters.
> 

What NIC do you use for testing?

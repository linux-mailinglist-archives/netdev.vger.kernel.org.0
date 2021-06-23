Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDF9E3B2244
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 23:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbhFWVQ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 17:16:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhFWVQz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 17:16:55 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E166C061574
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 14:14:36 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id m18so4188976wrv.2
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 14:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XG4mbve2XHnqzbEI0uwGUip+XcIWrptkZo/vS2VVx5Q=;
        b=d2udzGgzkj3BWlhmWlu8MEsoo1/x0qGvDiFtlxtmXXDeJrd+AzbzkhATS90dskyZxV
         1aslIAvqvF7SLJLR+w1lSzYjfOzJ6urm3gkhzd2bRRIov3xOKrEbQ3zgd0mnFhYhoz+W
         Yh+wMsuLFeLZPghgqpQoiPu2PoZPcIQI9zqjJrNjd4HHijPRSLA7u0cz/UZmuOCEB/BU
         emx/RUwyXOwSnLWwERE6DRNIFcXgNsX1paFb8J7oTMUDx0evQv4H5o9oyrekQtztkowG
         MYuXYSvHmTISFv89ALWuWgf4dk8YZLupzti53wxfTe8hWt14M1jlVuMKb1Ga24P08z7P
         GPDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XG4mbve2XHnqzbEI0uwGUip+XcIWrptkZo/vS2VVx5Q=;
        b=sSfmkq1UpW67Djp3hq99YCOIR6lmU07ZWbngvo+ns/q9hZ0BUtZ+Z0cueYr5mrxmeH
         qPWk0CZUKP6Vxs6nDOZ6clj8MTEiWejlmgVuQ2daTmKDocpWe2Xql/ZZhFi7r1TPZ8BG
         nstLu9Yi93VuCCviKp168O7wEsKj/2A5onE13wIvBI5W8ZP7Kl3zwrq9dOu0CyjblIsk
         E4h9D6CdQasUfHClDIkEGkfrnLN3ZZjlWOqwdi0//SZQw+ZUSrszlnPT8qTTOQAUJzTX
         bzwo4RhjFfhY1Fkzf+ZZkNLL67pHb3GQ8YWMvDPlz6oq0AScquT/EVy3qOWM/L1aBkK7
         Z7Ig==
X-Gm-Message-State: AOAM531oTa/qVsVC4Ni4vSrWlVh8PeEqYV4Nol853Nr6XL8mM4Fsisjm
        o35GwI9/TGaOIwaA/XaZ75w=
X-Google-Smtp-Source: ABdhPJwmwy7BdZu/iwoBDESV+CLDw8PIq8XTOIXvk6ngxPX+yTAJu8J0aUs19AmR62Fp+rXV9XM9wA==
X-Received: by 2002:adf:c790:: with SMTP id l16mr104273wrg.121.1624482875069;
        Wed, 23 Jun 2021 14:14:35 -0700 (PDT)
Received: from [10.0.0.10] ([37.173.240.181])
        by smtp.gmail.com with ESMTPSA id n16sm1099149wrx.85.2021.06.23.14.14.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 14:14:34 -0700 (PDT)
Subject: Re: [PATCH net-next v3] net: ip: avoid OOM kills with large UDP sends
 over loopback
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, willemb@google.com,
        eric.dumazet@gmail.com, dsahern@gmail.com, yoshfuji@linux-ipv6.org,
        Dave Jones <dsj@fb.com>
References: <20210623162328.2197645-1-kuba@kernel.org>
 <20210623214555.5c683821@carbon>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <e9de56b5-68da-91b3-7912-93b7229634fc@gmail.com>
Date:   Wed, 23 Jun 2021 23:14:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210623214555.5c683821@carbon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/23/21 9:45 PM, Jesper Dangaard Brouer wrote:
> On Wed, 23 Jun 2021 09:23:28 -0700
> Jakub Kicinski <kuba@kernel.org> wrote:
> 
>> Dave observed number of machines hitting OOM on the UDP send
>> path. The workload seems to be sending large UDP packets over
>> loopback. Since loopback has MTU of 64k kernel will try to
>> allocate an skb with up to 64k of head space. This has a good
>> chance of failing under memory pressure. What's worse if
>> the message length is <32k the allocation may trigger an
>> OOM killer.
>>
>> This is entirely avoidable, we can use an skb with page frags.
>>
>> af_unix solves a similar problem by limiting the head
>> length to SKB_MAX_ALLOC. This seems like a good and simple
>> approach. It means that UDP messages > 16kB will now
>> use fragments if underlying device supports SG, if extra
>> allocator pressure causes regressions in real workloads
>> we can switch to trying the large allocation first and
>> falling back.
>>
>> Reported-by: Dave Jones <dsj@fb.com>
>> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>> ---
>>  net/ipv4/ip_output.c  | 4 +++-
>>  net/ipv6/ip6_output.c | 4 +++-
>>  2 files changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
>> index c3efc7d658f6..790dd28fd198 100644
>> --- a/net/ipv4/ip_output.c
>> +++ b/net/ipv4/ip_output.c
>> @@ -1077,7 +1077,9 @@ static int __ip_append_data(struct sock *sk,
>>  			if ((flags & MSG_MORE) &&
>>  			    !(rt->dst.dev->features&NETIF_F_SG))
>>  				alloclen = mtu;
>> -			else if (!paged)
>> +			else if (!paged &&
>> +				 (fraglen + hh_len + 15 < SKB_MAX_ALLOC ||
> 
> What does the number 15 represent here?

Just look at the existing code, few lines below

skb = alloc_skb(alloclen + hh_len + 15, ...


> 
>> +				  !(rt->dst.dev->features & NETIF_F_SG)))
>>  				alloclen = fraglen;
>>  			else {
>>  				alloclen = min_t(int, fraglen, MAX_HEADER);
>> diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
>> index ff4f9ebcf7f6..ae8dbd6cdab1 100644
>> --- a/net/ipv6/ip6_output.c
>> +++ b/net/ipv6/ip6_output.c
>> @@ -1585,7 +1585,9 @@ static int __ip6_append_data(struct sock *sk,
>>  			if ((flags & MSG_MORE) &&
>>  			    !(rt->dst.dev->features&NETIF_F_SG))
>>  				alloclen = mtu;
>> -			else if (!paged)
>> +			else if (!paged &&
>> +				 (fraglen + hh_len < SKB_MAX_ALLOC ||
> 
> The number 15 is not use here.

Because the alloc_skb() done later does not use + 15



> 
>> +				  !(rt->dst.dev->features & NETIF_F_SG)))
>>  				alloclen = fraglen;
>>  			else {
>>  				alloclen = min_t(int, fraglen, MAX_HEADER);
> 
> 
> 

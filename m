Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACA6D3B0BD4
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 19:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232334AbhFVRwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 13:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbhFVRwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 13:52:14 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12F91C061574
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 10:49:57 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id f15so9220523wro.8
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 10:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+XDHXrZjralMTB4ySH8RMImUrzfgX5YNWKbVC712x18=;
        b=FczM7L5T6AoGJQoRPZ84gb2vfkKxH3G4e1e8R/paUQviiZCAwZgEqvEBQlthHgFcZc
         QkKZGRLrMZ43jqEAzNryFjm4Veq8eu1s0lfAr4DD3ToU7W9K/gGljkDU6DSDZRp+IY4r
         51KnR6zX/1QbEvAbNQU1cxKwm14VA1ToEXw1/dLnoQNDaPk4DmPoi78ytQUSmr8xSNsS
         QtUvqN866ID5GV/Szb0+b/lXd7Fo3iXKEZl5ouaYHf2+h36LYTBTM/mS4JbdiPUcEc65
         kForRtSCotvLMBHaEIAZCx6n9dQ+qq9pcxbHTTycJmhR2BFV5dvS5mUoogtybdb3lWeb
         8Big==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+XDHXrZjralMTB4ySH8RMImUrzfgX5YNWKbVC712x18=;
        b=UZTuUtshyDovNtR/w4F/AikPrMZY1eFStAFHw8iBAXVl83CGn0gCkHP83eCmsBZ5at
         +y/9YOXGucZlmy+L7MUZpgybFucKPGoSpzLHzUnjmHmPMMFjoOOBmrGsTHtzegUT53SN
         IbKytZQAUiL+zg6Bdk2sxxhs5VyVYHz9i8PBKb1RO8toIN0n0beO30KY/148Johe+LID
         DtK6DxcuC/ZudYg7y3diL3mC2IKruFyeosaZmyRMLmrlQN2YmF2VpvMKTxK34F8MF2cG
         HlyCwqmZPWkYEDoat5gv5sZVrVUsbcC/AdpsMy7QZCFV+SPqjgkHTehvcXEYBeOiwi1T
         wcaA==
X-Gm-Message-State: AOAM5308ZrHMELuxHmhWEGq6NP7PQzhsGBIfPKw0xAQAWfLQxROdfca/
        iVqfdq8gcucZ3jjfmEqjnvE=
X-Google-Smtp-Source: ABdhPJyqaPP/eJT7f8/42MTE+/UeKnlbNq7rcAOiH/pnfqTyYULFbl8ciGngWtyTEWG+wpgh+MusRA==
X-Received: by 2002:a5d:525a:: with SMTP id k26mr6214645wrc.303.1624384195678;
        Tue, 22 Jun 2021 10:49:55 -0700 (PDT)
Received: from [192.168.181.98] (15.248.23.93.rev.sfr.net. [93.23.248.15])
        by smtp.gmail.com with ESMTPSA id z9sm3151746wmf.43.2021.06.22.10.49.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 10:49:55 -0700 (PDT)
Subject: Re: [PATCH net-next] ip: avoid OOM kills with large UDP sends over
 loopback
To:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, willemb@google.com,
        dsahern@gmail.com, yoshfuji@linux-ipv6.org, Dave Jones <dsj@fb.com>
References: <20210621231307.1917413-1-kuba@kernel.org>
 <8fe00e04-3a79-6439-6ec7-5e40408529e2@gmail.com>
 <20210622095422.5e078bd4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20210622101952.28839d7e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <aeb56c34-4549-6f05-2077-2be9594a17e4@gmail.com>
Date:   Tue, 22 Jun 2021 19:49:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210622101952.28839d7e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/22/21 7:19 PM, Jakub Kicinski wrote:
> On Tue, 22 Jun 2021 09:54:22 -0700 Jakub Kicinski wrote:
>>>> +static inline void sk_allocation_push(struct sock *sk, gfp_t flag, gfp_t *old)
>>>> +{
>>>> +	*old = sk->sk_allocation;
>>>> +	sk->sk_allocation |= flag;
>>>> +}
>>>> +    
>>>
>>> This is not thread safe.
>>>
>>> Remember UDP sendmsg() does not lock the socket for non-corking sends.  
>>
>> Ugh, you're right :(
> 
> Hm, isn't it buggy to call sock_alloc_send_[p]skb() without holding the
> lock in the first place, then? The knee jerk fix would be to add another 
> layer of specialization to the helpers:

It is not buggy. Please elaborate if you found it is.



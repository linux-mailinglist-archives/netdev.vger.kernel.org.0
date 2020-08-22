Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8257924E46C
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 03:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbgHVBRv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 21:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726663AbgHVBRt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 21:17:49 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6AE6C061573
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 18:17:49 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id s14so1664532plp.4
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 18:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PBr38ONHjHf5Yd26dktyIMb9CQzaslw/BwWMbbALQpQ=;
        b=uG/AkSj5/IjNYQ9UVYePNS2oCaLR/4e6i/DjKyEGlCjXmivnsJcrE0xeERompjTmjS
         ebUZqc42ex77BNwx7NVnxS8yCxYEm4YsOrxLAqsHadse3MymGi2F3Jjp85gw5lJM+OlL
         9RkDj1o8OJOmgS5kPlbuzk2z0fP1AH+/qFKIbyhMMMi6Snj9SLCbxE8Ojb7nAUHsNchm
         vXr2ZHFKxkh3qP3vEr9Vihc1ce0FFCHGOKznmJJmI8nlk7O0FVhpzQsZrg/w5APdubO+
         4G4W2Swq0w6n3+5pzXoOVT+DlvKOI/F/HQqqNmCc3MEfHkzjQKPxe2dUmkjDJuEEO8iw
         kwXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PBr38ONHjHf5Yd26dktyIMb9CQzaslw/BwWMbbALQpQ=;
        b=QPXMeKOKID6AI729eir8XwZuXRLJW2xKPHZVaOd5p9IR+EIVB1yahN4VT22PqYicLb
         qzuQn2zz3dD2w6QoAhuK7zKMPDbyqydMjzD68BoQVMN1RNR+O8zJubcGZLtm8AXt7Mnv
         4u1jTc23aw4rG+L8fPftFgng1YWdKK9DiLeKm/24QwzDoiclMt6emwQTl62R8TrZ2qKP
         oNmrNUOwpu1b1j5el1JX9+yuD8pK7KTzp8tY5iYDMF3IPSOVaAc347fAmuDuPihOl5mz
         oYLscD0odLLBtuaMEuWyOJ9LY5RhGxelCN2bNf0iYQVW0LhynLJPeGkiEIXQrQvHiSV9
         I4cA==
X-Gm-Message-State: AOAM5328NhmM9TPYS97fFfhpsQM+6817NUIg9Rh1x6Mu5ZTJhNuJIHtN
        14NER+hum5295hQdZJ5c4iWC+Q==
X-Google-Smtp-Source: ABdhPJztUbcRVeuCZGYFKQbuGeH8ynlrlIdiE7wY63N3moELsxZsB/QURX6hcGhgWt+nlo8mkSGN1w==
X-Received: by 2002:a17:90a:d504:: with SMTP id t4mr4587526pju.58.1598059068463;
        Fri, 21 Aug 2020 18:17:48 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id mp1sm3216003pjb.27.2020.08.21.18.17.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Aug 2020 18:17:47 -0700 (PDT)
Subject: Re: [PATCH net-next 2/2] io_uring: ignore POLLIN for recvmsg on
 MSG_ERRQUEUE
To:     Luke Hsiao <lukehsiao@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Luke Hsiao <luke.w.hsiao@gmail.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Arjun Roy <arjunroy@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Eric Dumazet <edumazet@google.com>
References: <20200820234954.1784522-1-luke.w.hsiao@gmail.com>
 <20200820234954.1784522-3-luke.w.hsiao@gmail.com>
 <20200821134144.642f6fbb@kicinski-fedora-PC1C0HJN>
 <d0819955-6466-9c11-880d-ae607f033b84@kernel.dk>
 <CADFWnLzwUjs7Sw98y0vitTyPxCzsopeYKO0bVdG9r4uG7qBg2g@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9abca73b-de63-f69d-caff-ae3ed24854de@kernel.dk>
Date:   Fri, 21 Aug 2020 19:17:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CADFWnLzwUjs7Sw98y0vitTyPxCzsopeYKO0bVdG9r4uG7qBg2g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/21/20 6:08 PM, Luke Hsiao wrote:
> Hi Jakub and Jens,
> 
> Thank you for both of your reviews. Some responses inline below.
> 
> On Fri, Aug 21, 2020 at 2:11 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 8/21/20 2:41 PM, Jakub Kicinski wrote:
>>> On Thu, 20 Aug 2020 16:49:54 -0700 Luke Hsiao wrote:
>>>> +    /* If reading from MSG_ERRQUEUE using recvmsg, ignore POLLIN */
>>>> +    if (req->opcode == IORING_OP_RECVMSG && (sqe->msg_flags & MSG_ERRQUEUE))
>>>> +            mask &= ~(POLLIN);
>>>
>>> FWIW this adds another W=1 C=1 warnings to this code:
>>>
>>> fs/io_uring.c:4940:22: warning: invalid assignment: &=
>>> fs/io_uring.c:4940:22:    left side has type restricted __poll_t
>>> fs/io_uring.c:4940:22:    right side has type int
>>
>> Well, 8 or 9 of them don't really matter... This is something that should
>> be cleaned up separately at some point.
> 
> In the spirit of not adding a warning, even if it doesn't really
> matter, I'd like to fix this. But, I'm struggling to reproduce these
> warnings using upstream net-next and make for x86_64. With my patches
> on top of net-next/master, I'm running
> 
> $ make defconfig
> $ make -j`nproc` W=1
> 
> I don't see the warning you mentioned in the logs. Could you tell me
> how I can repro this warning?

You should see them with C=1. But as I said, don't worry about it, as that's
a class of warnings and several exist already. It needs to get cleaned up
separately.

>>> And obviously the brackets around POLLIN are not necessary.
>>
>> Agree, would be cleaner without!
> 
> Thanks, I'll also remove these unnecessary parens in v2 of the patch series.

Please do, thanks!

-- 
Jens Axboe


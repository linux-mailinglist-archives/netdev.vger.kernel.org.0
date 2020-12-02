Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 591862CC2B0
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 17:49:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730590AbgLBQqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 11:46:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727482AbgLBQqn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 11:46:43 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D12FC0613CF
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 08:46:02 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id o1so4743560wrx.7
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 08:46:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=B618rifWtTe7nRv47/DT0ZTGc2yNNKNh9AQE7f3/sbk=;
        b=bUNEoXKnsNuXGio7BNpxNpacY+AnOggyqsNh8Bo/hNKTeB1ZvKbX0AQnO9M37yeO4v
         hWS5xQabTn6tpRl5KZYMOEGHWJWMRi3UYiQa+a4qlYOnBRWetzOeYIIpYcaUDzdr9MEZ
         n+RYXne2bXz5UBJSr4A9x09oXxbD3nCQo68p0PnVNWx8Z0dP8VG5RsuWxw2ivJ+8myp3
         bu5fYIDmhj4gj6LaoLLDwcXREfFDsGODfoRFlsOwqEWvcZ4f77Wl9n7tbKIMKH/hAfmL
         W07fib7X0FEmF2jVHOm4CP0n4MQhHUylml+A+6lR4mDtsiV365TSEVa//OaDB8jflHAd
         fJHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=B618rifWtTe7nRv47/DT0ZTGc2yNNKNh9AQE7f3/sbk=;
        b=P6PmvS9BHL9Livqpkvr5Rnnoe8iUreKVzrHS6k2eO2KF3PSDpOqTlExIUQ7O3omyqx
         jrTfI5mRuZb/eKB4Yw7QytIuIL5VBx7bmirbH5pPY7OVUetOt9B5PLBhqvOgSDlbHRMG
         j9Vt7wGmFfiZD6gbaB3NWvFNy6tHMYTpOTvkOsBkWNlQNxvu0xMl1y1SmaKXw+kRVhWN
         OvLr4/z4g0nfQ/W8IXM0/x8ghKnBGSXs91hp4wv+ljReNzcbCpM45Lb6kcPVob6R8/Yg
         ZEjmg1APs7UPfppnF4vvMk6JEhYy6IfW4eAlSHAFCt0CZOOn986s84BsUb5ir26HR4Lm
         8s9g==
X-Gm-Message-State: AOAM53144p8MLf8gtQhunbEoKO1X2fy863XjvjAouvEhr/8OhE/ZIu4x
        212+nT2Bt+dsOPzYTY7EdtGkhiQSCbw=
X-Google-Smtp-Source: ABdhPJzs93/zanR8mIbDZjTrptMugtY53dR8BQigD6MDfXNEuhjGj5G6Jr6lqjNExcB6KU+THO0+ag==
X-Received: by 2002:adf:eb88:: with SMTP id t8mr4631049wrn.105.1606927561390;
        Wed, 02 Dec 2020 08:46:01 -0800 (PST)
Received: from [192.168.8.116] ([37.164.23.254])
        by smtp.gmail.com with ESMTPSA id y6sm2730121wmg.39.2020.12.02.08.46.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Dec 2020 08:46:00 -0800 (PST)
Subject: Re: [PATCH net-next v2] mptcp: be careful on MPTCP-level ack.
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org
References: <5370c0ae03449239e3d1674ddcfb090cf6f20abe.1606253206.git.pabeni@redhat.com>
 <fdad2c0e-e84e-4a82-7855-fc5a083bb055@gmail.com>
 <665bb3a603afebdcc85878f6b45bcf0313607994.camel@redhat.com>
 <2ac90c38-c82a-8aeb-2c01-b44a6de1bf57@gmail.com>
 <d05ac8b9-3522-e4fc-d3ce-4bea74a6dfbf@gmail.com>
 <ca50540b-f305-7519-6039-f3beced5e5d8@gmail.com>
Message-ID: <e2e9500c-f2cc-2e08-6ecc-68ed50e64cd1@gmail.com>
Date:   Wed, 2 Dec 2020 17:45:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <ca50540b-f305-7519-6039-f3beced5e5d8@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/2/20 5:32 PM, Eric Dumazet wrote:
> 
> 
> On 12/2/20 5:30 PM, Eric Dumazet wrote:
>>
>>
>> On 12/2/20 5:10 PM, Eric Dumazet wrote:
>>>
>>>
>>> On 12/2/20 4:37 PM, Paolo Abeni wrote:
>>>> On Wed, 2020-12-02 at 14:18 +0100, Eric Dumazet wrote:
>>>>>
>>>>> On 11/24/20 10:51 PM, Paolo Abeni wrote:
>>>>>> We can enter the main mptcp_recvmsg() loop even when
>>>>>> no subflows are connected. As note by Eric, that would
>>>>>> result in a divide by zero oops on ack generation.
>>>>>>
>>>>>> Address the issue by checking the subflow status before
>>>>>> sending the ack.
>>>>>>
>>>>>> Additionally protect mptcp_recvmsg() against invocation
>>>>>> with weird socket states.
>>>>>>
>>>>>> v1 -> v2:
>>>>>>  - removed unneeded inline keyword - Jakub
>>>>>>
>>>>>> Reported-and-suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
>>>>>> Fixes: ea4ca586b16f ("mptcp: refine MPTCP-level ack scheduling")
>>>>>> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
>>>>>> ---
>>>>>>  net/mptcp/protocol.c | 67 ++++++++++++++++++++++++++++++++------------
>>>>>>  1 file changed, 49 insertions(+), 18 deletions(-)
>>>>>>
>>>>>
>>>>> Looking at mptcp recvmsg(), it seems that a read(fd, ..., 0) will
>>>>> trigger an infinite loop if there is available data in receive queue ?
>>>>
>>>> Thank you for looking into this!
>>>>
>>>> I can't reproduce the issue with the following packetdrill ?!?
>>>>
>>>> +0.0  connect(3, ..., ...) = -1 EINPROGRESS (Operation now in progress)
>>>> +0.1   > S 0:0(0) <mss 1460,sackOK,TS val 100 ecr 0,nop,wscale 8,mpcapable v1 fflags[flag_h] nokey>
>>>> +0.1   < S. 0:0(0) ack 1 win 65535 <mss 1460,sackOK,TS val 700 ecr 100,nop,wscaale 8,mpcapable v1 flags[flag_h] key[skey=2] >
>>>> +0.1  > . 1:1(0) ack 1 <nop, nop, TS val 100 ecr 700,mpcapable v1 flags[flag_h]] key[ckey,skey]>
>>>> +0.1 fcntl(3, F_SETFL, O_RDWR) = 0
>>>> +0.1   < .  1:201(200) ack 1 win 225 <dss dack8=1 dsn8=1 ssn=1 dll=200 nocs,  nop, nop>
>>>> +0.1   > .  1:1(0) ack 201 <nop, nop, TS val 100 ecr 700, dss dack8=201 dll=00 nocs>
>>>> +0.1 read(3, ..., 0) = 0
>>>>
>>>> The main recvmsg() loop is interrupted by the following check:
>>>>
>>>>                 if (copied >= target)
>>>>                         break;
>>>
>>> @copied should be 0, and @target should be 1
>>>
>>> Are you sure the above condition is triggering ?
>>>
>>> Maybe read(fd, ..., 0) does not reach recvmsg() at all.
>>
>> Yes, sock_read_iter() has a shortcut :
>>
>> if (!iov_iter_count(to))    /* Match SYS5 behaviour */
>>      res = sock_recvmsg(sock, &msg, msg.msg_flags);
> 
> No idea what went wrong with my copy/paste.
> 
> The real code is more like :
> 
> if (!iov_iter_count(to))    /* Match SYS5 behaviour */
>     return 0;
>

Packetdrill recvmsg syntax would be something like

   +0	recvmsg(3, {msg_name(...)=...,
		    msg_iov(1)=[{..., 0}],
		    msg_flags=0
		    }, 0) = 0



Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24CC42CC254
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 17:31:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389091AbgLBQbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 11:31:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389127AbgLBQbO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 11:31:14 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A214C061A4D
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 08:30:18 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id e7so4686745wrv.6
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 08:30:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=m/r9so68MBI7cvUvWbAgjEbzBUm3gJd7064Fn8T1sGI=;
        b=YhNJxdhfwExxIIRphICeWtTHz0sguVZVsh3fF1GhScSOZqJdsmfYO59InDsB0Pe3oR
         1ce+rKUGReeSPvpgkqIbLQmesyGbResHSlmgHY7iG9Oip+ygUv021CzndHAx4iNjTzNk
         3i1qKhnqiykmnWTYMrw0XV5YGVfMQak3OhpEtD7Vo1rz2iVuwJehJZ2b8Vc+R/xmNsrT
         KqDswVCXFqemib+4MfMTXRvtZH2AIuE0OVHGxe0RJLwDfya3VIAV8yDSv1toZbjXuArq
         44SyUHyKZH3BQdA2fZYm7qSMLxfy6X9IVwW7w8QvS9897So9liiDVdC32hLVwVYdC7ap
         QKjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=m/r9so68MBI7cvUvWbAgjEbzBUm3gJd7064Fn8T1sGI=;
        b=HlbCcbmwZquhZRF/Edrk+/cLFYKuIPMKacOIbyhStEEMNW+QU/BbRkWcl+TauGK07t
         +vJ9NRtwiaGdMiOS+meemydrfe8siFYzz8wrwV7mxCSATHEtKWae5vdFey73qzf0II/t
         O9SJle2s4ly9sonJ5BvOGYCQRjWn35LLBCt28IE5QvivjdJI1spIduGB+akzZdcOa/Uz
         p3zs9y4cszRnr/H1mP753ZIkM17fpig4ipz5ocWhuZHKV6tV5+0ufaEMiSeBXW8/GCJ2
         iEjWwaudDNP8RQ0JvH7rXog5nPfPaPutU9GQlW/zsIER0O9omaEBwMvVJz2WQVOomvoW
         9BmQ==
X-Gm-Message-State: AOAM531rKZaB7SbKOYHQ7nD7KeV/SB44gW8pAfm5kz6SZWA/vEjfiwp1
        q3NO/M10/XFnhkQy9ig+xHo=
X-Google-Smtp-Source: ABdhPJwfbzUDm57QeqTCvPbOFRRE/v9Fx+uz10h4ka27LiGzK/ng9XsdjjNoq0b8BaBOSlim6mUGeg==
X-Received: by 2002:a05:6000:347:: with SMTP id e7mr4403030wre.35.1606926617110;
        Wed, 02 Dec 2020 08:30:17 -0800 (PST)
Received: from [192.168.8.116] ([37.164.23.254])
        by smtp.gmail.com with ESMTPSA id p4sm2781523wrm.51.2020.12.02.08.30.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Dec 2020 08:30:16 -0800 (PST)
Subject: Re: [PATCH net-next v2] mptcp: be careful on MPTCP-level ack.
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org
References: <5370c0ae03449239e3d1674ddcfb090cf6f20abe.1606253206.git.pabeni@redhat.com>
 <fdad2c0e-e84e-4a82-7855-fc5a083bb055@gmail.com>
 <665bb3a603afebdcc85878f6b45bcf0313607994.camel@redhat.com>
 <2ac90c38-c82a-8aeb-2c01-b44a6de1bf57@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <d05ac8b9-3522-e4fc-d3ce-4bea74a6dfbf@gmail.com>
Date:   Wed, 2 Dec 2020 17:30:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <2ac90c38-c82a-8aeb-2c01-b44a6de1bf57@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/2/20 5:10 PM, Eric Dumazet wrote:
> 
> 
> On 12/2/20 4:37 PM, Paolo Abeni wrote:
>> On Wed, 2020-12-02 at 14:18 +0100, Eric Dumazet wrote:
>>>
>>> On 11/24/20 10:51 PM, Paolo Abeni wrote:
>>>> We can enter the main mptcp_recvmsg() loop even when
>>>> no subflows are connected. As note by Eric, that would
>>>> result in a divide by zero oops on ack generation.
>>>>
>>>> Address the issue by checking the subflow status before
>>>> sending the ack.
>>>>
>>>> Additionally protect mptcp_recvmsg() against invocation
>>>> with weird socket states.
>>>>
>>>> v1 -> v2:
>>>>  - removed unneeded inline keyword - Jakub
>>>>
>>>> Reported-and-suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
>>>> Fixes: ea4ca586b16f ("mptcp: refine MPTCP-level ack scheduling")
>>>> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
>>>> ---
>>>>  net/mptcp/protocol.c | 67 ++++++++++++++++++++++++++++++++------------
>>>>  1 file changed, 49 insertions(+), 18 deletions(-)
>>>>
>>>
>>> Looking at mptcp recvmsg(), it seems that a read(fd, ..., 0) will
>>> trigger an infinite loop if there is available data in receive queue ?
>>
>> Thank you for looking into this!
>>
>> I can't reproduce the issue with the following packetdrill ?!?
>>
>> +0.0  connect(3, ..., ...) = -1 EINPROGRESS (Operation now in progress)
>> +0.1   > S 0:0(0) <mss 1460,sackOK,TS val 100 ecr 0,nop,wscale 8,mpcapable v1 fflags[flag_h] nokey>
>> +0.1   < S. 0:0(0) ack 1 win 65535 <mss 1460,sackOK,TS val 700 ecr 100,nop,wscaale 8,mpcapable v1 flags[flag_h] key[skey=2] >
>> +0.1  > . 1:1(0) ack 1 <nop, nop, TS val 100 ecr 700,mpcapable v1 flags[flag_h]] key[ckey,skey]>
>> +0.1 fcntl(3, F_SETFL, O_RDWR) = 0
>> +0.1   < .  1:201(200) ack 1 win 225 <dss dack8=1 dsn8=1 ssn=1 dll=200 nocs,  nop, nop>
>> +0.1   > .  1:1(0) ack 201 <nop, nop, TS val 100 ecr 700, dss dack8=201 dll=00 nocs>
>> +0.1 read(3, ..., 0) = 0
>>
>> The main recvmsg() loop is interrupted by the following check:
>>
>>                 if (copied >= target)
>>                         break;
> 
> @copied should be 0, and @target should be 1
> 
> Are you sure the above condition is triggering ?
> 
> Maybe read(fd, ..., 0) does not reach recvmsg() at all.

Yes, sock_read_iter() has a shortcut :

if (!iov_iter_count(to))    /* Match SYS5 behaviour */
     res = sock_recvmsg(sock, &msg, msg.msg_flags);

but recvmsg() does not have such check, or maybe I have not looked at the right place.

> 
> You could try recvmsg() or recvmmsg(), 
> 
>>
>> I guess we could loop while the msk has available rcv space and some
>> subflow is feeding new data. If so, I think moving:
>>
>> 	if (skb_queue_empty(&msk->receive_queue) &&
>>                     __mptcp_move_skbs(msk, len - copied))
>>                         continue;
>>
>> after the above check should address the issue, and will make the
>> common case faster. Let me test the above - unless I underlooked
>> something relevant!
>>
>> Thanks,
>>
>> Paolo
>>

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1BD2DDC72
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 01:45:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730833AbgLRApI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 19:45:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727136AbgLRApH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 19:45:07 -0500
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7698FC061794
        for <netdev@vger.kernel.org>; Thu, 17 Dec 2020 16:44:27 -0800 (PST)
Received: by mail-oo1-xc33.google.com with SMTP id y14so172183oom.10
        for <netdev@vger.kernel.org>; Thu, 17 Dec 2020 16:44:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RcG8UuuKICrSkT4O/nksVbgVV1JKB9kCFu7KnueB7gw=;
        b=SaDvPSn5+60md6Os91Kxf0BMZzgV/1uVPwm70Viav40Uqbw+0I0w9NX7eoY70bn85V
         9DaqGR2LpjhPmtyz6+hvwgUM/DMxDYiepu9+y7PVo/opvhL/B5/lmAMP5n3Np3HP5vhM
         7iaNVMvn8QZklV3bOPy5YigyG44Ui+kXhRiWzOI/ZwEmLEo5WR8dUNo3bn4TAJZHIW4+
         qLXCrWHRBpkWDeH8jppPd9xnJ1SvVgO69282LITjngcSAH2fuOk3A6crh5zhhNz/rUFT
         ecxo7oRajXdXIUmzWGGdoRZp3z4Jjcb1iOPtRp2cL/BXVpgxJrPCfEN+7jdtilg4zTc4
         UtfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RcG8UuuKICrSkT4O/nksVbgVV1JKB9kCFu7KnueB7gw=;
        b=Y2ntEJVE/s3coKJzEPQAd8Q8erLuzjJxSFaOukdV+ccJaM0nl7z16aze1wtfrqtc1B
         EaiF0sSrEIoYMmaKqsPizjJ/mDKZhBxqftrqbHNIr4G02gt1UYeSfNKrJzzN+JKuM3G4
         FDpvjpD1tLvBOdMAFxzKMeuDsBfBLkDbljs/8yB9NkMYebU9KoCJOtgYnygJIsDdBEZy
         wdHAnsSglIQXwt1/zBXtJiSHMKVZQvblqOfo5iwCyvaxoQh/rsUuvSgpa1pq+X4izb9v
         88VzKNwHw8957cB4hCs5/wYo4PZu9QraIJ4sTuGti5Pnh3OCi/3fKdfO0ZzlCOtp9n4E
         TxCA==
X-Gm-Message-State: AOAM5329XHfVhzgRfiyROPgiIdq5w88yPObwNKraYRBmwDqVIFgOloIo
        G/YDpuBUTG/Eodb91dFVX/4=
X-Google-Smtp-Source: ABdhPJw3reQHTuSmZBr762IvUXpUS8kWFbqz4KDwcnIinsYjB8dkOq/EkmFXmiEy9dpahXd9ldTzvQ==
X-Received: by 2002:a4a:6f0d:: with SMTP id h13mr1239416ooc.2.1608252266733;
        Thu, 17 Dec 2020 16:44:26 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.51])
        by smtp.googlemail.com with ESMTPSA id a22sm304517otr.75.2020.12.17.16.44.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Dec 2020 16:44:25 -0800 (PST)
Subject: Re: [PATCH v1 net-next 02/15] net: Introduce direct data placement
 tcp offload
To:     Boris Pismenny <borispismenny@gmail.com>,
        Boris Pismenny <borisp@mellanox.com>, kuba@kernel.org,
        davem@davemloft.net, saeedm@nvidia.com, hch@lst.de,
        sagi@grimberg.me, axboe@fb.com, kbusch@kernel.org,
        viro@zeniv.linux.org.uk, edumazet@google.com
Cc:     boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, benishay@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, Ben Ben-Ishay <benishay@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>,
        Boris Pismenny <borisp@nvidia.com>
References: <20201207210649.19194-1-borisp@mellanox.com>
 <20201207210649.19194-3-borisp@mellanox.com>
 <6f48fa5d-465c-5c38-ea45-704e86ba808b@gmail.com>
 <f52a99d2-03a4-6e9f-603e-feba4aad0512@gmail.com>
 <65dc5bba-13e6-110a-ddae-3d0c260aa875@gmail.com>
 <ab298844-c95e-43e6-b4bb-fe5ce78655d8@gmail.com>
 <921a110f-60fa-a711-d386-39eeca52199f@gmail.com>
 <ca9f42e5-fa4b-1fa0-c2a8-393e577cb6c9@gmail.com>
 <128d5ddc-ef46-1125-c27e-381f78a49a96@gmail.com>
 <999f935c-310b-39e0-6f77-6f39192cabc2@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1b6314aa-fa22-0847-67e6-280f73281110@gmail.com>
Date:   Thu, 17 Dec 2020 17:44:22 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <999f935c-310b-39e0-6f77-6f39192cabc2@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/17/20 12:06 PM, Boris Pismenny wrote:
> 
> 
> On 15/12/2020 7:19, David Ahern wrote:
>> On 12/13/20 11:21 AM, Boris Pismenny wrote:
>>>>> as zerocopy for the following reasons:
>>>>> (1) The former places buffers *exactly* where the user requests
>>>>> regardless of the order of response arrivals, while the latter places packets
>>>>> in anonymous buffers according to packet arrival order. Therefore, zerocopy
>>>>> can be implemented using data placement, but not vice versa.
>>>>
>>>> Fundamentally, it is an SGL and a TCP sequence number. There is a
>>>> starting point where seq N == sgl element 0, position 0. Presumably
>>>> there is a hardware cursor to track where you are in filling the SGL as
>>>> packets are processed. You abort on OOO, so it seems like a fairly
>>>> straightfoward problem.
>>>>
>>>
>>> We do not abort on OOO. Moreover, we can keep going as long as
>>> PDU headers are not reordered.
>>
>> Meaning packets received OOO which contain all or part of a PDU header
>> are aborted, but pure data packets can arrive out-of-order?
>>
>> Did you measure the affect of OOO packets? e.g., randomly drop 1 in 1000
>> nvme packets, 1 in 10,000, 1 in 100,000? How does that affect the fio
>> benchmarks?
>>
> 
> Yes for TLS where similar ideas are used, but not for NVMe-TCP, yet.
> At the worst case we measured (5% OOO), and we got the same performance
> as pure software TLS under these conditions. We will strive to have the
> same for nvme-tcp. We would be able to test this on nvme-tcp only when we
> have hardware. For now, we are using a mix of emulation and simulation to
> test and benchmark.

Interesting. So you don't have hardware today for this feature.

> 
>>>> Similarly for the NVMe SGLs and DDP offload - a more generic solution
>>>> allows other use cases to build on this as opposed to the checks you
>>>> want for a special case. For example, a split at the protocol headers /
>>>> payload boundaries would be a generic solution where kernel managed
>>>> protocols get data in one buffer and socket data is put into a given
>>>> SGL. I am guessing that you have to be already doing this to put PDU
>>>> payloads into an SGL and other headers into other memory to make a
>>>> complete packet, so this is not too far off from what you are already doing.
>>>>
>>>
>>> Splitting at protocol header boundaries and placing data at socket defined
>>> SGLs is not enough for nvme-tcp because the nvme-tcp protocol can reorder
>>> responses. Here is an example:
>>>
>>> the host submits the following requests:
>>> +--------+--------+--------+
>>> | Read 1 | Read 2 | Read 3 |
>>> +--------+--------+--------+
>>>
>>> the target responds with the following responses:
>>> +--------+--------+--------+
>>> | Resp 2 | Resp 3 | Resp 1 |
>>> +--------+--------+--------+
>>
>> Does 'Resp N' == 'PDU + data' like this:
>>
>>  +---------+--------+---------+--------+---------+--------+
>>  | PDU hdr | Resp 2 | PDU hdr | Resp 3 | PDU hdr | Resp 1 |
>>  +---------+--------+---------+--------+---------+--------+
>>
>> or is it 1 PDU hdr + all of the responses?
>>
> 
> Yes, 'RespN = PDU header + PDU data' segmented by TCP whichever way it
> chooses to do so. The PDU header's command_id field correlates between

I thought so and verified in the NVME over Fabrics spec. Not sure why
you brought up order of responses; that should be irrelevant to the design.

> the request and the response. We use that correlation in hardware to
> identify the buffers where data needs to be scattered. In other words,
> hardware holds a map between command_id and block layer buffers SGL.

Understood. Your design is forcing a command id to sgl correlation vs
handing h/w generic or shaped SGLs for writing the socket data.

> 
>>>
>>> I think that the interface we created (tcp_ddp) is sufficiently generic
>>> for the task at hand, which is offloading protocols that can re-order
>>> their responses, a non-trivial task that we claim is important.
>>>
>>> We designed it to support other protocols and not just nvme-tcp,
>>> which is merely an example. For instance, I think that supporting iSCSI
>>> would be natural, and that other protocols will fit nicely.
>>
>> It would be good to add documentation that describes the design, its
>> assumptions and its limitations. tls has several under
>> Documentation/networking. e.g., one important limitation to note is that
>> this design only works for TCP sockets owned by kernel modules.
>>
> 
> You are right. I'll do so for tcp_ddp. You are right that it works only
> for kernel TCP sockets, but maybe future work will extend it.

Little to nothing about this design can work for userspace sockets or
setups like Jonathan's netgpu. e.g., the memory address compares for
whether to copy the data will not work with userspace buffers which is
why I suggested something more generic like marking the skb as "h/w
offload" but that does not work for you since your skbs have a mixed bag
of fragments.


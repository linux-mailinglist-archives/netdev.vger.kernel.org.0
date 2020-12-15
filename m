Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3B3D2DA768
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 06:22:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbgLOFVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 00:21:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbgLOFUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 00:20:02 -0500
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 987CBC0617A7
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 21:19:21 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id j12so18202786ota.7
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 21:19:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TFo6pAamw/C8vc/02hjCiGROhwkSZktycdxG10y7qZ0=;
        b=mVpXqXVxZtcE6fCuBJPyeNUdFd4DPDGHfpJ6BjipAl9/7Gx0LvOTMriLLRFH44Y43C
         xlyhS0qagPyyOvRtlMbVEShJLhgVmoLx1OgLJx/IcA1utBUBSZwpdg6Xxqf7iintVXpZ
         3fn3p3mxyTOtDeJBBHe1SyV/Uv923f470YtbfdsS36dnBrD6zY3oh4UI7cEB7Gd8dyYM
         Ausm0t80bfB+XqFKWW64s5FHZcX8CGN16yPkIrIGKpwlcOnCigAPhVjVmbrMX/YT94zT
         X9VsZXFfonVx32BHmvEbEze1cyb5t9p+udJLvXW6UHsOE3Dv7qPQgcQuJC6NNtCYzCK3
         Xusw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TFo6pAamw/C8vc/02hjCiGROhwkSZktycdxG10y7qZ0=;
        b=QSbsaeIN7gmUkpVsHZgYqdkDuLAtTk0NTsNhknmy2Bl09Ij8bKJaSTc89v5PGYlt2D
         3oMoOMMX+zdVDlwsxHINx+/bFppyQPA11+PJPLjSc1Kqo655w0l4VSo1iA2yCm4xnxjf
         BAbzgkjuw5gL/L6wIE3LCiwT8W7/wiP4kk2LabfASjdn5sQs7Ze8W8B/HMwKxTOUcYiO
         D2Bt5P4ARCAn81QnLnfdjVfqbBsb7OjHc+redM2QZkTdJRqu4vhHxN3LVh5+U/QeLJoa
         niYDpj6ccSjD2LCJehds6nnY5v+VxM8UTQOS09fcDkw7zPp8xgjXnII3Sy7/dR1F1ndS
         nq7w==
X-Gm-Message-State: AOAM532Q1fVuem22l+5Q9WtjFN8tUPchBu3hDgGWglSgwz4sNU7qnFPR
        rqY50FV/foIU/SZzARCqrAU=
X-Google-Smtp-Source: ABdhPJxL6Hi5P/uULO+noA7VRc6fjnRSGZdaXTLpVC3WOXw1MnUy+i70A+TZNvPN4LKWcpBATTEcdg==
X-Received: by 2002:a9d:da3:: with SMTP id 32mr18505468ots.337.1608009560925;
        Mon, 14 Dec 2020 21:19:20 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:1f6:1ed:9027:4e75])
        by smtp.googlemail.com with ESMTPSA id w131sm4872004oif.8.2020.12.14.21.19.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Dec 2020 21:19:20 -0800 (PST)
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
From:   David Ahern <dsahern@gmail.com>
Message-ID: <128d5ddc-ef46-1125-c27e-381f78a49a96@gmail.com>
Date:   Mon, 14 Dec 2020 22:19:15 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <ca9f42e5-fa4b-1fa0-c2a8-393e577cb6c9@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/13/20 11:21 AM, Boris Pismenny wrote:
>>> as zerocopy for the following reasons:
>>> (1) The former places buffers *exactly* where the user requests
>>> regardless of the order of response arrivals, while the latter places packets
>>> in anonymous buffers according to packet arrival order. Therefore, zerocopy
>>> can be implemented using data placement, but not vice versa.
>>
>> Fundamentally, it is an SGL and a TCP sequence number. There is a
>> starting point where seq N == sgl element 0, position 0. Presumably
>> there is a hardware cursor to track where you are in filling the SGL as
>> packets are processed. You abort on OOO, so it seems like a fairly
>> straightfoward problem.
>>
> 
> We do not abort on OOO. Moreover, we can keep going as long as
> PDU headers are not reordered.

Meaning packets received OOO which contain all or part of a PDU header
are aborted, but pure data packets can arrive out-of-order?

Did you measure the affect of OOO packets? e.g., randomly drop 1 in 1000
nvme packets, 1 in 10,000, 1 in 100,000? How does that affect the fio
benchmarks?

>> Similarly for the NVMe SGLs and DDP offload - a more generic solution
>> allows other use cases to build on this as opposed to the checks you
>> want for a special case. For example, a split at the protocol headers /
>> payload boundaries would be a generic solution where kernel managed
>> protocols get data in one buffer and socket data is put into a given
>> SGL. I am guessing that you have to be already doing this to put PDU
>> payloads into an SGL and other headers into other memory to make a
>> complete packet, so this is not too far off from what you are already doing.
>>
> 
> Splitting at protocol header boundaries and placing data at socket defined
> SGLs is not enough for nvme-tcp because the nvme-tcp protocol can reorder
> responses. Here is an example:
> 
> the host submits the following requests:
> +--------+--------+--------+
> | Read 1 | Read 2 | Read 3 |
> +--------+--------+--------+
> 
> the target responds with the following responses:
> +--------+--------+--------+
> | Resp 2 | Resp 3 | Resp 1 |
> +--------+--------+--------+

Does 'Resp N' == 'PDU + data' like this:

 +---------+--------+---------+--------+---------+--------+
 | PDU hdr | Resp 2 | PDU hdr | Resp 3 | PDU hdr | Resp 1 |
 +---------+--------+---------+--------+---------+--------+

or is it 1 PDU hdr + all of the responses?

> 
> I think that the interface we created (tcp_ddp) is sufficiently generic
> for the task at hand, which is offloading protocols that can re-order
> their responses, a non-trivial task that we claim is important.
> 
> We designed it to support other protocols and not just nvme-tcp,
> which is merely an example. For instance, I think that supporting iSCSI
> would be natural, and that other protocols will fit nicely.

It would be good to add documentation that describes the design, its
assumptions and its limitations. tls has several under
Documentation/networking. e.g., one important limitation to note is that
this design only works for TCP sockets owned by kernel modules.

> 
>> ###
>>
>> A dump of other comments about this patch set:
> 
> Thanks for reviewing! We will fix and resubmit.

Another one I noticed today. You have several typecasts like this:

cqe128 = (struct mlx5e_cqe128 *)((char *)cqe - 64);

since cqe is a member of cqe128, container_of should be used instead of
the magic '- 64'.

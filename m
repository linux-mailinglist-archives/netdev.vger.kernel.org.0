Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6B222D2D4D
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 15:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729662AbgLHOhB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 09:37:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729358AbgLHOhB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 09:37:01 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF5DC061749
        for <netdev@vger.kernel.org>; Tue,  8 Dec 2020 06:36:15 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id lt17so24951277ejb.3
        for <netdev@vger.kernel.org>; Tue, 08 Dec 2020 06:36:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=btMPDftTIvTi3KHyYXrRdDfnWUrWosnPALX+QuJ+h6k=;
        b=TEIc/ZuthpNYb8jLLQIX9mL26v2oAqhlee+/c6DeR2XZLmo+8DQ9nEVcTeP5adiXEr
         75efyZ/m+o49252TWtwlltAI7avXnXvnns0cyygqM0eMOlqaV3jIBu8AmFaoBk0fA8K+
         GVV49dQ6+iTZqCEx4ZsUbgShcY1xQyZA0sr6XEg5sAVyMpCsrXP+TnVQaqbwlcwZW1vB
         Idufx6TDlXpzW7necDo/gatjVs3+cDdMVtynf8ySFEg4YHQFjOxY/h5v+ffeTnXYKd5c
         zsKR15+khazrjiv/sG5c70MwOxs0wHoqtsIj4ZYTvcwK9PjXmBAgLv8i63Z7iMTRohbq
         sMIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=btMPDftTIvTi3KHyYXrRdDfnWUrWosnPALX+QuJ+h6k=;
        b=PKsP7l8px/8poMtJxuUgcmCZUogSckTtMlZu3Sb0253LS0gvWaxCHx8QJGeAYRgftw
         JaJeQ0bHvEhckpURwunWnYxoZndnOQXVgoMi4gKZcHXthLcVKgP01+S2hflkHwNrq4Xb
         w/H45Rwualr25Tg404s/IKp3BSXkIZnMbq3KTXesDbex5VEKO/dY1rlcKchkAs5kwEkr
         GyQ/j9C+xGNXDXJ5TwQCMRVCPswkAJtzPy7rnJ9RwYjTpY9+ivKtUBec3CL9tg6uqn+Q
         UudAwic0YtkkjA6yWPtRm+x7BGnKEGR1vnIG/X0a2sQ32WFBjY2scaE5jK/JDFuaHt2F
         wcVA==
X-Gm-Message-State: AOAM5321Sm2mziiUiOaT7us7gJGkJQkZZkGEotwqAjd/paz101h89u/r
        UZ2jGTXmKZ+Uu6b2M1xKPHM=
X-Google-Smtp-Source: ABdhPJwUIJFYocbJ/wJYB8M2rOIgkF29KnygLBbgBhV/tQfNUN4N36wxDdKR0gjoC3rSDq/XVBkBMQ==
X-Received: by 2002:a17:906:a8f:: with SMTP id y15mr13296557ejf.552.1607438173783;
        Tue, 08 Dec 2020 06:36:13 -0800 (PST)
Received: from [132.68.43.153] ([132.68.43.153])
        by smtp.gmail.com with ESMTPSA id cc8sm16989409edb.17.2020.12.08.06.36.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 06:36:12 -0800 (PST)
Subject: Re: [PATCH v1 net-next 02/15] net: Introduce direct data placement
 tcp offload
To:     David Ahern <dsahern@gmail.com>,
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
From:   Boris Pismenny <borispismenny@gmail.com>
Message-ID: <f52a99d2-03a4-6e9f-603e-feba4aad0512@gmail.com>
Date:   Tue, 8 Dec 2020 16:36:10 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <6f48fa5d-465c-5c38-ea45-704e86ba808b@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/12/2020 2:42, David Ahern wrote:
> On 12/7/20 2:06 PM, Boris Pismenny wrote:
>> This commit introduces direct data placement offload for TCP.
>> This capability is accompanied by new net_device operations that
>> configure
>> hardware contexts. There is a context per socket, and a context per DDP
>> opreation. Additionally, a resynchronization routine is used to assist
>> hardware handle TCP OOO, and continue the offload.
>> Furthermore, we let the offloading driver advertise what is the max hw
>> sectors/segments.
>>
>> Using this interface, the NIC hardware will scatter TCP payload directly
>> to the BIO pages according to the command_id.
>> To maintain the correctness of the network stack, the driver is expected
>> to construct SKBs that point to the BIO pages.
>>
>> This, the SKB represents the data on the wire, while it is pointing
>> to data that is already placed in the destination buffer.
>> As a result, data from page frags should not be copied out to
>> the linear part.
>>
>> As SKBs that use DDP are already very memory efficient, we modify
>> skb_condence to avoid copying data from fragments to the linear
>> part of SKBs that belong to a socket that uses DDP offload.
>>
>> A follow-up patch will use this interface for DDP in NVMe-TCP.
>>
> 
> You call this Direct Data Placement - which sounds like a marketing name.
> 

[Re-sending as the previous one didn't hit the mailing list. Sorry for the spam]

Interesting idea. But, unlike SKBTX_DEV_ZEROCOPY this SKB can be inspected/modified by the stack without the need to copy things out. Additionally, the SKB may contain both data that is already placed in its final destination buffer (PDU data) and data that isn't (PDU header); it doesn't matter. Therefore, labeling the entire SKB as zerocopy doesn't convey the desired information. Moreover, skipping copies in the stack to receive zerocopy SKBs will require more invasive changes.

Our goal in this approach was to provide the smallest change that enables the desired functionality while preserving the performance of existing flows that do not care for it. An alternative approach, that doesn't affect existing flows at all, which we considered was to make a special version of memcpy_to_page to be used by DDP providers (nvme-tcp). This alternative will require creating corresponding special versions for users of this function such skb_copy_datagram_iter. Thit is more invasive, thus in this patchset we decided to avoid it.

> Fundamentally, this starts with offloading TCP socket buffers for a
> specific flow, so generically a TCP Rx zerocopy for kernel stack managed
> sockets (as opposed to AF_XDP's zerocopy). Why is this not building in
> that level of infrastructure first and adding ULPs like NVME on top?
> 

We aren't using AF_XDP or any of the Rx zerocopy infrastructure, because it is unsuitable for data placement for nvme-tcp, which reordes responses relatively to requests for efficiency and requires that data reside in specific destination buffers.



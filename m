Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E01E92D1F30
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 01:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728810AbgLHAnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 19:43:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbgLHAm7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 19:42:59 -0500
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9737FC06179C
        for <netdev@vger.kernel.org>; Mon,  7 Dec 2020 16:42:19 -0800 (PST)
Received: by mail-ot1-x342.google.com with SMTP id b18so14411802ots.0
        for <netdev@vger.kernel.org>; Mon, 07 Dec 2020 16:42:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZYYj64iOJHuX/xMvVRv3ZXW74hgbsDQts9uFztE8vxU=;
        b=mhJOpXUGZhTUU7AcHlTdW98b1GB3AGcLBXUf2HD/TrqkWJIp60mvwZ0lghNWMFlgnv
         IIxmvJNVr1PUa9mDs5gdnNVNLytg6KngttDEYraSbZpNTmInnQHde4nPHkEslEUOqYdh
         TSPfVtOvD38FBEF7bTjBW0AL/6Sj9z2ZUaseeZW3Cs73ZoR4leHciuVFwl42/UHHgERb
         RTzCuQuIaP2mFaG937ZnYINaNLnLIm7m6Qv5NrkcOLCTHPX4PWvZS5aOFw7Q0egYb/tt
         exXtY5oLB5UTH93Hdx2NmzwlA2xvZNx8DL6eAGZdqc/NG7vGoyQRMJbF6qHVg5dOjgrQ
         HGQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZYYj64iOJHuX/xMvVRv3ZXW74hgbsDQts9uFztE8vxU=;
        b=iK3eLlU+5VWDzvZ9lUcR26Uk+qfyCHejVbJEMo27lDJN45bqHG8h5fZQCYVTtguk4o
         4c248COr2MItw+mI1+YXCCIgalDhTOP7MRXY5Ejdmdjq/sfL36XDSX6tlfCQvphgQFoh
         wtoljXysRqFOl44V52qSv9+fiKC1cX3zmGTPqU4qx8jWvYlDlNrFJuiNLTkO6jvAnH+u
         ZSXCKBeCA6eV+v+2RqPyIR8CHTYu5bPKxCDRDWnQoiIdX/S6tys/WE7l5tK9/KxTgIZM
         ffReEIlJ0J6a/f2MFqRp9MWlva7bP7p5dy7FERi/wif5FU5DdHJlyWIP2hDg1+ATYdUU
         V0Qg==
X-Gm-Message-State: AOAM531FDVyb7MofvGr6xDJtR9Y+U/rYyVJKjuYBp97BIRfi0nRdjwFM
        1dBzAITGO1rC/NenFrRtHjI=
X-Google-Smtp-Source: ABdhPJwm4OctedO/dz22kdPnSZtfmeyJoO5kTh1gOZgT6QX6t7RmShIuEaZGVqnk9lW7wj9QuI6beA==
X-Received: by 2002:a9d:261:: with SMTP id 88mr14686997otb.202.1607388139095;
        Mon, 07 Dec 2020 16:42:19 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.51])
        by smtp.googlemail.com with ESMTPSA id l12sm3148666ooe.27.2020.12.07.16.42.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Dec 2020 16:42:18 -0800 (PST)
Subject: Re: [PATCH v1 net-next 02/15] net: Introduce direct data placement
 tcp offload
To:     Boris Pismenny <borisp@mellanox.com>, kuba@kernel.org,
        davem@davemloft.net, saeedm@nvidia.com, hch@lst.de,
        sagi@grimberg.me, axboe@fb.com, kbusch@kernel.org,
        viro@zeniv.linux.org.uk, edumazet@google.com
Cc:     boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, benishay@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, Ben Ben-Ishay <benishay@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
References: <20201207210649.19194-1-borisp@mellanox.com>
 <20201207210649.19194-3-borisp@mellanox.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <6f48fa5d-465c-5c38-ea45-704e86ba808b@gmail.com>
Date:   Mon, 7 Dec 2020 17:42:14 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201207210649.19194-3-borisp@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/7/20 2:06 PM, Boris Pismenny wrote:
> This commit introduces direct data placement offload for TCP.
> This capability is accompanied by new net_device operations that
> configure
> hardware contexts. There is a context per socket, and a context per DDP
> opreation. Additionally, a resynchronization routine is used to assist
> hardware handle TCP OOO, and continue the offload.
> Furthermore, we let the offloading driver advertise what is the max hw
> sectors/segments.
> 
> Using this interface, the NIC hardware will scatter TCP payload directly
> to the BIO pages according to the command_id.
> To maintain the correctness of the network stack, the driver is expected
> to construct SKBs that point to the BIO pages.
> 
> This, the SKB represents the data on the wire, while it is pointing
> to data that is already placed in the destination buffer.
> As a result, data from page frags should not be copied out to
> the linear part.
> 
> As SKBs that use DDP are already very memory efficient, we modify
> skb_condence to avoid copying data from fragments to the linear
> part of SKBs that belong to a socket that uses DDP offload.
> 
> A follow-up patch will use this interface for DDP in NVMe-TCP.
> 

You call this Direct Data Placement - which sounds like a marketing name.

Fundamentally, this starts with offloading TCP socket buffers for a
specific flow, so generically a TCP Rx zerocopy for kernel stack managed
sockets (as opposed to AF_XDP's zerocopy). Why is this not building in
that level of infrastructure first and adding ULPs like NVME on top?

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39BF42D7FC0
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 21:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393778AbgLKUA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 15:00:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390134AbgLKUAf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 15:00:35 -0500
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D9DEC0613D3
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 11:59:55 -0800 (PST)
Received: by mail-oi1-x241.google.com with SMTP id k2so11141702oic.13
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 11:59:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GXouTMg9z7FxGREV13t5lB9zURmuWrbw3x7YOJeBTgM=;
        b=uEyEY3EPAxWX3oGWTVNPUuEUfSH8bFqor4l/2fgf60BGehsY1bJ41QWiUEJ5XuKljy
         yNF2EMdJI0/VPcyTfOg6gU598Ppdx9lKtzdsoA5u2KspNJkMD5qWHD5Yyk90WB+fVHqF
         zM7As+I+S2ySbShGJsY80spNK0eZnSvab90q5RpmZFCWlrIj+gKOu/JXwHDU+amEvl4b
         NTDPzhllgUd8iZUn4d0RvKZd9R3jIiLnbQaXp9qU++PyRKHoY70YwMC6eBKqi6v+NgUU
         bBZZePrYoMggpeZ2fNv75GuBLe7z9QpWEjgrlEZ+DHjmWSheZXKj+NXqqLcQm1A7HU99
         Amkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GXouTMg9z7FxGREV13t5lB9zURmuWrbw3x7YOJeBTgM=;
        b=E3twtnBGk/qt7J1xNzsFpF8YN4Ta4XTtsfxYIS2xCmJcEDExzh5TLip8147+V0QUjt
         IvSxhfavD86l9qTaVEDX6q9m2+Gcl4i4ocYKUsSrQh/eQuXXutEJa/7b4TpkRhJraQyU
         WNu2AQQxCeyW/e31CvGkJC95fw6aGZfyqNP9IJuExNcO8o7XY+NFUCO28C1unawuv3ng
         ENZMco2dfWV3QJ9LwoW3L9nXLpK5Lay5fHDQeePxHj/5+86gfQ9VglARqsgGZ6i3ST7U
         3Ip8BRiLrFbqef/mGzDQQcpDxiC8DxsWgDzcWpeZN3KW3UFkVX+iCgcHgjGDcvnQfPnW
         dO+A==
X-Gm-Message-State: AOAM532cF5vssTrkFpzUfwTT/TMQLawpBdmm+8ssa4gqo/+8clQS2BcZ
        KcwAn+/r1La9UugW8TSCsNg=
X-Google-Smtp-Source: ABdhPJzxtMM7NQoSo5eoOOehPBdJgEAWO056zfguSFANeHCqz4IKmjGwP0JfVn+DZVXqR46X9uVNvA==
X-Received: by 2002:aca:1b1a:: with SMTP id b26mr10534497oib.43.1607716794557;
        Fri, 11 Dec 2020 11:59:54 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:6139:6f39:a803:1a61])
        by smtp.googlemail.com with ESMTPSA id l5sm2014127ooo.2.2020.12.11.11.59.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Dec 2020 11:59:53 -0800 (PST)
Subject: Re: [PATCH v1 net-next 02/15] net: Introduce direct data placement
 tcp offload
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Boris Pismenny <borispismenny@gmail.com>,
        Boris Pismenny <borisp@mellanox.com>, davem@davemloft.net,
        saeedm@nvidia.com, hch@lst.de, sagi@grimberg.me, axboe@fb.com,
        kbusch@kernel.org, viro@zeniv.linux.org.uk, edumazet@google.com,
        boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
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
 <20201210180108.3eb24f2b@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <5cadcfa0-b992-f124-f006-51872c86b804@gmail.com>
 <20201211104445.30684242@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <281b12de-7730-05a7-1187-e4f702c19cda@gmail.com>
Date:   Fri, 11 Dec 2020 12:59:52 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201211104445.30684242@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/11/20 11:45 AM, Jakub Kicinski wrote:
> Ack, these patches are not exciting (to me), so I'm wondering if there
> is a better way. The only reason NIC would have to understand a ULP for
> ZC is to parse out header/message lengths. There's gotta be a way to
> pass those in header options or such...
> 
> And, you know, if we figure something out - maybe we stand a chance
> against having 4 different zero copy implementations (this, TCP,
> AF_XDP, netgpu) :(

AF_XDP is for userspace IP/TCP/packet handling.

netgpu is fundamentally kernel stack socket with zerocopy direct to
userspace buffers. Yes, it has more complications like the process is
running on a GPU, but essential characteristics are header / payload
split, a kernel stack managed socket, and dedicated H/W queues for the
socket and those are all common to what the nvme patches are doing. So,
can we create a common framework for those characteristics which enables
other use cases (like a more generic Rx zerocopy)?

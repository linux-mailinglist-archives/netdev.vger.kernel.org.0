Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01A652D3D2E
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 09:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgLIIQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 03:16:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726674AbgLIIQl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 03:16:41 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB6CBC0613D6
        for <netdev@vger.kernel.org>; Wed,  9 Dec 2020 00:16:00 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id bo9so785285ejb.13
        for <netdev@vger.kernel.org>; Wed, 09 Dec 2020 00:16:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=08ob/p4UnManlSRT0tUy3hrEEI/D3u1JpUunWfKCo5w=;
        b=s2vKpouyMm3wbzMXwpn7cMBaEZ/m4HMqhpTYZ2IMX/HxSeMcfe8wu+Z8sZ9wWBFjzo
         D3KDovVWoSkIqaEvc0O5eEeSuHf+phxmOe2cah5+o1FlLJBMAl9AvGyoK2q0LorhmaDR
         ScGPAu8OsJCyCSx/QAg7A/OvITI5wLSGkrU6ZPaeWWf5vyS34z9x75XFKOTRe3PH3oP5
         ocRW5jc8ndtUPpneuWNw/bN4Exu36iAflmOaFQB9p99q64O5d+hDsYrmP18B4iS4ZWWG
         jLer34Bz6KqFYqSsiwJTiVyLAV7FC5uD14cfduhp7G2eQZLffl82wDa0XhbP84poEO1X
         cmSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=08ob/p4UnManlSRT0tUy3hrEEI/D3u1JpUunWfKCo5w=;
        b=m26dc0+6PMLniqXSxetWk6ZWaK2Bnr0cH7a9EPb7BwDjUjK7MvYwwdXlOVkdbpj9Zz
         aFqKNHZX5oamYwYUCP6L8hn1uCOozQMACPXAFxzWCNybYbimRvRELZe6QTZ49ZJO+RaI
         dqkB1VQPmz0pGvSEfUY8x/A0QIocAFGGvd1mX/BsQ+K3jcu4k4FK/1txSTyD/vxwVziR
         NKZlxlwIdrtnKaspwRM1cpQz04ecy1x9pv0MsevgbAhSMueN6gfiOOaC26oS6Ib2FiPT
         sRxOdpP71FUxD0riwL5QjHUiFZhOUn89pxUPsvxXEq+Pb+L/c2DSQtICnb/rh3x/AN2+
         vmZA==
X-Gm-Message-State: AOAM5302Z7gT1yQko3lfJkShZZf6thRbC9uIZVlXbf6s8IVncWAA3sH3
        n1frIp5vrxakyU56935RUEY=
X-Google-Smtp-Source: ABdhPJyiSTu4RqA4peRiMEDhIuXqyqwqC5BsVz5rN5DsFOBikhejYSZ9hSxYhQg+/A8LNni+nLhlbQ==
X-Received: by 2002:a17:906:f905:: with SMTP id lc5mr1064715ejb.177.1607501759732;
        Wed, 09 Dec 2020 00:15:59 -0800 (PST)
Received: from [132.68.43.153] ([132.68.43.153])
        by smtp.gmail.com with ESMTPSA id bq20sm751767ejb.64.2020.12.09.00.15.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Dec 2020 00:15:59 -0800 (PST)
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
 <f52a99d2-03a4-6e9f-603e-feba4aad0512@gmail.com>
 <65dc5bba-13e6-110a-ddae-3d0c260aa875@gmail.com>
From:   Boris Pismenny <borispismenny@gmail.com>
Message-ID: <ab298844-c95e-43e6-b4bb-fe5ce78655d8@gmail.com>
Date:   Wed, 9 Dec 2020 10:15:56 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <65dc5bba-13e6-110a-ddae-3d0c260aa875@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/12/2020 2:38, David Ahern wrote:
> 
> The AF_XDP reference was to differentiate one zerocopy use case (all
> packets go to userspace) from another (kernel managed TCP socket with
> zerocopy payload). You are focusing on a very narrow use case - kernel
> based NVMe over TCP - of a more general problem.
> 

Please note that although our framework implements support for nvme-tcp,
we designed it to fit iscsi as well, and hopefully future protocols too,
as general as we could. For why this could not be generalized further
see below.

> You have a TCP socket and a design that only works for kernel owned
> sockets. You have specialized queues in the NIC, a flow rule directing
> packets to those queues. Presumably some ULP parser in the NIC
> associated with the queues to process NVMe packets. Rather than copying
> headers (ethernet/ip/tcp) to one buffer and payload to another (which is
> similar to what Jonathan Lemon is working on), this design has a ULP
> processor that just splits out the TCP payload even more making it
> highly selective about which part of the packet is put into which
> buffer. Take out the NVMe part, and it is header split with zerocopy for
> the payload - a generic feature that can have a wider impact with NVMe
> as a special case.
> 

There is more to this than TCP zerocopy that exists in userspace or
inside the kernel. First, please note that the patches include support for
CRC offload as well as data placement. Second, data-placement is not the same
as zerocopy for the following reasons:
(1) The former places buffers *exactly* where the user requests
regardless of the order of response arrivals, while the latter places packets
in anonymous buffers according to packet arrival order. Therefore, zerocopy
can be implemented using data placement, but not vice versa.
(2) Data-placement supports sub-page zerocopy, unlike page-flipping
techniques (i.e., TCP_ZEROCOPY).
(3) Page-flipping can't work for any storage initiator because the
destination buffer is owned by some user pagecache or process using O_DIRECT.
(4) Storage over TCP PDUs are not necessarily aligned to TCP packets,
i.e., the PDU header can be in the middle of a packet, so header-data split
alone isn't enough.

I wish we could do the same using some simpler zerocopy mechanism,
it would indeed simplify things. But, unfortunately this would severely
restrict generality, no sub-page support and alignment between PDUs
and packets, and performance (ordering of PDUs).

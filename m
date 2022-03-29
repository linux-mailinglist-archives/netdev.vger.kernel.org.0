Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22F934EA8B0
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 09:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233524AbiC2Hr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 03:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231801AbiC2Hr6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 03:47:58 -0400
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FCEA1C391B;
        Tue, 29 Mar 2022 00:46:16 -0700 (PDT)
Received: by mail-wr1-f50.google.com with SMTP id w4so23468477wrg.12;
        Tue, 29 Mar 2022 00:46:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rpBdm54k3hpAJiNzkv6c+hlup42nSLv/yZ6rcxWnLSY=;
        b=IdMBuD8LnI+HL0crshDcWtnEpvBH7IbiTq0zCsQrOULxe99rzlzFZxLf1eX0sicliE
         L1+UiKY9WqdoYXA816Qhk2TZlZloTiyTU3aN7OJ2Fb9oIvjvjf+csLe+UexLybd9LKkX
         23kCiy/oewvkaN/d2BYogD6eMgG3gO/oAdBAnqzgmVleuQkGzqetIqQvLJnuQq06isu9
         ATT3817ZPs/rXNAl7eQS1vO5dm+rBVlUdKSZek6oQ+FhMyOxI6K2Op2NPs1VSqtKjJon
         BBF6Yj3/+FV0yK6D+7wHvU7e7/KTn6PoA2bjJtmhoovNSs25D16kPynFgKAKIpJQ7Wxs
         wy8A==
X-Gm-Message-State: AOAM532QI+WzGX4CLpBdbHUtJbPZaV/vRKmgMpVezp0h0Wlq16CGul8e
        wYFbEbCeITH/OFcCjJnjfYo=
X-Google-Smtp-Source: ABdhPJyfRXcJMYQfm/T0Xmp6DW40AVrN8t6gvbYC575ZZz3IPPUDF/qI9Epa4K9hd3rOOQQW3cNbmw==
X-Received: by 2002:a05:6000:12c3:b0:203:e0e0:7d18 with SMTP id l3-20020a05600012c300b00203e0e07d18mr28850582wrx.46.1648539972774;
        Tue, 29 Mar 2022 00:46:12 -0700 (PDT)
Received: from [192.168.64.180] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id p30-20020a05600c1d9e00b0038cc9d6ff0bsm1527133wms.33.2022.03.29.00.46.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Mar 2022 00:46:12 -0700 (PDT)
Message-ID: <15f24dcd-9a62-8bab-271c-baa9cc693d8d@grimberg.me>
Date:   Tue, 29 Mar 2022 10:46:08 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 2/3] nvme-tcp: support specifying the
 congestion-control
Content-Language: en-US
To:     Mingbao Sun <sunmingbao@tom.com>
Cc:     Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        tyler.sun@dell.com, ping.gan@dell.com, yanxiu.cai@dell.com,
        libin.zhang@dell.com, ao.sun@dell.com
References: <20220311103414.8255-1-sunmingbao@tom.com>
 <20220311103414.8255-2-sunmingbao@tom.com>
 <7121e4be-0e25-dd5f-9d29-0fb02cdbe8de@grimberg.me>
 <20220325201123.00002f28@tom.com>
 <b7b5106a-9c0d-db49-00ab-234756955de8@grimberg.me>
 <20220329104806.00000126@tom.com>
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20220329104806.00000126@tom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>> As I said, TCP can be tuned in various ways, congestion being just one
>> of them. I'm sure you can find a workload where rmem/wmem will make
>> a difference.
> 
> agree.
> but the difference for the knob of rmem/wmem is:
> we could enlarge rmem/wmem for NVMe/TCP via sysctl,
> and it would not bring downside to any other sockets whose
> rmem/wmem are not explicitly specified.

It can most certainly affect them, positively or negatively, depends
on the use-case.

>> In addition, based on my knowledge, application specific TCP level
>> tuning (like congestion) is not really a common thing to do. So why in
>> nvme-tcp?
>>
>> So to me at least, it is not clear why we should add it to the driver.
> 
> As mentioned in the commit message, though we can specify the
> congestion-control of NVMe_over_TCP via sysctl or writing
> '/proc/sys/net/ipv4/tcp_congestion_control', but this also
> changes the congestion-control of all the future TCP sockets on
> the same host that have not been explicitly assigned the
> congestion-control, thus bringing potential impaction on their
> performance.
> 
> For example:
> 
> A server in a data-center with the following 2 NICs:
> 
>      - NIC_fron-end, for interacting with clients through WAN
>        (high latency, ms-level)
> 
>      - NIC_back-end, for interacting with NVMe/TCP target through LAN
>        (low latency, ECN-enabled, ideal for dctcp)
> 
> This server interacts with clients (handling requests) via the fron-end
> network and accesses the NVMe/TCP storage via the back-end network.
> This is a normal use case, right?
> 
> For the client devices, we can’t determine their congestion-control.
> But normally it’s cubic by default (per the CONFIG_DEFAULT_TCP_CONG).
> So if we change the default congestion control on the server to dctcp
> on behalf of the NVMe/TCP traffic of the LAN side, it could at the
> same time change the congestion-control of the front-end sockets
> to dctcp while the congestion-control of the client-side is cubic.
> So this is an unexpected scenario.
> 
> In addition, distributed storage products like the following also have
> the above problem:
> 
>      - The product consists of a cluster of servers.
> 
>      - Each server serves clients via its front-end NIC
>       (WAN, high latency).
> 
>      - All servers interact with each other via NVMe/TCP via back-end NIC
>       (LAN, low latency, ECN-enabled, ideal for dctcp).

Separate networks are still not application (nvme-tcp) specific and as
mentioned, we have a way to control that. IMO, this still does not
qualify as solid justification to add this to nvme-tcp.

What do others think?

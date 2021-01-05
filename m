Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31ACA2EA79D
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 10:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728158AbhAEJeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 04:34:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42262 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728086AbhAEJeF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 04:34:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609839158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KDRR0z0TUONmOgv9BLItAtpsqP3CgvwXGzYeT1dfz/4=;
        b=bf1xH8KvDnGykQu0C/o3Wa+gXdSmeQFcYlcaHsy7UKFZ3wWKsW8NVIrqmfnthskML+4Pej
        sNg6DlL6L8H9EUHFg1N580QDdsh8XSGcoNJo/j256T2L1c75hmH+DEvALfiCDZN4WZfbaK
        sauM4zdsIybNmTvMS1doiw7j+0Sv1JM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-411-X9SbBh3RMIqosxb8yBjmxw-1; Tue, 05 Jan 2021 04:32:34 -0500
X-MC-Unique: X9SbBh3RMIqosxb8yBjmxw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0CD97801A9E;
        Tue,  5 Jan 2021 09:32:31 +0000 (UTC)
Received: from [10.72.13.192] (ovpn-13-192.pek2.redhat.com [10.72.13.192])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EFA7C60873;
        Tue,  5 Jan 2021 09:32:20 +0000 (UTC)
Subject: Re: [PATCH netdev 0/5] virtio-net support xdp socket zero copy xmit
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org
Cc:     dust.li@linux.alibaba.com, tonylu@linux.alibaba.com,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        "open list:VIRTIO CORE AND NET DRIVERS" 
        <virtualization@lists.linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:XDP SOCKETS (AF_XDP)" <bpf@vger.kernel.org>
References: <cover.1609837120.git.xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <a67e00af-47fb-4d92-8342-27dc93c8aab9@redhat.com>
Date:   Tue, 5 Jan 2021 17:32:19 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1609837120.git.xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/1/5 下午5:11, Xuan Zhuo wrote:
> The first patch made some adjustments to xsk.


Thanks a lot for the work. It's rather interesting.


>
> The second patch itself can be used as an independent patch to solve the problem
> that XDP may fail to load when the number of queues is insufficient.


It would be better to send this as a separated patch. Several people 
asked for this before.


>
> The third to last patch implements support for xsk in virtio-net.
>
> A practical problem with virtio is that tx interrupts are not very reliable.
> There will always be some missing or delayed tx interrupts. So I specially added
> a point timer to solve this problem. Of course, considering performance issues,
> The timer only triggers when the ring of the network card is full.


This is sub-optimal. We need figure out the root cause. We don't meet 
such issue before.

Several questions:

- is tx interrupt enabled?
- can you still see the issue if you disable event index?
- what's backend did you use? qemu or vhost(user)?


>
> Regarding the issue of virtio-net supporting xsk's zero copy rx, I am also
> developing it, but I found that the modification may be relatively large, so I
> consider this patch set to be separated from the code related to xsk zero copy
> rx.


That's fine, but a question here.

How is the multieuque being handled here. I'm asking since there's no 
programmable filters/directors support in virtio spec now.

Thanks


>
> Xuan Zhuo (5):
>    xsk: support get page for drv
>    virtio-net: support XDP_TX when not more queues
>    virtio-net, xsk: distinguish XDP_TX and XSK XMIT ctx
>    xsk, virtio-net: prepare for support xsk
>    virtio-net, xsk: virtio-net support xsk zero copy tx
>
>   drivers/net/virtio_net.c    | 643 +++++++++++++++++++++++++++++++++++++++-----
>   include/linux/netdevice.h   |   1 +
>   include/net/xdp_sock_drv.h  |  10 +
>   include/net/xsk_buff_pool.h |   1 +
>   net/xdp/xsk_buff_pool.c     |  10 +-
>   5 files changed, 597 insertions(+), 68 deletions(-)
>
> --
> 1.8.3.1
>


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC062EB83E
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 03:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbhAFCsg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 21:48:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28626 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726363AbhAFCsg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 21:48:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609901229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aGSEn9q3RMopoKalaky8zmG8K4EWEIZy2nW74+H0arI=;
        b=bQPIMXD8uZVK0QqMX1pjleMixVTWfrdSOqAhZtNyNx6HxKWoOYu6PbgY0jnX1UlcI9K+AN
        8eXfuz0UK3EMlOt9ueoKBr0ryeSnTKsvImSRSzDmn6BRSqYUPbeKPV5HtALfyOAzVELqgw
        tnsL0mzOkjq74lIZpxKawNRIJKXhY+4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-452-bHkpLFKCPGuhlqwUfh6t8Q-1; Tue, 05 Jan 2021 21:47:05 -0500
X-MC-Unique: bHkpLFKCPGuhlqwUfh6t8Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C2C21800D62;
        Wed,  6 Jan 2021 02:47:02 +0000 (UTC)
Received: from [10.72.13.221] (ovpn-13-221.pek2.redhat.com [10.72.13.221])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 640BB50DD5;
        Wed,  6 Jan 2021 02:46:51 +0000 (UTC)
Subject: Re: [PATCH netdev 0/5] virtio-net support xdp socket zero copy xmit
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
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
        VIRTIO CORE AND NET DRIVERS 
        <virtualization@lists.linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        "XDP SOCKETS (AF_XDP)" <bpf@vger.kernel.org>,
        netdev@vger.kernel.org
References: <1609850555.8687568-1-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <b1895acf-9366-ba9a-4265-7e871b351872@redhat.com>
Date:   Wed, 6 Jan 2021 10:46:43 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1609850555.8687568-1-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/1/5 下午8:42, Xuan Zhuo wrote:
> On Tue, 5 Jan 2021 17:32:19 +0800, Jason Wang <jasowang@redhat.com> wrote:
>> On 2021/1/5 下午5:11, Xuan Zhuo wrote:
>>> The first patch made some adjustments to xsk.
>>
>> Thanks a lot for the work. It's rather interesting.
>>
>>
>>> The second patch itself can be used as an independent patch to solve the problem
>>> that XDP may fail to load when the number of queues is insufficient.
>>
>> It would be better to send this as a separated patch. Several people
>> asked for this before.
>>
>>
>>> The third to last patch implements support for xsk in virtio-net.
>>>
>>> A practical problem with virtio is that tx interrupts are not very reliable.
>>> There will always be some missing or delayed tx interrupts. So I specially added
>>> a point timer to solve this problem. Of course, considering performance issues,
>>> The timer only triggers when the ring of the network card is full.
>>
>> This is sub-optimal. We need figure out the root cause. We don't meet
>> such issue before.
>>
>> Several questions:
>>
>> - is tx interrupt enabled?
>> - can you still see the issue if you disable event index?
>> - what's backend did you use? qemu or vhost(user)?
> Sorry, it may just be a problem with the backend I used here. I just tested the
> latest qemu and it did not have this problem. I think I should delete the
> timer-related code?


Yes, please.


>
>>
>>> Regarding the issue of virtio-net supporting xsk's zero copy rx, I am also
>>> developing it, but I found that the modification may be relatively large, so I
>>> consider this patch set to be separated from the code related to xsk zero copy
>>> rx.
>>
>> That's fine, but a question here.
>>
>> How is the multieuque being handled here. I'm asking since there's no
>> programmable filters/directors support in virtio spec now.
>>
>> Thanks
> I don't really understand what you mean. In the case of multiple queues,
> there is no problem.


So consider we bind xsk to queue 4, how can you make sure the traffic to 
be directed queue 4? One possible solution is to use filters as what 
suggested in af_xdp.rst:

       ethtool -N p3p2 rx-flow-hash udp4 fn
       ethtool -N p3p2 flow-type udp4 src-port 4242 dst-port 4242 \
           action 16
...

But virtio-net doesn't have any filters that could be programmed from 
the driver.

Anything I missed here?

Thanks


>
>>
>>> Xuan Zhuo (5):
>>>     xsk: support get page for drv
>>>     virtio-net: support XDP_TX when not more queues
>>>     virtio-net, xsk: distinguish XDP_TX and XSK XMIT ctx
>>>     xsk, virtio-net: prepare for support xsk
>>>     virtio-net, xsk: virtio-net support xsk zero copy tx
>>>
>>>    drivers/net/virtio_net.c    | 643 +++++++++++++++++++++++++++++++++++++++-----
>>>    include/linux/netdevice.h   |   1 +
>>>    include/net/xdp_sock_drv.h  |  10 +
>>>    include/net/xsk_buff_pool.h |   1 +
>>>    net/xdp/xsk_buff_pool.c     |  10 +-
>>>    5 files changed, 597 insertions(+), 68 deletions(-)
>>>
>>> --
>>> 1.8.3.1
>>>


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 277272F99EF
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 07:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732453AbhARGan (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 01:30:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37650 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732441AbhARGai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 01:30:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610951342;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IEXqRrmhe5TS1HeLniFVF/d1Z+5aM2lLZ+VPrEdE2SQ=;
        b=KQgqqX1QWU66JF7IQyMYnkN4ykGEXxH/wDCas9J67OBMoqyx3OX7JTAR3m+bdcYJhfZ0ji
        xy8TkgROaviTbeiR8TxIXDolM6Cw0TuIbRcyk4L4PSbCiRRg3LOXbhOKljE3rjEfyZqF5i
        6dPqvD69RTCtH5T7IQWMhqlc0/WOYco=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-203-0UL6bPaDO5iHb8DFFTh7MA-1; Mon, 18 Jan 2021 01:28:58 -0500
X-MC-Unique: 0UL6bPaDO5iHb8DFFTh7MA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 67F32100F35D;
        Mon, 18 Jan 2021 06:28:55 +0000 (UTC)
Received: from [10.72.13.12] (ovpn-13-12.pek2.redhat.com [10.72.13.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 94C716D029;
        Mon, 18 Jan 2021 06:28:44 +0000 (UTC)
Subject: Re: [PATCH net-next v2 0/7] virtio-net support xdp socket zero copy
 xmit
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
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
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
References: <cover.1609837120.git.xuanzhuo@linux.alibaba.com>
 <cover.1610765285.git.xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <b41ab0f0-4537-74b5-d7c3-b20ce082bdd6@redhat.com>
Date:   Mon, 18 Jan 2021 14:28:43 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1610765285.git.xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/1/16 上午10:59, Xuan Zhuo wrote:
> XDP socket is an excellent by pass kernel network transmission framework. The
> zero copy feature of xsk (XDP socket) needs to be supported by the driver. The
> performance of zero copy is very good. mlx5 and intel ixgbe already support this
> feature, This patch set allows virtio-net to support xsk's zerocopy xmit
> feature.
>
> And xsk's zerocopy rx has made major changes to virtio-net, and I hope to submit
> it after this patch set are received.
>
> Compared with other drivers, virtio-net does not directly obtain the dma
> address, so I first obtain the xsk page, and then pass the page to virtio.
>
> When recycling the sent packets, we have to distinguish between skb and xdp.
> Now we have to distinguish between skb, xdp, xsk. So the second patch solves
> this problem first.
>
> The last four patches are used to support xsk zerocopy in virtio-net:
>
>   1. support xsk enable/disable
>   2. realize the function of xsk packet sending
>   3. implement xsk wakeup callback
>   4. set xsk completed when packet sent done
>
>
> ---------------- Performance Testing ------------
>
> The udp package tool implemented by the interface of xsk vs sockperf(kernel udp)
> for performance testing:
>
> xsk zero copy in virtio-net:
> CPU        PPS         MSGSIZE
> 28.7%      3833857     64
> 38.5%      3689491     512
> 38.9%      2787096     1456


Some questions on the results:

1) What's the setup on the vhost?
2) What's the setup of the mitigation in both host and guest?
3) Any analyze on the possible bottleneck via perf or other tools?

Thanks


>
> xsk without zero copy in virtio-net:
> CPU        PPS         MSGSIZE
> 100%       1916747     64
> 100%       1775988     512
> 100%       1440054     1456
>
> sockperf:
> CPU        PPS         MSGSIZE
> 100%       713274      64
> 100%       701024      512
> 100%       695832      1456
>
> Xuan Zhuo (7):
>    xsk: support get page for drv
>    virtio-net, xsk: distinguish XDP_TX and XSK XMIT ctx
>    xsk, virtio-net: prepare for support xsk zerocopy xmit
>    virtio-net, xsk: support xsk enable/disable
>    virtio-net, xsk: realize the function of xsk packet sending
>    virtio-net, xsk: implement xsk wakeup callback
>    virtio-net, xsk: set xsk completed when packet sent done
>
>   drivers/net/virtio_net.c    | 559 +++++++++++++++++++++++++++++++++++++++-----
>   include/linux/netdevice.h   |   1 +
>   include/net/xdp_sock_drv.h  |  10 +
>   include/net/xsk_buff_pool.h |   1 +
>   net/xdp/xsk_buff_pool.c     |  10 +-
>   5 files changed, 523 insertions(+), 58 deletions(-)
>
> --
> 1.8.3.1
>


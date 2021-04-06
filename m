Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E782A354D2C
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 08:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244106AbhDFG7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 02:59:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36729 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244102AbhDFG7b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 02:59:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617692363;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MEh2o752ANYQ9L9YTCxFAQMwQEPClrn186DoZd/3tu4=;
        b=EK7EsUOVs+CN/FvgM59IiWJiUqM4C3cUjkxYtYHLq8BO1I2P/LmmRqvbwA0L9hrNB/FLT7
        vdA+tzNaPHE3Pop3rpQPqT4EXgwPPjfiqIFV25UjtnAi16ah9+/LNo/EFHfd87L7ytb3p5
        sscKrwTXV/gy0sJWzGnKHewaxb0WNkg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-363-_QPCqdfDPSWjsL08fqIxGA-1; Tue, 06 Apr 2021 02:59:19 -0400
X-MC-Unique: _QPCqdfDPSWjsL08fqIxGA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DE1901018F70;
        Tue,  6 Apr 2021 06:59:16 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-95.pek2.redhat.com [10.72.13.95])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9BAA019D9F;
        Tue,  6 Apr 2021 06:59:01 +0000 (UTC)
Subject: Re: [PATCH net-next v3 6/8] virtio-net: xsk zero copy xmit kick by
 threshold
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
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
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org,
        Dust Li <dust.li@linux.alibaba.com>
References: <20210331071139.15473-1-xuanzhuo@linux.alibaba.com>
 <20210331071139.15473-7-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <b04d7110-95ec-0aec-a802-631baf260a62@redhat.com>
Date:   Tue, 6 Apr 2021 14:59:00 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210331071139.15473-7-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/3/31 ÏÂÎç3:11, Xuan Zhuo Ð´µÀ:
> After testing, the performance of calling kick every time is not stable.
> And if all the packets are sent and kicked again, the performance is not
> good. So add a module parameter to specify how many packets are sent to
> call a kick.
>
> 8 is a relatively stable value with the best performance.


Please add some perf numbers here.

Thanks


>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
> ---
>   drivers/net/virtio_net.c | 23 ++++++++++++++++++++---
>   1 file changed, 20 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 259fafcf6028..d7e95f55478d 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -29,10 +29,12 @@ module_param(napi_weight, int, 0444);
>   
>   static bool csum = true, gso = true, napi_tx = true;
>   static int xsk_budget = 32;
> +static int xsk_kick_thr = 8;
>   module_param(csum, bool, 0444);
>   module_param(gso, bool, 0444);
>   module_param(napi_tx, bool, 0644);
>   module_param(xsk_budget, int, 0644);
> +module_param(xsk_kick_thr, int, 0644);
>   
>   /* FIXME: MTU in config. */
>   #define GOOD_PACKET_LEN (ETH_HLEN + VLAN_HLEN + ETH_DATA_LEN)
> @@ -2612,6 +2614,8 @@ static int virtnet_xsk_xmit_batch(struct send_queue *sq,
>   	struct xdp_desc desc;
>   	int err, packet = 0;
>   	int ret = -EAGAIN;
> +	int need_kick = 0;
> +	int kicks = 0;
>   
>   	if (sq->xsk.last_desc.addr) {
>   		err = virtnet_xsk_xmit(sq, pool, &sq->xsk.last_desc);
> @@ -2619,6 +2623,7 @@ static int virtnet_xsk_xmit_batch(struct send_queue *sq,
>   			return -EBUSY;
>   
>   		++packet;
> +		++need_kick;
>   		--budget;
>   		sq->xsk.last_desc.addr = 0;
>   	}
> @@ -2642,13 +2647,25 @@ static int virtnet_xsk_xmit_batch(struct send_queue *sq,
>   		}
>   
>   		++packet;
> +		++need_kick;
> +		if (need_kick > xsk_kick_thr) {
> +			if (virtqueue_kick_prepare(sq->vq) &&
> +			    virtqueue_notify(sq->vq))
> +				++kicks;
> +
> +			need_kick = 0;
> +		}
>   	}
>   
>   	if (packet) {
> -		if (virtqueue_kick_prepare(sq->vq) &&
> -		    virtqueue_notify(sq->vq)) {
> +		if (need_kick) {
> +			if (virtqueue_kick_prepare(sq->vq) &&
> +			    virtqueue_notify(sq->vq))
> +				++kicks;
> +		}
> +		if (kicks) {
>   			u64_stats_update_begin(&sq->stats.syncp);
> -			sq->stats.kicks += 1;
> +			sq->stats.kicks += kicks;
>   			u64_stats_update_end(&sq->stats.syncp);
>   		}
>   


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD3F371233
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 09:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232981AbhECIAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 04:00:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45182 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229817AbhECIAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 04:00:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620028795;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Bl/2ZSTX8uMrXqSmi7rgld0irgeLphGdm6TYit7LvXQ=;
        b=bVt+XJLo+T9U64cvYnmqoo68EaZLbh4spSkG9iDEYgbV5KG9Sv7S/nE22iHUui9bsKJWXK
        s1ZCwHoPwHhj0/9L9nrvU+vP7XKwaCkhuhbNyU3tYRNxjk38a56tXyv24pEu9jXFvaowai
        +zDlbd8JPtmyi9n2XNEsyG2vf+Z+hLY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-577-C3GpxyChN3ClCzRSOoWyLQ-1; Mon, 03 May 2021 03:59:53 -0400
X-MC-Unique: C3GpxyChN3ClCzRSOoWyLQ-1
Received: by mail-wr1-f70.google.com with SMTP id 93-20020adf83660000b029010d6b1e0949so3451217wrd.3
        for <netdev@vger.kernel.org>; Mon, 03 May 2021 00:59:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Bl/2ZSTX8uMrXqSmi7rgld0irgeLphGdm6TYit7LvXQ=;
        b=GaqzmBoyBvv+2iQYXFkUTq57e4CPSmZs08W35S//y8oHfspQOqD2NGZRZqQ3LkdsAF
         6di3TsGG2Z0/4avB0mDvbdFYC4Bqp5ItZTPyRcltGhqswcqEj8rHz3PG+XqYiNH/dhak
         IXCdL8hSyyQ6WfK05/2lh8+lDO+g6DvPKZZjbRPceUffGUysIoIlpfvFyRQvW4kKUXRj
         ouFx2W1kKnDmWUawjQhuiFLqHGI75WWL8S+BBysRTnKkpKLUJWBDzSFVs9QaKJOPoGxi
         b1J7CHJWzdOXbqWAY47ZxcIeSdqWXVgqdqAFy5oXfpI+DEPCEuW3snmmwVvScmOHW5xU
         gkKg==
X-Gm-Message-State: AOAM532B+2A5cmeszPaeD1CyRobjYflYVcWUIS9menm0/8pTXE8hI9P8
        RRCHZdrl92t727QPoGMEibVPD2HoHGRM5PGoZ84Q8OSaWkCJgRTM/KxxhCt6nxrVvGKzxjXHQhC
        1J8gv/p3B1qIpgrs2
X-Received: by 2002:adf:ffc4:: with SMTP id x4mr22751597wrs.415.1620028792119;
        Mon, 03 May 2021 00:59:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyCffXa6+dAVz5L8aMFmIueQzxjfgmT/aHs6Ms5LyRCC+jspoSf9j339dcA7DinKdFvbJu8Fw==
X-Received: by 2002:adf:ffc4:: with SMTP id x4mr22751582wrs.415.1620028791994;
        Mon, 03 May 2021 00:59:51 -0700 (PDT)
Received: from redhat.com ([2a10:800a:cdef:0:114d:2085:61e4:7b41])
        by smtp.gmail.com with ESMTPSA id u2sm12707675wmm.5.2021.05.03.00.59.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 May 2021 00:59:51 -0700 (PDT)
Date:   Mon, 3 May 2021 03:59:49 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next] virtio-net: fix use-after-free in
 skb_gro_receive
Message-ID: <20210503035920-mutt-send-email-mst@kernel.org>
References: <20210422151620.58204-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210422151620.58204-1-xuanzhuo@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 11:16:20PM +0800, Xuan Zhuo wrote:
> When "headroom" > 0, the actual allocated memory space is the entire
> page, so the address of the page should be used when passing it to
> build_skb().
> 
> BUG: KASAN: use-after-free in skb_gro_receive (net/core/skbuff.c:4260)
> Write of size 16 at addr ffff88811619fffc by task kworker/u9:0/534
> CPU: 2 PID: 534 Comm: kworker/u9:0 Not tainted 5.12.0-rc7-custom-16372-gb150be05b806 #3382
> Hardware name: QEMU MSN2700, BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
> Workqueue: xprtiod xs_stream_data_receive_workfn [sunrpc]
> Call Trace:
>  <IRQ>
> dump_stack (lib/dump_stack.c:122)
> print_address_description.constprop.0 (mm/kasan/report.c:233)
> kasan_report.cold (mm/kasan/report.c:400 mm/kasan/report.c:416)
> skb_gro_receive (net/core/skbuff.c:4260)
> tcp_gro_receive (net/ipv4/tcp_offload.c:266 (discriminator 1))
> tcp4_gro_receive (net/ipv4/tcp_offload.c:316)
> inet_gro_receive (net/ipv4/af_inet.c:1545 (discriminator 2))
> dev_gro_receive (net/core/dev.c:6075)
> napi_gro_receive (net/core/dev.c:6168 net/core/dev.c:6198)
> receive_buf (drivers/net/virtio_net.c:1151) virtio_net
> virtnet_poll (drivers/net/virtio_net.c:1415 drivers/net/virtio_net.c:1519) virtio_net
> __napi_poll (net/core/dev.c:6964)
> net_rx_action (net/core/dev.c:7033 net/core/dev.c:7118)
> __do_softirq (./arch/x86/include/asm/jump_label.h:25 ./include/linux/jump_label.h:200 ./include/trace/events/irq.h:142 kernel/softirq.c:346)
> irq_exit_rcu (kernel/softirq.c:221 kernel/softirq.c:422 kernel/softirq.c:434)
> common_interrupt (arch/x86/kernel/irq.c:240 (discriminator 14))
> </IRQ>
> 
> Fixes: fb32856b16ad ("virtio-net: page_to_skb() use build_skb when there's sufficient tailroom")
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Reported-by: Ido Schimmel <idosch@nvidia.com>
> Tested-by: Ido Schimmel <idosch@nvidia.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  drivers/net/virtio_net.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 74d2d49264f3..7fda2ae4c40f 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -387,7 +387,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>  	unsigned int copy, hdr_len, hdr_padded_len;
>  	struct page *page_to_free = NULL;
>  	int tailroom, shinfo_size;
> -	char *p, *hdr_p;
> +	char *p, *hdr_p, *buf;
>  
>  	p = page_address(page) + offset;
>  	hdr_p = p;
> @@ -403,11 +403,15 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>  	 * space are aligned.
>  	 */
>  	if (headroom) {
> -		/* The actual allocated space size is PAGE_SIZE. */
> +		/* Buffers with headroom use PAGE_SIZE as alloc size,
> +		 * see add_recvbuf_mergeable() + get_mergeable_buf_len()
> +		 */
>  		truesize = PAGE_SIZE;
>  		tailroom = truesize - len - offset;
> +		buf = page_address(page);
>  	} else {
>  		tailroom = truesize - len;
> +		buf = p;
>  	}
>  
>  	len -= hdr_len;
> @@ -416,11 +420,13 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>  
>  	shinfo_size = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
>  
> +	/* copy small packet so we can reuse these pages */
>  	if (!NET_IP_ALIGN && len > GOOD_COPY_LEN && tailroom >= shinfo_size) {
> -		skb = build_skb(p, truesize);
> +		skb = build_skb(buf, truesize);
>  		if (unlikely(!skb))
>  			return NULL;
>  
> +		skb_reserve(skb, p - buf);
>  		skb_put(skb, len);
>  		goto ok;
>  	}
> -- 
> 2.31.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAE00368BD1
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 06:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbhDWEJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 00:09:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42423 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229454AbhDWEJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 00:09:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619150928;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C+GSyHIdh8Go4j1sZl0+B3qpF1lIUKXILWqJcAbazOA=;
        b=gDZLs80UHN2hhdlPKzMko5CDQHeYHHa4RzQ+3qYb8GlJiSGarXH263M3m7p+RrhxV43wDa
        g4wIEG2LBjNX/HlADbE6AbPLgPwtVSfHJq3D7Zr7pTnUbxww0WcRWQKY6aAtoDXF5/aNI7
        Mh+IDNVMx3QUsGEMf00jLmZlkBXba6Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-12-8mnq1jCyP2a45amhpXgiSA-1; Fri, 23 Apr 2021 00:08:42 -0400
X-MC-Unique: 8mnq1jCyP2a45amhpXgiSA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3E27210054F6;
        Fri, 23 Apr 2021 04:08:41 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-225.pek2.redhat.com [10.72.13.225])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3044F60BE5;
        Fri, 23 Apr 2021 04:08:35 +0000 (UTC)
Subject: Re: [PATCH net-next] virtio-net: fix use-after-free in
 skb_gro_receive
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org,
        Ido Schimmel <idosch@nvidia.com>
References: <20210422151620.58204-1-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <ea0bc0bc-1ac0-bf21-94dd-e11bf527a0c1@redhat.com>
Date:   Fri, 23 Apr 2021 12:08:34 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210422151620.58204-1-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/4/22 ÏÂÎç11:16, Xuan Zhuo Ð´µÀ:
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
>   <IRQ>
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
> ---


Acked-by: Jason Wang <jasowang@redhat.com>

The codes became hard to read, I think we can try to do some cleanups on 
top to make it easier to read.

Thanks


>   drivers/net/virtio_net.c | 12 +++++++++---
>   1 file changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 74d2d49264f3..7fda2ae4c40f 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -387,7 +387,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>   	unsigned int copy, hdr_len, hdr_padded_len;
>   	struct page *page_to_free = NULL;
>   	int tailroom, shinfo_size;
> -	char *p, *hdr_p;
> +	char *p, *hdr_p, *buf;
>   
>   	p = page_address(page) + offset;
>   	hdr_p = p;
> @@ -403,11 +403,15 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>   	 * space are aligned.
>   	 */
>   	if (headroom) {
> -		/* The actual allocated space size is PAGE_SIZE. */
> +		/* Buffers with headroom use PAGE_SIZE as alloc size,
> +		 * see add_recvbuf_mergeable() + get_mergeable_buf_len()
> +		 */
>   		truesize = PAGE_SIZE;
>   		tailroom = truesize - len - offset;
> +		buf = page_address(page);
>   	} else {
>   		tailroom = truesize - len;
> +		buf = p;
>   	}
>   
>   	len -= hdr_len;
> @@ -416,11 +420,13 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>   
>   	shinfo_size = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
>   
> +	/* copy small packet so we can reuse these pages */
>   	if (!NET_IP_ALIGN && len > GOOD_COPY_LEN && tailroom >= shinfo_size) {
> -		skb = build_skb(p, truesize);
> +		skb = build_skb(buf, truesize);
>   		if (unlikely(!skb))
>   			return NULL;
>   
> +		skb_reserve(skb, p - buf);
>   		skb_put(skb, len);
>   		goto ok;
>   	}


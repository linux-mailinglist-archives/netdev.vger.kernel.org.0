Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F56B36638B
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 04:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234004AbhDUCQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 22:16:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21840 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233824AbhDUCQm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 22:16:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618971369;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iGr/qnvxYi2YAhXaRHoOb50iJM5aPIsNbPEVK2bwH+s=;
        b=L+yOF8yYDL1ZJXrqTP43j5nz9IGUqb+PdLQcK9J6XxvxNryfEX99kDl82s9u1qkqAwwW+Z
        5GOEmVV+Q0ad1SbfhRtmojY+mOY0r/aObGIRnYuxITiptyb7CphStGq3Ouep/GS/sUMtea
        o4R68uQSwr5hxzDkZXHLlUQ64UI5/LY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-509-WvnCbF-eO5iUlx5b1dMO6g-1; Tue, 20 Apr 2021 22:16:05 -0400
X-MC-Unique: WvnCbF-eO5iUlx5b1dMO6g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 97E091882FD8;
        Wed, 21 Apr 2021 02:16:03 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-189.pek2.redhat.com [10.72.13.189])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 959A85C1A1;
        Wed, 21 Apr 2021 02:15:55 +0000 (UTC)
Subject: Re: [PATCH net-next] virtio-net: fix use-after-free in page_to_skb()
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org
References: <20210420094341.3259328-1-eric.dumazet@gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <3224f3bb-ab26-0106-ea61-9a1e2fe49a57@redhat.com>
Date:   Wed, 21 Apr 2021 10:15:53 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210420094341.3259328-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/4/20 ÏÂÎç5:43, Eric Dumazet Ð´µÀ:
> From: Eric Dumazet <edumazet@google.com>
>
> KASAN/syzbot had 4 reports, one of them being:
>
> BUG: KASAN: slab-out-of-bounds in memcpy include/linux/fortify-string.h:191 [inline]
> BUG: KASAN: slab-out-of-bounds in page_to_skb+0x5cf/0xb70 drivers/net/virtio_net.c:480
> Read of size 12 at addr ffff888014a5f800 by task systemd-udevd/8445
>
> CPU: 0 PID: 8445 Comm: systemd-udevd Not tainted 5.12.0-rc8-next-20210419-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>   <IRQ>
>   __dump_stack lib/dump_stack.c:79 [inline]
>   dump_stack+0x141/0x1d7 lib/dump_stack.c:120
>   print_address_description.constprop.0.cold+0x5b/0x2f8 mm/kasan/report.c:233
>   __kasan_report mm/kasan/report.c:419 [inline]
>   kasan_report.cold+0x7c/0xd8 mm/kasan/report.c:436
>   check_region_inline mm/kasan/generic.c:180 [inline]
>   kasan_check_range+0x13d/0x180 mm/kasan/generic.c:186
>   memcpy+0x20/0x60 mm/kasan/shadow.c:65
>   memcpy include/linux/fortify-string.h:191 [inline]
>   page_to_skb+0x5cf/0xb70 drivers/net/virtio_net.c:480
>   receive_mergeable drivers/net/virtio_net.c:1009 [inline]
>   receive_buf+0x2bc0/0x6250 drivers/net/virtio_net.c:1119
>   virtnet_receive drivers/net/virtio_net.c:1411 [inline]
>   virtnet_poll+0x568/0x10b0 drivers/net/virtio_net.c:1516
>   __napi_poll+0xaf/0x440 net/core/dev.c:6962
>   napi_poll net/core/dev.c:7029 [inline]
>   net_rx_action+0x801/0xb40 net/core/dev.c:7116
>   __do_softirq+0x29b/0x9fe kernel/softirq.c:559
>   invoke_softirq kernel/softirq.c:433 [inline]
>   __irq_exit_rcu+0x136/0x200 kernel/softirq.c:637
>   irq_exit_rcu+0x5/0x20 kernel/softirq.c:649
>   common_interrupt+0xa4/0xd0 arch/x86/kernel/irq.c:240
>
> Fixes: fb32856b16ad ("virtio-net: page_to_skb() use build_skb when there's sufficient tailroom")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Reported-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: virtualization@lists.linux-foundation.org
> ---


Acked-by: Jason Wang <jasowang@redhat.com>


>   drivers/net/virtio_net.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 8cd76037c72481200ea3e8429e9fdfec005dad85..2e28c04aa6351d2b4016f7d277ce104c4970069d 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -385,6 +385,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>   	struct sk_buff *skb;
>   	struct virtio_net_hdr_mrg_rxbuf *hdr;
>   	unsigned int copy, hdr_len, hdr_padded_len;
> +	struct page *page_to_free = NULL;
>   	int tailroom, shinfo_size;
>   	char *p, *hdr_p;
>   
> @@ -445,7 +446,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>   		if (len)
>   			skb_add_rx_frag(skb, 0, page, offset, len, truesize);
>   		else
> -			put_page(page);
> +			page_to_free = page;
>   		goto ok;
>   	}
>   
> @@ -479,6 +480,8 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>   		hdr = skb_vnet_hdr(skb);
>   		memcpy(hdr, hdr_p, hdr_len);
>   	}
> +	if (page_to_free)
> +		put_page(page_to_free);
>   
>   	if (metasize) {
>   		__skb_pull(skb, metasize);


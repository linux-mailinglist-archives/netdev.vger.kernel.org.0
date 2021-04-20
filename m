Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2B33655DD
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 12:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbhDTKIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 06:08:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24726 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230264AbhDTKIL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 06:08:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618913260;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dywaIrimntGHtXMPexJC2bdCK/i5J9mjfxsn18CX8A0=;
        b=dQPGSAAEnXZrLtY2jWfZx2IYBuyPyFweLESTRflxGyjC70n+fontXRALsVSNF075Sj3OZl
        SNnbrRZu5v98ydf8yDwBrWf1mm0HAM2Now7J+m7vXWHBpVsMUX5vwLB46rlfjVY247A+3c
        w+Kj9JgP9TwmTs6yNqx78in9EUnyB+g=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-198-bMzC_5ZQN_-sxOC8bpG4pg-1; Tue, 20 Apr 2021 06:07:38 -0400
X-MC-Unique: bMzC_5ZQN_-sxOC8bpG4pg-1
Received: by mail-wm1-f70.google.com with SMTP id l6-20020a1c25060000b029010ee60ad0fcso4950130wml.9
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 03:07:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dywaIrimntGHtXMPexJC2bdCK/i5J9mjfxsn18CX8A0=;
        b=nxSs9UZ9uV2diJaiwGErscKJekNWyLvQglhoDXS5C3IO6v/Z9FoV2LuVDi+H7VEP/b
         wdXWVth+Mw2vR/Y5Zf6Dms900KRqs1qVcspJD/o0zgUZPIljwx8yVk5GpjnLCQfKKFAU
         lNRiX8G8EBCM1lXKcP0upA6O/spgXKJ67c4LcxuVn8BFy5fFvqKo9iUTCdCgOA6vNFrE
         Fx1VgAZI4FhBxmMUxn+kFRCFA2AKfwH+0uEnsnMZL3KDobw+4lIYK0vHxULs/FvuyCen
         ayMbpWA1gz+eQfaa6iSdamL/Fzk6Rmt+0eeHHKpR6juzZeol56UKyaNcjcXPXuh05y0J
         uEoA==
X-Gm-Message-State: AOAM533sKwluQnJ9RARPvmSrXT7xpppj4BIdRkU1RsSFcKNLKSUyi3KU
        9QVS8QNHVljJW1+N4wS0rJU6pfctQ5xwGNuazKj4yqrD+6bLkT6fw6iL+Fn0JuhUFYAUGmoiqRm
        Wmte+6LfUgxhM8sxP
X-Received: by 2002:a5d:4682:: with SMTP id u2mr19800076wrq.167.1618913257148;
        Tue, 20 Apr 2021 03:07:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzylBHKjaYkdj2ID3wez0kTYdtoOuUKNSm38xMKbXTkQM0o2Cry8DF33FvRPX7WNnbWeH3P+g==
X-Received: by 2002:a5d:4682:: with SMTP id u2mr19800063wrq.167.1618913257010;
        Tue, 20 Apr 2021 03:07:37 -0700 (PDT)
Received: from redhat.com ([2a10:800a:cdef:0:114d:2085:61e4:7b41])
        by smtp.gmail.com with ESMTPSA id t20sm2686479wmi.35.2021.04.20.03.07.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 03:07:36 -0700 (PDT)
Date:   Tue, 20 Apr 2021 06:07:33 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH net-next] virtio-net: fix use-after-free in page_to_skb()
Message-ID: <20210420060715-mutt-send-email-mst@kernel.org>
References: <20210420094341.3259328-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210420094341.3259328-1-eric.dumazet@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 02:43:41AM -0700, Eric Dumazet wrote:
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
>  <IRQ>
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0x141/0x1d7 lib/dump_stack.c:120
>  print_address_description.constprop.0.cold+0x5b/0x2f8 mm/kasan/report.c:233
>  __kasan_report mm/kasan/report.c:419 [inline]
>  kasan_report.cold+0x7c/0xd8 mm/kasan/report.c:436
>  check_region_inline mm/kasan/generic.c:180 [inline]
>  kasan_check_range+0x13d/0x180 mm/kasan/generic.c:186
>  memcpy+0x20/0x60 mm/kasan/shadow.c:65
>  memcpy include/linux/fortify-string.h:191 [inline]
>  page_to_skb+0x5cf/0xb70 drivers/net/virtio_net.c:480
>  receive_mergeable drivers/net/virtio_net.c:1009 [inline]
>  receive_buf+0x2bc0/0x6250 drivers/net/virtio_net.c:1119
>  virtnet_receive drivers/net/virtio_net.c:1411 [inline]
>  virtnet_poll+0x568/0x10b0 drivers/net/virtio_net.c:1516
>  __napi_poll+0xaf/0x440 net/core/dev.c:6962
>  napi_poll net/core/dev.c:7029 [inline]
>  net_rx_action+0x801/0xb40 net/core/dev.c:7116
>  __do_softirq+0x29b/0x9fe kernel/softirq.c:559
>  invoke_softirq kernel/softirq.c:433 [inline]
>  __irq_exit_rcu+0x136/0x200 kernel/softirq.c:637
>  irq_exit_rcu+0x5/0x20 kernel/softirq.c:649
>  common_interrupt+0xa4/0xd0 arch/x86/kernel/irq.c:240
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

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  drivers/net/virtio_net.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 8cd76037c72481200ea3e8429e9fdfec005dad85..2e28c04aa6351d2b4016f7d277ce104c4970069d 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -385,6 +385,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>  	struct sk_buff *skb;
>  	struct virtio_net_hdr_mrg_rxbuf *hdr;
>  	unsigned int copy, hdr_len, hdr_padded_len;
> +	struct page *page_to_free = NULL;
>  	int tailroom, shinfo_size;
>  	char *p, *hdr_p;
>  
> @@ -445,7 +446,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>  		if (len)
>  			skb_add_rx_frag(skb, 0, page, offset, len, truesize);
>  		else
> -			put_page(page);
> +			page_to_free = page;
>  		goto ok;
>  	}
>  
> @@ -479,6 +480,8 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>  		hdr = skb_vnet_hdr(skb);
>  		memcpy(hdr, hdr_p, hdr_len);
>  	}
> +	if (page_to_free)
> +		put_page(page_to_free);
>  
>  	if (metasize) {
>  		__skb_pull(skb, metasize);
> -- 
> 2.31.1.368.gbe11c130af-goog


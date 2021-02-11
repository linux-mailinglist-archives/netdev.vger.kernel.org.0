Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 874E5318B50
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 14:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbhBKM7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 07:59:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45243 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231635AbhBKM5T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 07:57:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613048131;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DqLEmy352PVSSCnB0NInkDsBA5ICJ08d95eqRxne6SQ=;
        b=K7seAH5wn60rn4i2Y1fLhIkX9GUFtqVQHJFxX6qRdDWqGDNx0RRrW2VUj8c8I/4FzeC9kz
        bCi3pSBpE/G48VxbrAFgjbb9beTs5zPuGNylkprSC23wqWCln9XUNJb1ClxAqdlQl6e4wS
        Lz5eSybEbNXbcy/S1Wm9QBWElZEyEUk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-450-OloXy9pNNVqG9SOeByEbFg-1; Thu, 11 Feb 2021 07:55:26 -0500
X-MC-Unique: OloXy9pNNVqG9SOeByEbFg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 23995425C6;
        Thu, 11 Feb 2021 12:55:12 +0000 (UTC)
Received: from carbon (unknown [10.36.110.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 140F67D55D;
        Thu, 11 Feb 2021 12:55:00 +0000 (UTC)
Date:   Thu, 11 Feb 2021 13:54:59 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Kevin Hao <haokexin@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Dexuan Cui <decui@microsoft.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        Yonghong Song <yhs@fb.com>, zhudi <zhudi21@huawei.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Florian Westphal <fw@strlen.de>,
        Edward Cree <ecree.xilinx@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        brouer@redhat.com
Subject: Re: [PATCH v4 net-next 08/11] skbuff: introduce
 {,__}napi_build_skb() which reuses NAPI cache heads
Message-ID: <20210211135459.075d954b@carbon>
In-Reply-To: <20210210162732.80467-9-alobakin@pm.me>
References: <20210210162732.80467-1-alobakin@pm.me>
        <20210210162732.80467-9-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Feb 2021 16:30:23 +0000
Alexander Lobakin <alobakin@pm.me> wrote:

> Instead of just bulk-flushing skbuff_heads queued up through
> napi_consume_skb() or __kfree_skb_defer(), try to reuse them
> on allocation path.

Maybe you are already aware of this dynamics, but high speed NICs will
usually run the TX "cleanup" (opportunistic DMA-completion) in the napi
poll function call, and often before processing RX packets. Like
ixgbe_poll[1] calls ixgbe_clean_tx_irq() before ixgbe_clean_rx_irq().

If traffic is symmetric (or is routed-back same interface) then this
SKB recycle scheme will be highly efficient. (I had this part of my
initial patchset and tested it on ixgbe).

[1] https://elixir.bootlin.com/linux/v5.11-rc7/source/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c#L3149

> If the cache is empty on allocation, bulk-allocate the first
> 16 elements, which is more efficient than per-skb allocation.
> If the cache is full on freeing, bulk-wipe the second half of
> the cache (32 elements).
> This also includes custom KASAN poisoning/unpoisoning to be
> double sure there are no use-after-free cases.
> 
> To not change current behaviour, introduce a new function,
> napi_build_skb(), to optionally use a new approach later
> in drivers.
> 
> Note on selected bulk size, 16:
>  - this equals to XDP_BULK_QUEUE_SIZE, DEV_MAP_BULK_SIZE
>    and especially VETH_XDP_BATCH, which is also used to
>    bulk-allocate skbuff_heads and was tested on powerful
>    setups;
>  - this also showed the best performance in the actual
>    test series (from the array of {8, 16, 32}).
> 
> Suggested-by: Edward Cree <ecree.xilinx@gmail.com> # Divide on two halves
> Suggested-by: Eric Dumazet <edumazet@google.com>   # KASAN poisoning
> Cc: Dmitry Vyukov <dvyukov@google.com>             # Help with KASAN
> Cc: Paolo Abeni <pabeni@redhat.com>                # Reduced batch size
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> ---
>  include/linux/skbuff.h |  2 +
>  net/core/skbuff.c      | 94 ++++++++++++++++++++++++++++++++++++------
>  2 files changed, 83 insertions(+), 13 deletions(-)
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 0e0707296098..906122eac82a 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -1087,6 +1087,8 @@ struct sk_buff *build_skb(void *data, unsigned int frag_size);
>  struct sk_buff *build_skb_around(struct sk_buff *skb,
>  				 void *data, unsigned int frag_size);
>  
> +struct sk_buff *napi_build_skb(void *data, unsigned int frag_size);
> +
>  /**
>   * alloc_skb - allocate a network buffer
>   * @size: size to allocate
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 860a9d4f752f..9e1a8ded4acc 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -120,6 +120,8 @@ static void skb_under_panic(struct sk_buff *skb, unsigned int sz, void *addr)
>  }
>  
>  #define NAPI_SKB_CACHE_SIZE	64
> +#define NAPI_SKB_CACHE_BULK	16
> +#define NAPI_SKB_CACHE_HALF	(NAPI_SKB_CACHE_SIZE / 2)
>  


-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer


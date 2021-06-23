Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 702A23B2161
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 21:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhFWTs1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 15:48:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21367 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229523AbhFWTs1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 15:48:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624477568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5RisPrPjCMS6safES3jNCNozmv4O8WOuYlgF9/vHY9w=;
        b=DZGtOiDqoNI1Ttto8PmHGsVKKNepzETX1t82w1M12mRQXdGgWa0NdX0uRYg9g3ak3wTGv8
        KFDGtsyEkMxS3QeKMlm9I19sUnwKHE7L0baf6unem4Ttk5KXiYvMxXaB8BgOJStkZJgTYM
        FNrgx5EHkh4F8R0f1ST/JgkuqNq9HFY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-324-_Bw6S495N7GWHT4OF3XpkA-1; Wed, 23 Jun 2021 15:46:04 -0400
X-MC-Unique: _Bw6S495N7GWHT4OF3XpkA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CBC331084F4C;
        Wed, 23 Jun 2021 19:46:02 +0000 (UTC)
Received: from carbon (unknown [10.36.110.39])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 55232100164A;
        Wed, 23 Jun 2021 19:45:56 +0000 (UTC)
Date:   Wed, 23 Jun 2021 21:45:55 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     brouer@redhat.com, davem@davemloft.net, netdev@vger.kernel.org,
        willemb@google.com, eric.dumazet@gmail.com, dsahern@gmail.com,
        yoshfuji@linux-ipv6.org, Dave Jones <dsj@fb.com>
Subject: Re: [PATCH net-next v3] net: ip: avoid OOM kills with large UDP
 sends over loopback
Message-ID: <20210623214555.5c683821@carbon>
In-Reply-To: <20210623162328.2197645-1-kuba@kernel.org>
References: <20210623162328.2197645-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Jun 2021 09:23:28 -0700
Jakub Kicinski <kuba@kernel.org> wrote:

> Dave observed number of machines hitting OOM on the UDP send
> path. The workload seems to be sending large UDP packets over
> loopback. Since loopback has MTU of 64k kernel will try to
> allocate an skb with up to 64k of head space. This has a good
> chance of failing under memory pressure. What's worse if
> the message length is <32k the allocation may trigger an
> OOM killer.
> 
> This is entirely avoidable, we can use an skb with page frags.
> 
> af_unix solves a similar problem by limiting the head
> length to SKB_MAX_ALLOC. This seems like a good and simple
> approach. It means that UDP messages > 16kB will now
> use fragments if underlying device supports SG, if extra
> allocator pressure causes regressions in real workloads
> we can switch to trying the large allocation first and
> falling back.
> 
> Reported-by: Dave Jones <dsj@fb.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  net/ipv4/ip_output.c  | 4 +++-
>  net/ipv6/ip6_output.c | 4 +++-
>  2 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
> index c3efc7d658f6..790dd28fd198 100644
> --- a/net/ipv4/ip_output.c
> +++ b/net/ipv4/ip_output.c
> @@ -1077,7 +1077,9 @@ static int __ip_append_data(struct sock *sk,
>  			if ((flags & MSG_MORE) &&
>  			    !(rt->dst.dev->features&NETIF_F_SG))
>  				alloclen = mtu;
> -			else if (!paged)
> +			else if (!paged &&
> +				 (fraglen + hh_len + 15 < SKB_MAX_ALLOC ||

What does the number 15 represent here?

> +				  !(rt->dst.dev->features & NETIF_F_SG)))
>  				alloclen = fraglen;
>  			else {
>  				alloclen = min_t(int, fraglen, MAX_HEADER);
> diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
> index ff4f9ebcf7f6..ae8dbd6cdab1 100644
> --- a/net/ipv6/ip6_output.c
> +++ b/net/ipv6/ip6_output.c
> @@ -1585,7 +1585,9 @@ static int __ip6_append_data(struct sock *sk,
>  			if ((flags & MSG_MORE) &&
>  			    !(rt->dst.dev->features&NETIF_F_SG))
>  				alloclen = mtu;
> -			else if (!paged)
> +			else if (!paged &&
> +				 (fraglen + hh_len < SKB_MAX_ALLOC ||

The number 15 is not use here.

> +				  !(rt->dst.dev->features & NETIF_F_SG)))
>  				alloclen = fraglen;
>  			else {
>  				alloclen = min_t(int, fraglen, MAX_HEADER);



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer


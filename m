Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D624A35DF9A
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 15:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345911AbhDMM6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 08:58:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41032 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345905AbhDMM6m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 08:58:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618318702;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VnhxLRKuFKiHVAmes1BYGe4kBPhEwPfKPuMbmo6cOLM=;
        b=Ub8CCIJYiRJ5v5SDmxUDASdyACt8m+3lyus2RPLNoIOkz1phrNh/09RRecnJSEDk2THPoz
        IsTI3GlwGiqd6lxNeDaNXAUkXgyk6q9qlrseTUO7PLCGJhAug1UkmVo/3HOc8coMhOTRrs
        JYGq4Nny+b8y0vww8JWUa66mUMO7ynY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-330-YFGJlbrwM32oaWYm_riLdw-1; Tue, 13 Apr 2021 08:58:20 -0400
X-MC-Unique: YFGJlbrwM32oaWYm_riLdw-1
Received: by mail-wr1-f71.google.com with SMTP id j24so749807wra.1
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 05:58:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VnhxLRKuFKiHVAmes1BYGe4kBPhEwPfKPuMbmo6cOLM=;
        b=TLYj+H0jDdCRVaAzJLQeZDeEBQcr0t9dQblg1NzTWIeQgrfTyLnvgNssyVml4ZsZQ3
         9ENqSfNuNxZImnGeFlFD/yumpF+GAAp8kQntsue51sQyKM4vnqGJbxQW/Rw/lJP6LIcG
         7rWRduq1wy9uh5tcV3R6PSECDFR9D/E+QzClzqUG88xPC9qogJdaBhZ6WcHoutnvtwks
         wBFDP3bOTw7hFj5NPGpVA5jeWhCJWc45qDA8vf+skjXFPfS+xeFCrER+AWGz8uu5daHD
         fqG9zs5W+iuZ2E59wXKY2FWmCKh30XFTjI8FmVdCYD8zeJeK5CPqJ/d7uryU1i2Qu2Kq
         R01w==
X-Gm-Message-State: AOAM533qYfQrd4511uaKHqxLOy/pwDMFxD8m6EYwgmyr9Z/boQbZH5Vm
        SxNQx6ABQem0wyNvjgI1vJSIIrQZcTGbD0mllK01QePOCyolMSscE4u+4bwHjDDMhzP7HAEpfQ5
        ljKXwhUqZ9NDa3fOS
X-Received: by 2002:a5d:4707:: with SMTP id y7mr15756115wrq.396.1618318698268;
        Tue, 13 Apr 2021 05:58:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzuDHn2tjby5upr6Iq2Al1K5wuJQorrhlOsOim3DHBtwJxV1o3i9sHrAHTyeF5TIHKMqdUwog==
X-Received: by 2002:a5d:4707:: with SMTP id y7mr15756099wrq.396.1618318698106;
        Tue, 13 Apr 2021 05:58:18 -0700 (PDT)
Received: from redhat.com ([2a10:8006:2281:0:1994:c627:9eac:1825])
        by smtp.gmail.com with ESMTPSA id l7sm22121605wrb.35.2021.04.13.05.58.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 05:58:17 -0700 (PDT)
Date:   Tue, 13 Apr 2021 08:58:14 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH net] gro: ensure frag0 meets IP header alignment
Message-ID: <20210413085758-mutt-send-email-mst@kernel.org>
References: <20210413124136.2750358-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210413124136.2750358-1-eric.dumazet@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 05:41:35AM -0700, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> After commit 0f6925b3e8da ("virtio_net: Do not pull payload in skb->head")
> Guenter Roeck reported one failure in his tests using sh architecture.
> 
> After much debugging, we have been able to spot silent unaligned accesses
> in inet_gro_receive()
> 
> The issue at hand is that upper networking stacks assume their header
> is word-aligned. Low level drivers are supposed to reserve NET_IP_ALIGN
> bytes before the Ethernet header to make that happen.
> 
> This patch hardens skb_gro_reset_offset() to not allow frag0 fast-path
> if the fragment is not properly aligned.
> 
> Some arches like x86, arm64 and powerpc do not care and define NET_IP_ALIGN
> as 0, this extra check will be a NOP for them.
> 
> Note that if frag0 is not used, GRO will call pskb_may_pull()
> as many times as needed to pull network and transport headers.
> 
> Fixes: 0f6925b3e8da ("virtio_net: Do not pull payload in skb->head")
> Fixes: 78a478d0efd9 ("gro: Inline skb_gro_header and cache frag0 virtual address")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>

Seems to make sense.

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  net/core/dev.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index af8c1ea040b9364b076e2d72f04dc3de2d7e2f11..1f79b9aa9a3f2392fddd1401f95ad098b5e03204 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -5924,7 +5924,8 @@ static void skb_gro_reset_offset(struct sk_buff *skb)
>  	NAPI_GRO_CB(skb)->frag0_len = 0;
>  
>  	if (!skb_headlen(skb) && pinfo->nr_frags &&
> -	    !PageHighMem(skb_frag_page(frag0))) {
> +	    !PageHighMem(skb_frag_page(frag0)) &&
> +	    (!NET_IP_ALIGN || !(skb_frag_off(frag0) & 3))) {
>  		NAPI_GRO_CB(skb)->frag0 = skb_frag_address(frag0);
>  		NAPI_GRO_CB(skb)->frag0_len = min_t(unsigned int,
>  						    skb_frag_size(frag0),
> -- 
> 2.31.1.295.g9ea45b61b8-goog


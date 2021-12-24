Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF45647EACC
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 04:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351117AbhLXDTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 22:19:24 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50310 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350989AbhLXDTY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 22:19:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0626D61F3B
        for <netdev@vger.kernel.org>; Fri, 24 Dec 2021 03:19:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03815C36AE5;
        Fri, 24 Dec 2021 03:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640315963;
        bh=f6J21/rOFUwCUU/Q/VM8YydqYFl4BWGqVzZqC0ZNdc0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Jzb3nXtFqjY/xF1wLN4NRDvPzDRWYHDWEQYQmGje/jBpAtP4XRKM2YY+scpdqcm3x
         NIiHNmhJqUJjDBXt9MBhwu1CaXfERcxm6SxZTd4ir/6TOjqSVqNNGUzcoeN66NXFsx
         3KwmvvjkydXWSWX30Kkca+suz19wJ7+V3WSvmX9KVbP8pU4xCuGyOlaL4qEiRVcbRa
         EVwLqjYdZygGEZYQ+V8aXduntmnHKsS7Q3ZwUJ+sRy/VW2odsu5j4ZB2O5jNHkJg8Q
         M8VgpZgWlPztwiKFUI+24va6tAdNGkw2NKifprMMmwlj6SqyT3nfRW6wT+ID75WPdx
         kMiphwvMacPRA==
Date:   Thu, 23 Dec 2021 19:19:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Coco Li <lixiaoyan@google.com>,
        Willem de Bruijn <willemb@google.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net 1/2] udp: using datalen to cap ipv6 udp max gso
 segments
Message-ID: <20211223191922.4a5cabc4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20211223222441.2975883-1-lixiaoyan@google.com>
References: <20211223222441.2975883-1-lixiaoyan@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Dec 2021 22:24:40 +0000 Coco Li wrote:
> The max number of UDP gso segments is intended to cap to
> UDP_MAX_SEGMENTS, this is checked in udp_send_skb().
> 
> skb->len contains network and transport header len here, we should use
> only data len instead.
> 
> This is the ipv6 counterpart to the below referenced commit,
> which missed the ipv6 change
> 
> Fixes: 158390e45612 ("udp: using datalen to cap max gso segments")

I'm gonna replace the Fixes tag with:

Fixes: bec1f6f69736 ("udp: generate gso with UDP_SEGMENT")

hope that's okay.

> Signed-off-by: Coco Li <lixiaoyan@google.com>
> Reviewed-by: Willem de Bruijn <willemb@google.com>
> ---
>  net/ipv6/udp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
> index a2caca6ccf11..8cde9efd7919 100644
> --- a/net/ipv6/udp.c
> +++ b/net/ipv6/udp.c
> @@ -1204,7 +1204,7 @@ static int udp_v6_send_skb(struct sk_buff *skb, struct flowi6 *fl6,
>  			kfree_skb(skb);
>  			return -EINVAL;
>  		}
> -		if (skb->len > cork->gso_size * UDP_MAX_SEGMENTS) {
> +		if (datalen > cork->gso_size * UDP_MAX_SEGMENTS) {
>  			kfree_skb(skb);
>  			return -EINVAL;
>  		}


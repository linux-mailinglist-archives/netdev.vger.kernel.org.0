Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2691E8C87
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 02:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728449AbgE3A1W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 20:27:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726898AbgE3A1W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 20:27:22 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D65C03E969
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 17:27:22 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 91FF81287B396;
        Fri, 29 May 2020 17:27:20 -0700 (PDT)
Date:   Fri, 29 May 2020 17:27:19 -0700 (PDT)
Message-Id: <20200529.172719.1001521060083156258.davem@davemloft.net>
To:     willemdebruijn.kernel@gmail.com
Cc:     netdev@vger.kernel.org, willemb@google.com
Subject: Re: [PATCH net] tun: correct header offsets in napi frags mode
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200528170532.215352-1-willemdebruijn.kernel@gmail.com>
References: <20200528170532.215352-1-willemdebruijn.kernel@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 29 May 2020 17:27:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Thu, 28 May 2020 13:05:32 -0400

> Temporarily pull ETH_HLEN to make control flow the same for frags and
> not frags. Then push the header just before calling napi_gro_frags.
 ...
>  	case IFF_TAP:
> -		if (!frags)
> -			skb->protocol = eth_type_trans(skb, tun->dev);
> +		if (frags && !pskb_may_pull(skb, ETH_HLEN)) {
> +			err = -ENOMEM;
> +			goto drop;
> +		}
> +		skb->protocol = eth_type_trans(skb, tun->dev);
 ...
>  		/* Exercise flow dissector code path. */
> -		u32 headlen = eth_get_headlen(tun->dev, skb->data,
> -					      skb_headlen(skb));
> +		skb_push(skb, ETH_HLEN);
> +		headlen = eth_get_headlen(tun->dev, skb->data,
> +					  skb_headlen(skb));

I hate to be a stickler on wording in the commit message, but the
change is not really "pulling" the ethernet header from the SKB.

Instead it is invoking pskb_may_pull() which just makes sure the
header is there in the linear SKB data area.

Can you please refine this description and resubmit?

Thank you.

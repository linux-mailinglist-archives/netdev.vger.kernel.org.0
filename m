Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42F2828AAE0
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 00:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387650AbgJKWNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 18:13:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:46352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387645AbgJKWNf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Oct 2020 18:13:35 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 919DA2078B;
        Sun, 11 Oct 2020 22:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602454414;
        bh=J+Bkm4u8Gbaj7zks/oCQZpsjPxzJvwnfT9WgDBzt4nk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=u07dGahIh240cs4Ts58attr+Yb0gPLHJ1SvpqSczal9e91I9vYN7oin32VvqVQQ19
         nLHasq89U9+7R6E26RqbhM1lXZyAjCzvG5YSMjA1LDD+nLCZTrJocMWboOLWQAnNuL
         +LlrB/DE0zo97fvbuXHTzAhkooernhO6o9fRML5A=
Date:   Sun, 11 Oct 2020 15:13:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH RFC] net: add helper eth_set_protocol
Message-ID: <20201011151332.3123c94e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <027ab4c5-57e8-10b8-816a-17c783f82323@gmail.com>
References: <027ab4c5-57e8-10b8-816a-17c783f82323@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 6 Oct 2020 22:10:00 +0200 Heiner Kallweit wrote:
> In all cases I've seen eth_type_trans() is used as in the new helper.
> Biggest benefit is improved readability when replacing statements like
> the following:
> desc->skb->protocol = eth_type_trans(desc->skb, priv->dev);
> 
> Coccinelle tells me that using the new helper tree-wide would touch
> 313 files. Therefore I'd like to check for feedback before bothering
> 100+ maintainers.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

FWIW in case you're planning to start sending conversion patches..

I'm not 100% sold on this. Maybe it's because I'm used to the call 
as it is. I don't feel like eth_set_protocol() expresses what
eth_type_trans() does well enough. Besides there's a whole bunch of
*_type_trans calls for different (old) L2s, are we going to leave those
as they are?

> diff --git a/include/linux/etherdevice.h b/include/linux/etherdevice.h
> index 2e5debc03..c7f89b1bf 100644
> --- a/include/linux/etherdevice.h
> +++ b/include/linux/etherdevice.h
> @@ -64,6 +64,11 @@ static const u8 eth_reserved_addr_base[ETH_ALEN] __aligned(2) =
>  { 0x01, 0x80, 0xc2, 0x00, 0x00, 0x00 };
>  #define eth_stp_addr eth_reserved_addr_base
>  
> +static inline void eth_set_protocol(struct sk_buff *skb, struct net_device *dev)
> +{
> +	skb->protocol = eth_type_trans(skb, dev);
> +}
> +
>  /**
>   * is_link_local_ether_addr - Determine if given Ethernet address is link-local
>   * @addr: Pointer to a six-byte array containing the Ethernet address


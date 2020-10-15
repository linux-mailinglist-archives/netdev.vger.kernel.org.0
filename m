Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9731728E988
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 02:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbgJOArS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 20:47:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:34440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726018AbgJOArS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Oct 2020 20:47:18 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 829BF22242;
        Thu, 15 Oct 2020 00:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602722837;
        bh=ZTlOSnZw1NE3EWvHZQGAro0qCvmBNY0OZLSYqhFRP2Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Bt3P+pwk+619qhIXDW+0iwZVOI4G0HLB1OYqWMyDh/ctSGACUQwiP/HqTNcI2TCgD
         ilDXDBHcdnXicbuaWB5lpU0RiIzEooAuHLGWpXBcwpMJs79Y/aWq/5WeAQVsorSx7p
         2sxkWUe4ZG26duYcvjFZRuMMXnmjNTgt8UmvNQjI=
Date:   Wed, 14 Oct 2020 17:47:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hoang Huu Le <hoang.h.le@dektech.com.au>
Cc:     tipc-discussion@lists.sourceforge.net, jmaloy@redhat.com,
        maloy@donjonn.com, ying.xue@windriver.com, netdev@vger.kernel.org
Subject: Re: [net] tipc: re-configure queue limit for broadcast link
Message-ID: <20201014174716.44b4fca3@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201013061810.77866-1-hoang.h.le@dektech.com.au>
References: <20201013061810.77866-1-hoang.h.le@dektech.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 13 Oct 2020 13:18:10 +0700 Hoang Huu Le wrote:
> The queue limit of the broadcast link is being calculated base on initial
> MTU. However, when MTU value changed (e.g manual changing MTU on NIC
> device, MTU negotiation etc.,) we do not re-calculate queue limit.
> This gives throughput does not reflect with the change.
> 
> So fix it by calling the function to re-calculate queue limit of the
> broadcast link.
> 
> Acked-by: Jon Maloy <jmaloy@redhat.com>
> Signed-off-by: Hoang Huu Le <hoang.h.le@dektech.com.au>
> ---
>  net/tipc/bcast.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/net/tipc/bcast.c b/net/tipc/bcast.c
> index 940d176e0e87..c77fd13e2777 100644
> --- a/net/tipc/bcast.c
> +++ b/net/tipc/bcast.c
> @@ -108,6 +108,7 @@ static void tipc_bcbase_select_primary(struct net *net)
>  {
>  	struct tipc_bc_base *bb = tipc_bc_base(net);
>  	int all_dests =  tipc_link_bc_peers(bb->link);
> +	int max_win = tipc_link_max_win(bb->link);
>  	int i, mtu, prim;
>  
>  	bb->primary_bearer = INVALID_BEARER_ID;
> @@ -121,8 +122,11 @@ static void tipc_bcbase_select_primary(struct net *net)
>  			continue;
>  
>  		mtu = tipc_bearer_mtu(net, i);
> -		if (mtu < tipc_link_mtu(bb->link))
> +		if (mtu < tipc_link_mtu(bb->link)) {
>  			tipc_link_set_mtu(bb->link, mtu);
> +			tipc_link_set_queue_limits(bb->link, max_win,
> +						   max_win);

Is max/max okay here? Other places seem to use BCLINK_WIN_MIN.

> +		}
>  		bb->bcast_support &= tipc_bearer_bcast_support(net, i);
>  		if (bb->dests[i] < all_dests)
>  			continue;


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB2B2B8566
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 21:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbgKRUOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 15:14:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:46878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726571AbgKRUOZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 15:14:25 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0C1B206FA;
        Wed, 18 Nov 2020 20:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605730464;
        bh=Kvk+98DcOotSnk/czJCfI3P8ZFliI6IdaE1eTW6qSx4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DhjzYnBxxdunMy4DZdrnjUFxiR+Kq9pZ9CtPwwzl8DNxsOObA/LQ37qXl74xOG7mP
         08BmRQZcVh1h4VtRFYx67n6JvEb6jb/s9AK9GzyEwauxQhdhsm/Vgo62cpDW1v0cQD
         TVHBWVenFuGPI07arJV8akKNk28Eql0y4PNW15s4=
Date:   Wed, 18 Nov 2020 12:14:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [PATCH net 2/2] net: Call skb destructor on
 NAPI_GRO_FREE_STOLEN_HEAD
Message-ID: <20201118121422.512ced1d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CANn89iJ=430ri_x_NbfnV2jrP3S0nWK+VUWf0WgrCVBz2oLNfA@mail.gmail.com>
References: <20201117203355.389661-1-saeedm@nvidia.com>
        <20201117203355.389661-2-saeedm@nvidia.com>
        <20201118112207.2b8bea44@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <CANn89iJ=430ri_x_NbfnV2jrP3S0nWK+VUWf0WgrCVBz2oLNfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Nov 2020 21:02:29 +0100 Eric Dumazet wrote:
> On Wed, Nov 18, 2020 at 8:22 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Tue, 17 Nov 2020 12:33:55 -0800 Saeed Mahameed wrote:  
> > > From: Maxim Mikityanskiy <maximmi@mellanox.com>
> > >
> > > All GRO flows except one call skb->destructor, however, GRO_MERGED_FREE
> > > doesn't do it in case of NAPI_GRO_FREE_STOLEN_HEAD. For better
> > > consistency and to add resiliency against the drivers that may pass SKBs
> > > with a destructor, this patch changes napi_skb_free_stolen_head to use
> > > skb_release_head_state, which should perform all the needed cleanups,
> > > including a call to the destructor. This way the code of GRO_MERGED_FREE
> > > becomes similar to kfree_skb_partial.
> > >
> > > Fixes: e44699d2c280 ("net: handle NAPI_GRO_FREE_STOLEN_HEAD case also in napi_frags_finish()")
> > > Fixes: d7e8883cfcf4 ("net: make GRO aware of skb->head_frag")
> > > Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> > > Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> > > Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>  
> >
> > CC Eric for GRO expertise.  
> 
> Thanks for CCing me.
> 
> Since when drivers can pass funny skbs with destructors ???
> 
> Can we please stop adding more cycles to _already_ expensive GRO ?

I don't think they do that today much (save for the ktls optimization
in mlx5 Maxim is fixing separately). But I believe the idea of early
demux in XDP had been floated in the past.

If we don't want that to happen we should document it (stating the
obvious).

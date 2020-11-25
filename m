Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD732C4AAC
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 23:18:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730414AbgKYWLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 17:11:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:48626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730419AbgKYWLj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 17:11:39 -0500
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1C7F206D9;
        Wed, 25 Nov 2020 22:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606342298;
        bh=N/kXEo9GLhv/gq1WfsNtE0guD9npFWg+7sGbyIyFg98=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=QHeIvuC0dLr8ofLeXqmhinzxfHCyJ0lQUPMH8V8XaACdFQjlSwq+3cK6XcdxxIqlg
         6rEWRc01XfPZxJ8qEbjMKCNpicf338/8gXLy0+frmWYC43O3UliB7ZnU/L3Pe3h0K4
         iLJI8PxZFxnmWHoTbcyGzcbIyCsHcOmoy+oxC+yE=
Message-ID: <01cf3d2bbaf3f090affa642e402c799a565f8ea9.camel@kernel.org>
Subject: Re: [PATCH net 2/2] net: Call skb destructor on
 NAPI_GRO_FREE_STOLEN_HEAD
From:   Saeed Mahameed <saeed@kernel.org>
To:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>
Date:   Wed, 25 Nov 2020 14:11:36 -0800
In-Reply-To: <CANn89iL2p33Z4LDUOb-6YOw+AiNiOhNWOjAu1+_N8_3aKDCFVQ@mail.gmail.com>
References: <20201117203355.389661-1-saeedm@nvidia.com>
         <20201117203355.389661-2-saeedm@nvidia.com>
         <20201118112207.2b8bea44@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
         <CANn89iJ=430ri_x_NbfnV2jrP3S0nWK+VUWf0WgrCVBz2oLNfA@mail.gmail.com>
         <20201118121422.512ced1d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
         <CANn89iL2p33Z4LDUOb-6YOw+AiNiOhNWOjAu1+_N8_3aKDCFVQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-11-18 at 21:21 +0100, Eric Dumazet wrote:
> On Wed, Nov 18, 2020 at 9:14 PM Jakub Kicinski <kuba@kernel.org>
> wrote:
> > On Wed, 18 Nov 2020 21:02:29 +0100 Eric Dumazet wrote:
> > > On Wed, Nov 18, 2020 at 8:22 PM Jakub Kicinski <kuba@kernel.org>
> > > wrote:
> > > > On Tue, 17 Nov 2020 12:33:55 -0800 Saeed Mahameed wrote:
> > > > > From: Maxim Mikityanskiy <maximmi@mellanox.com>
> > > > > 
> > > > > All GRO flows except one call skb->destructor, however,
> > > > > GRO_MERGED_FREE
> > > > > doesn't do it in case of NAPI_GRO_FREE_STOLEN_HEAD. For
> > > > > better
> > > > > consistency and to add resiliency against the drivers that
> > > > > may pass SKBs
> > > > > with a destructor, this patch changes
> > > > > napi_skb_free_stolen_head to use
> > > > > skb_release_head_state, which should perform all the needed
> > > > > cleanups,
> > > > > including a call to the destructor. This way the code of
> > > > > GRO_MERGED_FREE
> > > > > becomes similar to kfree_skb_partial.
> > > > > 
> > > > > Fixes: e44699d2c280 ("net: handle NAPI_GRO_FREE_STOLEN_HEAD
> > > > > case also in napi_frags_finish()")
> > > > > Fixes: d7e8883cfcf4 ("net: make GRO aware of skb->head_frag")
> > > > > Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> > > > > Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> > > > > Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> > > > 
> > > > CC Eric for GRO expertise.
> > > 
> > > Thanks for CCing me.
> > > 
> > > Since when drivers can pass funny skbs with destructors ???
> > > 
> > > Can we please stop adding more cycles to _already_ expensive GRO
> > > ?
> > 
> > I don't think they do that today much (save for the ktls
> > optimization
> > in mlx5 Maxim is fixing separately). But I believe the idea of
> > early
> > demux in XDP had been floated in the past.
> > 
> > If we don't want that to happen we should document it (stating the
> > obvious).
> 
> This is a patch targeting the net tree, with Fixes: tag pretending
> this is an old bug.
> 
> How can we possibly merge two skbs if they have destructors ?
> 
> We do not make sure it is even possible.
> 
> Many destructors track skb->truesize against a socket wmem_alloc or
> rmem_alloc,
> this stuff can not possibly work, unless stronger checks in GRO,
> since
> GRO changes skb->truesize
> without checking skb->destructor.
> 
> If skb has a destructor, just bypass GRO completely, this is the only
> thing we can do.
> This would be quite unfortunate to add such a check "just because
> someone tries to fool us"
> 

Thanks Eric !!
We don't actually need this patch, as the kTLS SKBs are handled locally
in the drivers, I think we don't need to add any extra check in the
datapath and just enforce the policy somehow with debug macros
maybe WARN_ONE_ONCE()

I will drop this patch, but the XDP folks who are going to implement
XDP early demux should take care of this themselves.

> diff --git a/net/core/dev.c b/net/core/dev.c
> index
> 4bfdcd6b20e8836e2884c51c6ce349ed54130bfa..76f0a627b6a1ee02339a724ecb6
> e4dbade80501b
> 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -5920,7 +5920,7 @@ static enum gro_result dev_gro_receive(struct
> napi_struct *napi, struct sk_buff
>         int same_flow;
>         int grow;
> 
> -       if (netif_elide_gro(skb->dev))
> +       if (netif_elide_gro(skb->dev) || skb->destructor)
>                 goto normal;
> 
>         gro_head = gro_list_prepare(napi, skb);


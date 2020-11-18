Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAB012B853F
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 21:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbgKRUCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 15:02:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725879AbgKRUCn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 15:02:43 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC343C0613D4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 12:02:41 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id j23so3390667iog.6
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 12:02:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zoXGx4yGemEQP0N2E9+3exsnK21xJyccYiuJ1xOqT8M=;
        b=YWhMK1PtqLpTaxXs2DsIHhYsSqsuUzgypHVnkjbNAKlN3uw9TPGYZCCg/BrsNNiIMs
         cIwVPrRjUKx3AhIM/jt9pBWbfTHIBEO3upU+bTNYAdqCTgJZmugN7fPGH5JsKeksiYfh
         LfNnG64F71MEms2nwIMA9i3qT1lwT52ErxfniC2tNtCRkMYXUJ+UyltP26MMOWNy69ID
         Mp6FKPzyEKhkXpSyp//3KCOK9SnRY+u8J4hRCZK7UQWem6Y8pv1vaLxkg6kAfS1TOZo+
         tqkCw5g5K/VbEHszxgsIPwG0l7zFcy3nWEwYP4tZeQxc3C+aUPkt7Rmjlo5clWEYyAT2
         CfAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zoXGx4yGemEQP0N2E9+3exsnK21xJyccYiuJ1xOqT8M=;
        b=O2WEsTdSvcG1Z1WJsiNX0Q35JQMVr7/3k1A4s+WwctTWTcB1IZjX+YlRgi1ISm2G16
         ApOBTztRrPA9omwcEjhEe392q+I4Ll291EE3J9R79DmjTR9Kl/D3YZdovY9yWy6wEush
         gyF7+aSRtQap3VA/V9BStNVtcr5hCArZxMo3/65z4RMUAhSuyC1xgWQqBD4epKB3Py6W
         1/Y8sfD2vBH6FMQFZpE44pM4UlYU2kVbfaLe+vfF+mbh1eJsAv+PxrfvLxYMmxy3SpsM
         JsUhNv9WH4hQ4YBoDa1z0jpHfgSWW59G+9XW1u045xV4dDZnJTbSjvomJh5EZzARot4Q
         Id0w==
X-Gm-Message-State: AOAM532J2HF4N7SWdnv2rBLjNg3csB9XogQWBLmaQ0o+K+ASrr7rFUqW
        7uRAQAyDeaxvrjBVRadtJVU7UoTAYG/WH608uyE0hREBh41g8/nw
X-Google-Smtp-Source: ABdhPJxlTiTkzFGsUhw+Hem85/zHf1INa8VWmgSoUxafTZCuUWvS5sdf+bBqh3DjNLQDVhY6JN1SOMH7TP5ddpbosZM=
X-Received: by 2002:a6b:8fc7:: with SMTP id r190mr1710742iod.99.1605729760890;
 Wed, 18 Nov 2020 12:02:40 -0800 (PST)
MIME-Version: 1.0
References: <20201117203355.389661-1-saeedm@nvidia.com> <20201117203355.389661-2-saeedm@nvidia.com>
 <20201118112207.2b8bea44@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201118112207.2b8bea44@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 18 Nov 2020 21:02:29 +0100
Message-ID: <CANn89iJ=430ri_x_NbfnV2jrP3S0nWK+VUWf0WgrCVBz2oLNfA@mail.gmail.com>
Subject: Re: [PATCH net 2/2] net: Call skb destructor on NAPI_GRO_FREE_STOLEN_HEAD
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 8:22 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 17 Nov 2020 12:33:55 -0800 Saeed Mahameed wrote:
> > From: Maxim Mikityanskiy <maximmi@mellanox.com>
> >
> > All GRO flows except one call skb->destructor, however, GRO_MERGED_FREE
> > doesn't do it in case of NAPI_GRO_FREE_STOLEN_HEAD. For better
> > consistency and to add resiliency against the drivers that may pass SKBs
> > with a destructor, this patch changes napi_skb_free_stolen_head to use
> > skb_release_head_state, which should perform all the needed cleanups,
> > including a call to the destructor. This way the code of GRO_MERGED_FREE
> > becomes similar to kfree_skb_partial.
> >
> > Fixes: e44699d2c280 ("net: handle NAPI_GRO_FREE_STOLEN_HEAD case also in napi_frags_finish()")
> > Fixes: d7e8883cfcf4 ("net: make GRO aware of skb->head_frag")
> > Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> > Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> > Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
>
> CC Eric for GRO expertise.

Thanks for CCing me.

Since when drivers can pass funny skbs with destructors ???

Can we please stop adding more cycles to _already_ expensive GRO ?




>
> Makes sense to me, but do you still need "net/mlx5e: Fix refcount leak
> on kTLS RX resync" even with this applied?
>
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 82dc6b48e45f..85dcc7f19902 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -6048,8 +6048,7 @@ EXPORT_SYMBOL(gro_find_complete_by_type);
> >
> >  static void napi_skb_free_stolen_head(struct sk_buff *skb)
> >  {
> > -     skb_dst_drop(skb);
> > -     skb_ext_put(skb);
> > +     skb_release_head_state(skb);
> >       kmem_cache_free(skbuff_head_cache, skb);
> >  }
> >
>

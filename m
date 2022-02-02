Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFAAD4A71CB
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 14:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344394AbiBBNpC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 08:45:02 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38530 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbiBBNpB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 08:45:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC256B830D1
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 13:45:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12BF0C004E1;
        Wed,  2 Feb 2022 13:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643809499;
        bh=SNB8llWIEaSpYGZp9oQynt1JowJJNwaOvZ9tBu/Zu+Y=;
        h=In-Reply-To:References:From:Subject:Cc:To:Date:From;
        b=f1HF8J+c86sFUGPGlsXspDhyAR9CaNI8vB24mId0ZW/YnRZUNvpYcn6XFhi9okts2
         /zIsEqVJXnNKCTzgeFNuZJTCUFp60PyZNvnJLP5/YLv/xcl48o8PNlarZOk7nzSDKx
         qgkzJTU6t22BMvzT727xCCx5UyiS6VWdVGAy0Q/p5XCP2rNxZyJ7R6Qp3B7ifdUz84
         k+CnNC6YiHzDf+lc9XNA7BBfNgiriBZJqwcfot8Tkd+coatmhetz6V/ipCBeJ7OoGT
         4FJwlrpea/gnL0COH9S+nWBhwXO+sNsP3Wt3tYbqawJ31RerIUXgwR+JmsOTIyG1J2
         WciFG4O+yWrJQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <8585630f-f68c-ecea-a6b5-9a2ca8323566@iogearbox.net>
References: <20220202110137.470850-1-atenart@kernel.org> <20220202110137.470850-2-atenart@kernel.org> <8585630f-f68c-ecea-a6b5-9a2ca8323566@iogearbox.net>
From:   Antoine Tenart <atenart@kernel.org>
Subject: Re: [PATCH net 1/2] net: do not keep the dst cache when uncloning an skb dst and its metadata
Cc:     netdev@vger.kernel.org, vladbu@nvidia.com, pabeni@redhat.com,
        pshelar@ovn.org
To:     Daniel Borkmann <daniel@iogearbox.net>, davem@davemloft.net,
        kuba@kernel.org
Message-ID: <164380949615.380114.13546587453907068231@kwain>
Date:   Wed, 02 Feb 2022 14:44:56 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Daniel Borkmann (2022-02-02 13:13:30)
> On 2/2/22 12:01 PM, Antoine Tenart wrote:
> > When uncloning an skb dst and its associated metadata a new dst+metadata
> > is allocated and the tunnel information from the old metadata is copied
> > over there.
> >=20
> > The issue is the tunnel metadata has references to cached dst, which are
> > copied along the way. When a dst+metadata refcount drops to 0 the
> > metadata is freed including the cached dst entries. As they are also
> > referenced in the initial dst+metadata, this ends up in UaFs.
> >=20
> > In practice the above did not happen because of another issue, the
> > dst+metadata was never freed because its refcount never dropped to 0
> > (this will be fixed in a subsequent patch).
> >=20
> > Fix this by initializing the dst cache after copying the tunnel
> > information from the old metadata to also unshare the dst cache.
> >=20
> > Fixes: d71785ffc7e7 ("net: add dst_cache to ovs vxlan lwtunnel")
> > Cc: Paolo Abeni <pabeni@redhat.com>
> > Reported-by: Vlad Buslov <vladbu@nvidia.com>
> > Tested-by: Vlad Buslov <vladbu@nvidia.com>
> > Signed-off-by: Antoine Tenart <atenart@kernel.org>
> > ---
> >   include/net/dst_metadata.h | 13 ++++++++++++-
> >   1 file changed, 12 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/include/net/dst_metadata.h b/include/net/dst_metadata.h
> > index 14efa0ded75d..c8f8b7b56bba 100644
> > --- a/include/net/dst_metadata.h
> > +++ b/include/net/dst_metadata.h
> > @@ -110,8 +110,8 @@ static inline struct metadata_dst *tun_rx_dst(int m=
d_size)
> >   static inline struct metadata_dst *tun_dst_unclone(struct sk_buff *sk=
b)
> >   {
> >       struct metadata_dst *md_dst =3D skb_metadata_dst(skb);
> > -     int md_size;
> >       struct metadata_dst *new_md;
> > +     int md_size, ret;
> >  =20
> >       if (!md_dst || md_dst->type !=3D METADATA_IP_TUNNEL)
> >               return ERR_PTR(-EINVAL);
> > @@ -123,6 +123,17 @@ static inline struct metadata_dst *tun_dst_unclone=
(struct sk_buff *skb)
> >  =20
> >       memcpy(&new_md->u.tun_info, &md_dst->u.tun_info,
> >              sizeof(struct ip_tunnel_info) + md_size);
> > +#ifdef CONFIG_DST_CACHE
> > +     ret =3D dst_cache_init(&new_md->u.tun_info.dst_cache, GFP_ATOMIC);
> > +     if (ret) {
> > +             /* We can't call metadata_dst_free directly as the still =
shared
> > +              * dst cache would be released.
> > +              */
> > +             kfree(new_md);
> > +             return ERR_PTR(ret);
> > +     }
> > +#endif
>=20
> Could you elaborate (e.g. also in commit message) how this interacts
> or whether it is needed for TUNNEL_NOCACHE users? (Among others,
> latter is used by BPF, for example.)

My understanding is that TUNNEL_NOCACHE is used to decide whether or not
to use a dst cache, that might or might not come from the tunnel info
attached to an skb. The dst cache being allocated in a tunnel info is
orthogonal to the use of TUNNEL_NOCACHE. While looking around I actually
found a code path explicitly setting both, in nft_tunnel_obj_init (that
might need to be investigated though but it is another topic).

It doesn't look like initializing the dst cache would break
TUNNEL_NOCACHE users as ip_tunnel_dst_cache_usable would return false
anyway. Having said that, we probably want to unshare the dst cache only
if there is one already, checking for
'md_dst->u.tun_info.dst_cache.cache !=3D NULL' first.

Does that make sense?

Thanks!
Antoine

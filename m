Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7EB4A9CD4
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 17:19:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347646AbiBDQTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 11:19:40 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55746 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376476AbiBDQTj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 11:19:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA9E9B83829
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 16:19:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E2CFC004E1;
        Fri,  4 Feb 2022 16:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643991577;
        bh=kXkkrkIEePN17Fz+Y1Uc4hhm7O497uhCYPNN5IO8p3Q=;
        h=In-Reply-To:References:Subject:To:Cc:From:Date:From;
        b=KZHDQcpZSVvcvEwa89QNj1XZQW+JZ4SMyuXn+Zg0RrBu8FQsXHpEAT18eOFoXTQdj
         g41azKjr7xHu4PDxrexTcpTsg9+RNCd0YuFsDO8c5aT3eNUX0X5D9bfHZdlRyI7US/
         tkK8KkQqPBNfzV+NwEYj6Vr/zYttjbmiWvdhi8fHPiyHx06yycXs0FJYythYkO+5nh
         LGeZ8/log3etpdmpBOJ83/S1sfQ3M3wFeE4Ra1AypSDmdHnYlR9NxDKs1QM7rK+hwV
         rq2HO+rVMz0RMJ+KUi0pEmz1dzMgoTATziWKmxBQvUK3rBI3g6a0f7anjX0zoD3wJb
         luU/xRJXPU8UQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <fc060e49-6ddf-0d18-f10d-958425876370@iogearbox.net>
References: <20220202110137.470850-1-atenart@kernel.org> <20220202110137.470850-2-atenart@kernel.org> <8585630f-f68c-ecea-a6b5-9a2ca8323566@iogearbox.net> <164380949615.380114.13546587453907068231@kwain> <fc060e49-6ddf-0d18-f10d-958425876370@iogearbox.net>
Subject: Re: [PATCH net 1/2] net: do not keep the dst cache when uncloning an skb dst and its metadata
To:     Daniel Borkmann <daniel@iogearbox.net>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, vladbu@nvidia.com, pabeni@redhat.com,
        pshelar@ovn.org, wenxu@ucloud.cn
From:   Antoine Tenart <atenart@kernel.org>
Message-ID: <164399157371.4980.14890218612337167330@kwain>
Date:   Fri, 04 Feb 2022 17:19:33 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Daniel Borkmann (2022-02-04 13:33:20)
> On 2/2/22 2:44 PM, Antoine Tenart wrote:
> > Quoting Daniel Borkmann (2022-02-02 13:13:30)
> >> On 2/2/22 12:01 PM, Antoine Tenart wrote:
> >>> When uncloning an skb dst and its associated metadata a new dst+metad=
ata
> >>> is allocated and the tunnel information from the old metadata is copi=
ed
> >>> over there.
> >>>
> >>> The issue is the tunnel metadata has references to cached dst, which =
are
> >>> copied along the way. When a dst+metadata refcount drops to 0 the
> >>> metadata is freed including the cached dst entries. As they are also
> >>> referenced in the initial dst+metadata, this ends up in UaFs.
> >>>
> >>> In practice the above did not happen because of another issue, the
> >>> dst+metadata was never freed because its refcount never dropped to 0
> >>> (this will be fixed in a subsequent patch).
> >>>
> >>> Fix this by initializing the dst cache after copying the tunnel
> >>> information from the old metadata to also unshare the dst cache.
> >>>
> >>> Fixes: d71785ffc7e7 ("net: add dst_cache to ovs vxlan lwtunnel")
> >>> Cc: Paolo Abeni <pabeni@redhat.com>
> >>> Reported-by: Vlad Buslov <vladbu@nvidia.com>
> >>> Tested-by: Vlad Buslov <vladbu@nvidia.com>
> >>> Signed-off-by: Antoine Tenart <atenart@kernel.org>
> >>> ---
> >>>    include/net/dst_metadata.h | 13 ++++++++++++-
> >>>    1 file changed, 12 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/include/net/dst_metadata.h b/include/net/dst_metadata.h
> >>> index 14efa0ded75d..c8f8b7b56bba 100644
> >>> --- a/include/net/dst_metadata.h
> >>> +++ b/include/net/dst_metadata.h
> >>> @@ -110,8 +110,8 @@ static inline struct metadata_dst *tun_rx_dst(int=
 md_size)
> >>>    static inline struct metadata_dst *tun_dst_unclone(struct sk_buff =
*skb)
> >>>    {
> >>>        struct metadata_dst *md_dst =3D skb_metadata_dst(skb);
> >>> -     int md_size;
> >>>        struct metadata_dst *new_md;
> >>> +     int md_size, ret;
> >>>   =20
> >>>        if (!md_dst || md_dst->type !=3D METADATA_IP_TUNNEL)
> >>>                return ERR_PTR(-EINVAL);
> >>> @@ -123,6 +123,17 @@ static inline struct metadata_dst *tun_dst_unclo=
ne(struct sk_buff *skb)
> >>>   =20
> >>>        memcpy(&new_md->u.tun_info, &md_dst->u.tun_info,
> >>>               sizeof(struct ip_tunnel_info) + md_size);
> >>> +#ifdef CONFIG_DST_CACHE
> >>> +     ret =3D dst_cache_init(&new_md->u.tun_info.dst_cache, GFP_ATOMI=
C);
> >>> +     if (ret) {
> >>> +             /* We can't call metadata_dst_free directly as the stil=
l shared
> >>> +              * dst cache would be released.
> >>> +              */
> >>> +             kfree(new_md);
> >>> +             return ERR_PTR(ret);
> >>> +     }
> >>> +#endif
> >>
> >> Could you elaborate (e.g. also in commit message) how this interacts
> >> or whether it is needed for TUNNEL_NOCACHE users? (Among others,
> >> latter is used by BPF, for example.)
> >=20
> > My understanding is that TUNNEL_NOCACHE is used to decide whether or not
> > to use a dst cache, that might or might not come from the tunnel info
> > attached to an skb. The dst cache being allocated in a tunnel info is
> > orthogonal to the use of TUNNEL_NOCACHE. While looking around I actually
> > found a code path explicitly setting both, in nft_tunnel_obj_init (that
> > might need to be investigated though but it is another topic).
>=20
> Good point, this is coming from 3e511d5652ce ("netfilter: nft_tunnel: Add=
 dst_cache
> support") and was added only after af308b94a2a4 ("netfilter: nf_tables: a=
dd tunnel
> support") which initially indicated TUNNEL_NOCACHE. This is indeed contra=
dictory.
> wenxu (+Cc), ptal.
>=20
> > It doesn't look like initializing the dst cache would break
> > TUNNEL_NOCACHE users as ip_tunnel_dst_cache_usable would return false
> > anyway. Having said that, we probably want to unshare the dst cache only
> > if there is one already, checking for
> > 'md_dst->u.tun_info.dst_cache.cache !=3D NULL' first.
>=20
> Meaning, if that is the case, we wouldn't require the dst_cache_init()
> and thus extra alloc, right? Would make sense afaics.

Meaning:

          memcpy(&new_md->u.tun_info, &md_dst->u.tun_info,
                 sizeof(struct ip_tunnel_info) + md_size);
  +#ifdef CONFIG_DST_CACHE
  +       if (new_md->u.tun_info.dst_cache.cache) {
  +               int ret =3D dst_cache_init(&new_md->u.tun_info.dst_cache,
  +                                        GFP_ATOMIC);
  +               if (ret) {
  +                       metadata_dst_free(new_md);
  +                       return ERR_PTR(ret);
  +               }
  +       }
  +#endif

So that the cache is unshared only if there was one in the first place.
If there was no cache to unshare, we can save the extra alloc.

> db3c6139e6ea ("bpf, vxlan, geneve, gre: fix usage of dst_cache on
> xmit") had some details related to BPF use.

With the above commit if TUNNEL_NOCACHE is set the tunnel cache
shouldn't be used, regardless of it being allocated. I guess with that
and the above, we should be good.

Thanks!
Antoine

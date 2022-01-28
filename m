Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD9149FE97
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 18:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350404AbiA1RBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 12:01:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245706AbiA1RBk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 12:01:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0513C061714
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 09:01:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8BF81B8265C
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 17:01:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C37FC340E0;
        Fri, 28 Jan 2022 17:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643389297;
        bh=A71JwlR0bUQxJFqtLuwQwV71pgAcuWDYp46jrkANon0=;
        h=In-Reply-To:References:Subject:To:Cc:From:Date:From;
        b=EOuEMcdFSXgCqT9ecaL5u6JSqt+EnJPhcqNaBhStnZR3UrefzGT823NwU89MOELIS
         fxV/m0UyECgf/GBuhAvBUjhPwMopatpAZJiSgzk8kbd0YZwes0GYHI880cZzSd3Q/2
         nyaY/EknsVYAbl25MsipYKZiJSb6IYH3QM52wJIEtafiC11a1LV7SkWn0aP6sxPCDP
         3O96L5mom4Vz+6k+LqGHWxX0A93k/WVtyz923xOWwiOssFInVBrwUKi7ilIBuczr1D
         kdcIJfVb0OO5Bu1Kn9Dfa6ekDDOc35qjnjWuWLmn4FRSZBXEYvliYYUnHgLdXDDEXK
         VXNcS6zlSAASA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <ygnhee52lg2d.fsf@nvidia.com>
References: <20210325153533.770125-1-atenart@kernel.org> <20210325153533.770125-2-atenart@kernel.org> <ygnhh79yluw2.fsf@nvidia.com> <164267447125.4497.8151505359440130213@kwain> <ygnhee52lg2d.fsf@nvidia.com>
Subject: Re: [PATCH net 1/2] vxlan: do not modify the shared tunnel info when PMTU triggers an ICMP reply
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, echaudro@redhat.com,
        sbrivio@redhat.com, netdev@vger.kernel.org, pshelar@ovn.org
From:   Antoine Tenart <atenart@kernel.org>
Message-ID: <164338929382.4461.13062562289533632448@kwain>
Date:   Fri, 28 Jan 2022 18:01:33 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vlad,

Quoting Vlad Buslov (2022-01-20 13:58:18)
> On Thu 20 Jan 2022 at 12:27, Antoine Tenart <atenart@kernel.org> wrote:
> > Quoting Vlad Buslov (2022-01-20 08:38:05)
> >>=20
> >> We have been getting memleaks in one of our tests that point to this
> >> code (test deletes vxlan device while running traffic redirected by OvS
> >> TC at the same time):
> >>=20
> >> unreferenced object 0xffff8882d0114200 (size 256):
> >>     [<0000000097659d47>] metadata_dst_alloc+0x1f/0x470
> >>     [<000000007571c30f>] tun_dst_unclone+0xee/0x360 [vxlan]
> >>     [<00000000d2dcfd00>] vxlan_xmit_one+0x131d/0x2a00 [vxlan]

[...]

> >> Looking at the code the potential issue seems to be that
> >> tun_dst_unclone() creates new metadata_dst instance with refcount=3D=
=3D1,
> >> increments the refcount with dst_hold() to value 2, then returns it.
> >> This seems to imply that caller is expected to release one of the
> >> references (second one if for skb), but none of the callers (including
> >> original dev_fill_metadata_dst()) do that, so I guess I'm
> >> misunderstanding something here.
> >>=20
> >> Any tips or suggestions?
> >
> > I'd say there is no need to increase the dst refcount here after calling
> > metadata_dst_alloc, as the metadata is local to the skb and the dst
> > refcount was already initialized to 1. This might be an issue with
> > commit fc4099f17240 ("openvswitch: Fix egress tunnel info."); I CCed
> > Pravin, he might recall if there was a reason to increase the refcount.
>=20
> I tried to remove the dst_hold(), but that caused underflows[0], so I
> guess the current reference counting is required at least for some
> use-cases.
>=20
> [0]:
>=20
> [  118.803011] dst_release: dst:000000001fc13e61 refcnt:-2               =
             =20

[...]

I finally had some time to look at this. Does the diff below fix your
issue?

diff --git a/include/net/dst_metadata.h b/include/net/dst_metadata.h
index 14efa0ded75d..90a7a4daea9c 100644
--- a/include/net/dst_metadata.h
+++ b/include/net/dst_metadata.h
@@ -110,8 +110,8 @@ static inline struct metadata_dst *tun_rx_dst(int md_si=
ze)
 static inline struct metadata_dst *tun_dst_unclone(struct sk_buff *skb)
 {
        struct metadata_dst *md_dst =3D skb_metadata_dst(skb);
-       int md_size;
        struct metadata_dst *new_md;
+       int md_size, ret;
=20
        if (!md_dst || md_dst->type !=3D METADATA_IP_TUNNEL)
                return ERR_PTR(-EINVAL);
@@ -123,8 +123,15 @@ static inline struct metadata_dst *tun_dst_unclone(str=
uct sk_buff *skb)
=20
        memcpy(&new_md->u.tun_info, &md_dst->u.tun_info,
               sizeof(struct ip_tunnel_info) + md_size);
+#ifdef CONFIG_DST_CACHE
+       ret =3D dst_cache_init(&new_md->u.tun_info.dst_cache, GFP_ATOMIC);
+       if (ret) {
+               metadata_dst_free(new_md);
+               return ERR_PTR(ret);
+       }
+#endif
+
        skb_dst_drop(skb);
-       dst_hold(&new_md->dst);
        skb_dst_set(skb, &new_md->dst);
        return new_md;
 }

Antoine

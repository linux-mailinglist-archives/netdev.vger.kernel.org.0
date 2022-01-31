Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D25174A480E
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 14:26:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378753AbiAaN0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 08:26:53 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53714 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348839AbiAaN0v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 08:26:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FAE361265
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 13:26:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07CABC340E8;
        Mon, 31 Jan 2022 13:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643635610;
        bh=nvEQWZFWzrI8gPCU/2Pwv3uOpwyscgKKyDukE/ORsgs=;
        h=In-Reply-To:References:From:To:Cc:Subject:Date:From;
        b=faX3Yxji8ndZk1Q2j0wXT40+0nN97AzKrYIXJf01F3tWAu8IV7/D54zeTK0MdgvmH
         nqUvlrLROI9OM3aBEI7/AklI1Ak6LfBxqfALa5boTObxgA9A/Sp13eCqfNe1zdqqVh
         bUcd32OlO+/uSflsyl/fv1/hh0nuW3LHxP9DU+az9HsbbnVkNVO9krVd/DmgxSUIgQ
         62+zbgpbAjD3qpJ0S/kUpXshSPEwlihm6msnOyI5TrH/J9ZJSncST+zM4PtxycMcAL
         e5g3oJ+qETHsDf3e4obMDbThZq9RiF8em5Bc+7CcojiPhdOEmArZAI0lTzLHrKxRGX
         YMx9gD91eILgg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <ygnhsft4p2mg.fsf@nvidia.com>
References: <20210325153533.770125-1-atenart@kernel.org> <20210325153533.770125-2-atenart@kernel.org> <ygnhh79yluw2.fsf@nvidia.com> <164267447125.4497.8151505359440130213@kwain> <ygnhee52lg2d.fsf@nvidia.com> <164338929382.4461.13062562289533632448@kwain> <ygnhsft4p2mg.fsf@nvidia.com>
From:   Antoine Tenart <atenart@kernel.org>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, echaudro@redhat.com,
        sbrivio@redhat.com, netdev@vger.kernel.org, pshelar@ovn.org
Subject: Re: [PATCH net 1/2] vxlan: do not modify the shared tunnel info when PMTU triggers an ICMP reply
Message-ID: <164363560725.4133.7633393991691247425@kwain>
Date:   Mon, 31 Jan 2022 14:26:47 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Vlad Buslov (2022-01-31 12:26:47)
> On Fri 28 Jan 2022 at 19:01, Antoine Tenart <atenart@kernel.org> wrote:
> >
> > I finally had some time to look at this. Does the diff below fix your
> > issue?
>=20
> Yes, with the patch applied I'm no longer able to reproduce memory leak.
> Thanks for fixing this!

Thanks for testing. I'll send a formal patch, can I add your Tested-by?

Also, do you know how to trigger the following code path in OVS
https://elixir.bootlin.com/linux/latest/source/net/openvswitch/actions.c#L9=
44
? Would be good (not required) to test it, to ensure the fix doesn't
break it.

Thanks,
Antoine

> > diff --git a/include/net/dst_metadata.h b/include/net/dst_metadata.h
> > index 14efa0ded75d..90a7a4daea9c 100644
> > --- a/include/net/dst_metadata.h
> > +++ b/include/net/dst_metadata.h
> > @@ -110,8 +110,8 @@ static inline struct metadata_dst *tun_rx_dst(int m=
d_size)
> >  static inline struct metadata_dst *tun_dst_unclone(struct sk_buff *skb)
> >  {
> >         struct metadata_dst *md_dst =3D skb_metadata_dst(skb);
> > -       int md_size;
> >         struct metadata_dst *new_md;
> > +       int md_size, ret;
> > =20
> >         if (!md_dst || md_dst->type !=3D METADATA_IP_TUNNEL)
> >                 return ERR_PTR(-EINVAL);
> > @@ -123,8 +123,15 @@ static inline struct metadata_dst *tun_dst_unclone=
(struct sk_buff *skb)
> > =20
> >         memcpy(&new_md->u.tun_info, &md_dst->u.tun_info,
> >                sizeof(struct ip_tunnel_info) + md_size);
> > +#ifdef CONFIG_DST_CACHE
> > +       ret =3D dst_cache_init(&new_md->u.tun_info.dst_cache, GFP_ATOMI=
C);
> > +       if (ret) {
> > +               metadata_dst_free(new_md);
> > +               return ERR_PTR(ret);
> > +       }
> > +#endif
> > +
> >         skb_dst_drop(skb);
> > -       dst_hold(&new_md->dst);
> >         skb_dst_set(skb, &new_md->dst);
> >         return new_md;
> >  }

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10FC049C8DD
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 12:42:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240840AbiAZLmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 06:42:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240836AbiAZLmU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 06:42:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BEB2C06161C;
        Wed, 26 Jan 2022 03:42:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CC14618D1;
        Wed, 26 Jan 2022 11:42:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10C6DC340E3;
        Wed, 26 Jan 2022 11:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643197339;
        bh=LqJHs8a8li/256j1Xfz1YCxmaaeabo+fkmMvyqOS0K4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SeIy7IoMZxOCv99ELjPRyeJFJ0GiO+xSt0Ea1lxvoiO2kX5OC6BQDsBh4s2fjOKT6
         Jgoeg8igpqWF62l8muoZ81a/gRXQlD1hNcPlY751Srvlk4qzAsjoB+EDYb9Xx/CGyQ
         UeiosPCbGkdKJqPDON+XxSBb3vTVZK07wEL66ROkbtf69t39fpKOQF8VJt4D6+OVCP
         Kp9SPObGSNDEj6e8BeB86N1/vLe8iFZrPu3LPx4W/nA5wADDq5ICqWR2OM3eFHv4Rs
         +yppPeu8Einin1Jq+iyBipUt+T7hcNwaDgijlhP+4mDGGKsh080Sr0WMBBMpFg6VXx
         oT3JEF8XBttkg==
Date:   Wed, 26 Jan 2022 12:42:15 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, dsahern@kernel.org,
        komachi.yoshiki@gmail.com, brouer@redhat.com, memxor@gmail.com,
        andrii.nakryiko@gmail.com
Subject: Re: [RFC bpf-next 1/2] net: bridge: add unstable
 br_fdb_find_port_from_ifindex helper
Message-ID: <YfEzl0wL+51wa6z7@lore-desk>
References: <cover.1643044381.git.lorenzo@kernel.org>
 <720907692575488526f06edc2cf5c8f783777d4f.1643044381.git.lorenzo@kernel.org>
 <878rv558fy.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="NAWMkjDihtnCxxji"
Content-Disposition: inline
In-Reply-To: <878rv558fy.fsf@toke.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--NAWMkjDihtnCxxji
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> [ snip to focus on the API ]
>=20
> > +int br_fdb_find_port_from_ifindex(struct xdp_md *xdp_ctx,
> > +				  struct bpf_fdb_lookup *opt,
> > +				  u32 opt__sz)
> > +{
> > +	struct xdp_buff *ctx =3D (struct xdp_buff *)xdp_ctx;
> > +	struct net_bridge_port *port;
> > +	struct net_device *dev;
> > +	int ret =3D -ENODEV;
> > +
> > +	BUILD_BUG_ON(sizeof(struct bpf_fdb_lookup) !=3D NF_BPF_FDB_OPTS_SZ);
> > +	if (!opt || opt__sz !=3D sizeof(struct bpf_fdb_lookup))
> > +		return -ENODEV;
>=20
> Why is the BUILD_BUG_ON needed? Or why is the NF_BPF_FDB_OPTS_SZ
> constant even needed?

I added it to be symmetric with respect to ct counterpart

>=20
> > +	rcu_read_lock();
>=20
> This is not needed when the function is only being called from XDP...

don't we need it since we do not hold the rtnl here?

>=20
> > +
> > +	dev =3D dev_get_by_index_rcu(dev_net(ctx->rxq->dev), opt->ifindex);
> > +	if (!dev)
> > +		goto out;
> > +
> > +	if (unlikely(!netif_is_bridge_port(dev)))
> > +		goto out;
> > +
> > +	port =3D br_port_get_check_rcu(dev);
> > +	if (unlikely(!port || !port->br))
> > +		goto out;
> > +
> > +	dev =3D __br_fdb_find_port(port->br->dev, opt->addr, opt->vid, true);
> > +	if (dev)
> > +		ret =3D dev->ifindex;
> > +out:
> > +	rcu_read_unlock();
> > +
> > +	return ret;
> > +}
> > +
> >  struct net_bridge_fdb_entry *br_fdb_find_rcu(struct net_bridge *br,
> >  					     const unsigned char *addr,
> >  					     __u16 vid)
> > diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> > index 2661dda1a92b..64d4f1727da2 100644
> > --- a/net/bridge/br_private.h
> > +++ b/net/bridge/br_private.h
> > @@ -18,6 +18,7 @@
> >  #include <linux/if_vlan.h>
> >  #include <linux/rhashtable.h>
> >  #include <linux/refcount.h>
> > +#include <linux/bpf.h>
> > =20
> >  #define BR_HASH_BITS 8
> >  #define BR_HASH_SIZE (1 << BR_HASH_BITS)
> > @@ -2094,4 +2095,15 @@ void br_do_proxy_suppress_arp(struct sk_buff *sk=
b, struct net_bridge *br,
> >  void br_do_suppress_nd(struct sk_buff *skb, struct net_bridge *br,
> >  		       u16 vid, struct net_bridge_port *p, struct nd_msg *msg);
> >  struct nd_msg *br_is_nd_neigh_msg(struct sk_buff *skb, struct nd_msg *=
m);
> > +
> > +#define NF_BPF_FDB_OPTS_SZ	12
> > +struct bpf_fdb_lookup {
> > +	u8	addr[ETH_ALEN]; /* ETH_ALEN */
> > +	u16	vid;
> > +	u32	ifindex;
> > +};
>=20
> It seems like addr and ifindex should always be required, right? So why
> not make them regular function args? That way the ptr to eth addr could
> be a ptr directly to the packet header (saving a memcpy), and the common
> case(?) could just pass a NULL opts struct?

ack, right. I agree.

>=20
> > +int br_fdb_find_port_from_ifindex(struct xdp_md *xdp_ctx,
> > +				  struct bpf_fdb_lookup *opt,
> > +				  u32 opt__sz);
>=20
> It should probably be documented that the return value is an ifindex as
> well; I guess one of the drawbacks of kfunc's relative to regular
> helpers is that there is no convention for how to document their usage -
> maybe we should fix that before we get too many of them? :)

kfunc is probably too new :)

Regards,
Lorenzo

>=20
> -Toke
>=20

--NAWMkjDihtnCxxji
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYfEzlwAKCRA6cBh0uS2t
rNEUAQDfv2ulJGR7fq6AxrFOPC/3t7QKbEUBJozNXBypP6TIDQEA64FSX8ZWuLH7
iCtHro3CxlcVibjiiqKYKd019/k95ws=
=uH2b
-----END PGP SIGNATURE-----

--NAWMkjDihtnCxxji--

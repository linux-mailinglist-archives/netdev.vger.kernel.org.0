Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF15F4660B
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 19:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbfFNRq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 13:46:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58448 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726082AbfFNRq6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 13:46:58 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 91EB430832E6;
        Fri, 14 Jun 2019 17:46:47 +0000 (UTC)
Received: from linux-ws.nc.xsintricity.com (ovpn-112-63.rdu2.redhat.com [10.10.112.63])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6DD31608A4;
        Fri, 14 Jun 2019 17:46:46 +0000 (UTC)
Message-ID: <f91615fe4a883ccb6490aec11ef4ae64cdd9e494.camel@redhat.com>
Subject: Re: [PATCH 2/2] ipoib: show VF broadcast address
From:   Doug Ledford <dledford@redhat.com>
To:     Denis Kirjanov <kda@linux-powerpc.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        mkubecek@suse.cz
Date:   Fri, 14 Jun 2019 13:46:43 -0400
In-Reply-To: <20190614133249.18308-2-dkirjanov@suse.com>
References: <20190614133249.18308-1-dkirjanov@suse.com>
         <20190614133249.18308-2-dkirjanov@suse.com>
Organization: Red Hat, Inc.
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-2TqKf2wcaxprFekRzaj+"
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Fri, 14 Jun 2019 17:46:57 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-2TqKf2wcaxprFekRzaj+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2019-06-14 at 15:32 +0200, Denis Kirjanov wrote:
> in IPoIB case we can't see a VF broadcast address for but
> can see for PF
>=20
> Before:
> 11: ib1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 2044 qdisc pfifo_fast
> state UP mode DEFAULT group default qlen 256
>     link/infiniband
> 80:00:00:66:fe:80:00:00:00:00:00:00:24:8a:07:03:00:a4:3e:7c brd
> 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
>     vf 0 MAC 14:80:00:00:66:fe, spoof checking off, link-state
> disable,
> trust off, query_rss off
> ...

The above Before: output should be used as the After: portion of the
previous commit message.  The previos commit does not fully resolve the
problem, but yet the commit message acts as though it does.

>=20
> After:
> 11: ib1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 2044 qdisc pfifo_fast
> state UP mode DEFAULT group default qlen 256
>     link/infiniband
> 80:00:00:66:fe:80:00:00:00:00:00:00:24:8a:07:03:00:a4:3e:7c brd
> 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
>     vf 0     link/infiniband
> 80:00:00:66:fe:80:00:00:00:00:00:00:24:8a:07:03:00:a4:3e:7c brd
> 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff, spoof
> checking off, link-state disable, trust off, query_rss off

Ok, I get why the After: should have a valid broadcast.  What I don't
get is why the Before: shows a MAC and the After: shows a
link/infiniband?  What change in this patch is responsible for that
difference?  I honestly expect, by reading this patch, that you would
have a MAC and Broadcast that look like Ethernet, not that the full
issue would be resolved.

> v1->v2: add the IFLA_VF_BROADCAST constant
> v2->v3: put IFLA_VF_BROADCAST at the end
> to avoid KABI breakage and set NLA_REJECT
> dev_setlink
>=20
> Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
> ---
>  include/uapi/linux/if_link.h | 5 +++++
>  net/core/rtnetlink.c         | 5 +++++
>  2 files changed, 10 insertions(+)
>=20
> diff --git a/include/uapi/linux/if_link.h
> b/include/uapi/linux/if_link.h
> index 5b225ff63b48..6f75bda2c2d7 100644
> --- a/include/uapi/linux/if_link.h
> +++ b/include/uapi/linux/if_link.h
> @@ -694,6 +694,7 @@ enum {
>  	IFLA_VF_IB_NODE_GUID,	/* VF Infiniband node GUID */
>  	IFLA_VF_IB_PORT_GUID,	/* VF Infiniband port GUID */
>  	IFLA_VF_VLAN_LIST,	/* nested list of vlans, option for
> QinQ */
> +	IFLA_VF_BROADCAST,	/* VF broadcast */
>  	__IFLA_VF_MAX,
>  };
> =20
> @@ -704,6 +705,10 @@ struct ifla_vf_mac {
>  	__u8 mac[32]; /* MAX_ADDR_LEN */
>  };
> =20
> +struct ifla_vf_broadcast {
> +	__u8 broadcast[32];
> +};
> +
>  struct ifla_vf_vlan {
>  	__u32 vf;
>  	__u32 vlan; /* 0 - 4095, 0 disables VLAN filter */
> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> index cec60583931f..8ac81630ab5c 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -908,6 +908,7 @@ static inline int rtnl_vfinfo_size(const struct
> net_device *dev,
>  		size +=3D num_vfs *
>  			(nla_total_size(0) +
>  			 nla_total_size(sizeof(struct ifla_vf_mac)) +
> +			 nla_total_size(sizeof(struct
> ifla_vf_broadcast)) +
>  			 nla_total_size(sizeof(struct ifla_vf_vlan)) +
>  			 nla_total_size(0) + /* nest IFLA_VF_VLAN_LIST
> */
>  			 nla_total_size(MAX_VLAN_LIST_LEN *
> @@ -1197,6 +1198,7 @@ static noinline_for_stack int
> rtnl_fill_vfinfo(struct sk_buff *skb,
>  	struct ifla_vf_vlan vf_vlan;
>  	struct ifla_vf_rate vf_rate;
>  	struct ifla_vf_mac vf_mac;
> +	struct ifla_vf_broadcast vf_broadcast;
>  	struct ifla_vf_info ivi;
> =20
>  	memset(&ivi, 0, sizeof(ivi));
> @@ -1231,6 +1233,7 @@ static noinline_for_stack int
> rtnl_fill_vfinfo(struct sk_buff *skb,
>  		vf_trust.vf =3D ivi.vf;
> =20
>  	memcpy(vf_mac.mac, ivi.mac, sizeof(ivi.mac));
> +	memcpy(vf_broadcast.broadcast, dev->broadcast, dev->addr_len);
>  	vf_vlan.vlan =3D ivi.vlan;
>  	vf_vlan.qos =3D ivi.qos;
>  	vf_vlan_info.vlan =3D ivi.vlan;
> @@ -1247,6 +1250,7 @@ static noinline_for_stack int
> rtnl_fill_vfinfo(struct sk_buff *skb,
>  	if (!vf)
>  		goto nla_put_vfinfo_failure;
>  	if (nla_put(skb, IFLA_VF_MAC, sizeof(vf_mac), &vf_mac) ||
> +	    nla_put(skb, IFLA_VF_BROADCAST, sizeof(vf_broadcast),
> &vf_broadcast) ||
>  	    nla_put(skb, IFLA_VF_VLAN, sizeof(vf_vlan), &vf_vlan) ||
>  	    nla_put(skb, IFLA_VF_RATE, sizeof(vf_rate),
>  		    &vf_rate) ||
> @@ -1753,6 +1757,7 @@ static const struct nla_policy
> ifla_info_policy[IFLA_INFO_MAX+1] =3D {
> =20
>  static const struct nla_policy ifla_vf_policy[IFLA_VF_MAX+1] =3D {
>  	[IFLA_VF_MAC]		=3D { .len =3D sizeof(struct ifla_vf_mac)
> },
> +	[IFLA_VF_BROADCAST]	=3D { .type =3D NLA_REJECT },
>  	[IFLA_VF_VLAN]		=3D { .len =3D sizeof(struct
> ifla_vf_vlan) },
>  	[IFLA_VF_VLAN_LIST]     =3D { .type =3D NLA_NESTED },
>  	[IFLA_VF_TX_RATE]	=3D { .len =3D sizeof(struct ifla_vf_tx_rate) },

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57
2FDD

--=-2TqKf2wcaxprFekRzaj+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAl0D3YMACgkQuCajMw5X
L90EfQ/+JJh0Hz6r/mLXCvqdNd8wzfuGlJvbgkB+MVsUO+OtEK1sYsnm1SYeib9D
DKpZub957TzmlKwPvLSAGyxt/7AW2P6TgPigDz2ljudd7TrdaLTPow0vTe/qMuuS
WYkni0SfWe+iuKvuKuKEoQ96NoVEp/YA0YMvmvklcqN+sN2gkkjNMF07uuifSTiK
e5D6Y1ju7E6cuxkBPZtY1nyNTIyo2uuAg0Q8Q9Ra+mYXSyJfsGh9AeagpXcYDZFr
Laf/W1s9dwfynjccSouxPW3dclmfQPT5HLIsrLuDKUfb/SrVFg8qlTVDMDgpshPC
xXVho7hUdluxOb2PA6Biu/Axg/U3ufWQ6ocZivpIrPzCNCtCFK1zEH1k7Z34p4mR
FFxFZbpCEZiZ80nQHWfnefokO8xQ1g0+bc/Jh9FvriSWnxT/kZQXoo0XpIZqWCqD
iWEQ5YQE7rKibvM2xvDBm/9cIQuZEJ+/kgKUfJt/DmQelPn+tFj+D+FmOjlS16O2
+g/a/He6hyoKrSzYpZfXSPTvNHNTM51GD0ea9m9ah5nfkSf93teosRkZdljfyBsa
2t2yNxi4OOuS8nz9RKqyktBpUOhQmo1P//UTC8KDY4arojQhdd+Sv2DYOB4aSuha
eNgwqCGTh47fo5UkMcnAsPMTiFQQkBAGIBZpuqubDnzdsLDfdj8=
=uEhD
-----END PGP SIGNATURE-----

--=-2TqKf2wcaxprFekRzaj+--


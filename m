Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACCDF360F3A
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 17:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233369AbhDOPqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 11:46:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:35334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231137AbhDOPqG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 11:46:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 719656115B;
        Thu, 15 Apr 2021 15:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618501542;
        bh=5QQsnYIjpMZ3jYk9CeYd19LBwUZImwRVtvV+ycyJ3LA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ES/LGW1HuI+5JKHLi24K5zbuil/09aJ8i0yq8tuW/nZ3EUa+BZXi4DjRQEkkWH5rk
         RzFBEmH3Ce2K6YPFV1iJYJCkXPOk7wQFzUzarGUW88TFev2tr7PTGXt8hBCpOwtk0B
         CIqL1b/oP1qovEKtf5Esb6if8BOalLISdO0VU5WqGxelLkk34GWkcLr5dU8iBw/teJ
         kSZRUaKy0RJNEpAJPHqwCQ895bcOzMHKSrHPtpCaxylsWp9tToiW82NFMzda/sTl92
         +GDlmTV+KjRzN2a9y/MkR7gxOpPhV+2y+oZWc9T/LYHDDd0Cbt4fRvZli4I8xyQOsr
         2/cAfs4u3HUUg==
Date:   Thu, 15 Apr 2021 08:45:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        mkubecek@suse.cz, idosch@nvidia.com,
        Ariel Almog <ariela@nvidia.com>
Subject: Re: [RFC net-next 0/6] ethtool: add uAPI for reading standard stats
Message-ID: <20210415084541.5ce6018f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <4425ee5839ac86270542ffa3d40cda67dc5068e1.camel@kernel.org>
References: <20210414202325.2225774-1-kuba@kernel.org>
        <4425ee5839ac86270542ffa3d40cda67dc5068e1.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 14 Apr 2021 22:51:39 -0700 Saeed Mahameed wrote:
> On Wed, 2021-04-14 at 13:23 -0700, Jakub Kicinski wrote:
> > This series adds a new ethtool command to read well defined
> > device statistics. There is nothing clever here, just a netlink
> > API for dumping statistics defined by standards and RFCs which
> > today end up in ethtool -S under infinite variations of names.
> >=20
> > This series adds basic IEEE stats (for PHY, MAC, Ctrl frames)
> > and RMON stats. AFAICT other RFCs only duplicate the IEEE
> > stats.
> >=20
> > This series does _not_ add a netlink API to read driver-defined
> > stats. There seems to be little to gain from moving that part
> > to netlink.
> >=20
> > The netlink message format is very simple, and aims to allow
> > adding stats and groups with no changes to user tooling (which
> > IIUC is expected for ethtool). Stats are dumped directly
> > into netlink with netlink attributes used as IDs. This is
> > perhaps where the biggest question mark is. We could instead
> > pack the stats into individual wrappers:
> >=20
> > =C2=A0[grp]
> > =C2=A0=C2=A0 [stat] // nest
> > =C2=A0=C2=A0=C2=A0=C2=A0 [id]=C2=A0=C2=A0=C2=A0 // u32
> > =C2=A0=C2=A0=C2=A0=C2=A0 [value] // u64
> > =C2=A0=C2=A0 [stat] // nest
> > =C2=A0=C2=A0=C2=A0=C2=A0 [id]=C2=A0=C2=A0=C2=A0 // u32
> > =C2=A0=C2=A0=C2=A0=C2=A0 [value] // u64
> >=20
> > which would increase the message size 2x but allow
> > to ID the stats from 0, saving strset space as well as =20
>=20
> don't you need to translate such ids to strs in userspace ?=20
> I am not fond of upgrading userspace every time we add new stat..=20

No, no, the question was only whether we keep stat ids in the same
attribute space as other group attributes (like string set ID) or
whether they are nested somewhere deeper and have their own ID space.

I went ahead and nested them yesterday. I had to engage in a little=20
bit of black magic for pad, but it feels more right to nest..

static int stat_put(struct sk_buff *skb, u16 attrtype, u64 val)
{
	struct nlattr *nest;
	int ret;

	if (val =3D=3D ETHTOOL_STAT_NOT_SET)
		return 0;

	/* We want to start stats attr types from 0, so we don't have a type
	 * for pad inside ETHTOOL_A_STATS_GRP_STAT. Pad things on the outside
	 * of ETHTOOL_A_STATS_GRP_STAT. Since we're one nest away from the
	 * actual attr we're 4B off - nla_need_padding_for_64bit() & co.
	 * can't be used.
	 */
#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
        if (!IS_ALIGNED((unsigned long)skb_tail_pointer(skb), 8))
                if (!nla_reserve(skb, ETHTOOL_A_STATS_GRP_PAD, 0))
			return -EMSGSIZE;
#endif

	nest =3D nla_nest_start(skb, ETHTOOL_A_STATS_GRP_STAT);
	if (!nest)
		return -EMSGSIZE;

	ret =3D nla_put_u64_64bit(skb, attrtype, val, -1 /* not used */);
	if (ret) {
		nla_nest_cancel(skb, nest);
		return ret;
	}

	nla_nest_end(skb, nest);
	return 0;
}

> Just throwing crazy ideas.. BTF might be a useful tool here! :))=20
>=20
> > allow seamless adding of legacy stats to this API =20
> which legacy stats ?=20

The ones from get_ethtool_stats.

> > (which are IDed from 0).
> >=20
> > On user space side we can re-use -S, and make it dump
> > standard stats if --groups are defined.
> >=20
> > $ ethtool -S eth0 --groups eth-phy eth-mac rmon eth-ctrl =20
>=20
> Deja-vu, I honestly remember someone in mlnx suggsting this exact
> command a couple of years ago.. :)=20

Hah! I hope it wasn't shot down as a bad idea :)

Thanks a lot for the reviews!

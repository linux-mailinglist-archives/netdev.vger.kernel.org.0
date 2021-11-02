Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4C13443528
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 19:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234864AbhKBSNF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 14:13:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:50118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232217AbhKBSNC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 14:13:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9640C60EBC;
        Tue,  2 Nov 2021 18:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635876627;
        bh=Tath62rT/aHeHTa18Rzb1CQbO+lzjo79oteEGhPTXa4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jW0we8qIs+0CS2bS1HTYc0TgDRsvM8tAorBOIQ/SFBcwjo05Dm4VGK+YrfMH/YSNv
         opMYujcrpqtu6h+a9osSbvROdp7wOT8bvCO3Ny0XJnGE3wWtnubqPj3yup6e+eSUos
         uIo12NdhutLKGiQqzPa8PPiyLH7ZuLWR6vyoLf9S35OX/46sxn4KsO7ibjpszsHnJb
         GTKZSSYUdh6Bq3dYX/LamSu52Dn/yNN7jM073LOuw3K0wRkPirbcdmIG4SMFGhOwOD
         AFYTTsYhd2xgO695HIsTXsKyt85bhooXUCBBbd63yzFsiK0rWqnYisC7cjv7Yksoar
         CHhOm/FdLjCFw==
Date:   Tue, 2 Nov 2021 11:10:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH net] ethtool: fix ethtool msg len calculation for pause
 stats
Message-ID: <20211102111023.6ed54026@kicinski-fedora-PC1C0HJN>
In-Reply-To: <502b2fdb44dfb579eaa00ca912b836eb8075e367.camel@nvidia.com>
References: <20211102042120.3595389-1-kuba@kernel.org>
        <502b2fdb44dfb579eaa00ca912b836eb8075e367.camel@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Nov 2021 16:08:52 +0000 Saeed Mahameed wrote:
> > diff --git a/net/ethtool/pause.c b/net/ethtool/pause.c
> > index 9009f412151e..c9171234130b 100644
> > --- a/net/ethtool/pause.c
> > +++ b/net/ethtool/pause.c
> > @@ -57,7 +57,7 @@ static int pause_reply_size(const struct
> > ethnl_req_info *req_base,
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (req_base->flags & E=
THTOOL_FLAG_STATS)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0n +=3D nla_total_size(0) +=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0/* _PAUSE_STATS */
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
nla_total_size_64bit(sizeof(u64)) *
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(ETHTOOL_A_PAUSE_STAT_MAX - 2);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(ETHTOOL_A_PAUSE_STAT_MAX - 1); =
=20
>=20
> Maybe for net-next we can improve readability here.
> Just by staring at these lines, you'd think that this should've been
> (ETHTOOL_A_PAUSE_STAT_MAX + 1), or even better, just
> (ETHTOOL_A_PAUSE_STAT_CNT) /* Count of only stats */
>=20
> maybe we need to separate stats from non-stats, or define
> ETHTOOL_A_PAUSE_STAT_CNT where it needs to be defined.

Fair point, something like this?

+++ b/include/uapi/linux/ethtool_netlink.h
@@ -411,10 +411,14 @@ enum {
        ETHTOOL_A_PAUSE_STAT_TX_FRAMES,
        ETHTOOL_A_PAUSE_STAT_RX_FRAMES,
=20
-       /* add new constants above here */
+       /* add new constants above here
+        * adjust ETHTOOL_PAUSE_STAT_CNT if adding non-stats!
+        */
        __ETHTOOL_A_PAUSE_STAT_CNT,
        ETHTOOL_A_PAUSE_STAT_MAX =3D (__ETHTOOL_A_PAUSE_STAT_CNT - 1)
 };
+#define ETHTOOL_PAUSE_STAT_CNT (__ETHTOOL_A_PAUSE_STAT_CNT -           \
+                                ETHTOOL_A_PAUSE_STAT_TX_FRAMES)
=20
 /* EEE */
=20


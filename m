Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77AC6422AA7
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 16:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236214AbhJEORC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 10:17:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:48814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235781AbhJEOQ4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 10:16:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D1AF6115B;
        Tue,  5 Oct 2021 14:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633443305;
        bh=I7XCFGAmyXivWz7d1EBNyLvBe+/ID7If4dnsGSTv3fU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CTXz7yEhcw5L8afieI4Lprps7Hj/MyvDyxzeE/k48YLH3jmq4j44t4icOlHt5zYyR
         ccOW3CzF4bKSDVWl5ovic4FZCkK5cC9TuGBClAKCXS1QSMKBaP2Mg40oT386unWOpS
         GGRbs0TaOPRhXCXLWqJcYgAUqi1Bb6AMOwt2kCuDHPCwc06hm/z3A67rs3YDG27qGR
         mvLOnWyvawrs252WNrM72wihsC+2o5Cf2YljKEbIIDnOaziCR+uPGBKuqXM+SHwvPj
         ec8ArAGbkvZalmO/i3JRlbKt7mLBKjH+cNmEC8F9ENafZDppDl7Dm31SjJyNmFKFD0
         +H1XQ49SxmB6w==
Date:   Tue, 5 Oct 2021 07:15:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, jacob.e.keller@intel.com,
        jiri@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 1/6] ethtool: Add ability to control
 transceiver modules' power mode
Message-ID: <20211005071504.43e08feb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YVv3UARMHU8HZTfz@shredder>
References: <20211003073219.1631064-1-idosch@idosch.org>
        <20211003073219.1631064-2-idosch@idosch.org>
        <20211004180135.55759be4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YVv3UARMHU8HZTfz@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 Oct 2021 09:57:20 +0300 Ido Schimmel wrote:
> > > +static int module_set_power_mode(struct net_device *dev, struct nlat=
tr **tb,
> > > +				 bool *p_mod, struct netlink_ext_ack *extack)
> > > +{
> > > +	struct ethtool_module_power_mode_params power =3D {};
> > > +	struct ethtool_module_power_mode_params power_new;
> > > +	const struct ethtool_ops *ops =3D dev->ethtool_ops;
> > > +	int ret;
> > > +
> > > +	if (!tb[ETHTOOL_A_MODULE_POWER_MODE_POLICY])
> > > +		return 0; =20
> >=20
> > Feels a little old school to allow set with no attrs, now that we=20
> > do strict validation on attrs across netlink.  What's the reason? =20
>=20
> The power mode policy is the first parameter that can be set via
> MODULE_SET, but in the future there can be more and it is valid for user
> space to only want to change a subset. In which case, we will skip over
> attributes that were not specified.

Ack, I guess catching the "no parameter specified" case may be more
effort than it's worth. Nothing is going to break if we don't do it.

> > > +	if (!ops->get_module_power_mode || !ops->set_module_power_mode) {
> > > +		NL_SET_ERR_MSG_ATTR(extack,
> > > +				    tb[ETHTOOL_A_MODULE_POWER_MODE_POLICY],
> > > +				    "Setting power mode policy is not supported by this device");
> > > +		return -EOPNOTSUPP;
> > > +	}
> > > +
> > > +	power_new.policy =3D nla_get_u8(tb[ETHTOOL_A_MODULE_POWER_MODE_POLI=
CY]);
> > > +	ret =3D ops->get_module_power_mode(dev, &power, extack);
> > > +	if (ret < 0)
> > > +		return ret;
> > > +	*p_mod =3D power_new.policy !=3D power.policy;
> > > +
> > > +	return ops->set_module_power_mode(dev, &power_new, extack); =20
> >=20
> > Why still call set if *p_mod =3D=3D false? =20
>=20
> Good question...
>=20
> Thinking about this again, this seems better:
>=20
> diff --git a/net/ethtool/module.c b/net/ethtool/module.c
> index 254ac84f9728..a6eefae906eb 100644
> --- a/net/ethtool/module.c
> +++ b/net/ethtool/module.c
> @@ -141,7 +141,10 @@ static int module_set_power_mode(struct net_device *=
dev, struct nlattr **tb,
>         ret =3D ops->get_module_power_mode(dev, &power, extack);
>         if (ret < 0)
>                 return ret;
> -       *p_mod =3D power_new.policy !=3D power.policy;
> +
> +       if (power_new.policy =3D=3D power.policy)
> +               return 0;
> +       *p_mod =3D true;
> =20
>         return ops->set_module_power_mode(dev, &power_new, extack);
>  }
>=20
> That way we avoid setting 'mod' to 'false' if it was already 'true'
> because of other parameters that were changed in ethnl_set_module(). We
> don't have any other parameters right now, but this can change.
>=20
> Thanks for looking into this

=F0=9F=91=8D

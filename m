Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 502AF691C95
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 11:18:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231926AbjBJKSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 05:18:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231795AbjBJKSw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 05:18:52 -0500
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [IPv6:2001:4b98:dc4:8::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C481F6CC63;
        Fri, 10 Feb 2023 02:18:49 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id E193810000B;
        Fri, 10 Feb 2023 10:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1676024328;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AK1i4vwymLGhLYk2W5XvLqUbttCS8W+m5BGnj9qJvsU=;
        b=pGoMRbUFhzju1orpx3oY49TADQhH4WakrZvXM25qi3oW5TKtVzQfZP1d7d9yJV/5D+c771
        mypT2qHlU8suG/kfWqcv2XaX4O1P40hOlPMvpNxy0+TjcymqXhhe+iL98497zw7rkHO3Qm
        M2Ib8Oc/H6Dvtnb+IR0YtZt4c4oAE1Q6F6zvSzy6q57OQsn2qGJXoPF9/b2I4Cta78zKV6
        ydH8w1NxZdcPh4JeTZIjrhPDdGBgYbsSHwrw8brbv3Bt77KWbz/oRPvU3Tx55CYsyH9afh
        FdIgCdP7PDQQ5zy/Se1/1QjwCimgkWzFh+JNU91IduHxnPmQX6asrtw/bolzvg==
Date:   Fri, 10 Feb 2023 11:18:43 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH wpan-next 1/6] ieee802154: Add support for user scanning
 requests
Message-ID: <20230210111843.0817d0d3@xps-13>
In-Reply-To: <20230203201923.6de5c692@kernel.org>
References: <20221129160046.538864-1-miquel.raynal@bootlin.com>
        <20221129160046.538864-2-miquel.raynal@bootlin.com>
        <20230203201923.6de5c692@kernel.org>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stefan, Jakub,

kuba@kernel.org wrote on Fri, 3 Feb 2023 20:19:23 -0800:

> On Tue, 29 Nov 2022 17:00:41 +0100 Miquel Raynal wrote:
> > +static int nl802154_trigger_scan(struct sk_buff *skb, struct genl_info=
 *info)
> > +{
> > +	struct cfg802154_registered_device *rdev =3D info->user_ptr[0];
> > +	struct net_device *dev =3D info->user_ptr[1];
> > +	struct wpan_dev *wpan_dev =3D dev->ieee802154_ptr;
> > +	struct wpan_phy *wpan_phy =3D &rdev->wpan_phy;
> > +	struct cfg802154_scan_request *request;
> > +	u8 type;
> > +	int err;
> > +
> > +	/* Monitors are not allowed to perform scans */
> > +	if (wpan_dev->iftype =3D=3D NL802154_IFTYPE_MONITOR) =20
>=20
> extack ?

Thanks for pointing at it, I just did know about it. I did convert
most of the printk's into extack strings. Shall I keep both or is fine
to just keep the extack thing?

For now I've dropped the printk's, please tell me if this is wrong.

>=20
> > +		return -EPERM;

Stefan, do you prefer a series of patches applying on top of your
current next or should I re-roll the entire series (scan + beacons)?

I am preparing a series applying on top of the current list of applied
patches. This means next PR to net maintainers will include this patch
as it is today + fixes on top. If this is fine for both parties, I will
send these (including the other changes discussed with Alexander). Just
let me know.

Sorry btw for the delay, I really had to finish other activities before
switching back.

> > +
> > +	request =3D kzalloc(sizeof(*request), GFP_KERNEL);
> > +	if (!request)
> > +		return -ENOMEM;
> > +
> > +	request->wpan_dev =3D wpan_dev;
> > +	request->wpan_phy =3D wpan_phy;
> > +
> > +	type =3D nla_get_u8(info->attrs[NL802154_ATTR_SCAN_TYPE]); =20
>=20
> what checks info->attrs[NL802154_ATTR_SCAN_TYPE] is not NULL?
>=20
> > +	switch (type) {
> > +	case NL802154_SCAN_PASSIVE:
> > +		request->type =3D type;
> > +		break;
> > +	default:
> > +		pr_err("Unsupported scan type: %d\n", type);
> > +		err =3D -EINVAL; =20
>=20
> extack (printfs are now supported)
>=20
> > +		goto free_request;
> > +	}
> > +
> > +	if (info->attrs[NL802154_ATTR_PAGE]) {
> > +		request->page =3D nla_get_u8(info->attrs[NL802154_ATTR_PAGE]);
> > +		if (request->page > IEEE802154_MAX_PAGE) { =20
>=20
> bound check should be part of the policy NLA_POLICY_MAX()

I just improved the policies to make these checks useless and simplify a
lot the code there, thanks as well for pointing at it.

> > +			pr_err("Invalid page %d > %d\n",
> > +			       request->page, IEEE802154_MAX_PAGE);
> > +			err =3D -EINVAL; =20
>=20
> extack
>=20
> > +			goto free_request;
> > +		}
> > +	} else {
> > +		/* Use current page by default */
> > +		request->page =3D wpan_phy->current_page;
> > +	}
> > +
> > +	if (info->attrs[NL802154_ATTR_SCAN_CHANNELS]) {
> > +		request->channels =3D nla_get_u32(info->attrs[NL802154_ATTR_SCAN_CHA=
NNELS]);
> > +		if (request->channels >=3D BIT(IEEE802154_MAX_CHANNEL + 1)) { =20
>=20
> policy as well
>=20
> > +			pr_err("Invalid channels bitfield %x =E2=89=A5 %lx\n",
> > +			       request->channels,
> > +			       BIT(IEEE802154_MAX_CHANNEL + 1));
> > +			err =3D -EINVAL;
> > +			goto free_request;
> > +		}
> > +	} else {
> > +		/* Scan all supported channels by default */
> > +		request->channels =3D wpan_phy->supported.channels[request->page];
> > +	}
> > +
> > +	if (info->attrs[NL802154_ATTR_SCAN_PREAMBLE_CODES] ||
> > +	    info->attrs[NL802154_ATTR_SCAN_MEAN_PRF]) {
> > +		pr_err("Preamble codes and mean PRF not supported yet\n"); =20
>=20
> NLA_REJECT also in policy
>=20
> > +		err =3D -EINVAL;
> > +		goto free_request;
> > +	}
> > +
> > +	if (info->attrs[NL802154_ATTR_SCAN_DURATION]) {
> > +		request->duration =3D nla_get_u8(info->attrs[NL802154_ATTR_SCAN_DURA=
TION]);
> > +		if (request->duration > IEEE802154_MAX_SCAN_DURATION) {
> > +			pr_err("Duration is out of range\n");
> > +			err =3D -EINVAL;
> > +			goto free_request;
> > +		}
> > +	} else {
> > +		/* Use maximum duration order by default */
> > +		request->duration =3D IEEE802154_MAX_SCAN_DURATION;
> > +	}
> > +
> > +	if (wpan_dev->netdev)
> > +		dev_hold(wpan_dev->netdev); =20
>=20
> Can we put a tracker in the request and use netdev_hold() ?

I'll look into it.

Thanks,
Miqu=C3=A8l

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7E166428E
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 14:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231512AbjAJN5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 08:57:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238486AbjAJN4k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 08:56:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 412D98061E
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 05:55:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF905B81673
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 13:55:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE086C433EF;
        Tue, 10 Jan 2023 13:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673358914;
        bh=qwKfpFYjkMFrE7bQr1A8U0q/qQBuCK6m3t8F7svr7BY=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=ZeuRhTz9RdsCw7FJoZOGsWEqYEBkEQf3wqoBt7vvR5r1Y0XJGr36Abhp9FpDV9qBO
         lDNuIjJmxbNrGR6xzEZTlFYkTkbR9Qs3tJWLAv4kOQRSjTdRLEDq5lV9Xbe4Cc5gAl
         YbBS3CC+gtjs67C4UgYUv8nDSWaVnPGcabZjgwHkvExiRlcdHjTyqzNaZQ/j640RQc
         N0bIxc36QxPmIDY1E99E/YOAhoEJ+QRceWxikU4s9D5t9db+YcouuLJF5OgoC/XArA
         lVTb7KCnVlA5w9WV6mi3DdRmtwMFlX7hnv7ftHMR1iZGk8NDPK4bZAmfJ/4x3vdrSD
         DhsE6AqaFTJPw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <Y71BfSFAtZJoker5@hog>
References: <20230109085557.10633-1-ehakim@nvidia.com> <20230109085557.10633-2-ehakim@nvidia.com> <Y7wvWOZYL1t7duV/@hog> <167334021775.17820.2386827809582589477@kwain.local> <Y71BfSFAtZJoker5@hog>
Subject: Re: [PATCH net-next v7 1/2] macsec: add support for IFLA_MACSEC_OFFLOAD in macsec_changelink
From:   Antoine Tenart <atenart@kernel.org>
Cc:     ehakim@nvidia.com, netdev@vger.kernel.org, raeds@nvidia.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
To:     Sabrina Dubroca <sd@queasysnail.net>
Date:   Tue, 10 Jan 2023 14:55:09 +0100
Message-ID: <167335890996.17820.293620523946399247@kwain.local>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Sabrina Dubroca (2023-01-10 11:44:13)
> 2023-01-10, 09:43:37 +0100, Antoine Tenart wrote:
> > Quoting Sabrina Dubroca (2023-01-09 16:14:32)
> > > 2023-01-09, 10:55:56 +0200, ehakim@nvidia.com wrote:
> > > > @@ -3840,6 +3835,12 @@ static int macsec_changelink(struct net_devi=
ce *dev, struct nlattr *tb[],
> > > >       if (ret)
> > > >               goto cleanup;
> > > > =20
> > > > +     if (data[IFLA_MACSEC_OFFLOAD]) {
> > > > +             ret =3D macsec_update_offload(dev, nla_get_u8(data[IF=
LA_MACSEC_OFFLOAD]));
> > > > +             if (ret)
> > > > +                     goto cleanup;
> > > > +     }
> > > > +
> > > >       /* If h/w offloading is available, propagate to the device */
> > > >       if (macsec_is_offloaded(macsec)) {
> > > >               const struct macsec_ops *ops;
> > >=20
> > > There's a missing rollback of the offloading status in the (probably
> > > quite unlikely) case that mdo_upd_secy fails, no? We can't fail
> > > macsec_get_ops because macsec_update_offload would have failed
> > > already, but I guess the driver could fail in mdo_upd_secy, and then
> > > "goto cleanup" doesn't restore the offloading state.  Sorry I didn't
> > > notice this earlier.
> > >=20
> > > In case the IFLA_MACSEC_OFFLOAD attribute is provided and we're
> > > enabling offload, we also end up calling the driver's mdo_add_secy,
> > > and then immediately afterwards mdo_upd_secy, which probably doesn't
> > > make much sense.
> > >=20
> > > Maybe we could turn that into:
> > >=20
> > >     if (data[IFLA_MACSEC_OFFLOAD]) {
> >=20
> > If data[IFLA_MACSEC_OFFLOAD] is provided but doesn't change the
> > offloading state, then macsec_update_offload will return early and
> > mdo_upd_secy won't be called.
>=20
> Ouch, thanks for catching this.
>=20
> >=20
> > >         ... macsec_update_offload
> > >     } else if (macsec_is_offloaded(macsec)) {
> > >         /* If h/w offloading is available, propagate to the device */
> > >         ... mdo_upd_secy
> > >     }
> > >=20
> > > Antoine, does that look reasonable to you?
> >=20
> > But yes I agree we can improve the logic. Maybe something like:
> >=20
> >   prev_offload =3D macsec->offload;
> >   offload =3D data[IFLA_MACSEC_OFFLOAD];
>=20
> That needs to be under if (data[IFLA_MACSEC_OFFLOAD]) and then the
> rest gets a bit messy.
>=20
> >=20
> >   if (prev_offload !=3D offload) {
> >       macsec_update_offload(...)
> >   } else if (macsec_is_offloaded(macsec)) {
> >       ...
> >       prev_offload can be used to restore the offloading state on
> >       failure here.
> >   }
>=20
> We also have a prev !=3D new test at the start of macsec_update_offload,
> the duplication is a bit ugly. We could move it out and then only call
> macsec_update_offload when there is a change to do, both from
> macsec_changelink and macsec_upd_offload.

Agreed.

> Since we don't need to restore in the second branch, and we can only
> fetch IFLA_MACSEC_OFFLOAD when it's present, maybe:
>=20
>     change =3D false;
>     if (data[IFLA_MACSEC_OFFLOAD]) {
>         offload =3D nla_get_u8(data[IFLA_MACSEC_OFFLOAD]);
>         if (macsec->offload !=3D offload) {
>             change =3D true;
>             macsec_update_offload ...cleanup
>         }
>     }
>    =20
>     if (!change && macsec_is_offloaded(macsec)) {
>         ...
>     }
>=20
> Or let macsec_update_offload do the macsec->offload !=3D offload test
> and pass &change so that changelink can know what to do next.

Either solutions work for me.

Thanks!
Antoine

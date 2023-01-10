Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80CDF663B86
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 09:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237984AbjAJIns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 03:43:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231597AbjAJInp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 03:43:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA20537272
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 00:43:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E82F61545
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 08:43:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20FEDC433EF;
        Tue, 10 Jan 2023 08:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673340223;
        bh=pVF8LyMXJH7h72577VnkRpU7grKTQhyAJ8TK7xCCV58=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=q3nyOeR/oBPzBbC7hI6ZVTYhBEprLYU7InBbehGcgZ/3mpk7s80iBbTrY6JVyQYbo
         VPrsqJxSLLbklSIHzUD5lJ4iEtPsq7B5oYZ0OdUYHxpRlbDb24Bv6mCw9ogEVI28ZR
         88mGSMKblSUyvctNmRd5Im43uLCNMZEVpKKorlQPhW7uaz96lIRAfsC/xfAQNrttdd
         f1PvXbVDVSHoXPkbGwbqDjlPUVgJ7SSmrJ+IhwzJqu+SLPePhQ4neIqaEdH/+ICno5
         3PuOctLtSo0wbfdNhJ+ZceldJV2WOZcwDdVvQkhz8hlyFE6myjKTQkNl17GXebWG5m
         DfpX/3mAyT9rA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <Y7wvWOZYL1t7duV/@hog>
References: <20230109085557.10633-1-ehakim@nvidia.com> <20230109085557.10633-2-ehakim@nvidia.com> <Y7wvWOZYL1t7duV/@hog>
Subject: Re: [PATCH net-next v7 1/2] macsec: add support for IFLA_MACSEC_OFFLOAD in macsec_changelink
From:   Antoine Tenart <atenart@kernel.org>
Cc:     netdev@vger.kernel.org, raeds@nvidia.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
To:     Sabrina Dubroca <sd@queasysnail.net>, ehakim@nvidia.com
Date:   Tue, 10 Jan 2023 09:43:37 +0100
Message-ID: <167334021775.17820.2386827809582589477@kwain.local>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Sabrina Dubroca (2023-01-09 16:14:32)
> 2023-01-09, 10:55:56 +0200, ehakim@nvidia.com wrote:
> > @@ -3840,6 +3835,12 @@ static int macsec_changelink(struct net_device *=
dev, struct nlattr *tb[],
> >       if (ret)
> >               goto cleanup;
> > =20
> > +     if (data[IFLA_MACSEC_OFFLOAD]) {
> > +             ret =3D macsec_update_offload(dev, nla_get_u8(data[IFLA_M=
ACSEC_OFFLOAD]));
> > +             if (ret)
> > +                     goto cleanup;
> > +     }
> > +
> >       /* If h/w offloading is available, propagate to the device */
> >       if (macsec_is_offloaded(macsec)) {
> >               const struct macsec_ops *ops;
>=20
> There's a missing rollback of the offloading status in the (probably
> quite unlikely) case that mdo_upd_secy fails, no? We can't fail
> macsec_get_ops because macsec_update_offload would have failed
> already, but I guess the driver could fail in mdo_upd_secy, and then
> "goto cleanup" doesn't restore the offloading state.  Sorry I didn't
> notice this earlier.
>=20
> In case the IFLA_MACSEC_OFFLOAD attribute is provided and we're
> enabling offload, we also end up calling the driver's mdo_add_secy,
> and then immediately afterwards mdo_upd_secy, which probably doesn't
> make much sense.
>=20
> Maybe we could turn that into:
>=20
>     if (data[IFLA_MACSEC_OFFLOAD]) {

If data[IFLA_MACSEC_OFFLOAD] is provided but doesn't change the
offloading state, then macsec_update_offload will return early and
mdo_upd_secy won't be called.

>         ... macsec_update_offload
>     } else if (macsec_is_offloaded(macsec)) {
>         /* If h/w offloading is available, propagate to the device */
>         ... mdo_upd_secy
>     }
>=20
> Antoine, does that look reasonable to you?

But yes I agree we can improve the logic. Maybe something like:

  prev_offload =3D macsec->offload;
  offload =3D data[IFLA_MACSEC_OFFLOAD];

  if (prev_offload !=3D offload) {
      macsec_update_offload(...)
  } else if (macsec_is_offloaded(macsec)) {
      ...
      prev_offload can be used to restore the offloading state on
      failure here.
  }

Thanks,
Antoine

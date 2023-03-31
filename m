Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7361F6D2793
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 20:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231429AbjCaSKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 14:10:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbjCaSKo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 14:10:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B1FF133
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 11:10:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA93962B14
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 18:10:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 073B6C433EF;
        Fri, 31 Mar 2023 18:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680286242;
        bh=pW1gbZVwJmtV1wtftdAeELUbmCq4wkd/So7DREFSWLY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nj8bWYtQ1EnDqr/DPLM4WAs/p6yBO/zEJoVtel986fSAVbPVV4yDLXKoULdP0iM09
         Wdr7+6A6guZvB+Xk2629tM79HVHo9JXHlsYJO9fZVrEYuj8R22t46yC0tIidjRdJiu
         SlWZ+8QzY5E4iCmu6U4EztWqzSd2KJn65YUwqBgqFQUghqGQ92Kb50MgOlq5R4+Ugs
         wyypde6AHWnWxu+OiYd2/Q8qshN07q0FYbGCaLveahmYMR6tTvTDdj/HSHQs11whK6
         aKNMM9RUcqOEKMUHWQ2gkVFDDX6nDh6l/L+FhrZux0IkKKOInNZgfHewrJ9PufGBM4
         J/9AFoeM59tTw==
Date:   Fri, 31 Mar 2023 11:10:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Max Georgiev <glipus@gmail.com>
Cc:     kory.maincent@bootlin.com, netdev@vger.kernel.org,
        maxime.chevallier@bootlin.com, vladimir.oltean@nxp.com
Subject: Re: [PATCH net-next RFC] Add NDOs for hardware timestamp get/set
Message-ID: <20230331111041.0dc5327c@kernel.org>
In-Reply-To: <CAP5jrPHzQN25gWmNCXYdCO0U7Fxx_wB0WdbKRNd8Owqp1Gftsg@mail.gmail.com>
References: <20230331045619.40256-1-glipus@gmail.com>
        <20230330223519.36ce7d23@kernel.org>
        <CAP5jrPHzQN25gWmNCXYdCO0U7Fxx_wB0WdbKRNd8Owqp1Gftsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 Mar 2023 11:51:06 -0600 Max Georgiev wrote:
> On Thu, Mar 30, 2023 at 11:35=E2=80=AFPM Jakub Kicinski <kuba@kernel.org>=
 wrote:
> >
> > On Thu, 30 Mar 2023 22:56:19 -0600 Maxim Georgiev wrote: =20
> > > @@ -1642,6 +1650,10 @@ struct net_device_ops {
> > >       ktime_t                 (*ndo_get_tstamp)(struct net_device *de=
v,
> > >                                                 const struct skb_shar=
ed_hwtstamps *hwtstamps,
> > >                                                 bool cycles);
> > > +     int                     (*ndo_hwtstamp_get)(struct net_device *=
dev,
> > > +                                                 struct hwtstamp_con=
fig *config);
> > > +     int                     (*ndo_hwtstamp_set)(struct net_device *=
dev,
> > > +                                                 struct hwtstamp_con=
fig *config); =20
> >
> > I wonder if we should pass in
> >
> >         struct netlink_ext_ack *extack
> >
> > and maybe another structure for future extensions?
> > So we don't have to change the drivers again when we extend uAPI. =20
>=20
> Would these two extra parameters be ignored by drivers in this initial
> version of NDO hw timestamp API implementation?

Yup, and passed in as NULL.

See struct kernel_ethtool_coalesce for example of a kernel side
structure extending a fixed-size uAPI struct ethtool_coalesce.

So we would add a struct kernel_hwtstamp_config which would be=20
empty for now, but we can make it not empty later.

Vladimir, does that sound reasonable or am I over-thinking?

> > > +     return err;
> > > +}
> > > +
> > >  static int dev_siocdevprivate(struct net_device *dev, struct ifreq *=
ifr,
> > >                             void __user *data, unsigned int cmd)
> > >  {
> > > @@ -391,11 +424,14 @@ static int dev_ifsioc(struct net *net, struct i=
freq *ifr, void __user *data,
> > >               rtnl_lock();
> > >               return err;
> > >
> > > +     case SIOCGHWTSTAMP:
> > > +             return dev_hwtstamp(dev, ifr, cmd);
> > > +
> > >       case SIOCSHWTSTAMP:
> > >               err =3D net_hwtstamp_validate(ifr);
> > >               if (err)
> > >                       return err;
> > > -             fallthrough;
> > > +             return dev_hwtstamp(dev, ifr, cmd); =20
> >
> > Let's refactor this differently, we need net_hwtstamp_validate()
> > to run on the same in-kernel copy as we'll send down to the driver.
> > If we copy_from_user() twice we may validate a different thing
> > than the driver will end up seeing (ToCToU). =20
>=20
> Got it, that would be a nice optimization for the NDO execution path!
> We still will need a version of net_hwtstamp_validate(struct ifreq *ifr)
> to do validation for drivers not implementing ndo_hwtstamp_set().
> Also we'll need to implement validation for dsa_ndo_eth_ioctl() which
> usually has an empty implementation, but can do something
> meaningful depending on kernel configuration if I understand
> it correctly. I'm not sure where to insert the validation code for
> the DSA code path, would greatly appreciate some advice here.

You can copy from user space onto stack at the start of the new
dev_set_hwtstamp(), make validation run on the already-copied
version, and then either proceed to call the NDO with the on-stack
config which was validated or the legacy and DSA path with ifr.

> > TBH I'm not sure if keeping GET and SET in a common dev_hwtstamp()
> > ends up being beneficial. If we fold in the validation check half
> > of the code will be under and if (GET) or if (SET).. =20
>=20
> I was on a fence about splitting dev_hwtstamp() into GET and SET versions.
> If you believe separate implementations will provide a cleaner implementa=
tion
> I'll be glad to split them.


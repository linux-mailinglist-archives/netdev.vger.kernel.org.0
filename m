Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1CC359A391
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 20:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351615AbiHSRu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 13:50:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354883AbiHSRuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 13:50:21 -0400
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EF43B4BD;
        Fri, 19 Aug 2022 10:22:35 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 34C081C0005;
        Fri, 19 Aug 2022 17:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1660929751;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YVuJLmtyvjBQfTz3ldnNOD8hJj8risCWE8ENHcXRIGI=;
        b=BRJXjvr7YYosg25XKsquAzb5Q/WlKD6rxcvZSAKxMRSlix00GWy8H+iTSNc6Bg3by/FsFf
        C3nZEgsnr2wyLJv+GkSgwjy0I99EkRXR79W5rieL54wkvwASVnHeMGzcY354mwG8iDD72C
        S+LcMb0f8yTEVVHPq1H0ua2gD9s+e94wU3iz3Xo9IHj+iuTDj7unv1m92HJVG7oIPGKSVI
        y9JMiwlc7mOakRqAtNM1aMgW6a9TYu2ktcmDvzX6c4hwfW+OpWhw+GSOimTT+kDM5pyHwk
        h7Fu0IXf9Me2M5Ev61OoRSLVMv0t7qs4/z9BEzWc0WpUDT9ty74tHWZlIJiTkQ==
Date:   Fri, 19 Aug 2022 19:22:28 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <aahringo@redhat.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Network Development <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH wpan-next 10/20] net: mac802154: Handle passive scanning
Message-ID: <20220819192228.7c76e86c@xps-13>
In-Reply-To: <CAK-6q+g5Co049ZED0fKkeh_k9mdRvm_wrgi4ostDBvN71UWcrA@mail.gmail.com>
References: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
        <20220701143052.1267509-11-miquel.raynal@bootlin.com>
        <CAK-6q+giwXeOue4x_mZK+qyG9FNLYpK6T5_L1HjaR6zz2LrW-A@mail.gmail.com>
        <CAK-6q+g5Co049ZED0fKkeh_k9mdRvm_wrgi4ostDBvN71UWcrA@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

aahringo@redhat.com wrote on Thu, 14 Jul 2022 23:42:08 -0400:

> Hi,
>=20
> On Thu, Jul 14, 2022 at 11:33 PM Alexander Aring <aahringo@redhat.com> wr=
ote:
> >
> > Hi,
> >
> > On Fri, Jul 1, 2022 at 10:36 AM Miquel Raynal <miquel.raynal@bootlin.co=
m> wrote: =20
> > >
> > > Implement the core hooks in order to provide the softMAC layer support
> > > for passive scans. Scans are requested by the user and can be aborted.
> > >
> > > Changing the channels is prohibited during the scan.
> > >
> > > As transceivers enter promiscuous mode during scans, they might stop
> > > checking frame validity so we ensure this gets done at mac level.
> > >
> > > The implementation uses a workqueue triggered at a certain interval
> > > depending on the symbol duration for the current channel and the
> > > duration order provided.
> > >
> > > Received beacons during a passive scan are processed also in a work
> > > queue and forwarded to the upper layer.
> > >
> > > Active scanning is not supported yet.
> > >
> > > Co-developed-by: David Girault <david.girault@qorvo.com>
> > > Signed-off-by: David Girault <david.girault@qorvo.com>
> > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > ---
> > >  include/linux/ieee802154.h   |   4 +
> > >  include/net/cfg802154.h      |  12 ++
> > >  net/mac802154/Makefile       |   2 +-
> > >  net/mac802154/cfg.c          |  39 ++++++
> > >  net/mac802154/ieee802154_i.h |  29 ++++
> > >  net/mac802154/iface.c        |   6 +
> > >  net/mac802154/main.c         |   4 +
> > >  net/mac802154/rx.c           |  49 ++++++-
> > >  net/mac802154/scan.c         | 264 +++++++++++++++++++++++++++++++++=
++
> > >  9 files changed, 405 insertions(+), 4 deletions(-)
> > >  create mode 100644 net/mac802154/scan.c
> > >

[...]

> > > +int mac802154_trigger_scan_locked(struct
ieee802154_sub_if_data *sdata,
> > > +                                 struct cfg802154_scan_request *requ=
est)
> > > +{
> > > +       struct ieee802154_local *local =3D sdata->local;
> > > +       int ret;
> > > +
> > > +       lockdep_assert_held(&local->scan_lock);
> > > +
> > > +       if (mac802154_is_scanning(local))
> > > +               return -EBUSY;
> > > +
> > > +       /* TODO: support other scanning type */
> > > +       if (request->type !=3D NL802154_SCAN_PASSIVE)
> > > +               return -EOPNOTSUPP;
> > > +
> > > +       /* Store scanning parameters */
> > > +       rcu_assign_pointer(local->scan_req, request);
> > > +
> > > +       /* Software scanning requires to set promiscuous mode, so we =
need to
> > > +        * pause the Tx queue during the entire operation.
> > > +        */
> > > +       ieee802154_mlme_op_pre(local);
> > > +
> > > +       ret =3D mac802154_set_promiscuous_mode(local, true);
> > > +       if (ret)
> > > +               goto cancel_mlme; =20
> >
> > I know some driver datasheets and as I said before, it's not allowed
> > to set promiscuous mode while in receive mode. We need to stop tx,
> > what we are doing. Then call stop() driver callback,
> > synchronize_net(), mac802154_set_promiscuous_mode(...), start(). The
> > same always for the opposite. =20
>
> s/always/as well/

Mmmh. I didn't know. I will look into it.

> I need to say, it needs to be something like that... we need to be
> careful here e.g. lots of monitor interfaces on one phy which has
> currently a serious use case for hwsim.
>=20
> We also don't need to do anything above if we already are in
> promiscuous mode, which might be worth checking.

True!

Thanks,
Miqu=C3=A8l

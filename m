Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB42A5FF94D
	for <lists+netdev@lfdr.de>; Sat, 15 Oct 2022 10:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbiJOI7r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Oct 2022 04:59:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiJOI7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Oct 2022 04:59:40 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CDCAA0;
        Sat, 15 Oct 2022 01:59:35 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 96C791BF207;
        Sat, 15 Oct 2022 08:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1665824373;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+d2GemBD9ox4LXebnGALG60SzehxFfCfOOnC+WT1Eew=;
        b=NQpTcP3xlK9f+3Fix6KWECbMjiEHWFdL1M8otXUGMpa6kLZSmV8i4oQRAeR+U2UL2wyq7+
        5nMADRkmxYaLqGWm1mCV6apih8S0vEW8WLEBjj2r9qeDRf59QKZwV1ptNj5EluQ/Rx74H4
        JB7vmOeabnnl3r/VCTQaZtNDALsl3ZY/+02+8bTPygTeaBAUGNP5RZUlbNcs0SOiqgmoBE
        ej5CuthZvaXnceJ3lSsZBFFXEk3j/3LEXT6mQwU20ZZ4P0J/yvDLGtqgpcZjm1h+pYSGBv
        XZQ4XTMSRyCmkVLXCNWXcoPKz7ce5oCeDwbIwtDo8kk+58YEuz8E1rFoxl01zw==
Date:   Sat, 15 Oct 2022 10:59:28 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <aahringo@redhat.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH wpan/next v4 5/8] ieee802154: hwsim: Implement address
 filtering
Message-ID: <20221012155828.5a5cade8@xps-13>
In-Reply-To: <CAK-6q+hO1AFzdH_DRYVM77VJhotsoeiBzqL0o7ND7sPYJhSrbQ@mail.gmail.com>
References: <20221007085310.503366-1-miquel.raynal@bootlin.com>
 <20221007085310.503366-6-miquel.raynal@bootlin.com>
 <CAK-6q+iun+K8F6Mv3=WLL92iZnv-9oSnoRYtY4Zex2DZqS8ABQ@mail.gmail.com>
 <CAK-6q+iKf5bXX+EPBw9utCpAoBVjZ678na0V_n4GUes5O=NLLw@mail.gmail.com>
 <CAK-6q+hO1AFzdH_DRYVM77VJhotsoeiBzqL0o7ND7sPYJhSrbQ@mail.gmail.com>
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

Hi Alexander,

aahringo@redhat.com wrote on Mon, 10 Oct 2022 21:21:17 -0400:

> Hi,
>=20
> On Mon, Oct 10, 2022 at 9:13 PM Alexander Aring <aahringo@redhat.com> wro=
te:
> >
> > Hi,
> >
> > On Mon, Oct 10, 2022 at 9:04 PM Alexander Aring <aahringo@redhat.com> w=
rote: =20
> > >
> > > Hi,
> > >
> > > On Fri, Oct 7, 2022 at 4:53 AM Miquel Raynal <miquel.raynal@bootlin.c=
om> wrote: =20
> > > >
> > > > We have access to the address filters being theoretically applied, =
we
> > > > also have access to the actual filtering level applied, so let's ad=
d a
> > > > proper frame validation sequence in hwsim.
> > > >
> > > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > > ---
> > > >  drivers/net/ieee802154/mac802154_hwsim.c | 111 +++++++++++++++++++=
+++-
> > > >  include/net/ieee802154_netdev.h          |   8 ++
> > > >  2 files changed, 117 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net=
/ieee802154/mac802154_hwsim.c
> > > > index 458be66b5195..84ee948f35bc 100644
> > > > --- a/drivers/net/ieee802154/mac802154_hwsim.c
> > > > +++ b/drivers/net/ieee802154/mac802154_hwsim.c
> > > > @@ -18,6 +18,7 @@
> > > >  #include <linux/netdevice.h>
> > > >  #include <linux/device.h>
> > > >  #include <linux/spinlock.h>
> > > > +#include <net/ieee802154_netdev.h>
> > > >  #include <net/mac802154.h>
> > > >  #include <net/cfg802154.h>
> > > >  #include <net/genetlink.h>
> > > > @@ -139,6 +140,113 @@ static int hwsim_hw_addr_filt(struct ieee8021=
54_hw *hw,
> > > >         return 0;
> > > >  }
> > > >
> > > > +static void hwsim_hw_receive(struct ieee802154_hw *hw, struct sk_b=
uff *skb,
> > > > +                            u8 lqi)
> > > > +{
> > > > +       struct ieee802154_hdr hdr;
> > > > +       struct hwsim_phy *phy =3D hw->priv;
> > > > +       struct hwsim_pib *pib;
> > > > +
> > > > +       rcu_read_lock();
> > > > +       pib =3D rcu_dereference(phy->pib);
> > > > +
> > > > +       if (!pskb_may_pull(skb, 3)) {
> > > > +               dev_dbg(hw->parent, "invalid frame\n");
> > > > +               goto drop;
> > > > +       }
> > > > +
> > > > +       memcpy(&hdr, skb->data, 3);
> > > > +
> > > > +       /* Level 4 filtering: Frame fields validity */
> > > > +       if (hw->phy->filtering =3D=3D IEEE802154_FILTERING_4_FRAME_=
FIELDS) { =20
> >
> > I see, there is this big if handling. But it accesses the
> > hw->phy->filtering value. It should be part of the hwsim pib setting
> > set by the driver callback. It is a question here of mac802154 layer
> > setting vs driver layer setting. We should do what the mac802154 tells
> > the driver to do, this way we do what the mac802154 layer is set to.
> >
> > However it's a minor thing and it's okay to do it so... =20
>=20
> * whereas we never let the driver know at any time of what different
> filter levels exist _currently_ we have only the promiscuous mode
> on/off switch which is do nothing or 4_FRAME_FIELDS.
> It will work for now, changing anything in the mac802154 filtering
> fields or something will end in probably breakage in this handling. In
> my point of view as the current state is it should not do that, as
> remember that hwsim will "simulate" hardware it should not be able to
> access mac802154 fields (especially when doing receiving of frames) as
> other hardware will only set register bits (as hwsim pib values is
> there for)...
>=20
> Still I think it's fine for now.

I see your point, indeed I could have added another PIB attribute
instead of accessing the PHY state.

I am fine doing it in a followup patch if this what you prefer. Shall I
do it?

Thanks,
Miqu=C3=A8l

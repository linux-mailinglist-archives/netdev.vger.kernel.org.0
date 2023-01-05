Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7496F65E7B3
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 10:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231409AbjAEJYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 04:24:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230479AbjAEJYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 04:24:37 -0500
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [IPv6:2001:4b98:dc4:8::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D8B350E5D;
        Thu,  5 Jan 2023 01:24:34 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id ABD42100011;
        Thu,  5 Jan 2023 09:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1672910672;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yf/C1jtMXhm6+8Q2rGRdXwGkY3vHOGxKg3J0mHCLBYU=;
        b=JmzBaUnkaUS5hX3cvRz24wBQcMFWdhOPE5j6M97DwFr5/PAN2ptrlHCARFLTSd0aayymIq
        s0VObuyvr2/NB2rj61FM7OPKOYpbvtp79le0xzUUTmYTCrTLo8w9kSbfi98nS7PEaCLwLe
        1FqSubSP+zqxvUioFpQYw1id8uhg6jAk4bCdWa4ZSdArSB1B4/8P2KyhxCMnRQjidpm80t
        s1JR51j2rV8CT8GdRjDzn2MECqIob5rdqz6/RO1r11MLrrVisc/1k/f/mBnsDONeFmM4Dk
        r7nxX2SngiIehPC3aV4keqWoyuoNbtcgmkZoz3/3fxB1Pln6gSZGoSz1Mxt5Kw==
Date:   Thu, 5 Jan 2023 10:24:27 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <aahringo@redhat.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
Subject: Re: [PATCH wpan-next v2 6/6] mac802154: Handle passive scanning
Message-ID: <20230105102427.4b836ea5@xps-13>
In-Reply-To: <CAK-6q+hniz7tw74Nzvjs6VPA6Goc1ozi231PcdWpysCdLdaf4Q@mail.gmail.com>
References: <20221217000226.646767-1-miquel.raynal@bootlin.com>
        <20221217000226.646767-7-miquel.raynal@bootlin.com>
        <CAK-6q+hJb-py2sNBGYBQeHLbyM_OWzi78-gOf0LcdTukFDO4MQ@mail.gmail.com>
        <CAK-6q+gTQwS5n+YVFDeGTqEnSREt9KjC58zq9r2c8T456zXagQ@mail.gmail.com>
        <20230103161047.4efc243c@xps-13>
        <CAK-6q+hniz7tw74Nzvjs6VPA6Goc1ozi231PcdWpysCdLdaf4Q@mail.gmail.com>
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

aahringo@redhat.com wrote on Tue, 3 Jan 2023 20:00:41 -0500:

> Hi,
>=20
> On Tue, Jan 3, 2023 at 10:15 AM Miquel Raynal <miquel.raynal@bootlin.com>=
 wrote:
> >
> > Hi Alexander,
> >
> > aahringo@redhat.com wrote on Mon, 2 Jan 2023 20:15:25 -0500:
> > =20
> > > Hi,
> > >
> > > On Mon, Jan 2, 2023 at 8:04 PM Alexander Aring <aahringo@redhat.com> =
wrote: =20
> > > >
> > > > Hi,
> > > >
> > > > On Fri, Dec 16, 2022 at 7:04 PM Miquel Raynal <miquel.raynal@bootli=
n.com> wrote:
> > > > ... =20
> > > > > +void mac802154_scan_worker(struct work_struct *work)
> > > > > +{
> > > > > +       struct ieee802154_local *local =3D
> > > > > +               container_of(work, struct ieee802154_local, scan_=
work.work);
> > > > > +       struct cfg802154_scan_request *scan_req;
> > > > > +       struct ieee802154_sub_if_data *sdata;
> > > > > +       unsigned int scan_duration =3D 0;
> > > > > +       struct wpan_phy* wpan_phy;
> > > > > +       u8 scan_req_duration;
> > > > > +       u8 page, channel;
> > > > > +       int ret;
> > > > > +
> > > > > +       /* Ensure the device receiver is turned off when changing=
 channels
> > > > > +        * because there is no atomic way to change the channel a=
nd know on
> > > > > +        * which one a beacon might have been received.
> > > > > +        */
> > > > > +       drv_stop(local);
> > > > > +       synchronize_net(); =20
> > > >
> > > > Do we do that for every channel switch? I think this is not necessa=
ry.
> > > > It is necessary for bringing the transceiver into scan filtering mo=
de,
> > > > but we don't need to do that for switching the channel.
> > > >
> > > > And there is a difference why we need to do that for filtering. In =
my
> > > > mind I had the following reason that the MAC layer is handled in Li=
nux
> > > > (softMAC) and by offloaded parts on the transceiver, this needs to =
be
> > > > synchronized. The PHY layer is completely on the transceiver side,
> > > > that's why you can switch channels during interface running. There
> > > > exist some MAC parameters which are offloaded to the hardware and a=
re
> > > > currently not possible to synchronize while an interface is up,
> > > > however this could change in future because the new helpers to
> > > > synchronize softmac/transceiver mac handling.
> > > >
> > > > There is maybe a need here to be sure everything is transmitted on =
the
> > > > hardware before switching the channel, but this should be done by t=
he
> > > > new mlme functionality which does a synchronized transmit. However =
we
> > > > don't transmit anything here, so there is no need for that yet. We
> > > > should never stop the transceiver being into receive mode and during
> > > > scan we should always be into receive mode in
> > > > IEEE802154_FILTERING_3_SCAN level without never leaving it.
> > > >
> > > > ... and happy new year.
> > > >
> > > > I wanted to ack this series but this came into my mind. I also want=
ed
> > > > to check what exactly happens when a mlme op returns an error like
> > > > channel access failure? Do we ignore it? Do we do cond_resched() and
> > > > retry again later? I guess these are questions only if we get into
> > > > active scanning with more exciting sending of frames, because here =
we
> > > > don't transmit anything. =20
> > >
> > > Ignore that above about stopping the transceiver being in receive
> > > mode, you are right... you cannot know on which channel/page
> > > combination the beacon was received because as the comment says, it is
> > > not atomic to switch it... sadly the transceiver does not tell us that
> > > on a per frame basis. =20
> >
> > No problem ;)
> > =20
> > > Sorry for the noise. Still with my previous comments why it's still
> > > valid to switch channels while phy is in receive mode but not in scan
> > > mode, I would say if a user does that... then we don't care. Some
> > > offloaded parts and softMAC handling still need indeed to be
> > > synchronized because we don't know how a transceiver reacts on it to
> > > change registers there while transmitting. =20
> >
> > In case of error during an MLME transmission the behavior depends on
> > which MLME it is. As you said, for passive scanning it does not matter
> > because we do not really transmit anything yet. However active scans
> > and beacons sending need this feature and have to transmit frames. I
> > assumed both actions should not have a very high importance and if the
> > transmission fails, we will just wait for the next slot and try again.
> > It was the simplest approach I could come up with (I will send the
> > beacons part very soon). Should we consider retrying a fixed number of
> > times immediately after the failure? 1 time? 2 times? Or should we, as
> > it is implemented, wait for the next slot? =20
>=20
> use the simplest approach. btw: 802.15.4 and ack handling has it's
> "own" retransmit handling, but I think csma retries could happen
> without setting the ack request bit. We should avoid that the user
> gets an error "channel access failure" for doing an active scan, or
> this maybe should be and the user can react to it? It would then
> require that the user's implementation cares/is aware about such a
> possibility and maybe does a simple retry on user level as well or
> whatever they want then? However they are probably not happy to start
> a whole scan again...
>=20
> I am not sure what the right thing is... it is probably a rare case.

I agree it should be very rare. As you said, the retransmission should
be already attempted in the active scan case so I think if the channel
is completely bloated, we could just ignore the issue and only wait for
"passive" beacons to arrive, exceptionally.

In the Beacon sending case I guess it's not that important. On one side,
if we dictate the active periods between each beacon then in theory no
device should emit when we send it. On the other side if we are
just sending these beacons without any kind of framing involved, we
don't really care if one of them cannot be transmitted, there will
be others.

Thanks,
Miqu=C3=A8l

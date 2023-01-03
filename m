Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAFA365C2D2
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 16:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233647AbjACPPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 10:15:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230337AbjACPPG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 10:15:06 -0500
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [217.70.178.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6010FFCF7;
        Tue,  3 Jan 2023 07:15:04 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 5D16D100084;
        Tue,  3 Jan 2023 15:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1672758902;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bmVFV1oaTao/UIOxac7aRnPXD7wlk2LRTtmVoenFRPY=;
        b=irDFW1FaWDAk9tpLdyQhaR8DpxkIaufyV+wgnoGCLmhBXmoLPeuQ7oJw4xmOFKG1t1CoaX
        r2ZNFPvfN3eE9z4n/SFT39g2Vpi3j3pjEZfWTZc86oaox7H4RbuVLLCJNcUtGQnytVQ+sa
        CcpdcGx6qUydGRM4e+4th6UYh2MJZd2drBYm1FWFvl5g4yNux590+czls2euc6mQIpHg94
        waddJ5qApYNuwFXe9JhA9K0WLypZgddmwAldUwq92wD0AIMKyzwCvHFVcPgwdZcNMfIZw4
        o4tkX4+STLuY68c2zqN9O+5uWPnhbjqrpmGx4NnwEqdEiHsanRyUkfF4ujOkYA==
Date:   Tue, 3 Jan 2023 16:10:47 +0100
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
Message-ID: <20230103161047.4efc243c@xps-13>
In-Reply-To: <CAK-6q+gTQwS5n+YVFDeGTqEnSREt9KjC58zq9r2c8T456zXagQ@mail.gmail.com>
References: <20221217000226.646767-1-miquel.raynal@bootlin.com>
        <20221217000226.646767-7-miquel.raynal@bootlin.com>
        <CAK-6q+hJb-py2sNBGYBQeHLbyM_OWzi78-gOf0LcdTukFDO4MQ@mail.gmail.com>
        <CAK-6q+gTQwS5n+YVFDeGTqEnSREt9KjC58zq9r2c8T456zXagQ@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

aahringo@redhat.com wrote on Mon, 2 Jan 2023 20:15:25 -0500:

> Hi,
>=20
> On Mon, Jan 2, 2023 at 8:04 PM Alexander Aring <aahringo@redhat.com> wrot=
e:
> >
> > Hi,
> >
> > On Fri, Dec 16, 2022 at 7:04 PM Miquel Raynal <miquel.raynal@bootlin.co=
m> wrote:
> > ... =20
> > > +void mac802154_scan_worker(struct work_struct *work)
> > > +{
> > > +       struct ieee802154_local *local =3D
> > > +               container_of(work, struct ieee802154_local, scan_work=
.work);
> > > +       struct cfg802154_scan_request *scan_req;
> > > +       struct ieee802154_sub_if_data *sdata;
> > > +       unsigned int scan_duration =3D 0;
> > > +       struct wpan_phy* wpan_phy;
> > > +       u8 scan_req_duration;
> > > +       u8 page, channel;
> > > +       int ret;
> > > +
> > > +       /* Ensure the device receiver is turned off when changing cha=
nnels
> > > +        * because there is no atomic way to change the channel and k=
now on
> > > +        * which one a beacon might have been received.
> > > +        */
> > > +       drv_stop(local);
> > > +       synchronize_net(); =20
> >
> > Do we do that for every channel switch? I think this is not necessary.
> > It is necessary for bringing the transceiver into scan filtering mode,
> > but we don't need to do that for switching the channel.
> >
> > And there is a difference why we need to do that for filtering. In my
> > mind I had the following reason that the MAC layer is handled in Linux
> > (softMAC) and by offloaded parts on the transceiver, this needs to be
> > synchronized. The PHY layer is completely on the transceiver side,
> > that's why you can switch channels during interface running. There
> > exist some MAC parameters which are offloaded to the hardware and are
> > currently not possible to synchronize while an interface is up,
> > however this could change in future because the new helpers to
> > synchronize softmac/transceiver mac handling.
> >
> > There is maybe a need here to be sure everything is transmitted on the
> > hardware before switching the channel, but this should be done by the
> > new mlme functionality which does a synchronized transmit. However we
> > don't transmit anything here, so there is no need for that yet. We
> > should never stop the transceiver being into receive mode and during
> > scan we should always be into receive mode in
> > IEEE802154_FILTERING_3_SCAN level without never leaving it.
> >
> > ... and happy new year.
> >
> > I wanted to ack this series but this came into my mind. I also wanted
> > to check what exactly happens when a mlme op returns an error like
> > channel access failure? Do we ignore it? Do we do cond_resched() and
> > retry again later? I guess these are questions only if we get into
> > active scanning with more exciting sending of frames, because here we
> > don't transmit anything. =20
>=20
> Ignore that above about stopping the transceiver being in receive
> mode, you are right... you cannot know on which channel/page
> combination the beacon was received because as the comment says, it is
> not atomic to switch it... sadly the transceiver does not tell us that
> on a per frame basis.

No problem ;)

> Sorry for the noise. Still with my previous comments why it's still
> valid to switch channels while phy is in receive mode but not in scan
> mode, I would say if a user does that... then we don't care. Some
> offloaded parts and softMAC handling still need indeed to be
> synchronized because we don't know how a transceiver reacts on it to
> change registers there while transmitting.

In case of error during an MLME transmission the behavior depends on
which MLME it is. As you said, for passive scanning it does not matter
because we do not really transmit anything yet. However active scans
and beacons sending need this feature and have to transmit frames. I
assumed both actions should not have a very high importance and if the
transmission fails, we will just wait for the next slot and try again.
It was the simplest approach I could come up with (I will send the
beacons part very soon). Should we consider retrying a fixed number of
times immediately after the failure? 1 time? 2 times? Or should we, as
it is implemented, wait for the next slot?

Thanks,
Miqu=C3=A8l

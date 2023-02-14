Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A39286966D9
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 15:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232349AbjBNO3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 09:29:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231580AbjBNO3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 09:29:08 -0500
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4CB62A9BC;
        Tue, 14 Feb 2023 06:28:54 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 449111C0011;
        Tue, 14 Feb 2023 14:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1676384933;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bQkME6Znl51y2tDIRZ8u/TJh9mxeNJ2vAEH2SYXAWhg=;
        b=QIc3S+8UfbCaFGsflrLbK3N6rDmAnpk21MWJPGh0K1NZnw/TGPrhOeNTPcOzIa11pqv+Cy
        TllEsegxh1Vwn7P+6/E39jYOH8SPtO7GNS1a+yP+c6jN8LIvIdixPwgVb0t4ZVsjvB7PUp
        66SyYPhxRF6wBxtVhKnIQDeu3L6ujvEYdjh1HoY3ye1Zhb75ct/oKcWMWN6GqB1F3Yfr5b
        IhIGpzSb2BmpeqRUNJlAVKCXsZM0PqXvZU9MLpy4gV17jWk7K+YzuMdx/nFbN4CCbCnFjh
        +9sOCeftgE+mtrt1TPhQA0H09OfbXBJf4So+kwQ3mXnhfetifJL7RScgHxFd3w==
Date:   Tue, 14 Feb 2023 15:28:49 +0100
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
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH wpan-next 1/6] ieee802154: Add support for user scanning
 requests
Message-ID: <20230214152849.5c3d196b@xps-13>
In-Reply-To: <CAK-6q+jP55MaB-_ZbRHKESgEb-AW+kN3bU2SMWMtkozvoyfAwA@mail.gmail.com>
References: <20221129160046.538864-1-miquel.raynal@bootlin.com>
        <20221129160046.538864-2-miquel.raynal@bootlin.com>
        <CAK-6q+iwqVx+6qQ-ctynykdrbN+SHxzk91gQCSdYCUD-FornZA@mail.gmail.com>
        <20230206101235.0371da87@xps-13>
        <CAK-6q+jav4yJD3MsOssyBobg1zGqKC5sm-xCRYX1SCkH9GhmHw@mail.gmail.com>
        <20230210182129.77c1084d@xps-13>
        <CAK-6q+jLKo1bLBie_xYZyZdyjNB_M8JvxDfr77RQAY9WYcQY8w@mail.gmail.com>
        <20230213111553.0dcce5c2@xps-13>
        <CAK-6q+jP55MaB-_ZbRHKESgEb-AW+kN3bU2SMWMtkozvoyfAwA@mail.gmail.com>
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

aahringo@redhat.com wrote on Tue, 14 Feb 2023 08:51:12 -0500:

> Hi,
>=20
> On Mon, Feb 13, 2023 at 5:16 AM Miquel Raynal <miquel.raynal@bootlin.com>=
 wrote:
> >
> > Hi Alexander,
> >
> > > > > > > > +static int nl802154_trigger_scan(struct sk_buff *skb, stru=
ct genl_info *info)
> > > > > > > > +{
> > > > > > > > +       struct cfg802154_registered_device *rdev =3D info->=
user_ptr[0];
> > > > > > > > +       struct net_device *dev =3D info->user_ptr[1];
> > > > > > > > +       struct wpan_dev *wpan_dev =3D dev->ieee802154_ptr;
> > > > > > > > +       struct wpan_phy *wpan_phy =3D &rdev->wpan_phy;
> > > > > > > > +       struct cfg802154_scan_request *request;
> > > > > > > > +       u8 type;
> > > > > > > > +       int err;
> > > > > > > > +
> > > > > > > > +       /* Monitors are not allowed to perform scans */
> > > > > > > > +       if (wpan_dev->iftype =3D=3D NL802154_IFTYPE_MONITOR)
> > > > > > > > +               return -EPERM;
> > > > > > >
> > > > > > > btw: why are monitors not allowed?
> > > > > >
> > > > > > I guess I had the "active scan" use case in mind which of cours=
e does
> > > > > > not work with monitors. Maybe I can relax this a little bit ind=
eed,
> > > > > > right now I don't remember why I strongly refused scans on moni=
tors.
> > > > >
> > > > > Isn't it that scans really work close to phy level? Means in this=
 case
> > > > > we disable mostly everything of MAC filtering on the transceiver =
side.
> > > > > Then I don't see any reasons why even monitors can't do anything,=
 they
> > > > > also can send something. But they really don't have any specific
> > > > > source address set, so long addresses are none for source address=
es, I
> > > > > don't see any problem here. They also don't have AACK handling, b=
ut
> > > > > it's not required for scan anyway...
> > > >
> > > > I think I remember why I did not want to enable scans on monitors: =
we
> > > > actually change the filtering level to "scan", which is very
> > > > different to what a monitor is supposed to receive, which means in =
scan
> > > > mode a monitor would no longer receive all what it is supposed to
> > > > receive. Nothing that cannot be workaround'ed by software, probably,
> > > > but I believe it is safer right now to avoid introducing potential
> > > > regressions. So I will just change the error code and still refuse
> > > > scans on monitor interfaces for now, until we figure out if it's
> > > > actually safe or not (and if we really want to allow it).
> > > >
> > >
> > > Okay, for scan yes we tell them to be in scan mode and then the
> > > transceiver can filter whatever it delivers to the next level which is
> > > necessary for filtering scan mac frames only. AACK handling is
> > > disabled for scan mode for all types !=3D MONITORS.
> > >
> > > For monitors we mostly allow everything and AACK is _always_ disabled.
> > > The transceiver filter is completely disabled for at least what looks
> > > like a 802.15.4 MAC header (even malformed). There are some frame
> > > length checks which are necessary for specific hardware because
> > > otherwise they would read out the frame buffer. For me it can still
> > > feed the mac802154 stack for scanning (with filtering level as what
> > > the monitor sets to, but currently our scan filter is equal to the
> > > monitor filter mode anyway (which probably can be changed in
> > > future?)). So in my opinion the monitor can do both -> feed the scan
> > > mac802154 deliver path and the packet layer. And I also think that on
> > > a normal interface type the packet layer should be feeded by those
> > > frames as well and do not hit the mac802154 layer scan path only.
> >
> > Actually that would be an out-of-spec situation, here is a quote of
> > chapter "6.3.1.3 Active and passive channel scan"
> >
> >         During an active or passive scan, the MAC sublayer shall
> >         discard all frames received over the PHY data service that are
> >         not Beacon frames.
> >
>=20
> Monitor interfaces are not anything that the spec describes, it is
> some interface type which offers the user (mostly over AF_PACKET raw
> socket) full phy level access with the _default_ options. I already
> run user space stacks (for hacking/development only) on monitor
> interfaces to connect with Linux 802.15.4 interfaces, e.g. see [0]
> (newer came upstream, somewhere I have also a 2 years old updated
> version, use hwsim not fakelb).

:-)

>=20
> In other words, by default it should bypass 802.15.4 MAC and it still
> conforms with your spec, just that it is in user space. However, there
> exists problems to do that, but it kind of works for the most use
> cases. I said here by default because some people have different use
> cases of what they want to do in the kernel. e.g. encryption (so users
> only get encrypted frames, etc.) We don't support that but we can,
> same for doing a scan. It probably requires just more mac802154 layer
> filtering.
>=20
> There are enough examples in wireless that they do "crazy" things and
> you can do that only with SoftMAC transceivers because it uses more
> software parts like mac80211 and HardMAC transceivers only do what the
> spec says and delivers it to the next layer. Some of them have more
> functionality I guess, but then it depends on driver implementation
> and a lot of other things.
>=20
> Monitors also act as a sniffer device, but you _could_ also send
> frames out and then the fun part begins.

Yes, you're right, it's up to us to allow monitor actions.

> > I don't think this is possible to do anyway on devices with a single
> > hardware filter setting?
> >
>=20
> On SoftMAC it need to support a filtering level where we can disable
> all filtering and get 802.15.4 MAC frames like it's on air (even
> without non valid checksum, but we simply don't care if the
> driver/transceiver does not support it we will always confirm it is
> correct again until somebody comes around and say "oh we can do FCS
> level then mac802154 does not need to check on this because it is
> always correct")... This is currently the NONE filtering level I
> think?

But right now we ask for the "scan" filtering, which kind of discards
most frames. Would you like a special config for monitors, like
receiving everything on each channel you jump on? Or shall we stick to
only transmitting beacon frames during a scan on a monitor interface?

I guess it's rather easy to handle in each case. Just let me know what
you prefer. I think I have a small preference for the scan filtering
level, but I'm open.

> For HardMAC it is more complicated; they don't do that, they do the
> "scan" operation on their transceiver and you can dump the result and
> probably never forward any beacon related frames? (I had this question
> once when Michael Richardson replied).

Yes, in this case we'll have to figure out something else...

>=20
> - Alex
>=20
> [0] https://github.com/RIOT-OS/RIOT/pull/5582
>=20

Thanks,
Miqu=C3=A8l

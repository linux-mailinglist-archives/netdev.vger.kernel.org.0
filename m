Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFEA568B863
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 10:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbjBFJNJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 04:13:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjBFJNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 04:13:08 -0500
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [IPv6:2001:4b98:dc4:8::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81EBD1024D;
        Mon,  6 Feb 2023 01:13:02 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 874F5100011;
        Mon,  6 Feb 2023 09:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1675674780;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wSj6D9+MgwE4nuQC3T7B4ND0UbKt+JyGGs2wQulfZHU=;
        b=BhE0hQP8yNWt/GfSw3z25S+kNy1Cz09hUHSNSRIaUTOQRCv8teh5/a/fq7fsHsIlQtvAZ0
        U6nwuiD+mKm52rnjMkTpZGaBNKPvzqXhh9SccCtA/muGJYz9BsD/HOuuHJT2kvocjNTjwR
        nPvrdsX47RKEIox63bPNeFFWOl4aswvVnZPZAoVPZm/ykKSGl6Cb3ISWdJwdR/aLq5Lsij
        H6nZdn3K87IcuE47ZHZ9ll9IHtU4WxdwW3ZVqFzfWg02yMHhYt5vFibqEXlRmHU9iEavgz
        h6Tve4WdQ8NaQEJI8e4k6b/o/5RftATnI8XSCdo9U/5dx4bQVEfO8ePZ0ZFWug==
Date:   Mon, 6 Feb 2023 10:12:35 +0100
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
Message-ID: <20230206101235.0371da87@xps-13>
In-Reply-To: <CAK-6q+iwqVx+6qQ-ctynykdrbN+SHxzk91gQCSdYCUD-FornZA@mail.gmail.com>
References: <20221129160046.538864-1-miquel.raynal@bootlin.com>
        <20221129160046.538864-2-miquel.raynal@bootlin.com>
        <CAK-6q+iwqVx+6qQ-ctynykdrbN+SHxzk91gQCSdYCUD-FornZA@mail.gmail.com>
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

aahringo@redhat.com wrote on Sun, 5 Feb 2023 20:39:32 -0500:

> Hi,
>=20
> On Tue, Nov 29, 2022 at 11:02 AM Miquel Raynal
> <miquel.raynal@bootlin.com> wrote:
> >
> > The ieee802154 layer should be able to scan a set of channels in order
> > to look for beacons advertizing PANs. Supporting this involves adding
> > two user commands: triggering scans and aborting scans. The user should
> > also be notified when a new beacon is received and also upon scan
> > termination.
> >
> > A scan request structure is created to list the requirements and to be
> > accessed asynchronously when changing channels or receiving beacons.
> >
> > Mac layers may now implement the ->trigger_scan() and ->abort_scan()
> > hooks.
> >
> > Co-developed-by: David Girault <david.girault@qorvo.com>
> > Signed-off-by: David Girault <david.girault@qorvo.com>
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > ---
> >  include/linux/ieee802154.h |   3 +
> >  include/net/cfg802154.h    |  25 +++++
> >  include/net/nl802154.h     |  49 +++++++++
> >  net/ieee802154/nl802154.c  | 215 +++++++++++++++++++++++++++++++++++++
> >  net/ieee802154/nl802154.h  |   3 +
> >  net/ieee802154/rdev-ops.h  |  28 +++++
> >  net/ieee802154/trace.h     |  40 +++++++
> >  7 files changed, 363 insertions(+)
> >
> > diff --git a/include/linux/ieee802154.h b/include/linux/ieee802154.h
> > index 0303eb84d596..b22e4147d334 100644
> > --- a/include/linux/ieee802154.h
> > +++ b/include/linux/ieee802154.h
> > @@ -44,6 +44,9 @@
> >  #define IEEE802154_SHORT_ADDR_LEN      2
> >  #define IEEE802154_PAN_ID_LEN          2
> >
> > +/* Duration in superframe order */
> > +#define IEEE802154_MAX_SCAN_DURATION   14
> > +#define IEEE802154_ACTIVE_SCAN_DURATION        15
> >  #define IEEE802154_LIFS_PERIOD         40
> >  #define IEEE802154_SIFS_PERIOD         12
> >  #define IEEE802154_MAX_SIFS_FRAME_SIZE 18
> > diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
> > index d09c393d229f..76d4f95e9974 100644
> > --- a/include/net/cfg802154.h
> > +++ b/include/net/cfg802154.h
> > @@ -18,6 +18,7 @@
> >
> >  struct wpan_phy;
> >  struct wpan_phy_cca;
> > +struct cfg802154_scan_request;
> >
> >  #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
> >  struct ieee802154_llsec_device_key;
> > @@ -67,6 +68,10 @@ struct cfg802154_ops {
> >                                 struct wpan_dev *wpan_dev, bool mode);
> >         int     (*set_ackreq_default)(struct wpan_phy *wpan_phy,
> >                                       struct wpan_dev *wpan_dev, bool a=
ckreq);
> > +       int     (*trigger_scan)(struct wpan_phy *wpan_phy,
> > +                               struct cfg802154_scan_request *request);
> > +       int     (*abort_scan)(struct wpan_phy *wpan_phy,
> > +                             struct wpan_dev *wpan_dev);
> >  #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
> >         void    (*get_llsec_table)(struct wpan_phy *wpan_phy,
> >                                    struct wpan_dev *wpan_dev,
> > @@ -278,6 +283,26 @@ struct ieee802154_coord_desc {
> >         bool gts_permit;
> >  };
> >
> > +/**
> > + * struct cfg802154_scan_request - Scan request
> > + *
> > + * @type: type of scan to be performed
> > + * @page: page on which to perform the scan
> > + * @channels: channels in te %page to be scanned
> > + * @duration: time spent on each channel, calculated with:
> > + *            aBaseSuperframeDuration * (2 ^ duration + 1)
> > + * @wpan_dev: the wpan device on which to perform the scan
> > + * @wpan_phy: the wpan phy on which to perform the scan
> > + */
> > +struct cfg802154_scan_request {
> > +       enum nl802154_scan_types type;
> > +       u8 page;
> > +       u32 channels;
> > +       u8 duration;
> > +       struct wpan_dev *wpan_dev;
> > +       struct wpan_phy *wpan_phy;
> > +};
> > +
> >  struct ieee802154_llsec_key_id {
> >         u8 mode;
> >         u8 id;
> > diff --git a/include/net/nl802154.h b/include/net/nl802154.h
> > index b79a89d5207c..79fbd820b25a 100644
> > --- a/include/net/nl802154.h
> > +++ b/include/net/nl802154.h
> > @@ -73,6 +73,9 @@ enum nl802154_commands {
> >         NL802154_CMD_DEL_SEC_LEVEL,
> >
> >         NL802154_CMD_SCAN_EVENT,
> > +       NL802154_CMD_TRIGGER_SCAN,
> > +       NL802154_CMD_ABORT_SCAN,
> > +       NL802154_CMD_SCAN_DONE,
> >
> >         /* add new commands above here */
> >
> > @@ -134,6 +137,12 @@ enum nl802154_attrs {
> >         NL802154_ATTR_NETNS_FD,
> >
> >         NL802154_ATTR_COORDINATOR,
> > +       NL802154_ATTR_SCAN_TYPE,
> > +       NL802154_ATTR_SCAN_FLAGS,
> > +       NL802154_ATTR_SCAN_CHANNELS,
> > +       NL802154_ATTR_SCAN_PREAMBLE_CODES,
> > +       NL802154_ATTR_SCAN_MEAN_PRF,
> > +       NL802154_ATTR_SCAN_DURATION,
> >
> >         /* add attributes here, update the policy in nl802154.c */
> >
> > @@ -259,6 +268,46 @@ enum nl802154_coord {
> >         NL802154_COORD_MAX,
> >  };
> >
> > +/**
> > + * enum nl802154_scan_types - Scan types
> > + *
> > + * @__NL802154_SCAN_INVALID: scan type number 0 is reserved
> > + * @NL802154_SCAN_ED: An ED scan allows a device to obtain a measure o=
f the peak
> > + *     energy in each requested channel
> > + * @NL802154_SCAN_ACTIVE: Locate any coordinator transmitting Beacon f=
rames using
> > + *     a Beacon Request command
> > + * @NL802154_SCAN_PASSIVE: Locate any coordinator transmitting Beacon =
frames
> > + * @NL802154_SCAN_ORPHAN: Relocate coordinator following a loss of syn=
chronisation
> > + * @NL802154_SCAN_ENHANCED_ACTIVE: Same as Active using Enhanced Beaco=
n Request
> > + *     command instead of Beacon Request command
> > + * @NL802154_SCAN_RIT_PASSIVE: Passive scan for RIT Data Request comma=
nd frames
> > + *     instead of Beacon frames
> > + * @NL802154_SCAN_ATTR_MAX: Maximum SCAN attribute number
> > + */
> > +enum nl802154_scan_types {
> > +       __NL802154_SCAN_INVALID,
> > +       NL802154_SCAN_ED,
> > +       NL802154_SCAN_ACTIVE,
> > +       NL802154_SCAN_PASSIVE,
> > +       NL802154_SCAN_ORPHAN,
> > +       NL802154_SCAN_ENHANCED_ACTIVE,
> > +       NL802154_SCAN_RIT_PASSIVE,
> > +
> > +       /* keep last */
> > +       NL802154_SCAN_ATTR_MAX,
> > +};
> > +
> > +/**
> > + * enum nl802154_scan_flags - Scan request control flags
> > + *
> > + * @NL802154_SCAN_FLAG_RANDOM_ADDR: use a random MAC address for this =
scan (ie.
> > + *     a different one for every scan iteration). When the flag is set=
, full
> > + *     randomisation is assumed.
> > + */
> > +enum nl802154_scan_flags {
> > +       NL802154_SCAN_FLAG_RANDOM_ADDR =3D BIT(0),
> > +};
> > +
> >  /**
> >   * enum nl802154_cca_modes - cca modes
> >   *
> > diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
> > index 80dc73182785..c497ffd8e897 100644
> > --- a/net/ieee802154/nl802154.c
> > +++ b/net/ieee802154/nl802154.c
> > @@ -221,6 +221,12 @@ static const struct nla_policy nl802154_policy[NL8=
02154_ATTR_MAX+1] =3D {
> >
> >         [NL802154_ATTR_COORDINATOR] =3D { .type =3D NLA_NESTED },
> >
> > +       [NL802154_ATTR_SCAN_TYPE] =3D { .type =3D NLA_U8 },
> > +       [NL802154_ATTR_SCAN_CHANNELS] =3D { .type =3D NLA_U32 },
> > +       [NL802154_ATTR_SCAN_PREAMBLE_CODES] =3D { .type =3D NLA_U64 },
> > +       [NL802154_ATTR_SCAN_MEAN_PRF] =3D { .type =3D NLA_U8 },
> > +       [NL802154_ATTR_SCAN_DURATION] =3D { .type =3D NLA_U8 },
> > +
> >  #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
> >         [NL802154_ATTR_SEC_ENABLED] =3D { .type =3D NLA_U8, },
> >         [NL802154_ATTR_SEC_OUT_LEVEL] =3D { .type =3D NLA_U32, },
> > @@ -1384,6 +1390,199 @@ int nl802154_scan_event(struct wpan_phy *wpan_p=
hy, struct wpan_dev *wpan_dev,
> >  }
> >  EXPORT_SYMBOL_GPL(nl802154_scan_event);
> >
> > +static int nl802154_trigger_scan(struct sk_buff *skb, struct genl_info=
 *info)
> > +{
> > +       struct cfg802154_registered_device *rdev =3D info->user_ptr[0];
> > +       struct net_device *dev =3D info->user_ptr[1];
> > +       struct wpan_dev *wpan_dev =3D dev->ieee802154_ptr;
> > +       struct wpan_phy *wpan_phy =3D &rdev->wpan_phy;
> > +       struct cfg802154_scan_request *request;
> > +       u8 type;
> > +       int err;
> > +
> > +       /* Monitors are not allowed to perform scans */
> > +       if (wpan_dev->iftype =3D=3D NL802154_IFTYPE_MONITOR)
> > +               return -EPERM; =20
>=20
> btw: why are monitors not allowed?

I guess I had the "active scan" use case in mind which of course does
not work with monitors. Maybe I can relax this a little bit indeed,
right now I don't remember why I strongly refused scans on monitors.

Thanks,
Miqu=C3=A8l

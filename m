Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48E3D62FFB3
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 23:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbiKRWFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 17:05:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231299AbiKRWE5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 17:04:57 -0500
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A95BB82236;
        Fri, 18 Nov 2022 14:04:49 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 5B2DA1C0003;
        Fri, 18 Nov 2022 22:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1668809087;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0Nfk1cV3NUPjTz3Qf+ohhStt/m/TJSf3Xe/oSioiKU0=;
        b=IKRjlKRb6MKYLFYyOv/N/8zt4lHzsET5QPApcM2ATG3Q5HOaIh/gPVkkWTRof4s9zZiUk/
        39aEOdakuxuw1Z2u+doQGC0jrGRhM3P8y5/rsTyAoXjfp2wXFdJonerCR2z1yjgxzEICJZ
        eHjcpxzqoIBEOBzwMQ9NnFEg6j9oWzHuEJ/SIChQxPY1QNDUq8sGTdUeBz5CqBg2m8W2BY
        9wViUDdFWTXcPUIpKPaz161f4TTDwxsEDypE1zvsfvd3GqeBhMyhxlPH2tvJ/ndfTnPfJa
        2EYL4w0xc6LAu7taH7gAQbFhuojDtPRW8cK491pW6mBRqCjWaA2vmw6GBIz88A==
Date:   Fri, 18 Nov 2022 23:04:43 +0100
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
Subject: Re: [PATCH wpan-next 1/3] ieee802154: Advertize coordinators
 discovery
Message-ID: <20221118230443.2e5ba612@xps-13>
In-Reply-To: <CAK-6q+iSzRyDDiNusXiRWvUsS5dSS5bSzAtNjSLTt6kgaxtbHg@mail.gmail.com>
References: <20221102151915.1007815-1-miquel.raynal@bootlin.com>
        <20221102151915.1007815-2-miquel.raynal@bootlin.com>
        <CAK-6q+iSzRyDDiNusXiRWvUsS5dSS5bSzAtNjSLTt6kgaxtbHg@mail.gmail.com>
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

aahringo@redhat.com wrote on Sun, 6 Nov 2022 21:01:35 -0500:

> Hi,
>=20
> On Wed, Nov 2, 2022 at 11:20 AM Miquel Raynal <miquel.raynal@bootlin.com>=
 wrote:
> >
> > Let's introduce the basics for advertizing discovered PANs and
> > coordinators, which is:
> > - A new "scan" netlink message group.
> > - A couple of netlink command/attribute.
> > - The main netlink helper to send a netlink message with all the
> >   necessary information to forward the main information to the user.
> >
> > Two netlink attributes are proactively added to support future UWB
> > complex channels, but are not actually used yet.
> >
> > Co-developed-by: David Girault <david.girault@qorvo.com>
> > Signed-off-by: David Girault <david.girault@qorvo.com>
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > ---
> >  include/net/cfg802154.h   |  20 +++++++
> >  include/net/nl802154.h    |  44 ++++++++++++++
> >  net/ieee802154/nl802154.c | 121 ++++++++++++++++++++++++++++++++++++++
> >  net/ieee802154/nl802154.h |   6 ++
> >  4 files changed, 191 insertions(+)
> >
> > diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
> > index e1481f9cf049..8d67d9ed438d 100644
> > --- a/include/net/cfg802154.h
> > +++ b/include/net/cfg802154.h
> > @@ -260,6 +260,26 @@ struct ieee802154_addr {
> >         };
> >  };
> >
> > +/**
> > + * struct ieee802154_coord_desc - Coordinator descriptor
> > + * @coord: PAN ID and coordinator address
> > + * @page: page this coordinator is using
> > + * @channel: channel this coordinator is using
> > + * @superframe_spec: SuperFrame specification as received
> > + * @link_quality: link quality indicator at which the beacon was recei=
ved
> > + * @gts_permit: the coordinator accepts GTS requests
> > + * @node: list item
> > + */
> > +struct ieee802154_coord_desc {
> > +       struct ieee802154_addr *addr; =20
>=20
> Why is this a pointer?

No reason anymore, I've changed this member to be a regular structure.

>=20
> > +       u8 page;
> > +       u8 channel;
> > +       u16 superframe_spec;
> > +       u8 link_quality;
> > +       bool gts_permit;
> > +       struct list_head node;
> > +};
> > +
> >  struct ieee802154_llsec_key_id {
> >         u8 mode;
> >         u8 id;
> > diff --git a/include/net/nl802154.h b/include/net/nl802154.h
> > index 145acb8f2509..cfe462288695 100644
> > --- a/include/net/nl802154.h
> > +++ b/include/net/nl802154.h
> > @@ -58,6 +58,9 @@ enum nl802154_commands {
> >
> >         NL802154_CMD_SET_WPAN_PHY_NETNS,
> >
> > +       NL802154_CMD_NEW_COORDINATOR,
> > +       NL802154_CMD_KNOWN_COORDINATOR,
> > + =20
>=20
> NEW is something we never saw before and KNOWN we already saw before?
> I am not getting that when I just want to maintain a list in the user
> space and keep them updated, but I think we had this discussion
> already or? Currently they do the same thing, just the command is
> different. The user can use it to filter NEW and KNOWN? Still I am not
> getting it why there is not just a start ... event, event, event ....
> end. and let the user decide if it knows that it's new or old from its
> perspective.

Actually we already discussed this once and I personally liked more to
handle this in the kernel, but you seem to really prefer letting the
user space device whether or not the beacon is a new one or not, so
I've updated both the kernel side and the userspace side to act like
this.

>=20
> >         /* add new commands above here */
> >
> >  #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
> > @@ -133,6 +136,8 @@ enum nl802154_attrs {
> >         NL802154_ATTR_PID,
> >         NL802154_ATTR_NETNS_FD,
> >
> > +       NL802154_ATTR_COORDINATOR,
> > +
> >         /* add attributes here, update the policy in nl802154.c */
> >
> >  #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
> > @@ -218,6 +223,45 @@ enum nl802154_wpan_phy_capability_attr {
> >         NL802154_CAP_ATTR_MAX =3D __NL802154_CAP_ATTR_AFTER_LAST - 1
> >  };
> >
> > +/**
> > + * enum nl802154_coord - Netlink attributes for a coord
> > + *
> > + * @__NL802154_COORD_INVALID: invalid
> > + * @NL802154_COORD_PANID: PANID of the coordinator (2 bytes)
> > + * @NL802154_COORD_ADDR: coordinator address, (8 bytes or 2 bytes)
> > + * @NL802154_COORD_CHANNEL: channel number, related to @NL802154_COORD=
_PAGE (u8)
> > + * @NL802154_COORD_PAGE: channel page, related to @NL802154_COORD_CHAN=
NEL (u8)
> > + * @NL802154_COORD_PREAMBLE_CODE: Preamble code used when the beacon w=
as received,
> > + *     this is PHY dependent and optional (u8)
> > + * @NL802154_COORD_MEAN_PRF: Mean PRF used when the beacon was receive=
d,
> > + *     this is PHY dependent and optional (u8)
> > + * @NL802154_COORD_SUPERFRAME_SPEC: superframe specification of the PA=
N (u16)
> > + * @NL802154_COORD_LINK_QUALITY: signal quality of beacon in unspecifi=
ed units,
> > + *     scaled to 0..255 (u8)
> > + * @NL802154_COORD_GTS_PERMIT: set to true if GTS is permitted on this=
 PAN
> > + * @NL802154_COORD_PAYLOAD_DATA: binary data containing the raw data f=
rom the
> > + *     frame payload, (only if beacon or probe response had data)
> > + * @NL802154_COORD_PAD: attribute used for padding for 64-bit alignment
> > + * @NL802154_COORD_MAX: highest coordinator attribute
> > + */
> > +enum nl802154_coord {
> > +       __NL802154_COORD_INVALID,
> > +       NL802154_COORD_PANID,
> > +       NL802154_COORD_ADDR,
> > +       NL802154_COORD_CHANNEL,
> > +       NL802154_COORD_PAGE,
> > +       NL802154_COORD_PREAMBLE_CODE, =20
>=20
> Interesting, if you do a scan and discover pans and others answers I
> would think you would see only pans on the same preamble. How is this
> working?

Yes this is how it is working, you only see PANs on one preamble at a
time. That's why we need to tell on which preamble we received the
beacon.

>=20
> > +       NL802154_COORD_MEAN_PRF,
> > +       NL802154_COORD_SUPERFRAME_SPEC,
> > +       NL802154_COORD_LINK_QUALITY, =20
>=20
> not against it to have it, it's fine. I just think it is not very
> useful. A way to dump all LQI values with some timestamp and having
> something in user space to collect stats and do some heuristic may be
> better?

Actually I really like seeing this in the event logs in userspace, so if
you don't mind I'll keep this parameter. It can safely be ignored by the
userspace anyway, so I guess it does not hurt.

>=20
> > +       NL802154_COORD_GTS_PERMIT,
> > +       NL802154_COORD_PAYLOAD_DATA,
> > +       NL802154_COORD_PAD,
> > +
> > +       /* keep last */
> > +       NL802154_COORD_MAX,
> > +};
> > +
> >  /**
> >   * enum nl802154_cca_modes - cca modes
> >   *
> > diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
> > index e0b072aecf0f..f6fb7a228747 100644
> > --- a/net/ieee802154/nl802154.c
> > +++ b/net/ieee802154/nl802154.c
> > @@ -26,10 +26,12 @@ static struct genl_family nl802154_fam;
> >  /* multicast groups */
> >  enum nl802154_multicast_groups {
> >         NL802154_MCGRP_CONFIG,
> > +       NL802154_MCGRP_SCAN,
> >  };
> >
> >  static const struct genl_multicast_group nl802154_mcgrps[] =3D {
> >         [NL802154_MCGRP_CONFIG] =3D { .name =3D "config", },
> > +       [NL802154_MCGRP_SCAN] =3D { .name =3D "scan", },
> >  };
> >
> >  /* returns ERR_PTR values */
> > @@ -216,6 +218,9 @@ static const struct nla_policy nl802154_policy[NL80=
2154_ATTR_MAX+1] =3D {
> >
> >         [NL802154_ATTR_PID] =3D { .type =3D NLA_U32 },
> >         [NL802154_ATTR_NETNS_FD] =3D { .type =3D NLA_U32 },
> > +
> > +       [NL802154_ATTR_COORDINATOR] =3D { .type =3D NLA_NESTED },
> > +
> >  #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
> >         [NL802154_ATTR_SEC_ENABLED] =3D { .type =3D NLA_U8, },
> >         [NL802154_ATTR_SEC_OUT_LEVEL] =3D { .type =3D NLA_U32, },
> > @@ -1281,6 +1286,122 @@ static int nl802154_wpan_phy_netns(struct sk_bu=
ff *skb, struct genl_info *info)
> >         return err;
> >  }
> >
> > +static int nl802154_prep_new_coord_msg(struct sk_buff *msg,
> > +                                      struct cfg802154_registered_devi=
ce *rdev,
> > +                                      struct wpan_dev *wpan_dev,
> > +                                      u32 portid, u32 seq, int flags, =
u8 cmd,
> > +                                      struct ieee802154_coord_desc *de=
sc)
> > +{
> > +       struct nlattr *nla;
> > +       void *hdr;
> > +
> > +       hdr =3D nl802154hdr_put(msg, portid, seq, flags, cmd);
> > +       if (!hdr)
> > +               return -ENOBUFS;
> > +
> > +       if (nla_put_u32(msg, NL802154_ATTR_WPAN_PHY, rdev->wpan_phy_idx=
))
> > +               goto nla_put_failure;
> > +
> > +       if (wpan_dev->netdev &&
> > +           nla_put_u32(msg, NL802154_ATTR_IFINDEX, wpan_dev->netdev->i=
findex))
> > +               goto nla_put_failure;
> > +
> > +       if (nla_put_u64_64bit(msg, NL802154_ATTR_WPAN_DEV,
> > +                             wpan_dev_id(wpan_dev), NL802154_ATTR_PAD))
> > +               goto nla_put_failure;
> > +
> > +       nla =3D nla_nest_start_noflag(msg, NL802154_ATTR_COORDINATOR);
> > +       if (!nla)
> > +               goto nla_put_failure;
> > +
> > +       if (nla_put(msg, NL802154_COORD_PANID, IEEE802154_PAN_ID_LEN,
> > +                   &desc->addr->pan_id))
> > +               goto nla_put_failure;
> > +
> > +       if (desc->addr->mode =3D=3D IEEE802154_ADDR_SHORT) {
> > +               if (nla_put(msg, NL802154_COORD_ADDR,
> > +                           IEEE802154_SHORT_ADDR_LEN,
> > +                           &desc->addr->short_addr))
> > +                       goto nla_put_failure;
> > +       } else {
> > +               if (nla_put(msg, NL802154_COORD_ADDR,
> > +                           IEEE802154_EXTENDED_ADDR_LEN,
> > +                           &desc->addr->extended_addr))
> > +                       goto nla_put_failure;
> > +       }
> > +
> > +       if (nla_put_u8(msg, NL802154_COORD_CHANNEL, desc->channel))
> > +               goto nla_put_failure;
> > +
> > +       if (nla_put_u8(msg, NL802154_COORD_PAGE, desc->page))
> > +               goto nla_put_failure;
> > +
> > +       if (nla_put_u16(msg, NL802154_COORD_SUPERFRAME_SPEC,
> > +                       desc->superframe_spec))
> > +               goto nla_put_failure;
> > +
> > +       if (nla_put_u8(msg, NL802154_COORD_LINK_QUALITY, desc->link_qua=
lity))
> > +               goto nla_put_failure;
> > +
> > +       if (desc->gts_permit && nla_put_flag(msg, NL802154_COORD_GTS_PE=
RMIT))
> > +               goto nla_put_failure;
> > +
> > +       /* TODO: NL802154_COORD_PAYLOAD_DATA if any */
> > +
> > +       nla_nest_end(msg, nla);
> > +
> > +       genlmsg_end(msg, hdr);
> > +
> > +       return 0;
> > +
> > + nla_put_failure:
> > +       genlmsg_cancel(msg, hdr);
> > +
> > +       return -EMSGSIZE;
> > +}
> > +
> > +static int nl802154_advertise_coordinator(struct wpan_phy *wpan_phy,
> > +                                         struct wpan_dev *wpan_dev, u8=
 cmd,
> > +                                         struct ieee802154_coord_desc =
*desc)
> > +{
> > +       struct cfg802154_registered_device *rdev =3D wpan_phy_to_rdev(w=
pan_phy);
> > +       struct sk_buff *msg;
> > +       int ret;
> > +
> > +       msg =3D nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
> > +       if (!msg)
> > +               return -ENOMEM;
> > +
> > +       ret =3D nl802154_prep_new_coord_msg(msg, rdev, wpan_dev, 0, 0, =
0, cmd, desc);
> > +       if (ret < 0) {
> > +               nlmsg_free(msg);
> > +               return ret;
> > +       }
> > +
> > +       return genlmsg_multicast_netns(&nl802154_fam, wpan_phy_net(wpan=
_phy),
> > +                                      msg, 0, NL802154_MCGRP_SCAN, GFP=
_ATOMIC);
> > +} =20
>=20
> ah, okay that answers my previous question... regarding the trace event.
>=20
> - Alex
>=20


Thanks,
Miqu=C3=A8l

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4A0755144A
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 11:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240672AbiFTJ0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 05:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240661AbiFTJ0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 05:26:49 -0400
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 623D412D20;
        Mon, 20 Jun 2022 02:26:48 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 8D26E1C0006;
        Mon, 20 Jun 2022 09:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1655717207;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BjEJ00h/h9s7Mts4kYrpWW5OrcmrFoJTYskT9VkugVY=;
        b=Zlb4Wdsl1v4gXO2cHelFeqDMq9k7gYIuWefCzsZstAWYsnnzAKX9tRJ0JCaWvlT3XCwICR
        V4WZNyDp/+FXSd/5Ckm056Zzjih04gNTFWQtHNeCquBwgoxXIax6iYlLD4veXBCZxeURin
        gOK6gYgn5+pSQiPYcFlRHJonOX42RUSuWWUaayZcXw276/ACjWsIUg9IzMknEyPTike1o2
        QF7EerdVPfcxjv4tI3kL06P7s/6EHFm0Asi68g1gEg6hdLlgmGt9rQvjOU4qgpp8IJOVD6
        HH7ZrVHRMNrtOXA8AdAO9oRtMq2k8HSBAttYAMc1ceLX5EopkTt7XErQkFRIEA==
Date:   Mon, 20 Jun 2022 11:26:44 +0200
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
Subject: Re: [PATCH wpan-next v2 1/6] net: ieee802154: Create a device type
Message-ID: <20220620112527.48c7ba54@xps-13>
In-Reply-To: <CAK-6q+g7pd14Bhng9r210kROttwtqQkF1JgAF283B9MPc22g3g@mail.gmail.com>
References: <20220617193254.1275912-1-miquel.raynal@bootlin.com>
        <20220617193254.1275912-2-miquel.raynal@bootlin.com>
        <CAK-6q+g7pd14Bhng9r210kROttwtqQkF1JgAF283B9MPc22g3g@mail.gmail.com>
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

Hi Alex,

aahringo@redhat.com wrote on Sun, 19 Jun 2022 20:18:43 -0400:

> Hi,
>=20
> On Fri, Jun 17, 2022 at 3:35 PM Miquel Raynal <miquel.raynal@bootlin.com>=
 wrote:
> >
> > A device can be either a fully functioning device or a kind of reduced
> > functioning device. Let's create a device type member. Drivers will be
> > in charge of setting this value if they handle non-FFD devices.
> >
> > FFD are considered the default.
> >
> > Provide this information in the interface get netlink command.
> >
> > Create a helper just to check if a rdev is a FFD or not, which will
> > then be useful when bringing scan support.
> >
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > ---
> >  include/net/nl802154.h    | 9 +++++++++
> >  net/ieee802154/core.h     | 8 ++++++++
> >  net/ieee802154/nl802154.c | 6 +++++-
> >  3 files changed, 22 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/net/nl802154.h b/include/net/nl802154.h
> > index 145acb8f2509..5258785879e8 100644
> > --- a/include/net/nl802154.h
> > +++ b/include/net/nl802154.h
> > @@ -133,6 +133,8 @@ enum nl802154_attrs {
> >         NL802154_ATTR_PID,
> >         NL802154_ATTR_NETNS_FD,
> >
> > +       NL802154_ATTR_DEV_TYPE,
> > +
> >         /* add attributes here, update the policy in nl802154.c */
> >
> >  #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
> > @@ -163,6 +165,13 @@ enum nl802154_iftype {
> >         NL802154_IFTYPE_MAX =3D NUM_NL802154_IFTYPES - 1
> >  };
> >
> > +enum nl802154_dev_type {
> > +       NL802154_DEV_TYPE_FFD =3D 0,
> > +       NL802154_DEV_TYPE_RFD,
> > +       NL802154_DEV_TYPE_RFD_RX,
> > +       NL802154_DEV_TYPE_RFD_TX,
> > +}; =20
>=20
> As I said in another mail, I think this is a "transceiver capability"

Maybe I can rename it to PHY_TYPE if you prefer.

> why it is required that a user sets a transceiver capability. It means
> that you can actually buy hardware which is either one of those
> capabilities, one reason why D in those acronyms stands for "Device".

The user is not supposed to set this field, but it can get this field.
This is what this enumeration is intended for.=20

> In SoftMac you probably find only FFD but out there you would probably
> find hardware which cannot run as e.g. coordinator and is a RFD.

My main concern was initially to be sure that we would not try to
perform any unsupported MLME commands on these devices. But as you said
in another mail, it is highly unlikely that we will ever have to support
true RFD devices in Linux, so I can just drop this parameter.

Thanks,
Miqu=C3=A8l

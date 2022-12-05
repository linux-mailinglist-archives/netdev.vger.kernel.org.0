Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60B61642638
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 10:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231375AbiLEJ6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 04:58:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbiLEJ6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 04:58:01 -0500
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D7AE388C;
        Mon,  5 Dec 2022 01:57:59 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 9E4024000E;
        Mon,  5 Dec 2022 09:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1670234277;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4Gxz7WoOpZc0oMoubYIgxVAsBpiZ8Y3OlcwRGN7ckt8=;
        b=cWl+MEYxC7EUwcQ8ogqjr6IoLd4jUvzjzg26vj7RG6MHklpBrsd0jcCjmcWY8swzpOoAT5
        aDOHeyPjx6R68TdVlwlNrstEBefSKoH3X1DtXfBtzNBcdReyR0TlgKtwsTOspgTH1AEUSK
        lAHUZpit6hr9Zh1xN1b8M1njrJIZ8WppmkooKFGHFVT1xMQIsk90+TP3XL2P3zDK2BQ1pf
        5+lWFSu/pcBQKzqRf3WJas5CrGLjdwo1n8wwxtZK8WQQMfRg1GQMbM3eoFCI+lFreO09hf
        kHIpTQeHchO/yTkAqB5QmygnzbekNnEPHwL8UREUiZr5sYJqyhVavoGF1mO/Ug==
Date:   Mon, 5 Dec 2022 10:57:52 +0100
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
Message-ID: <20221205105752.6ce87721@xps-13>
In-Reply-To: <CAK-6q+hjXKmOrf-p=hRzuD=4pOJeWNUu46iU8YAVL4BqWC437A@mail.gmail.com>
References: <20221129160046.538864-1-miquel.raynal@bootlin.com>
        <20221129160046.538864-2-miquel.raynal@bootlin.com>
        <CAK-6q+hjXKmOrf-p=hRzuD=4pOJeWNUu46iU8YAVL4BqWC437A@mail.gmail.com>
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

aahringo@redhat.com wrote on Sun, 4 Dec 2022 17:44:24 -0500:

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
> > +       NL802154_CMD_SCAN_DONE, =20
>=20
> Is NL802154_CMD_SCAN_DONE reserved now? I don't see it implemented in
> this series and I think we had some discussion about the need of abort
> vs done. Is the event now?

To be very honest I went back and forth about the "abort" information
so I don't remember exactly what was supposed to be implemented. The
current implementation forwards to userspace the reason (whether the
scan was finished or was aborted for an external reason). So it is
implemented this way:

* Patch 6/6 adds in mac802154/scan.c:

+       cmd =3D aborted ? NL802154_CMD_ABORT_SCAN : NL802154_CMD_SCAN_DONE;
+       nl802154_scan_done(wpan_phy, wpan_dev, cmd);

* And in patch 1/6, in ieee802154/nl802154.c:

+static int nl802154_send_scan_msg(struct cfg802154_registered_device *rdev,
+                                 struct wpan_dev *wpan_dev, u8 cmd)
+{
[...]
+
+       ret =3D nl802154_prep_scan_msg(msg, rdev, wpan_dev, 0, 0, 0, cmd);

Is this working for you?

Thanks,
Miqu=C3=A8l

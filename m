Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2945D5B15C3
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 09:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbiIHHhA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 03:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbiIHHg7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 03:36:59 -0400
Received: from relay10.mail.gandi.net (relay10.mail.gandi.net [217.70.178.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD4C1BCCF4;
        Thu,  8 Sep 2022 00:36:54 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 31ACA240008;
        Thu,  8 Sep 2022 07:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1662622613;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ot1OCH0XE7vuVQNBMm5PA+hO9WFmQKMyOZ0Ey/IcXCk=;
        b=YU7vRzEtKKIMoivaAPW4AQWetOdiR16xcdcLtpGptKxr5luBCSD3T5MTK90GTwVwfB4fhw
        3PpI755PJvo6BUWotZVCnu9UWOy7u5AHjqlMGc6tIYGHq+AUl55X7qJE+u03fTfZ5gkkFb
        eAGSC/rLj44b8nPOH2EwoOrW8zzZttqyMDqbkqJ0WseQDodFBnJcYiOpn6wzw+hNO1Gm5z
        DvirSisNF6sUMFi3inDA6xJsH4i5cNsscnxToRJP6nYR3nfWbpAa2C8GLIAWSOtOlGB0+O
        C5bJxSqMYMpiyzDQ42DtFkU4Yi+SWPIPLTMRYEWXTsxxHhFVA0GNvdMDyl7ljg==
Date:   Thu, 8 Sep 2022 09:36:48 +0200
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
Subject: Re: [PATCH wpan/next v3 0/9] net: ieee802154: Support
 scanning/beaconing
Message-ID: <20220908093648.5bae41b2@xps-13>
In-Reply-To: <CAK-6q+g64BTFsHKKwoCqRGEERRgwoMSTX2LJMQMmmRseWBi=hQ@mail.gmail.com>
References: <20220905203412.1322947-1-miquel.raynal@bootlin.com>
        <CAK-6q+g64BTFsHKKwoCqRGEERRgwoMSTX2LJMQMmmRseWBi=hQ@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

aahringo@redhat.com wrote on Wed, 7 Sep 2022 21:40:13 -0400:

> Hi,
>=20
> On Mon, Sep 5, 2022 at 4:34 PM Miquel Raynal <miquel.raynal@bootlin.com> =
wrote:
> >
> > Hello,
> >
> > A third version of this series, dropping the scan patches for now
> > because before we need to settle on the filtering topic and the
> > coordinator interface topic. Here is just the filtering part, I've
> > integrated Alexander's patches, as well as the atusb fix. Once this is
> > merge there are a few coordinator-related patches, and finally the
> > scan. =20
>=20
> I think we have a communication problem here and we should talk about
> what the problems are and agree on a way to solve them.
>=20
> The problems are:
>=20
> 1. We never supported switching from an operating phy (interfaces are
> up) into another filtering mode.

In the trigger scan path there is a:

	mlme_op_pre() // stop Tx
	drv_stop() // stop Rx
	synchronize_net()
	drv_start(params) // restart Rx with another hw filtering level

> 2. Scan requires to be in "promiscuous mode" (according to the
> 802.15.4 spec promiscuous mode). We don't support promiscuous mode
> (according to the 802.15.4 spec promiscuous mode). We "can" however
> use the currently supported mode which does not filter anything
> (IEEE802154_FILTERING_NONE) when we do additional filtering in
> mac802154. _But_ this is only required when the phy is scanning, it
> will also deliver anything to the upper layers.
>=20
> This patch-series tries to do the second thing, okay that's fine. But
> I thought this should only be done while the phy is in "scanning
> mode"?

I don't understand what's wrong then. We ask for the "scan mode"
filtering level when starting the scan [1] and we ask for the normal
filtering level when it's done/aborted [2] [3].

[1] https://github.com/miquelraynal/linux/blob/wpan-next/scan/net/mac802154=
/scan.c#L326
[2] https://github.com/miquelraynal/linux/blob/wpan-next/scan/net/mac802154=
/scan.c#L55

> The other receive path while not in promiscuous mode
> (phy->filtering =3D=3D IEEE802154_FILTERING_4_FRAME_FIELDS) should never
> require any additional filtering. I somehow miss this point here.

Maybe the drv_start() function should receive an sdata pointer. This way
instead of changing the PHY filtering level to what has just be asked
blindly, the code should look at the filtering level of all the
interfaces up on the PHY and apply the lowest filtering level by
hardware, knowing that on a per interface basis, the software will
compensate.

It should work just fine because local->phy->filtering shows the actual
filtering level of the PHY while sdata->requested_filtering shows the
level of filtering that was expected on each interface. If you don't
like the idea of having a mutable sdata->requested_filtering entry, I
can have an sdata->base_filtering which should only be set by
ieee802154_setup_sdata() and an sdata->expected_filtering which would
reflect what the mac expects on this interface at the present moment.

> For 1), the driver should change the filtering mode" when we start to
> "listen", this is done by the start() driver callback. They should get
> all receive parameters and set up receiving to whatever mac802154,
> currently there is a bit of chaos there. To move it into drv_start()
> is just a workaround to begin this step that we move it at some point
> to the driver. I mention 1) here because that should be part of the
> picture how everything works together when the phy is switched to a
> different filter level while it's operating (I mean there are running
> interfaces on it which requires IEEE802154_FILTERING_4_FRAME_FIELDS)
> which then activates the different receive path for the use case of
> scanning (something like (phy->state & WPANPHY_SCANING) =3D=3D true)?

Scanning is a dedicated filtering level per-se because it must discard
!beacon frames, that's why I request this level of filtering (which
maybe I should do on a per-interface basis instead of using the *local
poiner).

> I am sorry, but I somehow miss the picture of how those things work
> together. It is not clear for me and I miss those parts to get a whole
> picture of this. For me it's not clear that those patches are going in
> this direction.

Please tell me if it's more clear and if you agree with this vision. I
don't have time to draft something this week.

Thanks,
Miqu=C3=A8l

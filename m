Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 517276E2642
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 16:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbjDNOzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 10:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbjDNOzO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 10:55:14 -0400
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2336865A8;
        Fri, 14 Apr 2023 07:55:11 -0700 (PDT)
Received: (Authenticated sender: herve.codina@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 14271240002;
        Fri, 14 Apr 2023 14:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1681484110;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qYy47sl74TgDHd1JkFN/WszmVyDzzzCSFWb60vPYy+0=;
        b=S8uYckW7R+GfvkffcwP4D4MY1ukU9yz+ZPzKL+N3hwVDwDtAEe7tj5uKF58Q2y1BtBS0EZ
        YULYeii9S4yLhFQRedV0sLv3CbhMQGcqwEzKlVqDoWTnV+jnHloHa7YejLyIPHk+G8fu6D
        D6GVwBkKndJ1yckKs/xip2ON356TsIUCx88umFwgmFkrx05Cvd9P/W/OBv0zlb/zxj/fwb
        /Re15kObG7sv6pephz1IW0xLrr3KdG5nSuwV/O7iGayX4UDGBi9pvU68d6CJtQBPBs9+j+
        9MvE7kIOxNoVXDdxGF8oVhwXindJhPQXWRN/I9bhmM+6n6Zwyv6m+k/glh0nMQ==
Date:   Fri, 14 Apr 2023 16:55:04 +0200
From:   Herve Codina <herve.codina@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-phy@lists.infradead.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [RFC PATCH 0/4] Add support for QMC HDLC and PHY
Message-ID: <20230414165504.7da4116f@bootlin.com>
In-Reply-To: <885e4f20-614a-4b8e-827e-eb978480af87@lunn.ch>
References: <20230323103154.264546-1-herve.codina@bootlin.com>
        <885e4f20-614a-4b8e-827e-eb978480af87@lunn.ch>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.37; x86_64-redhat-linux-gnu)
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

Hi Andrew,

On Thu, 13 Apr 2023 14:48:30 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> On Thu, Mar 23, 2023 at 11:31:50AM +0100, Herve Codina wrote:
> > Hi,
> >=20
> > I have a system where I need to handle an HDLC interface.
> >=20
> > The HDLC data are transferred using a TDM bus on which a PEF2256 is
> > present. The PEF2256 transfers data from/to the TDM bus to/from E1 line.
> > This PEF2256 is also connected to a PowerQUICC SoC for the control path
> > and the TDM is connected to the SoC (QMC component) for the data path.
> >=20
> > From the HDLC driver, I need to handle data using the QMC and carrier
> > detection using the PEF2256 (E1 line carrier).
> >=20
> > The HDLC driver consider the PEF2256 as a generic PHY.
> > So, the design is the following:
> >=20
> > +----------+          +-------------+              +---------+
> > | HDLC drv | <-data-> | QMC channel | <-- TDM -->  | PEF2256 |
> > +----------+          +-------------+              |         | <--> E1
> >    ^   +---------+     +---------+                 |         |
> >    +-> | Gen PHY | <-> | PEF2256 | <- local bus -> |         |
> >        +---------+     | PHY drv |                 +---------+
> >                        +---------+ =20
>=20
> Hi Herver
>=20
> Sorry, i'm late to the conversation. I'm looking at this from two
> different perspectives. I help maintain Ethernet PHYs. And i have
> hacked on the IDT 82P2288 E1/T1/J1 framer.
>=20
> I think there is a block missing from this diagram. There appears to
> be an MFD driver for the PEF2256? At least, i see an include for
> linux/mfd/pef2256.h.

Indeed, there is the MFD driver and this MFD driver does the PEF2256
setup (line configuration, speed, ...).

>=20
> When i look at the 'phy' driver, i don't see anything a typical PHY
> driver used for networking would have. A networking PHY driver often
> has the ability to change between modes, like SGMII, QSGMII, 10GBASER.
> The equivalent here would be changing between E1, T1 and J1. It has
> the ability to change the speed, 1G, 2.5G, 10G etc. This could be
> implied via the mode, E1 is 2.048Mbps, T1 1.544Mbps, and i forget what
> J1 is. The PEF2256 also seems to support E1/T1/J1. How is its modes
> configured?

All of these are set by the MFD driver during its probe().
The expected setting come from several properties present in the pef2256
DT node. The binding can be found here:
  https://lore.kernel.org/all/20230328092645.634375-2-herve.codina@bootlin.=
com/

Further more, the QMC HDLC is not the only PEF2256 consumer.
The PEF2256 is also used for audio path (ie audio over E1) and so the
configuration is shared between network and audio. The setting cannot be
handle by the network part as the PEF2256 must be available and correctly
configured even if the network part is not present.

>=20
> In fact, this PHY driver does not seem to do any configuration of any
> sort on the framer. All it seems to be doing is take notification from
> one chain and send them out another chain!

Configuration is done by the parent MFD driver.
The PHY driver has nothing more to do.

>=20
> I also wounder if this get_status() call is sufficient. Don't you also
> want Red, Yellow and Blue alarms? It is not just the carrier is down,
> but why it is down.

I don't need them in my use case but if needed can't they be added later?
Also, from the HDLC device point of view what can be done with these alarms?

>=20
> Overall, i don't see why you want a PHY. What value does it add?

I need to detect carrier on/off according to the E1 link state.
The HDLC driver is a driver for a QMC device.
The QMC device present in some PowerPC SOC offers the possibility to send
data over a TDM bus.
=46rom the QMC HDLC driver I don't want to refer the PEF2256 as the driver has
nothing to do with the PEF2256 directly.
The QMC HDLC driver send data to a TDM bus using the QMC device.

The PEF2256 is an interface in the data path between the QMC output (TDM bu=
s) and
the E1 line.

We send HDLC over E1 because there is this kind of interface but we would
have sent HDLC over anything else if this interface was different.

Using a PHY to represent this interface was coherent for me.
Using the generic PHY subsystem allows to abstract the specific provider (P=
EF2256)
from the consumer (QMC HDLC).

Best regards,
Herv=C3=A9

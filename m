Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C022522F4C
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 11:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238555AbiEKJXF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 05:23:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238018AbiEKJXD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 05:23:03 -0400
X-Greylist: delayed 964 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 11 May 2022 02:23:00 PDT
Received: from smtp16.bhosted.nl (smtp16.bhosted.nl [IPv6:2a02:9e0:8000::27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9135A7A804
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 02:22:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=protonic.nl; s=202111;
        h=content-transfer-encoding:content-type:mime-version:references:in-reply-to:
         message-id:subject:cc:to:from:date:from;
        bh=n2xPqgvtWv5KMPWGWD4jNRZDCTudAr2aEHyO5J86aqQ=;
        b=qYrSZo1cxYNIL8va3yr4DdJVks7DrzkR67viN5/7E68OKxujiGfglvzwgL5LFf0d3TNVUduU4IARg
         phaMrIfqIkGEY+JkctXPWopo52PVZosqpf7b5LQlE2mGE8MVhBcDY8DOYTOFo8unC93HD7iK5hiwO4
         cqlo2J/gdIPjL0fzeGx2EXQ+OjpacdlRsAVY9wl3h6xRZQDRDVZGaNNbc5QMbh38BdDJdgV5sMlf0x
         cvJfBqHqZckdnPiCuQNr+zhmQSIVuimPN6UBNJIsSlu/hJMXCbnqNlY7ycptwzFAKRaBUxyTqAevxx
         S9aWyHqFV4Q5tQ27FdgUAuzN9uaf5gw==
X-MSG-ID: b1117358-d109-11ec-9896-0050569d2c73
Date:   Wed, 11 May 2022 11:06:49 +0200
From:   David Jander <david@protonic.nl>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Devid Antonio Filoni <devid.filoni@egluetechnologies.com>,
        Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>,
        Robin van der Gracht <robin@protonic.nl>,
        kernel@pengutronix.de, linux-can@vger.kernel.org,
        Oleksij Rempel <linux@rempel-privat.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Jayat <maxime.jayat@mobile-devices.fr>,
        kbuild test robot <lkp@intel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] can: j1939: do not wait 250ms if the same addr
 was already claimed
Message-ID: <20220511110649.21cc1f65@erd992>
In-Reply-To: <20220511084728.GD10669@pengutronix.de>
References: <20220509170303.29370-1-devid.filoni@egluetechnologies.com>
        <YnllpntZ8V5CD07v@x1.vandijck-laurijssen.be>
        <20220510042609.GA10669@pengutronix.de>
        <ce7da10389fe448efee86d788dd5282b8022f92e.camel@egluetechnologies.com>
        <20220511084728.GD10669@pengutronix.de>
Organization: Protonic Holland
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi,

On Wed, 11 May 2022 10:47:28 +0200
Oleksij Rempel <o.rempel@pengutronix.de> wrote:

> Hi,
>=20
> i'll CC more J1939 users to the discussion.

Thanks for the CC.

> On Tue, May 10, 2022 at 01:00:41PM +0200, Devid Antonio Filoni wrote:
> > Hi,
> >=20
> > On Tue, 2022-05-10 at 06:26 +0200, Oleksij Rempel wrote: =20
> > > Hi,
> > >=20
> > > On Mon, May 09, 2022 at 09:04:06PM +0200, Kurt Van Dijck wrote: =20
> > > > On ma, 09 mei 2022 19:03:03 +0200, Devid Antonio Filoni wrote: =20
> > > > > This is not explicitly stated in SAE J1939-21 and some tools used=
 for
> > > > > ISO-11783 certification do not expect this wait. =20
> > >=20
> > > It will be interesting to know which certification tool do not expect=
 it and
> > > what explanation is used if it fails?
> > >  =20
> > > > IMHO, the current behaviour is not explicitely stated, but nor is t=
he opposite.
> > > > And if I'm not mistaken, this introduces a 250msec delay.
> > > >=20
> > > > 1. If you want to avoid the 250msec gap, you should avoid to contes=
t the same address.
> > > >=20
> > > > 2. It's a balance between predictability and flexibility, but if yo=
u try to accomplish both,
> > > > as your patch suggests, there is slight time-window until the curre=
nt owner responds,
> > > > in which it may be confusing which node has the address. It depends=
 on how much history
> > > > you have collected on the bus.
> > > >=20
> > > > I'm sure that this problem decreases with increasing processing pow=
er on the nodes,
> > > > but bigger internal queues also increase this window.
> > > >=20
> > > > It would certainly help if you describe how the current implementat=
ion fails.
> > > >=20
> > > > Would decreasing the dead time to 50msec help in such case.
> > > >=20
> > > > Kind regards,
> > > > Kurt
> > > >  =20
> > >  =20
> >=20
> > The test that is being executed during the ISOBUS compliance is the
> > following: after an address has been claimed by a CF (#1), another CF
> > (#2) sends a  message (other than address-claim) using the same address
> > claimed by CF #1.
> >=20
> > As per ISO11783-5 standard, if a CF receives a message, other than the
> > address-claimed message, which uses the CF's own SA, then the CF (#1):
> > - shall send the address-claim message to the Global address;
> > - shall activate a diagnostic trouble code with SPN =3D 2000+SA and FMI=
 =3D
> > 31
> >=20
> > After the address-claim message is sent by CF #1, as per ISO11783-5
> > standard:
> > - If the name of the CF #1 has a lower priority then the one of the CF
> > #2, the the CF #2 shall send its address-claim message and thus the CF
> > #1 shall send the cannot-claim-address message or shall execute again
> > the claim procedure with a new address
> > - If the name of the CF #1 has higher priority then the of the CF #2,
> > then the CF #2 shall send the cannot-claim-address message or shall
> > execute the claim procedure with a new address
> >=20
> > Above conflict management is OK with current J1939 driver
> > implementation, however, since the driver always waits 250ms after
> > sending an address-claim message, the CF #1 cannot set the DTC. The DM1
> > message which is expected to be sent each second (as per J1939-73
> > standard) may not be sent.
> >=20
> > Honestly, I don't know which company is doing the ISOBUS compliance
> > tests on our products and which tool they use as it was choosen by our
> > customer, however they did send us some CAN traces of previously
> > performed tests and we noticed that the DM1 message is sent 160ms after
> > the address-claim message (but it may also be lower then that), and this
> > is something that we cannot do because the driver blocks the application
> > from sending it.
> >=20
> > 28401.127146 1  18E6FFF0x    Tx   d 8 FE 26 FF FF FF FF FF FF  //Message
> > with other CF's address
> > 28401.167414 1  18EEFFF0x    Rx   d 8 15 76 D1 0B 00 86 00 A0  //Address
> > Claim - SA =3D F0
> > 28401.349214 1  18FECAF0x    Rx   d 8 FF FF C0 08 1F 01 FF FF  //DM1
> > 28402.155774 1  18E6FFF0x    Tx   d 8 FE 26 FF FF FF FF FF FF  //Message
> > with other CF's address
> > 28402.169455 1  18EEFFF0x    Rx   d 8 15 76 D1 0B 00 86 00 A0  //Address
> > Claim - SA =3D F0
> > 28402.348226 1  18FECAF0x    Rx   d 8 FF FF C0 08 1F 02 FF FF  //DM1
> > 28403.182753 1  18E6FFF0x    Tx   d 8 FE 26 FF FF FF FF FF FF  //Message
> > with other CF's address
> > 28403.188648 1  18EEFFF0x    Rx   d 8 15 76 D1 0B 00 86 00 A0  //Address
> > Claim - SA =3D F0
> > 28403.349328 1  18FECAF0x    Rx   d 8 FF FF C0 08 1F 03 FF FF  //DM1
> > 28404.349406 1  18FECAF0x    Rx   d 8 FF FF C0 08 1F 03 FF FF  //DM1
> > 28405.349740 1  18FECAF0x    Rx   d 8 FF FF C0 08 1F 03 FF FF  //DM1
> >=20
> > Since the 250ms wait is not explicitly stated, IMHO it should be up to
> > the user-space implementation to decide how to manage it.

I think this is not entirely correct. AFAICS the 250ms wait is indeed
explicitly stated.
The following is taken from ISO 11783-5:

In "4.4.4.3 Address violation" it states that "If a CF receives a message,
other than the address-claimed message, which uses the CF=E2=80=99s own SA,=
 then the
CF [...] shall send the address-claim message to the Global address."

So the CF shall claim its address again. But further down, in "4.5.2 Address
claim requirements" it is stated that "...No CF shall begin, or resume,
transmission on the network until 250 ms after it has successfully claimed =
an
address".

At this moment, the address is in dispute. The affected CFs are not allowed=
 to
send any other messages until this dispute is resolved, and the standard
requires a waiting time of 250ms which is minimally deemed necessary to give
all participants time to respond and eventually dispute the address claim.

If the offending CF ignores this dispute and keeps sending incorrect messag=
es
faster than every 250ms, then effectively the other CF has no chance to ever
resume normal operation because its address is still disputed.

According to 4.4.4.3 it is also required to set a DTC, but it will not be
allowed to send the DM1 message unless the address dispute is resolved.

This effectively leads to the offending CF to DoS the affected CF if it kee=
ps
sending offending messages. Unfortunately neither J1939 nor ISObus takes in=
to
account adversarial behavior on the CAN network, so we cannot do anything
about this.

As for the ISObus compliance tool that is mentioned by Devid, IMHO this
compliance tool should be challenged and fixed, since it is broken.

The networking layer is prohibiting the DM1 message to be sent, and the
networking layer has precedence above all superior protocol layers, so the
diagnostics layer is not able to operate at this moment.

Best regards,

--=20
David Jander
Protonic Holland.

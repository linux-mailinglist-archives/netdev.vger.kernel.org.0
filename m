Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 046DF62E01A
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 16:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239401AbiKQPjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 10:39:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234952AbiKQPjJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 10:39:09 -0500
X-Greylist: delayed 964 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 17 Nov 2022 07:39:02 PST
Received: from smtp28.bhosted.nl (smtp28.bhosted.nl [IPv6:2a02:9e0:8000::40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5975B6373
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 07:39:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=protonic.nl; s=202111;
        h=content-transfer-encoding:content-type:mime-version:references:in-reply-to:
         message-id:subject:cc:to:from:date:from;
        bh=Qo1JiN1QWqUSI6yhuwoElw/UWt81bTiyqdVKcnwge6s=;
        b=OBKLikrOSODt4wcD5DtOy5ciQ50brTEGY+rcjmbeMFPATp4un0xJk6ozgCHEDUsoCMTcW2MbHSW6i
         DUw5sOSm1dzDXyVynU7zej180UW7Fgz1yCzmGXJb8E+DwIHzhO3w3QREgHEJCdRJP1b0sup8hD/0cj
         BWfnllP6ONjGqr+YIvOmpKcPRcwjO8hgCG0h5g4tOjJDUuyET6iHaMKrjT+RPyG0RMv4ieb47gSqGE
         MJT4kEaWm9ksnDNdn8YsFhDLVWf6zWxYQqRriiaURc8FMkykeMfK+uPU+Mj2ByWVg87fBcVeB5KNLA
         SoDegYfkNCsW9qKgCZRtPXoQnmP++PA==
X-MSG-ID: b3ae8148-668b-11ed-94b5-0050569d11ae
Date:   Thu, 17 Nov 2022 16:22:51 +0100
From:   David Jander <david@protonic.nl>
To:     Devid Antonio Filoni <devid.filoni@egluetechnologies.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
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
Message-ID: <20221117162251.5e5933c1@erd992>
In-Reply-To: <e0f6b26e2c724439752f3c13b53af1a56a42a5bf.camel@egluetechnologies.com>
References: <20220509170303.29370-1-devid.filoni@egluetechnologies.com>
        <YnllpntZ8V5CD07v@x1.vandijck-laurijssen.be>
        <20220510042609.GA10669@pengutronix.de>
        <ce7da10389fe448efee86d788dd5282b8022f92e.camel@egluetechnologies.com>
        <20220511084728.GD10669@pengutronix.de>
        <20220511110649.21cc1f65@erd992>
        <baaf0b8b237a2e6a8f99faca60112919d79cf549.camel@egluetechnologies.com>
        <20220511162247.2cf3fb2e@erd992>
        <3566cba652c64641603fd0ad477e2c90cd77655b.camel@egluetechnologies.com>
        <e0f6b26e2c724439752f3c13b53af1a56a42a5bf.camel@egluetechnologies.com>
Organization: Protonic Holland
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Nov 2022 15:08:20 +0100
Devid Antonio Filoni <devid.filoni@egluetechnologies.com> wrote:

> On Fri, 2022-05-13 at 11:46 +0200, Devid Antonio Filoni wrote:
> > Hi David,
> >=20
> > On Wed, 2022-05-11 at 16:22 +0200, David Jander wrote: =20
> > > Hi Devid,
> > >=20
> > > On Wed, 11 May 2022 14:55:04 +0200
> > > Devid Antonio Filoni <
> > > devid.filoni@egluetechnologies.com =20
> > > > wrote: =20
> > >  =20
> > > > On Wed, 2022-05-11 at 11:06 +0200, David Jander wrote: =20
> > > > > Hi,
> > > > >=20
> > > > > On Wed, 11 May 2022 10:47:28 +0200
> > > > > Oleksij Rempel <
> > > > > o.rempel@pengutronix.de
> > > > >    =20
> > > > > > wrote:   =20
> > > > >=20
> > > > >    =20
> > > > > > Hi,
> > > > > >=20
> > > > > > i'll CC more J1939 users to the discussion.   =20
> > > > >=20
> > > > > Thanks for the CC.
> > > > >    =20
> > > > > > On Tue, May 10, 2022 at 01:00:41PM +0200, Devid Antonio Filoni =
wrote:   =20
> > > > > > > Hi,
> > > > > > >=20
> > > > > > > On Tue, 2022-05-10 at 06:26 +0200, Oleksij Rempel wrote:     =
=20
> > > > > > > > Hi,
> > > > > > > >=20
> > > > > > > > On Mon, May 09, 2022 at 09:04:06PM +0200, Kurt Van Dijck wr=
ote:     =20
> > > > > > > > > On ma, 09 mei 2022 19:03:03 +0200, Devid Antonio Filoni w=
rote:     =20
> > > > > > > > > > This is not explicitly stated in SAE J1939-21 and some =
tools used for
> > > > > > > > > > ISO-11783 certification do not expect this wait.     =20
> > > > > > > >=20
> > > > > > > > It will be interesting to know which certification tool do =
not expect it and
> > > > > > > > what explanation is used if it fails?
> > > > > > > >      =20
> > > > > > > > > IMHO, the current behaviour is not explicitely stated, bu=
t nor is the opposite.
> > > > > > > > > And if I'm not mistaken, this introduces a 250msec delay.
> > > > > > > > >=20
> > > > > > > > > 1. If you want to avoid the 250msec gap, you should avoid=
 to contest the same address.
> > > > > > > > >=20
> > > > > > > > > 2. It's a balance between predictability and flexibility,=
 but if you try to accomplish both,
> > > > > > > > > as your patch suggests, there is slight time-window until=
 the current owner responds,
> > > > > > > > > in which it may be confusing which node has the address. =
It depends on how much history
> > > > > > > > > you have collected on the bus.
> > > > > > > > >=20
> > > > > > > > > I'm sure that this problem decreases with increasing proc=
essing power on the nodes,
> > > > > > > > > but bigger internal queues also increase this window.
> > > > > > > > >=20
> > > > > > > > > It would certainly help if you describe how the current i=
mplementation fails.
> > > > > > > > >=20
> > > > > > > > > Would decreasing the dead time to 50msec help in such cas=
e.
> > > > > > > > >=20
> > > > > > > > > Kind regards,
> > > > > > > > > Kurt
> > > > > > > > >      =20
> > > > > > > >=20
> > > > > > > >      =20
> > > > > > >=20
> > > > > > > The test that is being executed during the ISOBUS compliance =
is the
> > > > > > > following: after an address has been claimed by a CF (#1), an=
other CF
> > > > > > > (#2) sends a  message (other than address-claim) using the sa=
me address
> > > > > > > claimed by CF #1.
> > > > > > >=20
> > > > > > > As per ISO11783-5 standard, if a CF receives a message, other=
 than the
> > > > > > > address-claimed message, which uses the CF's own SA, then the=
 CF (#1):
> > > > > > > - shall send the address-claim message to the Global address;
> > > > > > > - shall activate a diagnostic trouble code with SPN =3D 2000+=
SA and FMI =3D
> > > > > > > 31
> > > > > > >=20
> > > > > > > After the address-claim message is sent by CF #1, as per ISO1=
1783-5
> > > > > > > standard:
> > > > > > > - If the name of the CF #1 has a lower priority then the one =
of the CF
> > > > > > > #2, the the CF #2 shall send its address-claim message and th=
us the CF
> > > > > > > #1 shall send the cannot-claim-address message or shall execu=
te again
> > > > > > > the claim procedure with a new address
> > > > > > > - If the name of the CF #1 has higher priority then the of th=
e CF #2,
> > > > > > > then the CF #2 shall send the cannot-claim-address message or=
 shall
> > > > > > > execute the claim procedure with a new address
> > > > > > >=20
> > > > > > > Above conflict management is OK with current J1939 driver
> > > > > > > implementation, however, since the driver always waits 250ms =
after
> > > > > > > sending an address-claim message, the CF #1 cannot set the DT=
C. The DM1
> > > > > > > message which is expected to be sent each second (as per J193=
9-73
> > > > > > > standard) may not be sent.
> > > > > > >=20
> > > > > > > Honestly, I don't know which company is doing the ISOBUS comp=
liance
> > > > > > > tests on our products and which tool they use as it was choos=
en by our
> > > > > > > customer, however they did send us some CAN traces of previou=
sly
> > > > > > > performed tests and we noticed that the DM1 message is sent 1=
60ms after
> > > > > > > the address-claim message (but it may also be lower then that=
), and this
> > > > > > > is something that we cannot do because the driver blocks the =
application
> > > > > > > from sending it.
> > > > > > >=20
> > > > > > > 28401.127146 1  18E6FFF0x    Tx   d 8 FE 26 FF FF FF FF FF FF=
  //Message
> > > > > > > with other CF's address
> > > > > > > 28401.167414 1  18EEFFF0x    Rx   d 8 15 76 D1 0B 00 86 00 A0=
  //Address
> > > > > > > Claim - SA =3D F0
> > > > > > > 28401.349214 1  18FECAF0x    Rx   d 8 FF FF C0 08 1F 01 FF FF=
  //DM1
> > > > > > > 28402.155774 1  18E6FFF0x    Tx   d 8 FE 26 FF FF FF FF FF FF=
  //Message
> > > > > > > with other CF's address
> > > > > > > 28402.169455 1  18EEFFF0x    Rx   d 8 15 76 D1 0B 00 86 00 A0=
  //Address
> > > > > > > Claim - SA =3D F0
> > > > > > > 28402.348226 1  18FECAF0x    Rx   d 8 FF FF C0 08 1F 02 FF FF=
  //DM1
> > > > > > > 28403.182753 1  18E6FFF0x    Tx   d 8 FE 26 FF FF FF FF FF FF=
  //Message
> > > > > > > with other CF's address
> > > > > > > 28403.188648 1  18EEFFF0x    Rx   d 8 15 76 D1 0B 00 86 00 A0=
  //Address
> > > > > > > Claim - SA =3D F0
> > > > > > > 28403.349328 1  18FECAF0x    Rx   d 8 FF FF C0 08 1F 03 FF FF=
  //DM1
> > > > > > > 28404.349406 1  18FECAF0x    Rx   d 8 FF FF C0 08 1F 03 FF FF=
  //DM1
> > > > > > > 28405.349740 1  18FECAF0x    Rx   d 8 FF FF C0 08 1F 03 FF FF=
  //DM1
> > > > > > >=20
> > > > > > > Since the 250ms wait is not explicitly stated, IMHO it should=
 be up to
> > > > > > > the user-space implementation to decide how to manage it.   =
=20
> > > > >=20
> > > > > I think this is not entirely correct. AFAICS the 250ms wait is in=
deed
> > > > > explicitly stated.
> > > > > The following is taken from ISO 11783-5:
> > > > >=20
> > > > > In "4.4.4.3 Address violation" it states that "If a CF receives a=
 message,
> > > > > other than the address-claimed message, which uses the CF=E2=80=
=99s own SA, then the
> > > > > CF [...] shall send the address-claim message to the Global addre=
ss."
> > > > >=20
> > > > > So the CF shall claim its address again. But further down, in "4.=
5.2 Address
> > > > > claim requirements" it is stated that "...No CF shall begin, or r=
esume,
> > > > > transmission on the network until 250 ms after it has successfull=
y claimed an
> > > > > address".
> > > > >=20
> > > > > At this moment, the address is in dispute. The affected CFs are n=
ot allowed to
> > > > > send any other messages until this dispute is resolved, and the s=
tandard
> > > > > requires a waiting time of 250ms which is minimally deemed necess=
ary to give
> > > > > all participants time to respond and eventually dispute the addre=
ss claim.
> > > > >=20
> > > > > If the offending CF ignores this dispute and keeps sending incorr=
ect messages
> > > > > faster than every 250ms, then effectively the other CF has no cha=
nce to ever
> > > > > resume normal operation because its address is still disputed.
> > > > >=20
> > > > > According to 4.4.4.3 it is also required to set a DTC, but it wil=
l not be
> > > > > allowed to send the DM1 message unless the address dispute is res=
olved.
> > > > >=20
> > > > > This effectively leads to the offending CF to DoS the affected CF=
 if it keeps
> > > > > sending offending messages. Unfortunately neither J1939 nor ISObu=
s takes into
> > > > > account adversarial behavior on the CAN network, so we cannot do =
anything
> > > > > about this.
> > > > >=20
> > > > > As for the ISObus compliance tool that is mentioned by Devid, IMH=
O this
> > > > > compliance tool should be challenged and fixed, since it is broke=
n.
> > > > >=20
> > > > > The networking layer is prohibiting the DM1 message to be sent, a=
nd the
> > > > > networking layer has precedence above all superior protocol layer=
s, so the
> > > > > diagnostics layer is not able to operate at this moment.
> > > > >=20
> > > > > Best regards,
> > > > >=20
> > > > >    =20
> > > >=20
> > > > Hi David,
> > > >=20
> > > > I get your point but I'm not sure that it is the correct interpreta=
tion
> > > > that should be applied in this particular case for the following
> > > > reasons:
> > > >=20
> > > > - In "4.5.2 Address claim requirements" it is explicitly stated that
> > > > "The CF shall claim its own address when initializing and when
> > > > responding to a command to change its NAME or address" and this see=
ms to =20
> > >=20
> > > The standard unfortunately has a track record of ignoring a lot of sc=
enarios
> > > and corner cases, like in this instance the fact that there can appea=
r new
> > > participants on the bus _after_ initialization has long finished, and=
 it would
> > > need to claim its address again in that case.
> > >=20
> > > But look at point d) of that same section: "No CF shall begin, or res=
ume,
> > > transmission on the network until 250 ms after it has successfully cl=
aimed an
> > > address (Figure 4). This does not apply when responding to a request =
for
> > > address claimed."
> > >=20
> > > So we basically have two situations when this will apply after the ne=
twork is
> > > up and running and a new node suddenly appears:
> > >=20
> > >  1. The new node starts with a "Request for address claimed" message,=
 to
> > >  which your CF should respond with an "Address Claimed" message and N=
OT wait
> > >  250ms.
> > >=20
> > > or
> > >=20
> > >  2. The new node creates an addressing conflict either by claiming it=
s address
> > >  without first sending a "request for address claimed" message or (an=
d this is
> > >  your case) simply using its address without claiming it first.
> > >=20
> > > It is this second possibility where there is a conflict that must be =
resolved,
> > > and then you must wait 250ms after claiming the conflicting address f=
or
> > > yourself.
> > >  =20
> > > > completely ignore the "4.4.4.3 Address violation" that states that =
the
> > > > address-claimed message shall be sent also when "the CF receives a
> > > > message, other than the address-claimed message, which uses the CF'=
s own
> > > > SA".
> > > > Please note that the address was already claimed by the CF, so I th=
ink
> > > > that the initialization requirements should not apply in this case =
since
> > > > all disputes were already resolved. =20
> > >=20
> > > Well, yes and no. The address was claimed before, yes, but then a new=
 node came
> > > onto the bus and disputed that address. In that case the dispute need=
s to be
> > > resolved first. Imagine you would NOT wait 250ms, but the other CF did
> > > correctly claim its address, but it was you who did not receive that =
message
> > > for some reason. Now also assume that your own NAME has a lower prior=
ity than
> > > the other CF. In this case you can send a "claimed address" message t=
o claim
> > > your address again, but it will be contested. If you don't wait for t=
he
> > > contestant, it is you who will be in violation of the protocol, becau=
se you
> > > should have changed your own address but failed to do so.
> > >  =20
> > > > - If the offending CF ignores the dispute, as you said, then the ot=
her
> > > > CF has no chance to ever resume normal operation and so the network
> > > > cannot be aware that the other CF is not working correctly because =
the
> > > > offending CF is spoofing its own address. =20
> > >=20
> > > Correct. And like I said in my previous reply, this is unfortunately =
how CAN,
> > > J1939 and ISObus work. The whole network must cooperate and there is =
no
> > > consideration for malign or adversarial actors.
> > > There are also a lot of possible corner cases that these standards
> > > unfortunately do not take into account. Conformance test tools seem t=
o be even
> > > more problematic and tend to have bugs quite often. I am still inclin=
ed to
> > > think this is the case with your test tool.
> > >  =20
> > > > This seems to make useless the
> > > > requirement that states to activate the DTC in "4.4.4.3 Address
> > > > violation". =20
> > >=20
> > > The requirement is not useless. You can still set and store the DTC, =
just not
> > > broadcast it to the network at that moment.
> > >=20
> > > Best regards,
> > >=20
> > >  =20
> >=20
> > Thank you for your feedback and explanation.
> > I asked the customer to contact the compliance company so that we can
> > verify with them this particular use-case. I want to understand if there
> > is an application note or exception that states how to manage it or if
> > they implemented the test basing it on their own interpretation and how
> > it really works: supposing that the test does not check the DM1
> > presence, then the test could be passed even without sending the DM1
> > message during the 250ms after the adress-claimed message.
> >=20
> > Best regards,
> > Devid =20
>=20
> Hi David, all,
>=20
> I'm sorry for resuming this discussion after a long time but I noticed
> that the driver forces the 250 ms wait even when responding to a request
> for address-claimed which is against point d) of ISO 11783-5 "4.5.2
> Address claim requirements":
>=20
> No CF shall begin, or resume, transmission on the network until 250 ms
> after it has successfully claimed  an  address  (see Figure 4), except
> when responding to a request for address-claimed.
>=20
> IMHO the driver shall be able to detect above condition or shall not
> force the 250 ms wait which should then be implemented, depending on the
> case, on user-space application side.

I am a bit out of the loop with this driver, but I think what you say is
correct. The J1939 stack should NOT unconditionally stay silent for 250ms
after sending an Address Claimed message. It should specifically NOT do so =
if
it is just responding to a Request for Address Claimed message.

So if it is indeed so, that the J1939 stack will hold off sending messages
forcibly after sending an Address Claimed message as a reply to a Request f=
or
Address Claimed, then I'd say this is a bug.

@Oleksij, can you confirm this?

Best regards,

--=20
David Jander
Protonic Holland.

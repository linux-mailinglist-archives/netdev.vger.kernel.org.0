Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08E7162ED72
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 07:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238946AbiKRGHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 01:07:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiKRGHX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 01:07:23 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 992169825A
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 22:07:21 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1ovuWb-0008GV-RN; Fri, 18 Nov 2022 07:06:53 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1ovuWV-0007eT-93; Fri, 18 Nov 2022 07:06:47 +0100
Date:   Fri, 18 Nov 2022 07:06:47 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     David Jander <david@protonic.nl>
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
Message-ID: <20221118060647.GE12278@pengutronix.de>
References: <YnllpntZ8V5CD07v@x1.vandijck-laurijssen.be>
 <20220510042609.GA10669@pengutronix.de>
 <ce7da10389fe448efee86d788dd5282b8022f92e.camel@egluetechnologies.com>
 <20220511084728.GD10669@pengutronix.de>
 <20220511110649.21cc1f65@erd992>
 <baaf0b8b237a2e6a8f99faca60112919d79cf549.camel@egluetechnologies.com>
 <20220511162247.2cf3fb2e@erd992>
 <3566cba652c64641603fd0ad477e2c90cd77655b.camel@egluetechnologies.com>
 <e0f6b26e2c724439752f3c13b53af1a56a42a5bf.camel@egluetechnologies.com>
 <20221117162251.5e5933c1@erd992>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221117162251.5e5933c1@erd992>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 04:22:51PM +0100, David Jander wrote:
> On Thu, 17 Nov 2022 15:08:20 +0100
> Devid Antonio Filoni <devid.filoni@egluetechnologies.com> wrote:
> 
> > On Fri, 2022-05-13 at 11:46 +0200, Devid Antonio Filoni wrote:
> > > Hi David,
> > > 
> > > On Wed, 2022-05-11 at 16:22 +0200, David Jander wrote:  
> > > > Hi Devid,
> > > > 
> > > > On Wed, 11 May 2022 14:55:04 +0200
> > > > Devid Antonio Filoni <
> > > > devid.filoni@egluetechnologies.com  
> > > > > wrote:  
> > > >   
> > > > > On Wed, 2022-05-11 at 11:06 +0200, David Jander wrote:  
> > > > > > Hi,
> > > > > > 
> > > > > > On Wed, 11 May 2022 10:47:28 +0200
> > > > > > Oleksij Rempel <
> > > > > > o.rempel@pengutronix.de
> > > > > >     
> > > > > > > wrote:    
> > > > > > 
> > > > > >     
> > > > > > > Hi,
> > > > > > > 
> > > > > > > i'll CC more J1939 users to the discussion.    
> > > > > > 
> > > > > > Thanks for the CC.
> > > > > >     
> > > > > > > On Tue, May 10, 2022 at 01:00:41PM +0200, Devid Antonio Filoni wrote:    
> > > > > > > > Hi,
> > > > > > > > 
> > > > > > > > On Tue, 2022-05-10 at 06:26 +0200, Oleksij Rempel wrote:      
> > > > > > > > > Hi,
> > > > > > > > > 
> > > > > > > > > On Mon, May 09, 2022 at 09:04:06PM +0200, Kurt Van Dijck wrote:      
> > > > > > > > > > On ma, 09 mei 2022 19:03:03 +0200, Devid Antonio Filoni wrote:      
> > > > > > > > > > > This is not explicitly stated in SAE J1939-21 and some tools used for
> > > > > > > > > > > ISO-11783 certification do not expect this wait.      
> > > > > > > > > 
> > > > > > > > > It will be interesting to know which certification tool do not expect it and
> > > > > > > > > what explanation is used if it fails?
> > > > > > > > >       
> > > > > > > > > > IMHO, the current behaviour is not explicitely stated, but nor is the opposite.
> > > > > > > > > > And if I'm not mistaken, this introduces a 250msec delay.
> > > > > > > > > > 
> > > > > > > > > > 1. If you want to avoid the 250msec gap, you should avoid to contest the same address.
> > > > > > > > > > 
> > > > > > > > > > 2. It's a balance between predictability and flexibility, but if you try to accomplish both,
> > > > > > > > > > as your patch suggests, there is slight time-window until the current owner responds,
> > > > > > > > > > in which it may be confusing which node has the address. It depends on how much history
> > > > > > > > > > you have collected on the bus.
> > > > > > > > > > 
> > > > > > > > > > I'm sure that this problem decreases with increasing processing power on the nodes,
> > > > > > > > > > but bigger internal queues also increase this window.
> > > > > > > > > > 
> > > > > > > > > > It would certainly help if you describe how the current implementation fails.
> > > > > > > > > > 
> > > > > > > > > > Would decreasing the dead time to 50msec help in such case.
> > > > > > > > > > 
> > > > > > > > > > Kind regards,
> > > > > > > > > > Kurt
> > > > > > > > > >       
> > > > > > > > > 
> > > > > > > > >       
> > > > > > > > 
> > > > > > > > The test that is being executed during the ISOBUS compliance is the
> > > > > > > > following: after an address has been claimed by a CF (#1), another CF
> > > > > > > > (#2) sends a  message (other than address-claim) using the same address
> > > > > > > > claimed by CF #1.
> > > > > > > > 
> > > > > > > > As per ISO11783-5 standard, if a CF receives a message, other than the
> > > > > > > > address-claimed message, which uses the CF's own SA, then the CF (#1):
> > > > > > > > - shall send the address-claim message to the Global address;
> > > > > > > > - shall activate a diagnostic trouble code with SPN = 2000+SA and FMI =
> > > > > > > > 31
> > > > > > > > 
> > > > > > > > After the address-claim message is sent by CF #1, as per ISO11783-5
> > > > > > > > standard:
> > > > > > > > - If the name of the CF #1 has a lower priority then the one of the CF
> > > > > > > > #2, the the CF #2 shall send its address-claim message and thus the CF
> > > > > > > > #1 shall send the cannot-claim-address message or shall execute again
> > > > > > > > the claim procedure with a new address
> > > > > > > > - If the name of the CF #1 has higher priority then the of the CF #2,
> > > > > > > > then the CF #2 shall send the cannot-claim-address message or shall
> > > > > > > > execute the claim procedure with a new address
> > > > > > > > 
> > > > > > > > Above conflict management is OK with current J1939 driver
> > > > > > > > implementation, however, since the driver always waits 250ms after
> > > > > > > > sending an address-claim message, the CF #1 cannot set the DTC. The DM1
> > > > > > > > message which is expected to be sent each second (as per J1939-73
> > > > > > > > standard) may not be sent.
> > > > > > > > 
> > > > > > > > Honestly, I don't know which company is doing the ISOBUS compliance
> > > > > > > > tests on our products and which tool they use as it was choosen by our
> > > > > > > > customer, however they did send us some CAN traces of previously
> > > > > > > > performed tests and we noticed that the DM1 message is sent 160ms after
> > > > > > > > the address-claim message (but it may also be lower then that), and this
> > > > > > > > is something that we cannot do because the driver blocks the application
> > > > > > > > from sending it.
> > > > > > > > 
> > > > > > > > 28401.127146 1  18E6FFF0x    Tx   d 8 FE 26 FF FF FF FF FF FF  //Message
> > > > > > > > with other CF's address
> > > > > > > > 28401.167414 1  18EEFFF0x    Rx   d 8 15 76 D1 0B 00 86 00 A0  //Address
> > > > > > > > Claim - SA = F0
> > > > > > > > 28401.349214 1  18FECAF0x    Rx   d 8 FF FF C0 08 1F 01 FF FF  //DM1
> > > > > > > > 28402.155774 1  18E6FFF0x    Tx   d 8 FE 26 FF FF FF FF FF FF  //Message
> > > > > > > > with other CF's address
> > > > > > > > 28402.169455 1  18EEFFF0x    Rx   d 8 15 76 D1 0B 00 86 00 A0  //Address
> > > > > > > > Claim - SA = F0
> > > > > > > > 28402.348226 1  18FECAF0x    Rx   d 8 FF FF C0 08 1F 02 FF FF  //DM1
> > > > > > > > 28403.182753 1  18E6FFF0x    Tx   d 8 FE 26 FF FF FF FF FF FF  //Message
> > > > > > > > with other CF's address
> > > > > > > > 28403.188648 1  18EEFFF0x    Rx   d 8 15 76 D1 0B 00 86 00 A0  //Address
> > > > > > > > Claim - SA = F0
> > > > > > > > 28403.349328 1  18FECAF0x    Rx   d 8 FF FF C0 08 1F 03 FF FF  //DM1
> > > > > > > > 28404.349406 1  18FECAF0x    Rx   d 8 FF FF C0 08 1F 03 FF FF  //DM1
> > > > > > > > 28405.349740 1  18FECAF0x    Rx   d 8 FF FF C0 08 1F 03 FF FF  //DM1
> > > > > > > > 
> > > > > > > > Since the 250ms wait is not explicitly stated, IMHO it should be up to
> > > > > > > > the user-space implementation to decide how to manage it.    
> > > > > > 
> > > > > > I think this is not entirely correct. AFAICS the 250ms wait is indeed
> > > > > > explicitly stated.
> > > > > > The following is taken from ISO 11783-5:
> > > > > > 
> > > > > > In "4.4.4.3 Address violation" it states that "If a CF receives a message,
> > > > > > other than the address-claimed message, which uses the CF’s own SA, then the
> > > > > > CF [...] shall send the address-claim message to the Global address."
> > > > > > 
> > > > > > So the CF shall claim its address again. But further down, in "4.5.2 Address
> > > > > > claim requirements" it is stated that "...No CF shall begin, or resume,
> > > > > > transmission on the network until 250 ms after it has successfully claimed an
> > > > > > address".
> > > > > > 
> > > > > > At this moment, the address is in dispute. The affected CFs are not allowed to
> > > > > > send any other messages until this dispute is resolved, and the standard
> > > > > > requires a waiting time of 250ms which is minimally deemed necessary to give
> > > > > > all participants time to respond and eventually dispute the address claim.
> > > > > > 
> > > > > > If the offending CF ignores this dispute and keeps sending incorrect messages
> > > > > > faster than every 250ms, then effectively the other CF has no chance to ever
> > > > > > resume normal operation because its address is still disputed.
> > > > > > 
> > > > > > According to 4.4.4.3 it is also required to set a DTC, but it will not be
> > > > > > allowed to send the DM1 message unless the address dispute is resolved.
> > > > > > 
> > > > > > This effectively leads to the offending CF to DoS the affected CF if it keeps
> > > > > > sending offending messages. Unfortunately neither J1939 nor ISObus takes into
> > > > > > account adversarial behavior on the CAN network, so we cannot do anything
> > > > > > about this.
> > > > > > 
> > > > > > As for the ISObus compliance tool that is mentioned by Devid, IMHO this
> > > > > > compliance tool should be challenged and fixed, since it is broken.
> > > > > > 
> > > > > > The networking layer is prohibiting the DM1 message to be sent, and the
> > > > > > networking layer has precedence above all superior protocol layers, so the
> > > > > > diagnostics layer is not able to operate at this moment.
> > > > > > 
> > > > > > Best regards,
> > > > > > 
> > > > > >     
> > > > > 
> > > > > Hi David,
> > > > > 
> > > > > I get your point but I'm not sure that it is the correct interpretation
> > > > > that should be applied in this particular case for the following
> > > > > reasons:
> > > > > 
> > > > > - In "4.5.2 Address claim requirements" it is explicitly stated that
> > > > > "The CF shall claim its own address when initializing and when
> > > > > responding to a command to change its NAME or address" and this seems to  
> > > > 
> > > > The standard unfortunately has a track record of ignoring a lot of scenarios
> > > > and corner cases, like in this instance the fact that there can appear new
> > > > participants on the bus _after_ initialization has long finished, and it would
> > > > need to claim its address again in that case.
> > > > 
> > > > But look at point d) of that same section: "No CF shall begin, or resume,
> > > > transmission on the network until 250 ms after it has successfully claimed an
> > > > address (Figure 4). This does not apply when responding to a request for
> > > > address claimed."
> > > > 
> > > > So we basically have two situations when this will apply after the network is
> > > > up and running and a new node suddenly appears:
> > > > 
> > > >  1. The new node starts with a "Request for address claimed" message, to
> > > >  which your CF should respond with an "Address Claimed" message and NOT wait
> > > >  250ms.
> > > > 
> > > > or
> > > > 
> > > >  2. The new node creates an addressing conflict either by claiming its address
> > > >  without first sending a "request for address claimed" message or (and this is
> > > >  your case) simply using its address without claiming it first.
> > > > 
> > > > It is this second possibility where there is a conflict that must be resolved,
> > > > and then you must wait 250ms after claiming the conflicting address for
> > > > yourself.
> > > >   
> > > > > completely ignore the "4.4.4.3 Address violation" that states that the
> > > > > address-claimed message shall be sent also when "the CF receives a
> > > > > message, other than the address-claimed message, which uses the CF's own
> > > > > SA".
> > > > > Please note that the address was already claimed by the CF, so I think
> > > > > that the initialization requirements should not apply in this case since
> > > > > all disputes were already resolved.  
> > > > 
> > > > Well, yes and no. The address was claimed before, yes, but then a new node came
> > > > onto the bus and disputed that address. In that case the dispute needs to be
> > > > resolved first. Imagine you would NOT wait 250ms, but the other CF did
> > > > correctly claim its address, but it was you who did not receive that message
> > > > for some reason. Now also assume that your own NAME has a lower priority than
> > > > the other CF. In this case you can send a "claimed address" message to claim
> > > > your address again, but it will be contested. If you don't wait for the
> > > > contestant, it is you who will be in violation of the protocol, because you
> > > > should have changed your own address but failed to do so.
> > > >   
> > > > > - If the offending CF ignores the dispute, as you said, then the other
> > > > > CF has no chance to ever resume normal operation and so the network
> > > > > cannot be aware that the other CF is not working correctly because the
> > > > > offending CF is spoofing its own address.  
> > > > 
> > > > Correct. And like I said in my previous reply, this is unfortunately how CAN,
> > > > J1939 and ISObus work. The whole network must cooperate and there is no
> > > > consideration for malign or adversarial actors.
> > > > There are also a lot of possible corner cases that these standards
> > > > unfortunately do not take into account. Conformance test tools seem to be even
> > > > more problematic and tend to have bugs quite often. I am still inclined to
> > > > think this is the case with your test tool.
> > > >   
> > > > > This seems to make useless the
> > > > > requirement that states to activate the DTC in "4.4.4.3 Address
> > > > > violation".  
> > > > 
> > > > The requirement is not useless. You can still set and store the DTC, just not
> > > > broadcast it to the network at that moment.
> > > > 
> > > > Best regards,
> > > > 
> > > >   
> > > 
> > > Thank you for your feedback and explanation.
> > > I asked the customer to contact the compliance company so that we can
> > > verify with them this particular use-case. I want to understand if there
> > > is an application note or exception that states how to manage it or if
> > > they implemented the test basing it on their own interpretation and how
> > > it really works: supposing that the test does not check the DM1
> > > presence, then the test could be passed even without sending the DM1
> > > message during the 250ms after the adress-claimed message.
> > > 
> > > Best regards,
> > > Devid  
> > 
> > Hi David, all,
> > 
> > I'm sorry for resuming this discussion after a long time but I noticed
> > that the driver forces the 250 ms wait even when responding to a request
> > for address-claimed which is against point d) of ISO 11783-5 "4.5.2
> > Address claim requirements":
> > 
> > No CF shall begin, or resume, transmission on the network until 250 ms
> > after it has successfully claimed  an  address  (see Figure 4), except
> > when responding to a request for address-claimed.
> > 
> > IMHO the driver shall be able to detect above condition or shall not
> > force the 250 ms wait which should then be implemented, depending on the
> > case, on user-space application side.
> 
> I am a bit out of the loop with this driver, but I think what you say is
> correct. The J1939 stack should NOT unconditionally stay silent for 250ms
> after sending an Address Claimed message. It should specifically NOT do so if
> it is just responding to a Request for Address Claimed message.
> 
> So if it is indeed so, that the J1939 stack will hold off sending messages
> forcibly after sending an Address Claimed message as a reply to a Request for
> Address Claimed, then I'd say this is a bug.
> 
> @Oleksij, can you confirm this?

I do not see any code path inside of the j1939 stack preventing sending
you anything by address. The only part which cares about address
claiming is net/can/j1939/address-claim.c and it will just not be able
to resolve name to address, because address claiming was not finished
jet. With other words, if you need to send responding to a request for
address-claimed, then just send it by using address instead of name.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

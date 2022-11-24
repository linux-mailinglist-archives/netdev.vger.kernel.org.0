Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6FAE6371AE
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 06:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbiKXFQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 00:16:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiKXFQm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 00:16:42 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79EA3BBDE8
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 21:16:40 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oy4av-0002of-SV; Thu, 24 Nov 2022 06:16:17 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oy4ap-0004R4-7F; Thu, 24 Nov 2022 06:16:11 +0100
Date:   Thu, 24 Nov 2022 06:16:11 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Devid Antonio Filoni <devid.filoni@egluetechnologies.com>
Cc:     Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>,
        kbuild test robot <lkp@intel.com>,
        Maxime Jayat <maxime.jayat@mobile-devices.fr>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        David Jander <david@protonic.nl>, linux-kernel@vger.kernel.org,
        Oleksij Rempel <linux@rempel-privat.de>,
        netdev@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        kernel@pengutronix.de, Robin van der Gracht <robin@protonic.nl>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, linux-can@vger.kernel.org
Subject: Re: [PATCH RESEND] can: j1939: do not wait 250ms if the same addr
 was already claimed
Message-ID: <20221124051611.GA7870@pengutronix.de>
References: <20221118123013.GF12278@pengutronix.de>
 <1fd663d232c7fba5f956faf1ad45fb410a675086.camel@egluetechnologies.com>
 <20221118134447.GG12278@pengutronix.de>
 <a01fe547c052e861d47089d6767aba639250adda.camel@egluetechnologies.com>
 <20221119101211.GA7626@pengutronix.de>
 <6c13c3072ca4c8c3217f9449f56921a8496c32eb.camel@egluetechnologies.com>
 <20221120084509.GB7626@pengutronix.de>
 <3da164b4269ac2ed9573560847c59aa1e54d2d9c.camel@egluetechnologies.com>
 <20221121051940.GA9293@pengutronix.de>
 <cbdb85ce0025ac6002e1a6e7d3ea8e4e1c451def.camel@egluetechnologies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cbdb85ce0025ac6002e1a6e7d3ea8e4e1c451def.camel@egluetechnologies.com>
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

On Wed, Nov 23, 2022 at 09:39:06PM +0100, Devid Antonio Filoni wrote:
> On Mon, 2022-11-21 at 06:19 +0100, Oleksij Rempel wrote:
> > On Sun, Nov 20, 2022 at 08:18:32PM +0100, Devid Antonio Filoni wrote:
> > > On Sun, 2022-11-20 at 09:45 +0100, Oleksij Rempel wrote:
> > > > On Sun, Nov 20, 2022 at 01:11:52AM +0100, Devid Antonio Filoni wrote:
> > > > > On Sat, 2022-11-19 at 11:12 +0100, Oleksij Rempel wrote:
> > > > > > On Fri, Nov 18, 2022 at 04:12:40PM +0100, Devid Antonio Filoni wrote:
> > > > > > > Hi Oleksij,
> > > > > > > 
> > > > > > > honestly I would apply proposed patch because it is the easier solution
> > > > > > > and makes the driver compliant with the standard for the following
> > > > > > > reasons:
> > > > > > > - on the first claim, the kernel will wait 250 ms as stated by the
> > > > > > > standard
> > > > > > > + on successive claims with the same name, the kernel will not wait
> > > > > > > 250ms, this implies:
> > > > > > >   - it will not wait after sending the address-claimed message when the
> > > > > > > claimed address has been spoofed, but the standard does not explicitly
> > > > > > > states what to do in this case (see previous emails in this thread), so
> > > > > > > it would be up to the application developer to decide how to manage the
> > > > > > > conflict
> > > > > > >   - it will not wait after sending the address-claimed message when a
> > > > > > > request for address-claimed message has been received as stated by the
> > > > > > > standard
> > > > > > 
> > > > > > Standard says:
> > > > > > 1. No CF _shall_ begin, or resume, transmission on the network until 250 ms
> > > > > >    after it has successfully claimed an address (Figure 4).
> > > > > > 2. This does not apply when responding to a request for address claimed.
> > > > > > 
> > > > > > With current patch state: 1. is implemented and working as expected, 2.
> > > > > > is not implemented.
> > > > > > With this patch: 1. is partially broken and 2. is partially faking
> > > > > > needed behavior.
> > > > > > 
> > > > > > It will not wait if remote ECU which rebooted for some reasons. With this patch
> > > > > > we are breaking one case of the standard in favor to fake compatibility to the
> > > > > > other case. We should avoid waiting only based on presence of RfAC not based
> > > > > > on the old_addr == new_addr.
> > > > > 
> > > > > I'm sorry, I don't think I understood the point about reboot ("It will
> > > > > not wait if remote ECU which rebooted for some reasons"). If another ECU
> > > > > rebooted, then *it* will have to perform the claim procedure again
> > > > > waiting 250 ms before beginning the transmission. Your ECU doesn't have
> > > > > to check if the other ECUs respected the 250 ms wait.
> > > > 
> > > > With proposed patch:
> > > > - local application which is sending to the remote NAME, will start or continue
> > > >   communication with ECU which should stay silent.
> > > 
> > > And this is not forbidden by the standard, the standard states that the
> > > remote ECU shall not start or continue the communication but it can
> > > *receive* messages.
> > > For example, what would you do if:
> > > - during the 250 ms wait, another ECU sends a request-for-address-
> > > claimed message meant to the address you're claiming?
> > > From "4.5.3 Other requirements for initialization":
> > > A CF shall respond to a request-for-address-claimed message when the
> > > destination address is the same as the CF's address and shall transmit
> > > its response to the Global address (255).
> > > - during the 250 ms wait another ECU sends a normal message (non
> > > address-claim related) using the SA you're currently claiming?
> > > 
> > > > - local application which was manually or automatically restarted (see
> > > >   application watchdogs), will bypass address claim procedure
> > > >   completion and start sending without 250ms delay.
> > > 
> > > Then the application will be violating the standard, you're right,
> > > however please note that, as per driver implementation, each time the
> > > socket is closed and opened again (if bound with a name) you have to
> > > send the address-claimed message again.
> > > The standard also states how to treat this kind of violations on the
> > > remote ECU side.
> > > 
> > > > 
> > > > > Also, the ISO11783-5 standard, with "Figure 6 (Resolving address
> > > > > contention between two self-configurable-address CF)" of "4.5.4.2 -
> > > > > Address-claim prioritization", shows that:
> > > > > - ECU1 claims the address (time: 0 ms)
> > > > > - ECU2 claims the same address (time: 0+x ms)
> > > > > - ECU1 NAME has the higher priority, so ECU1 sends again the address
> > > > > claimed message as soon as it received the address-claim from ECU2
> > > > > (time: 0+x+y ms)
> > > > > - ECU1 starts normal transmission (time: 250 ms)
> > > > > With current implementation, the ECU1 would start the transmission at
> > > > > time 0+x+y+250 ms, with proposed patch it would not.
> > > > 
> > > > You are right, this should be fixed.
> > > > But proposed patch closes one issues and opens another, with this patch it will
> > > > be enough to send at least two address claimed messages to bypass the delay.
> > > 
> > > No, because the timer associated with the first claim *is not stopped*.
> > > 
> > > > 
> > > > > Same is showed in "Figure 7 (Resolving address contention between a non-
> > > > > configurable address CF and a self-configurable address CF)", the ECU
> > > > > waits again 250 ms only when claiming a different address.
> > > > 
> > > > Ack
> > > > 
> > > > > Also, as previously discussed in this thread, the standard states in
> > > > > 4.4.4.3 - Address violation:
> > > > > If a CF receives a message, other than the address-claimed message,
> > > > > which uses the CF's own SA,
> > > > > then the CF:
> > > > > - shall send the address-claim message to the Global address;
> > > > > - shall activate a diagnostic trouble code with SPN = 2000+SA and FMI =
> > > > > 31
> > > > > It is not *explicitly* stated that you have to wait 250 ms after the
> > > > > address-claim message has been sent.
> > > > 
> > > > There is no need to explicitly state it. The requirement is clearly described
> > > > in the 4.5.2.d part 1 with clearly defined exception in  4.5.2.d part 2.
> > > > If something is not explicitly stated, the stated requirement has always
> > > > priority.
> > > > 
> > > > > Please note that the 250 ms wait is  mentioned only in "4.5 - Network
> > > > > initialization"
> > > > 
> > > > OK, we need to refer to the wording used in a specifications, in
> > > > general:
> > > > Shall – Shall is used to designate a mandatory requirement.
> > > > Should – Should is used for requirements that are considered good and are
> > > >          recommended, but are not absolutely mandatory.
> > > > May – May is used to for requirements that are optional.
> > > > 
> > > > If a requirement with strong wording as "shall" is not strong enough for
> > > > you and you are suing words as ".. mentioned only in .." then even a
> > > > statistical analysis of this spec will have no meaning. In all
> > > > cases we can just invalidate all arguments by using: it is only X or Y. 
> > > > 
> > > > > while above statements come from "4.4 - Network-management procedures".
> > > > > Also in this case, the proposed patch is still standard compliant.
> > > > 
> > > > If we remove 4.5.2.d from the spec, then yes.
> > > > 
> > > > > So I'm sorry but I have to disagree with you, there are many things
> > > > > broken in the current implementation because it is forcing the 250 wait
> > > > > to all cases but it should not.
> > > > 
> > > > If we remove 4.5.2.d from the spec, then yes. Every construction is
> > > > logical if we adopt input variables to the construction.
> > > 
> > > From "4.4.4.3 - Address violation":
> > > - *shall send the address-claim message* to the Global address
> > > From "4.5.2 Address claim requirements":
> > > - No CF shall begin, or resume, transmission on the network until 250 ms
> > > after it has successfully *claimed an address*, except when responding
> > > to a request for address-claimed.
> > > 
> > > Do you see any difference?
> > > With your interpretation of the standard, then above 4.5.2.d sentence
> > > shall be:
> > > - No CF shall begin, or resume, transmission on the network until 250 ms
> > > after it has successfully *sent the address-claim message*, except when
> > > responding to a request for address-claimed.
> > > 
> > > I think "it has successfully claimed an address" is valid for the whole
> > > claim procedure and not for the address-claimed message only.
> > > 
> > > Please note that the ECU shall send the address-claim message also when
> > > it receives a request for a matching NAME ("4.4.3.2 NAME management (NM)
> > > message"). This does not mean that is claiming again the address.
> > > 
> > > > 
> > > > > > Without words 2. part should be implemented without breaking 1.
> > > > > > 
> > > > > > > Otherwise you will have to keep track of above cases and decide if the
> > > > > > > wait is needed or not, but this is hard do accomplish because is the
> > > > > > > application in charge of sending the address-claimed message, so you
> > > > > > > would have to decide how much to keep track of the request for address-
> > > > > > > claimed message thus adding more complexity to the code of the driver.
> > > > > > 
> > > > > > Current kernel already tracks all claims on the bus and knows all registered
> > > > > > NAMEs. I do not see increased complicity in this case.
> > > > > 
> > > > > The kernel tracks the claims but it does *not track* incoming requests
> > > > > for address-claimed message, it would have to and it would have to
> > > > 
> > > > yes
> > > > 
> > > > > allow the application to answer to it *within a defined time window*.
> > > > 
> > > > yes.
> > > > 
> > > > > But keep in mind that there are other cases when the 250 ms wait is wrong
> > > > > or it is not explicitly stated by the standard.
> > > > 
> > > > If it is not stated in the standard how can we decide if it is wrong?
> > > And how can we decide if it is right? :)
> > > 
> > > > And if strongly worded statements have no value just because it is
> > > > stated only one time, how proper standard should look like? 
> > > See above.
> > > 
> > > > 
> > > > > > IMHO, only missing part i a user space interface. Some thing like "ip n"
> > > > > > will do.
> > > > > > 
> > > > > > > Another solution is to let the driver send the address-claimed message
> > > > > > > waiting or without waiting 250 ms for successive messages depending on
> > > > > > > the case.
> > > > > > 
> > > > > > You can send "address-claimed message" in any time you wont. Kernel will
> > > > > > just not resolve the NAME to address until 1. part of the spec will
> > > > > > apply. Do not forget, the NAME cache is used for local _and_ remote
> > > > > > names. You can trick out local system, not remote.
> > > > > > 
> > > > > > Even if you implement "smart" logic in user space and will know better
> > > > > > then kernel, that this application is responding to RfAC. You will newer
> > > > > > know if address-claimed message of remote system is a response to RfAC.
> > > > > > 
> > > > > > From this perspective, I do not know, how allowing the user space break
> > > > > > the rules will help to solve the problem?
> > > > > 
> > > > > I think you did not understand this last proposal: since the driver is
> > > > > already implementing part of the standard, then it might as well send
> > > > > the address-claimed message when needed and wait 250 ms or not depending
> > > > > on the case.
> > > > 
> > > > Let's try following test:
> > > > j1939acd -r 80 -c /tmp/1122334455667788.jacd 11223344556677 vcan0 &
> > > > while(true); do testj1939 -s8 vcan0:0x80 :0x90,0x12300; done
> > > > 
> > > > And start candump with delta time stamps:
> > > > :~ candump -t d vcan0                                                 
> > > >  (000.000000)  vcan0  18EAFFFE   [3]  00 EE 00               
> > > >  (000.002437)  vcan0  19239080   [8]  01 23 45 67 89 AB CD EF <---- no 250ms delay
> > > >  (000.011458)  vcan0  19239080   [8]  01 23 45 67 89 AB CD EF
> > > >  (000.011964)  vcan0  19239080   [8]  01 23 45 67 89 AB CD EF
> > > >  (000.011712)  vcan0  19239080   [8]  01 23 45 67 89 AB CD EF
> > > >  (000.012585)  vcan0  19239080   [8]  01 23 45 67 89 AB CD EF
> > > >  (000.012891)  vcan0  19239080   [8]  01 23 45 67 89 AB CD EF
> > > >  (000.012082)  vcan0  19239080   [8]  01 23 45 67 89 AB CD EF
> > > >  (000.012604)  vcan0  19239080   [8]  01 23 45 67 89 AB CD EF
> > > >  (000.012357)  vcan0  19239080   [8]  01 23 45 67 89 AB CD EF
> > > >  (000.012790)  vcan0  19239080   [8]  01 23 45 67 89 AB CD EF
> > > >  (000.012765)  vcan0  19239080   [8]  01 23 45 67 89 AB CD EF
> > > >  (000.012483)  vcan0  19239080   [8]  01 23 45 67 89 AB CD EF
> > > >  (000.012680)  vcan0  19239080   [8]  01 23 45 67 89 AB CD EF
> > > >  (000.012144)  vcan0  19239080   [8]  01 23 45 67 89 AB CD EF
> > > > ... snip ...
> > > >  (000.012592)  vcan0  19239080   [8]  01 23 45 67 89 AB CD EF
> > > >  (000.012515)  vcan0  19239080   [8]  01 23 45 67 89 AB CD EF
> > > >  (000.013183)  vcan0  19239080   [8]  01 23 45 67 89 AB CD EF
> > > >  (000.012653)  vcan0  19239080   [8]  01 23 45 67 89 AB CD EF
> > > >  (000.011886)  vcan0  19239080   [8]  01 23 45 67 89 AB CD EF
> > > >  (000.012836)  vcan0  19239080   [8]  01 23 45 67 89 AB CD EF
> > > >  (000.009494)  vcan0  18EEFF80   [8]  77 66 55 44 33 22 11 00 <---- SA 0x80 address claimed 
> > > >  (000.003362)  vcan0  19239080   [8]  01 23 45 67 89 AB CD EF <---- next packet from SA 0x80 3 usecs after previous. No 250ms delay.
> > > >  (000.012351)  vcan0  19239080   [8]  01 23 45 67 89 AB CD EF
> > > >  (000.012983)  vcan0  19239080   [8]  01 23 45 67 89 AB CD EF
> > > >  (000.012602)  vcan0  19239080   [8]  01 23 45 67 89 AB CD EF
> > > >  (000.012594)  vcan0  19239080   [8]  01 23 45 67 89 AB CD EF
> > > >  (000.012348)  vcan0  19239080   [8]  01 23 45 67 89 AB CD EF
> > > >  (000.011922)  vcan0  19239080   [8]  01 23 45 67 89 AB CD EF
> > > > 
> > > > As you can see, the j1939 stack do not forcing application to use NAMEs and
> > > > do not preventing sending any message withing 250ms delay. The only thing
> > > > what has the 250 timer is NAME to address resolution which should be fixed in
> > > > respect of 4.5.2.d without breaking every thing else.
> > > 
> > > Yes this is clear, this is working because the socket used by testj1939
> > > is not bound to any name.
> > > 
> > > Just to clarify: are you suggesting to applications developer to use one
> > > socket (bound with the name) to manage the address-claim and another one
> > > (bound without the name) for other transmissions? If so, then why that
> > > code exists in the driver?
> > > Honestly I would consider this proposal really bad since this would
> > > allow to completely violate the standard. I really hope you agree with
> > > me about this.
> > 
> > Hm... you are right.
> > 
> > Please add to your patch code comments with standard snippets and
> > clarification why it should be so. Commit comment will be often
> > overseen.
> > 
> > Regards,
> > Oleksij
> 
> Would the following comment be acceptable? Isn't it too long?
> 
> The ISO 11783-5 standard, in "4.5.2 - Address claim requirements",
> states:
>   d) No CF shall begin, or resume, transmission on the network until 250
>      ms after it has successfully claimed an address except when
>      responding to a request for address-claimed.
> But "Figure 6" and "Figure 7" in "4.5.4.2 - Address-claim
> prioritization" show that the CF begin the transmission after 250 ms
> from the first AC (address-claimed) message even if it sends another AC
> message during that time window to resolve the address contention with
> another CF.
> As stated in "4.4.2.3 - Address-claimed message":
>   In order to successfully claim an address, the CF sending an address
>   claimed message shall not receive a contending claim from another CF
>   for at least 250 ms.
> As stated in "4.4.3.2 - NAME management (NM) message":
>   1) A commanding CF can
>      d) request that a CF with a specified NAME transmit the address-
>         claimed message with its current NAME.
>   2) A target CF shall
>      d) send an address-claimed message in response to a request for a 
>         matching NAME
> Taking the above arguments into account, the 250 ms wait is requested
> only during network initialization.
> Do not restart the timer on AC message if both the NAME and the address
> match and therefore if the address has already been claimed (timer has
> expired) or the AC message has been sent to resolve the contention with
> another CF (timer is still running).

Sounds good.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6F25522EB0
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 10:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243900AbiEKIry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 04:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243994AbiEKIrv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 04:47:51 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C15246899F
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 01:47:49 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1noi0J-00064w-5P; Wed, 11 May 2022 10:47:31 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1noi0G-0006L6-97; Wed, 11 May 2022 10:47:28 +0200
Date:   Wed, 11 May 2022 10:47:28 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Devid Antonio Filoni <devid.filoni@egluetechnologies.com>
Cc:     Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>,
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
        linux-kernel@vger.kernel.org, David Jander <david@protonic.nl>
Subject: Re: [PATCH RESEND] can: j1939: do not wait 250ms if the same addr
 was already claimed
Message-ID: <20220511084728.GD10669@pengutronix.de>
References: <20220509170303.29370-1-devid.filoni@egluetechnologies.com>
 <YnllpntZ8V5CD07v@x1.vandijck-laurijssen.be>
 <20220510042609.GA10669@pengutronix.de>
 <ce7da10389fe448efee86d788dd5282b8022f92e.camel@egluetechnologies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ce7da10389fe448efee86d788dd5282b8022f92e.camel@egluetechnologies.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:45:23 up 41 days, 21:15, 74 users,  load average: 0.15, 0.09,
 0.09
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

i'll CC more J1939 users to the discussion.

On Tue, May 10, 2022 at 01:00:41PM +0200, Devid Antonio Filoni wrote:
> Hi,
> 
> On Tue, 2022-05-10 at 06:26 +0200, Oleksij Rempel wrote:
> > Hi,
> > 
> > On Mon, May 09, 2022 at 09:04:06PM +0200, Kurt Van Dijck wrote:
> > > On ma, 09 mei 2022 19:03:03 +0200, Devid Antonio Filoni wrote:
> > > > This is not explicitly stated in SAE J1939-21 and some tools used for
> > > > ISO-11783 certification do not expect this wait.
> > 
> > It will be interesting to know which certification tool do not expect it and
> > what explanation is used if it fails?
> > 
> > > IMHO, the current behaviour is not explicitely stated, but nor is the opposite.
> > > And if I'm not mistaken, this introduces a 250msec delay.
> > > 
> > > 1. If you want to avoid the 250msec gap, you should avoid to contest the same address.
> > > 
> > > 2. It's a balance between predictability and flexibility, but if you try to accomplish both,
> > > as your patch suggests, there is slight time-window until the current owner responds,
> > > in which it may be confusing which node has the address. It depends on how much history
> > > you have collected on the bus.
> > > 
> > > I'm sure that this problem decreases with increasing processing power on the nodes,
> > > but bigger internal queues also increase this window.
> > > 
> > > It would certainly help if you describe how the current implementation fails.
> > > 
> > > Would decreasing the dead time to 50msec help in such case.
> > > 
> > > Kind regards,
> > > Kurt
> > > 
> > 
> 
> The test that is being executed during the ISOBUS compliance is the
> following: after an address has been claimed by a CF (#1), another CF
> (#2) sends a  message (other than address-claim) using the same address
> claimed by CF #1.
> 
> As per ISO11783-5 standard, if a CF receives a message, other than the
> address-claimed message, which uses the CF's own SA, then the CF (#1):
> - shall send the address-claim message to the Global address;
> - shall activate a diagnostic trouble code with SPN = 2000+SA and FMI =
> 31
> 
> After the address-claim message is sent by CF #1, as per ISO11783-5
> standard:
> - If the name of the CF #1 has a lower priority then the one of the CF
> #2, the the CF #2 shall send its address-claim message and thus the CF
> #1 shall send the cannot-claim-address message or shall execute again
> the claim procedure with a new address
> - If the name of the CF #1 has higher priority then the of the CF #2,
> then the CF #2 shall send the cannot-claim-address message or shall
> execute the claim procedure with a new address
> 
> Above conflict management is OK with current J1939 driver
> implementation, however, since the driver always waits 250ms after
> sending an address-claim message, the CF #1 cannot set the DTC. The DM1
> message which is expected to be sent each second (as per J1939-73
> standard) may not be sent.
> 
> Honestly, I don't know which company is doing the ISOBUS compliance
> tests on our products and which tool they use as it was choosen by our
> customer, however they did send us some CAN traces of previously
> performed tests and we noticed that the DM1 message is sent 160ms after
> the address-claim message (but it may also be lower then that), and this
> is something that we cannot do because the driver blocks the application
> from sending it.
> 
> 28401.127146 1  18E6FFF0x    Tx   d 8 FE 26 FF FF FF FF FF FF  //Message
> with other CF's address
> 28401.167414 1  18EEFFF0x    Rx   d 8 15 76 D1 0B 00 86 00 A0  //Address
> Claim - SA = F0
> 28401.349214 1  18FECAF0x    Rx   d 8 FF FF C0 08 1F 01 FF FF  //DM1
> 28402.155774 1  18E6FFF0x    Tx   d 8 FE 26 FF FF FF FF FF FF  //Message
> with other CF's address
> 28402.169455 1  18EEFFF0x    Rx   d 8 15 76 D1 0B 00 86 00 A0  //Address
> Claim - SA = F0
> 28402.348226 1  18FECAF0x    Rx   d 8 FF FF C0 08 1F 02 FF FF  //DM1
> 28403.182753 1  18E6FFF0x    Tx   d 8 FE 26 FF FF FF FF FF FF  //Message
> with other CF's address
> 28403.188648 1  18EEFFF0x    Rx   d 8 15 76 D1 0B 00 86 00 A0  //Address
> Claim - SA = F0
> 28403.349328 1  18FECAF0x    Rx   d 8 FF FF C0 08 1F 03 FF FF  //DM1
> 28404.349406 1  18FECAF0x    Rx   d 8 FF FF C0 08 1F 03 FF FF  //DM1
> 28405.349740 1  18FECAF0x    Rx   d 8 FF FF C0 08 1F 03 FF FF  //DM1
> 
> Since the 250ms wait is not explicitly stated, IMHO it should be up to
> the user-space implementation to decide how to manage it.
> 
> Thank you,
> Devid
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

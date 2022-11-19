Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2CDD630E02
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 11:12:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbiKSKMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Nov 2022 05:12:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbiKSKMh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Nov 2022 05:12:37 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A88C96B9E1
        for <netdev@vger.kernel.org>; Sat, 19 Nov 2022 02:12:36 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1owKpe-0007kV-V0; Sat, 19 Nov 2022 11:12:18 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1owKpX-00043P-IH; Sat, 19 Nov 2022 11:12:11 +0100
Date:   Sat, 19 Nov 2022 11:12:11 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Devid Antonio Filoni <devid.filoni@egluetechnologies.com>
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>,
        kbuild test robot <lkp@intel.com>,
        Maxime Jayat <maxime.jayat@mobile-devices.fr>,
        Robin van der Gracht <robin@protonic.nl>,
        linux-kernel@vger.kernel.org,
        Oleksij Rempel <linux@rempel-privat.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>, kernel@pengutronix.de,
        David Jander <david@protonic.nl>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-can@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH RESEND] can: j1939: do not wait 250ms if the same addr
 was already claimed
Message-ID: <20221119101211.GA7626@pengutronix.de>
References: <20220511162247.2cf3fb2e@erd992>
 <3566cba652c64641603fd0ad477e2c90cd77655b.camel@egluetechnologies.com>
 <e0f6b26e2c724439752f3c13b53af1a56a42a5bf.camel@egluetechnologies.com>
 <20221117162251.5e5933c1@erd992>
 <20221118060647.GE12278@pengutronix.de>
 <7b575cface09a2817ac53485507985a7fef7b835.camel@egluetechnologies.com>
 <20221118123013.GF12278@pengutronix.de>
 <1fd663d232c7fba5f956faf1ad45fb410a675086.camel@egluetechnologies.com>
 <20221118134447.GG12278@pengutronix.de>
 <a01fe547c052e861d47089d6767aba639250adda.camel@egluetechnologies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a01fe547c052e861d47089d6767aba639250adda.camel@egluetechnologies.com>
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

On Fri, Nov 18, 2022 at 04:12:40PM +0100, Devid Antonio Filoni wrote:
> Hi Oleksij,
> 
> honestly I would apply proposed patch because it is the easier solution
> and makes the driver compliant with the standard for the following
> reasons:
> - on the first claim, the kernel will wait 250 ms as stated by the
> standard
> + on successive claims with the same name, the kernel will not wait
> 250ms, this implies:
>   - it will not wait after sending the address-claimed message when the
> claimed address has been spoofed, but the standard does not explicitly
> states what to do in this case (see previous emails in this thread), so
> it would be up to the application developer to decide how to manage the
> conflict
>   - it will not wait after sending the address-claimed message when a
> request for address-claimed message has been received as stated by the
> standard

Standard says:
1. No CF _shall_ begin, or resume, transmission on the network until 250 ms
   after it has successfully claimed an address (Figure 4).
2. This does not apply when responding to a request for address claimed.

With current patch state: 1. is implemented and working as expected, 2.
is not implemented.
With this patch: 1. is partially broken and 2. is partially faking
needed behavior.

It will not wait if remote ECU which rebooted for some reasons. With this patch
we are breaking one case of the standard in favor to fake compatibility to the
other case. We should avoid waiting only based on presence of RfAC not based
on the old_addr == new_addr.

Without words 2. part should be implemented without breaking 1.

> Otherwise you will have to keep track of above cases and decide if the
> wait is needed or not, but this is hard do accomplish because is the
> application in charge of sending the address-claimed message, so you
> would have to decide how much to keep track of the request for address-
> claimed message thus adding more complexity to the code of the driver.

Current kernel already tracks all claims on the bus and knows all registered
NAMEs. I do not see increased complicity in this case.

IMHO, only missing part i a user space interface. Some thing like "ip n"
will do.

> Another solution is to let the driver send the address-claimed message
> waiting or without waiting 250 ms for successive messages depending on
> the case.

You can send "address-claimed message" in any time you wont. Kernel will
just not resolve the NAME to address until 1. part of the spec will
apply. Do not forget, the NAME cache is used for local _and_ remote
names. You can trick out local system, not remote.

Even if you implement "smart" logic in user space and will know better
then kernel, that this application is responding to RfAC. You will newer
know if address-claimed message of remote system is a response to RfAC.

From this perspective, I do not know, how allowing the user space break
the rules will help to solve the problem?

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

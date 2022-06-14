Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECD9F54A898
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 07:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234653AbiFNFMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 01:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232385AbiFNFMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 01:12:33 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96DA67658
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 22:12:31 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1o0yqh-0003ck-Kn; Tue, 14 Jun 2022 07:12:19 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1o0yqf-0001gw-Gs; Tue, 14 Jun 2022 07:12:17 +0200
Date:   Tue, 14 Jun 2022 07:12:17 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Michal Kubecek <mkubecek@suse.cz>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/1] net: phy: add remote fault support
Message-ID: <20220614051217.GC4536@pengutronix.de>
References: <20220608093403.3999446-1-o.rempel@pengutronix.de>
 <YqS+zYHf6eHMWJlD@lunn.ch>
 <20220613125552.GA4536@pengutronix.de>
 <YqdQJepq3Klvr5n5@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YqdQJepq3Klvr5n5@lunn.ch>
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 13, 2022 at 04:56:37PM +0200, Andrew Lunn wrote:
> > If I see it correctly, there is no way to notify about remote fault when
> > the link is up. The remote fault bit is transferred withing Link Code
> > Word as part of FLP burst. At least in this part of specification.
> 
> Thanks for looking at the specification. So ksetting does seem like
> the right API.
> 
> Sorry, i won't have time to look at the specification until tomorrow.
> The next question is, is it a separate value, or as more link mode
> bits? Or a mixture of both? 

It is the bit D13 within Base Link Codeword as described in "28.2.1.2
Link codeword encoding". Every PHY will send or receive it, but may be
not every PHY will allow to set this bit.

The actual error value can be optionally transmitted separately withing the
"Next Page".

> Is there a capability bit somewhere to indicate this PHY can advertise a
> remote fault?

No, it is not part of the "Technology Ability Filed". It is more like a state
bit.

Potentially some PHY may set it witout some PHY may do it without
software:
28.2.2 Receive function requirements
...
If any other technology-dependent PMA indicates link_status=READY when
the autoneg_wait_timer expires, Auto-Negotiation will not allow any data
service to be enabled and may signal this as a remote fault to the Link
Partner using the Base Page and will flag this in the Local Device by
setting the Parallel Detection Fault bit (6.4) in the Auto-Negotiation
expansion register.

> That would suggest we  want a ETHTOOL_LINK_MODE_REMOTE_FAULT_BIT, which we
> can set in supported and maybe see in lpa?

No. We can see if it is supported only if it is already in fault state.

> Set it in advertising when indicating  a fault. The actual fault value could
> then be in a separate value which gets written to the extended page?

correct.

> Does 802.3 allow a remote fault to be indicated but without the reason?

yes.

> > So receiving remote fault information via linkstate and send remote fault via
> > ksetting?
> 
> We could also just broadcast the results of a ksetting get to
> userspace?

by using ethnl_multicast()? I it something what should be implemented?

> I don't have easy access to a machine at the moment. What does
> 
> ip monitor all
> 
> show when a link is configured up, but autoneg fails? And when autoneg
> is successful but indicates a remote fault? Are there any existing
> messages sent to userspace?

Hm, currently i get only link state changes:

[LINK]4: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default 
    link/ether 18:74:e2:a0:00:a3 brd ff:ff:ff:ff:ff:ff
[NEIGH]Deleted ff02::16 dev eth1 lladdr 33:33:00:00:00:16 NOARP
[NEIGH]Deleted ff02::1:3 dev eth1 lladdr 33:33:00:01:00:03 NOARP
[LINK]4: eth1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc fq_codel state DOWN group default 
    link/ether 18:74:e2:a0:00:a3 brd ff:ff:ff:ff:ff:ff
[LINK]4: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default 
    link/ether 18:74:e2:a0:00:a3 brd ff:ff:ff:ff:ff:ff
[LINK]5: eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default 
    link/ether 18:74:e2:a0:00:a8 brd ff:ff:ff:ff:ff:ff

> > The next logical question is, if a remote fault is RX'ed (potentially with a
> > reason) who will react on this. There might be different policies on how to
> > react on same reason.
> 
> Policy goes in userspace, is the general rule.

ack

> The only exception might be, if we decide to make use of one of these
> to silence the link to allow cabling testing. We probably want the
> kernel to try to do that.

ack :)

Regards
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

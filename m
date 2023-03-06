Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 893A26AC837
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 17:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbjCFQg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 11:36:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbjCFQgj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 11:36:39 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F9C93018D
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 08:36:12 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pZDoN-0007KU-Ne; Mon, 06 Mar 2023 17:35:43 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pZDoM-0005sl-FM; Mon, 06 Mar 2023 17:35:42 +0100
Date:   Mon, 6 Mar 2023 17:35:42 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, Eric Dumazet <edumazet@google.com>,
        kernel@pengutronix.de, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v1 2/2] net: dsa: microchip: add ETS Qdisc
 support for KSZ9477 series
Message-ID: <20230306163542.GB11936@pengutronix.de>
References: <20230306124940.865233-1-o.rempel@pengutronix.de>
 <20230306124940.865233-2-o.rempel@pengutronix.de>
 <20230306140651.kqayqatlrccfky2b@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230306140651.kqayqatlrccfky2b@skbuf>
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
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Mon, Mar 06, 2023 at 04:06:51PM +0200, Vladimir Oltean wrote:
> Hi Oleksij,
> 
> On Mon, Mar 06, 2023 at 01:49:40PM +0100, Oleksij Rempel wrote:
> > +	for (band = 0; band < p->bands; ++band) {
> > +		/* The KSZ switches utilize a weighted round robin configuration
> > +		 * where a certain number of packets can be transmitted from a
> > +		 * queue before the next queue is serviced. For more information
> > +		 * on this, refer to section 5.2.8.4 of the KSZ8565R
> > +		 * documentation on the Port Transmit Queue Control 1 Register.
> > +		 * However, the current ETS Qdisc implementation (as of February
> > +		 * 2023) assigns a weight to each queue based on the number of
> > +		 * bytes or extrapolated bandwidth in percentages. Since this
> > +		 * differs from the KSZ switches' method and we don't want to
> > +		 * fake support by converting bytes to packets, we have decided
> > +		 * to return an error instead.
> > +		 */
> > +		if (p->quanta[band]) {
> > +			dev_err(dev->dev, "Quanta/weights configuration is not supported.\n");
> > +			return -EOPNOTSUPP;
> > +		}
> 
> So what does the user gain using tc-ets over tc-mqprio? That has a way
> to set up strict prioritization and prio:tc maps as well, and to my
> knowledge mqprio is vastly more popular in non-DCB setups than tc-ets.
> The only thing is that with mqprio, AFAIK, the round robin between TXQs
> belonging to the same traffic class is not weighted.

Do mqprio already supports strict prio mode? net-next was not supporting
this back for two weeks. I do not care what to use, my motivation was based on
following points:
- tc-ets supports strict prio. mqprio need to be extended to do this
- tc-ets refers to IEEE 802.1Q specification, so i feel safe
  and do not need to invent new things.
- mqprio automatically creates software queues, but it seems to not
  provide any advantage for a typical bridged DSA setup. For example
  i can use queue mapping only for traffic from CPU to external DSA port
  but can't use multi queue advantages of CPU MAC for same traffic  (do I'm
  missing something). For bridged traffic i'll need to use HW offloading any
  way.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

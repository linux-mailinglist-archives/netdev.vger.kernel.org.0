Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5296AF0D8
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 19:37:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbjCGSgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 13:36:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233489AbjCGSgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 13:36:19 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5A968C0DA
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 10:28:29 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pZc2A-0006PO-4x; Tue, 07 Mar 2023 19:27:34 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pZc28-0002RL-RD; Tue, 07 Mar 2023 19:27:32 +0100
Date:   Tue, 7 Mar 2023 19:27:32 +0100
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
Message-ID: <20230307182732.GA1692@pengutronix.de>
References: <20230306124940.865233-1-o.rempel@pengutronix.de>
 <20230306124940.865233-2-o.rempel@pengutronix.de>
 <20230306140651.kqayqatlrccfky2b@skbuf>
 <20230306163542.GB11936@pengutronix.de>
 <20230307164614.jy2mzxvk3xgc4z7b@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230307164614.jy2mzxvk3xgc4z7b@skbuf>
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
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 07, 2023 at 06:46:14PM +0200, Vladimir Oltean wrote:
> On Mon, Mar 06, 2023 at 05:35:42PM +0100, Oleksij Rempel wrote:
> > > So what does the user gain using tc-ets over tc-mqprio? That has a way
> > > to set up strict prioritization and prio:tc maps as well, and to my
> > > knowledge mqprio is vastly more popular in non-DCB setups than tc-ets.
> > > The only thing is that with mqprio, AFAIK, the round robin between TXQs
> > > belonging to the same traffic class is not weighted.
> > 
> > Do mqprio already supports strict prio mode? net-next was not supporting
> > this back for two weeks. I do not care what to use, my motivation was based on
> > following points:
> > - tc-ets supports strict prio. mqprio need to be extended to do this
> > - tc-ets refers to IEEE 802.1Q specification, so i feel safe
> >   and do not need to invent new things.
> > - mqprio automatically creates software queues, but it seems to not
> >   provide any advantage for a typical bridged DSA setup. For example
> >   i can use queue mapping only for traffic from CPU to external DSA port
> >   but can't use multi queue advantages of CPU MAC for same traffic  (do I'm
> >   missing something). For bridged traffic i'll need to use HW offloading any
> >   way.
> 
> Sorry, my inbox is a mess and I forgot to respond to this.

No problem :)

> What do you mean tc-mqprio doesn't support strict priority? Strict
> priority between traffic classes is what it *does* (the "prio" in the name),
> although without hardware offload, the prioritization isn't enforced anywhere.
> Perhaps I'm misunderstanding what you mean?

Huh.. you have right, I overlooked this part of documentation:
"As one specific example numerous Ethernet cards support the
802.1Q link strict priority transmission selection algorithm
(TSA). MQPRIO enabled hardware in conjunction with the
classification methods below can provide hardware offloaded
support for this TSA."

But other parts of manual confuse me. May be you can help here:
- "map - The priority to traffic class map. Maps priorities 0..15 to a
   specified traffic class"
   "Priorities" is probably SO_PRIORITY? If yes, this option can't be offloaded
   by the KSZ switch.
- "queues - Provide count and offset of queue range for each traffic class..."
  If I see it correctly, I can map a traffic class to some queue. But traffic
  class is not priority? I can create traffic class with high number and map
  it to a low number queue but actual queue priority is HW specific and there
  is no way to notify user about it.
   
KSZ HW is capable of mapping 8 traffic classes separately to any available
queue. Ok, if I replace words used in manual from "priority" to "traffic class"
and "traffic class" to "queues". But even in this case the code will be even
more confusing - i'll have to use qopt->prio_tc_map array which is SO_PRIO to
TC map, as TC to queue map.

I still have difficulties to understand how priorities of actual queues
are organized. I see how to map traffic class to a queue, but I can't find
any thing in manual about queue priority. For example, if I assign traffic
class 3 to the Queue0 this traffic will have lowest priority in my HW. Is
it some how documented or known for users?

One more question is, what is actual expected behavior of mqprio if max_rate
option is used? In my case, if max_rate is set to a queue (even to max value),
then strict priority TSA will not work:
queue0---max rate 100Mbit/s---\
                               |---100Mbit/s---
queue1---max rate 100Mbit/s---/

in this example both streams will get 49Mbit/s. My expectation of strict prio
is that queue1 should get 100Mbit/s and queue 0Mbit/s

On other hand tc-ets made perfect sense to me from documentation and code pow.
TC is mapped to bands. Bands have documented priorities and it fit's to what
KSZ is supporting. Except of WRR configuration.

> For strict prioritization using multi-queue on the DSA master you should
> be able to set up a separate Qdisc.

I'll need to do more testing with FEC later, it didn't worked at first try, but
as you can see I still have a lot of misunderstandings.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

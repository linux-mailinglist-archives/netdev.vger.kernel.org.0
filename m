Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F356F6AF642
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 20:58:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbjCGT6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 14:58:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbjCGT55 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 14:57:57 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97D9A7A8D
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 11:52:54 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pZdMi-00012v-FY; Tue, 07 Mar 2023 20:52:52 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pZdMg-0006qC-Qg; Tue, 07 Mar 2023 20:52:50 +0100
Date:   Tue, 7 Mar 2023 20:52:50 +0100
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
Message-ID: <20230307195250.GB1692@pengutronix.de>
References: <20230306124940.865233-1-o.rempel@pengutronix.de>
 <20230306124940.865233-2-o.rempel@pengutronix.de>
 <20230306140651.kqayqatlrccfky2b@skbuf>
 <20230306163542.GB11936@pengutronix.de>
 <20230307164614.jy2mzxvk3xgc4z7b@skbuf>
 <20230307182732.GA1692@pengutronix.de>
 <20230307185734.x2lv4j3ml3fzfzoy@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230307185734.x2lv4j3ml3fzfzoy@skbuf>
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

On Tue, Mar 07, 2023 at 08:57:34PM +0200, Vladimir Oltean wrote:
> On Tue, Mar 07, 2023 at 07:27:32PM +0100, Oleksij Rempel wrote:
> > > What do you mean tc-mqprio doesn't support strict priority? Strict
> > > priority between traffic classes is what it *does* (the "prio" in the name),
> > > although without hardware offload, the prioritization isn't enforced anywhere.
> > > Perhaps I'm misunderstanding what you mean?
> > 
> > Huh.. you have right, I overlooked this part of documentation:
> > "As one specific example numerous Ethernet cards support the
> > 802.1Q link strict priority transmission selection algorithm
> > (TSA). MQPRIO enabled hardware in conjunction with the
> > classification methods below can provide hardware offloaded
> > support for this TSA."
> > 
> > But other parts of manual confuse me.
> 
> Not only you...
> Does this discussion help any bit?
> https://patchwork.kernel.org/project/netdevbpf/patch/20230220150548.2021-1-peti.antal99@gmail.com/

Ok, thx.

> > - "queues - Provide count and offset of queue range for each traffic class..."
> >   If I see it correctly, I can map a traffic class to some queue.
> 
> s/queue/group of TX queues/

grouping of TX queues to the same TC is not supported by this HW, but
yes, this description is more precise.

> >   But traffic class is not priority? I can create traffic class with high number
> >   and map it to a low number queue but actual queue priority is HW specific and
> >   there is no way to notify user about it.
> 
> no, where did you read that you should do that?
> traffic class number *is* the number based on which the NIC should do
> egress prioritization. Higher traffic class number => higher priority.

Ok, this was the missing part.

> > One more question is, what is actual expected behavior of mqprio if max_rate
> > option is used? In my case, if max_rate is set to a queue (even to max value),
> > then strict priority TSA will not work:
> > queue0---max rate 100Mbit/s---\
> >                                |---100Mbit/s---
> > queue1---max rate 100Mbit/s---/
> > 
> > in this example both streams will get 49Mbit/s. My expectation of strict prio
> > is that queue1 should get 100Mbit/s and queue 0Mbit/s
> 
> I don't understand this. Have you already implemented mqprio offloading
> and this is what you observe?

Ack.

> max_rate is an option per traffic class. Are queue0 and queue1 mapped to
> the same traffic class in your example, or are they not?

They are separate TCs. It is not possible to assign multiple TXQs to on TC on
KSZ.

> Could you show the full ommand you ran?

tc qdisc add dev lan2 parent root handle 100 mqprio num_tc 4 map 0 1 2 3
queues 1@0 1@1 1@2 1@3  hw 1 mode channel shaper bw_rlimit max_rate
70Mbit 70Mbit 70Mbit 70Mbit

lan2 is bridged with lan1 and lan3. Egress traffic on lan2 is from lan1 and lan3.
For testing I use 2 iperf3 instances with different PCP values in the VLAN tag.
Classification is done by HW (currently not configurable from user space)

> > On other hand tc-ets made perfect sense to me from documentation and code pow.
> > TC is mapped to bands. Bands have documented priorities and it fit's to what
> > KSZ is supporting. Except of WRR configuration.
> 
> I haven't used tc-ets, I was just curious about the differences you saw
> between it and mqprio which led to you choosing it.

Currently, the main difference would be flexible TC:TXQ mapping. In case
of mqprio it should be hard coded.

> > > For strict prioritization using multi-queue on the DSA master you should
> > > be able to set up a separate Qdisc.
> > 
> > I'll need to do more testing with FEC later, it didn't worked at first try, but
> > as you can see I still have a lot of misunderstandings.
> 
> fec doesn't seem to implement ndo_setup_tc() at all, so I'm not sure
> what you're going to try exactly.  OTOH it has this weird ndo_select_queue()
> implementation which (I think) implements multi-queue based on VLAN PCP.

Yes, this is exactly what I wont to investigate. How it should be
configured to work as plain interface and compare it combination with
DSA master. My tests are based on VLAN PCP, but only one queue is used.

> sorry for the quick response, need to go right now

No proble. Have fun.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

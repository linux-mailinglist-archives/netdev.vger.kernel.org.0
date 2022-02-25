Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3F334C4503
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 13:55:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239167AbiBYMzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 07:55:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbiBYMzI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 07:55:08 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E3D221CD35
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 04:54:33 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nNa7D-0008N1-I1; Fri, 25 Feb 2022 13:54:31 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nNa7C-0007ew-BD; Fri, 25 Feb 2022 13:54:30 +0100
Date:   Fri, 25 Feb 2022 13:54:30 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        kernel@pengutronix.de, Jakub Kicinski <kuba@kernel.org>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v2 1/1] net: dsa: microchip: ksz9477: implement
 MTU configuration
Message-ID: <20220225125430.GB27407@pengutronix.de>
References: <20220223084055.2719969-1-o.rempel@pengutronix.de>
 <20220223233833.mjknw5ko7hpxj3go@skbuf>
 <20220224045936.GB4594@pengutronix.de>
 <20220224093329.hssghouq7hmgxvwb@skbuf>
 <20220224093827.GC4594@pengutronix.de>
 <20220224094657.jzhvi67ryhuipor4@skbuf>
 <20220225114740.GA27407@pengutronix.de>
 <20220225115802.bvjd54cwwk6hjyfa@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220225115802.bvjd54cwwk6hjyfa@skbuf>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 13:01:41 up 76 days, 20:47, 89 users,  load average: 0.73, 0.65,
 0.38
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 25, 2022 at 01:58:02PM +0200, Vladimir Oltean wrote:
> On Fri, Feb 25, 2022 at 12:47:40PM +0100, Oleksij Rempel wrote:
> > On Thu, Feb 24, 2022 at 11:46:57AM +0200, Vladimir Oltean wrote:
> >  
> > > So where is it failing exactly? Here I guess, because mtu_limit will be
> > > negative?
> > > 
> > > 	mtu_limit = min_t(int, master->max_mtu, dev->max_mtu);
> > > 	old_master_mtu = master->mtu;
> > > 	new_master_mtu = largest_mtu + dsa_tag_protocol_overhead(cpu_dp->tag_ops);
> > > 	if (new_master_mtu > mtu_limit)
> > > 		return -ERANGE;
> > > 
> > > I don't think we can work around it in DSA, it's garbage in, garbage out.
> > > 
> > > In principle, I don't have such a big issue with writing the MTU
> > > register as part of the switch initialization, especially if it's global
> > > and not per port. But tell me something else. You pre-program the MTU
> > > with VLAN_ETH_FRAME_LEN + ETH_FCS_LEN, but in the MTU change procedure,
> > > you also add KSZ9477_INGRESS_TAG_LEN (2) to that. Is that needed at all?
> > > I expect that if it's needed, it's needed in both places. Can you
> > > sustain an iperf3 tcp session over a VLAN upper of a ksz9477 port?
> > > I suspect that the missing VLAN_HLEN is masking a lack of KSZ9477_INGRESS_TAG_LEN.
> > 
> > Hm... I assume I need to do something like this:
> > - build kernel with BRIDGE_VLAN_FILTERING
> > - |
> >   ip l a name br0 type bridge vlan_filtering 1
> >   ip l s dev br0 up
> >   ip l s lan1 master br0
> >   ip l s dev lan1 up
> >   bridge vlan add dev lan1 vid 5 pvid untagged
> >   ip link add link br0 name vlan5 type vlan id 5
> > 
> > I use lan5@ksz for net boot. As soon as i link lan1@ksz to the br0 with
> > vlan_filtering enabled, the nfs on lan5 will be broken. Currently I have
> > no time to investigate it. I'll try to fix VLAN support in a separate
> > task. What will is acceptable way to proceed with MTU patch?
> 
> No bridge, why create a bridge? And even if you do, why add lan5 to it?
> The expectation is that standalone ports still remain functional when
> other ports join a bridge.

No, lan5 is not added to the bridge, but stops functioning after creating
br with lan1 or any other lanX

> I was saying:
> 
> ip link set lan1 up
> ip link add link lan1 name lan1.5 type vlan id 5
> ip addr add 172.17.0.2/24 dev lan1.5 && ip link set lan1.5 up
> iperf3 -c 172.17.0.10

It works.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

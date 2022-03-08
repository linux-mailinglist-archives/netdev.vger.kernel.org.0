Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 578BA4D1438
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 11:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345618AbiCHKHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 05:07:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236103AbiCHKHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 05:07:43 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B82424B2
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 02:06:47 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nRWjt-0000Ie-Cn; Tue, 08 Mar 2022 11:06:45 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nRWjs-0004da-Iq; Tue, 08 Mar 2022 11:06:44 +0100
Date:   Tue, 8 Mar 2022 11:06:44 +0100
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
Message-ID: <20220308100644.GA5189@pengutronix.de>
References: <20220223084055.2719969-1-o.rempel@pengutronix.de>
 <20220223233833.mjknw5ko7hpxj3go@skbuf>
 <20220224045936.GB4594@pengutronix.de>
 <20220224093329.hssghouq7hmgxvwb@skbuf>
 <20220224093827.GC4594@pengutronix.de>
 <20220224094657.jzhvi67ryhuipor4@skbuf>
 <20220225114740.GA27407@pengutronix.de>
 <20220225115802.bvjd54cwwk6hjyfa@skbuf>
 <20220225125430.GB27407@pengutronix.de>
 <20220225163543.vnqlkltgmwf4vlmm@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220225163543.vnqlkltgmwf4vlmm@skbuf>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:48:47 up 87 days, 18:34, 88 users,  load average: 0.25, 0.29,
 0.22
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

On Fri, Feb 25, 2022 at 06:35:43PM +0200, Vladimir Oltean wrote:
> On Fri, Feb 25, 2022 at 01:54:30PM +0100, Oleksij Rempel wrote:
> > > No bridge, why create a bridge? And even if you do, why add lan5 to it?
> > > The expectation is that standalone ports still remain functional when
> > > other ports join a bridge.
> > 
> > No, lan5 is not added to the bridge, but stops functioning after creating
> > br with lan1 or any other lanX
> 
> Please take time to investigate the problem and fix it.

ack

> > > I was saying:
> > > 
> > > ip link set lan1 up
> > > ip link add link lan1 name lan1.5 type vlan id 5
> > > ip addr add 172.17.0.2/24 dev lan1.5 && ip link set lan1.5 up
> > > iperf3 -c 172.17.0.10
> > 
> > It works.
> 
> This is akin to saying that without any calls to ksz9477_change_mtu(),
> just writing VLAN_ETH_FRAME_LEN + ETH_FCS_LEN into REG_SW_MTU__2 is
> sufficient to get VLAN-tagged MTU-sized packets to pass through the CPU
> port and the lan1 user port.
> 
> So my question is: is this necessary?
> 
> 	if (dsa_is_cpu_port(ds, port))
> 		new_mtu += KSZ9477_INGRESS_TAG_LEN;
> 

No.

I did some extra tests with following results: REG_SW_MTU__2 should be
configured to 1518 to pass 1514 frame. Independent if the frame is
passed between external ports or external to CPU port. So, I assume,
ETH_FRAME_LEN + ETH_FCS_LEN should be used instead of VLAN_ETH_FRAME_LEN
+ ETH_FCS_LEN. Correct?

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

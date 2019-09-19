Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98E56B7563
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 10:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731914AbfISIoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 04:44:18 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:47059 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbfISIoS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 04:44:18 -0400
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1iAs2y-0001F8-VG; Thu, 19 Sep 2019 10:44:16 +0200
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <sha@pengutronix.de>)
        id 1iAs2y-00026w-8h; Thu, 19 Sep 2019 10:44:16 +0200
Date:   Thu, 19 Sep 2019 10:44:16 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        kernel@pengutronix.de
Subject: Re: dsa traffic priorization
Message-ID: <20190919084416.33ifxohtgkofrleb@pengutronix.de>
References: <20190918140225.imqchybuf3cnknob@pengutronix.de>
 <CA+h21hpG52R6ScGpGX86Q7MuRHCgGNY-TxzaQGu2wZR8EtPtbA@mail.gmail.com>
 <1b80f9ed-7a62-99c4-10bc-bc1887f80867@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b80f9ed-7a62-99c4-10bc-bc1887f80867@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:41:49 up 73 days, 14:52, 85 users,  load average: 0.13, 0.17,
 0.17
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Wed, Sep 18, 2019 at 10:41:58AM -0700, Florian Fainelli wrote:
> On 9/18/19 7:36 AM, Vladimir Oltean wrote:
> > Hi Sascha,
> > 
> > On Wed, 18 Sep 2019 at 17:03, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> >>
> >> Hi All,
> >>
> >> We have a customer using a Marvell 88e6240 switch with Ethercat on one port and
> >> regular network traffic on another port. The customer wants to configure two things
> >> on the switch: First Ethercat traffic shall be priorized over other network traffic
> >> (effectively prioritizing traffic based on port). Second the ethernet controller
> >> in the CPU is not able to handle full bandwidth traffic, so the traffic to the CPU
> >> port shall be rate limited.
> >>
> > 
> > You probably already know this, but egress shaping will not drop
> > frames, just let them accumulate in the egress queue until something
> > else happens (e.g. queue occupancy threshold triggers pause frames, or
> > tail dropping is enabled, etc). Is this what you want? It sounds a bit
> > strange to me to configure egress shaping on the CPU port of a DSA
> > switch. That literally means you are buffering frames inside the
> > system. What about ingress policing?
> 
> Indeed, but I suppose that depending on the switch architecture and/or
> nomenclature, configuring egress shaping amounts to determining ingress
> for the ports where the frame is going to be forwarded to.
> 
> For instance Broadcom switches rarely if at all mention ingress because
> the frames have to originate from somewhere and be forwarded to other
> port(s), therefore, they will egress their original port (which for all
> practical purposes is the direct continuation of the ingress stage),
> where shaping happens, which immediately influences the ingress shaping
> of the destination port, which will egress the frame eventually because
> packets have to be delivered to the final port's egress queue anyway.
> 
> > 
> >> For reference the patch below configures the switch to their needs. Now the question
> >> is how this can be implemented in a way suitable for mainline. It looks like the per
> >> port priority mapping for VLAN tagged packets could be done via ip link add link ...
> >> ingress-qos-map QOS-MAP. How the default priority would be set is unclear to me.
> >>
> > 
> > Technically, configuring a match-all rxnfc rule with ethtool would
> > count as 'default priority' - I have proposed that before. Now I'm not
> > entirely sure how intuitive it is, but I'm also interested in being
> > able to configure this.
> 
> That does not sound too crazy from my perspective.
> 
> > 
> >> The other part of the problem seems to be that the CPU port has no network device
> >> representation in Linux, so there's no interface to configure the egress limits via tc.
> >> This has been discussed before, but it seems there hasn't been any consensous regarding how
> >> we want to proceed?
> 
> You have the DSA master network device which is on the other side of the
> switch,

You mean the (in my case) i.MX FEC? Everything I do on this device ends
up in the FEC itself and not on the switch, right?

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

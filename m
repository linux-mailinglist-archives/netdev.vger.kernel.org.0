Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D782B749E
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 10:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388367AbfISIAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 04:00:55 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:39029 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387523AbfISIAy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 04:00:54 -0400
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1iArMy-0004ke-Sh; Thu, 19 Sep 2019 10:00:52 +0200
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <sha@pengutronix.de>)
        id 1iArMx-0000S5-SC; Thu, 19 Sep 2019 10:00:51 +0200
Date:   Thu, 19 Sep 2019 10:00:51 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Florian Fainelli <f.fainelli@gmail.com>, kernel@pengutronix.de
Subject: Re: dsa traffic priorization
Message-ID: <20190919080051.mr3cszpyypwqjwu4@pengutronix.de>
References: <20190918140225.imqchybuf3cnknob@pengutronix.de>
 <CA+h21hpG52R6ScGpGX86Q7MuRHCgGNY-TxzaQGu2wZR8EtPtbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hpG52R6ScGpGX86Q7MuRHCgGNY-TxzaQGu2wZR8EtPtbA@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:38:06 up 73 days, 13:48, 76 users,  load average: 0.01, 0.07,
 0.08
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Wed, Sep 18, 2019 at 05:36:08PM +0300, Vladimir Oltean wrote:
> Hi Sascha,
> 
> On Wed, 18 Sep 2019 at 17:03, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> >
> > Hi All,
> >
> > We have a customer using a Marvell 88e6240 switch with Ethercat on one port and
> > regular network traffic on another port. The customer wants to configure two things
> > on the switch: First Ethercat traffic shall be priorized over other network traffic
> > (effectively prioritizing traffic based on port). Second the ethernet controller
> > in the CPU is not able to handle full bandwidth traffic, so the traffic to the CPU
> > port shall be rate limited.
> >
> 
> You probably already know this, but egress shaping will not drop
> frames, just let them accumulate in the egress queue until something
> else happens (e.g. queue occupancy threshold triggers pause frames, or
> tail dropping is enabled, etc). Is this what you want?

If I understand correctly then the switch has multiple output queues per
port. The Ethercat traffic will go to a higher priority queue and on
congestion on other queues, frames designated for that queue will be
dropped. I just talked to our customer and he verified that their
Ethercat traffic still goes through even when the ports with the general
traffic are jammed with packets. So yes, I think this is what I want.

> It sounds a bit
> strange to me to configure egress shaping on the CPU port of a DSA
> switch. That literally means you are buffering frames inside the
> system. What about ingress policing?

The bottleneck here is in the CPU interface. The SoC simply can't handle
all frames coming into a fully occupied link, so we indeed have to limit
the number of packets coming into the SoC which speaks for egress rate
limiting. We could of course limit the ingress packets on the other
ports, but that would mean we have to rate limit each port to the total
desired rate divided by the number of ports to be safe, not very
optimal.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

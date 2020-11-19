Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 907AB2B9BE8
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 21:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727719AbgKSUSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 15:18:11 -0500
Received: from mailout08.rmx.de ([94.199.90.85]:35412 "EHLO mailout08.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727304AbgKSUSL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 15:18:11 -0500
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout08.rmx.de (Postfix) with ESMTPS id 4CcWFp6tRtzMpmr;
        Thu, 19 Nov 2020 21:18:06 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4CcWFZ1xFVz2TS6Z;
        Thu, 19 Nov 2020 21:17:54 +0100 (CET)
Received: from n95hx1g2.localnet (192.168.54.21) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Thu, 19 Nov
 2020 21:16:53 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     <Tristram.Ha@microchip.com>
CC:     <olteanv@gmail.com>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <richardcochran@gmail.com>, <robh+dt@kernel.org>,
        <vivien.didelot@gmail.com>, <davem@davemloft.net>,
        <kurt.kanzenbach@linutronix.de>, <george.mccollister@gmail.com>,
        <marex@denx.de>, <helmut.grohne@intenta.de>,
        <pbarker@konsulko.com>, <Codrin.Ciubotariu@microchip.com>,
        <Woojung.Huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v3 00/12] net: dsa: microchip: PTP support for KSZ956x
Date:   Thu, 19 Nov 2020 21:16:51 +0100
Message-ID: <2371588.77hP0NP6gc@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <BYAPR11MB35582F880B533EB2EE0CDD1DECE00@BYAPR11MB3558.namprd11.prod.outlook.com>
References: <20201118203013.5077-1-ceggers@arri.de> <2452899.Bt8PnbAPR0@n95hx1g2> <BYAPR11MB35582F880B533EB2EE0CDD1DECE00@BYAPR11MB3558.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.21]
X-RMX-ID: 20201119-211754-4CcWFZ1xFVz2TS6Z-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tristram,

thank you for joining this thread.

On Thursday, 19 November 2020, 19:51:15 CET, Tristram.Ha@microchip.com wrote:
> > On Thursday, 19 November 2020, 00:40:18 CET, Vladimir Oltean wrote:
> > > On Wed, Nov 18, 2020 at 09:30:01PM +0100, Christian Eggers wrote:
> > > [...]
> > [...]
> These are general comments about this PTP patch.
> 
> The initial proposal in tag_ksz.c is for the switch driver to provide
> callback functions to handle receiving and transmitting.  Then each switch
> driver can be added to process the tail tag in its own driver and leave
> tag_ksz.c unchanged. 
> It was rejected because of wanting to keep tag_ksz.c code and switch driver
> code separate and concern about performance.
> 
> Now tag_ksz.c is filled with PTP code that is not relevant for other
> switches and will need to be changed again when another switch driver with
> PTP function is added. 
> Can we implement that callback mechanism?
I didn't read the full history of the tagging driver. Vladimir already asked
whether I could put more stuff into the device driver. Lets wait for his
advice how to do this best.

> One issue with transmission with PTP enabled is that the tail tag needs to
> contain 4 additional bytes.  When the PTP function is off the bytes are
> not added.  This should be monitored all the time.
Currently, enabling the PTP function is only dependent on
CONFIG_NET_DSA_MICROCHIP_KSZ9477_PTP. The same condition is used for inserting
the additional 4 bytes.

> The extra 4 bytes are only used for 1-step Pdelay_Resp.  It should contain
> the receive timestamp of previous Pdelay_Req with latency adjusted.  The
> correction field in Pdelay_Resp should be zero.  It may be a hardware bug
> to have wrong UDP checksum when the message is sent.
Thanks for clarifying this.

> I think the right implementation is for the driver to remember this receive
> timestamp of Pdelay_Req and puts it in the tail tag when it sees a 1-step
> Pdelay_Resp is sent. 
I would like keep the current method ("time stamp to correction" on RX, 
"correction to tail tag" on TX). Otherwise the driver would have to keep a 
list
of rx time stamps which could grow if no corresponding PDelay_Resp is sent.
It was also discussed about creating a new interface for bringing the time
stamp to user space and then back into the kernel. But this has been rejected.

> There is one more requirement that is a little difficult to do.  The
> calculated peer delay needs to be programmed in hardware register, but the
> regular PTP stack has no way to send that command.
I already recognized that register. Can you please provide some more 
information what the switch does with this value? At least when I connect only
two boards, I get almost perfect synchronization (PPS output) without writing
anything to this register. Looks like this only affects forwarded messages,
right?

> I think the driver has to do its own calculation by snooping on the
> Pdelay_Req/Pdelay_Resp/Pdelay_Resp_Follow_Up messages.
As I already wrote, I am definitely not an expert for PTP. But if I remember
correctly, the delay values used by ptp4l are the result of filtering several 
delay measurements. I don't think that this algorithm should be duplicated in
the kernel. 

On the other hand, there is currently no interface for this. In my internal
tree, I have created sysfs entries for this, so that (a modified version of)
ptp4l could write the measured values. I also recognized, that ptp4l has some
kind of remote interface (I haven't really looked at it). Maybe it is possible
to do necessary management of the switch outside ptp4l in a separate process.

One other important question was about the internal "filter". Richard rejected
the idea of "manually" switching between the "master" and "slave" mode. Is
there any (undocumented) register bit for disabling filtering of Sync/
Delay_Req
messages entirely?

> The receive and transmit latencies are different for different connected
> speed.  So the driver needs to change them when the link changes.  For
> that reason the PTP stack should not use its own latency values as
> generally the application does not care about the linked speed.
Up to now, I didn't configure any latency values in ptp4l. I assume that the
power on default values are fine for 1000 MBit/s. Can you provide the latency
values for other links speeds? Would it be a major limitation if PTP 
functionality depend on 1000 MBit/s?

regards
Christian




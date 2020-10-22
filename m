Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABEF0295C94
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 12:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896452AbgJVKTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 06:19:08 -0400
Received: from mailout08.rmx.de ([94.199.90.85]:55927 "EHLO mailout08.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896433AbgJVKTH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Oct 2020 06:19:07 -0400
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout08.rmx.de (Postfix) with ESMTPS id 4CH3HW1WpQzMsy6;
        Thu, 22 Oct 2020 12:19:03 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4CH3HG3XSJz2TTM3;
        Thu, 22 Oct 2020 12:18:50 +0200 (CEST)
Received: from n95hx1g2.localnet (192.168.54.85) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Thu, 22 Oct
 2020 12:17:49 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Woojung Huh <woojung.huh@microchip.com>,
        "Microchip Linux Driver Support" <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 7/9] net: dsa: microchip: ksz9477: add hardware time stamping support
Date:   Thu, 22 Oct 2020 12:17:48 +0200
Message-ID: <1680734.pGj3N1mgWS@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <2975985.V79r5fVmzq@n95hx1g2>
References: <20201019172435.4416-1-ceggers@arri.de> <20201022023233.GA904@hoboy.vegasvil.org> <2975985.V79r5fVmzq@n95hx1g2>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.85]
X-RMX-ID: 20201022-121850-4CH3HG3XSJz2TTM3-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday, 22 October 2020, 09:30:57 CEST, Christian Eggers wrote:
> On Thursday, 22 October 2020, 04:42:01 CEST, Richard Cochran wrote:
> > On Thu, Oct 22, 2020 at 02:39:35AM +0300, Vladimir Oltean wrote:
> > > On Mon, Oct 19, 2020 at 07:24:33PM +0200, Christian Eggers wrote:
> > > > The PTP hardware performs internal detection of PTP frames (likely
> > > > similar as ptp_classify_raw() and ptp_parse_header()). As these
> > > > filters
> > > > cannot be disabled, the current delay mode (E2E/P2P) and the clock
> > > > mode
> > > > (master/slave) must be configured via sysfs attributes.
> > 
> > This is a complete no-go.  NAK.
> 
> I didn't design the hardware nor do I have access to adequate documentation.
> I will try to figure out what functionality is concretely affected by these
> two settings.
I tried to study the effect of setting the ocmode bit on the KSZ either to
master or to slave. The main visible change is, that some PTP message types
are be filtered out on RX:
- in "master" mode, "Sync" messages from other nodes will not be received
(but everything else like "Announce" seem to work)
- in "slave" mode, "Delay_Req" messages from other nodes will not be received

I am not an expert for PTP, so the following is only the idea of a beginner how
this could probably be handled:

As PTP announce messages are received all the time, the BMCA should always
be able to work. The KSZ hardware needs to be set to "master" when a node
is becoming master (in order to be able to receive (and answer) Delay_Req
messages). The setting "slave" is equired when the BCMA decides not being
master anymore (in order to receive Sync messages).

Handling the transition to "master" mode could probably be done easily in the 
driver (when a Sync message is seen in TX direction by the time stamping code).
But transition to slave seems to be difficult, because the tagging driver cannot
see when the node stops being master. For user space (ptp4l), the decision for
master/slave mode could probably be done easier.

If Richard (or somebody else) decides that "mode switching" of the KSZ device
would not be appropriate, I suspect the functionality of the KSZ has to be
limited to "Slave Only Clock".

regards
Christian




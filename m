Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E134C29593E
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 09:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2508567AbgJVHcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 03:32:17 -0400
Received: from mailout08.rmx.de ([94.199.90.85]:34111 "EHLO mailout08.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2508538AbgJVHcR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Oct 2020 03:32:17 -0400
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout08.rmx.de (Postfix) with ESMTPS id 4CGzb05T30zMtN6;
        Thu, 22 Oct 2020 09:32:12 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4CGzZm0HM5z2xKF;
        Thu, 22 Oct 2020 09:32:00 +0200 (CEST)
Received: from n95hx1g2.localnet (192.168.54.141) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Thu, 22 Oct
 2020 09:30:58 +0200
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
Date:   Thu, 22 Oct 2020 09:30:57 +0200
Message-ID: <2975985.V79r5fVmzq@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <20201022023233.GA904@hoboy.vegasvil.org>
References: <20201019172435.4416-1-ceggers@arri.de> <20201021233935.ocj5dnbdz7t7hleu@skbuf> <20201022023233.GA904@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.141]
X-RMX-ID: 20201022-093200-4CGzZm0HM5z2xKF-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Richard,

On Thursday, 22 October 2020, 04:42:01 CEST, Richard Cochran wrote:
> I'm just catching up with this.
> 
> Really. Truly. Please -- Include the maintainer on CC for such patches!
sorry for missing you on the recipients list. I blindly trusted the output of
get_maintainer.pl.

I recently sent two other patches which may also be of interest for you. They
related to handling of SO_TIMESTAMPING on 32 bit platforms with newer C 
libraries:

https://patchwork.ozlabs.org/project/netdev/patch/20201012093542.15504-1-ceggers@arri.de/
https://patchwork.ozlabs.org/project/netdev/patch/20201012093542.15504-2-ceggers@arri.de/

> On Thu, Oct 22, 2020 at 02:39:35AM +0300, Vladimir Oltean wrote:
> > On Mon, Oct 19, 2020 at 07:24:33PM +0200, Christian Eggers wrote:
> > > The PTP hardware performs internal detection of PTP frames (likely
> > > similar as ptp_classify_raw() and ptp_parse_header()). As these filters
> > > cannot be disabled, the current delay mode (E2E/P2P) and the clock mode
> > > (master/slave) must be configured via sysfs attributes.
> 
> This is a complete no-go.  NAK.
I didn't design the hardware nor do I have access to adequate documentation.
I will try to figure out what functionality is concretely affected by these
two settings.

If I am correct, the KSZ hardware consists of two main building blocks:
1. A TC on the switch path.
2. An OC on the DSA host port.

From the data sheet, page 109, chapter 5.1.6.11
("Global PTP Message Config 1 Register"), bit 2:

> *Selection of P2P or E2E*
> 1 = Peer-to-peer (P2P) transparent clock mode
> 0 = End-to-end (E2E) transparent clock mode
So this "tcmode" sysfs entry controls the behavior of the switch' transparent
clock. Is this related in any way to the PTP API?

For the master/slave setting, the data sheet writes the following:
*Selection of Master or Slave*
1 = Host port is PTP master ordinary clock
0 = Host port is PTP slave ordinary clock

So this is really related to the OC and so to the PTP API. Setting this
manually would interfere with the BMCA. I'll check whether delay measurement
and clock synchronization can also work for all conditions (E2E/P2P, 
master/slave) without altering this value. Otherwise we might consider
the KSZ as a "Slave Only Clock (SO)".

Christian




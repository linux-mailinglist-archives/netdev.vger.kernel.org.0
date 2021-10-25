Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 455884391E6
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 11:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232484AbhJYJCl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 05:02:41 -0400
Received: from relay-b01.edpnet.be ([212.71.1.221]:43812 "EHLO
        relay-b01.edpnet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232413AbhJYJCe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 05:02:34 -0400
X-ASG-Debug-ID: 1635152410-15c43417981e6c6b0001-BZBGGp
Received: from zotac.vandijck-laurijssen.be (94.105.120.149.dyn.edpnet.net [94.105.120.149]) by relay-b01.edpnet.be with ESMTP id WbBKmQf0ka8e3oI4; Mon, 25 Oct 2021 11:00:10 +0200 (CEST)
X-Barracuda-Envelope-From: dev.kurt@vandijck-laurijssen.be
X-Barracuda-Effective-Source-IP: 94.105.120.149.dyn.edpnet.net[94.105.120.149]
X-Barracuda-Apparent-Source-IP: 94.105.120.149
Received: from x1.vandijck-laurijssen.be (163.145-241-81.adsl-dyn.isp.belgacom.be [81.241.145.163])
        by zotac.vandijck-laurijssen.be (Postfix) with ESMTPSA id 3048916B46CE;
        Mon, 25 Oct 2021 11:00:10 +0200 (CEST)
Date:   Mon, 25 Oct 2021 11:00:08 +0200
From:   Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can <linux-can@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: Re: ethtool: ring configuration for CAN devices
Message-ID: <20211025090008.GD7834@x1.vandijck-laurijssen.be>
X-ASG-Orig-Subj: Re: ethtool: ring configuration for CAN devices
Mail-Followup-To: Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can <linux-can@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        netdev@vger.kernel.org
References: <20211024213759.hwhlb4e3repkvo6y@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211024213759.hwhlb4e3repkvo6y@pengutronix.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-Barracuda-Connect: 94.105.120.149.dyn.edpnet.net[94.105.120.149]
X-Barracuda-Start-Time: 1635152410
X-Barracuda-URL: https://212.71.1.221:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 3100
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=7.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.93506
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------------------------
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 24 Oct 2021 23:37:59 +0200, Marc Kleine-Budde wrote:
> Hello,
> 
> I'm currently working on runtime configurable RX/TX ring sizes for a the
> mcp251xfd CAN driver.
> 
> Unlike modern Ethernet cards with DMA support, most CAN IP cores come
> with a fixed size on chip RAM that's used to store received CAN frames
> and frames that should be sent.
> 
> For CAN-2.0 only devices that can be directly supported via ethtools's
> set/get_ringparam. A minor unaesthetic is, as the on chip RAM is usually
> shared between RX and TX, the maximum values for RX and TX cannot be set
> at the same time.
> 
> The mcp251xfd chip I'm enhancing supports CAN-2.0 and CAN-FD mode. The
> relevant difference of these modes is the size of the CAN frame. 8 vs 64
> bytes of payload + 12 bytes of header. This means we have different
> maximum values for both RX and TX for those modes.
> 
> How do we want to deal with the configuration of the two different
> modes? As the current set/get_ringparam interface can configure the
> mini- and jumbo frames for RX, but has only a single TX value.
> 
> Hao Chen and Guangbin Huang are laying the groundwork to extend the
> ringparam interface via netlink:
> 
> | https://lore.kernel.org/all/20211014113943.16231-1-huangguangbin2@huawei.com
> 
> I was thinking about adding rx/tx_pending for CAN-FD. The use case would
> be to configure the ring parameters independent of the current active
> CAN mode. For example in systemd the RX/TX ring parameters are
> configured in the .link file, while the CAN FD mode is configured in a
> .network file. When switching to the other CAN mode, the previously
> configured ring configuration of that CAN mode will be applied to the
> hardware.
> 
> In my proof of concept implementation I'm misusing the struct
> ethtool_ringparam's mini and jumbo values to pre-configure the CAN-2.0
> and CAN-FD mode's RX ring size, but this is not mainlinable from my
> point of view.
> 
> I'm interested in your opinion and use cases.

Isn't the simplest setup to stick to the current CAN mode (2.0 vs. FD).

Certain values/combinations may be valid in 2.0 and not in FD. So what?
This is true also for data-bittiming and what not.

I see no advantage in putting your configuration in different files
(.link and .network), since they influence each other.
I can imaging one network operating in FD, with certain rx/tx settings,
and another network operating in 2.0, with different rx/tx settings.
and a 3rd network operating in FD, with also different rx/tx settings.

If that is a problem for systemd, then ... fix systemd?
(systemd is really out of my scope, I'm not used to it)

IMHO, you try to provide different default settings (rx/tx split) for FD
and 2.0 mode.

> 
> regards,
> Marc
> 
> -- 
> Pengutronix e.K.                 | Marc Kleine-Budde           |
> Embedded Linux                   | https://www.pengutronix.de  |
> Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
> Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |



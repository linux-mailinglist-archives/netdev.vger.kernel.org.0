Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1B102FF499
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 20:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727380AbhAUTdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 14:33:41 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53110 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725956AbhAUTco (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 14:32:44 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l2f7G-001sMI-Tt; Thu, 21 Jan 2021 19:55:34 +0100
Date:   Thu, 21 Jan 2021 19:55:34 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: ethtool: allow MAC drivers to override
 ethtool get_ts_info
Message-ID: <YAnOJhG1Eh4gjglr@lunn.ch>
References: <20210114132217.GR1551@shell.armlinux.org.uk>
 <20210114133235.GP1605@shell.armlinux.org.uk>
 <20210114172712.GA13644@hoboy.vegasvil.org>
 <20210114173111.GX1551@shell.armlinux.org.uk>
 <20210114223800.GR1605@shell.armlinux.org.uk>
 <20210121040451.GB14465@hoboy.vegasvil.org>
 <20210121102738.GN1551@shell.armlinux.org.uk>
 <20210121150611.GA20321@hoboy.vegasvil.org>
 <YAmqTUdMXOmd/rYI@lunn.ch>
 <20210121170347.GA22517@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210121170347.GA22517@hoboy.vegasvil.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 21, 2021 at 09:03:47AM -0800, Richard Cochran wrote:
> On Thu, Jan 21, 2021 at 05:22:37PM +0100, Andrew Lunn wrote:
> 
> > There is a growing interesting in PTP, the number of drivers keeps
> > going up. The likelihood of MAC/PHY combination having two
> > timestamping sources is growing all the time. So the stack needs to
> > change to support the selection of the timestamp source.
> 
> Fine, but How should the support look like?
> 
> - New/extended time stamping API that delivers multiple time stamps?
> 
> - sysctl to select MAC/PHY preference at run time globally?
> 
> - per-interface ethtool control?
> 
> - per-socket control?  (probably not feasible, but heh)
> 
> Back of the napkin design ideas appreciated!

Do you know of any realistic uses cases for using two time stampers
for the same netdev? If we can eliminate that, then it is down to
selecting which one to use. And i would say, the selection needs to be
per netdev.

I don't know the ptp subsystem very well, but it seems like
ptp_clock_register() does not know which netdev the device is being
registered against. Is it guaranteed that parent is actual a MAC?
Seems like adding a netdev member to that call could be good, so the
core knows what stampers are available per netdev. It then becomes
possible to enumerate the stampers associated to a netdev, and to
select one to be used.

get_ts_info() is a problem because the MAC directly implements it. It
seems like you need all kAPI calls to go into the ptp core. It can
then call into the selected driver. So ptp_clock_info might need
additional methods, get_ts_info() for example.

	   Andrew

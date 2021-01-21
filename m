Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A27D02FF85A
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 00:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725891AbhAUXBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 18:01:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbhAUXAx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 18:00:53 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F382AC06174A
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 14:59:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=9lNdq3L/KlQIMMSOnqmMVhmNVnF4a+Bs3m4aXauFB/k=; b=wQFQ3lupiBiwnZFEa50swZfrO
        NtBwmWyypb3enetTLYzG1zdcVoMHM0JsVP4+k107pN0fjuMcg5bnEKbxNYVRP2MYRvu8WFPOBsAFK
        nwfcHtMwo0GiNNNUotVKseG2eLzYBMyOS2iCbb8eWnZUdz9+4O2AnYiJxBVsBz3rdY3m55UqHrLVh
        z5R3mpPqBXFb+80CJYDXNl5D7R2c3BGJReCHn3X534nOtyBHcEpJurtx8r4ig5ji57AU7sLQyN8n+
        ksFkLEk2Ju4HDxceEkwXcWGLGNM23vTu36uip1Xfw4CGwMNeTRW8KHQdVNy6Xyzf4w4BHmNCzMFvV
        zwkq0L8qQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:51018)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1l2ivX-0000KX-4Z; Thu, 21 Jan 2021 22:59:43 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1l2ivU-0007S4-Fc; Thu, 21 Jan 2021 22:59:40 +0000
Date:   Thu, 21 Jan 2021 22:59:40 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: ethtool: allow MAC drivers to override
 ethtool get_ts_info
Message-ID: <20210121225940.GR1551@shell.armlinux.org.uk>
References: <20210114133235.GP1605@shell.armlinux.org.uk>
 <20210114172712.GA13644@hoboy.vegasvil.org>
 <20210114173111.GX1551@shell.armlinux.org.uk>
 <20210114223800.GR1605@shell.armlinux.org.uk>
 <20210121040451.GB14465@hoboy.vegasvil.org>
 <20210121102738.GN1551@shell.armlinux.org.uk>
 <20210121150611.GA20321@hoboy.vegasvil.org>
 <YAmqTUdMXOmd/rYI@lunn.ch>
 <20210121170347.GA22517@hoboy.vegasvil.org>
 <YAnOJhG1Eh4gjglr@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YAnOJhG1Eh4gjglr@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 21, 2021 at 07:55:34PM +0100, Andrew Lunn wrote:
> On Thu, Jan 21, 2021 at 09:03:47AM -0800, Richard Cochran wrote:
> > On Thu, Jan 21, 2021 at 05:22:37PM +0100, Andrew Lunn wrote:
> > 
> > > There is a growing interesting in PTP, the number of drivers keeps
> > > going up. The likelihood of MAC/PHY combination having two
> > > timestamping sources is growing all the time. So the stack needs to
> > > change to support the selection of the timestamp source.
> > 
> > Fine, but How should the support look like?
> > 
> > - New/extended time stamping API that delivers multiple time stamps?
> > 
> > - sysctl to select MAC/PHY preference at run time globally?
> > 
> > - per-interface ethtool control?
> > 
> > - per-socket control?  (probably not feasible, but heh)
> > 
> > Back of the napkin design ideas appreciated!
> 
> Do you know of any realistic uses cases for using two time stampers
> for the same netdev? If we can eliminate that, then it is down to
> selecting which one to use. And i would say, the selection needs to be
> per netdev.

Yes, I think it needs to be per-netdev.

As I've already demonstrated in previous emails last year on this
subject, we have the situation where, on the Macchiatobin board,
the ability to sync the PTP clock is quite different between the
PHY and the MAC:

- the PHY (slow to access, only event capture which may not be wired,
  doesn't seem to synchronise well - delay of 58000, frequency changes
  every second between +/-1500ppb.)

- the Ethernet MAC (fast to access, supports event capture and trigger
  generation which also may not be wired, synchronises well, delay of
  700, frequency changes every second +/- 40ppb.)

These are not theoretical numbers, they are observed measurements on
real hardware. The MAC is 37 times more stable than the PHY and 82
times faster to access, which makes the MAC a higher quality clock,
and more desirable to use.

Much of the instabillity comes from the need to access the PHY over
MDIO - which introduces unpredictable latency, such as due to the bus
access locking with other PHYLIB activities delaying PTP accesses.

While it is true that a PHY _may_ be closer to the wire in terms of its
ability to timestamp the packet, if the quality of its clock that it is
stamping with is significantly less than that which is achievable from
the MAC, then "always use a PHY if present because it's more accurate"
is a _very_ false assumption to make.

Things could well be different /if/ the PHY that was being used had
usable hardware synchronisation (including hardware event capture, and
hardware adjustment of the tick rate.) At that point, the PHY would be
the device to use.

So, if we have the case where we have timestamping available at both a
PHY and a MAC, the choice of which should be used, even for one SoC
containing a mvpp2 network device, is not clear-cut "always use mvpp2"
or "always use PHY".

Now, what I complain about is what I see as a messed up interface in
the PTP world:

- get_ts_info is an ethtool method, where _if_ the PHY supports
  timestamping, get_ts_info() will _always_ be directed to the PHY,
  and the MAC driver gets no choice in the matter.

- the IOCTLs to control timestamping go via the .ndo_ioctl interface,
  where, typically, the MAC driver intercepts the calls that it is
  interested in, deferring any calls it is not to phy_ioctl() or
  similar. It is inside phy_ioctl() that we find the rest of the PTP
  interface.

So, right now, if we end up where, say, we have the mvpp2 driver with
a PHY supporting timestamping, we get get_ts_info() reporting what the
PHY is capable of, but the IOCTLs that actually control PTP get
intercepted and acted upon by the mvpp2 driver.

The solution used by fec_main.c is to detect whether the PHY supports
timestamping using phy_has_hwtstamp(phydev), and defer the IOCTLs to
phy_ioctl(). That is fine if you want the PHY PTP implementation to
always override the MAC PTP implementation.

If you want the other way around, then currently it is impossible
because the MAC driver has no choice in whether it sees the
get_ts_info() ethtool call.

So, if I were to merge my Marvell PHY PTP code, let's say for argument
sake that NETWORK_PHY_TIMESTAMPING dependency was dropped from mvpp2,
and a distro comes along and provides its users with a single kernel
(as is the case today) which is built with NETWORK_PHY_TIMESTAMPING
turned on (because some of the platforms require it) then there is
_no_ choice to use the more stable MAC PTP implementation. People would
have to suffer an inferior PHY based implementation despite the
hardware being capable of better.

We should be giving people the choice of which they want to use.

So, can I suggest that we make a step to _first_ santise how PTP is
dealt with in the network layer. Can I suggest that we have a
struct net_ptp_ops (or whatever name you care) that is attached to a
a net_device structure that contains _all_ the operations to do with
a PTP implementation - get_ts_info() and the appropriate PTP ioctls.
At that point, we have a much saner definition of how the networking
layer talks to the PTP layer, and the decision about whether to use a
PHY or a MAC becomes one of which set of operations the pointer to
struct net_ptp_ops are pointing at - and we kill the struct ethtool_ops
get_ts_info member, and the parsing of the ioctl numbers in network
and PHY drivers.

At that point, we have some options. We can think about having a list
of PTP clocks attached to a network device, and an API to userspace to
select between them. Alternatively, we could do what is done with
clocksources, where we provide a rating that determines their "quality"
for use, so the "best" can be selected automatically by the kernel.
Or whatever other scheme takes our fancy.

The problem right now is we're tied in to the current approach that the
PHY always takes precedence, and we must have code in every network
driver that has PTP support to defer to the PHY implementation in its
ioctl handler.

Does this sound like a sane first step?

(Please note, I've spent since yesterday evening tracking down a horrid
KVM regression with 32-bit ARM kernels post 5.6, and we're not yet done
with it, so I may not have lots of time to work on this until that is
properly sorted - hence my short replies earlier today as I didn't have
time for anything else until now. Sorry about that.)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88C0A2F6210
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 14:34:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbhANNdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 08:33:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbhANNdc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 08:33:32 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6094C061574
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 05:32:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=VvZDifLw6wONV1U6ug+PYp0wIGGE1vP/ceO4NxFU4EQ=; b=0NrLnNq6PuYace4tZaiYFtl4P
        RFPMKkFoyaQwYEQGzgJyt13qp+TQT5/x2wdzpGQq3cJmbUATL2eLnE/Tp6Qa6ffIs1IsuCEgRtmR1
        bUuXfwXWzssAeTDfuipDLIYYap1gfklEXBmjWWNDBb1KtR0ZlQDCrKDtJyWfVfmyU9wqr6bqJK1jR
        jfk+pTaFUVvC+MGcGj9/rarJ77d7cuDlH4Qoe9sI92oOys4e7T920sm2VR+gICMCk9BoAjpuewe0o
        TpLX6RT4VK8N7Gjg7ovXUpEAdjVKo8InbHE3XDAk2Raps7+8m9HyAIFJWQFdSfBKWJS107u2TAnqL
        3pahODXMA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:47890)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1l02jr-0002XZ-Lv; Thu, 14 Jan 2021 13:32:35 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1l02jr-0008NP-7P; Thu, 14 Jan 2021 13:32:35 +0000
Date:   Thu, 14 Jan 2021 13:32:35 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: ethtool: allow MAC drivers to override
 ethtool get_ts_info
Message-ID: <20210114133235.GP1605@shell.armlinux.org.uk>
References: <E1kyYfI-0004wl-Tf@rmk-PC.armlinux.org.uk>
 <20210114125506.GC3154@hoboy.vegasvil.org>
 <20210114132217.GR1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210114132217.GR1551@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 01:22:17PM +0000, Russell King - ARM Linux admin wrote:
> On Thu, Jan 14, 2021 at 04:55:06AM -0800, Richard Cochran wrote:
> > On Sun, Jan 10, 2021 at 11:13:44AM +0000, Russell King wrote:
> > > This allows network drivers such as mvpp2 to use their more accurate
> > > timestamping implementation than using a less accurate implementation
> > > in the PHY. Network drivers can opt to defer to phylib by returning
> > > -EOPNOTSUPP.
> > 
> > My expectation is that PHY time stamping is more accurate than MAC
> > time stamping.
> 
> PHY time stamping may be a "more accurate" location to get timestamps,
> in terms of the hardware, but when you consider the entire setup, that
> is not necessarily the case.
> 
> > > This change will be needed if the Marvell PHY drivers add support for
> > > PTP.
> > 
> > Huh? The mvpp2 appears to be a MAC.  If this device has integrated
> > PHYs then I don't see the issue.  If your board has the nvpp2 device
> > with the dp83640 PHYTER, then don't you want to actually use the
> > PHYTER?
> 
> You seem to be adding more information way beyond what I'm saying.
> 
> No, there aren't integrated PHYs. There's an external PHY - a Marvell
> 88e151x which has what I would call rudimentary stamping abilities,
> whereas the mvpp2 has advanced stamping abilities.
> 
> You implemented the Marvell timestamping in DSA, so you know what the
> Marvell offering there looks like and what it is capable of. That same
> hardware appears in some Marvell PHYs.
> 
> The mvpp2 hardware (which has support already merged after you acked
> the TAI part, and failed to provide comments on the mvpp2 part - so
> davem gave up waiting) is capable of:
> - stamping every received packet irrespective of its type
> - stamping any transmitted packet or only those we wish to stamp
> - inserting a timestamp into the packet (aka one-step, although that
>   isn't implemented that yet)
> - correcting the hardware time counter tick rate
> 
> There is considerable noise in reading the hardware timestamp counter
> from the PHYs - caused by latency over the MDIO bus, which makes the
> achievable accuracy lower. That noise is very much reduced when reading
> the hardware timestamp counter from mvpp2 - where we can implement
> mvpp22_tai_gettimex64(). Therefore, the achieved accuracy from mvpp2 is
> higher than from a PHY.
> 
> We had already discussed this patch last year, and you agreed with it
> then. What has changed?

See the discussion in this sub-thread:

https://lore.kernel.org/netdev/20200729105807.GZ1551@shell.armlinux.org.uk/

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

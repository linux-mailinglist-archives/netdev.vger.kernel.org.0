Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3B718B86C
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 14:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727407AbgCSN6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 09:58:12 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:44936 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727180AbgCSN6L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 09:58:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=JbcPGnuINlXiKU7pzfjGVNxHgU8/NfDj/roK0Ui4qiU=; b=DPVBOy2zVfGVA8Cpqv7+H391u
        St7kcwC+IcZ+vYgDu8D3FaYNqbsUD8XJFP8wjhoU2Pit1qI8hVuEXSpUofUXT4dIAfZdV9kHpaQmY
        431WkSrxlxo5iw0i5SmB7h/ITiWatGlkPD6Tckxkr9zJCfZqLW099IPR525SmFwP9bqRlUtvaEVCK
        P4r7C39YccyofAsAynL3n8cb8yozNs2Rj+ZslbZLhalVYY3rrQs9NoAb8swiMRuPhVv9JP+oLqRiI
        JSVVf+3VT8CK2RaRno7jiGQBOmVuLASirvix/a7fuFQjZwZZeMgX2+7eZ97LQBm1doG+BJ1YJLlfY
        CojyAPiag==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:55152)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jEvgR-0002WF-Ak; Thu, 19 Mar 2020 13:58:03 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jEvgO-0004pZ-NJ; Thu, 19 Mar 2020 13:58:00 +0000
Date:   Thu, 19 Mar 2020 13:58:00 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 1/3] net: phy: add and use phy_check_downshift
Message-ID: <20200319135800.GE25745@shell.armlinux.org.uk>
References: <6e4ea372-3d05-3446-2928-2c1e76a66faf@gmail.com>
 <d2822357-4c1e-a072-632e-a902b04eba7c@gmail.com>
 <20200318232159.GA25745@shell.armlinux.org.uk>
 <b0bc3ca0-0c1b-045e-cd00-37fc85c4eebf@gmail.com>
 <20200319112535.GD25745@shell.armlinux.org.uk>
 <20200319130429.GC24972@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200319130429.GC24972@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 19, 2020 at 02:04:29PM +0100, Andrew Lunn wrote:
> > The only time that this helps is if PHY drivers implement reading a
> > vendor register to report the actual link speed, and the PHY specific
> > driver is used.
> 
> So maybe we either need to implement this reading of the vendor
> register as a driver op, or we have a flag indicating the driver is
> returning the real speed, not the negotiated speed?

I'm not sure it's necessary to have another driver op.  How about
this for an idea:

- add a flag to struct phy_device which indicates the status of
  downshift.
- on link-up, check the flag and report whether a downshift occurred,
  printing whether a downshift occurred in phy_print_status() and
  similar places.  (Yes, I know that there are some network drivers
  that don't use phy_print_status().)

The downshift flag could be made tristate - "unknown", "not downshifted"
and "downshifted" - which would enable phy_print_status() to indicate
whether there is downshift supported (and hence whether we need to pay
more attention to what is going on when there is a slow-link report.)

Something like:

For no downshift:
	Link is Up - 1Gbps/Full - flow control off
For downshift:
	Link is Up - 100Mbps/Full (downshifted) - flow control off
For unknown:
	Link is Up - 1Gbps/Full (unknown downshift) - flow control off

which has the effect of being immediately obvious if the driver lacks
support.

We may wish to consider PHYs which support no downshift ability as
well, which should probably set the status to "not downshifted" or
maybe an "unsupported" state.

This way, if we fall back to the generic PHY driver, we'd get the
"unknown" state.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1895231D0C
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 12:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbgG2K6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 06:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbgG2K6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 06:58:10 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D37EAC061794
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 03:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=YwHcAo8JtZ8pPTU5tNcYUhAKmdKCD95vxiiMjQq4OJs=; b=NWWsEXP7dYzMqa7tTgE70CU26
        3aAjrSgaFYKfgpk5wHMWI1DF54sEtQvd3z6AfQS9H7qup1WyPcHAdjFdOgcokY0v0LXKjvYNMd9/P
        9i5GLPNiW2LEMV/p75vhyWxXEl7XAbL1QWCQXPx3Cw7gsaQbM1gfIxH/k+qN278mORypQNYuMu1ip
        +x15iHQVxnZQ4oxC+r31SLrLRNNZqa+Gw46iJw8UP2Hq8NYKkWBHPKZQg1HkeUZa7EjK4ZN3lzOsN
        j6qLwHWjf/7EkWai/iiPtXcupMiDhcySwHexOJXXfWG/MHU1heVT1OTvR8TNhVm/xhJxCBdqUCaeM
        Pmtc88sFg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45644)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1k0jmh-0005J6-SS; Wed, 29 Jul 2020 11:58:07 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1k0jmh-0005cX-9w; Wed, 29 Jul 2020 11:58:07 +0100
Date:   Wed, 29 Jul 2020 11:58:07 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
Message-ID: <20200729105807.GZ1551@shell.armlinux.org.uk>
References: <E1jvNlE-0001Y0-47@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1jvNlE-0001Y0-47@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 14, 2020 at 05:26:28PM +0100, Russell King wrote:
> Add PTP basic support for Marvell 88E151x PHYs.  These PHYs support
> timestamping the egress and ingress of packets, but does not support
> any packet modification, nor do we support any filtering beyond
> selecting packets that the hardware recognises as PTP/802.1AS.

A question has come up concerning the selection of PTP timestamping
sources within a network device.

I have the situation on a couple of devices where there are multiple
places that can do PTP timestamping:

- the PHY (slow to access, only event capture which may not be wired,
   doesn't seem to synchronise well - delay of 58000, frequency changes
   every second between +/-1500ppb.)
- the Ethernet MAC (fast to access, supports event capture and trigger
   generation which also may not be wired, synchronises well, delay of
   700, frequency changes every second +/- 40ppb.)

How do we deal with this situation - from what I can see from the
ethtool API, we have to make a choice about which to use.  How do we
make that choice?

It's not a case of "just implement one" since hardware may have both
available on a particular ethernet interface or just one available.

Do we need a property to indicate whether we wish to use the PHY
or MAC PTP stamping, or something more elaborate?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3319B203F8C
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 20:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730252AbgFVS6k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 14:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730238AbgFVS6j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 14:58:39 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66AB9C061573
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 11:58:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Jq76W+meRDwul/zgymfw+qgUDZB5HTfj+8HChO8cnuA=; b=sJga6tDUqK5+e3tDRQp3tAOQ1
        rW6V+IjV5ZvmFWP6dElKlfW/wN7cgkwdl3OTNYKPb+RpyFCOfxDrQuUcoGykgwra8hvXsLBglOeTn
        vcS8Rme7JY5arpoPnT/vhglhsupr8353HBkoOBoiHqDJ0Z1WftXqYCEg65Yj/FUNOZnNkmSYD6ZEV
        mTgbH/ugp4SNJt7ZuBkf9mxB/6/sMXjF5wfEe4jYKSl24AxohrnMEW6jqg+HDxsLGtE8Dh9uRQG1d
        HTP9X0cO53WfhUQsXWh+Wk8FveVoJrKjFrJe2MGGO1546rU9+ExwMeJfCPIDHziKneihYnZe7xo9T
        5/VgBd4yw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58980)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jnReQ-0000je-0Q; Mon, 22 Jun 2020 19:58:38 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jnReP-0000HY-Ki; Mon, 22 Jun 2020 19:58:37 +0100
Date:   Mon, 22 Jun 2020 19:58:37 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Daniel Mack <daniel@zonque.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com
Subject: Re: [PATCH] net: dsa: mv88e6xxx: Allow MAC configuration for ports
 with internal PHY
Message-ID: <20200622185837.GN1551@shell.armlinux.org.uk>
References: <20200622183443.3355240-1-daniel@zonque.org>
 <20200622184115.GE405672@lunn.ch>
 <b8a67f7d-9854-9854-3f53-983dd4eb8fda@zonque.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b8a67f7d-9854-9854-3f53-983dd4eb8fda@zonque.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 22, 2020 at 08:44:51PM +0200, Daniel Mack wrote:
> On 6/22/20 8:41 PM, Andrew Lunn wrote:
> > On Mon, Jun 22, 2020 at 08:34:43PM +0200, Daniel Mack wrote:
> >> Ports with internal PHYs that are not in 'fixed-link' mode are currently
> >> only set up once at startup with a static config. Attempts to change the
> >> link speed or duplex settings are currently prevented by an early bail
> >> in mv88e6xxx_mac_config(). As the default config forces the speed to
> >> 1000M, setups with reduced link speed on such ports are unsupported.
> > 
> > Hi Daniel
> > 
> > How are you trying to change the speed?
> 
> With ethtool for instance. But all userspace tools are bailing out early
> on this port for the reason I described.

A simple "return" to ignore a call in a void function won't have that
effect.

I don't see an issue here:

# ethtool -s lan1 autoneg off speed 10 duplex half
# ethtool lan1
Settings for lan1:
        Supported ports: [ TP MII ]
        Supported link modes:   10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Full
        Supported pause frame use: Symmetric
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  10baseT/Half
        Advertised pause frame use: Symmetric
        Advertised auto-negotiation: No
        Advertised FEC modes: Not reported
        Speed: 10Mb/s
        Duplex: Half
        Port: MII
        PHYAD: 4
        Transceiver: internal
        Auto-negotiation: off
        Supports Wake-on: d
        Wake-on: d
        Link detected: yes

libmii.c:v2.11 2/28/2005  Donald Becker (becker@scyld.com)
 http://www.scyld.com/diag/index.html
 MII PHY #4 transceiver registers:
   0000 794d 0141 0eb1 05e1 0000 0004 2001
   0000 0e00 0000 0000 0000 0003 0000 3000
   3360 0c48 6400 0000 0020 0000 0000 0000
   0000 0000 8040 0000 0000 0000 0000 0000.
 Basic mode control register 0x0000: Auto-negotiation disabled!
   Speed fixed at 10 mbps, half-duplex.
 Basic mode status register 0x794d ... 794d.
   Link status: established.
   Capable of  100baseTx-FD 100baseTx 10baseT-FD 10baseT.
   Able to perform Auto-negotiation, negotiation not complete.
 Vendor ID is 00:50:43:--:--:--, model 43 rev. 1.
   No specific information is known about this transceiver type.
 I'm advertising 05e1: Flow-control 100baseTx-FD 100baseTx 10baseT-FD 10baseT
   Advertising no additional info pages.
   IEEE 802.3 CSMA/CD protocol.
 Link partner capability is 0000:.
   Negotiation did not complete.

and traffic passes.

I've also been able to change what is advertised just fine, and the
link comes up as expected - in fact, I was running one of the switch
ports at 10Mbps to one of my machines and using the 'scope on the
ethernet signals over the weekend to debug a problem, which turned
out to be broken RGMII clock delay timings.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

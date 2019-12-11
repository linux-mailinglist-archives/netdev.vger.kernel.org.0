Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B490511ABB9
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 14:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729444AbfLKNLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 08:11:18 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47326 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729225AbfLKNLR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 08:11:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=U/p6mLNTZXGpeBKmRpeaGSMXL6/A79Y0wl3UTyUTLX4=; b=zsnIen1aen8bSvoz1K3HoofLvo
        NYRLEJXlYxyKT6EheATXnxx4+YWgqelagUBLf8HVKxIyFs9ioHPfc5sL1YMkwuhkpc1wBZu0j4Yc6
        TB4LYSiwDInqBENfr6MnhkMaCGXXLVNDLiGReHebWDDH4CZxkVd5HxSenZRZfMHJqFes=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1if1ln-0004Fg-Cb; Wed, 11 Dec 2019 14:11:11 +0100
Date:   Wed, 11 Dec 2019 14:11:11 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>, netdev@vger.kernel.org,
        Denis Odintsov <d.odintsov@traviangames.com>
Subject: Re: [BUG] mv88e6xxx: tx regression in v5.3
Message-ID: <20191211131111.GK16369@lunn.ch>
References: <87tv67tcom.fsf@tarshish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tv67tcom.fsf@tarshish>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 11, 2019 at 11:48:57AM +0200, Baruch Siach wrote:
> Hi Andrew, Vivien,
> 
> Since kernel v5.3 (tested v5.3.15), the 88E6141 switch on SolidRun
> Clearfog GT-8K stopped transmitting packets on switch connected
> ports. Kernel v5.2 works fine (tested v5.2.21).
> 
> Here are the relevant kernel v5.3 log lines:
> 
> [    2.867424] mv88e6085 f412a200.mdio-mii:04: switch 0x3400 detected: Marvell 88E6141, revision 0
> [    2.927445] libphy: mdio: probed
> [    3.578496] mv88e6085 f412a200.mdio-mii:04 lan2 (uninitialized): PHY [!cp1!config-space@f4000000!mdio@12a200!switch0@4!mdio:11] driver [Marvell 88E6390]
> [    3.595674] mv88e6085 f412a200.mdio-mii:04 lan1 (uninitialized): PHY [!cp1!config-space@f4000000!mdio@12a200!switch0@4!mdio:12] driver [Marvell 88E6390]
> [    3.612797] mv88e6085 f412a200.mdio-mii:04 lan4 (uninitialized): PHY [!cp1!config-space@f4000000!mdio@12a200!switch0@4!mdio:13] driver [Marvell 88E6390]
> [    3.629910] mv88e6085 f412a200.mdio-mii:04 lan3 (uninitialized): PHY [!cp1!config-space@f4000000!mdio@12a200!switch0@4!mdio:14] driver [Marvell 88E6390]
> [    3.646049] mv88e6085 f412a200.mdio-mii:04: configuring for phy/ link mode
> [    3.654451] DSA: tree 0 setup
> ...
> [   10.784521] mvpp2 f4000000.ethernet eth2: configuring for fixed/2500base-x link mode
> [   10.792401] mvpp2 f4000000.ethernet eth2: Link is Up - 2.5Gbps/Full - flow control off
> [   19.817981] mv88e6085 f412a200.mdio-mii:04 lan1: configuring for phy/ link mode
> [   19.827083] 8021q: adding VLAN 0 to HW filter on device lan1
> [   21.577276] mv88e6085 f412a200.mdio-mii:04 lan1: Link is Up - 100Mbps/Full - flow control rx/tx
> [   21.586030] IPv6: ADDRCONF(NETDEV_CHANGE): lan1: link becomes ready
> 
> The Tx count on the lan1 interface increments, but the ARP packets don't 
> show on the network.

Hi Baruch

I don't know of an issues.

If the MAC TX counter increases, it sounds like it is a PHY issue?
Does 100Mbps/Full make sense for this link?

Probably your best bet is to do a git bisect to find which commit
broke it.

      Andrew

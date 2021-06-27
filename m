Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 214E33B5471
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 19:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231239AbhF0RJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Jun 2021 13:09:12 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58914 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230315AbhF0RJL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Jun 2021 13:09:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=squZzVQuAS6w4p8lHsj9WH9NCMWNN/Dm7UH7WaRHEhU=; b=kgE7uJxiGxds36MeiM3kzPULP8
        0funsJdeh24BQfSLD6CRtKbl7NhK1kVBd8M97Or0dG7U8POg6E2Av3H4pkMK9RFBmCqwRuihJvvGs
        +Uqm4yqTX/ldN/iVWjgH2dpBhSj0vQedp/r1xsSfNMx1pUCcEXCoKVERdcoiljMSSp2M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lxYF3-00BKzJ-NY; Sun, 27 Jun 2021 19:06:45 +0200
Date:   Sun, 27 Jun 2021 19:06:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Michal Kubecek <mkubecek@suse.cz>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: PHY vs. MAC ethtool Wake-on-LAN selection
Message-ID: <YNiwJTgEZjRG7bha@lunn.ch>
References: <554fea3f-ba7c-b2fc-5ee6-755015f6dfba@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <554fea3f-ba7c-b2fc-5ee6-755015f6dfba@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> - Ethernet MAC (bcmgenet) is capable of doing Wake-on-LAN using Magic
> Packets (g) with password (s) or network filters (f) and is powered on in
> the "standby" (as written in /sys/power/state) suspend state, and completely
> powered off (by hardware) in the "mem" state
> 
> - Ethernet PHY (broadcom.c, no code there to support WoL yet) is capable of
> doing Wake-on-LAN using Magic Packets (g) with password (s) or a 48-bit MAC
> destination address (f) match allowing us to match on say, Broadcom and
> Multicast. That PHY is on during both the "standby" and "mem" suspend states

Marvell systems are similar. The mvneta hardware has support for WOL,
and has quite a capable filter. But there is no driver support. WOL is
simply forwarded to the PHY.

> What I envision we could do is add a ETHTOOL_A_WOL_DEVICE u8 field and have
> it take the values: 0 (default), 1 (MAC), 2 (PHY), 3 (both) and you would do
> the following on the command line:
> 
> ethtool -s eth0 wol g # default/existing mode, leave it to the driver
> ethtool -s eth0 wol g target mac # target the MAC only
> ethtool -s eth0 wol g target phy # target the PHY only
> ethtool -s eth0 wol g target mac+phy # target both MAC and PHY

This API seems like a start, but is it going to be limiting? It does
not appear you can say:

ethtool -s eth0 wol g target phy wol f target mac

So make use of magic packet in the PHY and filtering in the MAC.
ETHTOOL_A_WOL_DEVICE u8 appears to apply to all WoL options, not one
u8 per option.

And does mac+phy mean both will generate an interrupt? I'm assuming
the default of 0 means do whatever undefined behaviour we have now. Do
we need another value, 4 (auto) and the MAC driver will first try to
offload to the PHY, and if that fails, it does it at the MAC, with the
potential for some options to be in the MAC and some in the PHY?

> Is that over engineering or do you see other platforms possibly needing that
> distinction?

The over engineering question is clearly valid. Do we actually need to
support all possible options? I've made little use of WoL, so i don't
think i can answer that question.

Also, when it comes to implementation, i would suggest trying to pull
the interpretation of target and decision for MAC or PHY out into
helpers. The complexity is quite high, and if we want uniform
implementation, we want one implementation of it.

	Andrew

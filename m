Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9382A4509EB
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 17:45:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbhKOQsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 11:48:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231625AbhKOQsB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 11:48:01 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 605F4C061202
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 08:44:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=zEPv8zFwBPXGq1CjoH+woQfGWd6jiYMNCN/3K3NkBG8=; b=seiNnOIdTuHjvd1vOdgy+lsKHz
        UYzIa7OqVgrjCO7krk+DHdUmQ1ABR6PzNyTdxtZAa/OalPDuXwWIYQG+vGN3u/ArlBDg/eS4Vt/xX
        7rNJBNrXerktZqYXojJLxZGYVg1Hh/iv5bj45g7KLJ/Hv2FDyC1Q8VxbYv2hZkYEsm1Yws9e3/Y5P
        r9nSyRF9/7J4FDMuxuTv5Sst0bmychsGNqHmPTGZj4t9IiT1hVoTLWVGUOn38QzKAc2dzs0SiPYpw
        c3ZneWPYJv3ucdSco/gzKFMgzrjygDuSUQqCpmIJbSbaebH3Y9jkTo0OjVyHvxekw0aKpNBaJRu/T
        NHMZDulA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55636)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mmf63-0007qd-Ig; Mon, 15 Nov 2021 16:44:43 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mmf5y-0001Bd-9Y; Mon, 15 Nov 2021 16:44:38 +0000
Date:   Mon, 15 Nov 2021 16:44:38 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Parshuram Thombare <pthombar@cadence.com>,
        Antoine Tenart <atenart@kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Milind Parab <mparab@cadence.com>
Subject: Re: [net-next PATCH v6] net: macb: Fix several edge cases in validate
Message-ID: <YZKOdibmws3vlMUh@shell.armlinux.org.uk>
References: <20211112190400.1937855-1-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211112190400.1937855-1-sean.anderson@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 12, 2021 at 02:04:00PM -0500, Sean Anderson wrote:
> There were several cases where validate() would return bogus supported
> modes with unusual combinations of interfaces and capabilities. For
> example, if state->interface was 10GBASER and the macb had HIGH_SPEED
> and PCS but not GIGABIT MODE, then 10/100 modes would be set anyway. In
> another case, SGMII could be enabled even if the mac was not a GEM
> (despite this being checked for later on in mac_config()). These
> inconsistencies make it difficult to refactor this function cleanly.
> 
> There is still the open question of what exactly the requirements for
> SGMII and 10GBASER are, and what SGMII actually supports. If someone
> from Cadence (or anyone else with access to the GEM/MACB datasheet)
> could comment on this, it would be greatly appreciated. In particular,
> what is supported by Cadence vs. vendor extension/limitation?
> 
> To address this, the current logic is split into three parts. First, we
> determine what we support, then we eliminate unsupported interfaces, and
> finally we set the appropriate link modes. There is still some cruft
> related to NA, but this can be removed in a future patch.
> 
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>

Thanks - this looks good to me.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

I've added it to my tree as I have patches that follow on which
entirely eliminate macb_validate(), replacing it with the generic
implementation that was merged into net-next today.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

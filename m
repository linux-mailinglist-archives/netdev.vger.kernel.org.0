Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E393425125
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 12:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240947AbhJGKgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 06:36:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240923AbhJGKgC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 06:36:02 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7139C061755;
        Thu,  7 Oct 2021 03:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ovm8uBPvpGB+KgDK6CrWGI+MhaFX7YlkEV+ZsLLZNKk=; b=i3yxWEhNJhTuwj5y5q6seSKdKc
        bJHGzY5cOrfjD+wwo9Fu2myPpjJs7D+tPzHdubyGba3JUF4HTwy71YjpQjw6CToRo+1hTlSJrbsfR
        CsNOtNEj6tAh2eSoInlJFr0/6rjIg4O/BYBDRU0xPw3q9EVDjIDDcRl7hGjvIAj462I/5Z2UL8Wyx
        /u6y3CPGvE9VdIy5Rl1c5KGyjrDSTXzaPetYsDdIwQI+p16bmdk6XepPScj4KsVllAif1fOIYdTw8
        vIpws/eUMSNoV/qGWao8gBtKRpVraaJ16Z7UPEjJ4FExJT/1v8HEb4iUykKTA3mrqlmbYkkoLkQCC
        YqUpIPzw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54994)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mYQj0-0002L5-PN; Thu, 07 Oct 2021 11:34:06 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mYQiz-0001ov-Vv; Thu, 07 Oct 2021 11:34:05 +0100
Date:   Thu, 7 Oct 2021 11:34:05 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: Re: [RFC net-next PATCH 10/16] net: macb: Move PCS settings to PCS
 callbacks
Message-ID: <YV7NHZRFZ9U3Xj8v@shell.armlinux.org.uk>
References: <20211004191527.1610759-1-sean.anderson@seco.com>
 <20211004191527.1610759-11-sean.anderson@seco.com>
 <YVwjjghGcXaEYgY+@shell.armlinux.org.uk>
 <7c92218c-baec-a991-9d6b-af42dfabbad3@seco.com>
 <YVyfEOu+emsX/ERr@shell.armlinux.org.uk>
 <ddb81bf5-af74-1619-b083-0dba189a5061@seco.com>
 <YVzPgTAS0grKl6CN@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVzPgTAS0grKl6CN@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 05, 2021 at 11:19:45PM +0100, Russell King (Oracle) wrote:
> On Tue, Oct 05, 2021 at 05:44:11PM -0400, Sean Anderson wrote:
> > At the very least, it should be clearer what things are allowed to fail
> > for what reasons. Several callbacks are void when things can fail under
> > the hood (e.g. link_up or an_restart). And the API seems to have been
> > primarily designed around PCSs which are tightly-coupled to their MACs.

I think what I'd like to see is rather than a validate() callback for
the PCS, a bitmap of phy_interface_t modes that the PCS supports,
which is the direction I was wanting to take phylink and SFP support.

We can then use that information to inform the interface selection in
phylink and avoid interface modes that the PCS doesn't support.

However, things get tricky when we have several PCS that we can switch
between, and the switching is done in mac_prepare(). The current PCS
(if there is even a PCS attached) may not represent the abilities
that are actually available.

It sounds easy - just throw in an extra validation step when calling
phylink_validate(), but it isn't that simple. To avoid breaking
existing setups, phylink would need to know of every PCS that _could_
be attached, and the decisions that the MAC makes to select which PCS
is going to be used for any configuration.

We could possibly introduce a .mac_select_pcs(interface) method
which the MAC could return the PCS it wishes to use for the interface
mode with the guarantee that the PCS it returns is suitable - and if
it returns NULL that means the interface mode is unsupported. That,
along with the bitmask would probably work.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

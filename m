Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAEE93FEDAA
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 14:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344333AbhIBMUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 08:20:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234098AbhIBMUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 08:20:33 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A3FBC061575;
        Thu,  2 Sep 2021 05:19:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=DVgR33IVft+dCywULf17gDtnqaFtr2ZhHdeB92X8pQg=; b=SQ/AlGBVe6zLycRds30ClI57P
        18udRYN4eNprD0WBz8wysz1D7bKNOWkoB993pDaTUomTUpCYnt8IVw1zKZ1F1FXNgl9YZSLOkkkYF
        LpP9IzogxTczsN+01EOkivwMYxZoAMmnwO39qeUxDYVZ2MYBTHPdqQrn58viE+84faBPsOnTk3OW8
        /Bb+c6PDGtIwPglY+V9dOpNaEKXZBOU2RezAU/ypjFwKdqv8N6VFcZxqbAm6uSvMyx9q26Z9++qov
        HK4KO71rXWHE+gWOrtanzWbBTWRhcQ7PDN3rQWtdWKK2vSJnvNly3hl+U2A/dkmvQytwpIOiXtSVT
        CeOWsLDrw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48086)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mLlgo-0001OF-GP; Thu, 02 Sep 2021 13:19:30 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mLlgl-0007oS-Ul; Thu, 02 Sep 2021 13:19:27 +0100
Date:   Thu, 2 Sep 2021 13:19:27 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        kernel-team <kernel-team@android.com>,
        Len Brown <lenb@kernel.org>
Subject: Re: [RFC PATCH net-next 0/3] Make the PHY library stop being so
 greedy when binding the generic PHY driver
Message-ID: <20210902121927.GE22278@shell.armlinux.org.uk>
References: <20210901225053.1205571-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210901225053.1205571-1-vladimir.oltean@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 02, 2021 at 01:50:50AM +0300, Vladimir Oltean wrote:
> The central point of that discussion is that DSA seems "broken" for
> expecting the PHY driver to probe immediately on PHYs belonging to the
> internal MDIO buses of switches. A few suggestions were made about what
> to do, but some were not satisfactory and some did not solve the problem.

I think you need to describe the mechanism here. Why wouldn't a PHY
belonging to an internal MDIO bus of a switch not probe immediately?
What resources may not be available?

If we have a DSA driver that tries to probe the PHYs before e.g. the
interrupt controller inside the DSA switch has been configured, aren't
we just making completely unnecessary problems for ourselves? Wouldn't
it be saner to ensure that the interrupt controller has been setup
and become available prior to attempting to setup anything that
relies upon that interrupt controller?

From what I see of Marvell switches, the internal PHYs only ever rely
on internal resources of the switch they are embedded in.

External PHYs to the switch are a different matter - these can rely on
external clocks, and in that scenario, it would make sense for a
deferred probe to cause the entire switch to defer, since we don't
have all the resources for the switch to be functional (and, because we
want the PHYs to be present at switch probe time, not when we try to
bring up the interface, I don't see there's much other choice.)

Trying to move that to interface-up time /will/ break userspace - for
example, Debian's interfaces(8) bridge support will become unreliable,
and probably a whole host of other userspace. It will cause regressions
and instability to userspace. So that's a big no.

Maybe I'm missing exactly what the problem is...

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

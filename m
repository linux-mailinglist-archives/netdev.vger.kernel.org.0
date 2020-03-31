Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2841996E0
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 14:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730680AbgCaM53 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 08:57:29 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:40888 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730436AbgCaM53 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 08:57:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ce4BTpmyj7K9l9JDQD8ne61+/V42/n82/UFa1Yzdx8k=; b=pTGO0qTxzle+TuXbcEo+TE9O2
        zSAu0Q6texuUlAv0sT/c/eiiV0/WASk3gPPbVgXZilxR4zR+f+J8uy5s2BiwnnWeh1E0lctpdnlds
        7nO861N38KX8rOlFBu6V7yzTGxbYq9yAHnw/Z/99NN+eWTqG9LVnJDTuz3FCtGrezy8EqEG/KPVII
        i6OEgqtITBrw+4u+Q8dv4VyD2HorlQcPgu+G9rb5Mb/XsgMrvBa2uc5N6FMrP54ZNWX0BPxXAqaYM
        zduw3zjY0XrjnecLtlaIaYk6MEpGOtNlJyBF8MO8NCw0G7VvzG2zAtMRjooicR8EjuvZNnEZXH9WV
        F8ouwvrpA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:43792)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jJGSI-0008L1-U4; Tue, 31 Mar 2020 13:57:23 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jJGSE-00088K-Fq; Tue, 31 Mar 2020 13:57:18 +0100
Date:   Tue, 31 Mar 2020 13:57:18 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, ioana.ciornei@nxp.com,
        olteanv@gmail.com
Subject: Re: [PATCH net] net: dsa: Don't instantiate phylink for CPU/DSA
 ports unless needed
Message-ID: <20200331125718.GM25745@shell.armlinux.org.uk>
References: <20200311152424.18067-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200311152424.18067-1-andrew@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 11, 2020 at 04:24:24PM +0100, Andrew Lunn wrote:
> By default, DSA drivers should configure CPU and DSA ports to their
> maximum speed. In many configurations this is sufficient to make the
> link work.
> 
> In some cases it is necessary to configure the link to run slower,
> e.g. because of limitations of the SoC it is connected to. Or back to
> back PHYs are used and the PHY needs to be driven in order to
> establish link. In this case, phylink is used.
> 
> Only instantiate phylink if it is required. If there is no PHY, or no
> fixed link properties, phylink can upset a link which works in the
> default configuration.
> 
> Fixes: 0e27921816ad ("net: dsa: Use PHYLINK for the CPU/DSA ports")
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Hi Andrew,

This seems to conflict with the serdes changes.  For a CPU port using
a serdes connection, we claim the serdes interrupt, which then triggers
this:

[    9.069631] Unable to handle kernel NULL pointer dereference at virtual address 00000124
[    9.077785] pgd = c0004000
[    9.080528] [00000124] *pgd=00000000
[    9.084157] Internal error: Oops: 805 [#1] SMP ARM
[    9.088961] Modules linked in: tag_edsa spi_nor mtd xhci_plat_hcd mv88e6xxx(+) xhci_hcd armada_thermal marvell_cesa dsa_core ehci_orion libdes phy_armada38x_comphy at24 mcp3021 sfp evbug spi_orion sff mdio_i2c
[    9.107625] CPU: 1 PID: 214 Comm: irq/55-mv88e6xx Not tainted 5.6.0+ #470
[    9.114429] Hardware name: Marvell Armada 380/385 (Device Tree)
[    9.120371] PC is at phylink_mac_change+0x10/0x88
[    9.125129] LR is at mv88e6352_serdes_irq_status+0x74/0x94 [mv88e6xxx]

which is because dp->pl is NULL in dsa_port_phylink_mac_change() as a
result of this commit for links operating at max speed without a
fixed-link property.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A36001FD4FB
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 20:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbgFQS5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 14:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727894AbgFQS5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 14:57:09 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1AAEC06174E
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 11:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=9c/5XO2ZSjpjTcoNNpDqagMS/8PcdrjvAPEHJItnGRk=; b=Yrm1nGR5xKE/tYzc3aP2CplHN
        X0HuV1xPWIjpMeF+LHwvLmii8kqsmMBbwrjMy0xLRnLEJP1XwQwc0An09T2hTCr6RhE9e+9fDhG7x
        ErXDQ5GOEAzHbADXoZICn/9OQjZxQJGPn/pmyq2QkVBz2P1I+Bko+flxoGQ4fW9vM0BfVYVVnfEs7
        uKt98QTYbBlT1O4Jzri8fgmmSpLlH/ZrfSWVwJbsFKWuhIYvPTsMIUWTITVua9Hthl6MbE3MV261k
        SDWDaOD3fbJjVUFASL9pi/yQZw/qTp/7e9egOG28YVStWCezxyEdXK4pfeNlLlvZ/z9MZ77CvzAiz
        IICTd63+A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58596)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jldFA-00040N-MO; Wed, 17 Jun 2020 19:57:04 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jldF9-0003xv-Ng; Wed, 17 Jun 2020 19:57:03 +0100
Date:   Wed, 17 Jun 2020 19:57:03 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Jeremy Linton <jeremy.linton@arm.com>, Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev@vger.kernel.org, linux.cj@gmail.com
Subject: Re: [PATCH v1 1/3] net: phy: Allow mdio buses to auto-probe c45
 devices
Message-ID: <20200617185703.GW1551@shell.armlinux.org.uk>
References: <20200617171536.12014-1-calvin.johnson@oss.nxp.com>
 <20200617171536.12014-2-calvin.johnson@oss.nxp.com>
 <20200617174451.GT1551@shell.armlinux.org.uk>
 <20200617185120.GB240559@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200617185120.GB240559@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 17, 2020 at 08:51:20PM +0200, Andrew Lunn wrote:
> > > +	/* bus capabilities, used for probing */
> > > +	enum {
> > > +		MDIOBUS_C22 = 0,
> > > +		MDIOBUS_C45,
> > > +		MDIOBUS_C22_C45,
> > > +	} probe_capabilities;
> > 
> > I think it would be better to reserve "0" to mean that no capabilities
> > have been declared.  We hae the situation where we have mii_bus that
> > exist which do support C45, but as they stand, probe_capabilities will
> > be zero, and with your definitions above, that means MDIOBUS_C22.
> > 
> > It seems this could lock in some potential issues later down the line
> > if we want to use this elsewhere.
> 
> Hi Russell
> 
> Actually, this patch already causes issues, i think.
> 
> drivers/net/ethernet/marvell/mvmdio.c contains two MDIO bus master
> drivers. "marvell,orion-mdio" is C22 only. "marvell,xmdio" is C45
> only. Because the capabilites is not initialized, it will default to
> 0, aka MDIOBUS_C22, for the C45 only bus master, and i expect bad
> things will happen.
> 
> We need the value of 0 to cause existing behaviour. Or all MDIO bus
> drivers need reviewing, and the correct capabilities set.

Yes, that's basically what I was trying to say, thanks for putting it
more clearly.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

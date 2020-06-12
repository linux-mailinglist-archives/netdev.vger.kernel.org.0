Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8E3E1F756E
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 10:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbgFLIrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 04:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726292AbgFLIrT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 04:47:19 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AF13C03E96F;
        Fri, 12 Jun 2020 01:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ppaRPVGqkWM/OTbuguh/PjazU7yUJs4On6rOzMLESpI=; b=ztKNvNvAzydCyExul5EoZgwkb
        C4KGYLiTsxS4f8AZ6muEDgVmGHxD3VdtY/CxbTX2ds/PNXB82y5ZyE+XpElwI9ZiwapI6/XQJC/N+
        LB5PMOw2Z9fcG0fnSgHR9qUcTcuwkVwDDVIiyaASnT17SN0o2rHAhYv6hiCvoYBXr8Q7J7wnTKPyb
        UL7cMwhM6JMj0HK8irvtWveTqtk7hxVrQU8WqmsgQj6QJ6PAO7UITGP3qkFAxvIUfwB0Ky0ZW0gDh
        Rm4Kb6AlGflUyfLxlTS00wuJ9psA+jgjlHR8jtoUdLkex7EQ9Ewk/YgNeVm5ZalpVrs5MRNxygzna
        6XJvOxulQ==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:52602)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jjfLG-0002Pe-EG; Fri, 12 Jun 2020 09:47:14 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jjfLC-00067G-Fq; Fri, 12 Jun 2020 09:47:11 +0100
Date:   Fri, 12 Jun 2020 09:47:10 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Sascha Hauer <s.hauer@pengutronix.de>
Cc:     netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@pengutronix.de
Subject: Re: [PATCH v2] net: mvneta: Fix Serdes configuration for 2.5Gbps
 modes
Message-ID: <20200612084710.GC1551@shell.armlinux.org.uk>
References: <20200612083847.29942-1-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200612083847.29942-1-s.hauer@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 12, 2020 at 10:38:47AM +0200, Sascha Hauer wrote:
> The Marvell MVNETA Ethernet controller supports a 2.5Gbps SGMII mode
> called DRSGMII. Depending on the Port MAC Control Register0 PortType
> setting this seems to be either an overclocked SGMII mode or 2500BaseX.
> 
> This patch adds the necessary Serdes Configuration setting for the
> 2.5Gbps modes. There is no phy interface mode define for overclocked
> SGMII, so only 2500BaseX is handled for now.
> 
> As phy_interface_mode_is_8023z() returns true for both
> PHY_INTERFACE_MODE_1000BASEX and PHY_INTERFACE_MODE_2500BASEX we
> explicitly test for 1000BaseX instead of using
> phy_interface_mode_is_8023z() to differentiate the different
> possibilities.
> 
> Fixes: da58a931f248f ("net: mvneta: Add support for 2500Mbps SGMII")
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>

2500base-X is used today on Armada 388 and Armada 3720 platforms and
works - it is known to interoperate with Marvell PP2.2 hardware, as
well was various SFPs such as the Huawei MA5671A at 2.5Gbps.  The way
it is handled on these platforms is via the COMPHY, requesting that
the serdes is upclocked from 1.25Gbps to 3.125Gbps.

This "DRSGMII" mode is not mentioned in the functional specs for either
the Armada 388 or Armada 3720, the value you poke into the register is
not mentioned either.  As I've already requested, some information on
exactly what this "DRSGMII" is would be very useful, it can't be
"double-rate SGMII" because that would give you 2Gbps instead of 1Gbps.

So, I suspect this breaks the platforms that are known to work.

We need a proper description of what DRSGMII is before we can consider
taking any patches for it.

So, sorry, but NAK.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

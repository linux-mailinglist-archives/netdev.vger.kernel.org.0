Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C764845CC0E
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 19:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239871AbhKXSaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 13:30:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236712AbhKXSaI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 13:30:08 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39FDCC061574
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 10:26:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=t0zv+Uau4F84LVT7wybO+goB8I07I71TIhtuoFdzoWg=; b=GOnfrbijg3chpB2yJPGeNll/iD
        UtWa8aS8/vIe9rTXU+UeQDl3FBTuW2zbHfREDfFiTNSWKDxFnKF0sdASHtS51QxU5bv5zMIPhCta4
        9cSg0W3rtSfPLYaWsruWuG3yweYvwlTNAJk70u4Bmz98GQPDOX2al5YgRjx2m9Y7+gNiYjkpka/qj
        NERLsb03zk76iJet9mGL3h4zrorwBUGMWGOrELP16CadRpaFLtN5TBi5tOAxWDb9h1BC93ZNOA+ap
        iaGzKbCsgpp+V/3tuDjP/3Lv/HHuNZgfdVHRdGPi0g7YLArv+WXQlyYrDOmmB29royToHNdK+cprU
        a0KceWSg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55862)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mpwyo-00014I-8c; Wed, 24 Nov 2021 18:26:50 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mpwym-0001Oy-Kd; Wed, 24 Nov 2021 18:26:48 +0000
Date:   Wed, 24 Nov 2021 18:26:48 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        George McCollister <george.mccollister@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH RFC net-next 03/12] net: dsa: replace
 phylink_get_interfaces() with phylink_get_caps()
Message-ID: <YZ6D6GESyqbduFgz@shell.armlinux.org.uk>
References: <YZ56WapOaVpUbRuT@shell.armlinux.org.uk>
 <E1mpwRi-00D8L8-F1@rmk-PC.armlinux.org.uk>
 <20211124181507.cqlvv3bp46grpunz@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211124181507.cqlvv3bp46grpunz@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 24, 2021 at 06:15:08PM +0000, Vladimir Oltean wrote:
> On Wed, Nov 24, 2021 at 05:52:38PM +0000, Russell King (Oracle) wrote:
> > Phylink needs slightly more information than phylink_get_interfaces()
> > allows us to get from the DSA drivers - we need the MAC capabilities.
> > Replace the phylink_get_interfaces() method with phylink_get_caps() to
> > allow DSA drivers to fill in the phylink_config MAC capabilities field
> > as well.
> > 
> > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > ---
> 
> The effects of submitting new API without any user :)

It had users at the time, but they were not submitted, and the addition
of MAC capabilities was a future development. Had they been submitted at
the time, then they would have required updating too.

So that's entirely irrelevent.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF0B203356
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 11:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbgFVJ3t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 05:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbgFVJ3s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 05:29:48 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 287B9C061794
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 02:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=UFbpF+Fi82v4P6GbwhVJWErk/Vr9srbDGOo7/o9xpNo=; b=NVNVGeEccUdU/RTVmB0YdudfD
        joaAtvHRCj/km+ph4gDlk9CCzDlqrpQeRF6V1L1SdGvd3qSHuxzWKYDdjp9SJMK9Iflh7v+D2M0aS
        0fjLDK0MYNw8MeotzwRo4Q+940iScggTRsuF7lOyOQOJMQOx/vaHGPHIMfNoiFs6RBwrS1jeTj0Fe
        +NYReWlHOzO2DL/HYrXJD3TjYmsjqeq303M+qNzCYGb6mvYBbssBYdmkIM6O3cg/2GsvSTzNkD2b4
        X8o6LughusuVlwe7pvqKC3j4uiDGfQ76vBmYM36T2AYry1ed6ED9EyuUjqwtlwUY5gCwKqDI7UXyC
        HqGidu3Vw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58944)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jnIlu-0008Q4-7S; Mon, 22 Jun 2020 10:29:46 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jnIlt-0008Nt-1m; Mon, 22 Jun 2020 10:29:45 +0100
Date:   Mon, 22 Jun 2020 10:29:45 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, michael@walle.cc, andrew@lunn.ch,
        f.fainelli@gmail.com, olteanv@gmail.com
Subject: Re: [PATCH net-next v3 0/9] net: phy: add Lynx PCS MDIO module
Message-ID: <20200622092944.GB1551@shell.armlinux.org.uk>
References: <20200621225451.12435-1-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200621225451.12435-1-ioana.ciornei@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 22, 2020 at 01:54:42AM +0300, Ioana Ciornei wrote:
> Add support for the Lynx PCS as a separate module in drivers/net/phy/.
> The advantage of this structure is that multiple ethernet or switch
> drivers used on NXP hardware (ENETC, Felix DSA switch etc) can share the
> same implementation of PCS configuration and runtime management.
> 
> The PCS is represented as an mdio_device and the callbacks exported are
> highly tied with PHYLINK and can't be used without it.
> 
> The first 3 patches add some missing pieces in PHYLINK and the locked
> mdiobus write accessor. Next, the Lynx PCS MDIO module is added as a
> standalone module. The majority of the code is extracted from the Felix
> DSA driver. The last patch makes the necessary changes in the Felix
> driver in order to use the new common PCS implementation.
> 
> At the moment, USXGMII (only with in-band AN and speeds up to 2500),
> SGMII, QSGMII (with and without in-band AN) and 2500Base-X (only w/o
> in-band AN) are supported by the Lynx PCS MDIO module since these were
> also supported by Felix and no functional change is intended at this
> time.

Overall, I think we need to sort out the remaining changes in phylink
before moving forward with this patch set - I've made some progress
with Florian and the Broadcom DSA switches late last night.  I'm now
working on updating the felix DSA driver.

There's another reason - having looked at the work I did with this
same PHY, I think you are missing configuration of the link timer,
which is different in SGMII and 1000BASE-X.  Please can you look at
the code I came up with?  "dpaa2-mac: add 1000BASE-X/SGMII PCS support".

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

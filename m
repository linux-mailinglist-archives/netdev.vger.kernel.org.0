Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2E581FF7F0
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 17:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731458AbgFRPsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 11:48:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:53508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728027AbgFRPsq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 11:48:46 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E876206FA;
        Thu, 18 Jun 2020 15:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592495326;
        bh=pZJyK7I5M90pT1oXRjzUsfsRX/cjh7QteDL1dZ4WYxE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KY1EXfHZdpc4GFPDT9x/mo3w4ImyiInv5qS6ewEFDvAa5Hy2bBlT0N/6UYDK7PUbJ
         +u/T/j+rorRBiesc362ch1VPp+oA4fFRXl2F1m8bliCbBR8ia/5SILQ3RZDKpZxrKs
         RnqVmY5zrWlS1Dn2Vn0acFZcTShEDKsmDlWLnnOk=
Date:   Thu, 18 Jun 2020 08:48:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, michael@walle.cc, andrew@lunn.ch,
        linux@armlinux.org.uk, f.fainelli@gmail.com
Subject: Re: [PATCH net-next 5/5] net: dsa: felix: use the Lynx PCS helpers
Message-ID: <20200618084844.1540e6d2@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200618120837.27089-6-ioana.ciornei@nxp.com>
References: <20200618120837.27089-1-ioana.ciornei@nxp.com>
        <20200618120837.27089-6-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Jun 2020 15:08:37 +0300 Ioana Ciornei wrote:
> Use the helper functions introduced by the newly added
> Lynx PCS MDIO module.
> 
> Instead of representing the PCS as a phy_device, a mdio_device structure
> will be passed to the Lynx module which is now actually implementing all
> the PCS configuration and status reporting.
> 
> All code previously used for PCS momnitoring and runtime configuration
> is removed and replaced will calls to the Lynx PCS operations.
> 
> Tested on the following SERDES protocols of LS1028A: 0x7777
> (2500Base-X), 0x85bb (QSGMII), 0x9999 (SGMII) and 0x13bb (USXGMII).
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Hm, this does not build with allmodconfig.

drivers/net/phy/mdio-lynx-pcs.o: In function `lynx_pcs_link_up':
mdio-lynx-pcs.c:(.text+0x115): undefined reference to `mdiobus_modify'
mdio-lynx-pcs.c:(.text+0x1a3): undefined reference to `mdiobus_write'
drivers/net/phy/mdio-lynx-pcs.o: In function `lynx_pcs_config':
mdio-lynx-pcs.c:(.text+0x33a): undefined reference to `mdiobus_write'
mdio-lynx-pcs.c:(.text+0x371): undefined reference to `mdiobus_modify'
mdio-lynx-pcs.c:(.text+0x384): undefined reference to `phylink_mii_c22_pcs_config'
mdio-lynx-pcs.c:(.text+0x3e4): undefined reference to `mdiobus_write'
mdio-lynx-pcs.c:(.text+0x40d): undefined reference to `mdiobus_write'
mdio-lynx-pcs.c:(.text+0x422): undefined reference to `mdiobus_write'
drivers/net/phy/mdio-lynx-pcs.o: In function `lynx_pcs_get_state_usxgmii.isra.0':
mdio-lynx-pcs.c:(.text+0x457): undefined reference to `mdiobus_read'
mdio-lynx-pcs.c:(.text+0x4f1): undefined reference to `mdiobus_read'
drivers/net/phy/mdio-lynx-pcs.o: In function `lynx_pcs_get_state':
mdio-lynx-pcs.c:(.text+0x650): undefined reference to `phylink_mii_c22_pcs_get_state'
mdio-lynx-pcs.c:(.text+0x6fb): undefined reference to `phy_duplex_to_str'
mdio-lynx-pcs.c:(.text+0x711): undefined reference to `phy_speed_to_str'
mdio-lynx-pcs.c:(.text+0x7c0): undefined reference to `mdiobus_read'
mdio-lynx-pcs.c:(.text+0x7d4): undefined reference to `mdiobus_read'
drivers/net/phy/mdio-lynx-pcs.o: In function `lynx_pcs_an_restart':
mdio-lynx-pcs.c:(.text+0x954): undefined reference to `mdiobus_write'
mdio-lynx-pcs.c:(.text+0x978): undefined reference to `phylink_mii_c22_pcs_an_restart'
make[1]: *** [vmlinux] Error 1
make: *** [__sub-make] Error 2

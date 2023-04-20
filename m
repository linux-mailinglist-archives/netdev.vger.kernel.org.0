Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88A9C6E955E
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 15:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbjDTNHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 09:07:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230459AbjDTNHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 09:07:32 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 869784497;
        Thu, 20 Apr 2023 06:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=CU43sr26NtEC2kEdchgJlz6VjiMm/CokCw0uExZFsdg=; b=1Zkng9LJPp8Zd1T2fBdmK65iKA
        OZ3PJUbCx75Sok2QFYbzqSoZg9+IDJac0TXhHj1SFUHJrXyPM7+JdUZjgrVpY7N4F4nTLhtg0gFGv
        X7dtD7UcXDFF1NVzNwocXmry8MoNCMGT9DbBgCGE1GL8gwv8LbSHDOjWorutcw9UPGfg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ppU0C-00AnCT-4u; Thu, 20 Apr 2023 15:07:08 +0200
Date:   Thu, 20 Apr 2023 15:07:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     kernel test robot <lkp@intel.com>, llvm@lists.linux.dev,
        oe-kbuild-all@lists.linux.dev,
        Christian Marangi <ansuelsmth@gmail.com>,
        Netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [lunn:v6.3-rc2-net-next-phy-leds 5/15] ld.lld: error: undefined
 symbol: devm_mdiobus_alloc_size
Message-ID: <758fff85-aefc-4e0a-97b1-fe7179fafac6@lunn.ch>
References: <202303241935.xRMa6mc6-lkp@intel.com>
 <f16fb810-f70d-40ac-8e9d-2ada008c446d@app.fastmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f16fb810-f70d-40ac-8e9d-2ada008c446d@app.fastmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023 at 08:31:17AM +0200, Arnd Bergmann wrote:
> On Fri, Mar 24, 2023, at 12:36, kernel test robot wrote:
> >>> ld.lld: error: undefined symbol: devm_mdiobus_alloc_size
> >    >>> referenced by phy.h:458 (include/linux/phy.h:458)
> >    >>>               
> > drivers/net/ethernet/microchip/lan743x_main.o:(lan743x_pcidev_probe) in 
> > archive vmlinux.a
> >    >>> referenced by phy.h:458 (include/linux/phy.h:458)
> >    >>>               drivers/net/ethernet/ni/nixge.o:(nixge_probe) in 
> > archive vmlinux.a
> >
> > Kconfig warnings: (for reference only)
> >    WARNING: unmet direct dependencies detected for PHYLIB
> 
> It looks like this has hit linux-next now, I'm seeing the same problem in
> my own randconfig builds after Andrew's 01e5b728e9e4 ("net: phy: Add a
> binding for PHY LEDs").

Hi Arnd

I tried to fix this with:

commit 37f9b2a6c086bb28487a0682b8098f907861c4a1
Author: Andrew Lunn <andrew@lunn.ch>
Date:   Thu Mar 30 20:13:29 2023 -0500

    net: ethernet: Add missing depends on MDIO_DEVRES
    
    A number of MDIO drivers make use of devm_mdiobus_alloc_size(). This
    is only available when CONFIG_MDIO_DEVRES is enabled. Add missing
    depends or selects, depending on if there are circular dependencies or
    not. This avoids linker errors, especially for randconfig builds.

All the failures i've seen have CONFIG_MDIO_DEVRES set to disabled. So
i added either depends on, or select to the drivers which use it. I
missed the LAN743x.

> The problem here is that both PHYLIB and LEDS_CLASS are user-visible
> tristate symbols that are referenced from other Kconfig symbols with
> both 'depends on' and 'select'. Having the two interact introduces a
> number of ways that lead to circular dependencies.

I was getting circular dependencies with first versions of the above
patch. I initially tried depends on everywhere, and then had to drop
back to select for a few cases.

> It might be ok to use 'select LEDS_CLASS' from PHYLIB, but I have not
> tried that yet and I expect this will result in other build failures.
> 
> A better solution would be to change all drivers that currently use
> 'select PHYLIB' to 'depends on PHYLIB' and have PHYLIB itself
> 'default ETHERNET' to avoid most of the regressions, but doing this
> for 6.4 is a bit risky and can cause other problems.

For 6.4, will adding more depend on/select MDIO_DEVRES help? That
should be low risk.

Thanks
	Andrew

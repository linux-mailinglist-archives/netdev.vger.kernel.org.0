Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB5B837F4FD
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 11:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232065AbhEMJpd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 05:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231193AbhEMJp2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 05:45:28 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76D6EC061574;
        Thu, 13 May 2021 02:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=8lKBmdjvyNJC0zSVS9+cqxL1DCxV5U8RNgB+s7i0tH8=; b=aVEmWKaAYpr2okDCcyt3Yv7zs
        jWLgwljgaZaCitHkfIJaO6qVaNT2ncb4viijtLJXVnZ8W/dooauIr0wgC1MyFb4qTgK+EfMqPscvM
        X3KADSYrV7XQ5UE8uESnUcIt2ku4uojePpco/7SfH40CIenjESKrNGpjpDA41p0KF4iV4VkaRvuaf
        YmZtCyc6O5yYnmyDrbgUSu5vQlDycB9rZUV+aQNOWpP4ac2bmUJ/n2ixqklwv27WoBHQHyXS03Cf5
        BfHfSdJKUsio36PPqASSXhD8mm4mMtitnNuYCXTkVZ/t8eIg/+PlgIX3EP5UZHo/W3Hrjo0dJyvaT
        fJDzP/mgg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:43922)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lh7tA-0005uI-DM; Thu, 13 May 2021 10:44:16 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lh7t9-0002uD-Vh; Thu, 13 May 2021 10:44:16 +0100
Date:   Thu, 13 May 2021 10:44:15 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, f.fainelli@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net: mdio: octeon: Fix some double free issues
Message-ID: <20210513094415.GV1336@shell.armlinux.org.uk>
References: <7adc1815237605a0b774efb31a2ab22df51462d3.1620890610.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7adc1815237605a0b774efb31a2ab22df51462d3.1620890610.git.christophe.jaillet@wanadoo.fr>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 13, 2021 at 09:24:55AM +0200, Christophe JAILLET wrote:
> 'bus->mii_bus' has been allocated with 'devm_mdiobus_alloc_size()' in the
> probe function. So it must not be freed explicitly or there will be a
> double free.
> 
> Remove the incorrect 'mdiobus_free' in the error handling path of the
> probe function and in remove function.
> 
> Suggested-By: Andrew Lunn <andrew@lunn.ch>
> Fixes: 35d2aeac9810 ("phy: mdio-octeon: Use devm_mdiobus_alloc_size()")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>

> ---
> The 'smi_en.u64 = 0; oct_mdio_writeq()' looks odd to me. Usually the normal
> path and the error handling path don't write the same value. Here, both
> write 0.
> Having '1' somewhere would 'look' more usual. :)
> More over I think that 'smi_en.s.en = 1;' in the probe is useless.

It looks fine to me.

        smi_en.u64 = 0;
        smi_en.s.en = 1;
        oct_mdio_writeq(smi_en.u64, bus->register_base + SMI_EN);

smi_en is a union of a u64 and a structure containing a bitfield. s.en
corresponds on LE systems with the u64 bit 0. So the above has the
effect of writing a u64 value of '1' to the SMI_EN register, whereas:

        smi_en.u64 = 0;
        oct_mdio_writeq(smi_en.u64, bus->register_base + SMI_EN);

has the effect of writing a u64 value of '0' to the SMI_EN register.

This code is fine.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

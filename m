Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC62537EEA4
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 01:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442240AbhELV5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 17:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388045AbhELVtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 17:49:14 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DEC9C06138D;
        Wed, 12 May 2021 14:44:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=y/fK96kafVWJUqOAzIofEe1Sj54Q2fAf5XvOg0ehO8Y=; b=1xqf+KJauQDYC+YkSlJFrN3aU
        +duX9QVTX92GZYhiCtbThLDRSUB6+0TK+MuOKEEU7qvGYXUmxUn2lccwktaLjL0uWAa3pYSW90txs
        p5fZPv0V4dWNt065MBRzviRyIfPESg3Wjq9l4K+/1XZ6lCVdOqC1LxsJ16BgkfDTZdQi/T+Hjg3PM
        /dGwOGgWcGZZKhq9K9maC9fu5qG/uVNwv1+Zk1bN2LNxChDv7p7GNjFMRjnr0HR04fSIGva8JZZlW
        IEbS/OUuB3tvPeJAJGRJi6ugzLVwFhpHyLUTNAIF/VPpTk6eUuC9fzuzdXmzW3fTaUd0bWWZL20HL
        r84m/dxZA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:43900)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lgweD-00058K-IP; Wed, 12 May 2021 22:44:05 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lgweB-0002MJ-Js; Wed, 12 May 2021 22:44:03 +0100
Date:   Wed, 12 May 2021 22:44:03 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, david.daney@cavium.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net: mdio: Fix a double free issue in the .remove
 function
Message-ID: <20210512214403.GQ1336@shell.armlinux.org.uk>
References: <f8ad939e6d5df4cb0273ea71a418a3ca1835338d.1620855222.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f8ad939e6d5df4cb0273ea71a418a3ca1835338d.1620855222.git.christophe.jaillet@wanadoo.fr>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 12, 2021 at 11:35:38PM +0200, Christophe JAILLET wrote:
> 'bus->mii_bus' have been allocated with 'devm_mdiobus_alloc_size()' in the
> probe function. So it must not be freed explicitly or there will be a
> double free.
> 
> Remove the incorrect 'mdiobus_free' in the remove function.

Yes, this looks correct, thanks.

Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>

However, there's another issue in this driver that ought to be fixed.

If devm_mdiobus_alloc_size() succeeds, but of_mdiobus_register() fails,
we continue on to the next bus (which I think is reasonable.) We don't
free the bus.

When we come to the remove method however, we will call
mdiobus_unregister() on this existent but not-registered bus. Surely we
don't want to do that?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFFD69F4E2
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 13:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231752AbjBVMuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 07:50:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231234AbjBVMuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 07:50:16 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9270230295;
        Wed, 22 Feb 2023 04:50:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=mNXzgKur61SyqOKJ0HYgvhWIHUy8EMi7plEVd3tpR3Q=; b=oLKFhxUQW+nYsvc52wALgVPw2D
        fPRuI/JDLAE4jksfN1RZZKXJgV6/Es1/1pG1EPgbY8t6jYIthKx3SzzvR+taMiEVCkuu5W6gbcWVh
        6dFSjp7GA+hVFM0Qj2eisdHSh2riyuhGMEwYpXNF+1ulbgcJ2hIxdHsqfZAVY+tUEM/gscUpcT8y4
        scJn754dQ5ELllocAYij3ro9V7pVXoFvd1Zi80Wb5ULGwXIemLENH7hHf2RA2AlE+/J80v6ZnCRcZ
        QcC2RROZwnAUjBHLJ2TRxgErIigQzgxrep6TONfA/wfYW1cW4G3nGEgfXkcVoaYQt4suz3rlWp2rL
        1j9GTWuA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35390)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pUoZV-0006yO-NO; Wed, 22 Feb 2023 12:50:09 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pUoZT-0003DX-AK; Wed, 22 Feb 2023 12:50:07 +0000
Date:   Wed, 22 Feb 2023 12:50:07 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, UNGLinuxDriver@microchip.com,
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>, stable@vger.kernel.org
Subject: Re: [PATCH] net: dsa: microchip: Fix gigabit set and get function
 for KSZ87xx
Message-ID: <Y/YPfxg8Ackb8zmW@shell.armlinux.org.uk>
References: <20230222031738.189025-1-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230222031738.189025-1-marex@denx.de>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 22, 2023 at 04:17:38AM +0100, Marek Vasut wrote:
> diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
> index 729b36eeb2c46..7fc2155d93d6e 100644
> --- a/drivers/net/dsa/microchip/ksz_common.c
> +++ b/drivers/net/dsa/microchip/ksz_common.c
> @@ -319,7 +319,7 @@ static const u16 ksz8795_regs[] = {
>  	[S_BROADCAST_CTRL]		= 0x06,
>  	[S_MULTICAST_CTRL]		= 0x04,
>  	[P_XMII_CTRL_0]			= 0x06,
> -	[P_XMII_CTRL_1]			= 0x56,
> +	[P_XMII_CTRL_1]			= 0x06,

Looking at this driver, I have to say that it looks utterly vile
from the point of view of being sure that it is correct, and I
think this patch illustrates why.

You mention you're using a KSZ8794. This uses the ksz8795_regs
array, and ksz8_dev_ops. You claim this is about the P_GMII_1GBIT_M
bit, which is bit 6.

This bit is accessed only by ksz_get_gbit() and ksz_set_gbit().

Firstly, ksz_set_gbit() is only called from ksz_port_set_xmii_speed(),
which is only called from ksz9477_phylink_mac_link_up(). This is only
referenced by ksz9477_dev_ops and lan937x_dev_ops, but not ksz8_dev_ops.
Therefore, ksz_set_gbit() is not called for KSZ8794.

ksz_get_gbit() is only referenced by ksz9477.c in
ksz9477_get_interface(), called only by ksz9477_config_cpu_port().
This is only referenced by ksz9477_dev_ops, but not ksz8_dev_ops.

Therefore, my conclusion is that neither of the ksz_*_gbit()
functions are called on KSZ8794, and thus your change has no effect
on the driver's use of P_GMII_1GBIT_M - I think if you put some
debugging printk()s into both ksz_*_gbit() functions, it'll prove
that.

There's other places that P_XMII_CTRL_1 is accessed - ksz_set_xmii()
and ksz_get_xmii(). These look at the P_MII_SEL_M, P_RGMII_ID_IG_ENABLE
and P_RGMII_ID_EG_ENABLE bits - bits 0, 1, 3 and 4.

ksz_get_xmii() is only called by ksz9477_get_interface(), which we've
already looked at above as not being called.

ksz_set_xmii() is only called by ksz_phylink_mac_config(), which is
always called irrespective of the KSZ chip.

Now, let's look at functions that access P_XMII_CTRL_0. These are
ksz_set_100_10mbit() and ksz_duplex_flowctrl(). The former
accesses bit P_MII_100MBIT_M, which is bit 4. The latter looks at
bits 6, bit 5, and possibly bit 3 depending on the masks being used.
KSZ8795 uses ksz8795_masks, which omits bit 3, so bits 5 and 6.
Note... bit 6 is also P_GMII_1GBIT_M. So if ksz_duplex_flowctrl()
is ever called for the KSZ8795, then we have a situation where
the P_GMII_1GBIT_M will be manipulated.

ksz_set_100_10mbit() is only called from ksz_port_set_xmii_speed(),
which we've established won't be called.

ksz_duplex_flowctrl() is only called from ksz9477_phylink_mac_link_up()
which we've also established won't be called.

So, as far as I can see, P_XMII_CTRL_0 won't be accessed on this
device.

Now, what about other KSZ devices - I've analysed this for the KSZ8795,
but what about any of the others which use this register table? It
looks to me like those that use ksz8795_regs[] all use ksz8_dev_ops
and the same masks and bitvals, so they should be the same.

That is a hell of a lot of work to prove that setting both
P_XMII_CTRL_0 and P_XMII_CTRL_1 to point at the same register is
in fact safe. Given the number of registers, the masks, and bitval
arrays, doing this to prove every combination and then analysing
the code is utterly impractical - and thus why I label this driver
as "vile". Is there really no better option to these register
arrays, bitval arrays and mask arrays - something that makes it
easier to review and prove correctness?

I'm not going to give a reviewed-by for this, because... I could
have made a mistake in the above analysis given the vile nature
of this driver.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

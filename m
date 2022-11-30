Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 963E863D4B0
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 12:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbiK3LeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 06:34:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235085AbiK3Ld3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 06:33:29 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DEB363DA;
        Wed, 30 Nov 2022 03:32:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=bala5sYXRYw+sGi8PWv5pz9c1EOsKG0X5boc/1rjBGA=; b=AgOWSJCqrMdjpt/RLVZvdAOeUK
        xpWG2CF3aCC/+Z6UDvNjRIOuths+gW7BwUI0HoW76l0YHVFPIxv/+dR2TI30LFQEUNkWXjzzqYM9u
        rKcb00iFtgZDeJ3m8AOKekdE7vrBJnvA0zFDat+gJdmqTrgWdJ6d/IAN5E+MVuNam/Cu5gf20BJ0H
        qVdkki/yQjiF1DE52usTcJf0/CLXStCKMDbWN2zGm54fpu9y/Qg0mqgKdPoDmSrsbwvkRuU+GiElb
        ygwh4y0HvbVy5PibWanCGzbZ4JXYIVu74CQG72YM7Cp4BfUVyCkIUc1WWqAepU6d5qcVfLuKJTBAj
        w07kh9pw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35494)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1p0LKM-0001eb-Vm; Wed, 30 Nov 2022 11:32:35 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1p0LKK-0002S4-Le; Wed, 30 Nov 2022 11:32:32 +0000
Date:   Wed, 30 Nov 2022 11:32:32 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Clark Wang <xiaoning.wang@nxp.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        andrew@lunn.ch, hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] net: phylink: add sync flag mac_ready to fix resume
 issue with WoL enabled
Message-ID: <Y4c/UCHxIWZQVwi6@shell.armlinux.org.uk>
References: <20221130111148.1064475-1-xiaoning.wang@nxp.com>
 <20221130111148.1064475-2-xiaoning.wang@nxp.com>
 <Y4c9PlfEC17pVE08@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4c9PlfEC17pVE08@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 30, 2022 at 11:23:42AM +0000, Russell King (Oracle) wrote:
> On Wed, Nov 30, 2022 at 07:11:47PM +0800, Clark Wang wrote:
> > Issue we met:
> > On some platforms, mac cannot work after resumed from the suspend with WoL
> > enabled.
> > 
> > The cause of the issue:
> > 1. phylink_resolve() is in a workqueue which will not be executed immediately.
> >    This is the call sequence:
> >        phylink_resolve()->phylink_link_up()->pl->mac_ops->mac_link_up()
> >    For stmmac driver, mac_link_up() will set the correct speed/duplex...
> >    values which are from link_state.
> > 2. In stmmac_resume(), it will call stmmac_hw_setup() after called the
> >    phylink_resume(). stmmac_core_init() is called in function stmmac_hw_setup(),
> 
> ... and that is where the problem is. Don't call phylink_resume() before
> your hardware is ready to see a link-up event.

... and while that is being fixed, maybe the stupid code in
stmmac_resume() can also be fixed:

        rtnl_lock();
        if (device_may_wakeup(priv->device) && priv->plat->pmt) {
                phylink_resume(priv->phylink);
        } else {
                phylink_resume(priv->phylink);
                if (device_may_wakeup(priv->device))
                        phylink_speed_up(priv->phylink);
        }
        rtnl_unlock();

        rtnl_lock();

1. phylink_resume() is always called after that first rtnl_lock(), so
there's no point it being stupidly in each side of the if().

2. the rtnl_unlock() followed by rtnl_lock() is completely unnecessary.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

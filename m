Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A06C45C833
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 16:04:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235796AbhKXPHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 10:07:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235588AbhKXPHQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 10:07:16 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38BB2C061574;
        Wed, 24 Nov 2021 07:04:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ApSPonCUp/GG9TGqMr522k7jLaMFyzDlr31PRHF6kBM=; b=HBCUuNaY68/EDTeCXBNjHANIfU
        NZu16JMgs4FFHDVQaIJ7KrRuijEvzS8YtAV4oV8S69+kssPN8EPYxm1HpYqRoMhMeBV3zvVKrAiZA
        +gTRLcjMss3JxF/EBSmXVugiaNPAcccd5hIN/RSg750+sYzbjmAfzRGPgdvx7Q+lEFJqraDMQLp4X
        R+3K3GysmHxO/HoVZy4YbFvl4dlp0DplHHxpMvFdFcXHk9eUNP3czYPtzHGcb9zDpH3sH4dbg2W8O
        oxLjmAWMyggUagqe8qpfELlkL5LzlqfrWZRvDDtGuLHWtN1SW6tNsJT9Q65QFU0Vx9ilZM7n2/hpN
        F8K6fOAA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55850)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mptoU-0000l0-Q5; Wed, 24 Nov 2021 15:03:58 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mptoT-0001HC-BO; Wed, 24 Nov 2021 15:03:57 +0000
Date:   Wed, 24 Nov 2021 15:03:57 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, p.zabel@pengutronix.de,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 3/6] net: lan966x: add port module support
Message-ID: <YZ5UXdiNNf011skU@shell.armlinux.org.uk>
References: <20211124083915.2223065-1-horatiu.vultur@microchip.com>
 <20211124083915.2223065-4-horatiu.vultur@microchip.com>
 <YZ4SB/wX6UT3zrEV@shell.armlinux.org.uk>
 <20211124145800.my4niep3sifqpg55@soft-dev3-1.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211124145800.my4niep3sifqpg55@soft-dev3-1.localhost>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 24, 2021 at 03:58:00PM +0100, Horatiu Vultur wrote:
> > This doesn't look like the correct sequence to me. Shouldn't the net
> > device be unregistered first, which will take the port down by doing
> > so and make it unavailable to userspace to further manipulate. Then
> > we should start tearing other stuff down such as destroying phylink
> > and disabling interrupts (in the caller of this.)
> 
> I can change the order as you suggested.
> Regarding the interrupts, shouldn't they be first disable and then do
> all the teardown?

Depends if you need them disabled before you do the teardown. However,
what would be the effect of disabling interrupts while the user still
has the ability to interact with the port - that is the main point.

Generally the teardown should be the reverse of setup - where it's now
accepted that all setup should be done prior to user publication. So,
user interfaces should be removed and then teardown should proceed.

> > What is the difference between "portmode" and "phy_mode"? Does it matter
> > if port->config.phy_mode get zeroed when lan966x_port_pcs_set() is
> > called from lan966x_pcs_config()? It looks to me like the first call
> > will clear phy_mode, setting it to PHY_INTERFACE_MODE_NA from that point
> > on.
> 
> The purpose was to use portmode to configure the MAC and the phy_mode
> to configure the serdes. There are small issues regarding this which
> will be fix in the next series also I will add some comments just to
> make it clear.
> 
> Actually, port->config.phy_mode will not get zeroed. Because right after
> the memset it follows: 'config = port->config'.

Ah, missed that, thanks. However, why should portmode and phy_mode be
different?

> Actually, like you mentioned it needs to be link partner's advertisement
> so that code can be simplified more:
> 
>          if (DEV_PCS1G_ANEG_STATUS_ANEG_COMPLETE_GET(val)) {
>                  state->an_complete = true;
>  
>                  bmsr |= state->link ? BMSR_LSTATUS : 0;
>                  bmsr |= BMSR_ANEGCOMPLETE;
>  
>                  lp_adv = DEV_PCS1G_ANEG_STATUS_LP_ADV_GET(val);
>                  phylink_mii_c22_pcs_decode_state(state, bmsr, lp_adv);
>          }
> 
> Because inside phylink_mii_c22_pcs_decode_state, more precisely in
> phylink_decode_c37_work, state->advertising will have the local
> advertising.

Correct.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

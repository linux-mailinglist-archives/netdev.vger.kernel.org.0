Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A54606D848A
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 19:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231686AbjDERJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 13:09:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbjDERJB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 13:09:01 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCFCEE41;
        Wed,  5 Apr 2023 10:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=fXg8Mb4yOCOXyW4T6AIOqAjFd/E1fGh7oVSStyatFrU=; b=sI1gxebUBcKKqxgNaWbHB180aE
        WyuecNnx7sFIX6oa6Rc3UFJSttpR5yCk8wA+GX4Gs2/S4d8Kj5HyLJu+LG5f6hg4I1QSF85muu9Ig
        UoZu9oCE3QTJJttpc31MIXwfVIFa0L4sxkml8rvWaNQm56wBQk7xrXQ8q4J/STD94u0WJ3Tl5ISX3
        UFLT6GIYgrg9ZSPOEBjxHynE1Lg7X5hC3jV9KQI4G8VhVZFfTE+GvpVV/CEB23IGuGcfFjbldaV3D
        t3HG9OuI3mZyeb0xBaN0TLlIZKYeeivLyrY4TOwFB7ey0AtPfxnfVyedE236HNPCObgbbXvKax51L
        jx6G4gzw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:50532)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pk6cg-0005ua-Jz; Wed, 05 Apr 2023 18:08:38 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pk6cY-0006Vl-Ur; Wed, 05 Apr 2023 18:08:30 +0100
Date:   Wed, 5 Apr 2023 18:08:30 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Looi Hong Aun <hong.aun.looi@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Lai Peter Jun Ann <peter.jun.ann.lai@intel.com>
Subject: Re: [PATCH net v3 2/3] net: stmmac: check if MAC needs to attach to
 a PHY
Message-ID: <ZC2rDr0lE6p9VsdQ@shell.armlinux.org.uk>
References: <20230324081656.2969663-1-michael.wei.hong.sit@intel.com>
 <20230324081656.2969663-3-michael.wei.hong.sit@intel.com>
 <5bb39f85-7ef0-4cbb-a06b-0d6431ab09b7@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5bb39f85-7ef0-4cbb-a06b-0d6431ab09b7@roeck-us.net>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 05, 2023 at 10:02:16AM -0700, Guenter Roeck wrote:
> Hi,
> 
> On Fri, Mar 24, 2023 at 04:16:55PM +0800, Michael Sit Wei Hong wrote:
> > After the introduction of the fixed-link support, the MAC driver
> > no longer attempt to scan for a PHY to attach to. This causes the
> > non fixed-link setups to stop working.
> > 
> > Using the phylink_expects_phy() to check and determine if the MAC
> > should expect and attach a PHY.
> > 
> > Fixes: ab21cf920928 ("net: stmmac: make mdio register skips PHY scanning for fixed-link")
> > Signed-off-by: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
> > Signed-off-by: Lai Peter Jun Ann <peter.jun.ann.lai@intel.com>
> 
> With this patch in linux-next, the orangepi-pc qemu emulation fails to
> bring up the Ethernet interface. The following error is seen.
> 
> [   12.482401] dwmac-sun8i 1c30000.ethernet eth0: Register MEM_TYPE_PAGE_POOL RxQ-0
> [   12.487789] dwmac-sun8i 1c30000.ethernet eth0: PHY [mdio_mux-0.1:01] driver [Generic PHY] (irq=POLL)
> [   12.488177] dwmac-sun8i 1c30000.ethernet eth0: no phy found
> [   12.488295] dwmac-sun8i 1c30000.ethernet eth0: __stmmac_open: Cannot attach to PHY (error: -19)
> 
> Reverting this patch fixes the problem.

Please see 20230405093945.3549491-1-michael.wei.hong.sit@intel.com
for the fix.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

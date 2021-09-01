Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F36423FD648
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 11:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243475AbhIAJOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 05:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243474AbhIAJOn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 05:14:43 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD6FC061575
        for <netdev@vger.kernel.org>; Wed,  1 Sep 2021 02:13:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=6Mrrc7bEGRXEO6owa3uklfTEnRYUX0fSZh11N8w3gd0=; b=aOLmojBOOvYrObAdBi35DBFcS
        yhrhPtGyfJtA8w5V7ldLPZD9DbMdmbcD9eci3OA1tDj3wQ6JAe9HQ+7NEmpNivSCD8DEc5WoUzaw3
        yOZH4AymMSS6jkkg/ZZ3DxF1rOdI4d8CfAnEXmU9CAC+q3FvGPekEZezI8eMaJqgK8jq70aQ8NVA3
        FhqfF81wFziQHVuLbqMD/WLQbJ02imv7FMZAkNUwnHjYq4/zf2CNPGHXQGKOO0oxAePboQ5IbrkpZ
        F3sCqxGj91krip3Yb9V/3/p2RysTVHsuBlCv68/kD4sj1FhUq1/Hj6VPB86uiXTNibikg7azDh0qR
        9wKJ1LZXg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:47974)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mLMJM-0007qU-QM; Wed, 01 Sep 2021 10:13:36 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mLMJI-0006jw-Tk; Wed, 01 Sep 2021 10:13:32 +0100
Date:   Wed, 1 Sep 2021 10:13:32 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux-imx@nxp.com
Subject: Re: [PATCH] net: stmmac: fix MAC not working when system resume back
 with WoL enabled
Message-ID: <20210901091332.GZ22278@shell.armlinux.org.uk>
References: <20210901090228.11308-1-qiangqing.zhang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210901090228.11308-1-qiangqing.zhang@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 01, 2021 at 05:02:28PM +0800, Joakim Zhang wrote:
> We can reproduce this issue with below steps:
> 1) enable WoL on the host
> 2) host system suspended
> 3) remote client send out wakeup packets
> We can see that host system resume back, but can't work, such as ping failed.
> 
> After a bit digging, this issue is introduced by the commit 46f69ded988d
> ("net: stmmac: Use resolved link config in mac_link_up()"), which use
> the finalised link parameters in mac_link_up() rather than the
> parameters in mac_config().
> 
> There are two scenarios for MAC suspend/resume:
> 
> 1) MAC suspend with WoL disabled, stmmac_suspend() call
> phylink_mac_change() to notify phylink machine that a change in MAC
> state, then .mac_link_down callback would be invoked. Further, it will
> call phylink_stop() to stop the phylink instance. When MAC resume back,
> firstly phylink_start() is called to start the phylink instance, then
> call phylink_mac_change() which will finally trigger phylink machine to
> invoke .mac_config and .mac_link_up callback. All is fine since
> configuration in these two callbacks will be initialized.
> 
> 2) MAC suspend with WoL enabled, phylink_mac_change() will put link
> down, but there is no phylink_stop() to stop the phylink instance, so it
> will link up again, that means .mac_config and .mac_link_up would be
> invoked before system suspended. After system resume back, it will do
> DMA initialization and SW reset which let MAC lost the hardware setting
> (i.e MAC_Configuration register(offset 0x0) is reset). Since link is up
> before system suspended, so .mac_link_up would not be invoked after
> system resume back, lead to there is no chance to initialize the
> configuration in .mac_link_up callback, as a result, MAC can't work any
> longer.
> 
> Above description is what I found when debug this issue, this patch is
> just revert broken patch to workaround it, at least make MAC work when
> system resume back with WoL enabled.
> 
> Said this is a workaround, since it has not resolve the issue completely.
> I just move the speed/duplex/pause etc into .mac_config callback, there are
> other configurations in .mac_link_up callback which also need to be
> initialized to work for specific functions.

NAK. Please read the phylink documentation. speed/duplex/pause is
undefined in .mac_config.

I think the problem here is that you're not calling phylink_stop()
when WoL is enabled, which means phylink will continue to maintain
the state as per the hardware state, and phylib will continue to run
its state machine reporting the link state to phylink.

phylink_stop() (and therefore phy_stop()) should be called even if
WoL is active to shut down this state reporting, as other network
drivers do.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

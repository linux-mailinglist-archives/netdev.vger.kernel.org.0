Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CCC34972EC
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 17:15:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238502AbiAWQPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jan 2022 11:15:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234456AbiAWQPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jan 2022 11:15:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6F25C06173B;
        Sun, 23 Jan 2022 08:15:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 769F160F9F;
        Sun, 23 Jan 2022 16:15:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D7F1C340E2;
        Sun, 23 Jan 2022 16:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642954550;
        bh=pKH0JMOmNai7JFDdF+OBCDodqqK20XbbX9m5cv2cLTk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SulSkkVDm6DZv8xCQis9mFuQv/3+ghTsDAiAiXGnPGoCocnl1jK28y08CE+OWvbHo
         Lr2/u3tL5M1GXy4L9BZaCTo7v8dWUFw1GqaJ47wf5pjSwomOSPTOrNVFKBzXB+K5nK
         mkiBB+Y+kg5R0fwsmFDlK2gG8LB4DLB8ahHPhNoqX8RXDx6Vll0TzPfCrIAy+r86nE
         Bytr2Ze6VuBe1HJcPLqfcYi/Dx3T9z/peEA7bPkIfSAQHMci9K47hE4xfNy7sdi/C0
         0cgPc7pZke488jFqJyFGXexldT2mhpcaGYkoRAciGLCKYNRssxpnsailYUfLHx2CDT
         LLm1PUbOMd3ww==
Date:   Mon, 24 Jan 2022 00:08:12 +0800
From:   Jisheng Zhang <jszhang@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: stmmac: don't stop RXC during LPI
Message-ID: <Ye19bHxcQ5Plx0v9@xhacker>
References: <20220123141245.1060-1-jszhang@kernel.org>
 <Ye15va7tFWMgKPEE@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Ye15va7tFWMgKPEE@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 23, 2022 at 04:52:29PM +0100, Andrew Lunn wrote:
> On Sun, Jan 23, 2022 at 10:12:45PM +0800, Jisheng Zhang wrote:
> > I met can't receive rx pkt issue with below steps:
> > 0.plug in ethernet cable then boot normal and get ip from dhcp server
> > 1.quickly hotplug out then hotplug in the ethernet cable
> > 2.trigger the dhcp client to renew lease
> > 
> > tcpdump shows that the request tx pkt is sent out successfully,
> > but the mac can't receive the rx pkt.
> > 
> > The issue can easily be reproduced on platforms with PHY_POLL external
> > phy. If we don't allow the phy to stop the RXC during LPI, the issue
> > is gone. I think it's unsafe to stop the RXC during LPI because the mac
> > needs RXC clock to support RX logic.
> > 
> > And the 2nd param clk_stop_enable of phy_init_eee() is a bool, so use
> > false instead of 0.
> > 
> > Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> > ---
> >  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > index 6708ca2aa4f7..92a9b0b226b1 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > @@ -1162,7 +1162,7 @@ static void stmmac_mac_link_up(struct phylink_config *config,
> >  
> >  	stmmac_mac_set(priv, priv->ioaddr, true);
> >  	if (phy && priv->dma_cap.eee) {
> > -		priv->eee_active = phy_init_eee(phy, 1) >= 0;
> > +		priv->eee_active = phy_init_eee(phy, false) >= 0;
> 
> This has not caused issues in the past. So i'm wondering if this is
> somehow specific to your system? Does everybody else use a PHY which
> does not implement this bit? Does your synthesis of the stmmac have a
> different clock tree?
> 
> By changing this value for every instance of the stmmac, you are
> potentially causing a power regression for stmmac implementations
> which don't need the clock. So we need a clear understanding, stopping
> the clock is wrong in general and so the change is correct in

I think this is a common issue because the MAC needs phy's RXC for RX
logic. But it's better to let other stmmac users verify. The issue
can easily be reproduced on platforms with PHY_POLL external phy.
Or other platforms use a dedicated clock rather than clock from phy
for MAC's RX logic?

If the issue turns out specific to my system, then I will send out
a new patch to adopt your suggestion.

Hi Joakim, IIRC, you have stmmac + external RTL8211F phy platform, but
I'm not sure whether your platform have an irq for the phy. could you
help me to check whether you can reproduce the issue on your platform?

> general. Or this is specific to your system, and you probably need to
> add priv->dma_cap.keep_rx_clock_ticking, which you set in your glue
> driver,and use here to decide what to pass to phy_init_eee().

Thanks a lot for the suggestion.

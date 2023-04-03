Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD036D4647
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 15:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232713AbjDCN4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 09:56:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232683AbjDCN4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 09:56:00 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 711BF2706;
        Mon,  3 Apr 2023 06:55:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=cOmxQf/XohzQNc1y5zh+u/LIlyyFogpvuBcXFkIatHs=; b=URJqNH7Rivp8gJDAiwyB6mCoIy
        k+OV9TsBUl6zrXJdh1g1kG8iO/9y8ZfdI8h5o34bT4+SU7tyXjLjR+gJ9uUEiSFcGQuFWnLfTCpx6
        1VEWmbwB0a+V4mbFOCI+jzV9EE3fIjGni9SV1P8OBiXAo+YpgFW/Vv6ETXhM5ahGWbzmzmcW2Pw4g
        22u3J/cGTLLHWjyLZIObT0EZlC6gkPAZHCkqa2I75MO4mERzluyF8+51SUO0Y/6qTzoKMjkwSJ98t
        eYoLvrE8E9clC3hZTjdTtoyFvMn+3Cfv1LpUJQoK6/rys/TPycRxdij9spOkDo6wscfRQlDM7dB3V
        Si0RCsOg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48436)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pjKf2-0002s6-TQ; Mon, 03 Apr 2023 14:55:52 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pjKf1-0004IF-S6; Mon, 03 Apr 2023 14:55:51 +0100
Date:   Mon, 3 Apr 2023 14:55:51 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, rogerq@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        srk@ti.com
Subject: Re: [PATCH net-next v2 1/3] net: ethernet: ti: am65-cpsw: Move mode
 specific config to mac_config()
Message-ID: <ZCra58qbcwKCXBDR@shell.armlinux.org.uk>
References: <20230403110106.983994-1-s-vadapalli@ti.com>
 <20230403110106.983994-2-s-vadapalli@ti.com>
 <ZCqzuwDLGuBDMHQG@shell.armlinux.org.uk>
 <3a62f5cf-ebba-1603-50a0-7a873973534d@ti.com>
 <ZCrQ3lPjEmxXc9a2@shell.armlinux.org.uk>
 <a6dba95a-03ae-12ec-3ef4-c9544073c7a2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6dba95a-03ae-12ec-3ef4-c9544073c7a2@ti.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 03, 2023 at 07:20:21PM +0530, Siddharth Vadapalli wrote:
> 
> 
> On 03-04-2023 18:43, Russell King (Oracle) wrote:
> > On Mon, Apr 03, 2023 at 06:31:52PM +0530, Siddharth Vadapalli wrote:
> >>
> >>
> >> On 03-04-2023 16:38, Russell King (Oracle) wrote:
> >>> On Mon, Apr 03, 2023 at 04:31:04PM +0530, Siddharth Vadapalli wrote:
> >>>> Move the interface mode specific configuration to the mac_config()
> >>>> callback am65_cpsw_nuss_mac_config().
> >>>>
> >>>> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
> >>>> ---
> >>>>  drivers/net/ethernet/ti/am65-cpsw-nuss.c | 10 +++++++---
> >>>>  1 file changed, 7 insertions(+), 3 deletions(-)
> >>>>
> >>>> diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> >>>> index d17757ecbf42..74e099828978 100644
> >>>> --- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> >>>> +++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> >>>> @@ -1504,12 +1504,17 @@ static void am65_cpsw_nuss_mac_config(struct phylink_config *config, unsigned in
> >>>>  							  phylink_config);
> >>>>  	struct am65_cpsw_port *port = container_of(slave, struct am65_cpsw_port, slave);
> >>>>  	struct am65_cpsw_common *common = port->common;
> >>>> +	u32 mac_control = 0;
> >>>>  
> >>>>  	if (common->pdata.extra_modes & BIT(state->interface)) {
> >>>> -		if (state->interface == PHY_INTERFACE_MODE_SGMII)
> >>>> +		if (state->interface == PHY_INTERFACE_MODE_SGMII) {
> >>>> +			mac_control |= CPSW_SL_CTL_EXT_EN;
> >>>>  			writel(ADVERTISE_SGMII,
> >>>>  			       port->sgmii_base + AM65_CPSW_SGMII_MR_ADV_ABILITY_REG);
> >>>> +		}
> >>>>  
> >>>> +		if (mac_control)
> >>>> +			cpsw_sl_ctl_set(port->slave.mac_sl, mac_control);
> >>>>  		writel(AM65_CPSW_SGMII_CONTROL_MR_AN_ENABLE,
> >>>>  		       port->sgmii_base + AM65_CPSW_SGMII_CONTROL_REG);
> >>>>  	}
> >>>> @@ -1553,8 +1558,7 @@ static void am65_cpsw_nuss_mac_link_up(struct phylink_config *config, struct phy
> >>>>  
> >>>>  	if (speed == SPEED_1000)
> >>>>  		mac_control |= CPSW_SL_CTL_GIG;
> >>>> -	if (interface == PHY_INTERFACE_MODE_SGMII)
> >>>> -		mac_control |= CPSW_SL_CTL_EXT_EN;
> >>>> +	/* TODO: Verify whether in-band is necessary for 10 Mbps RGMII */
> >>>>  	if (speed == SPEED_10 && phy_interface_mode_is_rgmii(interface))
> >>>>  		/* Can be used with in band mode only */
> >>>>  		mac_control |= CPSW_SL_CTL_EXT_EN;
> >>>
> >>> I'm afraid I can see you haven't thought this patch through properly.
> >>>
> >>> am65_cpsw_nuss_mac_link_down() will call
> >>> cpsw_sl_ctl_reset(port->slave.mac_sl); which has the effect of clearing
> >>> to zero the entire MAC control register. This will clear
> >>> CPSW_SL_CTL_EXT_EN that was set in am65_cpsw_nuss_mac_config() which is
> >>> not what you want to be doing.
> >>>
> >>> Given that we have the 10Mbps issue with RGMII, I think what you want
> >>> to be doing is:
> >>>
> >>> 1. Set CPSW_SL_CTL_EXT_EN in am65_cpsw_nuss_mac_config() if in SGMII
> >>>    mode, otherwise clear this bit.
> >>>
> >>> 2. Clear the mac_control register in am65_cpsw_nuss_mac_link_down()
> >>>    if in RMGII mode, otherwise preserve the state of
> >>>    CPSW_SL_CTL_EXT_EN but clear all other bits.
> >>>
> >>> 3. Set CPSW_SL_CTL_EXT_EN in am65_cpsw_nuss_mac_link_up() if in
> >>>    RGMII mode and 10Mbps.
> >>
> >> I plan to implement it as follows:
> >> 1. Add a member "u32 mode_config" to "struct am65_cpsw_slave_data" in
> >> "am65-cpsw-nuss.h".
> >> 2. In am65_cpsw_nuss_mac_config(), store the value of mac_control in
> >> "port->slave.mode_config".
> >> 3. In am65_cpsw_nuss_mac_link_down(), after the reset via
> >> cpsw_sl_ctl_reset(), execute:
> >> cpsw_sl_ctl_set(port->slave.mac_sl, port->slave.mode_config) in order to
> >> restore the configuration performed in am65_cpsw_nuss_mac_config().
> >>
> >> Please let me know in case of any suggestions to implement it in a
> >> better manner.
> > 
> > Do you think this complexity is really worth it?
> > 
> > Let's look at what's available:
> > 
> > cpsw_sl_ctl_set() - sets bits in the mac control register
> > cpsw_sl_ctl_clr() - clears bits in the mac control register
> > cpsw_sl_ctl_reset() - sets the mac control register to zero
> > 
> > So, in mac_config(), we can do:
> > 
> > 	if (interface == SGMII)
> > 		cpsw_sl_ctl_set(CPSW_SL_CTL_EXT_EN);
> > 	else
> > 		cpsw_sl_ctl_clr(CPSW_SL_CTL_EXT_EN);
> 
> While this will work for patch 1/3, once I add support for USXGMII mode
> as in patch 3/3, I believe that I have to invert it, beginning by
> invoking a cpsw_sl_ctl_clr(CPSW_SL_CTL_EXT_EN) at the start in
> mac_config() followed by switching through the modes. If the mode is
> SGMII, then I invoke cpsw_sl_ctl_set(CPSW_SL_CTL_EXT_EN), along with the
> write to the MR_ADV_ABILITY_REG register to advertise SGMII. If the mode
> is USXGMII, then I invoke:
> cpsw_sl_ctl_set(CPSW_SL_CTL_XGIG | CPSW_SL_CTL_XGMII_EN)

For patch 1, I did leave out the write for MR_ADV_ABILITY_REG, I had
assumed you'd get the idea on that and merge the if() condition you
already had with my suggestion above (which isn't literal code!)

In patch 3, you simply need to add:

	if (interface == USXGMII)
		cpsw_sl_ctl_set(CPSW_SL_CTL_XGIG | CPSW_SL_CTL_XGMII_EN);
	else
		cpsw_sl_ctl_clr(CPSW_SL_CTL_XGIG | CPSW_SL_CTL_XGMII_EN);

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

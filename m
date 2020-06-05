Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5443D1EFE8C
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 19:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbgFERK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 13:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbgFERKz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jun 2020 13:10:55 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 430EFC08C5C2;
        Fri,  5 Jun 2020 10:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=bFULnDIrcoo5vNAMnbXJrSEdqEqeynJptngL9eBaw6Q=; b=mgNuAmUwerwSjSW1bP6sifoPS
        oyVwlxDFU7+6K95DTJN/uwBCgVG6qcNHeOgU0MVAnOt2q4JbtLYZfrweVP3G/cqYVPqZhl4W5CNjN
        MJbvyHd2J4Nql52XeMpptQ1Q+13NExysoGAIKH08TLLVx6OhYbIet0IQZ+GLXOUHr/vV/7udIPsdW
        o5OdwuPmPbbxZm2flSEafet9dPMWGpM+vtWRxxT/KECZBkTHOS9SGFTw+q8GjqeGfstsqeVV5KVwj
        T9X+Gd/EDJEsZ6PVmiL58axOmosAqd9bJDfLU42hHldolIO3DWkVp2mqLn7n31Pwm/5v/M7JzwmyY
        jrApGxyYw==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:49774)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jhFrf-0002d2-8n; Fri, 05 Jun 2020 18:10:43 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jhFrW-0007dl-Ma; Fri, 05 Jun 2020 18:10:34 +0100
Date:   Fri, 5 Jun 2020 18:10:34 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     netdev@vger.kernel.org, Joao Pinto <Joao.Pinto@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 7/8] net: phy: Add Synopsys DesignWare XPCS MDIO
 module
Message-ID: <20200605171034.GF1605@shell.armlinux.org.uk>
References: <cover.1583742615.git.Jose.Abreu@synopsys.com>
 <7d9880643585e4347027538df2a722dde54156cf.1583742616.git.Jose.Abreu@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d9880643585e4347027538df2a722dde54156cf.1583742616.git.Jose.Abreu@synopsys.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jose,

I just tripped over a bug while grepping for something else and
reading a bit of this driver:

On Mon, Mar 09, 2020 at 09:36:26AM +0100, Jose Abreu wrote:
> +static int xpcs_read_lpa(struct mdio_xpcs_args *xpcs,
> +			 struct phylink_link_state *state)
> +{
> +	int ret;
> +
> +	ret = xpcs_read(xpcs, MDIO_MMD_AN, MDIO_STAT1);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (!(ret & MDIO_AN_STAT1_LPABLE)) {
> +		phylink_clear(state->lp_advertising, Autoneg);
> +		return 0;
> +	}
> +
> +	phylink_set(state->lp_advertising, Autoneg);
> +
> +	/* Clause 73 outcome */
> +	ret = xpcs_read(xpcs, MDIO_MMD_AN, DW_SR_AN_LP_ABL3);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (ret & DW_C73_2500KX)
> +		phylink_set(state->lp_advertising, 2500baseX_Full);
> +
> +	ret = xpcs_read(xpcs, MDIO_MMD_AN, DW_SR_AN_LP_ABL2);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (ret & DW_C73_1000KX)
> +		phylink_set(state->lp_advertising, 1000baseKX_Full);
> +	if (ret & DW_C73_10000KX4)
> +		phylink_set(state->lp_advertising, 10000baseKX4_Full);
> +	if (ret & DW_C73_10000KR)
> +		phylink_set(state->lp_advertising, 10000baseKR_Full);
> +
> +	ret = xpcs_read(xpcs, MDIO_MMD_AN, DW_SR_AN_LP_ABL1);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (ret & DW_C73_PAUSE)
> +		phylink_set(state->lp_advertising, Pause);
> +	if (ret & DW_C73_ASYM_PAUSE)
> +		phylink_set(state->lp_advertising, Asym_Pause);
> +
> +	linkmode_and(state->lp_advertising, state->lp_advertising,
> +		     state->advertising);

This is incorrect - you should not mask the link partner's advertisement
with our advertisement like this; consider the table in 802.3 for
resolving the pause modes, where simply doing a bitwise-and operation
between the two advertisements would severely restrict the resulting
resolution to either symmetric pause or nothing at all.

You want to do this when you resolve the speed, but only _temporarily_
in order to resolve the speed - you do not want to write back the
result to state->lp_advertising.

You may wish to fix that.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up

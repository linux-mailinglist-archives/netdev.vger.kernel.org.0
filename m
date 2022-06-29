Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8129156037C
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 16:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233581AbiF2Ooj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 10:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232039AbiF2Ooi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 10:44:38 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C89924967;
        Wed, 29 Jun 2022 07:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=AEQBYydBwT3iVN4z4kFDQZdStP+6c3zXJmeQHUsEWdw=; b=XEVclGnSPiDmLmyaGijJL9luEx
        nSzGs2czy+W7cE956DazxAWblRW9u1/VXWvTrZ+KtcFvJXpk1QBGzoS6VuMK3UmbxjY+sfFRSEqiZ
        c6fdYfLgXC4zciaZWd6uez0VwVOe9wHMwJoI4KPUKuar6g2FS6dFTCnksWl1CrgRl0mHl3hb5CK9/
        1qVfox3ZjWlMjwUmw6KXS+xbbVjuEabhsEGNJYXSupLxMD0+MuzSZceSiW56stHcxEjT5qNTRBkwb
        ltLGcbPf7L4jYsCg0Qjv4wp7N/T9vHPO1MdVsZFcSjr8pmDiFyYppXQlFYtA1i7p7q0cuI/CPYRLF
        RPUZs+FQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33100)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1o6Yvd-0003Hf-S6; Wed, 29 Jun 2022 15:44:29 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1o6Yvb-0005vm-IK; Wed, 29 Jun 2022 15:44:27 +0100
Date:   Wed, 29 Jun 2022 15:44:27 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 31/35] [RFT] net: dpaa: Convert to phylink
Message-ID: <YrxlS7wvgUtg9+y0@shell.armlinux.org.uk>
References: <20220628221404.1444200-1-sean.anderson@seco.com>
 <20220628221404.1444200-32-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220628221404.1444200-32-sean.anderson@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 28, 2022 at 06:14:00PM -0400, Sean Anderson wrote:
> +static void dtsec_mac_config(struct phylink_config *config, unsigned int mode,
> +			     const struct phylink_link_state *state)
> +{
> +	struct mac_device *mac_dev = fman_config_to_mac(config);
> +	struct dtsec_regs __iomem *regs = mac_dev->fman_mac->regs;
> +	u32 tmp;
> +
> +	switch (state->interface) {
> +	case PHY_INTERFACE_MODE_RMII:
> +		tmp = DTSEC_ECNTRL_RMM;
> +		break;
> +	case PHY_INTERFACE_MODE_RGMII:
> +	case PHY_INTERFACE_MODE_RGMII_ID:
> +	case PHY_INTERFACE_MODE_RGMII_RXID:
> +	case PHY_INTERFACE_MODE_RGMII_TXID:
> +		tmp = DTSEC_ECNTRL_GMIIM | DTSEC_ECNTRL_RPM;
> +		break;
> +	case PHY_INTERFACE_MODE_SGMII:
> +	case PHY_INTERFACE_MODE_1000BASEX:
> +	case PHY_INTERFACE_MODE_2500BASEX:
> +		tmp = DTSEC_ECNTRL_TBIM | DTSEC_ECNTRL_SGMIIM;
> +		break;
> +	default:
> +		dev_warn(mac_dev->dev, "cannot configure dTSEC for %s\n",
> +			 phy_modes(state->interface));
> +	}
> +
> +	if (state->speed == SPEED_100)
> +		tmp |= DTSEC_ECNTRL_R100M;

Please do not refer to state->speed here, it is meaningless. What are
you trying to achieve here?

It looks like the old dtsec_adjust_link() used to set/clear this when
the link comes up - so can it be moved to dtsec_link_up() ?

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

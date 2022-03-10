Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07D254D4D67
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 16:43:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344944AbiCJPLn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 10:11:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242134AbiCJPLP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 10:11:15 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F7B5198D1E;
        Thu, 10 Mar 2022 07:05:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=QfdtZq1vbEFd+SsfcmwQGyqdK7peHjCTLzwr0dWrhh0=; b=so1JYeLxXOytQVNOW3EA6eQDWU
        wv466XB22ahE1YIVTlm4s9q4jIFPWmVeoLIss9nLX86db8Fa0Wfc5DCkP04x5RaPcr+54IF3GfT/X
        6pH6V5I+Ea60fx38vwreCwaS1x2+QdwEYjoJBR01gkwOQQdfNK0wf8vVU/lzZSNdkN01uzcE1uIHx
        UUKo/h78QlmIWmi6/D5C62Juw5UgcHBONtBwp3fhbD1uVwCaynxqatszXHxL0Lr3uaxYd5jxAvxKQ
        QnSm7T+uD+NWPJnAeNY8XwvG03Qu64IYVZz5LLE3jVfM0NSdM7hK1TCMC5ENQCMlbCKeszF9/h68M
        kBN8NmTg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57770)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nSKMR-0001OZ-Di; Thu, 10 Mar 2022 15:05:51 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nSKMQ-0000ep-6g; Thu, 10 Mar 2022 15:05:50 +0000
Date:   Thu, 10 Mar 2022 15:05:50 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        kishon@ti.com, vkoul@kernel.org, robh+dt@kernel.org,
        leoyang.li@nxp.com, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, shawnguo@kernel.org,
        hongxing.zhu@nxp.com
Subject: Re: [PATCH net-next v3 7/8] dpaa2-mac: configure the SerDes phy on a
 protocol change
Message-ID: <YioTznpNwldCnJpm@shell.armlinux.org.uk>
References: <20220310145200.3645763-1-ioana.ciornei@nxp.com>
 <20220310145200.3645763-8-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220310145200.3645763-8-ioana.ciornei@nxp.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 10, 2022 at 04:51:59PM +0200, Ioana Ciornei wrote:
> This patch integrates the dpaa2-eth driver with the generic PHY
> infrastructure in order to search, find and reconfigure the SerDes lanes
> in case of a protocol change.
> 
> On the .mac_config() callback, the phy_set_mode_ext() API is called so
> that the Lynx 28G SerDes PHY driver can change the lane's configuration.
> In the same phylink callback the MC firmware is called so that it
> reconfigures the MAC side to run using the new protocol.
> 
> The consumer drivers - dpaa2-eth and dpaa2-switch - are updated to call
> the dpaa2_mac_start/stop functions newly added which will
> power_on/power_off the associated SerDes lane.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>

Looks better, there's a minor thing that I missed, sorry:

> +	if (mac->features & DPAA2_MAC_FEATURE_PROTOCOL_CHANGE &&
> +	    !phy_interface_mode_is_rgmii(mac->if_mode) &&
> +	    is_of_node(dpmac_node)) {
> +		serdes_phy = of_phy_get(to_of_node(dpmac_node), NULL);
> +
> +		if (IS_ERR(serdes_phy)) {
> +			if (PTR_ERR(serdes_phy) == -ENODEV)
> +				serdes_phy = NULL;
> +			else
> +				return PTR_ERR(serdes_phy);
> +		} else {
> +			phy_init(serdes_phy);
> +		}

Would:
		if (PTR_ERR(serdes_phy) == -ENODEV)
			serdes_phy = NULL;
		else if (IS_ERR(serdes_phy))
			return PTR_ERR(serdes_phy);
		else
			phy_init(serdes_phy);

be neater? There is no need to check IS_ERR() before testing PTR_ERR().
One may also prefer the pointer-comparison approach:

		if (serdes_phy == ERR_PTR(-ENODEV))

to remove any question about PTR_ERR(p) on a !IS_ERR(p) value too, but
it really doesn't make any difference.

I suspect this is just a code formatting issue, I'd think the compiler
would generate reasonable code either way, so as I said above, it's
quite minor.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

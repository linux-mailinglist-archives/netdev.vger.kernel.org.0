Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CC386CAC94
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 20:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232411AbjC0SCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 14:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232303AbjC0SCG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 14:02:06 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D4B1FD6
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 11:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=h97fZDA27920rVp40llDvrb3zlK00O8VRH1fRBhdt+8=; b=mOHfk0ATC0QbXwaTgMKtFUGmc2
        RQ45mDpXzKEtzYrkbglni9GMiUkgjb7eq3JYDwF3YbTtpESGzXj0eLopXrTdppgcdFCeykraJ5ufd
        lD8A6YpuGgEw1MSlxz/Nyk+89polYpIbxygJWVkTfxSZf7vNukCAm++e+OUpI1f2KA3xyNF9gaCJp
        UmpeoUBmttey5mUXpEQO1Np1Kafg+aYaBqJVcfULOBzQ5SqNa7L2vVV1UITA+FOrmmo6nNxrm86qB
        Ptchzv/mv/FLmhib3xRjaAI5QRhGPtGEEGPPR5M7kGycwwRryV7nXyP6YwE65yHRuCTl+59OFKviv
        CqH5yYrg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33080)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pgrAQ-0004Ph-BS; Mon, 27 Mar 2023 19:02:02 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pgrAP-0005dy-9B; Mon, 27 Mar 2023 19:02:01 +0100
Date:   Mon, 27 Mar 2023 19:02:01 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [RFC/RFT 05/23] net: phy: Immediately call adjust_link if only
 tx_lpi_enabled changes
Message-ID: <ZCHaGbhSWk5xLnAi@shell.armlinux.org.uk>
References: <20230327170201.2036708-1-andrew@lunn.ch>
 <20230327170201.2036708-6-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230327170201.2036708-6-andrew@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 27, 2023 at 07:01:43PM +0200, Andrew Lunn wrote:
> The MAC driver changes its EEE hardware configuration in its
> adjust_link callback. This is called when auto-neg completes. If
> set_eee is called with a change to tx_lpi_enabled which does not
> trigger an auto-neg, it is necessary to call the adjust_link callback
> so that the MAC is reconfigured to take this change into account.
> 
> When setting phydev->eee_active, take tx_lpi_enabled into account, so
> the MAC drivers don't need to consider tx_lpi_enabled.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Hmm..

> @@ -1619,11 +1619,20 @@ int phy_ethtool_set_eee(struct phy_device *phydev, struct ethtool_eee *data)
>  
>  	mutex_lock(&phydev->lock);
>  	ret = genphy_c45_ethtool_set_eee(phydev, data);
> -	if (!ret)
> +	if (ret >= 0) {
> +		if (ret == 0) {
> +			/* auto-neg not triggered */
> +			if (phydev->tx_lpi_enabled != data->tx_lpi_enabled) {
> +				phydev->tx_lpi_enabled = data->tx_lpi_enabled;
> +				if (phydev->link)
> +					phy_link_up(phydev);
> +			}
> +		}
>  		phydev->tx_lpi_enabled = data->tx_lpi_enabled;

So we set eee_active depending on tx_lpi_enabled:

> +			phydev->eee_active = (err & phydev->tx_lpi_enabled);

However, if tx_lpi_enabled changes state in this function, we don't
update phydev->eee_active, but it's phydev->eee_active that gets
passed back to MAC drivers. Is that intentional?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

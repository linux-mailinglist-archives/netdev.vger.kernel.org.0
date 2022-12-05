Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 759AD642E71
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 18:14:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbiLEROj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 12:14:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbiLEROi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 12:14:38 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC63D1B1C7
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 09:14:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=AeBG9pcLoWmzMKmuzmShCBWFUvTDOkt4Fc9Mfh2Z7G8=; b=gXcJUBnrG/hIU8qIBhl0bhQ3Wq
        EiUnp2NBYe/rIjQz27B8GykfSyhkl727YhSnzdAvBBzKcHFDVZCX34QEThCuxL7unAl62XyOSF/fq
        oUfMfT8KsLz8PGevd+M1kBVwVrvazqQySpwJLLGQbBrP/BRGfIn00OeGaxoQP7tpZ1tg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p2F35-004QYC-Eh; Mon, 05 Dec 2022 18:14:35 +0100
Date:   Mon, 5 Dec 2022 18:14:35 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mengyuan Lou <mengyuanlou@net-swift.com>
Cc:     netdev@vger.kernel.org, jiawenwu@trustnetic.com
Subject: Re: [PATCH net-next] net: ngbe: Add ngbe mdio bus driver.
Message-ID: <Y44m+7t6pdjGc5QI@lunn.ch>
References: <20221205103338.49595-1-mengyuanlou@net-swift.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221205103338.49595-1-mengyuanlou@net-swift.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static void ngbe_phy_fixup(struct ngbe_hw *hw)
> +{
> +	struct phy_device *phydev = hw->phydev;
> +	struct ethtool_eee eee;
> +
> +	if (hw->mac_type != ngbe_mac_type_mdi)
> +		return;
> +	/* disable EEE, EEE not supported by mac */
> +	memset(&eee, 0, sizeof(eee));
> +	phy_ethtool_set_eee(phydev, &eee);
> +
> +	linkmode_zero(phydev->supported);
> +	linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseT_Full_BIT,
> +			 phydev->supported);
> +	linkmode_set_bit(ETHTOOL_LINK_MODE_100baseT_Full_BIT,
> +			 phydev->supported);
> +	linkmode_set_bit(ETHTOOL_LINK_MODE_10baseT_Full_BIT,
> +			 phydev->supported);

As a side effect of linkmode_zero(phydev->supported) you also removed
any PAUSE capabilities of the PHY.

I assume the real issue here is that your MAC does not support half
duplex? So use:

phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_10baseT_Half_BIT);

etc.

There was a few comments i made on the previous version which have not
yet been addresses. Please fix them for the next version.

    Andrew

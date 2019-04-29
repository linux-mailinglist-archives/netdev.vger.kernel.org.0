Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB4FDEC4D
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 23:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729401AbfD2VxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 17:53:01 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49133 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729354AbfD2VxA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 17:53:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=HAmWT8PNT+hk3EDjJxkxVCBjh/Xucm6d68wN9S+QqPM=; b=n+nc2uDceKz5DV1oG0btamjqoZ
        V0BKxDcB1lllN62RZagp8n0n3jBlBGPZbPKe3v3+ALCQaVhKXYK/qLrdmvsuEbkG/DqV5cbMqBNtK
        aLsqvFmx/3hzO8+htqMM0wWMEjMVCmCr9SxuBgr8xuHvtQenJbJM65FoDFJkhi6U4sIs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hLECk-0006vX-84; Mon, 29 Apr 2019 23:52:54 +0200
Date:   Mon, 29 Apr 2019 23:52:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 2/2] net: phy: improve phy_set_sym_pause and
 phy_set_asym_pause
Message-ID: <20190429215254.GG12333@lunn.ch>
References: <5ac8d9b0-ac63-64d2-d5e1-e0911a35e534@gmail.com>
 <f5521d12-bc72-8ed7-eeda-888185c6cee6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5521d12-bc72-8ed7-eeda-888185c6cee6@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -2078,6 +2089,11 @@ EXPORT_SYMBOL(phy_set_sym_pause);
>  void phy_set_asym_pause(struct phy_device *phydev, bool rx, bool tx)
>  {
>  	__ETHTOOL_DECLARE_LINK_MODE_MASK(oldadv);
> +	bool asym_pause_supported;
> +
> +	asym_pause_supported =
> +		linkmode_test_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
> +				  phydev->supported);
>  
>  	linkmode_copy(oldadv, phydev->advertising);
>  
> @@ -2086,14 +2102,14 @@ void phy_set_asym_pause(struct phy_device *phydev, bool rx, bool tx)
>  	linkmode_clear_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
>  			   phydev->advertising);
>  
> -	if (rx) {
> +	if (rx && asym_pause_supported) {
>  		linkmode_set_bit(ETHTOOL_LINK_MODE_Pause_BIT,
>  				 phydev->advertising);
>  		linkmode_set_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
>  				 phydev->advertising);
>  	}
>  
> -	if (tx)
> +	if (tx && asym_pause_supported)
>  		linkmode_change_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
>  				    phydev->advertising);

Hi Heiner

If the PHY only supports Pause, not Asym Pause, i wounder if we should
fall back to Pause here?

     Andrew

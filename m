Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A47A8192A4B
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 14:43:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727601AbgCYNne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 09:43:34 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56740 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727383AbgCYNnd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 09:43:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=1/8mTWJrenAg7O/YlpnDgMgE1IImRPDkK2qH5LisLrQ=; b=3Xxdvt6/CQ+RcOocwfyz8+R8d1
        z82iZDmhcvBBUIoCVVaWs07AM+pg2nz2ctHbld02U7pSdvgvnBHWu7t5O1t3b6o4pN9sZ3uiwhngQ
        ESVcnLsMtqN1cvJirrm4oxe9XNEVX+t2mTS1qn0JtIPWTLXcr51Qd9a1oXh2NV9winTM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jH6Je-0004PP-C2; Wed, 25 Mar 2020 14:43:30 +0100
Date:   Wed, 25 Mar 2020 14:43:30 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, o.rempel@pengutronix.de,
        Florian Fainelli <f.fainelli@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jean Delvare <jdelvare@suse.com>
Subject: Re: [RFC][PATCH 1/2] ethtool: Add BroadRReach Master/Slave PHY
 tunable
Message-ID: <20200325134330.GD3819@lunn.ch>
References: <20200325101736.2100-1-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200325101736.2100-1-marex@denx.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 25, 2020 at 11:17:35AM +0100, Marek Vasut wrote:
> Add a PHY tunable to select BroadRReach PHY Master/Slave mode.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> Cc: Jean Delvare <jdelvare@suse.com>
> Cc: netdev@vger.kernel.org
> ---
>  include/uapi/linux/ethtool.h | 1 +
>  net/core/ethtool.c           | 2 ++
>  2 files changed, 3 insertions(+)
> 
> diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
> index dc69391d2bba..ebe658804ef1 100644
> --- a/include/uapi/linux/ethtool.h
> +++ b/include/uapi/linux/ethtool.h
> @@ -259,6 +259,7 @@ struct ethtool_tunable {
>  enum phy_tunable_id {
>  	ETHTOOL_PHY_ID_UNSPEC,
>  	ETHTOOL_PHY_DOWNSHIFT,
> +	ETHTOOL_PHY_BRR_MODE,
>  	/*
>  	 * Add your fresh new phy tunable attribute above and remember to update
>  	 * phy_tunable_strings[] in net/core/ethtool.c
> diff --git a/net/core/ethtool.c b/net/core/ethtool.c
> index 09d828a6a173..553f3d0e2624 100644
> --- a/net/core/ethtool.c
> +++ b/net/core/ethtool.c
> @@ -133,6 +133,7 @@ static const char
>  phy_tunable_strings[__ETHTOOL_PHY_TUNABLE_COUNT][ETH_GSTRING_LEN] = {
>  	[ETHTOOL_ID_UNSPEC]     = "Unspec",
>  	[ETHTOOL_PHY_DOWNSHIFT]	= "phy-downshift",
> +	[ETHTOOL_PHY_BRR_MODE]	= "phy-broadrreach-mode",
>  };

>  
>  static int ethtool_get_features(struct net_device *dev, void __user *useraddr)
> @@ -2524,6 +2525,7 @@ static int ethtool_phy_tunable_valid(const struct ethtool_tunable *tuna)
>  {
>  	switch (tuna->id) {
>  	case ETHTOOL_PHY_DOWNSHIFT:
> +	case ETHTOOL_PHY_BRR_MODE:
>  		if (tuna->len != sizeof(u8) ||
>  		    tuna->type_id != ETHTOOL_TUNABLE_U8)
>  			return -EINVAL;

Hi Marek

As far as i understand, there are only two settings. Master and
Slave. So you can make the validation here more specific.

I would also add some #defines for this in
include/uapi/linux/ethtool.h so it is clear what value represents
master and what is slave.

       Andrew

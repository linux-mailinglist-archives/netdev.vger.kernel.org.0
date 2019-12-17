Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9614112278E
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 10:27:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbfLQJWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 04:22:01 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:56918 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726612AbfLQJWB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 04:22:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=0N6OgC5TJ93TNSuGfw9kW7Fv7ytnBT72iBp/cTrj13c=; b=gcEbzvRrdg/n1QmXUXRRYBgdkw
        GIqcH4B1App1szgKFbOc+2g1sVDDHLgEQ4Ys37jE29mewf4nk/DGRnH+CA5ANBunuV9nCwaWGV93z
        lUZCYFY3H6YZVIki9mgMK06L/KecTBdErKs1GwvZkXIdnXNPQ/1/CcLwt3i7evKQ328g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ih93D-0004cn-TU; Tue, 17 Dec 2019 10:21:55 +0100
Date:   Tue, 17 Dec 2019 10:21:55 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        devicetree@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Wingman Kwok <w-kwok2@ti.com>
Subject: Re: [PATCH V6 net-next 06/11] net: Introduce a new MII time stamping
 interface.
Message-ID: <20191217092155.GL6994@lunn.ch>
References: <cover.1576511937.git.richardcochran@gmail.com>
 <28939f11b984759257167e778d0c73c0dd206a35.1576511937.git.richardcochran@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28939f11b984759257167e778d0c73c0dd206a35.1576511937.git.richardcochran@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int dp83640_hwtstamp(struct mii_timestamper *mii_ts,
> +			    struct ifreq *ifr);
> +static int dp83640_ts_info(struct mii_timestamper *mii_ts,
> +			   struct ethtool_ts_info *info);
> +static bool dp83640_rxtstamp(struct mii_timestamper *mii_ts,
> +			     struct sk_buff *skb, int type);
> +static void dp83640_txtstamp(struct mii_timestamper *mii_ts,
> +			     struct sk_buff *skb, int type);
>  static void rx_timestamp_work(struct work_struct *work);

Hi Richard

Forward declarations are considered bad. Please add a new patch to the
series which moves code around first. You can probably move
dp83640_probe() further down.

> -static bool dp83640_rxtstamp(struct phy_device *phydev,
> +static bool dp83640_rxtstamp(struct mii_timestamper *mii_ts,
>  			     struct sk_buff *skb, int type)
>  {
> -	struct dp83640_private *dp83640 = phydev->priv;
> +	struct dp83640_private *dp83640 =
> +		container_of(mii_ts, struct dp83640_private, mii_ts);
>  	struct dp83640_skb_info *skb_info = (struct dp83640_skb_info *)skb->cb;
>  	struct list_head *this, *next;
>  	struct rxts *rxts;

David will probably complain about reverse christmas tree. Having to
fold dp83640_private is unfortunate here. Maybe consider adding a
macro for the container_of() so you can avoid the fold?

> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 0887ed2bb050..ee45838f90c9 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -919,6 +919,8 @@ static void phy_link_change(struct phy_device *phydev, bool up, bool do_carrier)
>  			netif_carrier_off(netdev);
>  	}
>  	phydev->adjust_link(netdev);
> +	if (phydev->mii_ts && phydev->mii_ts->link_state)
> +		phydev->mii_ts->link_state(phydev->mii_ts, phydev);
>  }

FYI:

When using phylink, not phylib, this call will not happen. You need to
add a similar bit of code in phylink_mac_config().

For the moment what you have is sufficient. I doubt anybody is using
the dp83640 with phylink, and the new hardware you are targeting seems
to be RGMII based, not SERDES, which is the main use case for PHYLINK.

   Andrew

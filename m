Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 306F6A92C1
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 22:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729656AbfIDUDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 16:03:54 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55190 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727809AbfIDUDy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 16:03:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=pV5Ja3nFmAXwbG0fo3pmv+berWnrf8+j3llPuWmXntY=; b=NdOKKqXL7uBDfZi9YtAuBOOTqZ
        UmpwjXExDZeH140ZmCh3N1X7qI80oF3ksiqJeu0CIJEuRSNzT/HT1cd1j37vuZBMDl/wW3mCU7Vhc
        C8W13+lU4Rupr4MMrzOxPL+7mNVqU50Wkj7A4YcPl/aJeEUjXHKDTSG0Ljcio/0NB3tI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i5bVO-0005tl-QP; Wed, 04 Sep 2019 22:03:50 +0200
Date:   Wed, 4 Sep 2019 22:03:50 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        f.fainelli@gmail.com, hkallweit1@gmail.com, davem@davemloft.net
Subject: Re: [PATCH v2 2/2] net: phy: adin: implement Energy Detect Powerdown
 mode via phy-tunable
Message-ID: <20190904200350.GB21264@lunn.ch>
References: <20190904162322.17542-1-alexandru.ardelean@analog.com>
 <20190904162322.17542-3-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190904162322.17542-3-alexandru.ardelean@analog.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 04, 2019 at 07:23:22PM +0300, Alexandru Ardelean wrote:
> This driver becomes the first user of the kernel's `ETHTOOL_PHY_EDPD`
> phy-tunable feature.
> EDPD is also enabled by default on PHY config_init, but can be disabled via
> the phy-tunable control.
> 
> When enabling EDPD, it's also a good idea (for the ADIN PHYs) to enable TX
> periodic pulses, so that in case the other PHY is also on EDPD mode, there
> is no lock-up situation where both sides are waiting for the other to
> transmit.
> 
> Via the phy-tunable control, TX pulses can be disabled if specifying 0
> `tx-interval` via ethtool.
> 
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
> ---
>  drivers/net/phy/adin.c | 50 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 50 insertions(+)
> 
> diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
> index 4dec83df048d..742728ab2a5d 100644
> --- a/drivers/net/phy/adin.c
> +++ b/drivers/net/phy/adin.c
> @@ -26,6 +26,11 @@
>  
>  #define ADIN1300_RX_ERR_CNT			0x0014
>  
> +#define ADIN1300_PHY_CTRL_STATUS2		0x0015
> +#define   ADIN1300_NRG_PD_EN			BIT(3)
> +#define   ADIN1300_NRG_PD_TX_EN			BIT(2)
> +#define   ADIN1300_NRG_PD_STATUS		BIT(1)
> +
>  #define ADIN1300_PHY_CTRL2			0x0016
>  #define   ADIN1300_DOWNSPEED_AN_100_EN		BIT(11)
>  #define   ADIN1300_DOWNSPEED_AN_10_EN		BIT(10)
> @@ -328,12 +333,51 @@ static int adin_set_downshift(struct phy_device *phydev, u8 cnt)
>  			    ADIN1300_DOWNSPEEDS_EN);
>  }
>  
> +static int adin_get_edpd(struct phy_device *phydev, u16 *tx_interval)
> +{
> +	int val;
> +
> +	val = phy_read(phydev, ADIN1300_PHY_CTRL_STATUS2);
> +	if (val < 0)
> +		return val;
> +
> +	if (ADIN1300_NRG_PD_EN & val) {
> +		if (val & ADIN1300_NRG_PD_TX_EN)
> +			*tx_interval = 1;

What does 1 mean? 1 pico second, one hour? Anything but zero seconds?
Does the datasheet specify what it actually does? Maybe you should be
using ETHTOOL_PHY_EDPD_DFLT_TX_INTERVAL here, to indicate you actually
have no idea, but it is the default for this PHY?

> +		else
> +			*tx_interval = ETHTOOL_PHY_EDPD_NO_TX;
> +	} else {
> +		*tx_interval = ETHTOOL_PHY_EDPD_DISABLE;
> +	}
> +
> +	return 0;
> +}
> +
> +static int adin_set_edpd(struct phy_device *phydev, u16 tx_interval)
> +{
> +	u16 val;
> +
> +	if (tx_interval == ETHTOOL_PHY_EDPD_DISABLE)
> +		return phy_clear_bits(phydev, ADIN1300_PHY_CTRL_STATUS2,
> +				(ADIN1300_NRG_PD_EN | ADIN1300_NRG_PD_TX_EN));
> +
> +	val = ADIN1300_NRG_PD_EN;
> +	if (tx_interval != ETHTOOL_PHY_EDPD_NO_TX)
> +		val |= ADIN1300_NRG_PD_TX_EN;

So you silently accept any interval? That sounds wrong. You really
should be returning -EINVAL for any value other than, either 1, or
maybe ETHTOOL_PHY_EDPD_DFLT_TX_INTERVAL, if you change the get
function.

      Andrew

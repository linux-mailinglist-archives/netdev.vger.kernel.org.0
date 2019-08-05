Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F41E781EEC
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 16:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729152AbfHEOV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 10:21:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34218 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728847AbfHEOV0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Aug 2019 10:21:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=O5VyocbyU6DrRR444C2YjE/xHFOrsZbnTvO3pdL/im8=; b=uyq3RYFNbTTE7d/kBLeW4FBaJd
        lvHc8AAYMzUoaTQVm1m/e9aHI0HpMBrkriyLG9xSc/Ur8bsV2KFucw2ybXhMpXPhcqc0sv6Ltx4as
        f5Yw24IFVNMkfh8RkHWvQvDc5TFdl97TnfeDC2m4E7g5LKP1qLkY5w/CrG0OC7SrcJyc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hudrX-0007RC-2R; Mon, 05 Aug 2019 16:21:23 +0200
Date:   Mon, 5 Aug 2019 16:21:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        robh+dt@kernel.org, mark.rutland@arm.com, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Subject: Re: [PATCH 03/16] net: phy: adin: add support for interrupts
Message-ID: <20190805142123.GJ24275@lunn.ch>
References: <20190805165453.3989-1-alexandru.ardelean@analog.com>
 <20190805165453.3989-4-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190805165453.3989-4-alexandru.ardelean@analog.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 05, 2019 at 07:54:40PM +0300, Alexandru Ardelean wrote:
> This change adds support for enabling PHY interrupts that can be used by
> the PHY framework to get signal for link/speed/auto-negotiation changes.
> 
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
> ---
>  drivers/net/phy/adin.c | 44 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 44 insertions(+)
> 
> diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
> index c100a0dd95cd..b75c723bda79 100644
> --- a/drivers/net/phy/adin.c
> +++ b/drivers/net/phy/adin.c
> @@ -14,6 +14,22 @@
>  #define PHY_ID_ADIN1200				0x0283bc20
>  #define PHY_ID_ADIN1300				0x0283bc30
>  
> +#define ADIN1300_INT_MASK_REG			0x0018
> +#define   ADIN1300_INT_MDIO_SYNC_EN		BIT(9)
> +#define   ADIN1300_INT_ANEG_STAT_CHNG_EN	BIT(8)
> +#define   ADIN1300_INT_ANEG_PAGE_RX_EN		BIT(6)
> +#define   ADIN1300_INT_IDLE_ERR_CNT_EN		BIT(5)
> +#define   ADIN1300_INT_MAC_FIFO_OU_EN		BIT(4)
> +#define   ADIN1300_INT_RX_STAT_CHNG_EN		BIT(3)
> +#define   ADIN1300_INT_LINK_STAT_CHNG_EN	BIT(2)
> +#define   ADIN1300_INT_SPEED_CHNG_EN		BIT(1)
> +#define   ADIN1300_INT_HW_IRQ_EN		BIT(0)
> +#define ADIN1300_INT_MASK_EN	\
> +	(ADIN1300_INT_ANEG_STAT_CHNG_EN | ADIN1300_INT_ANEG_PAGE_RX_EN | \
> +	 ADIN1300_INT_LINK_STAT_CHNG_EN | ADIN1300_INT_SPEED_CHNG_EN | \
> +	 ADIN1300_INT_HW_IRQ_EN)
> +#define ADIN1300_INT_STATUS_REG			0x0019
> +
>  static int adin_config_init(struct phy_device *phydev)
>  {
>  	int rc;
> @@ -25,15 +41,40 @@ static int adin_config_init(struct phy_device *phydev)
>  	return 0;
>  }
>  
> +static int adin_phy_ack_intr(struct phy_device *phydev)
> +{
> +	int ret;
> +
> +	/* Clear pending interrupts.  */
> +	ret = phy_read(phydev, ADIN1300_INT_STATUS_REG);
> +	if (ret < 0)
> +		return ret;
> +
> +	return 0;

Please go through the whole driver and throw out all the needless

	if (ret < 0)
		return ret;

	return 0;

Thanks
	Andrew

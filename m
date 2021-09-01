Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7D4B3FDC0E
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 15:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344454AbhIAMqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 08:46:35 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52190 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345564AbhIAMol (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Sep 2021 08:44:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=lzlOoGsZaqKGx4/IQjVmCXaKxUFWkuXvxDWMiiTurK4=; b=10gJlTCwTYoW9kEia1KCmOzJW+
        fRO8TgbSpSeq3z3Wi1fiTVfloa4qemd+PwrwgOBrw+ARigvGdISlJO0j/8CJvUnQX+cQgXQ7xWoAD
        fMrBOVN4q4hLUa7tZbIaE0hgJ7pL/UiHCTAM5xxQzi4wE74i4Hn64KyNGVTDvuWbKVtM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mLPaQ-004rc8-EO; Wed, 01 Sep 2021 14:43:26 +0200
Date:   Wed, 1 Sep 2021 14:43:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Qiang Ma <maqianga@uniontech.com>
Cc:     f.fainelli@gmail.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ming Wang <wangming01@loongson.cn>
Subject: Re: [PATCH] net: phy: fix autoneg invalid error state of GBSR
 register.
Message-ID: <YS91biZov3jE+Lrd@lunn.ch>
References: <20210901105608.29776-1-maqianga@uniontech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210901105608.29776-1-maqianga@uniontech.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 01, 2021 at 06:56:08PM +0800, Qiang Ma wrote:
> When the PHY is not link and working in polling mode, PHY state
> machine will periodically read GBSR register. Normally, the GBSR
> register value is 0. But as the log show, in very small cases the
> value is 0x8640. The value 0x8640 means Master/Slave resolution
> failed. The PHY state machine will enter PHY_HALTED state and the
> PHY will never be able to link.
> 
> [49176.903012] [debug]: lpagb:0x0 adv:0x300
> [49177.927025] [debug]: lpagb:0x8640 adv:0x300
> [49177.927034] Generic PHY stmmac-18:00: Master/Slave resolution failed
> [49177.927241] [debug]: lpagb:0x0 adv:0x300
> 
> According to the RTL8211E PHY chip datasheet, the contents of GBSR register
> are valid only when auto negotiation is completed(BMSR[5]: Auto-
> Negotiation Complete = 1). This patch adds the condition before
> reading GBSR register to fix this error state.
> 
> Signed-off-by: Ming Wang <wangming01@loongson.cn>
> Signed-off-by: Qiang Ma <maqianga@uniontech.com>
> ---
>  drivers/net/phy/phy_device.c | 10 ++++------
>  include/linux/phy.h          |  1 +
>  2 files changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index b884b681d5c5..b77ed5ec31c6 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -1532,10 +1532,8 @@ int genphy_update_link(struct phy_device *phydev)
>  	if (status < 0)
>  		return status;
>  
> -	if ((status & BMSR_LSTATUS) == 0)
> -		phydev->link = 0;
> -	else
> -		phydev->link = 1;
> +	phydev->link = status & BMSR_LSTATUS ? 1 : 0;
> +	phydev->autoneg_complete = status & BMSR_ANEGCOMPLETE ? 1 : 0;
>  
>  	return 0;
>  }

What tree is this against? Both net-next/master and net/master have:

        if (status < 0)
                return status;
done:
        phydev->link = status & BMSR_LSTATUS ? 1 : 0;
        phydev->autoneg_complete = status & BMSR_ANEGCOMPLETE ? 1 : 0;

        /* Consider the case that autoneg was started and "aneg complete"
         * bit has been reset, but "link up" bit not yet.
         */
        if (phydev->autoneg == AUTONEG_ENABLE && !phydev->autoneg_complete)
                phydev->link = 0;

        return 0;
}

It looks like you are using an old tree.

	Andrew

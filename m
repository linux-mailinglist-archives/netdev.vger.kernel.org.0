Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94598432939
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 23:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231234AbhJRVq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 17:46:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45328 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229524AbhJRVq1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 17:46:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=bkD2nLFxGvs8hX4pCzljKD2HfV6Z7HGJWd3D/XXQjuA=; b=eTB67c4hOEI27KR/gG9qXjXBKx
        TCWnoj02T4P7AteiO77SnStii/PkDwnb5CtUn3yubgqasaPMsvVYw3DdAlqwojqbZAgpL6vvIjb4x
        hcsiip57A9yJyce0W2YCyv+PQn9xyvLkDlPoqy0E8HSTvEB+S7QJ6NhnRSn3lpsbm7p0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mcaQW-00B0q5-Gk; Mon, 18 Oct 2021 23:44:12 +0200
Date:   Mon, 18 Oct 2021 23:44:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luo Jie <luoj@codeaurora.org>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sricharan@codeaurora.org
Subject: Re: [PATCH v3 07/13] net: phy: add qca8081 get_features
Message-ID: <YW3qrFRzvPlFrms0@lunn.ch>
References: <20211018033333.17677-1-luoj@codeaurora.org>
 <20211018033333.17677-8-luoj@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211018033333.17677-8-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 18, 2021 at 11:33:27AM +0800, Luo Jie wrote:
> Reuse the at803x phy driver get_features excepting
> adding 2500M capability.
> 
> Signed-off-by: Luo Jie <luoj@codeaurora.org>
> ---
>  drivers/net/phy/at803x.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
> index 42d3f8ccca94..0c22ef735230 100644
> --- a/drivers/net/phy/at803x.c
> +++ b/drivers/net/phy/at803x.c
> @@ -719,6 +719,15 @@ static int at803x_get_features(struct phy_device *phydev)
>  	if (err)
>  		return err;
>  
> +	if (phydev->drv->phy_id == QCA8081_PHY_ID) {
> +		err = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_NG_EXTABLE);
> +		if (err < 0)
> +			return err;
> +
> +		linkmode_mod_bit(ETHTOOL_LINK_MODE_2500baseT_Full_BIT, phydev->supported,
> +				err & MDIO_PMA_NG_EXTABLE_2_5GBT);
> +	}

genphy_c45_pma_read_abilities()?

	Andrew

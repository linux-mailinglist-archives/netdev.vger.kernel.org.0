Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5142A1C19B5
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 17:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729557AbgEAPhc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 11:37:32 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36520 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728865AbgEAPhc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 May 2020 11:37:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=CCW9t2Lcf3ESlVkJ4RGqmi6BmFZgD63tWCVuekoIumU=; b=TtzgkSzrEtfblR+H1wVwLbiwig
        C8qarQ6oBZtfxDOULpsjFye+/KFqIcIkpqUOeMILNA//s3bR50E1daGGhbT5ptwh1DDApdNwbcOo5
        sBLN/MpQUJSTzfYQgIEc4qimo/sF9UbZcCWJ9oL3Pg0y09HfCU4f0DqqOiHsHPtyZEJU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jUXjB-000YJL-8M; Fri, 01 May 2020 17:37:25 +0200
Date:   Fri, 1 May 2020 17:37:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     robh+dt@kernel.org, f.fainelli@gmail.com,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
        jianxin.pan@amlogic.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RFC v2 07/11] net: stmmac: dwmac-meson8b: Make the clock
 enabling code re-usable
Message-ID: <20200501153725.GG128733@lunn.ch>
References: <20200429201644.1144546-1-martin.blumenstingl@googlemail.com>
 <20200429201644.1144546-8-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429201644.1144546-8-martin.blumenstingl@googlemail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 29, 2020 at 10:16:40PM +0200, Martin Blumenstingl wrote:
> The timing adjustment clock will need similar logic as the RGMII clock:
> It has to be enabled in the driver conditionally and when the driver is
> unloaded it should be disabled again. Extract the existing code for the
> RGMII clock into a new function so it can be re-used.
> 
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---
>  .../ethernet/stmicro/stmmac/dwmac-meson8b.c   | 23 +++++++++++++++----
>  1 file changed, 18 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
> index 41f3ef6bea66..d31f79c455de 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
> @@ -266,6 +266,22 @@ static int meson_axg_set_phy_mode(struct meson8b_dwmac *dwmac)
>  	return 0;
>  }
>  
> +static int meson8b_devm_clk_prepare_enable(struct meson8b_dwmac *dwmac,
> +					   struct clk *clk)
> +{
> +	int ret;
> +
> +	ret = clk_prepare_enable(clk);
> +	if (ret)
> +		return ret;
> +
> +	devm_add_action_or_reset(dwmac->dev,
> +				 (void(*)(void *))clk_disable_unprepare,
> +				 dwmac->rgmii_tx_clk);
> +
> +	return 0;
> +}

I'm surprised this does not exist in the core. It looks like there was
some discussion about this, but nothing merged.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

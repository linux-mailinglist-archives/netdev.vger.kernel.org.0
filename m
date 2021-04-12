Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D16635D3FF
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 01:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238926AbhDLXcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 19:32:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:54960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237567AbhDLXce (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 19:32:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21D656124B;
        Mon, 12 Apr 2021 23:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618270335;
        bh=0uMrbYXhVghS1XGwvYu8bCNVYs47UOJSfwhcnACCotA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FyzShQ8quSs3ANtgUnfm/YgGWz7koWMgXPaP5OS5O4uVYXA8zhbachkAI/uoEULej
         hN/ilGJPrW3OA5kBYnCFoiDxz1RxWrIA9khAJu/MlGeE/qq6wacSXqb1zRv/sgLFrZ
         BvXsTQjPwyylrrhPE1om0XOs+5+rws/aEJVB3kHL5OwnwuId9H918ni3n0JViZ1bB2
         FCXBNEk7Kjo74Ek9Yvwfb4Nji4t/ieXp4KZsnY3qlC6JKXrp4Nxt3lT1kwKy05YRNX
         vyxfnMIyAjsVulrsjrzhvu3TG8GzGtihONlsX09voZu+M90HlyujfIVxJsfs6x97sc
         EHC7dCRBniBpA==
Date:   Tue, 13 Apr 2021 01:32:12 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Ivan Bornyakov <i.bornyakov@metrotek.ru>
Cc:     system@metrotek.ru, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: phy: marvell-88x2222: check that link
 is operational
Message-ID: <20210413013122.7fa0195f@thinkpad>
In-Reply-To: <614b534f1661ecf1fff419e2f36eddfb0e6f066d.1618227910.git.i.bornyakov@metrotek.ru>
References: <cover.1618227910.git.i.bornyakov@metrotek.ru>
        <614b534f1661ecf1fff419e2f36eddfb0e6f066d.1618227910.git.i.bornyakov@metrotek.ru>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Apr 2021 15:16:59 +0300
Ivan Bornyakov <i.bornyakov@metrotek.ru> wrote:

> Some SFP modules uses RX_LOS for link indication. In such cases link
> will be always up, even without cable connected. RX_LOS changes will
> trigger link_up()/link_down() upstream operations. Thus, check that SFP
> link is operational before actual read link status.
> 
> Signed-off-by: Ivan Bornyakov <i.bornyakov@metrotek.ru>
> ---
>  drivers/net/phy/marvell-88x2222.c | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/drivers/net/phy/marvell-88x2222.c b/drivers/net/phy/marvell-88x2222.c
> index eca8c2f20684..fb285ac741b2 100644
> --- a/drivers/net/phy/marvell-88x2222.c
> +++ b/drivers/net/phy/marvell-88x2222.c
> @@ -51,6 +51,7 @@
>  struct mv2222_data {
>  	phy_interface_t line_interface;
>  	__ETHTOOL_DECLARE_LINK_MODE_MASK(supported);
> +	bool sfp_link;
>  };
>  
>  /* SFI PMA transmit enable */
> @@ -148,6 +149,9 @@ static int mv2222_read_status(struct phy_device *phydev)
>  	phydev->speed = SPEED_UNKNOWN;
>  	phydev->duplex = DUPLEX_UNKNOWN;
>  
> +	if (!priv->sfp_link)
> +		return 0;
> +

So if SFP is not used at all, if this PHY is used in a different
usecase, this function will always return 0? Is this correct?

>  	if (priv->line_interface == PHY_INTERFACE_MODE_10GBASER)
>  		link = mv2222_read_status_10g(phydev);
>  	else
> @@ -446,9 +450,31 @@ static void mv2222_sfp_remove(void *upstream)
>  	linkmode_zero(priv->supported);
>  }
>  
> +static void mv2222_sfp_link_up(void *upstream)
> +{
> +	struct phy_device *phydev = upstream;
> +	struct mv2222_data *priv;
> +
> +	priv = (struct mv2222_data *)phydev->priv;
> +
> +	priv->sfp_link = true;
> +}
> +
> +static void mv2222_sfp_link_down(void *upstream)
> +{
> +	struct phy_device *phydev = upstream;
> +	struct mv2222_data *priv;
> +
> +	priv = (struct mv2222_data *)phydev->priv;

This cast is redundant since the phydev->priv is (void*). You can cast
(void*) to (struct ... *).

You can also just use
	struct mv2222_data *priv = phydev->priv;

> +
> +	priv->sfp_link = false;
> +}
> +
>  static const struct sfp_upstream_ops sfp_phy_ops = {
>  	.module_insert = mv2222_sfp_insert,
>  	.module_remove = mv2222_sfp_remove,
> +	.link_up = mv2222_sfp_link_up,
> +	.link_down = mv2222_sfp_link_down,
>  	.attach = phy_sfp_attach,
>  	.detach = phy_sfp_detach,
>  };


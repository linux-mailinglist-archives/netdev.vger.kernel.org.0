Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3BEA6429AF
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 14:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbiLENmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 08:42:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232055AbiLENmb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 08:42:31 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A53D2F2;
        Mon,  5 Dec 2022 05:42:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=wV7UwztxOnwBjLx4UlGsMD6gs4ljlBwmQRIlqbtKjYc=; b=xK2390t2TA9x1AxvFAR+QX6cz6
        HfVFNFtcUxYHfz1NNfwyDI4FZiGoL+gu8nx/QuZr3MXI+sMnY8c86crDAa6u4aGmPEuQWWsb78ScK
        R6wWm4/3NkQpNprw0Awkpyize8fwiZvXwRcMWQpQgGU5CEtaAuYCgave33hmTYqmrkZ4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p2Bjh-004POS-4P; Mon, 05 Dec 2022 14:42:21 +0100
Date:   Mon, 5 Dec 2022 14:42:21 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Divya Koppera <Divya.Koppera@microchip.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        richardcochran@gmail.com, UNGLinuxDriver@microchip.com,
        Madhuri.Sripada@microchip.com
Subject: Re: [PATCH v4 net-next 2/2] net: phy: micrel: Fix warn: passing zero
 to PTR_ERR
Message-ID: <Y431PXknftwxwX3f@lunn.ch>
References: <20221205103550.24944-1-Divya.Koppera@microchip.com>
 <20221205103550.24944-3-Divya.Koppera@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221205103550.24944-3-Divya.Koppera@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 05, 2022 at 04:05:50PM +0530, Divya Koppera wrote:
> Handle the NULL pointer case
> 
> Fixes New smatch warnings:
> drivers/net/phy/micrel.c:2613 lan8814_ptp_probe_once() warn: passing zero to 'PTR_ERR'
> 
> vim +/PTR_ERR +2613 drivers/net/phy/micrel.c
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Fixes: ece19502834d ("net: phy: micrel: 1588 support for LAN8814 phy")
> Signed-off-by: Divya Koppera <Divya.Koppera@microchip.com>
> ---
> v3 -> v4:
> - Split the patch for different warnings
> - Renamed variable from shared_priv to shared.
> 
> v2 -> v3:
> - Changed subject line from net to net-next
> - Removed config check for ptp and clock configuration
>   instead added null check for ptp_clock
> - Fixed one more warning related to initialisaton.
> 
> v1 -> v2:
> - Handled NULL pointer case
> - Changed subject line with net-next to net
> ---
>  drivers/net/phy/micrel.c | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
> index 1bcdb828db56..0399f3830700 100644
> --- a/drivers/net/phy/micrel.c
> +++ b/drivers/net/phy/micrel.c
> @@ -2971,12 +2971,13 @@ static int lan8814_config_intr(struct phy_device *phydev)
>  
>  static void lan8814_ptp_init(struct phy_device *phydev)
>  {
> +	struct lan8814_shared_priv *shared = phydev->shared->priv;
>  	struct kszphy_priv *priv = phydev->priv;
>  	struct kszphy_ptp_priv *ptp_priv = &priv->ptp_priv;
>  	u32 temp;
>  
> -	if (!IS_ENABLED(CONFIG_PTP_1588_CLOCK) ||
> -	    !IS_ENABLED(CONFIG_NETWORK_PHY_TIMESTAMPING))
> +	/* Check if PHC support is missing at the configuration level */
> +	if (!shared->ptp_clock)
>  		return;

Can you somehow keep the IS_ENABLED() ? It gets evaluated at compile
time. The optimizer can see the function will always return here, and
all the code that follows is pointless, and so remove it. By turning
this into a runtime test, you have made the image bigger.

     Andrew

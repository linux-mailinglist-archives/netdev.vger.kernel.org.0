Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6F8D34E6FE
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 14:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231622AbhC3MBz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 30 Mar 2021 08:01:55 -0400
Received: from unicorn.mansr.com ([81.2.72.234]:37010 "EHLO unicorn.mansr.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231701AbhC3MBf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 08:01:35 -0400
Received: from raven.mansr.com (raven.mansr.com [IPv6:2001:8b0:ca0d:8d8e::3])
        by unicorn.mansr.com (Postfix) with ESMTPS id 27B6715360;
        Tue, 30 Mar 2021 13:01:33 +0100 (BST)
Received: by raven.mansr.com (Postfix, from userid 51770)
        id 1AD4D21A3D2; Tue, 30 Mar 2021 13:01:33 +0100 (BST)
From:   =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To:     Andre Edich <andre.edich@microchip.com>
Cc:     <netdev@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <Parthiban.Veerasooran@microchip.com>
Subject: Re: [PATCH net-next] net: phy: lan87xx: fix access to wrong
 register of LAN87xx
References: <20210329094536.3118619-1-andre.edich@microchip.com>
Date:   Tue, 30 Mar 2021 13:01:33 +0100
In-Reply-To: <20210329094536.3118619-1-andre.edich@microchip.com> (Andre
        Edich's message of "Mon, 29 Mar 2021 11:45:36 +0200")
Message-ID: <yw1x35wcg89u.fsf@mansr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andre Edich <andre.edich@microchip.com> writes:

> The function lan87xx_config_aneg_ext was introduced to configure
> LAN95xxA but as well writes to undocumented register of LAN87xx.
> This fix prevents that access.
>
> The function lan87xx_config_aneg_ext gets more suitable for the new
> behavior name.
>
> Reported-by: Måns Rullgård <mans@mansr.com>
> Fixes: 05b35e7eb9a1 ("smsc95xx: add phylib support")
> Signed-off-by: Andre Edich <andre.edich@microchip.com>
> ---
>  drivers/net/phy/smsc.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)

I can confirm that this fixes the problem I was seeing.

> diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
> index ddb78fb4d6dc..d8cac02a79b9 100644
> --- a/drivers/net/phy/smsc.c
> +++ b/drivers/net/phy/smsc.c
> @@ -185,10 +185,13 @@ static int lan87xx_config_aneg(struct phy_device *phydev)
>  	return genphy_config_aneg(phydev);
>  }
>
> -static int lan87xx_config_aneg_ext(struct phy_device *phydev)
> +static int lan95xx_config_aneg_ext(struct phy_device *phydev)
>  {
>  	int rc;
>
> +	if (phydev->phy_id != 0x0007c0f0) /* not (LAN9500A or LAN9505A) */
> +		return lan87xx_config_aneg(phydev);
> +
>  	/* Extend Manual AutoMDIX timer */
>  	rc = phy_read(phydev, PHY_EDPD_CONFIG);
>  	if (rc < 0)
> @@ -441,7 +444,7 @@ static struct phy_driver smsc_phy_driver[] = {
>  	.read_status	= lan87xx_read_status,
>  	.config_init	= smsc_phy_config_init,
>  	.soft_reset	= smsc_phy_reset,
> -	.config_aneg	= lan87xx_config_aneg_ext,
> +	.config_aneg	= lan95xx_config_aneg_ext,
>
>  	/* IRQ related */
>  	.config_intr	= smsc_phy_config_intr,
> -- 
>
> 2.28.0
>

-- 
Måns Rullgård

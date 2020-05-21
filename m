Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13F381DD108
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 17:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728228AbgEUPTU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 11:19:20 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43080 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727898AbgEUPTU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 11:19:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=d4prlpe44iogc1YJ0dGlOCAaKDbp1fDXGQHsv13/mEA=; b=4mbZlUQ6qe7SgCuyqRbgqLgcmF
        MXZwmtOmPpn2Uk8jvHlBUDdbA1LUXY3M18m/jTKL8xTdPXX/KGDzPUWyx1JtGNlhfKEz0W2Fl3Euw
        Jd3XwQqALPHXyogcgDGnQSkBTSLDfanvVdshPffk6v3cmoDflvWnhnQnTj6+VhIh2FPc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jbmya-002upw-29; Thu, 21 May 2020 17:19:16 +0200
Date:   Thu, 21 May 2020 17:19:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Daniel =?iso-8859-1?Q?Gonz=E1lez?= Cabanelas <dgcbueu@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        thomas.petazzoni@bootlin.com,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: [PATCH] net: mvneta: only do WoL speed down if the PHY is valid
Message-ID: <20200521151916.GC677363@lunn.ch>
References: <3268996.Ej3Lftc7GC@tool>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3268996.Ej3Lftc7GC@tool>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  drivers/net/ethernet/marvell/mvneta.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> index 41d2a0eac..f9170bc93 100644
> --- a/drivers/net/ethernet/marvell/mvneta.c
> +++ b/drivers/net/ethernet/marvell/mvneta.c
> @@ -3567,8 +3567,9 @@ static void mvneta_start_dev(struct mvneta_port *pp)
>  
>  	phylink_start(pp->phylink);
>  
> -	/* We may have called phy_speed_down before */
> -	phy_speed_up(pp->dev->phydev);
> +	if(pp->dev->phydev)
> +		/* We may have called phy_speed_down before */
> +		phy_speed_up(pp->dev->phydev);

I don't think it is as simple as this. You should not really be mixing
phy_ and phylink_ calls within one driver. You might of noticed there
are no other phy_ calls in this driver. So ideally you want to add
phylink_ calls which do the right thing.

	 Andrew

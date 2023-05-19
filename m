Return-Path: <netdev+bounces-3947-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B600D709BDB
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 17:59:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9CA361C212BE
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 15:59:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E99E511199;
	Fri, 19 May 2023 15:59:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE21511191
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 15:59:43 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B574E10DC
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 08:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=UG+uDSWf69KfWm+wK+G0N5tGIWz32Lrt9Br5fdXZdyE=; b=DzA2Gz1SD4E0HVFHUR3I0wAn3z
	xHL6AlPivF5zunPVKLJSHGHf8HbqcnuYjJIOU+KLtWTUGPAffk1zzi8e62fsvfTzXUd5zVUzBDZTX
	B3Oei+ehC8t+QCdnkcyGGB8R6/jniBNmlpw1BDyeparPKyJT8PUHxyywECFj888NeHmY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q02VS-00DLNO-1i; Fri, 19 May 2023 17:59:02 +0200
Date: Fri, 19 May 2023 17:59:02 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Russell King <rmk+kernel@armlinux.org.uk>
Cc: Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: add helpers for comparing phy IDs
Message-ID: <808c6158-5e30-402b-b686-462ca17e2a2c@lunn.ch>
References: <E1pzzm3-006BZJ-Bi@rmk-PC.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1pzzm3-006BZJ-Bi@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 19, 2023 at 02:03:59PM +0100, Russell King wrote:
> There are several places which open code comparing PHY IDs. Provide a
> couple of helpers to assist with this, using a slightly simpler test
> than the original:
> 
> - phy_id_compare() compares two arbitary PHY IDs and a mask of the
>   significant bits in the ID.
> - phydev_id_compare() compares the bound phydev with the specified
>   PHY ID, using the bound driver's mask.

Hi Russell

I think these are useful, but i'm wondering about naming. In the PHY
drivers we use these macros:

#define PHY_ID_MATCH_EXACT(id) .phy_id = (id), .phy_id_mask = GENMASK(31, 0)
#define PHY_ID_MATCH_MODEL(id) .phy_id = (id), .phy_id_mask = GENMASK(31, 4)
#define PHY_ID_MATCH_VENDOR(id) .phy_id = (id), .phy_id_mask = GENMASK(31, 10)

when creating the tables. 

> diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
> index 3f81bb8dac44..2094d49025a7 100644
> --- a/drivers/net/phy/micrel.c
> +++ b/drivers/net/phy/micrel.c
> @@ -637,7 +637,7 @@ static int ksz8051_ksz8795_match_phy_device(struct phy_device *phydev,
>  {
>  	int ret;
>  
> -	if ((phydev->phy_id & MICREL_PHY_ID_MASK) != PHY_ID_KSZ8051)
> +	if (!phy_id_compare(phydev->phy_id, PHY_ID_KSZ8051, MICREL_PHY_ID_MASK))
>  		return 0;

This could be phy_id_compare_model() 

phy_id_compare_exact() could be used in a number of places, eg.

vitesse.c:			(phydev->drv->phy_id == PHY_ID_VSC8234 ||
vitesse.c:			 phydev->drv->phy_id == PHY_ID_VSC8244 ||
vitesse.c:			 phydev->drv->phy_id == PHY_ID_VSC8572 ||
vitesse.c:			 phydev->drv->phy_id == PHY_ID_VSC8601) ?
motorcomm.c:	} else if (phydev->drv->phy_id == PHY_ID_YT8531S) {
marvell10g.c:	if (phydev->drv->phy_id != MARVELL_PHY_ID_88X3310)

etc.

	Andrew


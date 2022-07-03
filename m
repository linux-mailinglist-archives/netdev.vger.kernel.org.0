Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75C0F56488F
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 18:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232479AbiGCQiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 12:38:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbiGCQiK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 12:38:10 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B43A160F9
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 09:38:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=9yrilCL+L8aJeq9uNEW8WYMGbNYHVoTbxNqwvYjOcdU=; b=eOI4QyBvbkwnq8t/Xf6zZaqYIa
        xs6WOgdtOnN8i4CDDGJVDqs05wGicxChncbE5XgTWgaYPnrm+wHnEPQ+UL3A9BkeY9di1mmdSpAI3
        PNWTTh5gKOY4Xv6dQma/Hpeo6s0JX+2bERimnCxfNF3m8GTWlimAMJ53WQhfYpJCcPYQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o82bk-009ACD-Qy; Sun, 03 Jul 2022 18:38:04 +0200
Date:   Sun, 3 Jul 2022 18:38:04 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tristram.Ha@microchip.com
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next 1/2] net: phy: smsc: add WoL support to
 LAN8740/LAN8742 PHYs.
Message-ID: <YsHF7G+afEkcBGw6@lunn.ch>
References: <1656802708-7918-1-git-send-email-Tristram.Ha@microchip.com>
 <1656802708-7918-2-git-send-email-Tristram.Ha@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1656802708-7918-2-git-send-email-Tristram.Ha@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static void lan874x_get_wol(struct phy_device *phydev,
> +			    struct ethtool_wolinfo *wol)
> +{
> +	struct smsc_phy_priv *priv = phydev->priv;
> +	u16 val_wucsr;
> +	int rc;

> +
> +	/* WoL event notification */
> +	if (val_wucsr & MII_LAN874X_PHY_WOL_WUFR) {
> +		if (wol->wolopts & WAKE_ARP)
> +			phydev_info(phydev, "ARP WoL event received\n");
> +		if (wol->wolopts & WAKE_MCAST)
> +			phydev_info(phydev, "MCAST WoL event received\n");
> +	}
> +
> +	if (val_wucsr & MII_LAN874X_PHY_WOL_PFDA_FR)
> +		phydev_info(phydev, "UCAST WoL event received\n");
> +
> +	if (val_wucsr & MII_LAN874X_PHY_WOL_BCAST_FR)
> +		phydev_info(phydev, "BCAST WoL event received\n");
> +
> +	if (val_wucsr & MII_LAN874X_PHY_WOL_MPR)
> +		phydev_info(phydev, "Magic WoL event received\n");
> +
> +	/* clear WoL event */
> +	rc = phy_write_mmd(phydev, MDIO_MMD_PCS, MII_LAN874X_PHY_MMD_WOL_WUCSR,
> +			   val_wucsr);

Why dump this information to the kernel log? And why clear it, in
get_wol. I assume WOL triggers an interrupt? Then dumping the event in
the interrupt handler would make sense. Also clearing the event in the
interrupt handler is probably required, since it is probably a level
interrupt, and you want to avoid a storm. But in get_wol?

> +static int lan874x_set_wol(struct phy_device *phydev,
> +			   struct ethtool_wolinfo *wol)
> +{
> +	struct net_device *ndev = phydev->attached_dev;
> +	struct smsc_phy_priv *priv = phydev->priv;
> +	u16 val, val_wucsr;
> +	int i = 0, rc;
> +	u8 data[128];
> +	u8 datalen;
> +

Do you need to clear the WOL event here? Could there be an event left
over from the past?

     Andrew

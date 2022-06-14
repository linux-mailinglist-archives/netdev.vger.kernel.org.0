Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 556B654BC63
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 23:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbiFNU7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 16:59:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345334AbiFNU7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 16:59:30 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA1150033;
        Tue, 14 Jun 2022 13:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=KaFwuyiDydNieugWY2Rcg20ITI2iYJiL+7nCWj9lmOQ=; b=HfulGoa5FKly1WcwXpxAY642Ct
        KwKDh/V/XnAjym72wMTQWyHCXdXXnuXxu+2sXPFAJ0ARhap9kEQytK0+e5J1yT6BJSv+KnIh8Hjhw
        60zcW6QEx7vFyM6l6KJI8/hnCHVDEWCuDj/brUpK366yYXn75r3pasA5lQr0gOU2LNQs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o1DdB-006vhD-42; Tue, 14 Jun 2022 22:59:21 +0200
Date:   Tue, 14 Jun 2022 22:59:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, bryan.whitehead@microchip.com,
        lxu@maxlinear.com, richardcochran@gmail.com,
        UNGLinuxDriver@microchip.com, Ian.Saturley@microchip.com
Subject: Re: [PATCH net-next 2/5] net: lan743x: Add support to Secure-ON WOL
Message-ID: <Yqj2qegsJ7UTEr0K@lunn.ch>
References: <20220614103424.58971-1-Raju.Lakkaraju@microchip.com>
 <20220614103424.58971-3-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614103424.58971-3-Raju.Lakkaraju@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 14, 2022 at 04:04:21PM +0530, Raju Lakkaraju wrote:
> Add support to Magic Packet Detection with Secure-ON for PCI11010/PCI11414 chips
> 
> Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
> ---
>  .../net/ethernet/microchip/lan743x_ethtool.c  | 14 +++++++++
>  drivers/net/ethernet/microchip/lan743x_main.c | 29 +++++++++++++++++++
>  drivers/net/ethernet/microchip/lan743x_main.h | 10 +++++++
>  3 files changed, 53 insertions(+)
> 
> diff --git a/drivers/net/ethernet/microchip/lan743x_ethtool.c b/drivers/net/ethernet/microchip/lan743x_ethtool.c
> index 48b19dcd4351..b591a7aea937 100644
> --- a/drivers/net/ethernet/microchip/lan743x_ethtool.c
> +++ b/drivers/net/ethernet/microchip/lan743x_ethtool.c
> @@ -1149,7 +1149,13 @@ static void lan743x_ethtool_get_wol(struct net_device *netdev,
>  	wol->supported |= WAKE_BCAST | WAKE_UCAST | WAKE_MCAST |
>  		WAKE_MAGIC | WAKE_PHY | WAKE_ARP;
>  
> +	if (adapter->is_pci11x1x)
> +		wol->supported |= WAKE_MAGICSECURE;
> +
>  	wol->wolopts |= adapter->wolopts;
> +	if (adapter->wolopts & WAKE_MAGICSECURE)
> +		memcpy(wol->sopass, adapter->sopass,
> +		       SOPASS_MAX * sizeof(wol->sopass[0]));

sizeof(wol->sopass) is simpler. That is what other drivers use.

> +	if (wol->wolopts & WAKE_MAGICSECURE &&
> +	    wol->wolopts & WAKE_MAGIC) {
> +		memcpy(adapter->sopass, wol->sopass,
> +		       SOPASS_MAX * sizeof(wol->sopass[0]));
> +		adapter->wolopts |= WAKE_MAGICSECURE;
> +	} else {
> +		memset(adapter->sopass, 0, sizeof(u8) * SOPASS_MAX);
> +	}

Same here.

     Andrew

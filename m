Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3E1A6DAEC9
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 16:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231915AbjDGOU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 10:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbjDGOU5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 10:20:57 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C916EB7;
        Fri,  7 Apr 2023 07:20:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=5Jyxr04qP9yFskbtHvux860ZyuoRYgOEjQbVknhtYPI=; b=0lHHBpxrC5+/w8dHhvSG8dNBBh
        aZidgqKoGEaptfpJ2EFaNVCQelR+TSAO+D5o+Y0HfgfOxG8Ddz4yDSqsWoJNLH1PbeS0iOqa1y6mY
        zdcje5RYubX6deXGY+vsjP2ej3PnxkmZCBkbHD7UyZijfJ1WeAR+NLAAlv69qaoXtTUQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pkmxB-009jGH-FI; Fri, 07 Apr 2023 16:20:37 +0200
Date:   Fri, 7 Apr 2023 16:20:37 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Radu Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH net] net: phy: nxp-c45-tja11xx: add remove callback
Message-ID: <cf1dd1a9-2e2d-473e-89f0-8e2c51226dfe@lunn.ch>
References: <20230406095904.75456-1-radu-nicolae.pirea@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230406095904.75456-1-radu-nicolae.pirea@oss.nxp.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 06, 2023 at 12:59:04PM +0300, Radu Pirea (OSS) wrote:
> Unregister PTP clock when the driver is removed.
> Purge the RX and TX skb queues.
> 
> Fixes: 514def5dd339 ("phy: nxp-c45-tja11xx: add timestamping support")
> CC: stable@vger.kernel.org # 5.15+
> Signed-off-by: Radu Pirea (OSS) <radu-nicolae.pirea@oss.nxp.com>
> ---
>  drivers/net/phy/nxp-c45-tja11xx.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/net/phy/nxp-c45-tja11xx.c b/drivers/net/phy/nxp-c45-tja11xx.c
> index 5813b07242ce..27738d1ae9ea 100644
> --- a/drivers/net/phy/nxp-c45-tja11xx.c
> +++ b/drivers/net/phy/nxp-c45-tja11xx.c
> @@ -1337,6 +1337,17 @@ static int nxp_c45_probe(struct phy_device *phydev)
>  	return ret;
>  }
>  
> +static void nxp_c45_remove(struct phy_device *phydev)
> +{
> +	struct nxp_c45_phy *priv = phydev->priv;
> +
> +	if (priv->ptp_clock)
> +		ptp_clock_unregister(priv->ptp_clock);
> +
> +	skb_queue_purge(&priv->tx_queue);
> +	skb_queue_purge(&priv->rx_queue);

Do you need to disable interrupts? I suppose the real question is, is
it guaranteed phy_disconnect() is called before the driver is removed?

   Andrew

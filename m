Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 511E5142782
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 10:43:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbgATJnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 04:43:16 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:60586 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbgATJnQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 04:43:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=FkSM7zAt+ZnzdzPaNM0/eDxIjWFl+SD3FFGJ6nqMM8I=; b=QuDgN4POLPcLSKDBE+WbGv2Th
        6WsYqEIkEE/1O5YeY0RPANmU5gFF+MrkaeRUmAQAbZ635Om8TZynUqL2xSnu/Yat86wNQ6JJU3fnO
        B7glz8FdB/VE+CRqBkk1+hHKx6CSXIi5bYnxDmXQkBCm/9dSzSdWOsCLgvWZpO3Z6LUG5JuHrMs1l
        wBCOMjkckz6tbF4GA7RV5mQxHRDKNKd+mVGKuhBLIs4RnGTbH3+xQHmRnSloxNWuCT3UJ4AzlH5uB
        F8oP13TWoC+ITWR9Zx/IjKR7YaenoYV99KypSUbi/36S1Xdy7FJyE7sjBTBw1/1H+kNwNbVj82MWc
        4lodAqSZQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:40798)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1itTaO-0005Gh-Sr; Mon, 20 Jan 2020 09:43:09 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1itTaK-0002jp-UY; Mon, 20 Jan 2020 09:43:04 +0000
Date:   Mon, 20 Jan 2020 09:43:04 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 1/2] net: dsa: felix: Handle PAUSE RX regardless
 of AN result
Message-ID: <20200120094304.GZ25745@shell.armlinux.org.uk>
References: <20200116181933.32765-1-olteanv@gmail.com>
 <20200116181933.32765-2-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116181933.32765-2-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 16, 2020 at 08:19:32PM +0200, Vladimir Oltean wrote:
> From: Alex Marginean <alexandru.marginean@nxp.com>
> 
> Flow control is used with 2500Base-X and AQR PHYs to do rate adaptation
> between line side 100/1000 links and MAC running at 2.5G.
> 
> This is independent of the flow control configuration settled on line
> side though AN.
> 
> In general, allowing the MAC to handle flow control even if not
> negotiated with the link partner should not be a problem, so the patch
> just enables it in all cases.
> 
> Signed-off-by: Alex Marginean <alexandru.marginean@nxp.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

I think this is not the best approach - you're working around the
issue in your network driver, rather than recognising that it's a
larger problem than just your network driver.  Rate adaption is
present in other PHYs using exactly the same mechanism so why do we
want to hack around this in each network driver?  It is a property
of the PHY, not of the network driver.

Surely it not be better to address this in phylib/phylink - after
all, there are several aspects to this:

1) separation of the MAC configuration (reported to the MAC) from
   the negotiation results (reported to the user).
2) we need the MAC to be able to receive and act on flow control.
3) we need to report the correct speed setting to the MAC.

I already have patches to improve the current phylib method of
reporting the flow control information to MAC drivers with the resolved
flow state rather than just the current link partner advertisement
bits, which should make (2) fairly easy to achieve.  (1) and (3) will
require additional work.

> ---
>  drivers/net/dsa/ocelot/felix.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
> index d6ee089dbfe1..46334436a8fe 100644
> --- a/drivers/net/dsa/ocelot/felix.c
> +++ b/drivers/net/dsa/ocelot/felix.c
> @@ -222,8 +222,12 @@ static void felix_phylink_mac_config(struct dsa_switch *ds, int port,
>  	 * specification in incoming pause frames.
>  	 */
>  	mac_fc_cfg = SYS_MAC_FC_CFG_FC_LINK_SPEED(state->speed);
> -	if (state->pause & MLO_PAUSE_RX)
> -		mac_fc_cfg |= SYS_MAC_FC_CFG_RX_FC_ENA;
> +
> +	/* handle Rx pause in all cases, with 2500base-X this is used for rate
> +	 * adaptation.
> +	 */
> +	mac_fc_cfg |= SYS_MAC_FC_CFG_RX_FC_ENA;
> +
>  	if (state->pause & MLO_PAUSE_TX)
>  		mac_fc_cfg |= SYS_MAC_FC_CFG_TX_FC_ENA |
>  			      SYS_MAC_FC_CFG_PAUSE_VAL_CFG(0xffff) |
> -- 
> 2.17.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up

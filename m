Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 940D216812A
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 16:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729111AbgBUPHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 10:07:54 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:44597 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728974AbgBUPHx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 10:07:53 -0500
X-Originating-IP: 86.201.231.92
Received: from localhost (lfbn-tou-1-149-92.w86-201.abo.wanadoo.fr [86.201.231.92])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 8F8FA1C0014;
        Fri, 21 Feb 2020 15:07:51 +0000 (UTC)
Date:   Fri, 21 Feb 2020 16:07:51 +0100
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>
Subject: Re: [RFC 06/18] net: macsec: invoke mdo_upd_secy callback when mac
 address changed
Message-ID: <20200221150751.GB3530@kwain>
References: <20200214150258.390-1-irusskikh@marvell.com>
 <20200214150258.390-7-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200214150258.390-7-irusskikh@marvell.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Fri, Feb 14, 2020 at 06:02:46PM +0300, Igor Russkikh wrote:
> From: Dmitry Bogdanov <dbogdanov@marvell.com>
> 
> Change SCI according to the new MAC address, because it must contain MAC
> in its first 6 octets.
> Also notify the offload engine about MAC address change to reconfigure it
> accordingly.

It seems you're making two different changes in a single commit, you
could split it.

Updating the SCI according to the new MAC address applies here to both
the s/w implementation and the offloaded ones: it looks like this is
fixing an issue when the MAC address is updated. If so, could you send
it accordingly (as a fix)?

Thanks!
Antoine

> Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
> Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
> Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
> ---
>  drivers/net/macsec.c | 25 ++++++++++++++++++++-----
>  1 file changed, 20 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
> index af41887d9a1e..973b09401099 100644
> --- a/drivers/net/macsec.c
> +++ b/drivers/net/macsec.c
> @@ -433,6 +433,11 @@ static struct macsec_eth_header *macsec_ethhdr(struct sk_buff *skb)
>  	return (struct macsec_eth_header *)skb_mac_header(skb);
>  }
>  
> +static sci_t dev_to_sci(struct net_device *dev, __be16 port)
> +{
> +	return make_sci(dev->dev_addr, port);
> +}
> +
>  static void __macsec_pn_wrapped(struct macsec_secy *secy,
>  				struct macsec_tx_sa *tx_sa)
>  {
> @@ -3291,6 +3296,21 @@ static int macsec_set_mac_address(struct net_device *dev, void *p)
>  
>  out:
>  	ether_addr_copy(dev->dev_addr, addr->sa_data);
> +
> +	macsec->secy.sci = dev_to_sci(dev, MACSEC_PORT_ES);
> +
> +	/* If h/w offloading is available, propagate to the device */
> +	if (macsec_is_offloaded(macsec)) {
> +		const struct macsec_ops *ops;
> +		struct macsec_context ctx;
> +
> +		ops = macsec_get_ops(macsec, &ctx);
> +		if (ops) {
> +			ctx.secy = &macsec->secy;
> +			macsec_offload(ops->mdo_upd_secy, &ctx);
> +		}
> +	}
> +
>  	return 0;
>  }
>  
> @@ -3615,11 +3635,6 @@ static bool sci_exists(struct net_device *dev, sci_t sci)
>  	return false;
>  }
>  
> -static sci_t dev_to_sci(struct net_device *dev, __be16 port)
> -{
> -	return make_sci(dev->dev_addr, port);
> -}
> -
>  static int macsec_add_dev(struct net_device *dev, sci_t sci, u8 icv_len)
>  {
>  	struct macsec_dev *macsec = macsec_priv(dev);
> -- 
> 2.17.1
> 

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

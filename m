Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1613B168130
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 16:09:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729082AbgBUPJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 10:09:33 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:41145 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728690AbgBUPJd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 10:09:33 -0500
X-Originating-IP: 86.201.231.92
Received: from localhost (lfbn-tou-1-149-92.w86-201.abo.wanadoo.fr [86.201.231.92])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 750921C000C;
        Fri, 21 Feb 2020 15:09:31 +0000 (UTC)
Date:   Fri, 21 Feb 2020 16:09:30 +0100
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>
Subject: Re: [RFC 05/18] net: macsec: init secy pointer in macsec_context
Message-ID: <20200221150930.GC3530@kwain>
References: <20200214150258.390-1-irusskikh@marvell.com>
 <20200214150258.390-6-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200214150258.390-6-irusskikh@marvell.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 14, 2020 at 06:02:45PM +0300, Igor Russkikh wrote:
> From: Dmitry Bogdanov <dbogdanov@marvell.com>
> 
> This patch adds secy pointer initialization in the macsec_context.
> It will be used by MAC drivers in offloading operations.
> 
> Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
> Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
> Signed-off-by: Igor Russkikh <irusskikh@marvell.com>

Reviewed-by: Antoine Tenart <antoine.tenart@bootlin.com>

> ---
>  drivers/net/macsec.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
> index a88b41a79103..af41887d9a1e 100644
> --- a/drivers/net/macsec.c
> +++ b/drivers/net/macsec.c
> @@ -1692,6 +1692,7 @@ static int macsec_add_rxsa(struct sk_buff *skb, struct genl_info *info)
>  
>  		ctx.sa.assoc_num = assoc_num;
>  		ctx.sa.rx_sa = rx_sa;
> +		ctx.secy = secy;
>  		memcpy(ctx.sa.key, nla_data(tb_sa[MACSEC_SA_ATTR_KEY]),
>  		       MACSEC_KEYID_LEN);
>  
> @@ -1733,6 +1734,7 @@ static int macsec_add_rxsc(struct sk_buff *skb, struct genl_info *info)
>  	struct nlattr **attrs = info->attrs;
>  	struct macsec_rx_sc *rx_sc;
>  	struct nlattr *tb_rxsc[MACSEC_RXSC_ATTR_MAX + 1];
> +	struct macsec_secy *secy;
>  	bool was_active;
>  	int ret;
>  
> @@ -1752,6 +1754,7 @@ static int macsec_add_rxsc(struct sk_buff *skb, struct genl_info *info)
>  		return PTR_ERR(dev);
>  	}
>  
> +	secy = &macsec_priv(dev)->secy;
>  	sci = nla_get_sci(tb_rxsc[MACSEC_RXSC_ATTR_SCI]);
>  
>  	rx_sc = create_rx_sc(dev, sci);
> @@ -1775,6 +1778,7 @@ static int macsec_add_rxsc(struct sk_buff *skb, struct genl_info *info)
>  		}
>  
>  		ctx.rx_sc = rx_sc;
> +		ctx.secy = secy;
>  
>  		ret = macsec_offload(ops->mdo_add_rxsc, &ctx);
>  		if (ret)
> @@ -1900,6 +1904,7 @@ static int macsec_add_txsa(struct sk_buff *skb, struct genl_info *info)
>  
>  		ctx.sa.assoc_num = assoc_num;
>  		ctx.sa.tx_sa = tx_sa;
> +		ctx.secy = secy;
>  		memcpy(ctx.sa.key, nla_data(tb_sa[MACSEC_SA_ATTR_KEY]),
>  		       MACSEC_KEYID_LEN);
>  
> @@ -1969,6 +1974,7 @@ static int macsec_del_rxsa(struct sk_buff *skb, struct genl_info *info)
>  
>  		ctx.sa.assoc_num = assoc_num;
>  		ctx.sa.rx_sa = rx_sa;
> +		ctx.secy = secy;
>  
>  		ret = macsec_offload(ops->mdo_del_rxsa, &ctx);
>  		if (ret)
> @@ -2034,6 +2040,7 @@ static int macsec_del_rxsc(struct sk_buff *skb, struct genl_info *info)
>  		}
>  
>  		ctx.rx_sc = rx_sc;
> +		ctx.secy = secy;
>  		ret = macsec_offload(ops->mdo_del_rxsc, &ctx);
>  		if (ret)
>  			goto cleanup;
> @@ -2092,6 +2099,7 @@ static int macsec_del_txsa(struct sk_buff *skb, struct genl_info *info)
>  
>  		ctx.sa.assoc_num = assoc_num;
>  		ctx.sa.tx_sa = tx_sa;
> +		ctx.secy = secy;
>  
>  		ret = macsec_offload(ops->mdo_del_txsa, &ctx);
>  		if (ret)
> @@ -2189,6 +2197,7 @@ static int macsec_upd_txsa(struct sk_buff *skb, struct genl_info *info)
>  
>  		ctx.sa.assoc_num = assoc_num;
>  		ctx.sa.tx_sa = tx_sa;
> +		ctx.secy = secy;
>  
>  		ret = macsec_offload(ops->mdo_upd_txsa, &ctx);
>  		if (ret)
> @@ -2269,6 +2278,7 @@ static int macsec_upd_rxsa(struct sk_buff *skb, struct genl_info *info)
>  
>  		ctx.sa.assoc_num = assoc_num;
>  		ctx.sa.rx_sa = rx_sa;
> +		ctx.secy = secy;
>  
>  		ret = macsec_offload(ops->mdo_upd_rxsa, &ctx);
>  		if (ret)
> @@ -2339,6 +2349,7 @@ static int macsec_upd_rxsc(struct sk_buff *skb, struct genl_info *info)
>  		}
>  
>  		ctx.rx_sc = rx_sc;
> +		ctx.secy = secy;
>  
>  		ret = macsec_offload(ops->mdo_upd_rxsc, &ctx);
>  		if (ret)
> @@ -3184,6 +3195,7 @@ static int macsec_dev_open(struct net_device *dev)
>  			goto clear_allmulti;
>  		}
>  
> +		ctx.secy = &macsec->secy;
>  		err = macsec_offload(ops->mdo_dev_open, &ctx);
>  		if (err)
>  			goto clear_allmulti;
> @@ -3215,8 +3227,10 @@ static int macsec_dev_stop(struct net_device *dev)
>  		struct macsec_context ctx;
>  
>  		ops = macsec_get_ops(macsec, &ctx);
> -		if (ops)
> +		if (ops) {
> +			ctx.secy = &macsec->secy;
>  			macsec_offload(ops->mdo_dev_stop, &ctx);
> +		}
>  	}
>  
>  	dev_mc_unsync(real_dev, dev);
> -- 
> 2.17.1
> 

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

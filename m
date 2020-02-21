Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDB6B16856E
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 18:48:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729425AbgBURs3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 12:48:29 -0500
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:42101 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729411AbgBURs1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 12:48:27 -0500
X-Originating-IP: 92.184.108.100
Received: from localhost (unknown [92.184.108.100])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id EDFB9FF806;
        Fri, 21 Feb 2020 17:48:23 +0000 (UTC)
Date:   Fri, 21 Feb 2020 18:48:20 +0100
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>
Subject: Re: [RFC 09/18] net: macsec: add support for getting offloaded stats
Message-ID: <20200221174820.GD3530@kwain>
References: <20200214150258.390-1-irusskikh@marvell.com>
 <20200214150258.390-10-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200214150258.390-10-irusskikh@marvell.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Fri, Feb 14, 2020 at 06:02:49PM +0300, Igor Russkikh wrote:
> From: Dmitry Bogdanov <dbogdanov@marvell.com>
> 
> report sw stats only if offloaded stats are not supported

Please improve the changelog.

> -static int copy_tx_sa_stats(struct sk_buff *skb,
> -			    struct macsec_tx_sa_stats __percpu *pstats)
> +static void get_tx_sa_stats(struct net_device *dev, int an,
> +			    struct macsec_tx_sa *tx_sa,
> +			    struct macsec_tx_sa_stats *sum)
>  {
> -	struct macsec_tx_sa_stats sum = {0, };
> +	struct macsec_dev *macsec = macsec_priv(dev);
> +	int err = -EOPNOTSUPP;
>  	int cpu;
>  
> +	/* If h/w offloading is available, propagate to the device */
> +	if (macsec_is_offloaded(macsec)) {
> +		const struct macsec_ops *ops;
> +		struct macsec_context ctx;
> +
> +		ops = macsec_get_ops(macsec, &ctx);
> +		if (ops) {
> +			ctx.sa.assoc_num = an;
> +			ctx.sa.tx_sa = tx_sa;
> +			ctx.stats.tx_sa_stats = sum;
> +			ctx.secy = &macsec_priv(dev)->secy;
> +			err = macsec_offload(ops->mdo_get_tx_sa_stats, &ctx);
> +		}
> +	}
> +
> +	if (err != -EOPNOTSUPP)
> +		return;

If offloading is enabled and ops->mdo_get_tx_sa_stats is returning
-EOPNOTSUPP, do we really want to return the s/w stats as they'll be
wrong and out of sync with the hardware anyway?

(The same applies for the other statistics retrieval in the same patch).

> +
>  	for_each_possible_cpu(cpu) {
> -		const struct macsec_tx_sa_stats *stats = per_cpu_ptr(pstats, cpu);
> +		const struct macsec_tx_sa_stats *stats =
> +			per_cpu_ptr(tx_sa->stats, cpu);
>  
> -		sum.OutPktsProtected += stats->OutPktsProtected;
> -		sum.OutPktsEncrypted += stats->OutPktsEncrypted;
> +		sum->OutPktsProtected += stats->OutPktsProtected;
> +		sum->OutPktsEncrypted += stats->OutPktsEncrypted;
>  	}
> +}

Thanks!
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

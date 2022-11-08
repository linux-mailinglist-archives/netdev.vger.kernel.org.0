Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B540B6206B7
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 03:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233106AbiKHC1e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 21:27:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiKHC1c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 21:27:32 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9150C183A1;
        Mon,  7 Nov 2022 18:27:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Cs3x9tc+ZgMBqe3I18ShxSkvk/KNHstoAyiOxOiMD/A=; b=IyKri1AWH2/qZZca8gTYBCxvn4
        rroDdxIZk2HZSCtF665/NYyXTCUDgT1k5NulxF8NZVZrt9AbnG/Q35/62FGOlSSl+e891+JqZvXQa
        dD0z/z2YJgvlG+SQTdHcq0PJgxlCLYALl3rualxXad6VNd75YqK8IokwYmP36kXQfSuY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1osEJM-001m0U-Dl; Tue, 08 Nov 2022 03:26:00 +0100
Date:   Tue, 8 Nov 2022 03:26:00 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Shenwei Wang <shenwei.wang@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        imx@lists.linux.dev
Subject: Re: [PATCH 2/2] net: fec: add xdp and page pool statistics
Message-ID: <Y2m+OHPaS6aV6GYx@lunn.ch>
References: <20221107143825.3368602-1-shenwei.wang@nxp.com>
 <20221107143825.3368602-3-shenwei.wang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221107143825.3368602-3-shenwei.wang@nxp.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +enum {
> +	RX_XDP_REDIRECT = 0,
> +	RX_XDP_PASS,
> +	RX_XDP_DROP,
> +	RX_XDP_TX,
> +	RX_XDP_TX_ERRORS,
> +	TX_XDP_XMIT,
> +	TX_XDP_XMIT_ERRORS,
> +	XDP_STATS_TOTAL,
> +};
> +
>  struct fec_enet_priv_tx_q {
>  	struct bufdesc_prop bd;
>  	unsigned char *tx_bounce[TX_RING_SIZE];
> @@ -546,6 +557,7 @@ struct fec_enet_priv_rx_q {
>  	/* page_pool */
>  	struct page_pool *page_pool;
>  	struct xdp_rxq_info xdp_rxq;
> +	u32 stats[XDP_STATS_TOTAL];
>  
>  	/* rx queue number, in the range 0-7 */
>  	u8 id;
> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
> index 3fb870340c22..89fef370bc10 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -1523,10 +1523,12 @@ fec_enet_run_xdp(struct fec_enet_private *fep, struct bpf_prog *prog,
>  
>  	switch (act) {
>  	case XDP_PASS:
> +		rxq->stats[RX_XDP_PASS]++;
>  		ret = FEC_ENET_XDP_PASS;
>  		break;
>  
>  	case XDP_REDIRECT:
> +		rxq->stats[RX_XDP_REDIRECT]++;
>  		err = xdp_do_redirect(fep->netdev, xdp, prog);
>  		if (!err) {
>  			ret = FEC_ENET_XDP_REDIR;
> @@ -1549,6 +1551,7 @@ fec_enet_run_xdp(struct fec_enet_private *fep, struct bpf_prog *prog,
>  		fallthrough;    /* handle aborts by dropping packet */
>  
>  	case XDP_DROP:
> +		rxq->stats[RX_XDP_DROP]++;
>  		ret = FEC_ENET_XDP_CONSUMED;
>  		page = virt_to_head_page(xdp->data);
>  		page_pool_put_page(rxq->page_pool, page, sync, true);
> @@ -2657,37 +2660,91 @@ static const struct fec_stat {
>  	{ "IEEE_rx_octets_ok", IEEE_R_OCTETS_OK },
>  };
>  
> -#define FEC_STATS_SIZE		(ARRAY_SIZE(fec_stats) * sizeof(u64))
> +static struct fec_xdp_stat {
> +	char name[ETH_GSTRING_LEN];
> +	u64 count;
> +} fec_xdp_stats[XDP_STATS_TOTAL] = {
> +	{ "rx_xdp_redirect", 0 },           /* RX_XDP_REDIRECT = 0, */
> +	{ "rx_xdp_pass", 0 },               /* RX_XDP_PASS, */
> +	{ "rx_xdp_drop", 0 },               /* RX_XDP_DROP, */
> +	{ "rx_xdp_tx", 0 },                 /* RX_XDP_TX, */
> +	{ "rx_xdp_tx_errors", 0 },          /* RX_XDP_TX_ERRORS, */
> +	{ "tx_xdp_xmit", 0 },               /* TX_XDP_XMIT, */
> +	{ "tx_xdp_xmit_errors", 0 },        /* TX_XDP_XMIT_ERRORS, */
> +};

Why do you mix the string and the count?

> +
> +#define FEC_STATS_SIZE	((ARRAY_SIZE(fec_stats) + \
> +			ARRAY_SIZE(fec_xdp_stats)) * sizeof(u64))
>  
>  static void fec_enet_update_ethtool_stats(struct net_device *dev)
>  {
>  	struct fec_enet_private *fep = netdev_priv(dev);
> -	int i;
> +	struct fec_xdp_stat xdp_stats[7];

You are allocating 7 x name[ETH_GSTRING_LEN], here, which you are not
going to use. All you really need is u64 xdp_stats[XDP_STATS_TOTAL]

> +	int off = ARRAY_SIZE(fec_stats);
> +	struct fec_enet_priv_rx_q *rxq;
> +	int i, j;
>  
>  	for (i = 0; i < ARRAY_SIZE(fec_stats); i++)
>  		fep->ethtool_stats[i] = readl(fep->hwp + fec_stats[i].offset);
> +
> +	for (i = fep->num_rx_queues - 1; i >= 0; i--) {
> +		rxq = fep->rx_queue[i];
> +		for (j = 0; j < XDP_STATS_TOTAL; j++)
> +			xdp_stats[j].count += rxq->stats[j];
> +	}
> +
> +	for (i = 0; i < XDP_STATS_TOTAL; i++)
> +		fep->ethtool_stats[i + off] = xdp_stats[i].count;

It would be more logical to use j here.

It is also pretty messy. For fec_enet_get_strings() and
fec_enet_get_sset_count() you deal with the three sets of stats
individually. But here you combine normal stats and xdp stats in
one. It will probably come out cleaner if you keep it all separate.

>  static void fec_enet_get_ethtool_stats(struct net_device *dev,
>  				       struct ethtool_stats *stats, u64 *data)
>  {
>  	struct fec_enet_private *fep = netdev_priv(dev);
> +	u64 *dst = data + FEC_STATS_SIZE / 8;

Why 8? sizeof(u64) would be a bit clearer. Or just use
ARRAY_SIZE(fec_stats) which is what you are actually wanting.

>  
>  	if (netif_running(dev))
>  		fec_enet_update_ethtool_stats(dev);
>  
>  	memcpy(data, fep->ethtool_stats, FEC_STATS_SIZE);
> +
> +	fec_enet_page_pool_stats(fep, dst);
>  }
>  
>  static void fec_enet_get_strings(struct net_device *netdev,
>  	u32 stringset, u8 *data)
>  {
> +	int off = ARRAY_SIZE(fec_stats);
>  	int i;
>  	switch (stringset) {
>  	case ETH_SS_STATS:
>  		for (i = 0; i < ARRAY_SIZE(fec_stats); i++)
>  			memcpy(data + i * ETH_GSTRING_LEN,
>  				fec_stats[i].name, ETH_GSTRING_LEN);
> +		for (i = 0; i < ARRAY_SIZE(fec_xdp_stats); i++)
> +			memcpy(data + (i + off) * ETH_GSTRING_LEN,
> +			       fec_xdp_stats[i].name, ETH_GSTRING_LEN);
> +		off = (i + off) * ETH_GSTRING_LEN;
> +		page_pool_ethtool_stats_get_strings(data + off);

Probably simpler is:

		for (i = 0; i < ARRAY_SIZE(fec_stats); i++) {
			memcpy(data, fec_stats[i].name, ETH_GSTRING_LEN);
			data += ETH_GSTRING_LEN;
		}
		for (i = 0; i < ARRAY_SIZE(fec_xdp_stats); i++) {
			memcpy(data, fec_xdp_stats[i].name, ETH_GSTRING_LEN);
			data += ETH_GSTRING_LEN;
		}
		page_pool_ethtool_stats_get_strings(data);
		
	Andrew

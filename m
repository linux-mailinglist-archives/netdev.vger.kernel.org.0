Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B51B4C36E7
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 21:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233866AbiBXUau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 15:30:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233806AbiBXUat (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 15:30:49 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5328197B7F
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 12:30:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=tQSo01E1krWTmpvHrN7l9D31H1fWhYV1P619XShHdv8=; b=2no5sB/FkRHklLe/ks2/MRw+Kx
        Q231vAnp/JWFM27kfpnxq73quSr5iSPzBv/P71zxBDNOmQnrM8ZAiNV6Qc7t2Ajp6HSBsv9K7YslR
        1Zm5jmnb2rJPDuI5tFuT2NPXyv/+St/pkWLhjtLlMueZaTdJTeQqfQGMcq5XD3YVOX4M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nNKke-0081E0-W8; Thu, 24 Feb 2022 21:30:13 +0100
Date:   Thu, 24 Feb 2022 21:30:12 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dimitris Michailidis <d.michailidis@fungible.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v7 4/8] net/funeth: ethtool operations
Message-ID: <Yhfq1N7ce/adhmN9@lunn.ch>
References: <20220218234536.9810-1-dmichail@fungible.com>
 <20220218234536.9810-5-dmichail@fungible.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220218234536.9810-5-dmichail@fungible.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static void fun_link_modes_to_ethtool(u64 modes,
> +				      unsigned long *ethtool_modes_map)
> +{
> +#define ADD_LINK_MODE(mode) \
> +	__set_bit(ETHTOOL_LINK_MODE_ ## mode ## _BIT, ethtool_modes_map)
> +
> +	if (modes & FUN_PORT_CAP_AUTONEG)
> +		ADD_LINK_MODE(Autoneg);
> +	if (modes & FUN_PORT_CAP_1000_X)
> +		ADD_LINK_MODE(1000baseX_Full);
> +	if (modes & FUN_PORT_CAP_10G_R) {
> +		ADD_LINK_MODE(10000baseCR_Full);
> +		ADD_LINK_MODE(10000baseSR_Full);
> +		ADD_LINK_MODE(10000baseLR_Full);
> +		ADD_LINK_MODE(10000baseER_Full);
> +	}

> +static unsigned int fun_port_type(unsigned int xcvr)
> +{
> +	if (!xcvr)
> +		return PORT_NONE;
> +
> +	switch (xcvr & 7) {
> +	case FUN_XCVR_BASET:
> +		return PORT_TP;

You support twisted pair, so should you also have the BaseT_FULL link
modes above?

> +static void fun_get_pauseparam(struct net_device *netdev,
> +			       struct ethtool_pauseparam *pause)
> +{
> +	const struct funeth_priv *fp = netdev_priv(netdev);
> +	u8 active_pause = fp->active_fc;
> +
> +	pause->rx_pause = !!(active_pause & FUN_PORT_CAP_RX_PAUSE);
> +	pause->tx_pause = !!(active_pause & FUN_PORT_CAP_TX_PAUSE);
> +	pause->autoneg = !!(fp->advertising & FUN_PORT_CAP_AUTONEG);

pause->autoneg is if you are negotiating pause via autneg, not if you
are doing autoneg in general. The user can set pause autoneg to false, via

ethtool -A|--pause devname [autoneg on|off]

but the link can still negotiate speed, duplex etc. But then it gets
more confusing with the following code:

> +}
> +
> +static int fun_set_pauseparam(struct net_device *netdev,
> +			      struct ethtool_pauseparam *pause)
> +{
> +	struct funeth_priv *fp = netdev_priv(netdev);
> +	u64 new_advert;
> +
> +	if (fp->port_caps & FUN_PORT_CAP_VPORT)
> +		return -EOPNOTSUPP;
> +	/* Forcing PAUSE settings with AN enabled is unsupported. */
> +	if (!pause->autoneg && (fp->advertising & FUN_PORT_CAP_AUTONEG))
> +		return -EOPNOTSUPP;

This seems wrong. You don't advertise you cannot advertise. You simply
don't advertise. It could just be you have a bad variable name here?

> +	if (pause->autoneg && !(fp->advertising & FUN_PORT_CAP_AUTONEG))
> +		return -EINVAL;

So it should be, you have the capability to advertise pause, not that
you have the ability to advertise advertising. And it sounds like the
ability to advertise pause is hard coded on.

> +static void fun_get_ethtool_stats(struct net_device *netdev,
> +				  struct ethtool_stats *stats, u64 *data)
> +{
> +	const struct funeth_priv *fp = netdev_priv(netdev);
> +	struct funeth_txq_stats txs;
> +	struct funeth_rxq_stats rxs;
> +	struct funeth_txq **xdpqs;
> +	struct funeth_rxq **rxqs;
> +	unsigned int i, start;
> +	u64 *totals, *tot;
> +
> +	if (!netif_running(netdev))
> +		return;

Why this limitation? I don't expect the counters to increment, but
they should still indicate the state when the interface was configured
down.

	Andrew

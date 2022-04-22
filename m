Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5013B50C115
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 23:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbiDVV0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 17:26:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiDVV0F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 17:26:05 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3444825CA09;
        Fri, 22 Apr 2022 13:22:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=IJ9Mu/aUYM3vuD5oQcui/J0/WhPDdyFZPtdQU+Ga/QI=; b=T1tOkSyynfaYwEC/xaB+p6az3Z
        XtQ2o1NqRu4SayBGALcPLXyZykVvU5An2x8p6KxswgnsA7y9ZqXOckyg10qAdYaxD1v/tTnx308tr
        3W0frA8HsyBxGGYZJ3dC1060Ed0pognN1wfkuOy5+1/JWKY9TF19h+gO4BQyUbykPAwM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nhzkl-00H2Uf-Si; Fri, 22 Apr 2022 22:19:43 +0200
Date:   Fri, 22 Apr 2022 22:19:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: Re: [PATCH net-next 1/5] net: ipqess: introduce the Qualcomm IPQESS
 driver
Message-ID: <YmMN37VjQNwhLDuX@lunn.ch>
References: <20220422180305.301882-1-maxime.chevallier@bootlin.com>
 <20220422180305.301882-2-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220422180305.301882-2-maxime.chevallier@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int ipqess_axi_probe(struct platform_device *pdev)
> +{
> +	struct device_node *np = pdev->dev.of_node;
> +	struct net_device *netdev;
> +	phy_interface_t phy_mode;
> +	struct resource *res;
> +	struct ipqess *ess;
> +	int i, err = 0;
> +
> +	netdev = devm_alloc_etherdev_mqs(&pdev->dev, sizeof(struct ipqess),
> +					 IPQESS_NETDEV_QUEUES,
> +					 IPQESS_NETDEV_QUEUES);
> +	if (!netdev)
> +		return -ENOMEM;
> +
> +	ess = netdev_priv(netdev);
> +	ess->netdev = netdev;
> +	ess->pdev = pdev;
> +	spin_lock_init(&ess->stats_lock);
> +	SET_NETDEV_DEV(netdev, &pdev->dev);
> +	platform_set_drvdata(pdev, netdev);

....

> +
> +	ipqess_set_ethtool_ops(netdev);
> +
> +	err = register_netdev(netdev);
> +	if (err)
> +		goto err_out;

Before register_netdev() even returns, your devices can be in use, the
open callback called and packets sent. This is particularly true for
NFS root. Which means any setup done after this is probably wrong.

> +
> +	err = ipqess_hw_init(ess);
> +	if (err)
> +		goto err_out;
> +
> +	for (i = 0; i < IPQESS_NETDEV_QUEUES; i++) {
> +		int qid;
> +
> +		netif_tx_napi_add(netdev, &ess->tx_ring[i].napi_tx,
> +				  ipqess_tx_napi, 64);
> +		netif_napi_add(netdev,
> +			       &ess->rx_ring[i].napi_rx,
> +			       ipqess_rx_napi, 64);
> +
> +		qid = ess->tx_ring[i].idx;
> +		err = devm_request_irq(&ess->netdev->dev, ess->tx_irq[qid],
> +				       ipqess_interrupt_tx, 0,
> +				       ess->tx_irq_names[qid],
> +				       &ess->tx_ring[i]);
> +		if (err)
> +			goto err_out;
> +
> +		qid = ess->rx_ring[i].idx;
> +		err = devm_request_irq(&ess->netdev->dev, ess->rx_irq[qid],
> +				       ipqess_interrupt_rx, 0,
> +				       ess->rx_irq_names[qid],
> +				       &ess->rx_ring[i]);
> +		if (err)
> +			goto err_out;
> +	}

All this should probably go before netdev_register().

> +static int ipqess_get_strset_count(struct net_device *netdev, int sset)
> +{
> +	switch (sset) {
> +	case ETH_SS_STATS:
> +		return ARRAY_SIZE(ipqess_stats);
> +	default:
> +		netdev_dbg(netdev, "%s: Invalid string set", __func__);

Unsupported would be better than invalid.

> +		return -EOPNOTSUPP;
> +	}
> +}

  Andrew

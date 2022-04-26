Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3349550FFFA
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 16:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351427AbiDZOGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 10:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351411AbiDZOGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 10:06:03 -0400
Received: from mslow1.mail.gandi.net (mslow1.mail.gandi.net [217.70.178.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 308AF194B3B;
        Tue, 26 Apr 2022 07:02:54 -0700 (PDT)
Received: from relay4-d.mail.gandi.net (unknown [IPv6:2001:4b98:dc4:8::224])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id A5F24CCCE7;
        Tue, 26 Apr 2022 13:59:27 +0000 (UTC)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id B1127E0005;
        Tue, 26 Apr 2022 13:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1650981560;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GTsEdXn491qPq9CntZ0vXSrj34SAbeJiBaBwaTF2/pU=;
        b=pEbSVKbl1mUCAPjU5O2M4QD9ktkNY1MhXV702GU3++Yr3XYy4/bv1zL6bBvV4PMxLagnW4
        /t0ra18CveutBw25GWFoPLqVkQr5soc1LpqMm4hjAunhaYTekh2qF92DcIP6Re2iaosXvi
        NOzWesBoHBw4ez/2huWOJtg2E1dao0u6k4dC5XoB2bWEsKkBOYYEGus/dzukssvJnGQkdk
        EX2Thw4tV80V7SR22wae7ZRuMxTHq9NDOe2zH0Tg96r9+G9zYqQ/spU4kkSkRPEtxziaUE
        WRCRK3sYI2qaVnrvpCDmyist5DKFswrbyeRhkpDEmnajIbYsqhwImCuG0SAqvQ==
Date:   Tue, 26 Apr 2022 15:59:18 +0200
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>
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
Message-ID: <20220426155918.4baeafd8@pc-19.home>
In-Reply-To: <YmMN37VjQNwhLDuX@lunn.ch>
References: <20220422180305.301882-1-maxime.chevallier@bootlin.com>
        <20220422180305.301882-2-maxime.chevallier@bootlin.com>
        <YmMN37VjQNwhLDuX@lunn.ch>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Andrew,

On Fri, 22 Apr 2022 22:19:43 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

Thanks for the review :)

> > +static int ipqess_axi_probe(struct platform_device *pdev)
> > +{
> > +	struct device_node *np = pdev->dev.of_node;
> > +	struct net_device *netdev;
> > +	phy_interface_t phy_mode;
> > +	struct resource *res;
> > +	struct ipqess *ess;
> > +	int i, err = 0;
> > +
> > +	netdev = devm_alloc_etherdev_mqs(&pdev->dev, sizeof(struct
> > ipqess),
> > +					 IPQESS_NETDEV_QUEUES,
> > +					 IPQESS_NETDEV_QUEUES);
> > +	if (!netdev)
> > +		return -ENOMEM;
> > +
> > +	ess = netdev_priv(netdev);
> > +	ess->netdev = netdev;
> > +	ess->pdev = pdev;
> > +	spin_lock_init(&ess->stats_lock);
> > +	SET_NETDEV_DEV(netdev, &pdev->dev);
> > +	platform_set_drvdata(pdev, netdev);  
> 
> ....
> 
> > +
> > +	ipqess_set_ethtool_ops(netdev);
> > +
> > +	err = register_netdev(netdev);
> > +	if (err)
> > +		goto err_out;  
> 
> Before register_netdev() even returns, your devices can be in use, the
> open callback called and packets sent. This is particularly true for
> NFS root. Which means any setup done after this is probably wrong.

Nice catch, thank you !

> > +
> > +	err = ipqess_hw_init(ess);
> > +	if (err)
> > +		goto err_out;
> > +
> > +	for (i = 0; i < IPQESS_NETDEV_QUEUES; i++) {
> > +		int qid;
> > +
> > +		netif_tx_napi_add(netdev, &ess->tx_ring[i].napi_tx,
> > +				  ipqess_tx_napi, 64);
> > +		netif_napi_add(netdev,
> > +			       &ess->rx_ring[i].napi_rx,
> > +			       ipqess_rx_napi, 64);
> > +
> > +		qid = ess->tx_ring[i].idx;
> > +		err = devm_request_irq(&ess->netdev->dev,
> > ess->tx_irq[qid],
> > +				       ipqess_interrupt_tx, 0,
> > +				       ess->tx_irq_names[qid],
> > +				       &ess->tx_ring[i]);
> > +		if (err)
> > +			goto err_out;
> > +
> > +		qid = ess->rx_ring[i].idx;
> > +		err = devm_request_irq(&ess->netdev->dev,
> > ess->rx_irq[qid],
> > +				       ipqess_interrupt_rx, 0,
> > +				       ess->rx_irq_names[qid],
> > +				       &ess->rx_ring[i]);
> > +		if (err)
> > +			goto err_out;
> > +	}  
> 
> All this should probably go before netdev_register().

I'll fix this for V2.

> > +static int ipqess_get_strset_count(struct net_device *netdev, int
> > sset) +{
> > +	switch (sset) {
> > +	case ETH_SS_STATS:
> > +		return ARRAY_SIZE(ipqess_stats);
> > +	default:
> > +		netdev_dbg(netdev, "%s: Invalid string set",
> > __func__);  
> 
> Unsupported would be better than invalid.

That's right, thanks

> > +		return -EOPNOTSUPP;
> > +	}
> > +}  
> 
>   Andrew

Best Regards,

Maxime

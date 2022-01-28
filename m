Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 765BE4A02E8
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 22:36:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348578AbiA1Vf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 16:35:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231977AbiA1Vfy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 16:35:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B36BC061714;
        Fri, 28 Jan 2022 13:35:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B19761EB5;
        Fri, 28 Jan 2022 21:35:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01502C340E7;
        Fri, 28 Jan 2022 21:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643405753;
        bh=42Qlj6xxhCnL3R9b8NONtGh7XV3bcSG/WVeh9CE2QwY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Nb4DsVRBFeiNPpDc9Zkl1OK9ealVU63qREhEjKh8AmcM0TtI8l6DdPfZNKH2ynQP3
         0i+ZHz949fGq/zCE+dec/fpK4GQlcNxlCu+yjsCfBNKcFEiPVeEHme41ALFI5cDgZx
         ksNHMUzw8YBRYVN2UfU/8SBaojZZevgQ9RbXv607ijzjBra53DuXJeC/M+qPlnwf3j
         e2EnimBA0XN42BlV00TEzuOLh52IcxYBC9gqnaeRT1BVjZskNvKG7qEo77lHoQU1lG
         SimqParRPUDL2LJjgF/RwH6nukhw1D7fTdnADi2ynNPVacM2raT6aRB4UKsceL7rqU
         3dQPKVx2iv6hA==
Date:   Fri, 28 Jan 2022 13:35:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joseph CHAMG <josright123@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, joseph_chang@davicom.com.tw,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com,
        andrew@lunn.ch, leon@kernel.org
Subject: Re: [PATCH v15, 2/2] net: Add dm9051 driver
Message-ID: <20220128133551.55c09fca@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220128064532.2654-3-josright123@gmail.com>
References: <20220128064532.2654-1-josright123@gmail.com>
        <20220128064532.2654-3-josright123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Jan 2022 14:45:32 +0800 Joseph CHAMG wrote:
> +/* Open network device
> + * Called when the network device is marked active, such as a user executing
> + * 'ifconfig up' on the device
> + */
> +static int dm9051_open(struct net_device *ndev)
> +{
> +	struct board_info *db = to_dm9051_board(ndev);
> +	struct spi_device *spi = db->spidev;
> +	int ret;
> +
> +	db->imr_all = IMR_PAR | IMR_PRM;
> +	db->rcr_all = RCR_DIS_LONG | RCR_DIS_CRC | RCR_RXEN;
> +	db->lcr_all = LMCR_MODE1;
> +
> +	netif_wake_queue(ndev);

This should be last, after the device is actually ready to transmit.

> +	ndev->irq = spi->irq; /* by dts */
> +	ret = request_threaded_irq(spi->irq, NULL, dm9051_rx_threaded_irq,
> +				   IRQF_TRIGGER_LOW | IRQF_ONESHOT,
> +				   ndev->name, db);
> +	if (ret < 0) {
> +		netdev_err(ndev, "failed to get irq\n");
> +		return ret;
> +	}
> +
> +	phy_support_sym_pause(db->phydev); /* Enable support of sym pause */
> +	phy_start(db->phydev); /* it enclose with mutex_lock/mutex_unlock */
> +
> +	ret = dm9051_all_start(db);
> +	if (ret) {
> +		phy_stop(db->phydev);
> +		free_irq(spi->irq, db);
> +		netif_stop_queue(ndev);
> +		return ret;
> +	}
> +
> +	/* init pause param FlowCtrl */
> +	db->eth_pause.rx_pause = true;
> +	db->eth_pause.tx_pause = true;
> +	db->eth_pause.autoneg = AUTONEG_DISABLE;
> +
> +	if (db->phydev->autoneg)
> +		db->eth_pause.autoneg = AUTONEG_ENABLE;
> +
> +	return 0;
> +}
> +
> +/* Close network device
> + * Called to close down a network device which has been active. Cancel any
> + * work, shutdown the RX and TX process and then place the chip into a low
> + * power state while it is not being used
> + */
> +static int dm9051_stop(struct net_device *ndev)
> +{
> +	struct board_info *db = to_dm9051_board(ndev);
> +
> +	phy_stop(db->phydev);
> +	free_irq(db->spidev->irq, db);
> +	netif_stop_queue(ndev);

I don't see anything draining &db->txq when the worker is stopped.
It should probably be drained here, after the queue is stopped.

> +	return dm9051_all_stop(db);
> +}

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04AD549F0C2
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 02:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345200AbiA1B56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 20:57:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345178AbiA1B55 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 20:57:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 494F4C061714;
        Thu, 27 Jan 2022 17:57:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA7F1B8241B;
        Fri, 28 Jan 2022 01:57:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15552C340E5;
        Fri, 28 Jan 2022 01:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643335073;
        bh=TysClmp2wYd6iFt2FNNZ24/T6VG/tjD1dbeLuKE4/wo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CxvkUWSZR1brvkZrepb8/Ywk1zcj9GpgN4/Z65wiidOiWUuT8p+azdMFi5qx6fGlR
         tdlczA+iArJ4ND88VFdeabfTLxaQUjEAV0BZ9ZgR7qk0cLuN5DWNST83phTnilWrZP
         lJtM7RcvXzPdkJn/3tszihq1wlRCHjfnN03cMG2kZlrR21TbHGDEN9GwBRMFwFemXi
         oQkFnVyz1KgmF5nT9MvDpGKttkUz4UDogi9fT0BBKBp9KCbqHMdjE7g22z0iEx3GS3
         UFIEbIs3Z5k+quO8/BriyW00MyrOyFTQwCHA5P1o/EgkHjKYfMJGf9TAT8Y7qYeKYQ
         1cnIR+RA51HoQ==
Date:   Thu, 27 Jan 2022 17:57:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joseph CHAMG <josright123@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, joseph_chang@davicom.com.tw,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com,
        andrew@lunn.ch, leon@kernel.org
Subject: Re: [PATCH v14, 2/2] net: Add dm9051 driver
Message-ID: <20220127175751.7ef239c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220127032701.23056-3-josright123@gmail.com>
References: <20220127032701.23056-1-josright123@gmail.com>
        <20220127032701.23056-3-josright123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Jan 2022 11:27:01 +0800 Joseph CHAMG wrote:
> Add davicom dm9051 spi ethernet driver, The driver work for the
> device platform which has the spi master
> 
> Signed-off-by: Joseph CHAMG <josright123@gmail.com>

> +/* event: write into the mac registers and eeprom directly
> + */
> +static int dm9051_set_mac_address(struct net_device *ndev, void *p)
> +{
> +	struct board_info *db = to_dm9051_board(ndev);
> +	int ret;
> +
> +	ret = eth_mac_addr(ndev, p);

You should not be using this helper if the write can fail. See what
this function does internally and:

 - put the eth_prepare_mac_addr_change() call here

> +	if (ret < 0)
> +		return ret;
> +
> +	ret = regmap_bulk_write(db->regmap_dmbulk, DM9051_PAR, ndev->dev_addr, ETH_ALEN);
> +	if (ret < 0)
> +		netif_err(db, drv, ndev, "%s: error %d bulk writing reg %02x, len %d\n",
> +			  __func__, ret, DM9051_PAR, ETH_ALEN);

 - put the eth_commit_mac_addr_change() call here

> +	return ret;
> +}

> +static void dm9051_netdev(struct net_device *ndev)
> +{
> +	ndev->mtu = 1500;

Unnecessary, ether_setup() does this already.

> +	ndev->if_port = IF_PORT_100BASET;

Why set this? The if_port API is a leftover from very old 10Mbit
Ethernet days, we have ethtool link APIs now.

> +	ndev->netdev_ops = &dm9051_netdev_ops;
> +	ndev->ethtool_ops = &dm9051_ethtool_ops;

Just inline there two lines into the caller and remove the helper.
dm9051_netdev() does not sound like a function that does setup.

> +}
> +
> +static int dm9051_map_init(struct spi_device *spi, struct board_info *db)
> +{
> +	/* create two regmap instances,
> +	 * run read/write and bulk_read/bulk_write individually,
> +	 * to resolve regmap execution confliction problem
> +	 */
> +	regconfigdm.lock_arg = db;
> +	db->regmap_dm = devm_regmap_init_spi(db->spidev, &regconfigdm);
> +
> +	if (IS_ERR(db->regmap_dm))
> +		return PTR_ERR_OR_ZERO(db->regmap_dm);
> +
> +	regconfigdmbulk.lock_arg = db;
> +	db->regmap_dmbulk = devm_regmap_init_spi(db->spidev, &regconfigdmbulk);
> +

Please remove all the empty lines between function call and error
checking the result.

> +	if (IS_ERR(db->regmap_dmbulk))
> +		return PTR_ERR_OR_ZERO(db->regmap_dmbulk);

Why _OR_ZERO() when you're in a IS_ERR() condition already?

> +	return 0;

> +	ret = devm_register_netdev(dev, ndev);
> +	if (ret) {
> +		dev_err(dev, "failed to register network device\n");
> +		kthread_stop(db->kwr_task_kw);
> +		phy_disconnect(db->phydev);
> +		return ret;
> +	}
> +
> +	skb_queue_head_init(&db->txq);

All the state must be initialized before netdev is registered,
otherwise another thread may immediately open the device and
start to transmit.

> +	return 0;
> +
> +err_stopthread:
> +	kthread_stop(db->kwr_task_kw);
> +	return ret;
> +}

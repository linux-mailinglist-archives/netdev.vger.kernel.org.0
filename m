Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED9C481EFE
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 19:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241600AbhL3SEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 13:04:13 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:45548 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241595AbhL3SEM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Dec 2021 13:04:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=UMW7lfaA3lveC8YHi/MarLbb/OntTpCkslN7sKw0i+8=; b=3PIR+QAvfGFO30RQY9o6kXSUpA
        jrKSqLfU3nbktJU0au1/FdZ9NTofj5qDXSM9zbaulIZrSb5FmHQi1NQjqb5pzmQOuCKvPertmG6u1
        jomxAOIZARHH+o/xpKaFGV3gfRXi/6PskIIVXJEbvhE5MMUqC6Sw/+RdW71vFMmYIK6E=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n2zma-000BKL-Gp; Thu, 30 Dec 2021 19:04:08 +0100
Date:   Thu, 30 Dec 2021 19:04:08 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dimitris Michailidis <d.michailidis@fungible.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 4/8] net/funeth: ethtool operations
Message-ID: <Yc30mG7tPQIT2HZK@lunn.ch>
References: <20211230163909.160269-1-dmichail@fungible.com>
 <20211230163909.160269-5-dmichail@fungible.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211230163909.160269-5-dmichail@fungible.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static void fun_get_pauseparam(struct net_device *netdev,
> +			       struct ethtool_pauseparam *pause)
> +{
> +	const struct funeth_priv *fp = netdev_priv(netdev);
> +	u8 active_pause = fp->active_fc;
> +
> +	pause->rx_pause = active_pause & FUN_PORT_CAP_RX_PAUSE;
> +	pause->tx_pause = active_pause & FUN_PORT_CAP_TX_PAUSE;
> +	pause->autoneg = !!(fp->advertising & FUN_PORT_CAP_AUTONEG);
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
> +	if (pause->autoneg && !(fp->advertising & FUN_PORT_CAP_AUTONEG))
> +		return -EINVAL;
> +	if (pause->tx_pause & !(fp->port_caps & FUN_PORT_CAP_TX_PAUSE))
> +		return -EINVAL;
> +	if (pause->rx_pause & !(fp->port_caps & FUN_PORT_CAP_RX_PAUSE))
> +		return -EINVAL;
> +

I _think_ this is wrong. pause->autoneg means we are autoneg'ing
pause, not that we are using auto-neg in general. The user can have
autoneg turned on, but force pause by setting pause->autoneg to False.
In that case, the pause->rx_pause and pause->tx_pause are given direct
to the MAC, not auto negotiated.

> +static void fun_get_wol(struct net_device *netdev, struct ethtool_wolinfo *wol)
> +{
> +	wol->supported = 0;
> +	wol->wolopts = 0;
> +}

Not required. If you don't provide the callback, the core will return
-EOPNOTSUPP.

> +static void fun_get_drvinfo(struct net_device *netdev,
> +			    struct ethtool_drvinfo *info)
> +{
> +	const struct funeth_priv *fp = netdev_priv(netdev);
> +
> +	strscpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
> +	strcpy(info->fw_version, "N/A");

Don't set it, if you have nothing useful to put in it.

      Andrew

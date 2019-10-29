Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB026E880E
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 13:24:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733120AbfJ2MYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 08:24:48 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40154 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727924AbfJ2MYr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Oct 2019 08:24:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=xMtT1n7AGoA6K6DL5+Z4fPFRQg3Fuamc+hw6KUzP67Y=; b=zNhKyuRv6c3/TY+bX38MgSdr+I
        7s0s1TX0blmE8PR+mGvXzmwk420bC2zv+5gvQ2ujcvf1luG4aE0+an1qdxxH5kHyExHXE/SD4qje/
        oAYbVWaRPpQctx5Z5VT5LTP0a2dxe/yxELgl1ovPZgjp0IwoY9CFbexUnZJ27lxHxwDk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iPQXu-00044i-Ft; Tue, 29 Oct 2019 13:24:22 +0100
Date:   Tue, 29 Oct 2019 13:24:22 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sekhar Nori <nsekhar@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Murali Karicheri <m-karicheri2@ti.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH v5 net-next 06/12] net: ethernet: ti: introduce cpsw
  switchdev based driver part 1 - dual-emac
Message-ID: <20191029122422.GL15259@lunn.ch>
References: <20191024100914.16840-1-grygorii.strashko@ti.com>
 <20191024100914.16840-7-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191024100914.16840-7-grygorii.strashko@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  config TI_CPTS
>  	bool "TI Common Platform Time Sync (CPTS) Support"
> -	depends on TI_CPSW || TI_KEYSTONE_NETCP || COMPILE_TEST
> +	depends on TI_CPSW || TI_KEYSTONE_NETCP || COMPILE_TEST || TI_CPSW_SWITCHDEV

nit picking, but COMPILE_TEST is generally last on the line.

> +/**
> + * cpsw_set_mc - adds multicast entry to the table if it's not added or deletes
> + * if it's not deleted
> + * @ndev: device to sync
> + * @addr: address to be added or deleted
> + * @vid: vlan id, if vid < 0 set/unset address for real device
> + * @add: add address if the flag is set or remove otherwise
> + */
> +static int cpsw_set_mc(struct net_device *ndev, const u8 *addr,
> +		       int vid, int add)
> +{
> +	struct cpsw_priv *priv = netdev_priv(ndev);
> +	struct cpsw_common *cpsw = priv->cpsw;
> +	int slave_no = cpsw_slave_index(cpsw, priv);
> +	int mask, flags, ret;

David will complain about reverse Christmas tree. You need to move
some of the assignments into the body of the function. This problems
happens a few times in the code.

> +static int cpsw_set_pauseparam(struct net_device *ndev,
> +			       struct ethtool_pauseparam *pause)
> +{
> +	struct cpsw_common *cpsw = ndev_to_cpsw(ndev);
> +	struct cpsw_priv *priv = netdev_priv(ndev);
> +
> +	priv->rx_pause = pause->rx_pause ? true : false;
> +	priv->tx_pause = pause->tx_pause ? true : false;
> +
> +	return phy_restart_aneg(cpsw->slaves[priv->emac_port - 1].phy);
> +}

You should look at the value of pause.autoneg.

> +static const struct devlink_ops cpsw_devlink_ops;

It would be nice to avoid this forward declaration.

> +static const struct devlink_param cpsw_devlink_params[] = {
> +	DEVLINK_PARAM_DRIVER(CPSW_DL_PARAM_ALE_BYPASS,
> +			     "ale_bypass", DEVLINK_PARAM_TYPE_BOOL,
> +			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
> +			     cpsw_dl_ale_ctrl_get, cpsw_dl_ale_ctrl_set, NULL),
> +};

Is this documented?

   Andrew

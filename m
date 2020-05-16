Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAC3A1D61D9
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 17:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbgEPPOQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 11:14:16 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35406 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726527AbgEPPOQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 May 2020 11:14:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+N3ofBZjdn7SbrBi6qDil1VdNsI2nuXn3YK00wVe5Ok=; b=4wnM1PFrcCkyn1aKfVTrKd42Nx
        8O2rbuQkVuCf8PLDUJGuYGEiXfffXLHNee/lKic5dFMIKOOTOlBx8Ikt1naE7jbldmi2Li89cgTFY
        u43pIYAEs7vph39Zrn9MVl+7FA5alJC08GWoyL6QnN14oD1tw2osQixyv+FbNHkgLMGU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jZyVv-002TcQ-B4; Sat, 16 May 2020 17:14:11 +0200
Date:   Sat, 16 May 2020 17:14:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luo bin <luobin9@huawei.com>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, luoxianjun@huawei.com,
        yin.yinshi@huawei.com, cloud.wangxiaoyun@huawei.com
Subject: Re: [PATCH net-next] hinic: add support to set and get pause param
Message-ID: <20200516151411.GT527401@lunn.ch>
References: <20200516020030.23017-1-luobin9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200516020030.23017-1-luobin9@huawei.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 16, 2020 at 02:00:30AM +0000, Luo bin wrote:
> +static int hinic_set_pauseparam(struct net_device *netdev,
> +				struct ethtool_pauseparam *pause)
> +{
> +	struct hinic_dev *nic_dev = netdev_priv(netdev);
> +	struct hinic_pause_config pause_info = {0};
> +	struct hinic_port_cap port_cap = {0};
> +	int err;
> +
> +	err = hinic_port_get_cap(nic_dev, &port_cap);
> +	if (err) {
> +		netif_err(nic_dev, drv, netdev,
> +			  "Failed to get port capability\n");
> +		return -EIO;
> +	}
> +
> +	if (pause->autoneg != port_cap.autoneg_state) {
> +		netif_err(nic_dev, drv, netdev,
> +			  "To change autoneg please use: ethtool -s <dev> autoneg <on|off>\n");
> +		return -EOPNOTSUPP;
> +	}

It is unclear at the moment if this is the correct thing to do. There
was a discussion this week involving Russell King and Doug Berger you
might want to read.

> +
> +	pause_info.auto_neg = pause->autoneg;
> +	pause_info.rx_pause = pause->rx_pause;
> +	pause_info.tx_pause = pause->tx_pause;
> +
> +	down(&nic_dev->hwdev->func_to_io.nic_cfg.cfg_lock);
> +	err = hinic_set_hw_pause_info(nic_dev->hwdev, &pause_info);
> +	if (err) {
> +		netif_err(nic_dev, drv, netdev, "Failed to set pauseparam\n");
> +		up(&nic_dev->hwdev->func_to_io.nic_cfg.cfg_lock);
> +		return err;
> +	}
> +	nic_dev->hwdev->func_to_io.nic_cfg.pause_set = true;
> +	nic_dev->hwdev->func_to_io.nic_cfg.auto_neg = pause->autoneg;
> +	nic_dev->hwdev->func_to_io.nic_cfg.rx_pause = pause->rx_pause;
> +	nic_dev->hwdev->func_to_io.nic_cfg.tx_pause = pause->tx_pause;
> +	up(&nic_dev->hwdev->func_to_io.nic_cfg.cfg_lock);
> +
> +	netif_info(nic_dev, drv, netdev, "Set pause options, tx: %s, rx: %s\n",
> +		   pause->tx_pause ? "on" : "off",
> +		   pause->rx_pause ? "on" : "off");

netif_dbg()

	Andrew

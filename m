Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05ACF265080
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 22:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726176AbgIJUVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 16:21:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56252 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725833AbgIJUUM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 16:20:12 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kGT2t-00E8FC-Be; Thu, 10 Sep 2020 22:19:51 +0200
Date:   Thu, 10 Sep 2020 22:19:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oded Gabbay <oded.gabbay@gmail.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        SW_Drivers@habana.ai, gregkh@linuxfoundation.org,
        davem@davemloft.net, kuba@kernel.org,
        Omer Shpigelman <oshpigelman@habana.ai>
Subject: Re: [PATCH 13/15] habanalabs/gaudi: Add ethtool support using
 coresight
Message-ID: <20200910201951.GG3354160@lunn.ch>
References: <20200910161126.30948-1-oded.gabbay@gmail.com>
 <20200910161126.30948-14-oded.gabbay@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200910161126.30948-14-oded.gabbay@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int gaudi_nic_get_link_ksettings(struct net_device *netdev,
> +					struct ethtool_link_ksettings *cmd)
> +{
> +	struct gaudi_nic_device **ptr = netdev_priv(netdev);
> +	struct gaudi_nic_device *gaudi_nic = *ptr;
> +	struct hl_device *hdev = gaudi_nic->hdev;
> +	u32 port = gaudi_nic->port, speed = gaudi_nic->speed;

Please go through the code and fixup Reverse Christmas tree.

> +
> +	cmd->base.speed = speed;
> +	cmd->base.duplex = DUPLEX_FULL;
> +
> +	ethtool_link_ksettings_zero_link_mode(cmd, supported);
> +	ethtool_link_ksettings_zero_link_mode(cmd, advertising);
> +
> +	ethtool_add_mode(cmd, supported, 100000baseCR4_Full);
> +	ethtool_add_mode(cmd, supported, 100000baseSR4_Full);
> +	ethtool_add_mode(cmd, supported, 100000baseKR4_Full);
> +	ethtool_add_mode(cmd, supported, 100000baseLR4_ER4_Full);
> +
> +	ethtool_add_mode(cmd, supported, 50000baseSR2_Full);
> +	ethtool_add_mode(cmd, supported, 50000baseCR2_Full);
> +	ethtool_add_mode(cmd, supported, 50000baseKR2_Full);
> +
> +	if (speed == SPEED_100000) {
> +		ethtool_add_mode(cmd, advertising, 100000baseCR4_Full);
> +		ethtool_add_mode(cmd, advertising, 100000baseSR4_Full);
> +		ethtool_add_mode(cmd, advertising, 100000baseKR4_Full);
> +		ethtool_add_mode(cmd, advertising, 100000baseLR4_ER4_Full);
> +
> +		cmd->base.port = PORT_FIBRE;
> +
> +		ethtool_add_mode(cmd, supported, FIBRE);
> +		ethtool_add_mode(cmd, advertising, FIBRE);
> +
> +		ethtool_add_mode(cmd, supported, Backplane);
> +		ethtool_add_mode(cmd, advertising, Backplane);
> +	} else if (speed == SPEED_50000) {
> +		ethtool_add_mode(cmd, advertising, 50000baseSR2_Full);
> +		ethtool_add_mode(cmd, advertising, 50000baseCR2_Full);
> +		ethtool_add_mode(cmd, advertising, 50000baseKR2_Full);
> +	} else {
> +		dev_err(hdev->dev, "unknown speed %d, port %d\n", speed, port);
> +		return -EFAULT;
> +	}
> +
> +	ethtool_add_mode(cmd, supported, Autoneg);
> +
> +	if (gaudi_nic->auto_neg_enable) {
> +		ethtool_add_mode(cmd, advertising, Autoneg);
> +		cmd->base.autoneg = AUTONEG_ENABLE;
> +		if (gaudi_nic->auto_neg_resolved)
> +			ethtool_add_mode(cmd, lp_advertising, Autoneg);
> +	} else {
> +		cmd->base.autoneg = AUTONEG_DISABLE;
> +	}
> +
> +	ethtool_add_mode(cmd, supported, Pause);
> +
> +	if (gaudi_nic->pfc_enable)
> +		ethtool_add_mode(cmd, advertising, Pause);
> +
> +	return 0;
> +}
> +
> +static int gaudi_nic_set_link_ksettings(struct net_device *netdev,
> +				const struct ethtool_link_ksettings *cmd)
> +{
> +	struct gaudi_nic_device **ptr = netdev_priv(netdev);
> +	struct gaudi_nic_device *gaudi_nic = *ptr;
> +	struct hl_device *hdev = gaudi_nic->hdev;
> +	u32 port = gaudi_nic->port;
> +	int rc = 0, speed = cmd->base.speed;
> +	bool auto_neg = cmd->base.autoneg == AUTONEG_ENABLE;

It appears you only support speed and auto_neg. You should check that
all other things which could be configured are empty, e.g. none of the
bits are set in cmd->link_modes.advertising. If you are requested to
configure something which is not supported, you need to return
-EOPNOTSUPP.

	Andrew

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C191A421B5D
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 03:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbhJEBD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 21:03:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:51504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229549AbhJEBD0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 21:03:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5677361207;
        Tue,  5 Oct 2021 01:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633395696;
        bh=r7dTZFXr2HMyNM8EVV6b9Hg3K9jOI5YSw2Ej9MxJBxo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=utri28NrgT5Tqt597H+9BF5ZI9pbsMlek8d8X/HyZUfVMDsnSJtVyBUnwX/ST3nhG
         SIcdCA2KUWbMcVb42kqIuRzceUS0dQpevBzWrH4+lb/g0MRsL6mTyIkkWwBRA1UhAC
         fJkl2XHj2LJJtId7rz96hk6U2c4DoCjgIJwFRLfbv77jpzGC1dccuG+WGWgn6mnY3H
         Ym+5XxuB9bEwTYKSeCciT/JQt24FlsHaXvlYHxWlMAUKpBQrrlvlBfMXuR1foIbwuk
         Iu5nPS0gDD0JYQqGbZ6hR1vta4aurNHnfm/UdqqY4jybFiwZC8cP7OHK0Yd7itKLm4
         xk208Pfjjk1zw==
Date:   Mon, 4 Oct 2021 18:01:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, jacob.e.keller@intel.com,
        jiri@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 1/6] ethtool: Add ability to control
 transceiver modules' power mode
Message-ID: <20211004180135.55759be4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211003073219.1631064-2-idosch@idosch.org>
References: <20211003073219.1631064-1-idosch@idosch.org>
        <20211003073219.1631064-2-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  3 Oct 2021 10:32:14 +0300 Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Add a pair of new ethtool messages, 'ETHTOOL_MSG_MODULE_SET' and
> 'ETHTOOL_MSG_MODULE_GET', that can be used to control transceiver
> modules parameters and retrieve their status.

Acked-by: Jakub Kicinski <kuba@kernel.org>

Couple of take it or leave it comments again, if you prefer to leave as
is that's fine.

> +enum ethtool_module_power_mode_policy {
> +	ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH,
> +	ETHTOOL_MODULE_POWER_MODE_POLICY_AUTO,
> +};

I see you left this starting from 0, and we still need a valid bit,
granted just internal to the core.

Would we not need a driver-facing valid bit later on when we extend 
the module API to control more params?  Can't there be drivers which
implement power but don't support the mode policy?

> +static int module_set_power_mode(struct net_device *dev, struct nlattr **tb,
> +				 bool *p_mod, struct netlink_ext_ack *extack)
> +{
> +	struct ethtool_module_power_mode_params power = {};
> +	struct ethtool_module_power_mode_params power_new;
> +	const struct ethtool_ops *ops = dev->ethtool_ops;
> +	int ret;
> +
> +	if (!tb[ETHTOOL_A_MODULE_POWER_MODE_POLICY])
> +		return 0;

Feels a little old school to allow set with no attrs, now that we 
do strict validation on attrs across netlink.  What's the reason?

> +	if (!ops->get_module_power_mode || !ops->set_module_power_mode) {
> +		NL_SET_ERR_MSG_ATTR(extack,
> +				    tb[ETHTOOL_A_MODULE_POWER_MODE_POLICY],
> +				    "Setting power mode policy is not supported by this device");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	power_new.policy = nla_get_u8(tb[ETHTOOL_A_MODULE_POWER_MODE_POLICY]);
> +	ret = ops->get_module_power_mode(dev, &power, extack);
> +	if (ret < 0)
> +		return ret;
> +	*p_mod = power_new.policy != power.policy;
> +
> +	return ops->set_module_power_mode(dev, &power_new, extack);

Why still call set if *p_mod == false?

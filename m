Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1259421AD2
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 01:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233952AbhJDXqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 19:46:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:36154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229703AbhJDXqF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 19:46:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7F3F61381;
        Mon,  4 Oct 2021 23:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633391055;
        bh=eXQTxp06FhapF/t+dZjCHKv+wufhogFdqMBNGl5+xd4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pI2/QjWWUUNLdS9SbBBbh/vEB+DOUuqx2idvkn6QJNrMg7RFyrCqW84mY4g5gBe/o
         TDMBXWyyWG7NinXQxd0FNp/ovLSPL38nKRQwLRtFQ+dRLuyTvu+yHuqZ1456hhe6uG
         oNH6czZNRQXfYJN5P6ssFKuw+Np+WvNSQ/j9G0ZUutH97qsEaTtm8b7ggkZctuNabe
         WsskH+BygFXCzC0vLamRofpcPJ5BqRG1XxA+GQgSvfAFBZ/wPk5N2TwClUT9YjrvVI
         GPOXxUlY00bsxJbypwjfPv6wM7MVuHJHLo1QEBRSCzCR1XwKzFXz5xPoW+91xQUnPJ
         VzK97iZYQusLw==
Date:   Mon, 4 Oct 2021 16:44:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Leon Romanovsky <leonro@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        mlxsw@nvidia.com, Moshe Shemesh <moshe@nvidia.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Shay Drory <shayd@nvidia.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>
Subject: Re: [PATCH net-next v2 3/5] devlink: Allow set specific ops
 callbacks dynamically
Message-ID: <20211004164413.60e9ce80@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <92971648bcad41d095d12f5296246fc44ab8f5c7.1633284302.git.leonro@nvidia.com>
References: <cover.1633284302.git.leonro@nvidia.com>
        <92971648bcad41d095d12f5296246fc44ab8f5c7.1633284302.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  3 Oct 2021 21:12:04 +0300 Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Introduce new devlink call to set specific ops callback during
> device initialization phase after devlink_alloc() is already
> called.
> 
> This allows us to set specific ops based on device property which
> is not known at the beginning of driver initialization.
> 
> For the sake of simplicity, this API lacks any type of locking and
> needs to be called before devlink_register() to make sure that no
> parallel access to the ops is possible at this stage.

The fact that it's not registered does not mean that the callbacks
won't be invoked. Look at uses of devlink_compat_flash_update().

> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index 4e484afeadea..25c2aa2b35cd 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -53,7 +53,7 @@ struct devlink {
>  	struct list_head trap_list;
>  	struct list_head trap_group_list;
>  	struct list_head trap_policer_list;
> -	const struct devlink_ops *ops;
> +	struct devlink_ops ops;

Security people like ops to live in read-only memory. You're making
them r/w for every devlink instance now.

>  	struct xarray snapshot_ids;
>  	struct devlink_dev_stats stats;
>  	struct device *dev;

> +/**
> + *	devlink_set_ops - Set devlink ops dynamically
> + *
> + *	@devlink: devlink
> + *	@ops: devlink ops to set
> + *
> + *	This interface allows us to set ops based on device property
> + *	which is known after devlink_alloc() was already called.
> + *
> + *	This call sets fields that are not initialized yet and ignores
> + *	already set fields.
> + *
> + *	It should be called before devlink_register(), so doesn't have any
> + *	protection from concurent access.
> + */
> +void devlink_set_ops(struct devlink *devlink, const struct devlink_ops *ops)
> +{
> +	struct devlink_ops *dev_ops = &devlink->ops;
> +
> +	WARN_ON(!devlink_reload_actions_valid(ops));
> +	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
> +
> +#define SET_DEVICE_OP(ptr, op, name)                                           \
> +	do {                                                                   \
> +		if ((op)->name)                                                \
> +			if (!((ptr)->name))                                    \
> +				(ptr)->name = (op)->name;                      \
> +	} while (0)
> +
> +	/* Keep sorte alphabetically for readability */
> +	SET_DEVICE_OP(dev_ops, ops, eswitch_encap_mode_get);
> +	SET_DEVICE_OP(dev_ops, ops, eswitch_encap_mode_set);
> +	SET_DEVICE_OP(dev_ops, ops, eswitch_inline_mode_get);
> +	SET_DEVICE_OP(dev_ops, ops, eswitch_inline_mode_set);
> +	SET_DEVICE_OP(dev_ops, ops, eswitch_mode_get);
> +	SET_DEVICE_OP(dev_ops, ops, eswitch_mode_set);
> +	SET_DEVICE_OP(dev_ops, ops, flash_update);
> +	SET_DEVICE_OP(dev_ops, ops, info_get);
> +	SET_DEVICE_OP(dev_ops, ops, port_del);
> +	SET_DEVICE_OP(dev_ops, ops, port_fn_state_get);
> +	SET_DEVICE_OP(dev_ops, ops, port_fn_state_set);
> +	SET_DEVICE_OP(dev_ops, ops, port_function_hw_addr_get);
> +	SET_DEVICE_OP(dev_ops, ops, port_function_hw_addr_set);
> +	SET_DEVICE_OP(dev_ops, ops, port_new);
> +	SET_DEVICE_OP(dev_ops, ops, port_split);
> +	SET_DEVICE_OP(dev_ops, ops, port_type_set);
> +	SET_DEVICE_OP(dev_ops, ops, port_unsplit);
> +	SET_DEVICE_OP(dev_ops, ops, rate_leaf_parent_set);
> +	SET_DEVICE_OP(dev_ops, ops, rate_leaf_tx_max_set);
> +	SET_DEVICE_OP(dev_ops, ops, rate_leaf_tx_share_set);
> +	SET_DEVICE_OP(dev_ops, ops, rate_node_del);
> +	SET_DEVICE_OP(dev_ops, ops, rate_node_new);
> +	SET_DEVICE_OP(dev_ops, ops, rate_node_parent_set);
> +	SET_DEVICE_OP(dev_ops, ops, rate_node_tx_max_set);
> +	SET_DEVICE_OP(dev_ops, ops, rate_node_tx_share_set);
> +	SET_DEVICE_OP(dev_ops, ops, reload_actions);
> +	SET_DEVICE_OP(dev_ops, ops, reload_down);
> +	SET_DEVICE_OP(dev_ops, ops, reload_limits);
> +	SET_DEVICE_OP(dev_ops, ops, reload_up);
> +	SET_DEVICE_OP(dev_ops, ops, sb_occ_max_clear);
> +	SET_DEVICE_OP(dev_ops, ops, sb_occ_port_pool_get);
> +	SET_DEVICE_OP(dev_ops, ops, sb_occ_snapshot);
> +	SET_DEVICE_OP(dev_ops, ops, sb_occ_tc_port_bind_get);
> +	SET_DEVICE_OP(dev_ops, ops, sb_pool_get);
> +	SET_DEVICE_OP(dev_ops, ops, sb_pool_set);
> +	SET_DEVICE_OP(dev_ops, ops, sb_port_pool_get);
> +	SET_DEVICE_OP(dev_ops, ops, sb_port_pool_set);
> +	SET_DEVICE_OP(dev_ops, ops, sb_tc_pool_bind_get);
> +	SET_DEVICE_OP(dev_ops, ops, sb_tc_pool_bind_set);
> +	SET_DEVICE_OP(dev_ops, ops, supported_flash_update_params);
> +	SET_DEVICE_OP(dev_ops, ops, trap_action_set);
> +	SET_DEVICE_OP(dev_ops, ops, trap_drop_counter_get);
> +	SET_DEVICE_OP(dev_ops, ops, trap_fini);
> +	SET_DEVICE_OP(dev_ops, ops, trap_group_action_set);
> +	SET_DEVICE_OP(dev_ops, ops, trap_group_init);
> +	SET_DEVICE_OP(dev_ops, ops, trap_group_set);
> +	SET_DEVICE_OP(dev_ops, ops, trap_init);
> +	SET_DEVICE_OP(dev_ops, ops, trap_policer_counter_get);
> +	SET_DEVICE_OP(dev_ops, ops, trap_policer_fini);
> +	SET_DEVICE_OP(dev_ops, ops, trap_policer_init);
> +	SET_DEVICE_OP(dev_ops, ops, trap_policer_set);
> +
> +#undef SET_DEVICE_OP
> +}
> +EXPORT_SYMBOL_GPL(devlink_set_ops);

I still don't like this. IMO using feature bits to dynamically mask-off
capabilities has much better properties. We already have static caps
in devlink_ops (first 3 members), we should build on top of that. 

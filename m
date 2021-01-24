Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6852301C50
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 14:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725918AbhAXNqh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 08:46:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:48286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725268AbhAXNqg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Jan 2021 08:46:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57488227BF;
        Sun, 24 Jan 2021 13:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611495955;
        bh=8SKR/G8hww3sahSCUEdv19IP/CnswdwvSZfUon47hoM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PCEuPA0rqStT4mgsklOrINGz3tu50k5eiGiiRbM0D1uu6G78KGX7lFNp15lf2dQq0
         VcsIycdrcPagT6iuFXkWgfb43+hWGT580cfxhwBqZ+rFAZ/ytu/n+4gbXIK/m616dS
         tCk4M1ElhKkEhLWhb9tglFyK1/14s8fbfedWpxpPBu9bp/jCBAn0PsKA2nU2vMvcVW
         UcgXczdBUqhh4szwl+68NU33QMkqVJN3/1Bu9Gqd9kgarlpNCR4wP87NjP2SUutSCV
         4SBSfn250/WfvHKbRngyKU/nz8o+4nR2YyiUJFpihjD2wRLg4gYtXmoX8RHV9SJRt1
         fc+gtRVM54Bww==
Date:   Sun, 24 Jan 2021 15:45:51 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Shiraz Saleem <shiraz.saleem@intel.com>
Cc:     dledford@redhat.com, jgg@nvidia.com, kuba@kernel.org,
        davem@davemloft.net, linux-rdma@vger.kernel.org,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        david.m.ertman@intel.com, anthony.l.nguyen@intel.com,
        Mustafa Ismail <mustafa.ismail@intel.com>
Subject: Re: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
 implement private channel OPs
Message-ID: <20210124134551.GB5038@unreal>
References: <20210122234827.1353-1-shiraz.saleem@intel.com>
 <20210122234827.1353-8-shiraz.saleem@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210122234827.1353-8-shiraz.saleem@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 05:48:12PM -0600, Shiraz Saleem wrote:
> From: Mustafa Ismail <mustafa.ismail@intel.com>
>
> Register irdma as an auxiliary driver which can attach to auxiliary RDMA
> devices from Intel PCI netdev drivers i40e and ice. Implement the private
> channel ops, add basic devlink support in the driver and register net
> notifiers.

Devlink part in "the RDMA client" is interesting thing.

The idea behind auxiliary bus was that PCI logic will stay at one place
and devlink considered as the tool to manage that.

In current form every client is going to get independent devlink instance.

<...>

> +static int irdma_devlink_rsrc_limits_validate(struct devlink *dl, u32 id,
> +					      union devlink_param_value val,
> +					      struct netlink_ext_ack *extack)
> +{
> +	u8 value = val.vu8;
> +
> +	if (value > 7) {
> +		NL_SET_ERR_MSG_MOD(extack, "resource limits selector range is (0-7)");
> +		return -ERANGE;
> +	}
> +
> +	return 0;
> +}
> +
> +static int irdma_devlink_enable_roce_validate(struct devlink *dl, u32 id,
> +					      union devlink_param_value val,
> +					      struct netlink_ext_ack *extack)
> +{
> +	struct irdma_dl_priv *priv = devlink_priv(dl);
> +	bool value = val.vbool;
> +
> +	if (value && priv->drvdata->hw_ver == IRDMA_GEN_1) {
> +		NL_SET_ERR_MSG_MOD(extack, "RoCE not supported on device");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	return 0;
> +}
> +
> +static int irdma_devlink_upload_ctx_get(struct devlink *devlink, u32 id,
> +					struct devlink_param_gset_ctx *ctx)
> +{
> +	ctx->val.vbool = irdma_upload_context;
> +	return 0;
> +}
> +
> +static int irdma_devlink_upload_ctx_set(struct devlink *devlink, u32 id,
> +					struct devlink_param_gset_ctx *ctx)
> +{
> +	irdma_upload_context = ctx->val.vbool;
> +	return 0;
> +}
> +
> +enum irdma_dl_param_id {
> +	IRDMA_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
> +	IRDMA_DEVLINK_PARAM_ID_LIMITS_SELECTOR,
> +	IRDMA_DEVLINK_PARAM_ID_UPLOAD_CONTEXT,
> +};
> +
> +static const struct devlink_param irdma_devlink_params[] = {
> +	DEVLINK_PARAM_DRIVER(IRDMA_DEVLINK_PARAM_ID_LIMITS_SELECTOR,
> +			     "resource_limits_selector", DEVLINK_PARAM_TYPE_U8,
> +			      BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
> +			      NULL, NULL, irdma_devlink_rsrc_limits_validate),
> +	DEVLINK_PARAM_DRIVER(IRDMA_DEVLINK_PARAM_ID_UPLOAD_CONTEXT,
> +			     "upload_context", DEVLINK_PARAM_TYPE_BOOL,
> +			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
> +			     irdma_devlink_upload_ctx_get,
> +			     irdma_devlink_upload_ctx_set, NULL),
> +	DEVLINK_PARAM_GENERIC(ENABLE_ROCE, BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
> +			      NULL, NULL, irdma_devlink_enable_roce_validate),
> +};

RoCE enable knob is understandable, but others are not explained.

> +
> +static int irdma_devlink_reload_down(struct devlink *devlink, bool netns_change,
> +				     enum devlink_reload_action action,
> +				     enum devlink_reload_limit limit,
> +				     struct netlink_ext_ack *extack)
> +{
> +	struct irdma_dl_priv *priv = devlink_priv(devlink);
> +	struct auxiliary_device *aux_dev = to_auxiliary_dev(devlink->dev);
> +
> +	if (netns_change) {
> +		NL_SET_ERR_MSG_MOD(extack, "Namespace change is not supported");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	priv->drvdata->deinit_dev(aux_dev);
> +
> +	return 0;
> +}
> +
> +static int irdma_devlink_reload_up(struct devlink *devlink, enum devlink_reload_action action,
> +				   enum devlink_reload_limit limit, u32 *actions_performed,
> +				   struct netlink_ext_ack *extack)
> +{
> +	struct irdma_dl_priv *priv = devlink_priv(devlink);
> +	struct auxiliary_device *aux_dev = to_auxiliary_dev(devlink->dev);
> +	union devlink_param_value saved_value;
> +	int ret;
> +
> +	*actions_performed = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT);
> +
> +	devlink_param_driverinit_value_get(devlink,
> +				DEVLINK_PARAM_GENERIC_ID_ENABLE_ROCE,
> +				&saved_value);
> +	priv->roce_ena = saved_value.vbool;
> +	devlink_param_driverinit_value_get(devlink,
> +				IRDMA_DEVLINK_PARAM_ID_LIMITS_SELECTOR,
> +				&saved_value);
> +	priv->limits_sel = saved_value.vbool;
> +
> +	ret = priv->drvdata->init_dev(aux_dev);
> +
> +	return ret;
> +}
> +
> +static const struct devlink_ops irdma_devlink_ops = {
> +	.reload_up = irdma_devlink_reload_up,
> +	.reload_down = irdma_devlink_reload_down,
> +	.reload_actions = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT),
> +};

So the plan is that every client will implement same devlink reload logic?

Thanks

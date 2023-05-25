Return-Path: <netdev+bounces-5219-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E401D710425
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 06:48:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A5AC31C20D41
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 04:48:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E71AE1FBE;
	Thu, 25 May 2023 04:48:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A55199
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 04:48:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B87FC433D2;
	Thu, 25 May 2023 04:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684990093;
	bh=5/4bG7+Ol+YnYcb/OH+LbuO142jME624yhP5aymtUNE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=MxH1vWZ+uQfIMPEp4awerv5W0YY+PQaPuFQpTayAj/vKNgkkxgyF3PyfhNARsTsEE
	 VODZDc86K/7mWicqePaoxA12XjlUHMtUVeFa+dgB39Xr+vqzsGl6EVd7662hMhiPpH
	 VeuFwQvNXS+bezBCJSlEYBkzVKRubp7j/s3cvRdQ6VpAs7qX31L1CDNyn6NtPf1Ahd
	 pxL9kz07MfhK8Ejmls/soTGrlvw2Lq6KYkF9MHT9ds+Y+O5BqJaWiZGxo98yy/e89G
	 fF/GYW1uu0ddfL7o3qsgUy02s2BwwaDvkvQqnUS1ka2O8+Ny9bBdOVEvhdJhi3D/AY
	 0pgFyva7qcdsw==
Date: Wed, 24 May 2023 21:48:11 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jiri Pirko <jiri@resnulli.us>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, leon@kernel.org, saeedm@nvidia.com, moshe@nvidia.com,
 jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com, tariqt@nvidia.com,
 idosch@nvidia.com, petrm@nvidia.com, simon.horman@corigine.com,
 ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
 michal.wilczynski@intel.com, jacob.e.keller@intel.com
Subject: Re: [patch net-next 01/15] devlink: introduce port ops placeholder
Message-ID: <20230524214811.0fb25930@kernel.org>
In-Reply-To: <20230524121836.2070879-2-jiri@resnulli.us>
References: <20230524121836.2070879-1-jiri@resnulli.us>
	<20230524121836.2070879-2-jiri@resnulli.us>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 24 May 2023 14:18:22 +0200 Jiri Pirko wrote:
> @@ -6799,6 +6799,7 @@ EXPORT_SYMBOL_GPL(devlink_port_fini);
>   * @devlink: devlink
>   * @devlink_port: devlink port
>   * @port_index: driver-specific numerical identifier of the port
> + * @ops: port ops
>   *
>   * Register devlink port with provided port index. User can use
>   * any indexing, even hw-related one. devlink_port structure
> @@ -6806,9 +6807,10 @@ EXPORT_SYMBOL_GPL(devlink_port_fini);
>   * Note that the caller should take care of zeroing the devlink_port
>   * structure.
>   */
> -int devl_port_register(struct devlink *devlink,
> -		       struct devlink_port *devlink_port,
> -		       unsigned int port_index)
> +int devl_port_register_with_ops(struct devlink *devlink,
> +				struct devlink_port *devlink_port,
> +				unsigned int port_index,
> +				const struct devlink_port_ops *ops)
>  {
>  	int err;

function name in kdoc needs an update

> @@ -6819,6 +6821,7 @@ int devl_port_register(struct devlink *devlink,
>  	devlink_port_init(devlink, devlink_port);
>  	devlink_port->registered = true;
>  	devlink_port->index = port_index;
> +	devlink_port->ops = ops;
>  	spin_lock_init(&devlink_port->type_lock);
>  	INIT_LIST_HEAD(&devlink_port->reporter_list);
>  	err = xa_insert(&devlink->ports, port_index, devlink_port, GFP_KERNEL);
> @@ -6830,7 +6833,7 @@ int devl_port_register(struct devlink *devlink,
>  	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_NEW);
>  	return 0;
>  }
> -EXPORT_SYMBOL_GPL(devl_port_register);
> +EXPORT_SYMBOL_GPL(devl_port_register_with_ops);
>  
>  /**
>   *	devlink_port_register - Register devlink port
> @@ -6838,6 +6841,7 @@ EXPORT_SYMBOL_GPL(devl_port_register);
>   *	@devlink: devlink
>   *	@devlink_port: devlink port
>   *	@port_index: driver-specific numerical identifier of the port
> + *	@ops: port ops
>   *
>   *	Register devlink port with provided port index. User can use
>   *	any indexing, even hw-related one. devlink_port structure
> @@ -6847,18 +6851,20 @@ EXPORT_SYMBOL_GPL(devl_port_register);
>   *
>   *	Context: Takes and release devlink->lock <mutex>.
>   */
> -int devlink_port_register(struct devlink *devlink,
> -			  struct devlink_port *devlink_port,
> -			  unsigned int port_index)
> +int devlink_port_register_with_ops(struct devlink *devlink,
> +				   struct devlink_port *devlink_port,
> +				   unsigned int port_index,
> +				   const struct devlink_port_ops *ops)

same here.

BTW do we need to provide the "devlink_*" form of this API or can we
use this as an opportunity to move everyone to devl_*. Even if the
driver just wraps the call with devl_lock(), sooner or later people
will coalesce the locking in the drivers, I hope.
-- 
pw-bot: cr


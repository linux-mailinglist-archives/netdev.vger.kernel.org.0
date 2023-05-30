Return-Path: <netdev+bounces-6500-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C87E8716B2F
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 19:34:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 61BA01C20C7D
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 17:34:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C59021098;
	Tue, 30 May 2023 17:34:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB1161F92D
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 17:34:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C59A7C433D2;
	Tue, 30 May 2023 17:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685468042;
	bh=nd8faKKXh+xeGc/3q/sVd8Nj8apsSb5cRqMVkFlXfPc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=J6L3mb7L7VWSXIlBlg5NJTmnaIClv4ztaRAfR7prFU8M9814MJ0qzU/hC9ux1tKpA
	 7yhOT2S7DOJi9/FlAhRRZz02TJJg4AxcWqWZnHkL2vA7TEjWTODfcYbPm6NinMGHlv
	 nQqGzV9Ukfm/WcbHuspca3x4wRqI4s5ZQYsqHAmpFjMNXh7HJMQ1pn2wiqA0edaMNG
	 lKuWejJU56gJFNfL7C0idizXe2eZLc0PRfb78HDsxUJtQv7cyzSTkfIt0vOMxwBu6g
	 NOhyBc7XpuOYx3Y5bEb3nF8xBVdO2kal8IL2fgavFxkRi1ZRf6W2bp2iuuEKKed2e+
	 kUDZLJ4rnARyg==
Date: Tue, 30 May 2023 10:34:00 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jiri Pirko <jiri@resnulli.us>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, leon@kernel.org, saeedm@nvidia.com, moshe@nvidia.com,
 jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com, tariqt@nvidia.com,
 idosch@nvidia.com, petrm@nvidia.com, simon.horman@corigine.com,
 ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
 michal.wilczynski@intel.com, jacob.e.keller@intel.com
Subject: Re: [patch net-next v2 14/15] devlink: move port_del() to
 devlink_port_ops
Message-ID: <20230530103400.3d0be965@kernel.org>
In-Reply-To: <ZHWep0dU9gCGJW0d@nanopsycho>
References: <20230526102841.2226553-1-jiri@resnulli.us>
	<20230526102841.2226553-15-jiri@resnulli.us>
	<20230526211008.7b06ac3e@kernel.org>
	<ZHG0dSuA7s0ggN0o@nanopsycho>
	<20230528233334.77dc191d@kernel.org>
	<ZHRi0qZD/Hsjn0Fq@nanopsycho>
	<20230529184119.414d62f3@kernel.org>
	<ZHWep0dU9gCGJW0d@nanopsycho>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 30 May 2023 08:58:47 +0200 Jiri Pirko wrote:
> >>  	.port_fn_hw_addr_get = mlx5_devlink_port_fn_hw_addr_get,
> >>  	.port_fn_hw_addr_set = mlx5_devlink_port_fn_hw_addr_set,
> >>  	.port_fn_roce_get = mlx5_devlink_port_fn_roce_get,  
> >
> >Is it okay if we deferred the port_del() patch until there's some
> >clear benefit?  
> 
> Well actually, there is a clear benefit even in this patchset:
> 
> We have 2 flavours of ports each with different ops in mlx5:
> VF:
> static const struct devlink_port_ops mlx5_esw_dl_port_ops = {
>         .port_fn_hw_addr_get = mlx5_devlink_port_fn_hw_addr_get,
>         .port_fn_hw_addr_set = mlx5_devlink_port_fn_hw_addr_set,
>         .port_fn_roce_get = mlx5_devlink_port_fn_roce_get,
>         .port_fn_roce_set = mlx5_devlink_port_fn_roce_set,
>         .port_fn_migratable_get = mlx5_devlink_port_fn_migratable_get,
>         .port_fn_migratable_set = mlx5_devlink_port_fn_migratable_set,
> };
> 
> SF:
> static const struct devlink_port_ops mlx5_esw_dl_sf_port_ops = {
>         .port_del = mlx5_devlink_sf_port_del,
>         .port_fn_hw_addr_get = mlx5_devlink_port_fn_hw_addr_get,
>         .port_fn_hw_addr_set = mlx5_devlink_port_fn_hw_addr_set,
>         .port_fn_roce_get = mlx5_devlink_port_fn_roce_get,
>         .port_fn_roce_set = mlx5_devlink_port_fn_roce_set,
>         .port_fn_state_get = mlx5_devlink_sf_port_fn_state_get,
>         .port_fn_state_set = mlx5_devlink_sf_port_fn_state_set,
> };
> 
> You can see that the port_del() op is supported only on the SF flavour.
> VF does not support it and therefore port_del() is not defined on it.

This is what I started thinking as well yesterday. Is there any reason
to delete a port which isn't an SF? Similarly - is there any reason to
delete a port which wasn't allocated via port_new?

> Without this patch, I would have to have a helper
> mlx5_devlink_port_del() that would check if the port is SF and call
> mlx5_devlink_sf_port_del() in that case. This patch reduces the
> boilerplate.

... Because if port_del can only happen on port_new'd ports, we should
try to move that check into the core. It'd prevent misuse of the API.

> Btw if you look at the cmd line api, it also aligns:
> $ devlink port add pci/0000:08:00.0 flavour pcisf pfnum 0 sfnum 101
> pci/0000:08:00.0/32768: type eth netdev eth4 flavour pcisf controller 0 pfnum 0 sfnum 101 splittable false
>   function:
>     hw_addr 00:00:00:00:00:00 state inactive opstate detached
> $ devlink port del pci/0000:08:00.0/32768
> 
> You use pci/0000:08:00.0/32768 as a delete handle.
> 
> port_del() is basically an object destructor. Would it perhaps help to
> rename is to .port_destructor()? That would somehow ease the asymmetry
> :) IDK. I would leave the name as it is a and move to port_ops.

Meh.


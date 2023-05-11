Return-Path: <netdev+bounces-1621-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 10A596FE905
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 03:01:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 145AF28151A
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 01:01:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E1BF622;
	Thu, 11 May 2023 01:01:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D59D8620
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 01:01:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 272DAC433D2;
	Thu, 11 May 2023 01:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683766882;
	bh=MkcYzcUlUC36xOc0e6qBy4rObCDDjycwsZTq318YXAI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=UVMJBJV/+BNsc1sB708id/xzE4ASfowBop1WYePXp81lI8KknUMkyRtLa/0ZB0Moh
	 jfZmsGJ+29vGXXclLOkG0ukNlW/LBZiay6lIMwH/U8Y/oTAFmkznUrG2+lizg2uVnK
	 r/jwfJkB1xXglJyHykjWd4djFR4IhU6raAIKIVUIZLaBJsiip6TL9bnl2n9DWT2TkF
	 F9JyseoFcPZguv6lya/5Z4V5TkdRUeazncjOLcy4eioxQkjvd6WcvfhksOmXoHqQze
	 lqpjKmJMYLq13t3zwYIiMAhtsMmramezCTtQwedA7VNPxo5jG/uTTw1vP+v983yXAf
	 ZJPgv/Uns41QQ==
Date: Wed, 10 May 2023 18:01:21 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jiri Pirko <jiri@resnulli.us>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, jacob.e.keller@intel.com, saeedm@nvidia.com,
 moshe@nvidia.com
Subject: Re: [patch net] devlink: change per-devlink netdev notifier to
 static one
Message-ID: <20230510180121.7918ad1f@kernel.org>
In-Reply-To: <20230510144621.932017-1-jiri@resnulli.us>
References: <20230510144621.932017-1-jiri@resnulli.us>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 10 May 2023 16:46:21 +0200 Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> The commit 565b4824c39f ("devlink: change port event netdev notifier
> from per-net to global") changed original per-net notifier to be
> per-devlink instance. That fixed the issue of non-receiving events
> of netdev uninit if that moved to a different namespace.
> That worked fine in -net tree.
> 
> However, later on when commit ee75f1fc44dd ("net/mlx5e: Create
> separate devlink instance for ethernet auxiliary device") and
> commit 72ed5d5624af ("net/mlx5: Suspend auxiliary devices only in
> case of PCI device suspend") were merged, a deadlock was introduced
> when removing a namespace with devlink instance with another nested
> instance.
> 
> Here there is the bad flow example resulting in deadlock with mlx5:
> net_cleanup_work -> cleanup_net (takes down_read(&pernet_ops_rwsem) ->
> devlink_pernet_pre_exit() -> devlink_reload() ->
> mlx5_devlink_reload_down() -> mlx5_unload_one_devl_locked() ->
> mlx5_detach_device() -> del_adev() -> mlx5e_remove() ->
> mlx5e_destroy_devlink() -> devlink_free() ->
> unregister_netdevice_notifier() (takes down_write(&pernet_ops_rwsem)
> 
> Steps to reproduce:
> $ modprobe mlx5_core
> $ ip netns add ns1
> $ devlink dev reload pci/0000:08:00.0 netns ns1
> $ ip netns del ns1
> 
> Resolve this by converting the notifier from per-devlink instance to
> a static one registered during init phase and leaving it registered
> forever. Use this notifier for all devlink port instances created
> later on.
> 
> Note what a tree needs this fix only in case all of the cited fixes
> commits are present.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

For posterity v1(/previous):
https://lore.kernel.org/all/20230509100939.760867-1-jiri@resnulli.us/


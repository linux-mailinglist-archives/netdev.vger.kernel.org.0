Return-Path: <netdev+bounces-1314-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AC7D6FD43D
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 05:24:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2991A1C20CA5
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 03:24:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A147A63C;
	Wed, 10 May 2023 03:24:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7A3373
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 03:24:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D86FBC433EF;
	Wed, 10 May 2023 03:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683689086;
	bh=dYSBtuwYDING2TFzrYCJ3mSO3nsB7w0FRRpmmH5deEc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=cOspkPfUE4z0TWjuwYqQxOcCIdKWiTG0QNfVxsOSk+M08q+oMD8epOjZTLQgdh5Vq
	 AlD/2JO0QlE6AmOtl+O+34iw+cOkf6cBJl9sPocANOkhUdpph2h8j/io7hE3NraPdr
	 o1DSzy/AyWapSAe6gAZsgAuRQ+D/7dP5D6JRr7xTAFl4pHLxDhBvIRykMya8dUnHdV
	 ECIe5wMAG5NsV6roSRCerAlDiQNZbr5hhpT/WaiLDJ+6Jje0X9tJ52y2pKVnhYbp2n
	 VP0hSV73MzGdvHNwWpAXFcJ+nFcahYt6nebz/IwhdOK9kA/fphd4Od3+bY/G5XCKg6
	 rfcXd5ZmExD+A==
Date: Tue, 9 May 2023 20:24:44 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jiri Pirko <jiri@resnulli.us>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, jacob.e.keller@intel.com, saeedm@nvidia.com,
 moshe@nvidia.com
Subject: Re: [patch net 3/3] devlink: fix a deadlock with nested instances
 during namespace remove
Message-ID: <20230509202444.30436b9f@kernel.org>
In-Reply-To: <20230509100939.760867-1-jiri@resnulli.us>
References: <20230509100939.760867-1-jiri@resnulli.us>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue,  9 May 2023 12:09:36 +0200 Jiri Pirko wrote:
> The commit 565b4824c39f ("devlink: change port event netdev notifier
> from per-net to global") changed original per-net notifier to be global
> which fixed the issue of non-receiving events of netdev uninit if that
> moved to a different namespace. That worked fine in -net tree.
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

Why don't we have a single, static notifier for all of devlink?
Why the per device/per port notifiers?

We have the devlink port pointer in struct net_device, resolving from
a global event to the correct devlink instance is trivial.


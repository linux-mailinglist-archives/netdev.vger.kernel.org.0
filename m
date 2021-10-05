Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12479421F74
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 09:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232619AbhJEHek (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 03:34:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:60304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230526AbhJEHej (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 03:34:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BC1D61409;
        Tue,  5 Oct 2021 07:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633419169;
        bh=rNjNETXWfok71bBE4wm5rQuwBKj4geCeZR3SBjjv/+U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=az5HyTgs2vyFsukgITlv3XE4h11tikLrO2G2bdtlzDgZgIjamNQ5ULM4gSBs3pNpG
         xx3PkOkHtxg0690dhzX02aImkDblhjMqgDEse+xtujKm+7EsBmCZX1bnbsLzP+jwiq
         jzwbHkfphd9OrY4SDdDa3jtSz2FpyIcTluM5q7C5+oetYvk78D6+nuNQaXGWKFNn5a
         U8ptJXC6D6NtjnJGuF5nIY8qCHZIYB955jcEczDOBWORG1Wcc9lNdr8fD9Ip708Pzw
         tm2gtZiTH9DIeqPSBrQGgtnfPvAwwfcONZGhRGpPW+kC8TIKbFcetsEBrHbqh9OpW0
         3C+HtMGFYIGqg==
Date:   Tue, 5 Oct 2021 10:32:45 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
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
Message-ID: <YVv/nUe63nO8o8wz@unreal>
References: <cover.1633284302.git.leonro@nvidia.com>
 <92971648bcad41d095d12f5296246fc44ab8f5c7.1633284302.git.leonro@nvidia.com>
 <20211004164413.60e9ce80@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211004164413.60e9ce80@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 04, 2021 at 04:44:13PM -0700, Jakub Kicinski wrote:
> On Sun,  3 Oct 2021 21:12:04 +0300 Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Introduce new devlink call to set specific ops callback during
> > device initialization phase after devlink_alloc() is already
> > called.
> > 
> > This allows us to set specific ops based on device property which
> > is not known at the beginning of driver initialization.
> > 
> > For the sake of simplicity, this API lacks any type of locking and
> > needs to be called before devlink_register() to make sure that no
> > parallel access to the ops is possible at this stage.
> 
> The fact that it's not registered does not mean that the callbacks
> won't be invoked. Look at uses of devlink_compat_flash_update().

It is impossible, devlink_register() is part of .probe() flow and if it
wasn't called -> probe didn't success -> net_device doesn't exist.

We are not having net_device without "connected" device beneath, aren't we?

At least drivers that I checked are not prepared at all to handle call
to devlink->ops.flash_update() if they didn't probe successfully.

> 
> > diff --git a/net/core/devlink.c b/net/core/devlink.c
> > index 4e484afeadea..25c2aa2b35cd 100644
> > --- a/net/core/devlink.c
> > +++ b/net/core/devlink.c
> > @@ -53,7 +53,7 @@ struct devlink {
> >  	struct list_head trap_list;
> >  	struct list_head trap_group_list;
> >  	struct list_head trap_policer_list;
> > -	const struct devlink_ops *ops;
> > +	struct devlink_ops ops;
> 
> Security people like ops to live in read-only memory. You're making
> them r/w for every devlink instance now.

Yes, but we are explicitly copy every function pointer, which is safe.

> 
> >  	struct xarray snapshot_ids;
> >  	struct devlink_dev_stats stats;
> >  	struct device *dev;
> 
> > +/**
> > + *	devlink_set_ops - Set devlink ops dynamically
> > + *
> > + *	@devlink: devlink
> > + *	@ops: devlink ops to set
> > + *
> > + *	This interface allows us to set ops based on device property
> > + *	which is known after devlink_alloc() was already called.
> > + *
> > + *	This call sets fields that are not initialized yet and ignores
> > + *	already set fields.
> > + *
> > + *	It should be called before devlink_register(), so doesn't have any
> > + *	protection from concurent access.
> > + */
> > +void devlink_set_ops(struct devlink *devlink, const struct devlink_ops *ops)
> > +{
> > +	struct devlink_ops *dev_ops = &devlink->ops;
> > +
> > +	WARN_ON(!devlink_reload_actions_valid(ops));
> > +	ASSERT_DEVLINK_NOT_REGISTERED(devlink);

<...>

> > +EXPORT_SYMBOL_GPL(devlink_set_ops);
> 
> I still don't like this. IMO using feature bits to dynamically mask-off
> capabilities has much better properties. We already have static caps
> in devlink_ops (first 3 members), we should build on top of that. 

These capabilities are for specific operation, like flash or reload.
They control how these flows will work, they don't control if this flow
is valid or not.

You are too focused on reload caps, but mutliport mlx5 device doesn't
support eswitch too. I just didn't remove the eswitch callbacks to
stay focused on more important work - making devlink better. :)

Even if we decide to use new flag in devlink_ops, we will still need to
add this devlink_set_ops() patch, because the value of that new flag
will be known very late in initialization phase, after FW capabilities
are known and I will need to overwrite RO memory.

Jakub,

Can we please continue with the current approach? It doesn't expose any
user visible API and everything here will be easy rewrite differently
if such needs arise.

We have so much ahead, like removing devlink_lock, rewriting devlink->lock,
fixing devlink reload of IB part, e.t.c

Thanks

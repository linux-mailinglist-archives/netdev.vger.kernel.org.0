Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 810A5423010
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 20:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234916AbhJESeH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 14:34:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:45550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229626AbhJESeG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 14:34:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B3FD610FC;
        Tue,  5 Oct 2021 18:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633458735;
        bh=fWiFxnLxlEYJaeb4vqHUXjVPIw59E/Lp4hGMAvlSYAo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BAPwjPOQLG7w7zAx4AnjgMhZwqXELQcZGskKEhXSDsb6E7PKRwr3e42VEt8sWqfbw
         EVM20EWdWgF1FL7AO54vHDEFWdJV3yYOd99w+fIWVTvoI6AT+KICXDMZrdIs1ZhJOJ
         fTC9cHEp8sFmQpwcgwAnkKZnXm99V8a6kRXJmmfrjjIpaw/BukRwS0I+uu9IP06YzV
         ZUJMm9P2iO/JmED0HuPwmxO+r7f73aCAVjZZadccs+tttbl/KvO4XT+jFrBnhIJFgh
         v9DMbrlupU4F9uU0l4phg8bOET3O6YY/KTs8iJBAzbiCRxKutwjFNx2O5QEygh0p7e
         yhJDa1F/kPkjQ==
Date:   Tue, 5 Oct 2021 11:32:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
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
Message-ID: <20211005113213.0ee61358@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YVv/nUe63nO8o8wz@unreal>
References: <cover.1633284302.git.leonro@nvidia.com>
        <92971648bcad41d095d12f5296246fc44ab8f5c7.1633284302.git.leonro@nvidia.com>
        <20211004164413.60e9ce80@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YVv/nUe63nO8o8wz@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 Oct 2021 10:32:45 +0300 Leon Romanovsky wrote:
> On Mon, Oct 04, 2021 at 04:44:13PM -0700, Jakub Kicinski wrote:
> > On Sun,  3 Oct 2021 21:12:04 +0300 Leon Romanovsky wrote:  
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > > 
> > > Introduce new devlink call to set specific ops callback during
> > > device initialization phase after devlink_alloc() is already
> > > called.
> > > 
> > > This allows us to set specific ops based on device property which
> > > is not known at the beginning of driver initialization.
> > > 
> > > For the sake of simplicity, this API lacks any type of locking and
> > > needs to be called before devlink_register() to make sure that no
> > > parallel access to the ops is possible at this stage.  
> > 
> > The fact that it's not registered does not mean that the callbacks
> > won't be invoked. Look at uses of devlink_compat_flash_update().  
> 
> It is impossible, devlink_register() is part of .probe() flow and if it
> wasn't called -> probe didn't success -> net_device doesn't exist.

Are you talking about reality or the bright future brought by auxbus?

> We are not having net_device without "connected" device beneath, aren't we?
> 
> At least drivers that I checked are not prepared at all to handle call
> to devlink->ops.flash_update() if they didn't probe successfully.

Last time I checked you moved the devlink_register() at the end of
probe which for all no-auxbus drivers means after register_netdev().

> > > diff --git a/net/core/devlink.c b/net/core/devlink.c
> > > index 4e484afeadea..25c2aa2b35cd 100644
> > > --- a/net/core/devlink.c
> > > +++ b/net/core/devlink.c
> > > @@ -53,7 +53,7 @@ struct devlink {
> > >  	struct list_head trap_list;
> > >  	struct list_head trap_group_list;
> > >  	struct list_head trap_policer_list;
> > > -	const struct devlink_ops *ops;
> > > +	struct devlink_ops ops;  
> > 
> > Security people like ops to live in read-only memory. You're making
> > them r/w for every devlink instance now.  
> 
> Yes, but we are explicitly copy every function pointer, which is safe.

The goal is for ops to live in pages which are mapped read-only,
so that heap overflows can overwrite the pointers.

> > >  	struct xarray snapshot_ids;
> > >  	struct devlink_dev_stats stats;
> > >  	struct device *dev;  

> > > +EXPORT_SYMBOL_GPL(devlink_set_ops);  
> > 
> > I still don't like this. IMO using feature bits to dynamically mask-off
> > capabilities has much better properties. We already have static caps
> > in devlink_ops (first 3 members), we should build on top of that.   
> 
> These capabilities are for specific operation, like flash or reload.
> They control how these flows will work, they don't control if this flow
> is valid or not.
> 
> You are too focused on reload caps, but mutliport mlx5 device doesn't
> support eswitch too. I just didn't remove the eswitch callbacks to
> stay focused on more important work - making devlink better. :)
> 
> Even if we decide to use new flag in devlink_ops, we will still need to
> add this devlink_set_ops() patch, because the value of that new flag
> will be known very late in initialization phase, after FW capabilities
> are known and I will need to overwrite RO memory.

Yes, you can change the caps at run time, that's perfectly reasonable.
You'll also be able to define more fine grained caps going forward as
needed.

> Jakub,
> 
> Can we please continue with the current approach? It doesn't expose any
> user visible API and everything here will be easy rewrite differently
> if such needs arise.
> 
> We have so much ahead, like removing devlink_lock, rewriting devlink->lock,
> fixing devlink reload of IB part, e.t.c

I don't like it. If you're feeling strongly please gather support of
other developers. Right now it's my preference against yours. I don't
even see you making arguments that your approach is better, just that
mine is not perfect and requires some similar changes.

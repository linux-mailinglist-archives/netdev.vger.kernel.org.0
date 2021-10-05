Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5C54230A2
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 21:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235421AbhJETRi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 15:17:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:58762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235157AbhJETRf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 15:17:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE49261372;
        Tue,  5 Oct 2021 19:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633461344;
        bh=QlG3sQglseWfkURiKCWMosrqdWfH4HRYzxEXsFR8ogU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aa62h0WA4S9B48zmGcRHtpgkleEHVI2Tl2yoNhpNulTAl6uOBH5rqDOwhaiSTgUnF
         Ov1K0eAn9r4wzPnVvMjOHRES4Ik7L9szrL/CXt7L3//p/DerptWqI+O/ceY1j1UMJs
         xp6li8DLI0HOIid9eQGxoWrMw8lsOxkeb+wJ/nlCax6eRNbv779FyhCU7j+S1uWPUb
         WVahoYc2ByBRUQez5/wT7jDflYwebnZpeNYJ/JvQ+xqFMN2oN+HoZUYIBMrNAbo10E
         R9dFxaJYU7ZZBkPNFl6DD6outONhCVAmPqy00Dnor0krlV2wVtlPAByhEXwG+80G3r
         JOAyXNnHkBrAw==
Date:   Tue, 5 Oct 2021 22:15:40 +0300
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
Message-ID: <YVykXLY7mX4K1ScW@unreal>
References: <cover.1633284302.git.leonro@nvidia.com>
 <92971648bcad41d095d12f5296246fc44ab8f5c7.1633284302.git.leonro@nvidia.com>
 <20211004164413.60e9ce80@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YVv/nUe63nO8o8wz@unreal>
 <20211005113213.0ee61358@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211005113213.0ee61358@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 05, 2021 at 11:32:13AM -0700, Jakub Kicinski wrote:
> On Tue, 5 Oct 2021 10:32:45 +0300 Leon Romanovsky wrote:
> > On Mon, Oct 04, 2021 at 04:44:13PM -0700, Jakub Kicinski wrote:
> > > On Sun,  3 Oct 2021 21:12:04 +0300 Leon Romanovsky wrote:  
> > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > 
> > > > Introduce new devlink call to set specific ops callback during
> > > > device initialization phase after devlink_alloc() is already
> > > > called.
> > > > 
> > > > This allows us to set specific ops based on device property which
> > > > is not known at the beginning of driver initialization.
> > > > 
> > > > For the sake of simplicity, this API lacks any type of locking and
> > > > needs to be called before devlink_register() to make sure that no
> > > > parallel access to the ops is possible at this stage.  
> > > 
> > > The fact that it's not registered does not mean that the callbacks
> > > won't be invoked. Look at uses of devlink_compat_flash_update().  
> > 
> > It is impossible, devlink_register() is part of .probe() flow and if it
> > wasn't called -> probe didn't success -> net_device doesn't exist.
> 
> Are you talking about reality or the bright future brought by auxbus?

I looked on all the drivers which called to devlink_alloc() which is
starting point before devlink_register(). All of them used it in the
probe. My annotation patch checks that too.

https://lore.kernel.org/linux-rdma/f65772d429d2c259bbc18cf5b1bbe61e39eb7081.1633284302.git.leonro@nvidia.com/T/#u

So IMHO, it is reality.

> 
> > We are not having net_device without "connected" device beneath, aren't we?
> > 
> > At least drivers that I checked are not prepared at all to handle call
> > to devlink->ops.flash_update() if they didn't probe successfully.
> 
> Last time I checked you moved the devlink_register() at the end of
> probe which for all no-auxbus drivers means after register_netdev().

I need to add a check of if(devlink_register) inside devlink_compat_flash_update().

> 
> > > > diff --git a/net/core/devlink.c b/net/core/devlink.c
> > > > index 4e484afeadea..25c2aa2b35cd 100644
> > > > --- a/net/core/devlink.c
> > > > +++ b/net/core/devlink.c
> > > > @@ -53,7 +53,7 @@ struct devlink {
> > > >  	struct list_head trap_list;
> > > >  	struct list_head trap_group_list;
> > > >  	struct list_head trap_policer_list;
> > > > -	const struct devlink_ops *ops;
> > > > +	struct devlink_ops ops;  
> > > 
> > > Security people like ops to live in read-only memory. You're making
> > > them r/w for every devlink instance now.  
> > 
> > Yes, but we are explicitly copy every function pointer, which is safe.
> 
> The goal is for ops to live in pages which are mapped read-only,
> so that heap overflows can overwrite the pointers.

<...>

> I don't like it. If you're feeling strongly please gather support of
> other developers. Right now it's my preference against yours. I don't
> even see you making arguments that your approach is better, just that
> mine is not perfect and requires some similar changes.

I have an idea of how to keep static ops and allow devlink_set_ops()
like functionality.

What about if I group ops by some sort of commonalities?

In my case, it will be devlink_reload_ops, which will include reload
relevant callbacks and provide devlink_set_reload_ops() wrapper to set
them?

It will ensure that all pointers are const without need to have feature
bits.

Thanks

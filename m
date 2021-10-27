Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F66643CD59
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 17:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237959AbhJ0PT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 11:19:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:36984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233452AbhJ0PTz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 11:19:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A51F604DA;
        Wed, 27 Oct 2021 15:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635347849;
        bh=duLbKkirYQ9pfMnvEqq90eGUtUZ0vya7R2CEdc+8AnU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WfBoonE6uqLKGMtOVcvHZ4dXFQOw87aV179p2rg7nWjWd3Ix2LadcVs77hD/3AQRG
         WjUbdRxGd6T7u1cRImB26ozL1XgjbWKGprDoBTHksWO+m8hOuXhN+4Bb/BxNGVQibS
         KhOr9fe1SJZC0nUGiwOKvi8379bFn5IesfiC17ruFJ/se75QH4ZH5nf4hbH/p9oq5Q
         3rY1crVp0OerY8J6K/xlrOvb3jpeAgjMV6MnhY7Cpg7bita9B3lTLz7UguXf4z2xSL
         C2YZ6gGn9OdxCo3u21F5uwDgkoSkohu/8b9jyFY0wxOpFt495XVJRQsAou3s8BoCm/
         Nys6lqUk82+MQ==
Date:   Wed, 27 Oct 2021 18:17:25 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>,
        "David S . Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        syzbot+93d5accfaefceedf43c1@syzkaller.appspotmail.com,
        Edwin Peer <edwin.peer@broadcom.com>
Subject: Re: [PATCH net-next] netdevsim: Register and unregister devlink
 traps on probe/remove device
Message-ID: <YXlthf7pEU/OdnS0@unreal>
References: <YXaNUQv8RwDc0lif@unreal>
 <YXelYVqeqyVJ5HLc@shredder>
 <YXertDP8ouVbdnUt@unreal>
 <YXgMK2NKiiVYJhLl@shredder>
 <YXgpgr/BFpbdMLJp@unreal>
 <20211026120234.3408fbcc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YXhXT/u9bFADwEIo@unreal>
 <20211026125602.7a8f8b7e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YXjqHc9eCpYy03Ym@unreal>
 <20211027071723.12bd0b29@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211027071723.12bd0b29@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 27, 2021 at 07:17:23AM -0700, Jakub Kicinski wrote:
> On Wed, 27 Oct 2021 08:56:45 +0300 Leon Romanovsky wrote:
> > On Tue, Oct 26, 2021 at 12:56:02PM -0700, Jakub Kicinski wrote:
> > > On Tue, 26 Oct 2021 22:30:23 +0300 Leon Romanovsky wrote:  
> > > > No problem, I'll send a revert now, but what is your take on the direction?  
> > > 
> > > I haven't put in the time to understand the detail so I was hoping not
> > > to pass judgment on the direction. My likely unfounded feeling is that
> > > reshuffling ordering is not going to fix what is fundamentally a
> > > locking issue. Driver has internal locks it needs to hold both inside
> > > devlink callbacks and when registering devlink objects. We would solve
> > > a lot of the problems if those were one single lock instead of two. 
> > > At least that's my recollection from the times I was actually writing
> > > driver code...  
> > 
> > Exactly, and this is what reshuffling of registrations does. It allows us
> > to actually reduce number of locks to bare minimum, so at least creation
> > and deletion of devlink objects will be locks free.
> 
> That's not what I meant. I meant devlink should call in to take
> driver's lock or more likely driver should use the devlink instance
> mutex instead of creating its own. Most of the devlink helpers (with
> minor exceptions like alloc) should just assert that devlink instance
> lock is already held by the driver when called.
> 
> > Latest changes already solved devlink reload issues for mlx5 eth side
> > and it is deadlock and lockdep free now. We still have deadlocks with
> > our IB part, where we obligated to hold pernet lock during registering
> > to net notifiers, but it is different discussion.
> > 
> > > > IMHO, the mlxsw layering should be fixed. All this recursive devlink re-entry
> > > > looks horrible and adds unneeded complexity.  
> > > 
> > > If you're asking about mlxsw or bnxt in particular I wouldn't say what
> > > they do is wrong until we can point out bugs.  
> > 
> > I'm talking about mlxsw and pointed to the reentry to devlink over and over.
> 
> To me "pointing to re-entry" read like breaking the new model you have
> in mind, not actual bug/race/deadlock etc. If that's not the case the
> explanation flew over my head :)

It doesn't break, but complicates without any reason.

Let me try to summarize my vision for the devlink. It is not written
in stone and changes after every review comment. :)

I want to divide all devlink APIs into two buckets:
1. Before devlink_register() - we don't need to worry about locking at
all. If caller decides to go crazy and wants parallel calls to devlink
in this stage, he/she will need to be responsible for proper locking.

2. After devlink_register() - users can send their commands through
netlink, so we need maximum protection. The devlink core will have
RW semaphore to make sure that every entry in this stage is marked
or read (allow parallel calls) or write (exclusive access). Plus we
have a barrier for devlink_unregister().

My goal is to move as much as possible in first bucket, and various
devlink_*_register() calls are natural candidates for it.

In addition, they are candidates because devlink is SW layer, in my
view everything or almost everything should be allocated during driver
init with const arrays and feature bits with clear separation between
devlink and driver beneath.

Call chains like "devlink->driver->devlink->driver.." that exist in
mlxsw can't be correct from layering POV.

The current implementation of devlink reload in mlxsw adds amazingly
large amount of over engineering to main devlink core, because it drags
many (constant) initializations to be in bucket #2.

Bottom line, convert devlink core to be similar to driver core. :)

Thanks

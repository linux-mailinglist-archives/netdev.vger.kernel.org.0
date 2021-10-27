Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1856743CBCE
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 16:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242454AbhJ0OUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 10:20:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:43188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234859AbhJ0OTu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 10:19:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF14B608FE;
        Wed, 27 Oct 2021 14:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635344245;
        bh=T7SyeJt1fjnS3sitciSvNl7zKaarI6pju2vL88fkFrU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bGjoxyw7sKHLKaxGcaPaMNtQR70Fo6LJXZaYsJkiPgRwjF2Lewm4LGQwO4LiOThGn
         MLGWik0q99HOdSfkPYb+SpVP3demEHysc0rHlZTIFXYFDKLTwoTRo+//ozuEVrRDRE
         hm5t5b5zoa0EQwNsKcnY7ud+27a8JOdNbBbe51bOdEW1PjytRgChZ1sFcw0VQy46wJ
         ufCR1e4E2fRrK7bqzk9rzk7Cd/ysF33jkxwlP7fSpLp1PpcONA0LtRoBujIL3KCo4M
         s5VekVhj3RMUIQ17t1zS+TbmaGZDiXNj9CmgAgOYHlcaxHesPW/LTD2UDUlmCL6L9/
         ONRAJaD986j3w==
Date:   Wed, 27 Oct 2021 07:17:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>,
        "David S . Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        syzbot+93d5accfaefceedf43c1@syzkaller.appspotmail.com,
        Edwin Peer <edwin.peer@broadcom.com>
Subject: Re: [PATCH net-next] netdevsim: Register and unregister devlink
 traps on probe/remove device
Message-ID: <20211027071723.12bd0b29@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YXjqHc9eCpYy03Ym@unreal>
References: <YXZB/3+IR6I0b2xE@unreal>
        <YXZl4Gmq6DYSdDM3@shredder>
        <YXaNUQv8RwDc0lif@unreal>
        <YXelYVqeqyVJ5HLc@shredder>
        <YXertDP8ouVbdnUt@unreal>
        <YXgMK2NKiiVYJhLl@shredder>
        <YXgpgr/BFpbdMLJp@unreal>
        <20211026120234.3408fbcc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YXhXT/u9bFADwEIo@unreal>
        <20211026125602.7a8f8b7e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YXjqHc9eCpYy03Ym@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Oct 2021 08:56:45 +0300 Leon Romanovsky wrote:
> On Tue, Oct 26, 2021 at 12:56:02PM -0700, Jakub Kicinski wrote:
> > On Tue, 26 Oct 2021 22:30:23 +0300 Leon Romanovsky wrote:  
> > > No problem, I'll send a revert now, but what is your take on the direction?  
> > 
> > I haven't put in the time to understand the detail so I was hoping not
> > to pass judgment on the direction. My likely unfounded feeling is that
> > reshuffling ordering is not going to fix what is fundamentally a
> > locking issue. Driver has internal locks it needs to hold both inside
> > devlink callbacks and when registering devlink objects. We would solve
> > a lot of the problems if those were one single lock instead of two. 
> > At least that's my recollection from the times I was actually writing
> > driver code...  
> 
> Exactly, and this is what reshuffling of registrations does. It allows us
> to actually reduce number of locks to bare minimum, so at least creation
> and deletion of devlink objects will be locks free.

That's not what I meant. I meant devlink should call in to take
driver's lock or more likely driver should use the devlink instance
mutex instead of creating its own. Most of the devlink helpers (with
minor exceptions like alloc) should just assert that devlink instance
lock is already held by the driver when called.

> Latest changes already solved devlink reload issues for mlx5 eth side
> and it is deadlock and lockdep free now. We still have deadlocks with
> our IB part, where we obligated to hold pernet lock during registering
> to net notifiers, but it is different discussion.
> 
> > > IMHO, the mlxsw layering should be fixed. All this recursive devlink re-entry
> > > looks horrible and adds unneeded complexity.  
> > 
> > If you're asking about mlxsw or bnxt in particular I wouldn't say what
> > they do is wrong until we can point out bugs.  
> 
> I'm talking about mlxsw and pointed to the reentry to devlink over and over.

To me "pointing to re-entry" read like breaking the new model you have
in mind, not actual bug/race/deadlock etc. If that's not the case the
explanation flew over my head :)

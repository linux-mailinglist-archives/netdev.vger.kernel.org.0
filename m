Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43FF643C273
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 07:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239809AbhJ0F7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 01:59:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:39938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239783AbhJ0F7O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 01:59:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0AA8610A5;
        Wed, 27 Oct 2021 05:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635314209;
        bh=YgmW+t8asJX/JwlVQGunsHP1Jp0HXbk0ZQuIFp5nlRI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IDxrgT+YfY/woreXfsB9D1KtOFGm1Zste5kSQzKrZcipYu1kFFPER9HS2OTAgPPIW
         Zhhe/y9acKQAp/bl0PrO6uwvJDA+sPkDlCpO30SaCi/aYhXqFjzU+PTAxExZKMvTXn
         O561fEuOul6IQ9mmNGfiDPXs1BLZ9plchDrQ/OiXvIbgpw1CslRPe7PDeKR4Mcnw1f
         4e5se9hU+Ta596VPAM/oh3lYLjufB5Ix1nSOwx5XHj/yQySTMJRxhGsjhXpvxpLnk+
         qCCdWX2AbJj9X4vfOrse8+VGBqBGwHZaXnk6jtqCFXem05LPOzCy9Jbvzg2nw0DPpL
         qiISaBJBO86nA==
Date:   Wed, 27 Oct 2021 08:56:45 +0300
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
Message-ID: <YXjqHc9eCpYy03Ym@unreal>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211026125602.7a8f8b7e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 12:56:02PM -0700, Jakub Kicinski wrote:
> On Tue, 26 Oct 2021 22:30:23 +0300 Leon Romanovsky wrote:
> > On Tue, Oct 26, 2021 at 12:02:34PM -0700, Jakub Kicinski wrote:
> > > On Tue, 26 Oct 2021 19:14:58 +0300 Leon Romanovsky wrote:  
> > > > I understand your temptation to send revert, at the end it is the
> > > > easiest solution. However, I prefer to finish this discussion with
> > > > decision on how the end result in mlxsw will look like.
> > > > 
> > > > Let's hear Jiri and Jakub before we are rushing to revert something that
> > > > is correct in my opinion. We have whole week till merge window, and
> > > > revert takes less than 5 minutes, so no need to rush and do it before
> > > > direction is clear.  
> > > 
> > > Having drivers in a broken state will not be conducive to calm discussions.
> > > Let's do a quick revert and unbreak the selftests.  
> > 
> > No problem, I'll send a revert now, but what is your take on the direction?
> 
> I haven't put in the time to understand the detail so I was hoping not
> to pass judgment on the direction. My likely unfounded feeling is that
> reshuffling ordering is not going to fix what is fundamentally a
> locking issue. Driver has internal locks it needs to hold both inside
> devlink callbacks and when registering devlink objects. We would solve
> a lot of the problems if those were one single lock instead of two. 
> At least that's my recollection from the times I was actually writing
> driver code...

Exactly, and this is what reshuffling of registrations does. It allows us
to actually reduce number of locks to bare minimum, so at least creation
and deletion of devlink objects will be locks free.

Latest changes already solved devlink reload issues for mlx5 eth side
and it is deadlock and lockdep free now. We still have deadlocks with
our IB part, where we obligated to hold pernet lock during registering
to net notifiers, but it is different discussion.

> 
> > IMHO, the mlxsw layering should be fixed. All this recursive devlink re-entry
> > looks horrible and adds unneeded complexity.
> 
> If you're asking about mlxsw or bnxt in particular I wouldn't say what
> they do is wrong until we can point out bugs.

I'm talking about mlxsw and pointed to the reentry to devlink over and over.

From what I read about bnxt, it is test issue.

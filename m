Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C01943BB44
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 21:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237227AbhJZT62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 15:58:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:57416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233673AbhJZT61 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 15:58:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30CE560F39;
        Tue, 26 Oct 2021 19:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635278163;
        bh=kvqJFp+cHfI3ZD3gwuLVtjyzwjfnskN22KPY7SKhbrQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SfKfLsd4jIPQqwJgsgIptNuyKr7FOigu1pBmyDsbGti2fMK1QbqPT/6z3BL0Ug9dD
         ZZFZ7xR+rkML9v6B4xaG4oojopRndCFFpBy/MZ/39DpLYbzZ8f42T8MEa3SwvFUwRx
         u9hipgh0C7iWjhdfXbRzj6crjuCG8+Dm8bs5jM50ZkArH1uGyvG4TNtcfu8WyFMMW7
         ak1frWv+RkWgwMaeKAHD62yZbeDvUNM3GWt4muLFUzhPhQ1UjT0T6soTCdU0OMCLlO
         SDxgporhmFpRRHKu/fwc2Ti0ohJyceHsU4rilfk87AX0Hbj/8inWmT0IIYTkH1Lncj
         vrprE5iuX7Bxw==
Date:   Tue, 26 Oct 2021 12:56:02 -0700
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
Message-ID: <20211026125602.7a8f8b7e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YXhXT/u9bFADwEIo@unreal>
References: <YXUtbOpjmmWr71dU@unreal>
        <YXU5+XLhQ9zkBGNY@shredder>
        <YXZB/3+IR6I0b2xE@unreal>
        <YXZl4Gmq6DYSdDM3@shredder>
        <YXaNUQv8RwDc0lif@unreal>
        <YXelYVqeqyVJ5HLc@shredder>
        <YXertDP8ouVbdnUt@unreal>
        <YXgMK2NKiiVYJhLl@shredder>
        <YXgpgr/BFpbdMLJp@unreal>
        <20211026120234.3408fbcc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YXhXT/u9bFADwEIo@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Oct 2021 22:30:23 +0300 Leon Romanovsky wrote:
> On Tue, Oct 26, 2021 at 12:02:34PM -0700, Jakub Kicinski wrote:
> > On Tue, 26 Oct 2021 19:14:58 +0300 Leon Romanovsky wrote:  
> > > I understand your temptation to send revert, at the end it is the
> > > easiest solution. However, I prefer to finish this discussion with
> > > decision on how the end result in mlxsw will look like.
> > > 
> > > Let's hear Jiri and Jakub before we are rushing to revert something that
> > > is correct in my opinion. We have whole week till merge window, and
> > > revert takes less than 5 minutes, so no need to rush and do it before
> > > direction is clear.  
> > 
> > Having drivers in a broken state will not be conducive to calm discussions.
> > Let's do a quick revert and unbreak the selftests.  
> 
> No problem, I'll send a revert now, but what is your take on the direction?

I haven't put in the time to understand the detail so I was hoping not
to pass judgment on the direction. My likely unfounded feeling is that
reshuffling ordering is not going to fix what is fundamentally a
locking issue. Driver has internal locks it needs to hold both inside
devlink callbacks and when registering devlink objects. We would solve
a lot of the problems if those were one single lock instead of two. 
At least that's my recollection from the times I was actually writing
driver code...

> IMHO, the mlxsw layering should be fixed. All this recursive devlink re-entry
> looks horrible and adds unneeded complexity.

If you're asking about mlxsw or bnxt in particular I wouldn't say what
they do is wrong until we can point out bugs.

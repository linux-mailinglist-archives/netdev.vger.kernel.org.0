Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 223DE43B6AD
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 18:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237252AbhJZQR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 12:17:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:33674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231621AbhJZQR1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 12:17:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD22560238;
        Tue, 26 Oct 2021 16:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635264903;
        bh=BdTGtk7KbB3zzHKxNZPxwsXlTigcQu1tCE1klmFklCw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Rltr8DmXDhBQv2ZyAAWzQfnCirqOZJkm4urTDMAsAMPp2ZqEPG2ph8TJYE4OzNIza
         4b2hLjr4Lvwncqkx+/fIrtO5dlaonxedI9a5PUC9yfOpCb3m6FNIMAO4vvRNXCUsmW
         6SNYXsRst5wkS7ZkuEcJw9KL5BqqWTjmIlrkbqVOUSTwutXk0pt3UIMPPH1kf6Ujdp
         rEri78ci7vL1ddh3e8Pxx+DryEnv/hGxFLJt564OX7yhdF94A6JS+SmgGbpQLmpZ/p
         p4evJQHwsXMlFGBnmcoSeMS1Lm7cHtML+kpcNPrMCmuvKJhKYJKwWh3TgZQTXKb5ZH
         697c0BRMh9QqQ==
Date:   Tue, 26 Oct 2021 19:14:58 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        syzbot+93d5accfaefceedf43c1@syzkaller.appspotmail.com
Subject: Re: [PATCH net-next] netdevsim: Register and unregister devlink
 traps on probe/remove device
Message-ID: <YXgpgr/BFpbdMLJp@unreal>
References: <725e121f05362da4328dda08d5814211a0725dac.1635064599.git.leonro@nvidia.com>
 <YXUhyLXsc2egWNKx@shredder>
 <YXUtbOpjmmWr71dU@unreal>
 <YXU5+XLhQ9zkBGNY@shredder>
 <YXZB/3+IR6I0b2xE@unreal>
 <YXZl4Gmq6DYSdDM3@shredder>
 <YXaNUQv8RwDc0lif@unreal>
 <YXelYVqeqyVJ5HLc@shredder>
 <YXertDP8ouVbdnUt@unreal>
 <YXgMK2NKiiVYJhLl@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXgMK2NKiiVYJhLl@shredder>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 05:09:47PM +0300, Ido Schimmel wrote:
> On Tue, Oct 26, 2021 at 10:18:12AM +0300, Leon Romanovsky wrote:
> > On Tue, Oct 26, 2021 at 09:51:13AM +0300, Ido Schimmel wrote:
> > 
> > <...>
> > 
> > > > 
> > > > Can you please explain why is it so important to touch devlink SW
> > > > objects, reallocate them again and again on every reload in mlxsw?
> > > 
> > > Because that's how reload was defined and implemented. A complete
> > > reload. We are not changing the semantics 4 years later.
> > 
> > Please put your emotions aside and explain me technically why are you
> > must to do it?
> 
> Already did. The current semantics are "devlink-reload provides
> mechanism to reinit driver entities, applying devlink-params and
> devlink-resources new values. It also provides mechanism to activate
> firmware."

Right, it doesn't mean that devlink should reregister itself.

> 
> And this is exactly what netdevsim and mlxsw are doing. Driver entities
> are re-initialized. Your patch breaks that as entities are not
> re-initialized, which results in user space breakage. You simply cannot
> introduce such regressions.

Again, and again. I don't want to introduce regression, and I'll fix it.
However, let's try to reach a conclusion on how to fix the current regression
properly.

> 
> > 
> > The proposed semantics was broken for last 4 years, it can even seen as
> > dead on arrival,
> 
> Again with the bombastic statements. It was "dead on arrival" like the
> notifications were "impossible"?

No, it was dead-on-arrival, because of deadlocks and kernel panics.

My search in internal bug tracker shows more than 500 bugs opened
by various teams where devlink reload is involved. It is hard to tell
which are pure devlink reload related, but when I started to work on
this series, close to 20 such bugs were assigned to me.

> 
> > because it never worked for us in real production.
> 
> Who is "us"? mlx5 that apparently decided to do its own thing?

Yes, mlx5. I don't see why you think that us not calling devlink
recursively means "own thing".

> 
> We are using reload in mlxsw on a daily basis and users are using it to
> re-partition ASIC resources and activate firmware. 

Are you really compare mlx5 deployment scale and broad of use with mlxsw?

> There are tests over netdevsim implementation that anyone can run for
> testing purposes. We also made sure to integrate it into syzkaller:
> 
> https://github.com/google/syzkaller/commit/5b49e1f605a770e8f8fcdcbd1a8ff85591fc0c8e
> https://github.com/google/syzkaller/commit/04ca72cd45348daab9d896bbec8ea4c2d13455ac
> https://github.com/google/syzkaller/commit/6930bbef3b671ae21f74007f9e59efb9b236b93f
> https://github.com/google/syzkaller/commit/d45a4d69d83f40579e74fb561e1583db1be0e294
> https://github.com/google/syzkaller/commit/510951950dc0ee69cfdaf746061d3dbe31b49fd8
> 
> Which is why the regressions you introduced were discovered so quickly.

No, it was caught because I explicitly added assertions to find misuse.

> 
> > 
> > So I'm fixing bugs without relation to when they were introduced.
> 
> We all do

Great

> 
> > 
> > For example, this fix from Jiri [1] for basic design flow was merged almost
> > two years later after devlink reload was introduced [2], or this patch from
> > Parav [3] that fixed an issue introduced year before [4].
> 
> What is your point? That code has bugs?

My point is that devlink should be decoupled from mlxsw, so mlxsw won't
call recursively to devlink when executes devlink API.

This is incorrect and for me it is a bug.

> 
> By now I have spent more time arguing with you than you spent testing
> your patches and it's clear this discussion is not going anywhere.
> 
> Are you going to send a revert or I will? This is the fourth time I'm
> asking you.

I understand your temptation to send revert, at the end it is the
easiest solution. However, I prefer to finish this discussion with
decision on how the end result in mlxsw will look like.

Let's hear Jiri and Jakub before we are rushing to revert something that
is correct in my opinion. We have whole week till merge window, and
revert takes less than 5 minutes, so no need to rush and do it before
direction is clear.

Thanks

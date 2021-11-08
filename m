Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B92B449B9A
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 19:24:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235497AbhKHS10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 13:27:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:43112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235472AbhKHS10 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 13:27:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C1C561029;
        Mon,  8 Nov 2021 18:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636395881;
        bh=hqLreZ17nUMObGhW7DnA0LH/tm6sV6cExozL2LFyZP8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZrI12cBq2X/sqUI1CA7Hm1umZ73y+cgG8ZNgWBxzfWaDtFAVfiAAhnTX7qJZUl+KU
         bwXEG7Uz8SxGDoYmA6BKDNzY3yrFCMvX2NEvDiRX4/NZ8/NjbKzoPRnf7hJMNHv1RA
         WsMi7tpCYObjX/9VHjnhQXC/mzjR93W7+wh2cwow8fZWP6S3HdCBpmN2mw2Dc5Cg58
         wkL6JENAG4w4awfbwtmuqLAJOjsa7pwm4rR1R1H6273RRfrhfibo/sgoB1HDl6S/1h
         F6zDGYINBTKVw1jtqHlOWH6eXqPiqOwT+yWuU/dPmZYLPtR99AkfF4NUbPhbGF+oyI
         ceUgsxxUiKrDQ==
Date:   Mon, 8 Nov 2021 20:24:37 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>, Jiri Pirko <jiri@resnulli.us>,
        "David S . Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, edwin.peer@broadcom.com
Subject: Re: [PATCH net-next] devlink: Require devlink lock during device
 reload
Message-ID: <YYlrZZTdJKhha0FF@unreal>
References: <9716f9a13e217a0a163b745b6e92e02d40973d2c.1635701665.git.leonro@nvidia.com>
 <YYABqfFy//g5Gdis@nanopsycho>
 <YYBTg4nW2BIVadYE@shredder>
 <20211101161122.37fbb99d@kicinski-fedora-PC1C0HJN>
 <YYgJ1bnECwUWvNqD@shredder>
 <YYgSzEHppKY3oYTb@unreal>
 <20211108080918.2214996c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YYlfI4UgpEsMt5QI@unreal>
 <20211108101646.0a4e5ca4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211108101646.0a4e5ca4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 08, 2021 at 10:16:46AM -0800, Jakub Kicinski wrote:
> On Mon, 8 Nov 2021 19:32:19 +0200 Leon Romanovsky wrote:
> > > I think it's common sense. We're just exporting something to make our
> > > lives easier somewhere else in the three. Do you see a way in which
> > > taking refs on devlink can help out-of-tree code?  
> > 
> > I didn't go such far in my thoughts. My main concern is that you ore
> > exposing broken devlink internals in the hope that drivers will do better
> > locking. I wanted to show that internal locking should be fixed first.
> > 
> > https://lore.kernel.org/netdev/cover.1636390483.git.leonro@nvidia.com/T/#m093f067d0cafcbe6c05ed469bcfd708dd1eb7f36
> > 
> > While this series fixes locking and after all my changes devlink started
> > to be more secure, that works correctly for simple drivers.
> 
> I prefer my version. I think I asked you to show how the changes make
> drivers simpler, which you failed to do.

Why did I fail? My version requires **zero** changes to the drivers.
Everything works without them changing anything. You can't ask for more.

> 
> I already told you how this is going to go, don't expect me to comment
> too much.
> 
> > However for net namespace aware drivers it still stays DOA.
> > 
> > As you can see, devlink reload holds pernet_ops_rwsem, which drivers should
> > take too in order to unregister_netdevice_notifier.
> > 
> > So for me, the difference between netdevsim and real device (mlx5) is
> > too huge to really invest time into netdevsim-centric API, because it
> > won't solve any of real world problems.
> 
> Did we not already go over this? Sorry, it feels like you're repeating
> arguments which I replied to before. This is exhausting.

I don't enjoy it either.

> 
> nfp will benefit from the simplified locking as well, and so will bnxt,
> although I'm not sure the maintainers will opt for using devlink framework
> due to the downstream requirements.

Exactly why devlink should be fixed first.

Thanks

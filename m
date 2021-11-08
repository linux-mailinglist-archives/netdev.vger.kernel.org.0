Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09F73449BF1
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 19:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236000AbhKHSsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 13:48:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:46990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235369AbhKHSsy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 13:48:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 42566619A6;
        Mon,  8 Nov 2021 18:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636397169;
        bh=OL2pijau4dCFXd79EY6K4KgyqMTw/4w/M9XevyAdKjw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nfV1B8AHWbUPJFCOG/FeW4DjNSZctOjvK02VByspEAFyKPVEvzqW84KIoCyf3rCbC
         pw6XSpccxuvfNvJwveA65upAFqQPw8iMjo2/iG8oBjV3dNtsZkeWZVeEpeeKnUa7vT
         HvDCggpZ/Xd2Xs0yqayoBVTG7yIV6RVR6Yk3ixL0VVvKF/2OcATnZ2p3z7ZZ2GAMOG
         ZX2T5UeI+IKgxWIWXe3TLLrS8CU2tRnj0/HRIDVFnpzKdwQFhON0q4e4h//DHNClY1
         cA1qZuYp2QLV7BlHWzxVWm1rDWLOTmZTo7Gr09OKwvVAG2GorT3rr9pBHjOcPU+IJM
         EWWQyRriK/Vow==
Date:   Mon, 8 Nov 2021 10:46:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>, Jiri Pirko <jiri@resnulli.us>,
        "David S . Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, edwin.peer@broadcom.com
Subject: Re: [PATCH net-next] devlink: Require devlink lock during device
 reload
Message-ID: <20211108104608.378c106e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YYlrZZTdJKhha0FF@unreal>
References: <9716f9a13e217a0a163b745b6e92e02d40973d2c.1635701665.git.leonro@nvidia.com>
        <YYABqfFy//g5Gdis@nanopsycho>
        <YYBTg4nW2BIVadYE@shredder>
        <20211101161122.37fbb99d@kicinski-fedora-PC1C0HJN>
        <YYgJ1bnECwUWvNqD@shredder>
        <YYgSzEHppKY3oYTb@unreal>
        <20211108080918.2214996c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YYlfI4UgpEsMt5QI@unreal>
        <20211108101646.0a4e5ca4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YYlrZZTdJKhha0FF@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 8 Nov 2021 20:24:37 +0200 Leon Romanovsky wrote:
> > I prefer my version. I think I asked you to show how the changes make
> > drivers simpler, which you failed to do.  
> 
> Why did I fail? My version requires **zero** changes to the drivers.
> Everything works without them changing anything. You can't ask for more.

For the last time.

"Your version" does require driver changes, but for better or worse
we have already committed them to the tree. All the re-ordering to make
sure devlink is registered last and more work is done at alloc,
remember?

The goal is to make the upstream drivers simpler. You failed to show
how your code does that.

Maybe you don't see the benefit because upstream simplifications are
hard to depend on in out-of-tree drivers?

> > I already told you how this is going to go, don't expect me to comment
> > too much.
> >   
> > > However for net namespace aware drivers it still stays DOA.
> > > 
> > > As you can see, devlink reload holds pernet_ops_rwsem, which drivers should
> > > take too in order to unregister_netdevice_notifier.
> > > 
> > > So for me, the difference between netdevsim and real device (mlx5) is
> > > too huge to really invest time into netdevsim-centric API, because it
> > > won't solve any of real world problems.  
> > 
> > Did we not already go over this? Sorry, it feels like you're repeating
> > arguments which I replied to before. This is exhausting.  
> 
> I don't enjoy it either.
> 
> > nfp will benefit from the simplified locking as well, and so will bnxt,
> > although I'm not sure the maintainers will opt for using devlink framework
> > due to the downstream requirements.  
> 
> Exactly why devlink should be fixed first.

If by "fixed first" you mean it needs 5 locks to be added and to remove
any guarantees on sub-object lifetime then no thanks.

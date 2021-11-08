Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78D32449CC6
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 20:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238138AbhKHUBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 15:01:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:33396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230380AbhKHUBY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 15:01:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80323619BB;
        Mon,  8 Nov 2021 19:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636401520;
        bh=Tnug3S4nRTm6CERU8i/tUjb4Q2wQMGUGdCNAGitc0oc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MLtXwIn25NOcLAhX3DWLmGzFnYAQ/99iGrgqQyfzJ31QbuHI2M+sR4nMokpQr8tbp
         77OxkvWitMtbEWKh2QhRIN3qPDgknMtEj6icrU3s5WJUDXkKHhpKFp2fSigr9CQ8qK
         jFLY1s9YI7AmyZWrbYsj0j2MRT6090aCF1jGUHH348qzzZyCsnzYidhJGCKEROsKt6
         g0808CsJK2Jt5yOktm+00gG79eepOnD5m9x70Fs85Yuf6zBObeyxTnSltMh2+alszG
         ugAlwCviiqIx4d1BGYSfwaLi9ordbiF+7O6CeqZeLBFyJrOuChOEPf2ctu0ehvcqQC
         qALbeR6RqiaoQ==
Date:   Mon, 8 Nov 2021 21:58:36 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>, Jiri Pirko <jiri@resnulli.us>,
        "David S . Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, edwin.peer@broadcom.com
Subject: Re: [PATCH net-next] devlink: Require devlink lock during device
 reload
Message-ID: <YYmBbJ5++iO4MOo7@unreal>
References: <YYABqfFy//g5Gdis@nanopsycho>
 <YYBTg4nW2BIVadYE@shredder>
 <20211101161122.37fbb99d@kicinski-fedora-PC1C0HJN>
 <YYgJ1bnECwUWvNqD@shredder>
 <YYgSzEHppKY3oYTb@unreal>
 <20211108080918.2214996c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YYlfI4UgpEsMt5QI@unreal>
 <20211108101646.0a4e5ca4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YYlrZZTdJKhha0FF@unreal>
 <20211108104608.378c106e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211108104608.378c106e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 08, 2021 at 10:46:08AM -0800, Jakub Kicinski wrote:
> On Mon, 8 Nov 2021 20:24:37 +0200 Leon Romanovsky wrote:
> > > I prefer my version. I think I asked you to show how the changes make
> > > drivers simpler, which you failed to do.  
> > 
> > Why did I fail? My version requires **zero** changes to the drivers.
> > Everything works without them changing anything. You can't ask for more.
> 
> For the last time.
> 
> "Your version" does require driver changes, but for better or worse
> we have already committed them to the tree. All the re-ordering to make
> sure devlink is registered last and more work is done at alloc,
> remember?

It fixed access to devlink before driver is ready. Also it fixed devlink
reload of simple drivers (without net namespaces support). So yes, at
least for now, we have a workaround to devlink reload bugs. We rmmod
mlx5_ib before reload and after. Everything thanks to reordering.

> 
> The goal is to make the upstream drivers simpler. You failed to show
> how your code does that.
> 
> Maybe you don't see the benefit because upstream simplifications are
> hard to depend on in out-of-tree drivers?

I don't care about out-of-tree drivers, mlx5 is fully upstream.

> 
> > > I already told you how this is going to go, don't expect me to comment
> > > too much.
> > >   
> > > > However for net namespace aware drivers it still stays DOA.
> > > > 
> > > > As you can see, devlink reload holds pernet_ops_rwsem, which drivers should
> > > > take too in order to unregister_netdevice_notifier.
> > > > 
> > > > So for me, the difference between netdevsim and real device (mlx5) is
> > > > too huge to really invest time into netdevsim-centric API, because it
> > > > won't solve any of real world problems.  
> > > 
> > > Did we not already go over this? Sorry, it feels like you're repeating
> > > arguments which I replied to before. This is exhausting.  
> > 
> > I don't enjoy it either.
> > 
> > > nfp will benefit from the simplified locking as well, and so will bnxt,
> > > although I'm not sure the maintainers will opt for using devlink framework
> > > due to the downstream requirements.  
> > 
> > Exactly why devlink should be fixed first.
> 
> If by "fixed first" you mean it needs 5 locks to be added and to remove
> any guarantees on sub-object lifetime then no thanks.

How do you plan to fix pernet_ops_rwsem lock? By exposing devlink state
to the drivers? By providing unlocked version of unregister_netdevice_notifier?

This simple scenario has deadlocks:
sudo ip netns add n1
sudo devlink dev reload pci/0000:00:09.0 netns n1
sudo ip netns del n1

https://lore.kernel.org/netdev/20211108104608.378c106e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/T/#m94b5c173f134c7d19daf455e3f6bad5ba6afd90d

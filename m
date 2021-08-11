Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35AFA3E93C0
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 16:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232484AbhHKOhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 10:37:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:54560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232391AbhHKOhD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 10:37:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A92260F55;
        Wed, 11 Aug 2021 14:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628692600;
        bh=ggRfXvghh/3E1G1f8mqv1IKk5tuAu3iaplQrNw1OyH4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hctz4eEY1MmZ0eRIVqoNX5NJLyEUb92zD9ZLMZQZzXGm05XT3KjMHIVxgTHnp2mCB
         3IFXl/UWkroSxUTiv6JEJu4425R6LSuEzLJJyvnJeLXEhxkFWa5TaSifcvkdoQx7Gb
         RF77NOz9WDv32RjN7h16cB3b8hu05AhuZUoqIdAZWPWHJpNHY+hhhPeEBwkt8vCyQE
         HUYzBo5y0nX2Sui0mmE4y1j5acsLdw3OzRWef0vNX7iV7Gz6lrBUZd3hqrHF9BPztE
         C5FcaxquqBUUjlR1VgrvRNpz3o2gzu7TWtR0G+5fBIgUtaxZPrxnLwZru2d6MP7aC1
         E0bP/KzmtMAUg==
Date:   Wed, 11 Aug 2021 17:36:36 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org,
        Michael Guralnik <michaelgur@mellanox.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Yufeng Mo <moyufeng@huawei.com>
Subject: Re: [PATCH net-next 0/5] Move devlink_register to be near
 devlink_reload_enable
Message-ID: <YRPgdCG4pFtsAS0D@unreal>
References: <cover.1628599239.git.leonro@nvidia.com>
 <20210810165318.323eae24@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YRNp6Zmh99N3kJVa@unreal>
 <20210811062732.0f569b9a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YRPYMKxPHUkegEhj@unreal>
 <20210811071817.4af5ab34@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210811071817.4af5ab34@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 11, 2021 at 07:18:17AM -0700, Jakub Kicinski wrote:
> On Wed, 11 Aug 2021 17:01:20 +0300 Leon Romanovsky wrote:
> > > > Not really, they will register but won't be accessible from the user space.
> > > > The only difference is the location of "[dev,new] ..." notification.  
> > > 
> > > Is that because of mlx5's use of auxdev, or locking? I don't see
> > > anything that should prevent the port notification from coming out.  
> > 
> > And it is ok, kernel can (and does) send notifications, because we left
> > devlink_ops assignment to be in devlink_alloc(). It ensures that all
> > flows that worked before will continue to work without too much changes.
> > 
> > > I think the notifications need to get straightened out, we can't notify
> > > about sub-objects until the object is registered, since they are
> > > inaccessible.  
> > 
> > I'm not sure about that. You present the case where kernel and user
> > space races against each other and historically kernel doesn't protect
> > from such flows. 
> > 
> > For example, you can randomly remove and add kernel modules. At some
> > point of time, you will get "missing symbols errors", just because
> > one module tries to load and it depends on already removed one.
> 
> Sure. But there is a difference between an error because another
> actor did something conflicting, asynchronously, and API which by design
> sends notifications which can't be acted upon until later point in time,
> because kernel sent them too early.
> 
> > We must protect kernel and this is what I do. User shouldn't access
> > devlink instance before he sees "dev name" notification.
> 
> Which is a new rule, and therefore a uAPI change..
> 
> > Of course, we can move various iterators to devlink_register(), but it
> > will make code much complex, because we have objects that can be
> > registered at any time (IMHO. trap is one of them) and I will need to 
> > implement notification logic that separate objects that were created
> > before devlink_register and after.
> 
> I appreciate it's a PITA but it is the downside of a solution where
> registration of co-dependent objects exposed via devlink is reordered 
> in the kernel.

No problem, I will rewrite notification logic to be queue-based mechanism.

Thanks

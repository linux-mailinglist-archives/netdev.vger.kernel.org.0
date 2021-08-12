Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4ACD3E9D2F
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 06:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232072AbhHLEKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 00:10:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:38370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229460AbhHLEKh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Aug 2021 00:10:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A52B6101E;
        Thu, 12 Aug 2021 04:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628741413;
        bh=a9vCK+JdDyQ/TYRtaNeWmsXY/ywprZ4LdBlp4fn/VfE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mR7eVbDbfGxuv2MXbYx9SVJrf69DNFdd0wvWjrJc9c6NijYWAXv2OjZ+aH/oMX3mA
         4yTkzdeTCZyRop3QUMZYuC1G4Ho9fyuPJ0FUS7/leekM7ILS53MH6pox4u2NCLXlKJ
         f6LKF6kELnVXbXDXB7T7WHdS6e0npH+kKGsjj7YrEld5fORHgGWVbdJk3fFM97S1W0
         Yw/zrO3EOG71PyE23Ap/5TawhxAcNaKE+eg0xLZQLw2WgOQhzmd+CbhnG4bEuY5S6w
         gNYyOEeV/RsWvjMvvRcVDRgzpNRBMe8bHHYba9MHORhXI6lnTh0Zi15ibJkIL6u95H
         QWjI4blRLGsTA==
Date:   Thu, 12 Aug 2021 07:10:09 +0300
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
Message-ID: <YRSfIXUgNtv5Eyxr@unreal>
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

I thought about it more and realized what we can make registration
monitor notifications behave as before, we can't do it for unregister
path.

For register, we can buffer all notifications till devlink_register
comes, use it as a marker and release everything that was accumulated
till that point. Everything that will come later will be delivered
immediately.

It will give "dev name ..." print at the beginning as you want.

For unregister, this trick won't work because we don't know if any other
devlink unregister API is used after devlink_unregister. So we can't
delay notifications.

Even if we can, it will be even worse from user perspective, because
in such case devlink_unregister() will close netlink access without
notifying user and he won't understand why ports don't work (as an
example).

Jakub, you are over engineering here and solve non-existing problem.

> Which is a new rule, and therefore a uAPI change..

AFAIR, netlink can be out-of-order, because it is UDP, but it is just
impractical to see it in the real-life. So no, it is not new rule.

Thanks

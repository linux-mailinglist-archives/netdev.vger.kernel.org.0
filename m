Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3C5A3EFEE9
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 10:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238670AbhHRINJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 04:13:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:33226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240622AbhHRIMx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 04:12:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA99060F58;
        Wed, 18 Aug 2021 08:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629274339;
        bh=zxrOxb1Q7G3y9Z3wfx9YmJefmG6HeicBAF0ENCXgsdA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kTOoDBY7gaKQ9QauedmZo6c8JZZbrhC7WVmBtnuxePFbSXT+9ZvcgOwmoxY4NR3OX
         7q4hpKIC2Z9U0cbIncWT/xGmstdJTODWpmMz0nQ6BbAhP4Ca0P4ZqJ9GDmxFdrCDqA
         OSwiLmAcxs8sXMZNoWxPXxGHvMGgm41UTVHPbyWPdfTuhrXlX3UBCS0MFJH64DPKmO
         uxXy/APpXuSAMe6/nHpSoPCFnvR4gZfWSXBf0jmdj1M4HlqIYHKk2QQh6OgTJhGyxg
         JEkr8jBWaGq80u4E881Lk+PI//SWai8qFhFaGrGQ03oOqJhsGEgmm2bjyFc4WrGhRr
         Yg70ESYrwvqng==
Date:   Wed, 18 Aug 2021 11:12:15 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Jiri Pirko <jiri@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Salil Mehta <salil.mehta@huawei.com>,
        Shannon Nelson <snelson@pensando.io>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Yufeng Mo <moyufeng@huawei.com>
Subject: Re: [PATCH net-next 3/6] devlink: Count struct devlink consumers
Message-ID: <YRzA3zCKCgAtprwc@unreal>
References: <cover.1628933864.git.leonro@nvidia.com>
 <d4d59d801f4521e562c9ecf2d8767077aaefb456.1628933864.git.leonro@nvidia.com>
 <20210816084741.1dd1c415@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YRqKCVbjTZaSrSy+@unreal>
 <20210816090700.313a54ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CO1PR11MB50895F0BA3FE20CD92D79CB6D6FD9@CO1PR11MB5089.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO1PR11MB50895F0BA3FE20CD92D79CB6D6FD9@CO1PR11MB5089.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 16, 2021 at 09:32:17PM +0000, Keller, Jacob E wrote:
> 
> 
> > -----Original Message-----
> > From: Jakub Kicinski <kuba@kernel.org>
> > Sent: Monday, August 16, 2021 9:07 AM
> > To: Leon Romanovsky <leon@kernel.org>
> > Cc: David S . Miller <davem@davemloft.net>; Guangbin Huang
> > <huangguangbin2@huawei.com>; Keller, Jacob E <jacob.e.keller@intel.com>; Jiri
> > Pirko <jiri@nvidia.com>; linux-kernel@vger.kernel.org; netdev@vger.kernel.org;
> > Salil Mehta <salil.mehta@huawei.com>; Shannon Nelson
> > <snelson@pensando.io>; Yisen Zhuang <yisen.zhuang@huawei.com>; Yufeng
> > Mo <moyufeng@huawei.com>
> > Subject: Re: [PATCH net-next 3/6] devlink: Count struct devlink consumers
> > 
> > On Mon, 16 Aug 2021 18:53:45 +0300 Leon Romanovsky wrote:
> > > On Mon, Aug 16, 2021 at 08:47:41AM -0700, Jakub Kicinski wrote:
> > > > On Sat, 14 Aug 2021 12:57:28 +0300 Leon Romanovsky wrote:
> > > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > >
> > > > > The struct devlink itself is protected by internal lock and doesn't
> > > > > need global lock during operation. That global lock is used to protect
> > > > > addition/removal new devlink instances from the global list in use by
> > > > > all devlink consumers in the system.
> > > > >
> > > > > The future conversion of linked list to be xarray will allow us to
> > > > > actually delete that lock, but first we need to count all struct devlink
> > > > > users.
> > > >
> > > > Not a problem with this set but to state the obvious the global devlink
> > > > lock also protects from concurrent execution of all the ops which don't
> > > > take the instance lock (DEVLINK_NL_FLAG_NO_LOCK). You most likely know
> > > > this but I thought I'd comment on an off chance it helps.
> > >
> > > The end goal will be something like that:
> > > 1. Delete devlink lock
> > > 2. Rely on xa_lock() while grabbing devlink instance (past devlink_try_get)
> > > 3. Convert devlink->lock to be read/write lock to make sure that we can run
> > > get query in parallel.
> > > 4. Open devlink netlink to parallel ops, ".parallel_ops = true".
> > 
> > IIUC that'd mean setting eswitch mode would hold write lock on
> > the dl instance. What locks does e.g. registering a dl port take
> > then?
> 
> Also that I think we have some cases where we want to allow the driver to allocate new devlink objects in response to adding a port, but still want to block other global operations from running?

I don't see the flow where operations on devlink_A should block devlink_B.
Only in such flows we will need global lock like we have now - devlink->lock.
In all other flows, write lock of devlink instance will protect from
parallel execution.

Thanks

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A30213EDA45
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 17:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237124AbhHPP4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 11:56:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:42472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237406AbhHPPyt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 11:54:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79E3660F4B;
        Mon, 16 Aug 2021 15:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629129229;
        bh=wjnnlmVi3Qh8uS9MigPn3yJA2hsAEy/ZbPM5padIYCI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eR/LqbLzu0HGG6fZDVjcWPHFekOC2mneksHBNVGKeuM9Cw1T1xzV9bbzjuBxgM4tj
         nYvJPXZZQ7o3v51+n3svA0qXNaulJG9xK00Q9XOEiYlTG6tRQKQcCrFMNXBKGnpab/
         FVQEHFabQBsmdr2te0sSHcg4MKwJ0svoTihZcgbOWoZA0DoaqCp+qUvWK8NzWKU2zN
         1vLyDRANb7AVO36P2kMmtWK+iwp0WVo2XI7i7wttx7zL4GceB0nSmlyPitZoG4DCg3
         4V5dR45G+J3nF8bJCw9mdVky+JYZt7LuWfIwKcvV5+F+LA9kFiWI08tQuG+ltBuuza
         1UYeUDAgk/pfw==
Date:   Mon, 16 Aug 2021 18:53:45 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@nvidia.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Salil Mehta <salil.mehta@huawei.com>,
        Shannon Nelson <snelson@pensando.io>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Yufeng Mo <moyufeng@huawei.com>
Subject: Re: [PATCH net-next 3/6] devlink: Count struct devlink consumers
Message-ID: <YRqKCVbjTZaSrSy+@unreal>
References: <cover.1628933864.git.leonro@nvidia.com>
 <d4d59d801f4521e562c9ecf2d8767077aaefb456.1628933864.git.leonro@nvidia.com>
 <20210816084741.1dd1c415@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210816084741.1dd1c415@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 16, 2021 at 08:47:41AM -0700, Jakub Kicinski wrote:
> On Sat, 14 Aug 2021 12:57:28 +0300 Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > The struct devlink itself is protected by internal lock and doesn't
> > need global lock during operation. That global lock is used to protect
> > addition/removal new devlink instances from the global list in use by
> > all devlink consumers in the system.
> > 
> > The future conversion of linked list to be xarray will allow us to
> > actually delete that lock, but first we need to count all struct devlink
> > users.
> 
> Not a problem with this set but to state the obvious the global devlink
> lock also protects from concurrent execution of all the ops which don't
> take the instance lock (DEVLINK_NL_FLAG_NO_LOCK). You most likely know
> this but I thought I'd comment on an off chance it helps.

The end goal will be something like that:
1. Delete devlink lock
2. Rely on xa_lock() while grabbing devlink instance (past devlink_try_get)
3. Convert devlink->lock to be read/write lock to make sure that we can run
get query in parallel.
4. Open devlink netlink to parallel ops, ".parallel_ops = true".

Thanks


> 
> > The reference counting provides us a way to ensure that no new user
> > space commands success to grab devlink instance which is going to be
> > destroyed makes it is safe to access it without lock.
> 

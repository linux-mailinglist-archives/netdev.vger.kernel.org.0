Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BEC83EDA87
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 18:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbhHPQHe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 12:07:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:48570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229621AbhHPQHd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 12:07:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C8346056B;
        Mon, 16 Aug 2021 16:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629130021;
        bh=dQ7YdQ2ihh87LThyE6YAzcRBdsJeA/gOE3NhxEzSMgY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lVfcuZvRIc5hRBNPL9PCCiPON7jp6Ak1mRU0mhJwTdJK0KONo78N3qaCWN9CvUXA4
         8uGhdt/P9O6QCFDYyzEiGnDoBdVuDwrHsAIbgu4yrAldXNF2WUw3SAfepnUe31Edgm
         v0WZb2VRhDAGLxMiW9p07N9YUoxQD/sSjIO3gE5U1HfGMqYbXcBR3A+eWqK9Pf0NWj
         32RjGSAixHY10CnCvOBOUSzn6RflfHnXPZl1h8J+VnkB/GDviL1LOi00pm4m1tIQwg
         2gtt2YvefCj1eaqCz743ZRH84PbcAP+J2oXlUG37Hfxr5uuiFDc2KzY+uZHooezl8R
         e552YDmXKOY2A==
Date:   Mon, 16 Aug 2021 09:07:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@nvidia.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Salil Mehta <salil.mehta@huawei.com>,
        Shannon Nelson <snelson@pensando.io>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Yufeng Mo <moyufeng@huawei.com>
Subject: Re: [PATCH net-next 3/6] devlink: Count struct devlink consumers
Message-ID: <20210816090700.313a54ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YRqKCVbjTZaSrSy+@unreal>
References: <cover.1628933864.git.leonro@nvidia.com>
        <d4d59d801f4521e562c9ecf2d8767077aaefb456.1628933864.git.leonro@nvidia.com>
        <20210816084741.1dd1c415@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YRqKCVbjTZaSrSy+@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Aug 2021 18:53:45 +0300 Leon Romanovsky wrote:
> On Mon, Aug 16, 2021 at 08:47:41AM -0700, Jakub Kicinski wrote:
> > On Sat, 14 Aug 2021 12:57:28 +0300 Leon Romanovsky wrote:  
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > > 
> > > The struct devlink itself is protected by internal lock and doesn't
> > > need global lock during operation. That global lock is used to protect
> > > addition/removal new devlink instances from the global list in use by
> > > all devlink consumers in the system.
> > > 
> > > The future conversion of linked list to be xarray will allow us to
> > > actually delete that lock, but first we need to count all struct devlink
> > > users.  
> > 
> > Not a problem with this set but to state the obvious the global devlink
> > lock also protects from concurrent execution of all the ops which don't
> > take the instance lock (DEVLINK_NL_FLAG_NO_LOCK). You most likely know
> > this but I thought I'd comment on an off chance it helps.  
> 
> The end goal will be something like that:
> 1. Delete devlink lock
> 2. Rely on xa_lock() while grabbing devlink instance (past devlink_try_get)
> 3. Convert devlink->lock to be read/write lock to make sure that we can run
> get query in parallel.
> 4. Open devlink netlink to parallel ops, ".parallel_ops = true".

IIUC that'd mean setting eswitch mode would hold write lock on 
the dl instance. What locks does e.g. registering a dl port take 
then?

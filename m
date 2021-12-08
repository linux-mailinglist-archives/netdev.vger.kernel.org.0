Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC52346CE93
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 08:55:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244593AbhLHH6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 02:58:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244604AbhLHH6f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 02:58:35 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5EE2C061574;
        Tue,  7 Dec 2021 23:55:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2ACAACE2033;
        Wed,  8 Dec 2021 07:55:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 815D2C00446;
        Wed,  8 Dec 2021 07:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638950100;
        bh=v1wvVzDCmzs5HFFlBEU2ec0atnC8pdnq8s5Q1+Ys7ZM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SEgZ4l878A7pa6DHyWtLq2+ZDbPQ/vXJUfzpYA3lZEl3QZOhgG2vHtlp4xie+r1TD
         Gom9prBvfU9wVN2dqb7waPm2ZHpCQoq4IYZrCSUwb8mmhfb6NfPZw0zKyxjXaUVxZJ
         +xYx7uot934G+9dVUui/aBCwXuBxu+DoleQ27uSAyX421DkeRR8+HxHCcMX8h2+aua
         cAn0IEc8jEsWr2Qdg+mz85aDKJApMjBj026oGB3l3UeoKkpxtewXxVYi4Dmqu1GcFs
         YzYv1V1HaQo0OMotudex1Pd/EFc426Pd376N16df8VYh8agfcmvs7R3l6knHpLZJhk
         O8b19Xak+PvlA==
Date:   Wed, 8 Dec 2021 09:54:55 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/6] Allow parallel devlink execution
Message-ID: <YbBkzy+I1Buxp286@unreal>
References: <cover.1638690564.git.leonro@nvidia.com>
 <20211206180027.3700d357@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <Ya8NPxxn8/OAF4cR@unreal>
 <20211207202114.5ce27b2b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211207202114.5ce27b2b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 07, 2021 at 08:21:14PM -0800, Jakub Kicinski wrote:
> On Tue, 7 Dec 2021 09:29:03 +0200 Leon Romanovsky wrote:
> > On Mon, Dec 06, 2021 at 06:00:27PM -0800, Jakub Kicinski wrote:
> > > On Sun,  5 Dec 2021 10:22:00 +0200 Leon Romanovsky wrote:  
> > > > This is final piece of devlink locking puzzle, where I remove global
> > > > mutex lock (devlink_mutex), so we can run devlink commands in parallel.
> > > > 
> > > > The series starts with addition of port_list_lock, which is needed to
> > > > prevent locking dependency between netdevsim sysfs and devlink. It
> > > > follows by the patch that adds context aware locking primitives. Such
> > > > primitives allow us to make sure that devlink instance is locked and
> > > > stays locked even during reload operation. The last patches opens
> > > > devlink to parallel commands.  
> > > 
> > > I'm not okay with assuming that all sub-objects are added when devlink
> > > is not registered.  
> > 
> > But none of the patches in this series assume that.
> > 
> > In devlink_nested_lock() patch [1], I added new marker just to make sure
> > that we don't lock if this specific command is called in locked context.
> > 
> > +#define DEVLINK_NESTED_LOCK XA_MARK_2
> > 
> > [1] https://lore.kernel.org/all/2b64a2a81995b56fec0231751ff6075020058584.1638690564.git.leonro@nvidia.com/
> 
> You skip locking if the marker is set. So a register operation can race
> with a user space operation, right?

Not in upstream code.

In upstream code, we call to devlink_*_register()/devlink_*_unregister()
routines in two possible flows: before/after registration or as a part
of user space request through netlink interface. We don't call to them
randomly.

The current code is intermediate solution that allows us to get rid from
devlink_mutex lock together with annotations that help to spot problematic
flows.

In next patches, I will:
1. Reduce scope of devlink->lock to make sure that it locks exactly what
is needed to be protected (linked lists) instead of all-in-one lock as
it is now.
2. Rename devlink->lock to be evlink->lists_lock to clear the mud around
the scope.
3. Untangle mess with pre_doit, where some commands set _FLAG_NEED_*
flags and ignore user_ptr[1]. Every command should take internally the
object they need without any flags. It will make sub-object management
more clear.
4. Push down the mutex_lock(&devlink->lock) pre_doit to actual commands,
so pre_doit won't take any locks at all.
5. Reference count objects or use write semaphore in uregister paths to
make sure that we can access sub-objects without locks. I'm not sure
about the final implementations details yet.

In the steps 3, 4 and 5, we will delete _nested_lock, pre/post doit mess
and make sure that commands are holding as less as possible locks.

I afraid that many here are underestimate the amount of work needed that is
needed in devlink area to clean the rust due-to mixing in-kernel with
user-visible APIs. 

Thanks

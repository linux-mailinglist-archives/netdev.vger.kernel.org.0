Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F58646D6C0
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 16:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235843AbhLHPSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 10:18:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234098AbhLHPSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 10:18:44 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF61C061746;
        Wed,  8 Dec 2021 07:15:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 38636CE2207;
        Wed,  8 Dec 2021 15:15:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E277C00446;
        Wed,  8 Dec 2021 15:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638976508;
        bh=eF/Gngc8wez/wnWqieq7Ygi3WYHzXfZhwWIiTf9FbYU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=a5zSHoRZTSDQ8AlNyUKqjvs3ofLIdpKNEBB7d4RPO9/CgZR+xROhj2ELsn9VfIhPO
         d/xDD3fG3bAXXa8wR78881XMeuiCI/C7XEwcL4i6sOp6Fl3k8XaV7PqFq7WlNoDWMc
         vqIFL1pGrw7YYB1Z1+4e+y5DCe2crsYA8xyM4dNrc0I4YKmirxTv32jDu7XJIBHEN+
         PVe/b5wOKgwNemeC71qQXjhojlNX+USgY23pI4dzxM2MfewDiRfYImj+wzcNSoM0k6
         4fuZfVtlrtUphh7CsJu12kfIMF2JqLbu5YY66LvDhu6TcrGlNyCUjtxphON9XwgZkf
         xcfPSUtoRZVrQ==
Date:   Wed, 8 Dec 2021 07:15:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/6] Allow parallel devlink execution
Message-ID: <20211208071507.2ba46b0c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YbBkzy+I1Buxp286@unreal>
References: <cover.1638690564.git.leonro@nvidia.com>
        <20211206180027.3700d357@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <Ya8NPxxn8/OAF4cR@unreal>
        <20211207202114.5ce27b2b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YbBkzy+I1Buxp286@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Dec 2021 09:54:55 +0200 Leon Romanovsky wrote:
> On Tue, Dec 07, 2021 at 08:21:14PM -0800, Jakub Kicinski wrote:
> > On Tue, 7 Dec 2021 09:29:03 +0200 Leon Romanovsky wrote:  
> > > On Mon, Dec 06, 2021 at 06:00:27PM -0800, Jakub Kicinski wrote:  
> > > > On Sun,  5 Dec 2021 10:22:00 +0200 Leon Romanovsky wrote:    
> > > > > This is final piece of devlink locking puzzle, where I remove global
> > > > > mutex lock (devlink_mutex), so we can run devlink commands in parallel.
> > > > > 
> > > > > The series starts with addition of port_list_lock, which is needed to
> > > > > prevent locking dependency between netdevsim sysfs and devlink. It
> > > > > follows by the patch that adds context aware locking primitives. Such
> > > > > primitives allow us to make sure that devlink instance is locked and
> > > > > stays locked even during reload operation. The last patches opens
> > > > > devlink to parallel commands.    
> > > > 
> > > > I'm not okay with assuming that all sub-objects are added when devlink
> > > > is not registered.    
> > > 
> > > But none of the patches in this series assume that.
> > > 
> > > In devlink_nested_lock() patch [1], I added new marker just to make sure
> > > that we don't lock if this specific command is called in locked context.
> > > 
> > > +#define DEVLINK_NESTED_LOCK XA_MARK_2
> > > 
> > > [1] https://lore.kernel.org/all/2b64a2a81995b56fec0231751ff6075020058584.1638690564.git.leonro@nvidia.com/  
> > 
> > You skip locking if the marker is set. So a register operation can race
> > with a user space operation, right?  
> 
> Not in upstream code.
> 
> In upstream code, we call to devlink_*_register()/devlink_*_unregister()
> routines in two possible flows: before/after registration or as a part
> of user space request through netlink interface. We don't call to them
> randomly.

  me: this code does X
Leon: no it doesn't
  me: but it clear does, here's why
Leon: <convoluted evasive explanation>

I think it's going to be more healthy at this point to merge my code.

I do appreciate your work, but we disagree on how the API should look.

> The current code is intermediate solution that allows us to get rid from
> devlink_mutex lock together with annotations that help to spot problematic
> flows.
> 
> In next patches, I will:
> 1. Reduce scope of devlink->lock to make sure that it locks exactly what
> is needed to be protected (linked lists) instead of all-in-one lock as
> it is now.
> 2. Rename devlink->lock to be evlink->lists_lock to clear the mud around
> the scope.
> 3. Untangle mess with pre_doit, where some commands set _FLAG_NEED_*
> flags and ignore user_ptr[1]. Every command should take internally the
> object they need without any flags. It will make sub-object management
> more clear.
> 4. Push down the mutex_lock(&devlink->lock) pre_doit to actual commands,
> so pre_doit won't take any locks at all.
> 5. Reference count objects or use write semaphore in uregister paths to
> make sure that we can access sub-objects without locks. I'm not sure
> about the final implementations details yet.
> 
> In the steps 3, 4 and 5, we will delete _nested_lock, pre/post doit mess
> and make sure that commands are holding as less as possible locks.
> 
> I afraid that many here are underestimate the amount of work needed that is
> needed in devlink area to clean the rust due-to mixing in-kernel with
> user-visible APIs. 


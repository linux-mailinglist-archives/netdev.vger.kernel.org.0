Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0F93E0506
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 17:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239570AbhHDP4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 11:56:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:57348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239505AbhHDP4b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 11:56:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E78260ED6;
        Wed,  4 Aug 2021 15:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628092578;
        bh=RPaomrfZsu0NlLq7o4610pOBPFZ977N+t3sUJsClm/o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cgW3dGl+lOQ49qtgd0AyTzNXEKEqNbr3rw9VFTFxA2mnrCIzn+O9zKT+z1QZf44Fx
         xq/EienfNdqOpqyOmfkm0rs/WFYIvooEArRQL9c9zwpKd0JcXj56Aq+81l96a2QOt6
         sBS6XU/JnsJk/XSJeUFaImMpxhKWCECSOclwyFLE3Uf5bqn1LlOV0foKvxEj3r6Sqn
         eJS/Fs0msIarzkdQj6PKhOFVmlgUcYDKflTdXElfNHHF9kcQ7X7cmQD+pXdtWKW9uu
         tlNmeMYmF220fhlYGluHsKANBls0L0qRseNKUGrbxSWMmGGwevnEnKv/YOKMMly5nb
         QqIlo+F/dRQUg==
Date:   Wed, 4 Aug 2021 08:56:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "Cong Wang ." <cong.wang@bytedance.com>,
        Peilin Ye <peilin.ye@bytedance.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH net-next] Revert "netdevsim: Add multi-queue support"
Message-ID: <20210804085617.58855e62@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YQqM8XUyHKVaj1WF@unreal>
References: <20210803123921.2374485-1-kuba@kernel.org>
        <CAM_iQpUS_hNAb_-NmbcywyERwYp06ebJqv5Ve__okY6755-F=w@mail.gmail.com>
        <20210803141839.79e99e23@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAM_iQpV07aWSt5Jf-zSv6Qh4ydrJMYw54X3Seb8-eKGOpBYX7A@mail.gmail.com>
        <20210803145124.71a8aab4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YQo+XJQNAP7jnGw0@unreal>
        <20210804045247.057c5e9c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YQqM8XUyHKVaj1WF@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 4 Aug 2021 15:49:53 +0300 Leon Romanovsky wrote:
> It is something preliminary, I have POC code which works but it is far
> from the actual patches yet.
> 
> The problem is that "devlink reload" in its current form causes us
> (mlx5) a lot of grief. We see deadlocks due to combinations of internal
> flows with external ones, without going too much in details loops of
> module removal together with health recovery and devlink reload doesn't
> work properly :).
> 
> The same problem exists in all drivers that implement "devlink reload",
> mlx5 just most complicated one and looks like most tested either.
> 
> My idea (for now) is pretty simple:
> 1. Move devlink ops callbacks from devlink_alloc phase to devlink_register().
> 2. Ensure that devlink_register() is the last command in the probe sequence.

IDK.. does that work with port registration vs netdev registration?
IIRC ports should be registered first.

In general devlink is between bus devices and netdevs so I think
devlink should be initialized first, right?

Is merging the two flows (probe vs reload) possible? What I mean is can
we make the drivers use reload_up() during probe? IOW if driver has
.reload_up() make devlink core call that on register with whatever
locks it holds to prevent double-reload?

Either way please make sure to dump all the knowledge you gain about
the locking to some doc. Seems like that's a major sore spot for
devlink.

> 3. Delete devlink_reload_enable/disable. It is not needed if proper ops used.
> 4. Add reference counting to struct devlink to make sure that we
> properly account netlink users, so we will be able to drop big devlink_lock.
> 5. Convert linked list of devlink instances to be xarray. It gives us an
> option to work relatively lockless.
> ....
> 
> Every step solves some bug, even first one solves current bug where
> devlink reload statistics presented despite devlink_reload_disable().
> 
> Of course, we can try to patch devlink with specific fix for specific
> bug, but better to make it error prone from the beginning.
> 
> So I'm trying to get a sense what can and what can't be done in the netdev.
> And netdevsim combination of devlink and sysfs knobs adds challenges. :)

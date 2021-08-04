Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 066A73E06B4
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 19:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239816AbhHDRZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 13:25:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:44034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230089AbhHDRZ6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 13:25:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A71816023B;
        Wed,  4 Aug 2021 17:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628097945;
        bh=wncXwE3IJuiPDX4irEto+3HfssR62Y1vaAGrAuID7HI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IKli5uaiBnDeRFSTtT2QFkLFUvbwxPkBTR5m+MlimWKQDDRnTvO/zusj2o4bUQpct
         XoM0Ks/OEnU+oAvkdugX0FPao0WSBJRDZqRC/bYDmNZX4wfWnQgm8k7GVlCW9Ux335
         db+Zx+LSKMo8Zd5o3Cftr4SlMOsXdd0WG0c5HACnHzmxcQG4QLo1HWuhZH1lSeF3hG
         qiLiWXaquIPJkLORGjfmgkjf986N8u27SAGKN97gkPwHjUModXZILSd97WqZmQ7/1i
         /EgtqR6nmbD2XkDSYjKnqeOfDP6umkp4VQBUgZ36HALAMiVMjCYlNC1akrQg9BHx43
         DxfowcBAqN30w==
Date:   Wed, 4 Aug 2021 20:25:41 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "Cong Wang ." <cong.wang@bytedance.com>,
        Peilin Ye <peilin.ye@bytedance.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH net-next] Revert "netdevsim: Add multi-queue support"
Message-ID: <YQrNlUX3Vxv3Ez+S@unreal>
References: <20210803123921.2374485-1-kuba@kernel.org>
 <CAM_iQpUS_hNAb_-NmbcywyERwYp06ebJqv5Ve__okY6755-F=w@mail.gmail.com>
 <20210803141839.79e99e23@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAM_iQpV07aWSt5Jf-zSv6Qh4ydrJMYw54X3Seb8-eKGOpBYX7A@mail.gmail.com>
 <20210803145124.71a8aab4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YQo+XJQNAP7jnGw0@unreal>
 <20210804045247.057c5e9c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YQqM8XUyHKVaj1WF@unreal>
 <20210804085617.58855e62@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210804085617.58855e62@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 04, 2021 at 08:56:17AM -0700, Jakub Kicinski wrote:
> On Wed, 4 Aug 2021 15:49:53 +0300 Leon Romanovsky wrote:
> > It is something preliminary, I have POC code which works but it is far
> > from the actual patches yet.
> > 
> > The problem is that "devlink reload" in its current form causes us
> > (mlx5) a lot of grief. We see deadlocks due to combinations of internal
> > flows with external ones, without going too much in details loops of
> > module removal together with health recovery and devlink reload doesn't
> > work properly :).
> > 
> > The same problem exists in all drivers that implement "devlink reload",
> > mlx5 just most complicated one and looks like most tested either.
> > 
> > My idea (for now) is pretty simple:
> > 1. Move devlink ops callbacks from devlink_alloc phase to devlink_register().
> > 2. Ensure that devlink_register() is the last command in the probe sequence.
> 
> IDK.. does that work with port registration vs netdev registration?
> IIRC ports should be registered first.

I just throw the sketch, the proper solution requires to change all
devlink_*_register() function to accept relevant to that object ops.

> 
> In general devlink is between bus devices and netdevs so I think
> devlink should be initialized first, right?

Yes, because there are driver initialization parameters involved.

My personal opinion is that devlink is implemented in wrong layer
and everything would be much easier if it was part of driver/bus,
so it will be aware of driver core state machine and would hold
device_lock as part of driver core.

It would eliminate PCI recovery, devlink reload e.t.c races.

> 
> Is merging the two flows (probe vs reload) possible? What I mean is can
> we make the drivers use reload_up() during probe? IOW if driver has
> .reload_up() make devlink core call that on register with whatever
> locks it holds to prevent double-reload?

It was one of my internal POC, the problem is that .probe() is called
with device_lock, so I needed to teach devlink to hold that lock too.
The end result didn't look nice.

> 
> Either way please make sure to dump all the knowledge you gain about
> the locking to some doc. Seems like that's a major sore spot for
> devlink.

Sure

> 
> > 3. Delete devlink_reload_enable/disable. It is not needed if proper ops used.
> > 4. Add reference counting to struct devlink to make sure that we
> > properly account netlink users, so we will be able to drop big devlink_lock.
> > 5. Convert linked list of devlink instances to be xarray. It gives us an
> > option to work relatively lockless.
> > ....
> > 
> > Every step solves some bug, even first one solves current bug where
> > devlink reload statistics presented despite devlink_reload_disable().
> > 
> > Of course, we can try to patch devlink with specific fix for specific
> > bug, but better to make it error prone from the beginning.
> > 
> > So I'm trying to get a sense what can and what can't be done in the netdev.
> > And netdevsim combination of devlink and sysfs knobs adds challenges. :)

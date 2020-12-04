Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 518362CED50
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 12:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730115AbgLDLmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 06:42:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:38134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725999AbgLDLmL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 06:42:11 -0500
Date:   Fri, 4 Dec 2020 12:42:46 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607082090;
        bh=U+D8jQyF2x7hxn+mgXKApvlrbJWVFjxv8aEqAKyetO4=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=pgzHwqQII3NRBJIRuBKi8KUHFpoykh2NAC8oAmuATii8kf7GxzUu5WwCliXD1+7KD
         SLwaG5RKj8YEjSZFdnw97/idOqD3UmftByYTQE+u1gB6pQ6RRVQK/is2uWeoAyR3nd
         lB+8Q9xv9WeKHfmSB1weOGsoHXMTlFdTgFgW5VJ0=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     broonie@kernel.org, lgirdwood@gmail.com, davem@davemloft.net,
        kuba@kernel.org, jgg@nvidia.com,
        Kiran Patil <kiran.patil@intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Fred Oh <fred.oh@linux.intel.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Parav Pandit <parav@mellanox.com>,
        Martin Habets <mhabets@solarflare.com>,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [resend/standalone PATCH v4] Add auxiliary bus support
Message-ID: <X8ogtmrm7tOzZo+N@kroah.com>
References: <160695681289.505290.8978295443574440604.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160695681289.505290.8978295443574440604.stgit@dwillia2-desk3.amr.corp.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 02, 2020 at 04:54:24PM -0800, Dan Williams wrote:
> From: Dave Ertman <david.m.ertman@intel.com>
> 
> Add support for the Auxiliary Bus, auxiliary_device and auxiliary_driver.
> It enables drivers to create an auxiliary_device and bind an
> auxiliary_driver to it.
> 
> The bus supports probe/remove shutdown and suspend/resume callbacks.
> Each auxiliary_device has a unique string based id; driver binds to
> an auxiliary_device based on this id through the bus.
> 
> Co-developed-by: Kiran Patil <kiran.patil@intel.com>
> Co-developed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
> Co-developed-by: Fred Oh <fred.oh@linux.intel.com>
> Co-developed-by: Leon Romanovsky <leonro@nvidia.com>
> Signed-off-by: Kiran Patil <kiran.patil@intel.com>
> Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
> Signed-off-by: Fred Oh <fred.oh@linux.intel.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
> Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> Reviewed-by: Shiraz Saleem <shiraz.saleem@intel.com>
> Reviewed-by: Parav Pandit <parav@mellanox.com>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> Reviewed-by: Martin Habets <mhabets@solarflare.com>
> Link: https://lore.kernel.org/r/20201113161859.1775473-2-david.m.ertman@intel.com
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> This patch is "To:" the maintainers that have a pending backlog of
> driver updates dependent on this facility, and "Cc:" Greg. Greg, I
> understand you have asked for more time to fully review this and apply
> it to driver-core.git, likely for v5.12, but please consider Acking it
> for v5.11 instead. It looks good to me and several other stakeholders.
> Namely, stakeholders that have pressure building up behind this facility
> in particular Mellanox RDMA, but also SOF, Intel Ethernet, and later on
> Compute Express Link.
> 
> I will take the blame for the 2 months of silence that made this awkward
> to take through driver-core.git, but at the same time I do not want to
> see that communication mistake inconvenience other parties that
> reasonably thought this was shaping up to land in v5.11.
> 
> I am willing to host this version at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/djbw/linux tags/auxiliary-bus-for-5.11
> 
> ...for all the independent drivers to have a common commit baseline. It
> is not there yet pending Greg's Ack.
> 
> For example implementations incorporating this patch, see Dave Ertman's
> SOF series:
> 
> https://lore.kernel.org/r/20201113161859.1775473-2-david.m.ertman@intel.com
> 
> ...and Leon's mlx5 series:
> 
> http://lore.kernel.org/r/20201026111849.1035786-1-leon@kernel.org
> 
> PS: Greg I know I promised some review on newcomer patches to help with
> your queue, unfortunately Intel-internal review is keeping my plate
> full. Again, I do not want other stakeholder to be waiting on me to
> resolve that backlog.

Ok, I spent some hours today playing around with this.  I wrote up a
small test-patch for this (how did anyone test this thing???) and while
it feels awkward in places, and it feels like there is still way too
much "boilerplate" code that a user has to write and manage, I don't
have the time myself to fix it up right now.

So I'll go apply this to my tree, and provide a tag for everyone else to
be able to pull from for their different development trees so they can
work on.

I do have 3 follow-on patches that I will send to the list in response
to this message that I will be applying on top of this patch.  They do
some minor code formatting changes, as well as change the return type of
the remove function to make it more future-proof.  That last change will
require users of this code to change their implementations, but it will
be obvious what to do as you will get a build warning.

Note, I'm still not comfortable with a few things here.  The
documentation feels odd, and didn't really help me out in writing any
test code, which doesn't seem right.  Also the use of strings and '.' as
part of the api feels awkward, and messy, and of course, totally
undocumented.

But, as the use of '.' is undocumented, that means we can change it in
the future!  Because no driver or device name should ever be a user api
reliant thing, if we come up with a better way to do all of this in the
future, that shouldn't be a problem to change existing users over to
this.  So this is a warning to everyone, you CAN NOT depend on the sysfs
name of a device or bus name for any tool.  If so, your userspace tool
is broken.

Thanks for everyone in sticking with this, I know it's been a long slog,
hopefully this will help some driver authors move forward with their
crazy complex devices :)

thanks,

greg k-h

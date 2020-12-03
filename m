Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFAB82CD9CF
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 16:07:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728532AbgLCPF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 10:05:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:55310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725899AbgLCPF5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 10:05:57 -0500
Date:   Thu, 3 Dec 2020 16:06:24 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607007916;
        bh=/J7gpUERaDM9moTEEEztSBOYPXPY+1XBfrGQKejOuvY=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=HX4owR3tVP+i3f7QYdDhUhab7Q8N1/aR087nZ+T3r/vCFu1loWGADTevPSNLXw54N
         V29cV6+JhrNjwNbTM0z2MLR2nibX9loLE3RFShRdD97WvmNT13YpezMkpCTdCQGxZ8
         kZZQ2ISElcTQv4wS9gTDn+FvriQ+caA/hx+g5+7w=
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
Message-ID: <X8j+8DRrPeXBaTA7@kroah.com>
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

I have been trying to carve out some time to review this.  At my initial
glance, I still have objections, so please, give me a few more days to
get this done...

thanks,

greg k-h

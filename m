Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91486405F12
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 23:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347788AbhIIVtp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 17:49:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:57236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232371AbhIIVtp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 17:49:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB10B61131;
        Thu,  9 Sep 2021 21:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631224115;
        bh=zgld0ENlJlel6GXYsTEi10TI+j+hHy9GAC9tRdTbpmU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=s3gSANa5PaatYRdPl+UZjLCJtfDR2TSj6pSaJjtIlpqFpTh7mRBJ0nFYPxnZAZa/E
         yQgCacQlbxweBMAFDhnqZGG9shtUowlzinoR/oZ6TYrlzs6BuKAQVeJJVINzvnWqbl
         ElhkbozbzU4QKe1dXqRQtiUym0TDJD/2Y1vDx7yQlQeVJD+HOVNYsuXlZKi6rSFPLk
         YigZKx02u/D8BEaU0qB9hyx5JG4xn9ZvaIg5+fxQG3NbqBwtMUKb4gRKfUY2rE+EXk
         rQwInkOSDr6KsxM5E3kSfPAy0gPKuFSL516hQ6wVZslpnln6Qv6PwkJ0YNPhILyye4
         KJeCyvCrW4hjw==
Date:   Thu, 9 Sep 2021 14:48:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dave Ertman <david.m.ertman@intel.com>
Cc:     davem@davemloft.net, yongxin.liu@windriver.com,
        shiraz.saleem@intel.com, anthony.l.nguyen@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jesse.brandeburg@intel.com, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH net] ice: Correctly deal with PFs that do not support
 RDMA
Message-ID: <20210909144833.2ca0069d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210909085612.570229-1-david.m.ertman@intel.com>
References: <20210909085612.570229-1-david.m.ertman@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  9 Sep 2021 01:56:12 -0700 Dave Ertman wrote:
> There are two cases where the current PF does not support RDMA
> functionality.  The first is if the NVM loaded on the device is set
> to not support RDMA (common_caps.rdma is false).  The second is if
> the kernel bonding driver has included the current PF in an active
> link aggregate.
> 
> When the driver has determined that this PF does not support RDMA, then
> auxiliary devices should not be created on the auxiliary bus.  Without
> a device on the auxiliary bus, even if the irdma driver is present, there
> will be no RDMA activity attempted on this PF.
> 
> Currently, in the reset flow, an attempt to create auxiliary devices is
> performed without regard to the ability of the PF.  There needs to be a
> check in ice_aux_plug_dev (as the central point that creates auxiliary
> devices) to see if the PF is in a state to support the functionality.
> 
> When disabling and re-enabling RDMA due to the inclusion/removal of the PF
> in a link aggregate, we also need to set/clear the bit which controls
> auxiliary device creation so that a reset recovery in a link aggregate
> situation doesn't try to create auxiliary devices when it shouldn't.
> 
> Fixes: f9f5301e7e2d ("ice: Register auxiliary device to provide RDMA")
> Reported-by: Yongxin Liu <yongxin.liu@windriver.com>
> Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

Why CC lkml but not CC RDMA or Leon?

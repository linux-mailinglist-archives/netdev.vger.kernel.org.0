Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C50C14068FC
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 11:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232072AbhIJJU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 05:20:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:37570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231950AbhIJJU0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Sep 2021 05:20:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1CFE60E54;
        Fri, 10 Sep 2021 09:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631265555;
        bh=MMdXWy9QH0CzGaZwwChXTBW5lxYyYuHrr1/bvcKTO20=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F8JcAKGjm89rFblCLpR+Tlttk8cyjZwZ6IjQe8rcKDaWLIChbb8lKu4LRiXkNu1zU
         7zOvkS2atN/JENfcou79ze/peTxu7QZgJLtF+jFSb/8gveQ37vT5Vgbvq45iuQ033W
         djHtyCbnG/3SqLCsUVHebjEfcBJrcW7jZrqHzQUqBYa0zFJFnuWbUP/gFnqBYZ9Jll
         DhL12KibM5lY4NCLzoa/GxShPqNxTVqC239ao2kcG2jaIXzlm8M8Q/jyrYJ2VqzteH
         qawRXAhIcj/lB/LQfkq6/HCr0/FmDeIPZaB32NBEnBLe+dapcpPM7mK8DUP7psSGC5
         RbfwRSCRnqWqA==
Date:   Fri, 10 Sep 2021 12:19:10 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Dave Ertman <david.m.ertman@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, yongxin.liu@windriver.com,
        shiraz.saleem@intel.com, anthony.l.nguyen@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jesse.brandeburg@intel.com, intel-wired-lan@lists.osuosl.org,
        linux-rdma@vger.kernel.org, jgg@ziepe.ca
Subject: Re: [PATCH RESEND net] ice: Correctly deal with PFs that do not
 support RDMA
Message-ID: <YTsjDsFbBggL2X/8@unreal>
References: <20210909151223.572918-1-david.m.ertman@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210909151223.572918-1-david.m.ertman@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 09, 2021 at 08:12:23AM -0700, Dave Ertman wrote:
> There are two cases where the current PF does not support RDMA
> functionality.  The first is if the NVM loaded on the device is set
> to not support RDMA (common_caps.rdma is false).  The second is if
> the kernel bonding driver has included the current PF in an active
> link aggregate.
> 
> When the driver has determined that this PF does not support RDMA, then
> auxiliary devices should not be created on the auxiliary bus. 

This part is wrong, auxiliary devices should always be created, in your case it
will be one eth device only without extra irdma device.

Your "bug" is that you mixed auxiliary bus devices with "regular" ones
and created eth device not as auxiliary one. This is why you are calling
to auxiliary_device_init() for RDMA only and fallback to non-auxiliary mode.

I hope that this is simple mistake while Intel folks rushed to merge irdma
and not deliberate decision to find a way to support out-of-tree drivers.

As a reminder, the whole idea of auxiliary bus is to have small,
independent vendor driver core logic that manages capabilities and
based on that creates/removes sub-devices (eth, rdma, vdpa ...), so
driver core can properly load/unload their respective drivers.

Thanks

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE8B191071
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 14:31:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729878AbgCXN2K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 09:28:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:54144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729750AbgCXN2J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 09:28:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B66220870;
        Tue, 24 Mar 2020 13:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585056487;
        bh=sakM28rhhUNLc5cSyBxue32+lBn40xDL1D0nR8qBmS4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0COg1nA+NHMhCe9z0F98EYc10JGg598BB1HRccWxwIve3Vead4l2FxSGvqcv0kNR6
         N2M21f4u6sj4iP3wz/wBaM0IrpByYduYtZdFrjd3w1qFvCicZSZgvHaSpXmwGRVWsE
         UzAirPFOp0AU+fWtnQo5qW0RiYU3swhoEFcYivmc=
Date:   Tue, 24 Mar 2020 14:19:57 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, rafael@kernel.org,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mitch.a.williams@intel.com
Subject: Re: [PATCH net 0/3] net: core: avoid unexpected situation in
 namespace change routine
Message-ID: <20200324131957.GA2501774@kroah.com>
References: <20200324123041.18825-1-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324123041.18825-1-ap420073@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 12:30:41PM +0000, Taehee Yoo wrote:
> This patchset is to avoid an unexpected situation when an interface's
> namespace is being changed.
> 
> When interface's namespace is being changed, dev_change_net_namespace()
> is called. This removes and re-allocates many resources that include
> sysfs files. The "/net/class/net/<interface name>" is one of them.
> If the sysfs creation routine(device_rename()) found duplicate sysfs
> file name, it warns about it and fails. But unfortunately, at that point,
> dev_change_net_namespace() doesn't return fail because rollback cost
> is too high.
> So, the interface can't have a sysfs file.
> 
> The approach of this patchset is to find the duplicate sysfs file as
> fast as possible. If it found that, dev_change_net_namespace() returns
> fail immediately with zero rollback cost.
> 
> 1. The first patch is to add class_find_and_get_file_ns() helper function.
> That function will be used for checking the existence of duplicate
> sysfs file.
> 2. The second patch is to add netdev_class_has_file_ns().
> That function is to check whether duplicate sysfs file in
> the "/sys/class/net*" using class_find_and_get_file_ns().
> 3. The last patch is to avoid an unexpected situation.
> a) If duplicate sysfs is existing, it fails as fast as possible in
> the dev_change_net_namespace()
> b) Acquire rtnl_lock() in both bond_create_sysfs() and bond_destroy_sysfs()
> to avoid race condition.
> c) Do not remove "/sys/class/net/bonding_masters" sysfs file by
> bond_destroy_sysfs() if the file wasn't created by bond_create_sysfs().
> 
> Test commands#1:
>     ip netns add nst 
>     ip link add bonding_masters type dummy
>     modprobe bonding
>     ip link set bonding_masters netns nst 
> 
> Test commands#2:
>     ip link add bonding_masters type dummy
>     ls /sys/class/net
>     modprobe bonding
>     modprobe -rv bonding
>     ls /sys/class/net
> 
> After removing the bonding module, we can see the "bonding_masters"
> interface's sysfs will be removed.
> This is an unexpected situation.
> 
> Taehee Yoo (3):
>   class: add class_find_and_get_file_ns() helper function
>   net: core: add netdev_class_has_file_ns() helper function
>   net: core: avoid warning in dev_change_net_namespace()
> 
>  drivers/base/class.c             | 12 ++++++++++++
>  drivers/net/bonding/bond_sysfs.c | 13 ++++++++++++-
>  include/linux/device/class.h     |  4 +++-
>  include/linux/netdevice.h        |  2 +-
>  include/net/bonding.h            |  1 +
>  net/core/dev.c                   |  4 ++++
>  net/core/net-sysfs.c             | 13 +++++++++++++
>  7 files changed, 46 insertions(+), 3 deletions(-)

I don't seem to see patch 1/3 anywhere...


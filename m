Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28D7E3E8A10
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 08:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234698AbhHKGLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 02:11:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:59708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234468AbhHKGLQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 02:11:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2840C60F41;
        Wed, 11 Aug 2021 06:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628662252;
        bh=AKwTurEJzTx7U40tBTzGKeANm+iVMkeeFGKfRLV6toc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Bw7bdqJhsZvuUoyFRRqt7VzbA22+hLjUJb/VctHnEC2eRxDYdTv001GU0L7+McjWG
         zgCvbIIleLYtIYX2JrHqrGY3ngWqtESh64nkJLktfUDLPM9txKwxJrk9x+lpcuiEmK
         dyw4KjwtiYeEWCkTQ3R0GqMku46c/5Dsc/UQFBftUJlm2bUeno+7j2csjvn8vYOYxS
         S2+K/KZ5EQheTMO3xSk976tWfnlCV2sdBjiuPbG+KQFFEjH1jnoAaVTH/j+/eIu1sk
         Yj3zaux0Dg60EpwSvDqc/1hodllYInFhHWLV1B7px5aPMQ401gTg5ScvnauVch7s5c
         t7IOiuE0d73jg==
Date:   Wed, 11 Aug 2021 09:10:49 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org,
        Michael Guralnik <michaelgur@mellanox.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Yufeng Mo <moyufeng@huawei.com>
Subject: Re: [PATCH net-next 0/5] Move devlink_register to be near
 devlink_reload_enable
Message-ID: <YRNp6Zmh99N3kJVa@unreal>
References: <cover.1628599239.git.leonro@nvidia.com>
 <20210810165318.323eae24@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810165318.323eae24@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 10, 2021 at 04:53:18PM -0700, Jakub Kicinski wrote:
> On Tue, 10 Aug 2021 16:37:30 +0300 Leon Romanovsky wrote:
> > This series prepares code to remove devlink_reload_enable/_disable API
> > and in order to do, we move all devlink_register() calls to be right
> > before devlink_reload_enable().
> > 
> > The best place for such a call should be right before exiting from
> > the probe().
> > 
> > This is done because devlink_register() opens devlink netlink to the
> > users and gives them a venue to issue commands before initialization
> > is finished.
> > 
> > 1. Some drivers were aware of such "functionality" and tried to protect
> > themselves with extra locks, state machines and devlink_reload_enable().
> > Let's assume that it worked for them, but I'm personally skeptical about
> > it.
> > 
> > 2. Some drivers copied that pattern, but without locks and state
> > machines. That protected them from reload flows, but not from any _set_
> > routines.
> > 
> > 3. And all other drivers simply didn't understand the implications of early
> > devlink_register() and can be seen as "broken".
> 
> What are those implications for drivers which don't implement reload?
> Depending on which parts of devlink the drivers implement there may well
> be nothing to worry about.
> 
> Plus devlink instances start out with reload disabled. Could you please
> take a step back and explain why these changes are needed.

The problem is that devlink_register() adds new devlink instance to the
list of visible devlinks (devlink_list). It means that all devlink_*_dumpit()
will try to access devices during their initialization, before they are ready.

The more troublesome case is that devlink_list is iterated in the
devlink_get_from_attrs() and it is used in devlink_nl_pre_doit(). The
latter function will return to the caller that new devlink is valid and
such caller will be able to proceed to *_set_doit() functions.

Just as an example:
 * user sends netlink message
  * devlink_nl_cmd_eswitch_set_doit()
   * ops->eswitch_mode_set()
    * Are you sure that all drivers protected here?
      I remind that driver is in the middle of its probe().

Someone can argue that drivers and devlink are protected from anything
harmful with their global (devlink_mutex and devlink->lock) and internal
(device->lock, e.t.c.) locks. However it is impossible to prove for all
drivers and prone to errors.

Reload enable/disable gives false impression that the problem exists in
that flow only, which is not true.

devlink_reload_enable() is a duct tape because reload flows much easier
to hit.

> 
> > In this series, we focus on items #1 and #2.
> > 
> > Please share your opinion if I should change ALL other drivers to make
> > sure that devlink_register() is the last command or leave them in an
> > as-is state.
> 
> Can you please share the output of devlink monitor and ip monitor link
> before and after?  The modified drivers will not register ports before
> they register the devlink instance itself.

Not really, they will register but won't be accessible from the user space.
The only difference is the location of "[dev,new] ..." notification.

[leonro@vm ~]$ sudo modprobe mlx5_core
[  105.575790] mlx5_core 0000:00:09.0: firmware version: 4.8.9999
[  105.576349] mlx5_core 0000:00:09.0: 0.000 Gb/s available PCIe bandwidth (8.0 GT/s PCIe x255 link)
[  105.686217] pps pps0: new PPS source ptp0
[  105.688144] mlx5_core 0000:00:09.0: E-Switch: Total vports 2, per vport: max uc(32768) max mc(32768)
[  105.717736] mlx5_core 0000:00:09.0: MLX5E: StrdRq(1) RqSz(8) StrdSz(2048) RxCqeCmprss(0)
[  106.957028] mlx5_core 0000:00:09.0 eth1: Link down
[  106.960379] mlx5_core 0000:00:09.0 eth1: Link up
[  106.967916] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
================================================================================================
Before:
[leonro@vm ~]$ sudo devlink monitor
[dev,new] pci/0000:00:09.0
[param,new] pci/0000:00:09.0: name flow_steering_mode type driver-specific
  values:
[param,new] pci/0000:00:09.0: name esw_port_metadata type driver-specific
  values:
[param,new] pci/0000:00:09.0: name enable_remote_dev_reset type generic
  values:
[param,new] pci/0000:00:09.0: name enable_roce type generic
  values:
    cmode driverinit value true
[param,new] pci/0000:00:09.0: name fdb_large_groups type driver-specific
  values:
    cmode driverinit value 15
[param,new] pci/0000:00:09.0: name flow_steering_mode type driver-specific
  values:
    cmode runtime value dmfs
[param,new] pci/0000:00:09.0: name enable_roce type generic
  values:
    cmode driverinit value true
[param,new] pci/0000:00:09.0: name fdb_large_groups type driver-specific
  values:
    cmode driverinit value 15
[param,new] pci/0000:00:09.0: name esw_port_metadata type driver-specific
  values:
    cmode runtime value true
[param,new] pci/0000:00:09.0: name enable_remote_dev_reset type generic
  values:
    cmode runtime value true
[trap-group,new] pci/0000:00:09.0: name l2_drops generic true
[trap,new] pci/0000:00:09.0: name ingress_vlan_filter type drop generic true action drop group l2_drops
[trap,new] pci/0000:00:09.0: name dmac_filter type drop generic true action drop group l2_drops
[port,new] pci/0000:00:09.0/131071: type notset flavour physical port 0 splittable false
[port,new] pci/0000:00:09.0/131071: type eth netdev eth1 flavour physical port 0 splittable false

[leonro@vm ~]$ sudo ip monitor
inet eth1 forwarding off rp_filter loose mc_forwarding off proxy_neigh off ignore_routes_with_linkdown off 
inet6 eth1 forwarding off mc_forwarding off proxy_neigh off ignore_routes_with_linkdown off 
4: eth1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default 
    link/ether 52:54:00:12:34:56 brd ff:ff:ff:ff:ff:ff
4: eth1: <NO-CARRIER,BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state DOWN group default 
    link/ether 52:54:00:12:34:56 brd ff:ff:ff:ff:ff:ff
multicast ff00::/8 dev eth1 table local proto kernel metric 256 pref medium
fe80::/64 dev eth1 proto kernel metric 256 pref medium
4: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default 
    link/ether 52:54:00:12:34:56 brd ff:ff:ff:ff:ff:ff
4: eth1    inet6 fe80::5054:ff:fe12:3456/64 scope link 
       valid_lft forever preferred_lft forever
local fe80::5054:ff:fe12:3456 dev eth1 table local proto kernel metric 0 pref medium

===========================================================================================================
After:
[leonro@vm ~]$ sudo devlink monitor
[param,new] pci/0000:00:09.0: name flow_steering_mode type driver-specific
  values:
[param,new] pci/0000:00:09.0: name esw_port_metadata type driver-specific
  values:
[param,new] pci/0000:00:09.0: name enable_remote_dev_reset type generic
  values:
[param,new] pci/0000:00:09.0: name enable_roce type generic
  values:
    cmode driverinit value true
[param,new] pci/0000:00:09.0: name fdb_large_groups type driver-specific
  values:
    cmode driverinit value 15
[param,new] pci/0000:00:09.0: name flow_steering_mode type driver-specific
  values:
    cmode runtime value dmfs
[param,new] pci/0000:00:09.0: name enable_roce type generic
  values:
    cmode driverinit value true
[param,new] pci/0000:00:09.0: name fdb_large_groups type driver-specific
  values:
    cmode driverinit value 15
[param,new] pci/0000:00:09.0: name esw_port_metadata type driver-specific
  values:
    cmode runtime value true
[param,new] pci/0000:00:09.0: name enable_remote_dev_reset type generic
  values:
    cmode runtime value true
[trap-group,new] pci/0000:00:09.0: name l2_drops generic true
[trap,new] pci/0000:00:09.0: name ingress_vlan_filter type drop generic true action drop group l2_drops
[trap,new] pci/0000:00:09.0: name dmac_filter type drop generic true action drop group l2_drops
[dev,new] pci/0000:00:09.0
[port,new] pci/0000:00:09.0/131071: type notset flavour physical port 0 splittable false
[port,new] pci/0000:00:09.0/131071: type eth netdev eth1 flavour physical port 0 splittable false

[leonro@vm ~]$ sudo ip monitor
inet eth1 forwarding off rp_filter loose mc_forwarding off proxy_neigh off ignore_routes_with_linkdown off 
inet6 eth1 forwarding off mc_forwarding off proxy_neigh off ignore_routes_with_linkdown off 
4: eth1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default 
    link/ether 52:54:00:12:34:56 brd ff:ff:ff:ff:ff:ff
4: eth1: <NO-CARRIER,BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state DOWN group default 
    link/ether 52:54:00:12:34:56 brd ff:ff:ff:ff:ff:ff
multicast ff00::/8 dev eth1 table local proto kernel metric 256 pref medium
fe80::/64 dev eth1 proto kernel metric 256 pref medium
4: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default 
    link/ether 52:54:00:12:34:56 brd ff:ff:ff:ff:ff:ff
4: eth1    inet6 fe80::5054:ff:fe12:3456/64 scope link 
       valid_lft forever preferred_lft forever
local fe80::5054:ff:fe12:3456 dev eth1 table local proto kernel metric 0 pref medium

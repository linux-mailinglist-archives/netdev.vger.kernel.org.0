Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38E9E2B9FD3
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 02:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbgKTBhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 20:37:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726553AbgKTBhj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 20:37:39 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 494B1C0613CF
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 17:37:39 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id l206so8637694oif.12
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 17:37:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=RhAdjnbkAKnVEwI/8EkcGeCeeTmYpL/3cZ5B5Sny/4U=;
        b=jnq5lyc7SV96Ap+MolmwFYfzr4f7MvIayQ+UIRqDn4umHzZjdHCIGdhOszTpaGwg4K
         qSr3UTARVit6dCxO6m/L3O2iI11+NpChYzZJj3TnvbtkW3Rg9x5pAhEMXjJVeeh7owyR
         X7x3RjEl+y3YB85bYx2cqv3ndHgk9U4THHJXBkgdGnkdLtWoEMAJrDIDNFfrVQGCWBE7
         ypoDTpgpo4kQ1ridj88mA3U3c+NAtbKWjPrrBR927ksfZeYmqOncZna9eUJCpUdob8C8
         PaTULg9SR1rjei1JGNeigECTK3i1SmzHmwQYmYBa3F7U5pKE7+173+OnfNhzun8aoB6Q
         3Vfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=RhAdjnbkAKnVEwI/8EkcGeCeeTmYpL/3cZ5B5Sny/4U=;
        b=tyEt3CtgS8b49nFITfMHkuJ923EWr1d4lLgIXF5Lv1oSzO2Zv4m4tPzybt6N86nZNc
         oWQn6ydcZ07O6+V6r9d0OqVIl3JW3umb4/lyt6bpnkQnu0JDcs2EiXrjlRQ7aw1QM8/E
         rROTOrA9dTGVdziYITozhF/fAcOMjre29sC6fNZjTNMFVeztML7PaM05ucZHj6LoSYiy
         WuCJkd01unwE8UuQdAfpuoDlq2x1Gaf4JkDy2CuUIHy1KpNvv1P7j7NLuUcqBaFFk99s
         5lqQ3llSsgTRAbnC/QFDGIO6f+jcbLQHh+HP8VxRoJWV6eilAs+OO56aILh/dR09vaao
         ixKA==
X-Gm-Message-State: AOAM532eFykqiI5IlKFOFvcJFttONknKy8yWkuBtlwhEXCgSe85G6wAZ
        4bJIfO7gcKMJe0z2X0z4dFFv6bB+Woqco4rueZ4spVV3RwaZqA==
X-Google-Smtp-Source: ABdhPJz86Og56LA8Nvq4XunqlfLY1HihdY7BID1znf8mfcpIuljAQcGMPLIWPdOYeGNt1minXIJGu52kGf2VRKiWZFk=
X-Received: by 2002:aca:5fc2:: with SMTP id t185mr4849117oib.113.1605836258470;
 Thu, 19 Nov 2020 17:37:38 -0800 (PST)
MIME-Version: 1.0
From:   Limin Wang <lwang.nbl@gmail.com>
Date:   Thu, 19 Nov 2020 20:37:27 -0500
Message-ID: <CACpdL32SRKb8hXzuF_APybip+hyxkXRYoxCW_OMhn0odRSQKuw@mail.gmail.com>
Subject: LRO: creating vlan subports affects parent port's LRO settings
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Under relatively recent kernels (v4.4+), creating a vlan subport on a
LRO supported parent NIC may turn LRO off on the parent port and
further render its LRO feature practically unchangeable.

This can be easily reproduced on different distros, and independent of
NIC vendors.
Hopefully, this is not a repeat post of a known issue.

Below example is on Ubuntu 18.04 LTS. (Centos-7.6 is slightly
different, but the end result is the same, will attach in the end)
===========================================================================
# Ubuntu 18.04 LTS
root@server1:# uname -a
Linux server1 4.15.0-20-generic #21-Ubuntu SMP Tue Apr 24 06:16:15 UTC
2018 x86_64 x86_64 x86_64 GNU/Linux

# mellanox NIC
root@server1:# /sbin/ethtool -i ens4f0
driver: mlx5_core
version: 5.0-2.1.8

# enable LRO on the NIC
root@server1:# /sbin/ethtool -k ens4f0 | grep large
large-receive-offload: off
root@server1:# /sbin/ethtool -K ens4f0 lro on
root@server1:# /sbin/ethtool -k ens4f0 | grep large
large-receive-offload: on

# create a vlan subport, once subport is up, parent port LRO is disabled
root@server1:# ip link add link ens4f0 name ens4f0.50 type vlan id 50
root@server1:# ifconfig ens4f0.50 up
root@server1:# ethtool -k ens4f0.50 | grep large
large-receive-offload: off [fixed]
root@server1:# ethtool -k ens4f0 | grep large
large-receive-offload: off

# manually enabling LRO on parent port not working any more
root@server1:# /sbin/ethtool -K ens4f0 lro on
Could not change any device features
root@server1:# /sbin/ethtool -K ens4f0.50 lro on
Cannot change large-receive-offload
Could not change any device features
root@server1:# /sbin/ethtool -K ens4f0 lro on
Could not change any device features
root@server1:# ethtool -k ens4f0 | grep large
large-receive-offload: off [requested on]

# Now the only way to re-enable LRO on the parent port is to remove the subport
root@server1:# ip link del ens4f0.50
root@server1:# /sbin/ethtool -k ens4f0 | grep large
large-receive-offload: off [requested on]
root@server1:# /sbin/ethtool -K ens4f0 lro on
root@server1:# ethtool -k ens4f0 | grep large
large-receive-offload: on
===========================================================================

Although LRO may have different implications or issues in practice,
this seems a simple use case expected to work?--enabling LRO on the
physical NIC and also having vlans on the same NIC port.
Note, here both the parent port and the vlan subport are not attached
to any bridge, bond, team or ovs devices, just standalone.

This issue seems not driver or distro related, and lies in the kernel
network stack.
When changing netdev features, (via either userspace ethtool, or other
in-kernel processing), in the end:
__netdev_update_features() does the job and calls
netdev_sync_upper_features() and netdev_sync_lower_features()
both sync functions basically do one thing: make sure
NETIF_F_UPPER_DISABLES is consistently enforced among upper and lower
net devices.
currently NETIF_F_UPPER_DISABLES only includes NETIF_F_LRO

A lot of thoughts must have been given to this logic, and many
situations are considered for upper_devs like bond, team, bridge etc.
However, maybe a possible oversight is vlan_dev, which is an upper_dev
for its parent real_dev?
A vlan_dev is created with LRO unsupported by default, (NETIF_F_LRO
bit not set in hw_features).
As seen "fixed" in
root@server1:# ethtool -k ens4f0.50 | grep large
large-receive-offload: off [fixed]

Therefore, following the code path of upper_sync and lower_sync above,
once a vlan_dev is created, the parent real_dev can no longer set LRO
on.

Honestly, vlan_dev being treated as an upper_dev for the real_dev is a
bit counter-intuitive at the beginning, as people call them vlan
subports.
But, from the perspective that vlan_dev is a virtual device created
out of real_dev, it has somewhat "upper_dev" flavor, similar to
bond/team devices.
Kernel also associates upper_dev with some "master" role, and it makes
perfect sense for bond/team/bridge/ovs.
However, for vlan_dev, it sounds more like a slave dev to real_dev
(some people call real_dev parent port).
A secondary point, upper_dev (bond/team/bridge) typically has > 1
lower_dev, upper:lower normally has 1:N relationship.
For vlan_dev, it has only 1 lower_dev, upper:lower could often be N:1
relationship.

The above upper/lower sync logic probably stems from the "master" role
aspect of upper_dev, just that vlan_dev may not be a good fit for
this.
Probably that is where the confusion is.

Maybe I missed something, but this logic has been there for quite some
time (since v4.4 onwards, didn't try the latest, but tried pre-v4.4
kernels, no such issue under older kernels though).

Feel free to correct me.

Now, two possible solution proposals to fix this (if considered as an issue)
1. when creating/init a vlan_dev, set its hw_feature's NETIF_F_LRO bit
based on its underlying real_dev's hw_feature NETIF_F_LRO bit.
  (maybe not just hw_features, set wanted_feature as well?)
2. in netdev_sync_upper_features() and netdev_sync_lower_features()
exclude those upper_dev that is also a vlan_dev

Thanks for the attention.
Limin

p.s. another example of Centos-7.6 with VMXNET3 port
===========================================================================
# CentOS Linux release 7.6.1810 (Core)
root@esxi-server]# uname -a
Linux esxi-server 3.10.0-957.27.2.el7.x86_64 #1 SMP Mon Jul 29
17:46:05 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux

# VMXNET3 NIC
[root@esxi-server]# ethtool -i ens224
driver: vmxnet3
version: 1.4.14.0-k-NAPI

# LRO enabled on the NIC
[root@esxi-server]# ethtool -k ens224 | grep large
large-receive-offload: on

# create a vlan subport, NIC LRO still on
[root@esxi-server]# ip link add link ens224 name ens224.50 type vlan id 50
[root@esxi-server]# ifconfig ens224.50 up
[root@esxi-server]# ethtool -k ens224 | grep large
large-receive-offload: on
[root@esxi-server]# ethtool -k ens224.50 | grep large
large-receive-offload: off [fixed]

# now turn LRO off, and after that, LRO cannot be turned on any longer
[root@esxi-server]# ethtool -K ens224 lro off
[root@esxi-server]# ethtool -k ens224 | grep large
large-receive-offload: off
[root@esxi-server]# ethtool -k ens224.50 | grep large
large-receive-offload: off [fixed]
[root@esxi-server]# ethtool -K ens224 lro on
Could not change any device features
[root@esxi-server]# ethtool -k ens224 | grep large
large-receive-offload: off [requested on]
[root@esxi-server]# ethtool -k ens224.50 | grep large
large-receive-offload: off [fixed]

# Now the only way to re-enable LRO on the parent port is to remove the subport
[root@esxi-server]# ip link del ens224.50
[root@esxi-server]# ethtool -k ens224 | grep large
large-receive-offload: off [requested on]
[root@esxi-server]# ethtool -K ens224 lro on
[root@esxi-server]# ethtool -k ens224 | grep large
large-receive-offload: on
===========================================================================

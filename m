Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29A1C41AF71
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 14:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240807AbhI1M4x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 08:56:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:47526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240731AbhI1M4w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 08:56:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E31DA610E5;
        Tue, 28 Sep 2021 12:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632833713;
        bh=oC1KRsjYDcetg0hccLZehffW8qYBJJe3Kfv8Z++YyJM=;
        h=From:To:Cc:Subject:Date:From;
        b=Y6xhTtv+DBjAIUm/8rI7zcUoh+TJaUBVM5ZM+4VjbZlIjJ7F8h19bA3P8i3N0R375
         9ppHAgZkbeZafXDJY1TV67qJc+QU0ZwdYlSu8RLPqoLW21gqBTg7fwvORFBRQoGuok
         4TJQqqQV/ucoKUPbEdkMT37n7URMt9kjOezac5lqurpYaL5zPK8L31jTi2wPBAGq8y
         ZhrK77Dge7CkTrUrEM2fwKrvDElArLUnV9brVRQw1jNfCTotyM56JyUOlDieNKa34N
         ggNv8yy7ZxL57rNMdYbCcgE3fDMfEPhM9mH4fXARkr8MD3bjUY97IJwk9zhjowLGHO
         60cBXpGOPa8Ug==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>, pabeni@redhat.com,
        gregkh@linuxfoundation.org, ebiederm@xmission.com,
        stephen@networkplumber.org, herbert@gondor.apana.org.au,
        juri.lelli@redhat.com, netdev@vger.kernel.org
Subject: [RFC PATCH net-next 0/9] Userspace spinning on net-sysfs access
Date:   Tue, 28 Sep 2021 14:54:51 +0200
Message-Id: <20210928125500.167943-1-atenart@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

[Feel free to Cc anyone interested in this]

Please read this before looking at the patches: they are possible
improvements or fixes, that might or might not be acceptable, and there
might be other ways to improve the situation. But we at least wanted to
provide some pointers. Patch 1 is a possible workaround and the rest of
the series is an attempt at fixing this; the two are not necessarily
linked. More below.

We had a report creating pods had performance issues. This was seen when
using -rt kernel but we know it also happens on non-rt kernel (although
the performance impact is smaller). The issue is worse as multiple pods
are created, e.g. at boot time. The issue came down to userspace
spinning on net sysfs reads when virtual Ethernet pair devices were
created or moved: systemd-udevd, NetworkManager & others would wait for
events and trigger internal functions reading attributes such as
'phys_port_id' depending on 1) their implementation 2) the distro or
user configuration (udev rules for example). Tests showed the spin also
happens for a single veth pair creation (on both -rt and non-rt).

What made those syscalls to spin is the following construction (which is
found a lot in net sysfs and sysctl code):

  if (!rtnl_trylock())
          return restart_syscall();

Even with low lock contention if a syscall fails to take the rtnl lock
it goes back to VFS and spins in userspace, which has a huge impact
(compared to using rtnl_lock). The above construction is however there
for a good reason: it was introduced[1] years ago as a workaround to
deadlocks in net[2][3], as the initial issues were (and still are) not
the nice type.

Fixing the issue described here is simple, replacing rtnl_trylock &
restart_syscall with an rtnl_lock is enough. However the initial issues
have then to be fixed for the kernel to work properly.

First, a partial workaround is described in patch 1 ("net-sysfs: try not
to restart the syscall if it will fail eventually"). It is not a fix,
far from being perfect, nor it can be applied for all attributes. But it
does help a lot in most cases as the 'phys_*' attributes are read by
default by systemd and NM (and probably others) when adding or moving
interfaces; although those attributes are not always implemented (or not
at all for many virtual interfaces including veth) and eventually fail.

Then, to understand what could be done to fix this properly we need to
understand what are the initial deadlock issues the trylock/restart
construction fixed. An explanation is done in the initial thread[2];
here is a tl;dr: there are two ABBA deadlocks, between the net device
unregistration and the sysfs or sysctl unregistration (waiting for files
to be unused). Both can be seen as:

              A                            B

   unregister_netdevice_many         sysfs/sysctl access
   rtnl_lock                         sysfs/sysctl lock/refcount
				     rtnl_lock
   sysfs/sysctl drains files
   => waits for B                    => waits for A

We'll focus on net sysfs here[4]. One way to fix ABBA deadlocks is to
invert two locks:

- Looking at thread A, it doesn't seem OK to release and take back the
  rtnl lock in the sysfs draining logic (plus this would make the net
  device unregistration split, which would introduce other issues).

- Looking at thread B, we could take the rtnl lock before the sysfs
  refcount. But that needs to be done one layer up, as we can't access
  sysfs (kernfs) nodes without increasing their refcount first. In the
  end this would mean layers violation, lots of added helpers (there are
  multiple levels of indirections here) to access the rtnl lock. Or
  having it hardcoded in a non-net part. All this didn't looked good.

Another possibility would be to split the rtnl lock. That would be
great, some work already was done, but this is reasonably not for the
near future (if ever doable).

In the end we thought about doing the sysfs drain outside the rtnl lock.
The net device unregistration is already done in two parts:
unregister_netdevice_many and netdev_run_todo (where part of it drops
the rtnl lock). Moving device_del there does the trick, but another
change needs to be done: the naming collision logic has to be extended
until then. (Otherwise the net device name is free to be used between
unregister_netdevice_many and device_del, allowing a concurrent net
device registration to call device_add with the same name; which does
not end well).[6]

The drawback is this has implications about assumptions we currently
have regarding the net device lifecycle: there would now be a window
between starting the unregistration and running todo where names would
still be reserved. This would not be an "rtnl atomic" operation. I see
two new behaviours at least:

- It might be possible to not see a device with name A while still not
  be able to register a new one with the same name, for a short period
  of time.

- Maybe more problematic: __rtnl_newlink would now be able to fail
  because of naming collision. (The logic currently looks for an
  existing device, and if so uses it. With the extension of the naming
  collision, there would be a window were an interface is not usable
  *and* its name is still reserved).

An attempt at doing the above is provided: all patches expect 1.

Side note: netlink doesn't have the above issues (trylock isn't used
there). I know it is seen as the preferable interface for userspace (and
it allows to group attributes); but sysfs is there, used, and won't be
removed anytime soon (if ever).

Thanks for reading until here! Thoughts? Suggestions are more than
welcomed (either about the patches provided or about other ways to
improve the situation).

Antoine

[1] https://lore.kernel.org/netdev/20090226084924.16cb3e08@nehalam/
[2] https://lore.kernel.org/netdev/49A4D5D5.5090602@trash.net/
[3] https://lore.kernel.org/netdev/m14oyhis31.fsf@fess.ebiederm.org/
[4] The sysctl deadlock also happens when renaming a net device, as
    sysctl needs to go through unregistration/registration in an "rtnl
    atomic" operation (sysctl doesn't support renaming and this might
    not change[5]). It makes sense here to tackle first the net sysfs
    issue: while sysctl can be configured from userspace per-interface
    at device creation time, it is however not always used; sysfs is. (A
    fix for net sysfs could probably applied to sysctl with additional
    changes, making net sysfs a good first step candidate as well).
[5] https://elixir.bootlin.com/linux/latest/source/drivers/base/core.c#L4139
    This isn't linked to sysctl; but it might give an idea how
    improvements in device renaming support would be welcomed. (Not
    judging in any way).
[6] Alternatively sysfs_create_dir_ns could be modified not to call
    dump_stack on naming collisions. But 1) removing this would not only
    impact net 2) doing it conditionally looks quite invasive. (I think
    naming collision detection is also always done by subsystems and not
    expected to happen in device_*).

Antoine Tenart (9):
  net-sysfs: try not to restart the syscall if it will fail eventually
  net: split unlisting the net device from unlisting its node name
  net: export netdev_name_node_lookup
  bonding: use the correct function to check for netdev name collision
  ppp: use the correct function to check for netdev name collision
  net: use the correct function to check for netdev name collision
  net: delay the removal of the name nodes until run_todo
  net: delay device_del until run_todo
  net-sysfs: remove the use of rtnl_trylock/restart_syscall

 drivers/net/bonding/bond_sysfs.c |  4 +--
 drivers/net/ppp/ppp_generic.c    |  2 +-
 include/linux/netdevice.h        |  2 ++
 net/core/dev.c                   | 40 +++++++++++++++++-----
 net/core/net-sysfs.c             | 59 ++++++++------------------------
 5 files changed, 50 insertions(+), 57 deletions(-)

-- 
2.31.1


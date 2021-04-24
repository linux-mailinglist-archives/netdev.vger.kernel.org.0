Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E754D36A007
	for <lists+netdev@lfdr.de>; Sat, 24 Apr 2021 10:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233206AbhDXIDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Apr 2021 04:03:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:47236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231722AbhDXICK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Apr 2021 04:02:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C4EA61462;
        Sat, 24 Apr 2021 08:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619251281;
        bh=XDwlpZMJRYh6rtNo1bwuEHSTav3hdHOiP6db0kscWtg=;
        h=From:To:Cc:Subject:Date:From;
        b=cxHLqm1EM7Z5AEMkuNz34vd61Lsx2lxXSM6XhpD+vU7mVy7l0gqYiXALOZRRe4kN/
         XRIpUiJAIb6SR7w0auHXJtR7Lkn6O36X4wDk8RF/790nXmTTugTkAFutWD1jvNpD3S
         4pLOuJCE5kf7E+FtUV1i1Jk97EySXSxgYu33nYzgcNnfjQvz2Du8QVE3jTXA/WjsMw
         r1dF6zozx+dmB5LZvTEKypYMzZt2twbHYRIiasv/8lojGUd5s2SLWeh/fJ8qyahD/8
         jvtN/rqd1s1JhlYkkInaxOZUjA+bi7HjizM7X0y3P3UnJy3/LsrhkpP5kJUUIWfBJ2
         5zvIzkyOVO1oA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next V2 00/11] mlx5 External sub function controller
Date:   Sat, 24 Apr 2021 01:01:04 -0700
Message-Id: <20210424080115.97273-1-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Jakub,

This adds the support to instantiate Sub-Functions on external hosts.

changelog:
v1->v2:
 - fixed unused variable warning

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---

The following changes since commit b2f0ca00e6b34bd57c9298a869ea133699e8ec39:

  phy: nxp-c45-tja11xx: add interrupt support (2021-04-23 14:13:16 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2021-04-21

for you to fetch changes up to f1b9acd3a5e800bb68e7b8abc5b56d01faf68bbc:

  net/mlx5: SF, Extend SF table for additional SF id range (2021-04-24 00:59:07 -0700)

----------------------------------------------------------------
mlx5-updates-2021-04-21

devlink external port attribute for SF (Sub-Function) port flavour

This adds the support to instantiate Sub-Functions on external hosts
E.g when Eswitch manager is enabled on the ARM SmarNic SoC CPU, users
are now able to spawn new Sub-Functions on the Host server CPU.

Parav Pandit Says:
==================

This series introduces and uses external attribute for the SF port to
indicate that a SF port belongs to an external controller.

This is needed to generate unique phys_port_name when PF and SF numbers
are overlapping between local and external controllers.
For example two controllers 0 and 1, both of these controller have a SF.
having PF number 0, SF number 77. Here, phys_port_name has duplicate
entry which doesn't have controller number in it.

Hence, add controller number optionally when a SF port is for an
external controller. This extension is similar to existing PF and VF
eswitch ports of the external controller.

When a SF is for external controller an example view of external SF
port and config sequence:

On eswitch system:
$ devlink dev eswitch set pci/0033:01:00.0 mode switchdev

$ devlink port show
pci/0033:01:00.0/196607: type eth netdev enP51p1s0f0np0 flavour physical port 0 splittable false
pci/0033:01:00.0/131072: type eth netdev eth0 flavour pcipf controller 1 pfnum 0 external true splittable false
  function:
    hw_addr 00:00:00:00:00:00

$ devlink port add pci/0033:01:00.0 flavour pcisf pfnum 0 sfnum 77 controller 1
pci/0033:01:00.0/163840: type eth netdev eth1 flavour pcisf controller 1 pfnum 0 sfnum 77 splittable false
  function:
    hw_addr 00:00:00:00:00:00 state inactive opstate detached

phys_port_name construction:
$ cat /sys/class/net/eth1/phys_port_name
c1pf0sf77

Patch summary:
First 3 patches prepares the eswitch to handle vports in more generic
way using xarray to lookup vport from its unique vport number.
Patch-1 returns maximum eswitch ports only when eswitch is enabled
Patch-2 prepares eswitch to return eswitch max ports from a struct
Patch-3 uses xarray for vport and representor lookup
Patch-4 considers SF for an additioanl range of SF vports
Patch-5 relies on SF hw table to check SF support
Patch-6 extends SF devlink port attribute for external flag
Patch-7 stores the per controller SF allocation attributes
Patch-8 uses SF function id for filtering events
Patch-9 uses helper for allocation and free
Patch-10 splits hw table into per controller table and generic one
Patch-11 extends sf table for additional range

==================

----------------------------------------------------------------
Parav Pandit (11):
      net/mlx5: E-Switch, Return eswitch max ports when eswitch is supported
      net/mlx5: E-Switch, Prepare to return total vports from eswitch struct
      net/mlx5: E-Switch, Use xarray for vport number to vport and rep mapping
      net/mlx5: E-Switch, Consider SF ports of host PF
      net/mlx5: SF, Rely on hw table for SF devlink port allocation
      devlink: Extend SF port attributes to have external attribute
      net/mlx5: SF, Store and use start function id
      net/mlx5: SF, Consider own vhca events of SF devices
      net/mlx5: SF, Use helpers for allocation and free
      net/mlx5: SF, Split mlx5_sf_hw_table into two parts
      net/mlx5: SF, Extend SF table for additional SF id range

 .../mellanox/mlx5/core/esw/acl/egress_lgcy.c       |   2 +-
 .../mellanox/mlx5/core/esw/acl/egress_ofld.c       |   4 +-
 .../ethernet/mellanox/mlx5/core/esw/acl/helper.c   |   8 +-
 .../ethernet/mellanox/mlx5/core/esw/acl/helper.h   |   2 +-
 .../mellanox/mlx5/core/esw/acl/ingress_lgcy.c      |   2 +-
 .../mellanox/mlx5/core/esw/acl/ingress_ofld.c      |   4 +-
 .../ethernet/mellanox/mlx5/core/esw/devlink_port.c |   7 +-
 .../net/ethernet/mellanox/mlx5/core/esw/legacy.c   |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  | 276 +++++++++++++++----
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  | 193 +++-----------
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 293 ++++++++++++++-------
 .../net/ethernet/mellanox/mlx5/core/sf/dev/dev.c   |  12 +-
 .../net/ethernet/mellanox/mlx5/core/sf/devlink.c   |  38 +--
 .../net/ethernet/mellanox/mlx5/core/sf/hw_table.c  | 256 +++++++++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/sf/priv.h  |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/vport.c    |  14 -
 include/linux/mlx5/eswitch.h                       |  11 +-
 include/linux/mlx5/vport.h                         |   8 -
 include/net/devlink.h                              |   5 +-
 net/core/devlink.c                                 |  11 +-
 20 files changed, 724 insertions(+), 434 deletions(-)

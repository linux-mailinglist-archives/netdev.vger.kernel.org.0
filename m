Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFE89E0AE1
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 19:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731781AbfJVRnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 13:43:17 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:55786 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730432AbfJVRnR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 13:43:17 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from yuvalav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 22 Oct 2019 19:43:14 +0200
Received: from sw-mtx-008.mtx.labs.mlnx (sw-mtx-008.mtx.labs.mlnx [10.9.150.35])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x9MHhDg5005557;
        Tue, 22 Oct 2019 20:43:14 +0300
Received: from sw-mtx-008.mtx.labs.mlnx (localhost [127.0.0.1])
        by sw-mtx-008.mtx.labs.mlnx (8.14.7/8.14.7) with ESMTP id x9MHhDBS023978;
        Tue, 22 Oct 2019 20:43:13 +0300
Received: (from yuvalav@localhost)
        by sw-mtx-008.mtx.labs.mlnx (8.14.7/8.14.7/Submit) id x9MHhBxg023977;
        Tue, 22 Oct 2019 20:43:11 +0300
From:   Yuval Avnery <yuvalav@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jiri@mellanox.com, saeedm@mellanox.com, leon@kernel.org,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        shuah@kernel.org, Yuval Avnery <yuvalav@mellanox.com>
Subject: [PATCH net-next 0/9] devlink vdev
Date:   Tue, 22 Oct 2019 20:43:01 +0300
Message-Id: <1571766190-23943-1-git-send-email-yuvalav@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset introduces devlink vdev.

Currently, legacy tools do not provide a comprehensive solution that can
be used in both SmartNic and non-SmartNic mode.
Vdev represents a device that exists on the ASIC but is not necessarily
visible to the kernel.

Using devlink ports is not suitable because:

1. Those devices aren't necessarily network devices (such as NVMe devices)
   and doesn’t have E-switch representation. Therefore, there is need for
   more generic representation of PCI VF.
2. Some attributes are not necessarily pure port attributes
   (number of MSIX vectors)
3. It creates a confusing devlink topology, with multiple port flavours
   and indices.

Vdev will be created along with flavour and attributes.
Some network vdevs may be linked with a devlink port.

This is also aimed to replace "ip link vf" commands as they are strongly
linked to the PCI topology and allow access only to enabled VFs.
Even though current patchset and example is limited to MAC address
of the VF, this interface will allow to manage PF, VF, mdev in
SmartNic and non SmartNic modes, in unified way for networking and
non-networking devices via devlink instance.

Example:

A privileged user wants to configure a VF's hw_addr, before the VF is
enabled.

$ devlink vdev set pci/0000:03:00.0/1 hw_addr 10:22:33:44:55:66

$ devlink vdev show pci/0000:03:00.0/1
pci/0000:03:00.0/1: flavour pcivf pf 0 vf 0 port_index 1 hw_addr 10:22:33:44:55:66

$ devlink vdev show pci/0000:03:00.0/1 -jp
{
    "vdev": {
        "pci/0000:03:00.0/1": {
            "flavour": "pcivf",
            "pf": 0,
            "vf": 0,
            "port_index": 1,
            "hw_addr": "10:22:33:44:55:66"
        }
    }
}

Patches 1-5 adds devlink support for vdev.
Patches 6-7 adds netdevsim implementation and test.
Patch 9 adds mlx5 vdev creation and hw_addr get/set.

Yuval Avnery (9):
  devlink: Introduce vdev
  devlink: Add PCI attributes support for vdev
  devlink: Add port with vdev register support
  devlink: Support vdev HW address get
  devlink: Support vdev HW address set
  netdevsim: Add max_vfs to bus_dev
  netdevsim: Add devlink vdev creation
  netdevsim: Add devlink vdev sefltest for netdevsim
  net/mlx5e: Add support for devlink vdev and vdev hw_addr set/show

 .../net/ethernet/mellanox/mlx5/core/devlink.c |  86 ++++
 .../net/ethernet/mellanox/mlx5/core/devlink.h |   5 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   6 +-
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |   9 +-
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  19 +-
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |   7 +-
 .../mellanox/mlx5/core/eswitch_offloads.c     |   8 +
 drivers/net/netdevsim/Makefile                |   2 +-
 drivers/net/netdevsim/bus.c                   |  39 +-
 drivers/net/netdevsim/dev.c                   |   9 +-
 drivers/net/netdevsim/netdevsim.h             |  11 +
 drivers/net/netdevsim/vdev.c                  |  96 +++++
 include/net/devlink.h                         |  44 ++
 include/uapi/linux/devlink.h                  |  16 +
 net/core/devlink.c                            | 393 +++++++++++++++++-
 .../drivers/net/netdevsim/devlink.sh          |  55 ++-
 16 files changed, 777 insertions(+), 28 deletions(-)
 create mode 100644 drivers/net/netdevsim/vdev.c

-- 
2.17.1


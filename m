Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34FFCF50DD
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 17:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbfKHQS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 11:18:57 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:60236 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725941AbfKHQS4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 11:18:56 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from yuvalav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 8 Nov 2019 18:18:51 +0200
Received: from sw-mtx-008.mtx.labs.mlnx (sw-mtx-008.mtx.labs.mlnx [10.9.150.35])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id xA8GInuj003095;
        Fri, 8 Nov 2019 18:18:50 +0200
Received: from sw-mtx-008.mtx.labs.mlnx (localhost [127.0.0.1])
        by sw-mtx-008.mtx.labs.mlnx (8.14.7/8.14.7) with ESMTP id xA8GIm11030079;
        Fri, 8 Nov 2019 18:18:48 +0200
Received: (from yuvalav@localhost)
        by sw-mtx-008.mtx.labs.mlnx (8.14.7/8.14.7/Submit) id xA8GIlTW030078;
        Fri, 8 Nov 2019 18:18:47 +0200
From:   Yuval Avnery <yuvalav@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jiri@mellanox.com, saeedm@mellanox.com, leon@kernel.org,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        shuah@kernel.org, danielj@mellanox.com, parav@mellanox.com,
        andrew.gospodarek@broadcom.com, michael.chan@broadcom.com,
        Yuval Avnery <yuvalav@mellanox.com>
Subject: [PATCH net-next v2 00/10] devlink subdev
Date:   Fri,  8 Nov 2019 18:18:36 +0200
Message-Id: <1573229926-30040-1-git-send-email-yuvalav@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset introduces devlink subdev.

Currently, legacy tools do not provide a comprehensive solution that can
be used in both SmartNic and non-SmartNic mode.
Subdev represents a device that exists on the ASIC but is not necessarily
visible to the kernel.

Using devlink ports is not suitable because:

1. Those devices aren't necessarily network devices (such as NVMe devices)
   and doesn’t have E-switch representation. Therefore, there is need for
   more generic representation of PCI VF.
2. Some attributes are not necessarily pure port attributes
   (number of MSIX vectors)
3. It creates a confusing devlink topology, with multiple port flavours
   and indices.

Subdev will be created along with flavour and attributes.
Some network subdevs may be linked with a devlink port.

This is also aimed to replace "ip link vf" commands as they are strongly
linked to the PCI topology and allow access only to enabled VFs.
Even though current patchset and example is limited to MAC address
of the VF, this interface will allow to manage PF, VF, mdev in
SmartNic and non SmartNic modes, in unified way for networking and
non-networking devices via devlink instance.

Use case example:
An example system view of a networking ASIC (aka SmartNIC), can be seen in
below diagram, where devlink eswitch instance and PCI PF and/or VFs are
situated on two different CPU subsystems:


      +------------------------------+
      |                              |
      |             HOST             |
      |                              |
      |   +----+-----+-----+-----+   |
      |   | PF | VF0 | VF1 | VF2 |   |
      +---+----+-----------+-----+---+
                 PCI1|
          +---+------------+
              |
     +----------------------------------------+
     |        |         SmartNic              |
     |   +----+-------------------------+     |
     |   |                              |     |
     |   |               NIC            |     |
     |   |                              |     |
     |   +---------------------+--------+     |
     |                         |  PCI2        |
     |         +-----+---------+--+           |
     |               |                        |
     |      +-----+--+--+--------------+      |
     |      |     | PF  |              |      |
     |      |     +-----+              |      |
     |      |      Embedded CPU        |      |
     |      |                          |      |
     |      +--------------------------+      |
     |                                        |
     +----------------------------------------+

The below diagram shows an example devlink subdev topology where some
subdevs are connected to devlink ports::



            (PF0)    (VF0)    (VF1)           (NVME VF2)
         +--------------------------+         +--------+
         | devlink| devlink| devlink|         | devlink|
         | subdev | subdev | subdev |         | subdev |
         |    0   |    1   |    2   |         |    3   |
         +--------------------------+         +--------+
              |        |        |
              |        |        |
              |        |        |
     +----------------------------------+
     |   | devlink| devlink| devlink|   |
     |   |  port  |  port  |  port  |   |
     |   |    0   |    1   |    2   |   |
     |   +--------------------------+   |
     |                                  |
     |                                  |
     |           E-switch               |
     |                                  |
     |                                  |
     |          +--------+              |
     |          | uplink |              |
     |          | devlink|              |
     |          |  port  |              |
     +----------------------------------+
 
Devlink command example:

A privileged user wants to configure a VF's hw_addr, before the VF is
enabled.

$ devlink subdev set pci/0000:03:00.0/1 hw_addr 10:22:33:44:55:66

$ devlink subdev show pci/0000:03:00.0/1
pci/0000:03:00.0/1: flavour pcivf pf 0 vf 0 port_index 1 hw_addr 10:22:33:44:55:66

$ devlink subdev show pci/0000:03:00.0/1 -jp
{
    "subdev": {
        "pci/0000:03:00.0/1": {
            "flavour": "pcivf",
            "pf": 0,
            "vf": 0,
            "port_index": 1,
            "hw_addr": "10:22:33:44:55:66"
        }
    }
}

Patches 1-6 adds devlink support for subdev.
Patches 7-8 adds netdevsim implementation and test.
Patch 10 adds mlx5 subdev creation and hw_addr get/set.

---

v1->v2:
 - vdev -> subdev
 - Update cover letter and add more examples.

Yuval Avnery (10):
  devlink: Introduce subdev
  devlink: Add PCI attributes support for subdev
  devlink: Add port with subdev register support
  devlink: Support subdev HW address get
  devlink: Support subdev HW address set
  Documentation: Add devlink-subdev documentation.
  netdevsim: Add max_vfs to bus_dev
  netdevsim: Add devlink subdev creation
  netdevsim: Add devlink subdev sefltest for netdevsim
  net/mlx5e: Add support for devlink subdev and subdev hw_addr set/show

 Documentation/networking/devlink-subdev.rst   |  96 +++++
 .../net/ethernet/mellanox/mlx5/core/devlink.c |  92 ++++
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
 drivers/net/netdevsim/subdev.c                |  99 +++++
 include/net/devlink.h                         |  46 ++
 include/uapi/linux/devlink.h                  |  16 +
 net/core/devlink.c                            | 403 +++++++++++++++++-
 .../drivers/net/netdevsim/devlink.sh          |  55 ++-
 17 files changed, 894 insertions(+), 28 deletions(-)
 create mode 100644 Documentation/networking/devlink-subdev.rst
 create mode 100644 drivers/net/netdevsim/subdev.c

-- 
2.17.1


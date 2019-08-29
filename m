Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CED3EA1819
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 13:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbfH2LTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 07:19:17 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:43720 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728094AbfH2LTP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 07:19:15 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 29 Aug 2019 14:19:11 +0300
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.12.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x7TBJ8v1020002;
        Thu, 29 Aug 2019 14:19:09 +0300
From:   Parav Pandit <parav@mellanox.com>
To:     alex.williamson@redhat.com, jiri@mellanox.com,
        kwankhede@nvidia.com, cohuck@redhat.com, davem@davemloft.net
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Parav Pandit <parav@mellanox.com>
Subject: [PATCH v2 0/6] Introduce variable length mdev alias
Date:   Thu, 29 Aug 2019 06:18:58 -0500
Message-Id: <20190829111904.16042-1-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190826204119.54386-1-parav@mellanox.com>
References: <20190826204119.54386-1-parav@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To have consistent naming for the netdevice of a mdev and to have
consistent naming of the devlink port [1] of a mdev, which is formed using
phys_port_name of the devlink port, current UUID is not usable because
UUID is too long.

UUID in string format is 36-characters long and in binary 128-bit.
Both formats are not able to fit within 15 characters limit of netdev
name.

It is desired to have mdev device naming consistent using UUID.
So that widely used user space framework such as ovs [2] can make use
of mdev representor in similar way as PCIe SR-IOV VF and PF representors.

Hence,
(a) mdev alias is created which is derived using sha1 from the mdev name.
(b) Vendor driver describes how long an alias should be for the child mdev
created for a given parent.
(c) Mdev aliases are unique at system level.
(d) alias is created optionally whenever parent requested.
This ensures that non networking mdev parents can function without alias
creation overhead.

This design is discussed at [3].

An example systemd/udev extension will have,

1. netdev name created using mdev alias available in sysfs.

mdev UUID=83b8f4f2-509f-382f-3c1e-e6bfe0fa1001
mdev 12 character alias=cd5b146a80a5

netdev name of this mdev = enmcd5b146a80a5
Here en = Ethernet link
m = mediated device

2. devlink port phys_port_name created using mdev alias.
devlink phys_port_name=pcd5b146a80a5

This patchset enables mdev core to maintain unique alias for a mdev.

Patch-1 Introduces mdev alias using sha1.
Patch-2 Ensures that mdev alias is unique in a system.
Patch-3 Exposes mdev alias in a sysfs hirerchy.
Patch-4 Introduces mdev_alias() API.
Patch-5 Updated sysfs documentation
Patch-6 Extends mtty driver to optionally provide alias generation.
This also enables to test UUID based sha1 collision and trigger
error handling for duplicate sha1 results.

[1] http://man7.org/linux/man-pages/man8/devlink-port.8.html
[2] https://docs.openstack.org/os-vif/latest/user/plugins/ovs.html
[3] https://patchwork.kernel.org/cover/11084231/

---
Changelog:
v1->v2:
 - Corrected a typo from 'and' to 'an'
 - Addressed comments from Alex Williamson
 - Kept mdev_device naturally aligned
 - Added error checking for crypt_*() calls
 - Moved alias NULL check at beginning
 - Added mdev_alias() API
 - Updated mtty driver to show example mdev_alias() usage
 - Changed return type of generate_alias() from int to char*
v0->v1:
 - Addressed comments from Alex Williamson, Cornelia Hunk and Mark Bloch
 - Moved alias length check outside of the parent lock
 - Moved alias and digest allocation from kvzalloc to kzalloc
 - &alias[0] changed to alias
 - alias_length check is nested under get_alias_length callback check
 - Changed comments to start with an empty line
 - Added comment where alias memory ownership is handed over to mdev device
 - Fixed cleaunup of hash if mdev_bus_register() fails
 - Updated documentation for new sysfs alias file
 - Improved commit logs to make description more clear
 - Fixed inclusiong of alias for NULL check
 - Added ratelimited debug print for sha1 hash collision error

Parav Pandit (6):
  mdev: Introduce sha1 based mdev alias
  mdev: Make mdev alias unique among all mdevs
  mdev: Expose mdev alias in sysfs tree
  mdev: Introduce an API mdev_alias
  mdev: Update sysfs documentation
  mtty: Optionally support mtty alias

 .../driver-api/vfio-mediated-device.rst       |   5 +
 drivers/vfio/mdev/mdev_core.c                 | 142 +++++++++++++++++-
 drivers/vfio/mdev/mdev_private.h              |   5 +-
 drivers/vfio/mdev/mdev_sysfs.c                |  26 +++-
 include/linux/mdev.h                          |   5 +
 samples/vfio-mdev/mtty.c                      |  13 ++
 6 files changed, 186 insertions(+), 10 deletions(-)

-- 
2.19.2


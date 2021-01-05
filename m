Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 321612EA8D4
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 11:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729059AbhAEKdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 05:33:02 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:15997 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728460AbhAEKdB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 05:33:01 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ff440350006>; Tue, 05 Jan 2021 02:32:21 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 5 Jan
 2021 10:32:20 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <virtualization@lists.linux-foundation.org>
CC:     <mst@redhat.com>, <jasowang@redhat.com>, <parav@nvidia.com>,
        <elic@nvidia.com>, <netdev@vger.kernel.org>
Subject: [PATCH linux-next v3 0/6] Introduce vdpa management tool
Date:   Tue, 5 Jan 2021 12:31:57 +0200
Message-ID: <20210105103203.82508-1-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201112064005.349268-1-parav@nvidia.com>
References: <20201112064005.349268-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1609842741; bh=Q+z9tAzool1itBaUooZ7QxS2JmVAriUZbpqZsraY7YU=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=UM35m06wyUnUPtojjdLcYao256UaIX1khSCIb6BNzcA9nq4FfZqEoI2WrXVT2qxMI
         a81Z/Qe5+vCJ1XHrEi1pC5FoHxzEyqOeyg8K6Si3XLApfBpozePX7qAghSi1wy+3Jr
         5zg+cWHzas1aey9q8hBXHxAanCbjcgV7oQ3ItchuiBIMks9xbh0vqKGEAqFF/+0bfX
         hSgFFiV9eyVwz+4lyBcOv2G01xygLk9BfcVx9VS8/iqjABU8gcZ1Xv6bAyJJALYh3C
         gIbi6Rcm24nlBZKsYqjUxN53jZ+zT5ZH7LrA8mP5LQqWLPlYxZQ4yFP9u66aJBuwGp
         0eJ6BoXIr2pIQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset covers user requirements for managing existing vdpa devices,
using a tool and its internal design notes for kernel drivers.

Background and user requirements:
----------------------------------
(1) Currently VDPA device is created by driver when driver is loaded.
However, user should have a choice when to create or not create a vdpa
device for the underlying management device.

For example, mlx5 PCI VF and subfunction device supports multiple classes o=
f
device such netdev, vdpa, rdma. Howevever it is not required to always
created vdpa device for such device.

(2) In another use case, a device may support creating one or multiple vdpa
device of same or different class such as net and block.
Creating vdpa devices at driver load time further limits this use case.

(3) A user should be able to monitor and query vdpa queue level or device
level statistics for a given vdpa device.

(4) A user should be able to query what class of vdpa devices are supported
by its management device.

(5) A user should be able to view supported features and negotiated
features of the vdpa device.

(6) A user should be able to create a vdpa device in vendor agnostic manner
using single tool.

Hence, it is required to have a tool through which user can create one or
more vdpa devices from a management device which addresses above user
requirements.

Example devices:
----------------
 +-----------+ +-----------+ +---------+ +--------+ +-----------+=20
 |vdpa dev 0 | |vdpa dev 1 | |rdma dev | |netdev  | |vdpa dev 3 |
 |type=3Dnet   | |type=3Dnet   | |mlx5_0   | |ens3f0  | |type=3Dnet   |
 +----+------+ +-----+-----+ +----+----+ +-----+--+ +----+------+
      |              |            |            |         |
      |              |            |            |         |
 +----+-----+        |       +----+----+       |    +----+----+
 |  mlx5    +--------+       |mlx5     +-------+    |mlx5     |
 |pci vf 2  |                |pci vf 4 |            |pci sf 8 |
 |03:00:2   |                |03:00.4  |            |mlx5_sf.8|
 +----+-----+                +----+----+            +----+----+
      |                           |                      |
      |                      +----+-----+                |
      +----------------------+mlx5      +----------------+
                             |pci pf 0  |
                             |03:00.0   |
                             +----------+

vdpa tool:
----------
vdpa tool is a tool to create, delete vdpa devices from a management
device. It is a tool that enables user to query statistics, features
and may be more attributes in future.

vdpa tool command draft:
------------------------
(a) List management devices which support creating vdpa devices.
It also shows which class types supported by this management device.
In below command example four management devices support vdpa device
creation.

First is simulated vdpasim_net management device.
Second is PCI VF whose bdf is 03.00:2.
Third is PCI VF whose name is 03:00.4.
Forth is PCI SF whose name is mlx5_core.sf.8

$ vdpa mgmtdev list
vdpasim_net
  supported_classes
    net
pci/0000:03.00:0
  supported_classes
    net
pci/0000:03.00:4
  supported_classes
    net
auxiliary/mlx5_core.sf.8
  supported_classes
    net

(b) Now add a vdpa device of networking class and show the device.
$ vdpa dev add mgmtdev pci/0000:03.00:0 name foo0

$ vdpa dev show foo0
foo0: mgmtdev pci/0000:03.00:2 type network vendor_id 0 max_vqs 2 max_vq_si=
ze 256

(c) Show features of a vdpa device
$ vdpa dev features show foo0
supported
  iommu platform
  version 1

(d) Dump vdpa device statistics
$ vdpa dev stats show foo0
kickdoorbells 10
wqes 100

(e) Now delete a vdpa device previously created.
$ vdpa dev del foo0

vdpa tool support in this patchset:
-----------------------------------
vdpa tool is created to create, delete and query vdpa devices.
examples:
Show vdpa management device that supports creating, deleting vdpa devices.

$ vdpa mgmtdev show
vdpasim_net:
  supported_classes
    net

$ vdpa mgmtdev show -jp
{
    "show": {
       "vdpasim_net": {
          "supported_classes": {
             "net"
        }
    }
}

Create a vdpa device of type networking named as "foo2" from the
management device vdpasim_net:

$ vdpa dev add mgmtdev vdpasim_net name foo2

Show the newly created vdpa device by its name:
$ vdpa dev show foo2
foo2: type network mgmtdev vdpasim_net vendor_id 0 max_vqs 2 max_vq_size 25=
6

$ vdpa dev show foo2 -jp
{
    "dev": {
        "foo2": {
            "type": "network",
            "mgmtdev": "vdpasim_net",
            "vendor_id": 0,
            "max_vqs": 2,
            "max_vq_size": 256
        }
    }
}

Delete the vdpa device after its use:
$ vdpa dev del foo2

vdpa tool support by kernel:
----------------------------
vdpa tool user interface is supported by existing vdpa kernel framework,
i.e. drivers/vdpa/vdpa.c It services user command through a netlink interfa=
ce.

Each management device registers supported callback operations with vdpa
subsystem through which vdpa device(s) can be managed.

Patch summary:
--------------
Patch-1 Makes mac address array static
Patch-2 Extends API to accept vdpa device name
Patch-3 Defines management device interface
Patch-4 Extends netlink interface to add, delete vdpa devices
Patch-5 Extends netlink interface to query vdpa device attributes
Patch-6 Extends vdpa_sim_net driver to add/delete simulated vdpa devices

Changelog:
----------
v2->v3:
 - removed default device module param patch
 - removed code branches due to removal of default device module param
   patch
 - removed two merged patches from v1
 - added patch to make mac address static
v1->v2:
 - rebased
 - moved code from vdpasim to vdpa_sim_net module as code is split
   between two modules
 - removed device_id field during device create as its not used
   currently
 - updated examples in commit log for management device name and
   device_id removal
 - changed parentdev to mgmtdev as tool reflects management
   functionality

FAQs:
-----
1. Where does userspace vdpa tool reside which users can use?
Ans: vdpa tool can possibly reside in iproute2 [1] as it enables user to
handler vdpa network devices.

2. Why not create and delete vdpa device using sysfs/configfs?
Ans:
(a) A device creation may involve passing one or more attributes.
Passing multiple attributes and returning error code and more verbose
information for invalid attributes cannot be handled by sysfs/configfs.

(b) netlink framework is rich that enables user space and kernel driver to
provide nested attributes.

(c) Exposing device specific file under sysfs without net namespace
awareness exposes details to multiple containers. Instead exposing
attributes via a netlink socket secures the communication channel with kern=
el.

(d) netlink socket interface enables to run syscaller kernel tests.

3. Why not use ioctl() interface?
Ans: ioctl() interface replicates the necessary plumbing which already
exists through netlink socket.

4. What happens when one or more user created vdpa devices exist for a
management PCI VF or SF and such management device is removed?
Ans: All user created vdpa devices are removed that belong to a
management device.

[1] git://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git

Next steps:
-----------
(a) Post this patchset and iproute2/vdpa inclusion, remaining two drivers
will be coverted to support vdpa tool instead of creating unmanaged default
device on driver load.
(b) More net specific parameters such as mac, mtu will be added.
(c) Features bits get and set interface will be added.

Parav Pandit (6):
  vdpa_sim_net: Make mac address array static
  vdpa: Extend routine to accept vdpa device name
  vdpa: Define vdpa mgmt device, ops and a netlink interface
  vdpa: Enable a user to add and delete a vdpa device
  vdpa: Enable user to query vdpa device info
  vdpa_sim_net: Add support for user supported devices

 drivers/vdpa/Kconfig                 |   1 +
 drivers/vdpa/ifcvf/ifcvf_main.c      |   2 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c    |   2 +-
 drivers/vdpa/vdpa.c                  | 503 ++++++++++++++++++++++++++-
 drivers/vdpa/vdpa_sim/vdpa_sim.c     |   3 +-
 drivers/vdpa/vdpa_sim/vdpa_sim.h     |   2 +
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c |  98 ++++--
 include/linux/vdpa.h                 |  44 ++-
 include/uapi/linux/vdpa.h            |  40 +++
 9 files changed, 657 insertions(+), 38 deletions(-)
 create mode 100644 include/uapi/linux/vdpa.h

--=20
2.26.2


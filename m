Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 449872E8F95
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 04:35:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbhADDc6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 22:32:58 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:10276 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726688AbhADDc5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jan 2021 22:32:57 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ff28c410000>; Sun, 03 Jan 2021 19:32:17 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 4 Jan
 2021 03:32:16 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <virtualization@lists.linux-foundation.org>
CC:     <mst@redhat.com>, <jasowang@redhat.com>, <parav@nvidia.com>,
        <elic@nvidia.com>, <netdev@vger.kernel.org>
Subject: [PATCH linux-next v2 0/7] Introduce vdpa management tool
Date:   Mon, 4 Jan 2021 05:31:34 +0200
Message-ID: <20210104033141.105876-1-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201112064005.349268-1-parav@nvidia.com>
References: <20201112064005.349268-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1609731137; bh=VWEj3029SIsYfpGWtDFsCRPZSRP9LMEAt5loHvhcasc=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=kMiVmC46jABVP0jOWmjkk/q+dGVtAM/KfzMKcVsb2HbHVMOaCbhGeFfHg0hyVuivf
         5R6nu+38FL3tpbYKbxyOOR/LIFJe9zSAap2VFvtWQ7SC2/40g8I3Q8MizkMVOeXu60
         uPJt56CZxA+amLzU/M4HYEvy0opJV/+1cvCvCwTJWEzvbHuDwAsKcMyRBCqaGF4iCn
         7/zUCn9TKIaAjdrnmUy84uM8y9VjR9rRXGtAe/0+Vl44i/CvwdDMJKuXLrDlczUuw9
         eCIrL6QElViK0W2ZFXjAWJrcWC1Ew0HmHQh6Nmnftw4bdXrCWdEur0Z38wiWiH8Q4r
         EeIcB0p3gwRJQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset covers user requirements for managing existing vdpa devices,
using a tool and its internal design notes for kernel drivers.

Background and user requirements:
----------------------------------
(1) Currently VDPA device is created by driver when driver is loaded.
However, user should have a choice when to create or not create a vdpa devi=
ce
for the underlying management device.

For example, mlx5 PCI VF and subfunction device supports multiple classes o=
f
device such netdev, vdpa, rdma. Howevever it is not required to always crea=
ted
vdpa device for such device.

(2) In another use case, a device may support creating one or multiple vdpa
device of same or different class such as net and block.
Creating vdpa devices at driver load time further limits this use case.

(3) A user should be able to monitor and query vdpa queue level or device l=
evel
statistics for a given vdpa device.

(4) A user should be able to query what class of vdpa devices are supported
by its management device.

(5) A user should be able to view supported features and negotiated feature=
s
of the vdpa device.

(6) A user should be able to create a vdpa device in vendor agnostic manner
using single tool.

Hence, it is required to have a tool through which user can create one or m=
ore
vdpa devices from a management device which addresses above user requiremen=
ts.

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
vdpa tool is a tool to create, delete vdpa devices from a management device=
.
It is a tool that enables user to query statistics, features and may be mor=
e
attributes in future.

vdpa tool command draft:
------------------------
(a) List management devices which support creating vdpa devices.
It also shows which class types supported by this management device.
In below command example four management devices support vdpa device creati=
on.
First is PCI VF whose bdf is 03.00:2.
Second is PCI VF whose name is 03:00.4.
Third is PCI SF whose name is mlx5_core.sf.8

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
management device vdpasim:

$ vdpa dev add mgmtdev vdpasim type net name foo2

Show the newly created vdpa device by its name:
$ vdpa dev show foo2
foo2: type network mgmtdev vdpasim vendor_id 0 max_vqs 2 max_vq_size 256

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
vdpa tool user interface will be supported by existing vdpa kernel framewor=
k,
i.e. drivers/vdpa/vdpa.c It services user command through a netlink interfa=
ce.

Each management device registers supported callback operations with vdpa
subsystem through which vdpa device(s) can be managed.

Patch summary:
--------------
Patch-1 Makes mac address array static
Patch-2 adds module parameter to avoid breaking backward compatibility
        for default device
Patch-3 Extends API to accept vdpa device name
Patch-4 Defines management device interface
Patch-5 Extends netlink interface to add, delete vdpa devices
Patch-6 Extends netlink interface to query vdpa device attributes
Patch-7 Extends vdpa_sim_net driver to add/delete simulated vdpa devices

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

Parav Pandit (7):
  vdpa_sim_net: Make mac address array static
  vdpa_sim_net: Add module param to disable default vdpa net device
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
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c | 135 ++++++-
 include/linux/vdpa.h                 |  44 ++-
 include/uapi/linux/vdpa.h            |  40 +++
 9 files changed, 707 insertions(+), 25 deletions(-)
 create mode 100644 include/uapi/linux/vdpa.h

--=20
2.26.2


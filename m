Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFC64316EE5
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 19:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233933AbhBJSip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 13:38:45 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:2774 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231543AbhBJSfq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 13:35:46 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B602427530000>; Wed, 10 Feb 2021 10:34:59 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 10 Feb
 2021 18:34:58 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>, <mst@redhat.com>,
        <jasowang@redhat.com>
CC:     Parav Pandit <parav@nvidia.com>
Subject: [PATCH iproute2-next v5 0/5] Add vdpa device management tool
Date:   Wed, 10 Feb 2021 20:34:40 +0200
Message-ID: <20210210183445.1009795-1-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612982099; bh=JrBd8bjR5X17Xw0ChiwqzFey7ZoXv5uySBPzIFsCoUA=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Transfer-Encoding:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=f6FOaAeHA2hWq/ocBmDBGtHHialpopwaAGRPPSgmOsN0XEFcN8sz0BZ3icXJ9H4Y/
         wN//pSsWnoh/qDdFLsr5wHfHdXKGt2gTGaXrIYy3kSrmco4smExqqu8EfIbotox1YD
         Fy3OJEiHsoXgH1P42ESgZnrbWVdYdxsXOnA5HMLk8qbJaU9tHAfvGlCg2L4fPMjWEI
         Pb38H7t5Kk/h+Htcc+pbCeSK/+2TzZkaT8eNaMdrMWtUm8zi5+IP3S+46t+G266p3N
         Qze9D0MWKpzrQ79PZZ1txLUeeLso/HqrDiLPy7ymgKnS8g84cNWzgu4ZmIdWOw7IrA
         9AkWhbJBCTzIw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Linux vdpa interface allows vdpa device management functionality.
This includes adding, removing, querying vdpa devices.

vdpa interface also includes showing supported management devices
which support such operations.

This patchset includes kernel uapi headers and a vdpa tool.

examples:

$ vdpa mgmtdev show
vdpasim:
  supported_classes net

$ vdpa mgmtdev show -jp
{
    "show": {
        "vdpasim": {
            "supported_classes": [ "net" ]
        }
    }
}

Create a vdpa device of type networking named as "foo2" from
the management device vdpasim_net:

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

An example of PCI PF, VF and SF management device:
pci/0000:03.00:0
  supported_classes
    net
pci/0000:03.00:4
  supported_classes
    net
auxiliary/mlx5_core.sf.8
  supported_classes
    net

Patch summary:
Patch-1 adds kernel headers for vdpa subsystem
Patch-2 adds library routines for indent handling
Patch-3 adds library routines for generic socket communication
PAtch-4 adds library routine for number to string mapping
Patch-5 adds vdpa tool

Kernel headers are from the linux-next [1].

[1] https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git

---
changelog:
v4->v5:
 - avoided UAPI prefix in the vdpa.h header file
 - updated commit id to commit of linux-next tree
v3->v4:
 - relocated vdpa headers to vdpa/include/uapi/linux
 - added new headers path to CFLAGS of vdpa tool
v2->v3:
 - addressed David's comment to split patch for utils and other parts
 - rebased
 - using newly added helper routine for number to string mapping
v1->v2:
 - addressed below comments from David
 - added and used library helpers for socket communication
 - added and used library functions for string processing helpers
 - added and used library functions indent processing helpers


Parav Pandit (5):
  Add kernel headers
  utils: Add helper routines for indent handling
  utils: Add generic socket helpers
  utils: Add helper to map string to unsigned int
  vdpa: Add vdpa tool

 Makefile                             |   2 +-
 include/mnl_utils.h                  |  16 +
 include/utils.h                      |  20 +-
 lib/mnl_utils.c                      | 121 +++++
 lib/utils.c                          |  83 +++-
 man/man8/vdpa-dev.8                  |  96 ++++
 man/man8/vdpa-mgmtdev.8              |  53 +++
 man/man8/vdpa.8                      |  76 +++
 vdpa/Makefile                        |  25 +
 vdpa/include/uapi/linux/vdpa.h       |  40 ++
 vdpa/include/uapi/linux/virtio_ids.h |  58 +++
 vdpa/vdpa.c                          | 675 +++++++++++++++++++++++++++
 12 files changed, 1261 insertions(+), 4 deletions(-)
 create mode 100644 man/man8/vdpa-dev.8
 create mode 100644 man/man8/vdpa-mgmtdev.8
 create mode 100644 man/man8/vdpa.8
 create mode 100644 vdpa/Makefile
 create mode 100644 vdpa/include/uapi/linux/vdpa.h
 create mode 100644 vdpa/include/uapi/linux/virtio_ids.h
 create mode 100644 vdpa/vdpa.c

--=20
2.26.2


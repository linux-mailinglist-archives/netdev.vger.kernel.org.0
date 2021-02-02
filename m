Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F32230BC23
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 11:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbhBBKgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 05:36:21 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:7185 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbhBBKgP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 05:36:15 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60192af70000>; Tue, 02 Feb 2021 02:35:35 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 2 Feb
 2021 10:35:33 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>, <mst@redhat.com>,
        <jasowang@redhat.com>
CC:     Parav Pandit <parav@nvidia.com>
Subject: [PATCH iproute2-next v3 0/5] Add vdpa device management tool
Date:   Tue, 2 Feb 2021 12:35:13 +0200
Message-ID: <20210202103518.3858-1-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210122112654.9593-3-parav@nvidia.com>
References: <20210122112654.9593-3-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612262135; bh=1HIC4SA7rNq3aFrDXNqk5dum/56SF6d83BkKlVr7vX4=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=nwk90/KAe82eO98Z8rooOavbR64FhzELvYALJ5/BoSy9SS7LJXtg4kVexEcI51F0z
         cRSPjwXlswU/Ovp0Sh/Gqs4OaWBhZLUpyngbcW0vDqFPpexhzVKcZfgmVBED6yNjvK
         Wsq/JcNueWOdM04UncI/V22lnTLsC7QkGBt4KrWmmsm0aYIBTD2yc7jumAUlvyI8Jx
         FVhPAD0KG/K0t/Gcvd1kGxwBQo8aoRtYnvX5JA0KrV93U/WAu5NVUK5IQk26mMWdd4
         i0XIEL63kssD/reLSeTSK6G2PlKNj83gqwkYiR3+KQOv7XexaNiejp+mjDkzdCJlRP
         W+NCARt5b3lNw==
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

Patch summary:
Patch-1 adds kernel headers for vdpa subsystem
Patch-2 adds library routines for indent handling
Patch-3 adds library routines for generic socket communication
PAtch-4 adds library routine for number to string mapping
Patch-5 adds vdpa tool

Kernel headers are from the vhost kernel tree [1] from branch linux-next.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git

---
changelog:
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

 Makefile                        |   2 +-
 include/mnl_utils.h             |  16 +
 include/uapi/linux/vdpa.h       |  40 ++
 include/uapi/linux/virtio_ids.h |  58 +++
 include/utils.h                 |  20 +-
 lib/mnl_utils.c                 | 121 ++++++
 lib/utils.c                     |  83 +++-
 man/man8/vdpa-dev.8             |  96 +++++
 man/man8/vdpa-mgmtdev.8         |  53 +++
 man/man8/vdpa.8                 |  76 ++++
 vdpa/Makefile                   |  24 ++
 vdpa/vdpa.c                     | 675 ++++++++++++++++++++++++++++++++
 12 files changed, 1260 insertions(+), 4 deletions(-)
 create mode 100644 include/uapi/linux/vdpa.h
 create mode 100644 include/uapi/linux/virtio_ids.h
 create mode 100644 man/man8/vdpa-dev.8
 create mode 100644 man/man8/vdpa-mgmtdev.8
 create mode 100644 man/man8/vdpa.8
 create mode 100644 vdpa/Makefile
 create mode 100644 vdpa/vdpa.c

--=20
2.26.2


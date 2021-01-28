Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D33F307E61
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 19:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232314AbhA1Sqd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 13:46:33 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:5933 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231302AbhA1So2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 13:44:28 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601305d70002>; Thu, 28 Jan 2021 10:43:35 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 28 Jan
 2021 18:43:34 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>, <mst@redhat.com>,
        <jasowang@redhat.com>
CC:     Parav Pandit <parav@nvidia.com>
Subject: [PATCH iproute2-next v2 0/2] Add vdpa device management tool
Date:   Thu, 28 Jan 2021 20:43:17 +0200
Message-ID: <20210128184319.29174-1-parav@nvidia.com>
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
        t=1611859415; bh=gD3TwqAZnpPuRRCh6snMjoooY6MKiOD3vD0bZD9u6V8=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=Dm/MoECUncWaHq558vBy73aqW4HFJV4/HlXduYODbPk96pRpGpAMxw3rYossLu7S/
         zEo/C2oUZt9dyU+OXiGqx7AVTz6FSvt8f1hOHwfiwzBstTdBnFPRoZsiO/FvibUt14
         x5HB+38gLkHL1GfWq0PIWkFzJdUytAPCDqsX0OEgOgssvH08Aef0F+DVsfsMnM2bC1
         vGeybRgFb8S95ukWjMis4lxY2sIs/sczmdy8O4h3frXA6ANmWlHOMSBI2ZexIzW63z
         lmBenW42km5vepRd1EmIIdNTTAF8R1LjRZ7tHIpqsKKw6d3ePD8qULEEkOj1L8v7ez
         hnizrSxOzAQoA==
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
Patch-2 adds vdpa tool along with helper library routines and man pages=20

Kernel headers are from the vhost kernel tree [1] from branch linux-next.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git

---
changelog:
v1->v2:
 - addressed below comments from David
 - added and used library helpers for socket communication
 - added and used library functions for string processing helpers
 - added and used library functions indent processing helpers

Parav Pandit (2):
  Add kernel headers
  vdpa: Add vdpa tool

 Makefile                        |   2 +-
 include/mnl_utils.h             |  16 +
 include/uapi/linux/vdpa.h       |  40 ++
 include/uapi/linux/virtio_ids.h |  58 +++
 include/utils.h                 |  16 +
 lib/mnl_utils.c                 | 121 ++++++
 lib/utils.c                     |  66 ++++
 man/man8/vdpa-dev.8             |  96 +++++
 man/man8/vdpa-mgmtdev.8         |  53 +++
 man/man8/vdpa.8                 |  76 ++++
 vdpa/Makefile                   |  24 ++
 vdpa/vdpa.c                     | 669 ++++++++++++++++++++++++++++++++
 12 files changed, 1236 insertions(+), 1 deletion(-)
 create mode 100644 include/uapi/linux/vdpa.h
 create mode 100644 include/uapi/linux/virtio_ids.h
 create mode 100644 man/man8/vdpa-dev.8
 create mode 100644 man/man8/vdpa-mgmtdev.8
 create mode 100644 man/man8/vdpa.8
 create mode 100644 vdpa/Makefile
 create mode 100644 vdpa/vdpa.c

--=20
2.26.2


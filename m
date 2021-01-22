Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D000E300195
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 12:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728404AbhAVL3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 06:29:54 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:6417 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728202AbhAVL15 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 06:27:57 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600ab6920001>; Fri, 22 Jan 2021 03:27:14 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 22 Jan
 2021 11:27:13 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>, <mst@redhat.com>,
        <jasowang@redhat.com>
CC:     Parav Pandit <parav@nvidia.com>
Subject: [PATCH iproute2-next 0/2] Add vdpa device management tool
Date:   Fri, 22 Jan 2021 13:26:52 +0200
Message-ID: <20210122112654.9593-1-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611314835; bh=2ZB/XEEklof71qF9Kn209ervpR48S1+tZlHCq86dS/Y=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Transfer-Encoding:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=mTzBk+eFhnZKeUczG6WyoLHNrGcMEZCLz0CtR12iHvTdBKIxELmqzYuXnnk7dGnvd
         0CdI1lcKcQ8EBIwFEBBPwtnVe+C9SHaiCQICX9lo4toohbtlT3iXy/QKDG/M/X0+Db
         lk9BZEk5RdMV14xeEaHpMzu1O6WAdoM+9syvX2mjgbPyR60+0LrSkctBpWEr6Bbkrl
         8dHzYhreJjL1MrhtXvuBVMkDnEIb+0oO2z3L/IY95GMVORnNUTsc3maEruRgSvLMx9
         ysPm3P76GA9BXSNFHix0PeH4ags6a4ZIEeejOVUzOnVMZ5AC8wghaf0OQZDKYwVDmU
         n53d1QH0IUy3w==
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
Patch-2 adds vdpa tool and its man pages

Kernel headers are from the vhost kernel tree [1] from branch linux-next.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git

Parav Pandit (2):
  Add kernel headers
  vdpa: Add vdpa tool

 Makefile                        |   2 +-
 include/uapi/linux/vdpa.h       |  40 ++
 include/uapi/linux/virtio_ids.h |  58 +++
 man/man8/vdpa-dev.8             |  96 ++++
 man/man8/vdpa-mgmtdev.8         |  53 ++
 man/man8/vdpa.8                 |  76 +++
 vdpa/Makefile                   |  24 +
 vdpa/vdpa.c                     | 828 ++++++++++++++++++++++++++++++++
 8 files changed, 1176 insertions(+), 1 deletion(-)
 create mode 100644 include/uapi/linux/vdpa.h
 create mode 100644 include/uapi/linux/virtio_ids.h
 create mode 100644 man/man8/vdpa-dev.8
 create mode 100644 man/man8/vdpa-mgmtdev.8
 create mode 100644 man/man8/vdpa.8
 create mode 100644 vdpa/Makefile
 create mode 100644 vdpa/vdpa.c

--=20
2.26.2


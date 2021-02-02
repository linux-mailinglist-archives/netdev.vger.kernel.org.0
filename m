Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C712330B93F
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 09:09:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231601AbhBBIHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 03:07:35 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:4313 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbhBBIH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 03:07:27 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6019080f0001>; Tue, 02 Feb 2021 00:06:39 -0800
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 2 Feb
 2021 08:06:39 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1473.3 via Frontend
 Transport; Tue, 2 Feb 2021 08:06:36 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <jgg@nvidia.com>, <dledford@redhat.com>,
        <linux-rdma@vger.kernel.org>, <parav@nvidia.com>,
        <saeedm@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>
Subject: [PATCH net-next RESEND 0/2] devlink: Add port function attribute to enable/disable roce
Date:   Tue, 2 Feb 2021 10:06:12 +0200
Message-ID: <20210202080614.37903-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612253199; bh=tCNUPMDoAXFXudQ9jxfgIOYAAJxxZgJ9CUyv9SDLEF4=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Transfer-Encoding:Content-Type;
        b=bz2cFS6wesPRlEuuMjrrzbJnUTuVw7IPfLrm922bSD5xaq7TQHu0GGv1yObfGSm0k
         QIflsZQYdKUNsaqB4lPdfihtfIRQpOPN+3U0Uab1bKOzsdLzR81vR0AM3klqP5kCTC
         1vVh927FVVc6Vt2rIXxgohnTw0fZ0eapByAvs5/1z2HUvaavFPZqL9/WHqKyQLDXWU
         cxDY8h4UWDbgmI3Wa7Lu1RzUTolX1vHrnYrHSVPbnx1StFWPFwGBor4a0uuRNbU0Zr
         3rhWWYBS9xHA2dmq3ABwy0Qk9cQF/SzJ5UVjCNjnQfF7sosE647FTV6Ew0AoK5ksSY
         5HyzYLBcDDDmw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Resending to include rdma mailing list.

Currently mlx5 PCI VF and SF are enabled by default for RoCE
functionality.

Currently a user does not have the ability to disable RoCE for a PCI
VF/SF device before such device is enumerated by the driver.

User is also incapable to do such setting from smartnic scenario for a
VF from the smartnic.

Current 'enable_roce' device knob is limited to do setting only at
driverinit time. By this time device is already created and firmware has
already allocated necessary system memory for supporting RoCE.

When a RoCE is disabled for the PCI VF/SF device, it saves 1 Mbyte of
system memory per function. Such saving is helpful when running on low
memory embedded platform with many VFs or SFs.

Therefore, it is desired to empower user to disable RoCE functionality
before a PCI SF/VF device is enumerated.

This is achieved by extending existing 'port function' object to control
capabilities of a function. This enables users to control capability of
the device before enumeration.

Examples when user prefers to disable RoCE for a VF when using switchdev
mode:

$ devlink port show pci/0000:06:00.0/1
pci/0000:06:00.0/1: type eth netdev pf0vf0 flavour pcivf controller 0
pfnum 0 vfnum 0 external false splittable false
  function:
    hw_addr 00:00:00:00:00:00 roce on

$ devlink port function set pci/0000:06:00.0/1 roce off
 =20
$ devlink port show pci/0000:06:00.0/1
pci/0000:06:00.0/1: type eth netdev pf0vf0 flavour pcivf controller 0
pfnum 0 vfnum 0 external false splittable false
  function:
    hw_addr 00:00:00:00:00:00 roce off

FAQs:
-----
1. What does roce on/off do?
Ans: It disables RoCE capability of the function before its enumerated,
so when driver reads the capability from the device firmware, it is
disabled.
At this point RDMA stack will not be able to create UD, QP1, RC, XRC
type of QPs. When RoCE is disabled, the GID table of all ports of the
device is disabled in the device and software stack.

2. How is the roce 'port function' option different from existing
devlink param?
Ans: RoCE attribute at the port function level disables the RoCE
capability at the specific function level; while enable_roce only does
at the software level.

3. Why is this option for disabling only RoCE and not the whole RDMA
device?
Ans: Because user still wants to use the RDMA device for non RoCE
commands in more memory efficient way.

Patch summary:
Patch-1 adds devlink attribute to control roce
Patch-2 implements mlx5 callbacks for roce control

Yishai Hadas (2):
  devlink: Expose port function commands to control roce
  net/mlx5: E-Switch, Implement devlink port function cmds to control
    roce

 .../device_drivers/ethernet/mellanox/mlx5.rst |  32 ++++
 .../networking/devlink/devlink-port.rst       |   5 +-
 .../net/ethernet/mellanox/mlx5/core/devlink.c |   3 +
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 138 ++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  10 +-
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   2 +
 .../net/ethernet/mellanox/mlx5/core/vport.c   |  35 +++++
 include/net/devlink.h                         |  22 +++
 include/uapi/linux/devlink.h                  |   1 +
 net/core/devlink.c                            |  63 ++++++++
 10 files changed, 307 insertions(+), 4 deletions(-)

--=20
2.18.1


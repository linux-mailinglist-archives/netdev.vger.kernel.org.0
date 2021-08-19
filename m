Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC803F19A7
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 14:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237861AbhHSMrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 08:47:12 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:14278 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbhHSMrL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 08:47:11 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Gr4Jc4PlKz87wF;
        Thu, 19 Aug 2021 20:46:24 +0800 (CST)
Received: from dggema772-chm.china.huawei.com (10.1.198.214) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 19 Aug 2021 20:46:33 +0800
Received: from [127.0.0.1] (10.69.38.196) by dggema772-chm.china.huawei.com
 (10.1.198.214) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 19
 Aug 2021 20:46:32 +0800
From:   Yicong Yang <yangyicong@hisilicon.com>
Subject: [Issue] mlx5_core probe failed with error -17 when rescanning devices
To:     <dlinkin@nvidia.com>, <leonro@nvidia.com>, <roid@nvidia.com>,
        <saeedm@nvidia.com>
CC:     <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Yicong Yang <yangyicong@hisilicon.com>,
        Linuxarm <linuxarm@huawei.com>
Message-ID: <87040cfb-6f16-8a66-5ef7-ca5acc2beb05@hisilicon.com>
Date:   Thu, 19 Aug 2021 20:46:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.38.196]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggema772-chm.china.huawei.com (10.1.198.214)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I met an issue of mlx5_core on v5.14-rc6. After performing hot reset of root port
where mellanox connectX-4 locates, I remove the root port and rescan the pci bus,
but the driver cannot probe the device. The hirarchy of the devices:

# lspci -tv
[...]
 +-[0000:80]-+-00.0-[81]--+-00.0  Intel Corporation I350 Gigabit Network Connection
 |           |            +-00.1  Intel Corporation I350 Gigabit Network Connection
 |           |            +-00.2  Intel Corporation I350 Gigabit Network Connection
 |           |            \-00.3  Intel Corporation I350 Gigabit Network Connection
 |           +-04.0-[82]--+-00.0  Mellanox Technologies MT27710 Family [ConnectX-4 Lx]
 |           |            \-00.1  Mellanox Technologies MT27710 Family [ConnectX-4 Lx]
[...]
# lspci -vx -s 82:00.0
82:00.0 Ethernet controller: Mellanox Technologies MT27710 Family [ConnectX-4 Lx]
	Subsystem: Mellanox Technologies MT27710 Family [ConnectX-4 Lx]
	Flags: fast devsel, IRQ 42, NUMA node 2, IOMMU group 13
	Memory at 280000000000 (64-bit, prefetchable) [size=32M]
	Expansion ROM at f0700000 [disabled] [size=1M]
	Capabilities: [60] Express Endpoint, MSI 00
	Capabilities: [48] Vital Product Data
	Capabilities: [9c] MSI-X: Enable- Count=64 Masked-
	Capabilities: [c0] Vendor Specific Information: Len=18 <?>
	Capabilities: [40] Power Management version 3
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [150] Alternative Routing-ID Interpretation (ARI)
	Capabilities: [180] Single Root I/O Virtualization (SR-IOV)
	Capabilities: [1c0] Secondary PCI Express
	Capabilities: [230] Access Control Services
00: b3 15 15 10 42 01 10 00 00 00 00 02 08 00 80 00
10: 0c 00 00 00 00 28 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 b3 15 9c 00
30: 00 00 10 f0 60 00 00 00 00 00 00 00 ff 01 00 00

Here is the error log:

[...]
[13904.335445] mlx5_core 0000:82:00.1: Adding to iommu group 29
[13904.341460] mlx5_core 0000:82:00.1: firmware version: 14.22.1002
[13904.347479] mlx5_core 0000:82:00.1: 63.008 Gb/s available PCIe bandwidth (8.0 GT/s PCIe x8 link)
[13904.880505] mlx5_core 0000:82:00.1: E-Switch: Total vports 6, per vport: max uc(1024) max mc(16384)
[13904.893763] mlx5_core 0000:82:00.1: Port module event: module 1, Cable plugged
[13904.917246] sysfs: cannot create duplicate filename '/bus/auxiliary/devices/mlx5_core.eth.2'
[13904.925656] CPU: 64 PID: 957 Comm: kworker/64:2 Tainted: G        W         5.13.0-rc3-bisect+ #37
[13904.934573] Hardware name: Huawei TaiShan 200 (Model 2280)/BC82AMDD, BIOS 2280-V2 CS V5.B170.01 06/30/2021
[13904.944181] Workqueue: events work_for_cpu_fn
[13904.948522] Call trace:
[13904.950949]  dump_backtrace+0x0/0x19c
[13904.954598]  show_stack+0x24/0x30
[13904.957899]  dump_stack+0xc8/0x104
[13904.961287]  sysfs_warn_dup+0x70/0x90
[13904.964936]  sysfs_do_create_link_sd+0xf8/0x100
[13904.969448]  sysfs_create_link+0x2c/0x50
[13904.973355]  bus_add_device+0x74/0x120
[13904.977088]  device_add+0x2f4/0x840
[13904.980562]  __auxiliary_device_add+0x4c/0xb0
[13904.984901]  add_adev+0x9c/0xf0
[13904.988030]  mlx5_rescan_drivers_locked.part.0+0x154/0x1c0
[13904.993491]  mlx5_register_device+0x80/0xe0
[13904.997656]  mlx5_init_one+0x224/0x4dc
[13905.001389]  probe_one+0x1dc/0x4cc
[13905.004776]  local_pci_probe+0x4c/0xc0
[13905.008500]  work_for_cpu_fn+0x28/0x40
[13905.012232]  process_one_work+0x1dc/0x48c
[13905.016223]  worker_thread+0x2e8/0x464
[13905.019955]  kthread+0x168/0x16c
[13905.023171]  ret_from_fork+0x10/0x18
[13905.026764] auxiliary mlx5_core.eth.2: adding auxiliary device failed!: -17
[13905.033698] mlx5_core 0000:82:00.1: add_drivers:424:(pid 957): Device[0] (eth) failed to load
[13907.274212] mlx5_core 0000:82:00.1: E-Switch: cleanup
[13907.896435] mlx5_core 0000:82:00.1: probe_one:1484:(pid 957): mlx5_init_one failed with error code -17
[13907.905855] mlx5_core: probe of 0000:82:00.1 failed with error -17

The test script I used:

#!/bin/bash
setpci -s 80:04.0 0x3e.b=0x43 # perform hot reset by setting secondary bus reset bit
setpci -s 80:04.0 0x3e.b=0x3 # clear secondary bus reset bit
echo 1 > /sys/bus/pci/devices/0000:80:04.0/remove
echo 1 > /sys/bus/pci/rescan

There is no such issue on v5.13-rc4. So I did a git bisect and here is log:

[...]
# good: [c7d2ef5dd4b03ed0ee1d13bc0c55f9cf62d49bd6] net/packet: annotate accesses to po->bind
git bisect good c7d2ef5dd4b03ed0ee1d13bc0c55f9cf62d49bd6
# bad: [bc39f6792ede3a830b1893c9133636b9f6991e59] Merge tag 'mlx5-fixes-2021-06-16' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
git bisect bad bc39f6792ede3a830b1893c9133636b9f6991e59
# good: [94a4b8414d3e91104873007b659252f855ee344a] net/mlx5: Fix error path for set HCA defaults
git bisect good 94a4b8414d3e91104873007b659252f855ee344a
# good: [65fb7d109abe3a1a9f1c2d3ba7e1249bc978d5f0] net/mlx5: DR, Fix STEv1 incorrect L3 decapsulation padding
git bisect good 65fb7d109abe3a1a9f1c2d3ba7e1249bc978d5f0
# bad: [0232fc2ddcf4ffe01069fd1aa07922652120f44a] net/mlx5: Reset mkey index on creation
git bisect bad 0232fc2ddcf4ffe01069fd1aa07922652120f44a
# bad: [a5ae8fc9058e37437c8c1f82b3d412b4abd1b9e6] net/mlx5e: Don't create devices during unload flow
git bisect bad a5ae8fc9058e37437c8c1f82b3d412b4abd1b9e6
# first bad commit: [a5ae8fc9058e37437c8c1f82b3d412b4abd1b9e6] net/mlx5e: Don't create devices during unload flow

So after reverting a5ae8fc9058e ("net/mlx5e: Don't create devices during unload flow") the issue
is resolved. Seems the devlink file is not removed properly and the unremoved file fails the
probe process. I don't know about the driver so I hope somebody can get this fixed.

Thanks,
Yicong



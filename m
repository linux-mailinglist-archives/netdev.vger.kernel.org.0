Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7EC3CEDC8
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 22:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387052AbhGSTpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 15:45:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:54360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1386707AbhGSThU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 15:37:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1506460FDC;
        Mon, 19 Jul 2021 20:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626725879;
        bh=GLIPz6MDw/otVUbpLQGRowCU0+qqN2R+rIcrRfFxxAY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SQ5xsIRE9CgnWD1pLTDGvBzkktUWFCbFTIBA0u3KmZEyJeBtlo/mBuBt5R201Qq39
         RXx58UBta2pEH7tPqzIYoZH6To3efXLjQAUS2Zbq/Yit+9RpUzGhnOUlKIHg+yq5Kl
         kfJoVF/jRcEXCmB8PQlIMdAJr+MJ7UwbDRKOkNB9AW6kNWUq9R3GKqwy5A6fdBDjSn
         IJw/1ZDDemHVYNjGQ8CJbOG5/1LbdqMobQcLRZj43gD1fRATJaJGeeXOsObQzX6H/u
         0x+DGgzutLAP1aMdZ3iEMmgB02eRcbb62Ecy6wF5yQRmC481KlmyolvDhv+Q68xkhy
         5wxQKxNe3GBMA==
Message-ID: <c61af64fd275b3a329bbad699de9db661e3cf082.camel@kernel.org>
Subject: Re: [5.14-rc1] mlx5_core receives no interrupts with maxcpus=8
From:   Saeed Mahameed <saeed@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>, Dexuan Cui <decui@microsoft.com>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>,
        "'x86@kernel.org'" <x86@kernel.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Date:   Mon, 19 Jul 2021 13:17:58 -0700
In-Reply-To: <YPPwel8mhaIdHP1y@unreal>
References: <BYAPR21MB12703228F3E7A8B8158EB054BF129@BYAPR21MB1270.namprd21.prod.outlook.com>
         <BYAPR21MB127099BADA8490B48910D3F1BF129@BYAPR21MB1270.namprd21.prod.outlook.com>
         <YPPwel8mhaIdHP1y@unreal>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.3 (3.40.3-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2021-07-18 at 12:12 +0300, Leon Romanovsky wrote:
> On Thu, Jul 15, 2021 at 01:11:55AM +0000, Dexuan Cui wrote:
> > > From: Dexuan Cui
> > > Sent: Wednesday, July 14, 2021 5:39 PM
> > > To: netdev@vger.kernel.org; x86@kernel.org
> > > Cc: Haiyang Zhang <haiyangz@microsoft.com>;
> > > linux-kernel@vger.kernel.org
> > > Subject: [5.14-rc1] mlx5_core receives no interrupts with maxcpus=8
> > > 
> > > Hi all,
> > > I'm seeing a strange "no MSI-X interrupt" issue with the Mellanox
> > > NIC
> > > driver on a physical Linux host [1], if I only enable part of the
> > > CPUs.
> > > 
> > > The physical host has 104 logical processors (2 sockets, and each
> > > socket
> > > has 26 cores with HT enabled). By default, the Mellanox driver
> > > works fine
> > > when Linux boots up.
> > > 
> > > If I only use 1, 2, 32, 64, 96 processors by the Linux kernel
> > > parameter
> > > "maxcpus=X" or "nr_cpus=X", everthing still works fine.
> > > 
> > > However, if the Linux host OS only uses 4, 8 or 16 processors, the
> > > mlx5_core driver fails to load as it can not receive interrupt when
> > > creating EQ (maxcpus=8 or 16), or the driver can load but it
> > > reports a
> > > timeout error when I try to bring the NIC up (maxcpus=4). This
> > > issue is
> > > a 100% repro.
> > > 
> > > For example, with "maxcpus=8", I get the below timeout error when
> > > trying
> > > to load mlx5_core:
> > > 
> > > # modprobe mlx5_core
> > > [ 1475.716688] mlx5_core 0000:d8:00.0: firmware version: 16.25.8352
> > > [ 1475.722742] mlx5_core 0000:d8:00.0: 126.016 Gb/s available PCIe
> > > bandwidth (8.0 GT/s PCIe x16 link)
> > > [ 1475.991398] mlx5_core 0000:d8:00.0: E-Switch: Total vports 2,
> > > per vport:
> > > max uc(1024) max mc(16384)
> > > 
> > > [ 1537.020001] mlx5_core 0000:d8:00.0: mlx5_cmd_eq_recover:245:(pid
> > > 1416):
> > > Recovered 1 EQEs on cmd_eq
> > > [ 1537.028969] mlx5_core 0000:d8:00.0:
> > > wait_func_handle_exec_timeout:1062:(pid 1416): cmd[0]:
> > > CREATE_EQ(0x301)
> > > recovered after timeout
> > > [ 1598.460003] mlx5_core 0000:d8:00.0: mlx5_cmd_eq_recover:245:(pid
> > > 1416):
> > > Recovered 1 EQEs on cmd_eq
> > > [ 1598.468978] mlx5_core 0000:d8:00.0:
> > > wait_func_handle_exec_timeout:1062:(pid 1416): cmd[0]:
> > > CREATE_EQ(0x301)
> > > recovered after timeout
> > > [ 1659.900010] mlx5_core 0000:d8:00.0: mlx5_cmd_eq_recover:245:(pid
> > > 1416):
> > > Recovered 1 EQEs on cmd_eq
> > > [ 1659.908987] mlx5_core 0000:d8:00.0:
> > > wait_func_handle_exec_timeout:1062:(pid 1416): cmd[0]:
> > > CREATE_EQ(0x301)
> > > recovered after timeout
> > > [ 1721.340006] mlx5_core 0000:d8:00.0: mlx5_cmd_eq_recover:245:(pid
> > > 1416):
> > > Recovered 1 EQEs on cmd_eq
> > > [ 1721.348989] mlx5_core 0000:d8:00.0:
> > > wait_func_handle_exec_timeout:1062:(pid 1416): cmd[0]:
> > > CREATE_EQ(0x301)
> > > recovered after timeout
> > > 
> > > When this happens, the mlx5_core driver is stuck with the below
> > > call-trace, waiting for some interrupt:
> > > 
> > > # ps aux |grep modprobe
> > > root        1416  0.0  0.0  11024  1472 ttyS0    D+   08:08   0:00
> > > modprobe mlx5_core
> > > root        1480  0.0  0.0   6440   736 pts/0    S+   08:15   0:00
> > > grep --color=auto modprobe
> > > 
> > > # cat /proc/1416/stack
> > > [<0>] cmd_exec+0x8a7/0x9b0 [mlx5_core]
> > > [<0>] mlx5_cmd_exec+0x24/0x50 [mlx5_core]
> > > [<0>] create_map_eq+0x2a6/0x380 [mlx5_core]
> > > [<0>] mlx5_eq_table_create+0x504/0x710 [mlx5_core]
> > > [<0>] mlx5_load+0x52/0x130 [mlx5_core]
> > > [<0>] mlx5_init_one+0x1cc/0x250 [mlx5_core]
> > > [<0>] probe_one+0x1d3/0x2a0 [mlx5_core]
> > > [<0>] local_pci_probe+0x45/0x80
> > > [<0>] pci_device_probe+0x10f/0x1c0
> > > [<0>] really_probe+0x1c1/0x3b0
> > > [<0>] __driver_probe_device+0x109/0x180
> > > [<0>] driver_probe_device+0x23/0xa0
> > > [<0>] __driver_attach+0xbd/0x160
> > > [<0>] bus_for_each_dev+0x7c/0xc0
> > > [<0>] driver_attach+0x1e/0x20
> > > [<0>] bus_add_driver+0x152/0x1f0
> > > [<0>] driver_register+0x74/0xd0
> > > [<0>] __pci_register_driver+0x68/0x70
> > > [<0>] init+0x6b/0x1000 [mlx5_core]
> > > [<0>] do_one_initcall+0x46/0x1d0
> > > [<0>] do_init_module+0x62/0x250
> > > [<0>] load_module+0x2503/0x2730
> > > [<0>] __do_sys_finit_module+0xbf/0x120
> > > [<0>] __x64_sys_finit_module+0x1a/0x20
> > > [<0>] do_syscall_64+0x38/0xc0
> > > [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xae
> > > 
> > > To make the issue even weirder, when the issue happens (e.g. when
> > > Linux
> > > only uses 8 processors), if I manually bring CPU #8~#31 online [2]
> > > and
> > > then bring them offline [3], the Mellanox driver will work fine!
> > > 
> > > This is a x86-64 host. Is it possibe that the IOMMU Interrrupt
> > > Remapping
> > > is not proprely set up with maxcpus=4, 8 and 16?
> > > 
> > > The above tests were done with the recent Linux v5.14-rc1 kernel. I
> > > also
> > > tried Ubuntu 20.04's kernel "5.4.0-77-generic", and the Mellanox
> > > driver
> > > exhibits exactly the same issue.
> > > 
> > > I have Linux/Windows dual-boot on this physical machine, and
> > > Windows
> > > doesn't have the issue when I let it only use 4, 8 and 16
> > > processors.
> > > So this looks like somehow the issue is specific to Linux.
> > > 
> > > Can someone please shed some light on this strange issue? I'm ready
> > > to provide more logs if needed. Thanks!
> > > 
> > > PS, the physical machine has 4 NVMe controllers and 4 Broadcom
> > > NICs,
> > > which are not affected by maxcpus=4, 8, and 16.
> > > 
> > > [1] This is the 'lspci' output of the Mellanox NIC:
> > > d8:00.0 Ethernet controller: Mellanox Technologies MT27800 Family
> > > [ConnectX-5]
> > >         Subsystem: Mellanox Technologies MT27800 Family [ConnectX-
> > > 5]
> > >         Flags: bus master, fast devsel, latency 0, IRQ 33, NUMA
> > > node 1
> > >         Memory at f8000000 (64-bit, prefetchable) [size=32M]
> > >         Expansion ROM at fbe00000 [disabled] [size=1M]
> > >         Capabilities: [60] Express Endpoint, MSI 00
> > >         Capabilities: [48] Vital Product Data
> > >         Capabilities: [9c] MSI-X: Enable+ Count=64 Masked-
> > >         Capabilities: [c0] Vendor Specific Information: Len=18 <?>
> > >         Capabilities: [40] Power Management version 3
> > >         Capabilities: [100] Advanced Error Reporting
> > >         Capabilities: [150] Alternative Routing-ID Interpretation
> > > (ARI)
> > >         Capabilities: [180] Single Root I/O Virtualization (SR-IOV)
> > >         Capabilities: [1c0] Secondary PCI Express
> > >         Kernel driver in use: mlx5_core
> > >         Kernel modules: mlx5_core
> > > 00: b3 15 17 10 46 05 10 00 00 00 00 02 08 00 00 00
> > > 10: 0c 00 00 f8 00 00 00 00 00 00 00 00 00 00 00 00
> > > 20: 00 00 00 00 00 00 00 00 00 00 00 00 b3 15 80 00
> > > 30: 00 00 e0 fb 60 00 00 00 00 00 00 00 ff 01 00 00
> > > 
> > > [2] for i in `seq 8 31`;  do echo 1 > 
> > > /sys/devices/system/cpu/cpu$i/online;
> > > done
> > > [3] for i in `seq 8 31`;  do echo 0 > 
> > > /sys/devices/system/cpu/cpu$i/online;
> > > done
> > > 
> > > Thanks,
> > > -- Dexuan
> > 
> > (+ the linux-pci list)
> > 
> > It turns out that adding "intremap=off" can work around the issue!
> > 
> > The root cause is still not clear yet. I don't know why Windows is
> > good here.
> 
> The card is stuck in the FW, maybe Saeed knows why. I tried your
> scenario and it worked for me.
> 
> Thanks

I don't think the FW is stuck since we see the cmd completion after
timeout, this means that the 1st interrupt from the device got lost.

"wait_func_handle_exec_timeout:1062:(pid 1416): cmd[0]:
CREATE_EQ(0x301) recovered after timeout"

the fact that this happens on  5.14 and 5.4 kernels and the issue is
worked around via bringing the cpus online, or disabling intremap,
means that there is something wrong with the interrupt remapping
mechanism, maybe the interrupt is being delivered on an offline cpu ? 
is this a qemu/VM guest or a bare metal host ?






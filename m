Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3175EFD644
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 07:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727978AbfKOGXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 01:23:10 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:6233 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727953AbfKOGXH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Nov 2019 01:23:07 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 95A67377791EE37F876E;
        Fri, 15 Nov 2019 14:23:03 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.12) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Fri, 15 Nov 2019
 14:22:57 +0800
From:   "wangxiaogang (F)" <wangxiaogang3@huawei.com>
To:     <dsahern@kernel.org>, <shrijeet@gmail.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hujunwei4@huawei.com>, <xuhanbing@huawei.com>
Subject: [PATCH] vrf: Fix possible NULL pointer oops when delete nic
Message-ID: <60e827cb-2bba-2b7e-55dc-651103e9905f@huawei.com>
Date:   Fri, 15 Nov 2019 14:22:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.222.12]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: XiaoGang Wang <wangxiaogang3@huawei.com>

Recently we get a crash when access illegal address (0xc0),
which will occasionally appear when deleting a physical NIC with vrf.

[166603.826737]hinic 0000:43:00.4 eth-s3: Failed to cycle device eth-s3;
route tables might be wrong!
.....
[166603.828018]WARNING: CPU: 135 PID: 15382at net/core/dev.c:6875
__netdev_adjacent_dev_remove.constprop.40+0x1e0/0x1e8
......
[166603.828169]pc : __netdev_adjacent_dev_remove.constprop.40+0x1e0/0x1e8
[166603.828171]lr : __netdev_adjacent_dev_remove.constprop.40+0x1e0/0x1e8
[166603.828172]sp : ffff000031efb810
[166603.828173]x29: ffff000031efb810 x28: 0000000000002710
[166603.828175]x27: 0000000000000001 x26: ffffa021f4095d88
[166603.828177]x25: ffff000008d30de8 x24: ffff0000092d75d6
[166603.828179]x23: 0000000000000006 x22: ffffa021e1edc480
[166603.828181]x21: 0000000000000000 x20: ffffa021e1edc530
[166603.828183]x19: ffffa021e1edc518 x18: ffffffffffffffff
[166603.828185]x17: 0000000000000000 x16: 0000000000000000
[166603.828186]x15: ffff0000091d9708 x14: 776620746567206f
[166603.828188]x13: 742064656c696146 x12: ffff800040801004
[166603.828190]x11: ffff80004080100c x10: ffff0000091dbae0
[166603.828192]x9 : 0000000000000001 x8 : 0000000006a60f9c
[166603.828194]x7 : ffff0000093b6fc0 x6 : 0000000000000001
[166603.828196]x5 : 0000000000000001 x4 : ffffa020560383c0
[166603.828198]x3 : ffffa020560383c0 x2 : 371cb5224b539100
[166603.828200]x1 : 0000000000000000 x0 : 0000000000000036
[166603.828202]Call trace:
[166603.828204] __netdev_adjacent_dev_remove.constprop.40+0x1e0/0x1e8
[166603.828205] __netdev_adjacent_dev_unlink_neighbour+0x2c/0x48
[166603.828207] netdev_upper_dev_unlink+0x7c/0xe8
[166603.828215] vrf_device_event+0x58/0x80 [vrf]
[166603.828221] notifier_call_chain+0x5c/0xa0
[166603.828222] raw_notifier_call_chain+0x3c/0x50
[166603.828224] call_netdevice_notifiers_info+0x3c/0x80
[166603.828229] rollback_registered_many+0x35c/0x568
[166603.828233] rollback_registered+0x68/0xb0
[166603.828234] unregister_netdevice_queue+0xc0/0x110
[166603.828239] unregister_netdev+0x28/0x38
[166603.828425] nic_remove+0x58/0xc0 [hinic]
[166603.828442] detach_uld+0xd8/0x1a8 [hinic]
[166603.828458] hinic_ulds_deinit+0x54/0x68 [hinic]
[166603.828473] hinic_remove+0x218/0x240 [hinic]
[166603.828481] pci_device_remove+0x48/0xd8
[166603.828490] device_release_driver_internal+0x1b4/0x250
[166603.828492] device_release_driver+0x28/0x38
[166603.828499] pci_stop_bus_device+0x84/0xb8
[166603.828500] pci_stop_bus_device+0x40/0xb8
[166603.828502] pci_stop_bus_device+0x40/0xb8
[166603.828503] pci_stop_and_remove_bus_device+0x20/0x38
[166603.828557] PCIEMGT_KNL_DelPciDev+0xc0/0x198 [pciemgtagent]
[166603.828564] PCIEMGT_KNL_DelDev+0xac/0x1d8 [pciemgtagent]
[166603.828573] PCIEMGT_DelKnlDev+0x50/0x180 [pciemgtagent]
[166603.828579] PCIEMGT_KAGENT_DevEventHandle+0x94/0x168 [pciemgtagent]
[166603.828585] PCIEMGT_KAGENT_EventHandleThread+0xb8/0x1a0 [pciemgtagent]
[166603.828594] kthread+0x134/0x138
[166603.828599] ret_from_fork+0x10/0x18
[166603.828601]---[ end trace 5052903cb62d99f0 ]---
[166603.828612]Unable to handle kernel NULL pointer dereference at virtual address 00000000000000c0
[166603.828613]Mem abort info:
[166603.828614]  ESR = 0x96000006
[166603.828616]  Exception class = DABT (current EL), IL = 32 bits
[166603.828617]  SET = 0, FnV = 0
[166603.828618]  EA = 0, S1PTW = 0
[166603.828618]Data abort info:
[166603.828619]  ISV = 0, ISS = 0x00000006
[166603.828620]  CM = 0, WnR = 0
[166603.828622]user pgtable: 4k pages, 48-bit VAs, pgdp = 000000003c6ab870
[166603.828623][00000000000000c0] pgd=00002022651d1003, pud=000020226bd6a003, pmd=0000000000000000
[166603.828628]Internal error: Oops: 96000006 [#1] SMP
[166603.828630]Process PCIE40:c.0 (pid: 15382, stack limit = 0x00000000d24f8167)
[166603.828632]CPU: 135 PID: 15382 Comm: PCIE40:c.0 Kdump: loaded Tainted: PF       WC OE     4.19.36-vhulk1907.1.0.h453.eulerosv2r8.aarch64 #1
[166603.828633]Hardware name: Huawei Technologies Co., Ltd. PANGEA/STL6SPCB, BIOS TA BIOS Pangea3P CS - 11.01.60T31 05/26/2019
[166603.828634]pstate: 40c00009 (nZcv daif +PAN +UAO)
[166603.828636]pc : __netdev_adjacent_dev_remove.constprop.40+0x28/0x1e8
[166603.828638]lr : __netdev_adjacent_dev_unlink_neighbour+0x3c/0x48
[166603.828639]sp : ffff000031efb810
[166603.828639]x29: ffff000031efb810 x28: 0000000000002710
[166603.828641]x27: 0000000000000001 x26: ffffa021f4095d88
[166603.828643]x25: ffff000008d30de8 x24: ffff0000092d75d6
[166603.828645]x23: 0000000000000006 x22: 0000000000000000
[166603.828647]x21: ffffa021e1edc480 x20: 00000000000000c0
[166603.828649]x19: 0000000000000000 x18: ffffffffffffffff
[166603.828651]x17: 0000000000000000 x16: 0000000000000000
[166603.828653]x15: ffff0000091d9708 x14: 776620746567206f
[166603.828654]x13: 742064656c696146 x12: ffff800040801004
[166603.828656]x11: ffff80004080100c x10: ffff0000091dbae0
[166603.828658]x9 : 0000000000000001 x8 : 0000000006a60f9c
[166603.828660]x7 : ffff0000093b6fc0 x6 : 0000000000000001
[166603.828662]x5 : 0000000000000001 x4 : ffffa020560383c0
[166603.828664]x3 : ffffa020560383c0 x2 : 00000000000000c0
[166603.828666]x1 : ffffa021e1edc480 x0 : ffff000008879f7c
[166603.828668]Call trace:
[166603.828669] __netdev_adjacent_dev_remove.constprop.40+0x28/0x1e8
[166603.828670] __netdev_adjacent_dev_unlink_neighbour+0x3c/0x48
[166603.828672] netdev_upper_dev_unlink+0x7c/0xe8
[166603.828674] vrf_device_event+0x58/0x80 [vrf]
[166603.828675] notifier_call_chain+0x5c/0xa0
[166603.828676] raw_notifier_call_chain+0x3c/0x50
[166603.828678] call_netdevice_notifiers_info+0x3c/0x80
[166603.828679] rollback_registered_many+0x35c/0x568
[166603.828681] rollback_registered+0x68/0xb0
[166603.828682] unregister_netdevice_queue+0xc0/0x110
[166603.828684] unregister_netdev+0x28/0x38
[166603.828699] nic_remove+0x58/0xc0 [hinic]
[166603.828714] detach_uld+0xd8/0x1a8 [hinic]
[166603.828729] hinic_ulds_deinit+0x54/0x68 [hinic]
[166603.828743] hinic_remove+0x218/0x240 [hinic]
[166603.828745] pci_device_remove+0x48/0xd8
[166603.828747] device_release_driver_internal+0x1b4/0x250
[166603.828748] device_release_driver+0x28/0x38
[166603.828750] pci_stop_bus_device+0x84/0xb8
[166603.828751] pci_stop_bus_device+0x40/0xb8
[166603.828752] pci_stop_bus_device+0x40/0xb8
[166603.828753] pci_stop_and_remove_bus_device+0x20/0x38
[166603.828760] PCIEMGT_KNL_DelPciDev+0xc0/0x198 [pciemgtagent]
[166603.828765] PCIEMGT_KNL_DelDev+0xac/0x1d8 [pciemgtagent]
[166603.828771] PCIEMGT_DelKnlDev+0x50/0x180 [pciemgtagent]
[166603.828776] PCIEMGT_KAGENT_DevEventHandle+0x94/0x168 [pciemgtagent]
[166603.828782] PCIEMGT_KAGENT_EventHandleThread+0xb8/0x1a0 [pciemgtagent]
[166603.828784] kthread+0x134/0x138
[166603.828785] ret_from_fork+0x10/0x18
[166603.828788]Code: aa0203f4 aa1e03e0 d503201f d503201f (f9400280)
[166603.828789]kernel fault(0x1) notification starting on CPU 135

set vrf nomaster function vrf_del_slave() and del nic function
vrf_device_event() concurrent execution will occasionally oops.

thread1                     thread2

do_vrf_del_slave
netdev_upper_dev_unlink()   vrf_device_event
 	
                            vrf_device_event
                            netif_is_l3_slave(dev)
                            //IFF_L3MDEV_SLAVE is not cleaned
                            //so function return 1
                            netdev_master_upper_dev_get()
                            //return vrf_dev is NULL
                            ....	
                            __netdev_adjacent_dev_remove()
                            //adj pointer is NULL cause WARN_ON
                            __netdev_adjacent_dev_remove()
                            //down_list is NULL cause OOPS

port_dev->priv_flags &= ~IFF_L3MDEV_SLAVE;

why oops did not happen in __netdev_adjacent_dev_unlink_lists()'s
parameter “&upper_dev->adj_list.lower”.
we Disassemble __netdev_adjacent_dev_unlink_neighbour:
.....
 <__netdev_adjacent_dev_unlink_neighbour+44>: add     x2, x19, #0xc0
 <__netdev_adjacent_dev_unlink_neighbour+48>: mov     x1, x20
 <__netdev_adjacent_dev_unlink_neighbour+52>: mov     x0, x19
....
upper_dev->adj_list.lower is compiled to be optimized to
upper_dev pointer offset 0xc0.

this patch adds vrf_dev NULL pointer judgment to resolve the above problem.

Signed-off-by: XiaoGang Wang <wangxiaogang3@huawei.com>
Reviewed-by: JunWei Hu <hujunwei4@huawei.com>
---
 drivers/net/vrf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index b8228f5..86c4b8c 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -1427,6 +1427,9 @@ static int vrf_device_event(struct notifier_block *unused,
 			goto out;

 		vrf_dev = netdev_master_upper_dev_get(dev);
+		if (!vrf_dev)
+			goto out;
+
 		vrf_del_slave(vrf_dev, dev);
 	}
 out:
-- 
1.7.12.4


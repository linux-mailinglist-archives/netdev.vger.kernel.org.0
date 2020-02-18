Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E25C161F97
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 04:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbgBRDjo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 22:39:44 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:60374 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726166AbgBRDjo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Feb 2020 22:39:44 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 74EEF8FC6ED6BCEAAC74;
        Tue, 18 Feb 2020 11:39:41 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.439.0; Tue, 18 Feb 2020 11:39:35 +0800
From:   Lang Cheng <chenglang@huawei.com>
To:     <dledford@redhat.com>, <jgg@ziepe.ca>, <leon@kernel.org>,
        <davem@davemloft.net>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>
CC:     <linuxarm@huawei.com>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>
Subject: [RFC rdma-next] RDMA/core: Add attribute WQ_MEM_RECLAIM to workqueue "infiniband"
Date:   Tue, 18 Feb 2020 11:35:35 +0800
Message-ID: <1581996935-46507-1-git-send-email-chenglang@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The hns3 driver sets "hclge_service_task" workqueue with
WQ_MEM_RECLAIM flag in order to guarantee forward progress
under memory pressure. When hns3 ethernet driver perfrom a
reset bacause of tx timeout or ras error, hclge_service_task
will unregister ib_device before telling the fw to perfrom the
hardware reset in oder to disable accessing to the ib_device.
And ib_unregister_device() will call ib_cache_cleanup_one() to
flush workqueue "infiniband", which is without WQ_MEM_RECLAIM set,
then a WARNNING is triggered as below:

[11246.200168] hns3 0000:bd:00.1: Reset done, hclge driver initialization finished.
[11246.209979] hns3 0000:bd:00.1 eth7: net open
[11246.227608] ------------[ cut here ]------------
[11246.237370] workqueue: WQ_MEM_RECLAIM hclge:hclge_service_task [hclge] is flushing !WQ_MEM_RECLAIM infiniband:0x0
[11246.237391] WARNING: CPU: 50 PID: 2279 at ./kernel/workqueue.c:2605 check_flush_dependency+0xcc/0x140
[11246.260412] Modules linked in: hclgevf hns_roce_hw_v2 rdma_test(O) hns3 xt_CHECKSUM iptable_mangle xt_conntrack ipt_REJECT nf_reject_ipv4 ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter bpfilter vfio_iommu_type1 vfio_pci vfio_virqfd vfio ib_isert iscsi_target_mod ib_ipoib ib_umad rpcrdma ib_iser libiscsi scsi_transport_iscsi aes_ce_blk crypto_simd cryptd aes_ce_cipher sunrpc nls_iso8859_1 crct10dif_ce ghash_ce sha2_ce sha256_arm64 sha1_ce joydev input_leds hid_generic usbkbd usbmouse sbsa_gwdt usbhid usb_storage hid ses hclge hisi_zip hisi_hpre hisi_sec2 hnae3 hisi_qm ahci hisi_trng_v2 evbug uacce rng_core gpio_dwapb autofs4 hisi_sas_v3_hw megaraid_sas hisi_sas_main libsas scsi_transport_sas [last unloaded: hns_roce_hw_v2]
[11246.325742] CPU: 50 PID: 2279 Comm: kworker/50:0 Kdump: loaded Tainted: G           O      5.4.0-rc4+ #1
[11246.335181] Hardware name: Huawei TaiShan 200 (Model 2280)/BC82AMDD, BIOS 2280-V2 CS V3.B140.01 12/18/2019
[11246.344802] Workqueue: hclge hclge_service_task [hclge]
[11246.350007] pstate: 60c00009 (nZCv daif +PAN +UAO)
[11246.354779] pc : check_flush_dependency+0xcc/0x140
[11246.359549] lr : check_flush_dependency+0xcc/0x140
[11246.364317] sp : ffff800268a73990
[11246.367618] x29: ffff800268a73990 x28: 0000000000000001 
[11246.372907] x27: ffffcbe4f5868000 x26: ffffcbe4f5541000 
[11246.378196] x25: 00000000000000b8 x24: ffff002fdd0ff868 
[11246.383483] x23: ffff002fdd0ff800 x22: ffff2027401ba600 
[11246.388770] x21: 0000000000000000 x20: ffff002fdd0ff800 
[11246.394059] x19: ffff202719293b00 x18: ffffcbe4f5541948 
[11246.399347] x17: 000000006f8ad8dd x16: 0000000000000002 
[11246.404634] x15: ffff8002e8a734f7 x14: 6c66207369205d65 
[11246.409922] x13: 676c63685b206b73 x12: 61745f6563697672 
[11246.415208] x11: 65735f65676c6368 x10: 3a65676c6368204d 
[11246.420494] x9 : 49414c4345525f4d x8 : 6e6162696e69666e 
[11246.425782] x7 : 69204d49414c4345 x6 : ffffcbe4f5765145 
[11246.431068] x5 : 0000000000000000 x4 : 0000000000000000 
[11246.436355] x3 : 0000000000000030 x2 : 00000000ffffffff 
[11246.441642] x1 : 3349eb1ac5310100 x0 : 0000000000000000 
[11246.446928] Call trace:
[11246.449363]  check_flush_dependency+0xcc/0x140
[11246.453785]  flush_workqueue+0x110/0x410
[11246.457691]  ib_cache_cleanup_one+0x54/0x468
[11246.461943]  __ib_unregister_device+0x70/0xa8
[11246.466279]  ib_unregister_device+0x2c/0x40
[11246.470455]  hns_roce_exit+0x34/0x198 [hns_roce_hw_v2]
[11246.475571]  __hns_roce_hw_v2_uninit_instance.isra.56+0x3c/0x58 [hns_roce_hw_v2]
[11246.482934]  hns_roce_hw_v2_reset_notify+0xd8/0x210 [hns_roce_hw_v2]
[11246.489261]  hclge_notify_roce_client+0x84/0xe0 [hclge]
[11246.494464]  hclge_reset_rebuild+0x60/0x730 [hclge]
[11246.499320]  hclge_reset_service_task+0x400/0x5a0 [hclge]
[11246.504695]  hclge_service_task+0x54/0x698 [hclge]
[11246.509464]  process_one_work+0x15c/0x458
[11246.513454]  worker_thread+0x144/0x520
[11246.517186]  kthread+0xfc/0x128
[11246.520314]  ret_from_fork+0x10/0x18
[11246.523873] ---[ end trace eb980723699c2585 ]---
[11246.528710] hns3 0000:bd:00.2: Func clear success after reset.
[11246.528747] hns3 0000:bd:00.0: Func clear success after reset.
[11246.907710] hns3 0000:bd:00.1 eth7: link up

There may be three ways to avoid the above warnning:
1. Allocate the "hclge_service_task" workqueue without
WQ_MEM_RECLAIM flag, which may cause deadlock problem
when hns3 driver is used as the low level transport of
a network file system

2. Do not unregister ib_device during reset process, maybe
only disable accessing to the ib_device using disable_device()
as rdma_dev_change_netns() does.

3. Allocate the "infiniband" workqueue with WQ_MEM_RECLAIM flag.

This patch allocates the "infiniband" workqueue with WQ_MEM_RECLAIM
flag to avoid the warnning.

Fixes: 0ea68902256e ("net: hns3: allocate WQ with WQ_MEM_RECLAIM flag")
Signed-off-by: Lang Cheng <chenglang@huawei.com>
---
 drivers/infiniband/core/device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 84dd74f..595548a 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -2707,7 +2707,7 @@ static int __init ib_core_init(void)
 {
 	int ret;
 
-	ib_wq = alloc_workqueue("infiniband", 0, 0);
+	ib_wq = alloc_workqueue("infiniband", WQ_MEM_RECLAIM, 0);
 	if (!ib_wq)
 		return -ENOMEM;
 
-- 
2.8.1


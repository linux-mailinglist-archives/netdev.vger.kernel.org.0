Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5D96DBB58
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 16:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbjDHOBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Apr 2023 10:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbjDHOBh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Apr 2023 10:01:37 -0400
Received: from mail-m11880.qiye.163.com (mail-m11880.qiye.163.com [115.236.118.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04F21EF96;
        Sat,  8 Apr 2023 07:01:34 -0700 (PDT)
Received: from localhost.localdomain (unknown [IPV6:240e:3b7:3279:cf80:b96f:666f:20ca:bc83])
        by mail-m11880.qiye.163.com (Hmail) with ESMTPA id 855A420196;
        Sat,  8 Apr 2023 22:01:28 +0800 (CST)
From:   Ding Hui <dinghui@sangfor.com.cn>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, intel-wired-lan@lists.osuosl.org
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        keescook@chromium.org, grzegorzx.szczurek@intel.com,
        mateusz.palczewski@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        Ding Hui <dinghui@sangfor.com.cn>,
        Donglin Peng <pengdonglin@sangfor.com.cn>,
        Huang Cun <huangcun@sangfor.com.cn>
Subject: [PATCH net 1/2] iavf: Fix use-after-free in free_netdev
Date:   Sat,  8 Apr 2023 22:00:29 +0800
Message-Id: <20230408140030.5769-2-dinghui@sangfor.com.cn>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230408140030.5769-1-dinghui@sangfor.com.cn>
References: <20230408140030.5769-1-dinghui@sangfor.com.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVlDH0weVkIfH0xMGk8eHR5MHlUTARMWGhIXJBQOD1
        lXWRgSC1lBWUlPSx5BSBlMQUhJTEJBGB1DS0EZQk0dQU1NTR1BSUsYGkEZGENIWVdZFhoPEhUdFF
        lBWU9LSFVKSENMSEpVSktLVUtZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MBw6DRw5ST0OPDcBSSgUHAxM
        GVEaFAhVSlVKTUNLQk1JT0NCTUlOVTMWGhIXVR8SFRwTDhI7CBoVHB0UCVUYFBZVGBVFWVdZEgtZ
        QVlJT0seQUgZTEFISUxCQRgdQ0tBGUJNHUFNTU0dQUlLGBpBGRhDSFlXWQgBWUFDQ05KNwY+
X-HM-Tid: 0a87612c0aa72eb6kusn855a420196
X-HM-MType: 1
X-Spam-Status: No, score=-0.0 required=5.0 tests=RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We do netif_napi_add() for all allocated q_vectors[], but potentially
do netif_napi_del() for part of them, then kfree q_vectors and lefted
invalid pointers at dev->napi_list.

If num_active_queues is changed to less than allocated q_vectors[] by
by unexpected, when iavf_remove, we might see UAF in free_netdev like this:

[ 4093.900222] ==================================================================
[ 4093.900230] BUG: KASAN: use-after-free in free_netdev+0x308/0x390
[ 4093.900232] Read of size 8 at addr ffff88b4dc145640 by task test-iavf-1.sh/6699
[ 4093.900233]
[ 4093.900236] CPU: 10 PID: 6699 Comm: test-iavf-1.sh Kdump: loaded Tainted: G           O     --------- -t - 4.18.0 #1
[ 4093.900238] Hardware name: Powerleader PR2008AL/H12DSi-N6, BIOS 2.0 04/09/2021
[ 4093.900239] Call Trace:
[ 4093.900244]  dump_stack+0x71/0xab
[ 4093.900249]  print_address_description+0x6b/0x290
[ 4093.900251]  ? free_netdev+0x308/0x390
[ 4093.900252]  kasan_report+0x14a/0x2b0
[ 4093.900254]  free_netdev+0x308/0x390
[ 4093.900261]  iavf_remove+0x825/0xd20 [iavf]
[ 4093.900265]  pci_device_remove+0xa8/0x1f0
[ 4093.900268]  device_release_driver_internal+0x1c6/0x460
[ 4093.900271]  pci_stop_bus_device+0x101/0x150
[ 4093.900273]  pci_stop_and_remove_bus_device+0xe/0x20
[ 4093.900275]  pci_iov_remove_virtfn+0x187/0x420
[ 4093.900277]  ? pci_iov_add_virtfn+0xe10/0xe10
[ 4093.900278]  ? pci_get_subsys+0x90/0x90
[ 4093.900280]  sriov_disable+0xed/0x3e0
[ 4093.900282]  ? bus_find_device+0x12d/0x1a0
[ 4093.900290]  i40e_free_vfs+0x754/0x1210 [i40e]
[ 4093.900298]  ? i40e_reset_all_vfs+0x880/0x880 [i40e]
[ 4093.900299]  ? pci_get_device+0x7c/0x90
[ 4093.900300]  ? pci_get_subsys+0x90/0x90
[ 4093.900306]  ? pci_vfs_assigned.part.7+0x144/0x210
[ 4093.900309]  ? __mutex_lock_slowpath+0x10/0x10
[ 4093.900315]  i40e_pci_sriov_configure+0x1fa/0x2e0 [i40e]
[ 4093.900318]  sriov_numvfs_store+0x214/0x290
[ 4093.900320]  ? sriov_totalvfs_show+0x30/0x30
[ 4093.900321]  ? __mutex_lock_slowpath+0x10/0x10
[ 4093.900323]  ? __check_object_size+0x15a/0x350
[ 4093.900326]  kernfs_fop_write+0x280/0x3f0
[ 4093.900329]  vfs_write+0x145/0x440
[ 4093.900330]  ksys_write+0xab/0x160
[ 4093.900332]  ? __ia32_sys_read+0xb0/0xb0
[ 4093.900334]  ? fput_many+0x1a/0x120
[ 4093.900335]  ? filp_close+0xf0/0x130
[ 4093.900338]  do_syscall_64+0xa0/0x370
[ 4093.900339]  ? page_fault+0x8/0x30
[ 4093.900341]  entry_SYSCALL_64_after_hwframe+0x65/0xca
[ 4093.900357] RIP: 0033:0x7f16ad4d22c0
[ 4093.900359] Code: 73 01 c3 48 8b 0d d8 cb 2c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 83 3d 89 24 2d 00 00 75 10 b8 01 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 fe dd 01 00 48 89 04 24
[ 4093.900360] RSP: 002b:00007ffd6491b7f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
[ 4093.900362] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f16ad4d22c0
[ 4093.900363] RDX: 0000000000000002 RSI: 0000000001a41408 RDI: 0000000000000001
[ 4093.900364] RBP: 0000000001a41408 R08: 00007f16ad7a1780 R09: 00007f16ae1f2700
[ 4093.900364] R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000002
[ 4093.900365] R13: 0000000000000001 R14: 00007f16ad7a0620 R15: 0000000000000001
[ 4093.900367]
[ 4093.900368] Allocated by task 820:
[ 4093.900371]  kasan_kmalloc+0xa6/0xd0
[ 4093.900373]  __kmalloc+0xfb/0x200
[ 4093.900376]  iavf_init_interrupt_scheme+0x63b/0x1320 [iavf]
[ 4093.900380]  iavf_watchdog_task+0x3d51/0x52c0 [iavf]
[ 4093.900382]  process_one_work+0x56a/0x11f0
[ 4093.900383]  worker_thread+0x8f/0xf40
[ 4093.900384]  kthread+0x2a0/0x390
[ 4093.900385]  ret_from_fork+0x1f/0x40
[ 4093.900387]  0xffffffffffffffff
[ 4093.900387]
[ 4093.900388] Freed by task 6699:
[ 4093.900390]  __kasan_slab_free+0x137/0x190
[ 4093.900391]  kfree+0x8b/0x1b0
[ 4093.900394]  iavf_free_q_vectors+0x11d/0x1a0 [iavf]
[ 4093.900397]  iavf_remove+0x35a/0xd20 [iavf]
[ 4093.900399]  pci_device_remove+0xa8/0x1f0
[ 4093.900400]  device_release_driver_internal+0x1c6/0x460
[ 4093.900401]  pci_stop_bus_device+0x101/0x150
[ 4093.900402]  pci_stop_and_remove_bus_device+0xe/0x20
[ 4093.900403]  pci_iov_remove_virtfn+0x187/0x420
[ 4093.900404]  sriov_disable+0xed/0x3e0
[ 4093.900409]  i40e_free_vfs+0x754/0x1210 [i40e]
[ 4093.900415]  i40e_pci_sriov_configure+0x1fa/0x2e0 [i40e]
[ 4093.900416]  sriov_numvfs_store+0x214/0x290
[ 4093.900417]  kernfs_fop_write+0x280/0x3f0
[ 4093.900418]  vfs_write+0x145/0x440
[ 4093.900419]  ksys_write+0xab/0x160
[ 4093.900420]  do_syscall_64+0xa0/0x370
[ 4093.900421]  entry_SYSCALL_64_after_hwframe+0x65/0xca
[ 4093.900422]  0xffffffffffffffff
[ 4093.900422]
[ 4093.900424] The buggy address belongs to the object at ffff88b4dc144200
                which belongs to the cache kmalloc-8k of size 8192
[ 4093.900425] The buggy address is located 5184 bytes inside of
                8192-byte region [ffff88b4dc144200, ffff88b4dc146200)
[ 4093.900425] The buggy address belongs to the page:
[ 4093.900427] page:ffffea00d3705000 refcount:1 mapcount:0 mapping:ffff88bf04415c80 index:0x0 compound_mapcount: 0
[ 4093.900430] flags: 0x10000000008100(slab|head)
[ 4093.900433] raw: 0010000000008100 dead000000000100 dead000000000200 ffff88bf04415c80
[ 4093.900434] raw: 0000000000000000 0000000000030003 00000001ffffffff 0000000000000000
[ 4093.900434] page dumped because: kasan: bad access detected
[ 4093.900435]
[ 4093.900435] Memory state around the buggy address:
[ 4093.900436]  ffff88b4dc145500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[ 4093.900437]  ffff88b4dc145580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[ 4093.900438] >ffff88b4dc145600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[ 4093.900438]                                            ^
[ 4093.900439]  ffff88b4dc145680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[ 4093.900440]  ffff88b4dc145700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[ 4093.900440] ==================================================================

Fix it by letting netif_napi_del() match to netif_napi_add().

Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
Cc: Donglin Peng <pengdonglin@sangfor.com.cn>
CC: Huang Cun <huangcun@sangfor.com.cn>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 095201e83c9d..a57e3425f960 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -1849,19 +1849,15 @@ static int iavf_alloc_q_vectors(struct iavf_adapter *adapter)
 static void iavf_free_q_vectors(struct iavf_adapter *adapter)
 {
 	int q_idx, num_q_vectors;
-	int napi_vectors;
 
 	if (!adapter->q_vectors)
 		return;
 
 	num_q_vectors = adapter->num_msix_vectors - NONQ_VECS;
-	napi_vectors = adapter->num_active_queues;
 
 	for (q_idx = 0; q_idx < num_q_vectors; q_idx++) {
 		struct iavf_q_vector *q_vector = &adapter->q_vectors[q_idx];
-
-		if (q_idx < napi_vectors)
-			netif_napi_del(&q_vector->napi);
+		netif_napi_del(&q_vector->napi);
 	}
 	kfree(adapter->q_vectors);
 	adapter->q_vectors = NULL;
-- 
2.17.1


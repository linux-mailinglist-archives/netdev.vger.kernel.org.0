Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE3055E07F
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243526AbiF1CUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 22:20:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243524AbiF1CUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 22:20:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B6D22494A;
        Mon, 27 Jun 2022 19:19:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23B01B81C00;
        Tue, 28 Jun 2022 02:19:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 148EAC341CA;
        Tue, 28 Jun 2022 02:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656382791;
        bh=Q78B4HIHe+ZIKG+LJ9OZkYq2OyCFAm90aOtep1sNIiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t/o87W01jVAs/BlwRfeY/mwdcUCEtegUiOFNngYWcrpvML64QSJby/n4qwDm/es3P
         +gRbyL/yci74Kg+GqZuaKNImz9PWVYLEC3BzLxsduMeZSCkZ/5dhBJeVoUiLWG7kXv
         mBXp8knXJy7SSBgX+9qburWMb8eIrGvPr6I5MIpWJ+h5ctBICcjiwz2VfbuTxqZzOk
         Rn89jlsD5CDc12X0u/neTf4D4uFk31/OeK2+IjW1aziR3o3QEakK8+bvF35urYPMYm
         Blyljs7Q6H66xFnixLZyANYUhy6MrjMmBkvRERrnq9SfD/szmPcYKbHGsDdEPm7ucF
         9Yj3PlBMZvCbg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wentao_Liang <Wentao_Liang_g@163.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, jdmason@kudzu.us,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        paskripkin@gmail.com, jgg@ziepe.ca, liuhangbin@gmail.com,
        arnd@arndb.de, christophe.jaillet@wanadoo.fr,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 24/53] drivers/net/ethernet/neterion/vxge: Fix a use-after-free bug in vxge-main.c
Date:   Mon, 27 Jun 2022 22:18:10 -0400
Message-Id: <20220628021839.594423-24-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628021839.594423-1-sashal@kernel.org>
References: <20220628021839.594423-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wentao_Liang <Wentao_Liang_g@163.com>

[ Upstream commit 8fc74d18639a2402ca52b177e990428e26ea881f ]

The pointer vdev points to a memory region adjacent to a net_device
structure ndev, which is a field of hldev. At line 4740, the invocation
to vxge_device_unregister unregisters device hldev, and it also releases
the memory region pointed by vdev->bar0. At line 4743, the freed memory
region is referenced (i.e., iounmap(vdev->bar0)), resulting in a
use-after-free vulnerability. We can fix the bug by calling iounmap
before vxge_device_unregister.

4721.      static void vxge_remove(struct pci_dev *pdev)
4722.      {
4723.             struct __vxge_hw_device *hldev;
4724.             struct vxgedev *vdev;
…
4731.             vdev = netdev_priv(hldev->ndev);
…
4740.             vxge_device_unregister(hldev);
4741.             /* Do not call pci_disable_sriov here, as it
						will break child devices */
4742.             vxge_hw_device_terminate(hldev);
4743.             iounmap(vdev->bar0);
…
4749              vxge_debug_init(vdev->level_trace, "%s:%d
								Device unregistered",
4750                            __func__, __LINE__);
4751              vxge_debug_entryexit(vdev->level_trace, "%s:%d
								Exiting...", __func__,
4752                          __LINE__);
4753.      }

This is the screenshot when the vulnerability is triggered by using
KASAN. We can see that there is a use-after-free reported by KASAN.

/***************************start**************************/

root@kernel:~# echo 1 > /sys/bus/pci/devices/0000:00:03.0/remove
[  178.296316] vxge_remove
[  182.057081]
 ==================================================================
[  182.057548] BUG: KASAN: use-after-free in vxge_remove+0xe0/0x15c
[  182.057760] Read of size 8 at addr ffff888006c76598 by task bash/119
[  182.057983]
[  182.058747] CPU: 0 PID: 119 Comm: bash Not tainted 5.18.0 #5
[  182.058919] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
[  182.059463] Call Trace:
[  182.059726]  <TASK>
[  182.060017]  dump_stack_lvl+0x34/0x44
[  182.060316]  print_report.cold+0xb2/0x6b7
[  182.060401]  ? kfree+0x89/0x290
[  182.060478]  ? vxge_remove+0xe0/0x15c
[  182.060545]  kasan_report+0xa9/0x120
[  182.060629]  ? vxge_remove+0xe0/0x15c
[  182.060706]  vxge_remove+0xe0/0x15c
[  182.060793]  pci_device_remove+0x5d/0xe0
[  182.060968]  device_release_driver_internal+0xf1/0x180
[  182.061063]  pci_stop_bus_device+0xae/0xe0
[  182.061150]  pci_stop_and_remove_bus_device_locked+0x11/0x20
[  182.061236]  remove_store+0xc6/0xe0
[  182.061297]  ? subordinate_bus_number_show+0xc0/0xc0
[  182.061359]  ? __mutex_lock_slowpath+0x10/0x10
[  182.061438]  ? sysfs_kf_write+0x6d/0xa0
[  182.061525]  kernfs_fop_write_iter+0x1b0/0x260
[  182.061610]  ? sysfs_kf_bin_read+0xf0/0xf0
[  182.061695]  new_sync_write+0x209/0x310
[  182.061789]  ? new_sync_read+0x310/0x310
[  182.061865]  ? cgroup_rstat_updated+0x5c/0x170
[  182.061937]  ? preempt_count_sub+0xf/0xb0
[  182.061995]  ? pick_next_entity+0x13a/0x220
[  182.062063]  ? __inode_security_revalidate+0x44/0x80
[  182.062155]  ? security_file_permission+0x46/0x2a0
[  182.062230]  vfs_write+0x33f/0x3e0
[  182.062303]  ksys_write+0xb4/0x150
[  182.062369]  ? __ia32_sys_read+0x40/0x40
[  182.062451]  do_syscall_64+0x3b/0x90
[  182.062531]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
[  182.062894] RIP: 0033:0x7f3f37d17274
[  182.063558] Code: 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b3 0f 1f
80 00 00 00 00 48 8d 05 89 54 0d 00 8b 00 85 c0 75 13 b8 01 00 00 00 0f
05 <48> 3d 00 f0 ff ff 77 54 c3 0f 1f 00 41 54 49 89 d4 55 48 89 f5 53
[  182.063797] RSP: 002b:00007ffd5ba9e178 EFLAGS: 00000246
ORIG_RAX: 0000000000000001
[  182.064117] RAX: ffffffffffffffda RBX: 0000000000000002
RCX: 00007f3f37d17274
[  182.064219] RDX: 0000000000000002 RSI: 000055bbec327180
RDI: 0000000000000001
[  182.064315] RBP: 000055bbec327180 R08: 000000000000000a
R09: 00007f3f37de7cf0
[  182.064414] R10: 000000000000000a R11: 0000000000000246
R12: 00007f3f37de8760
[  182.064513] R13: 0000000000000002 R14: 00007f3f37de3760
R15: 0000000000000002
[  182.064691]  </TASK>
[  182.064916]
[  182.065224] The buggy address belongs to the physical page:
[  182.065804] page:00000000ef31e4f4 refcount:0 mapcount:0
mapping:0000000000000000 index:0x0 pfn:0x6c76
[  182.067419] flags: 0x100000000000000(node=0|zone=1)
[  182.068997] raw: 0100000000000000 0000000000000000
ffffea00001b1d88 0000000000000000
[  182.069118] raw: 0000000000000000 0000000000000000
00000000ffffffff 0000000000000000
[  182.069294] page dumped because: kasan: bad access detected
[  182.069331]
[  182.069360] Memory state around the buggy address:
[  182.070006]  ffff888006c76480: ff ff ff ff ff ff ff ff ff ff ff
 ff ff ff ff ff
[  182.070136]  ffff888006c76500: ff ff ff ff ff ff ff ff ff ff ff
 ff ff ff ff ff
[  182.070230] >ffff888006c76580: ff ff ff ff ff ff ff ff ff ff ff
 ff ff ff ff ff
[  182.070305]                             ^
[  182.070456]  ffff888006c76600: ff ff ff ff ff ff ff ff ff ff ff
 ff ff ff ff ff
[  182.070505]  ffff888006c76680: ff ff ff ff ff ff ff ff ff ff ff
 ff ff ff ff ff
[  182.070606]
==================================================================
[  182.071374] Disabling lock debugging due to kernel taint

/*****************************end*****************************/

After fixing the bug as done in the patch, we can find KASAN do not report
 the bug and the device(00:03.0) has been successfully removed.

/*****************************start***************************/

root@kernel:~# echo 1 > /sys/bus/pci/devices/0000:00:03.0/remove
root@kernel:~#

/******************************end****************************/

Signed-off-by: Wentao_Liang <Wentao_Liang_g@163.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/neterion/vxge/vxge-main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/neterion/vxge/vxge-main.c b/drivers/net/ethernet/neterion/vxge/vxge-main.c
index aa7c093f1f91..9684d468b5a7 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-main.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-main.c
@@ -4737,10 +4737,10 @@ static void vxge_remove(struct pci_dev *pdev)
 	for (i = 0; i < vdev->no_of_vpath; i++)
 		vxge_free_mac_add_list(&vdev->vpaths[i]);
 
+	iounmap(vdev->bar0);
 	vxge_device_unregister(hldev);
 	/* Do not call pci_disable_sriov here, as it will break child devices */
 	vxge_hw_device_terminate(hldev);
-	iounmap(vdev->bar0);
 	pci_release_region(pdev, 0);
 	pci_disable_device(pdev);
 	driver_config->config_dev_cnt--;
-- 
2.35.1


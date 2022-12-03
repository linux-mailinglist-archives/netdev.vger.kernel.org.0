Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC3B36414A5
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 08:14:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbiLCHO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 02:14:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbiLCHOZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 02:14:25 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80FF61741B;
        Fri,  2 Dec 2022 23:14:23 -0800 (PST)
Received: from dggpemm500015.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4NPLdF6b48z15N2q;
        Sat,  3 Dec 2022 15:13:37 +0800 (CST)
Received: from huawei.com (10.175.103.91) by dggpemm500015.china.huawei.com
 (7.185.36.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sat, 3 Dec
 2022 15:14:21 +0800
From:   Wang ShaoBo <bobo.shaobowang@huawei.com>
CC:     <liwei391@huawei.com>, <sameo@linux.intel.com>, <kuba@kernel.org>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bobo.shaobowang@huawei.com>,
        <pabeni@redhat.com>
Subject: [PATCH v2] nfc: llcp: Fix race in handling llcp_devices
Date:   Sat, 3 Dec 2022 15:12:18 +0800
Message-ID: <20221203071218.3817593-1-bobo.shaobowang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500015.china.huawei.com (7.185.36.181)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are multiple path operate llcp_devices list without protection:

         CPU0                        CPU1

nfc_unregister_device()        nfc_register_device()
 nfc_llcp_unregister_device()    nfc_llcp_register_device() //no lock
    ...                            list_add(local->list, llcp_devices)
    local_release()
      list_del(local->list)

        CPU2
...
 nfc_llcp_find_local()
   list_for_each_entry(,&llcp_devices,)

So reach race condition if two of the three occur simultaneously, like
following crash report, although there is no reproduction script in
syzbot currently, our artificially constructed use cases can also
reproduce it.

list_del corruption. prev->next should be ffff888060ce7000, but was ffff88802a0ad000. (prev=ffffffff8e536240)
------------[ cut here ]------------
kernel BUG at lib/list_debug.c:59!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 16622 Comm: syz-executor.5 Not tainted 6.1.0-rc6-next-20221125-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
RIP: 0010:__list_del_entry_valid.cold+0x12/0x72 lib/list_debug.c:59
Code: f0 ff 0f 0b 48 89 f1 48 c7 c7 60 96 a6 8a 4c 89 e6 e8 4b 29 f0 ff 0f 0b 4c 89 e1 48 89 ee 48 c7 c7 c0 98 a6 8a e8 37 29 f0 ff <0f> 0b 48 89 ee 48 c7 c7 a0 97 a6 8a e8 26 29 f0 ff 0f 0b 4c 89 e2
RSP: 0018:ffffc900151afd58 EFLAGS: 00010282
RAX: 000000000000006d RBX: 0000000000000001 RCX: 0000000000000000
RDX: ffff88801e7eba80 RSI: ffffffff8166001c RDI: fffff52002a35f9d
RBP: ffff888060ce7000 R08: 000000000000006d R09: 0000000000000000
R10: 0000000080000000 R11: 0000000000000000 R12: ffffffff8e536240
R13: ffff88801f3f3000 R14: ffff888060ce1000 R15: ffff888079d855f0
FS:  0000555556f57400(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f095d5ad988 CR3: 000000002155a000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __list_del_entry include/linux/list.h:134 [inline]
 list_del include/linux/list.h:148 [inline]
 local_release net/nfc/llcp_core.c:171 [inline]
 kref_put include/linux/kref.h:65 [inline]
 nfc_llcp_local_put net/nfc/llcp_core.c:181 [inline]
 nfc_llcp_local_put net/nfc/llcp_core.c:176 [inline]
 nfc_llcp_unregister_device+0xb8/0x260 net/nfc/llcp_core.c:1619
 nfc_unregister_device+0x196/0x330 net/nfc/core.c:1179
 virtual_ncidev_close+0x52/0xb0 drivers/nfc/virtual_ncidev.c:163
 __fput+0x27c/0xa90 fs/file_table.c:320
 task_work_run+0x16f/0x270 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0x23c/0x250 kernel/entry/common.c:203
 __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
 syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:296
 do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

This patch add llcp_devices_list_lock lock to make it safe to process
llcp_devices list.

Fixes: 30cc4587659e ("NFC: Move LLCP code to the NFC top level diirectory")
Reported-by: syzbot+81232c4a81a886e2b580@syzkaller.appspotmail.com
Signed-off-by: Wang ShaoBo <bobo.shaobowang@huawei.com>
---
v2:
- replace mutex lock with spin lock

 net/nfc/llcp_core.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/net/nfc/llcp_core.c b/net/nfc/llcp_core.c
index 3364caabef8b..b2161f6b92ae 100644
--- a/net/nfc/llcp_core.c
+++ b/net/nfc/llcp_core.c
@@ -17,6 +17,7 @@
 static u8 llcp_magic[3] = {0x46, 0x66, 0x6d};
 
 static LIST_HEAD(llcp_devices);
+static DEFINE_SPINLOCK(llcp_devices_list_lock);
 
 static void nfc_llcp_rx_skb(struct nfc_llcp_local *local, struct sk_buff *skb);
 
@@ -168,7 +169,9 @@ static void local_release(struct kref *ref)
 
 	local = container_of(ref, struct nfc_llcp_local, ref);
 
+	spin_lock(&llcp_devices_list_lock);
 	list_del(&local->list);
+	spin_unlock(&llcp_devices_list_lock);
 	local_cleanup(local);
 	kfree(local);
 }
@@ -282,9 +285,13 @@ struct nfc_llcp_local *nfc_llcp_find_local(struct nfc_dev *dev)
 {
 	struct nfc_llcp_local *local;
 
+	spin_lock(&llcp_devices_list_lock);
 	list_for_each_entry(local, &llcp_devices, list)
-		if (local->dev == dev)
+		if (local->dev == dev) {
+			spin_unlock(&llcp_devices_list_lock);
 			return local;
+		}
+	spin_unlock(&llcp_devices_list_lock);
 
 	pr_debug("No device found\n");
 
@@ -1600,7 +1607,9 @@ int nfc_llcp_register_device(struct nfc_dev *ndev)
 	timer_setup(&local->sdreq_timer, nfc_llcp_sdreq_timer, 0);
 	INIT_WORK(&local->sdreq_timeout_work, nfc_llcp_sdreq_timeout_work);
 
+	spin_lock(&llcp_devices_list_lock);
 	list_add(&local->list, &llcp_devices);
+	spin_unlock(&llcp_devices_list_lock);
 
 	return 0;
 }
-- 
2.25.1


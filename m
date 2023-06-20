Return-Path: <netdev+bounces-12102-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 677C77361A4
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 04:54:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42C00280F63
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 02:54:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 345FE139B;
	Tue, 20 Jun 2023 02:54:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F997ED5
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 02:54:26 +0000 (UTC)
Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [52.237.72.81])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id AC27E119
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 19:54:22 -0700 (PDT)
Received: from localhost.localdomain (unknown [39.174.92.167])
	by mail-app3 (Coremail) with SMTP id cC_KCgAHDw+_FJFkiLceCA--.36171S4;
	Tue, 20 Jun 2023 10:53:52 +0800 (CST)
From: Lin Ma <linma@zju.edu.cn>
To: krzysztof.kozlowski@linaro.org,
	avem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	netdev@vger.kernel.org
Cc: Lin Ma <linma@zju.edu.cn>
Subject: [PATCH v1] net: nfc: Fix use-after-free in nfc_genl_llc_{{get/set}_params/sdreq}
Date: Tue, 20 Jun 2023 10:53:50 +0800
Message-Id: <20230620025350.4034422-1-linma@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID:cC_KCgAHDw+_FJFkiLceCA--.36171S4
X-Coremail-Antispam: 1UD129KBjvJXoW3urW7Cr18Gw1rZFy3Aw1rXrb_yoWDXF15pa
	sxGryxGr40qryDZrWIyF48JFyrZFZxA3WjkrWIkrZIkF9Iqry3JF109r98ur1UCr4kCFy7
	ZFnxGr48Kw1UJaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyv14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4U
	JVW0owA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCF04k20xvY0x0EwIxG
	rwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4
	vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IY
	x2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26c
	xKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAF
	wI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VUbXdbUUUUUU==
X-CM-SenderInfo: qtrwiiyqvtljo62m3hxhgxhubq/
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H2,RCVD_IN_VALIDITY_RPBL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

This commit fixes a use-after-free for object nfc_llcp_local, the root
cause of this bug is due to the race in nfc_llcp_unregister_device.
Just like the buggy time window below. Since the nfc_llcp_find_local will
not increase the reference counter of object nfc_llcp_local, UAF occurs.

// nfc_genl_llc_get_params   | // nfc_unregister_device
                             |
dev = nfc_get_device(idx);   | device_lock(...)
if (!dev)                    | dev->shutting_down = true;
    return -ENODEV;          | device_unlock(...);
                             |
device_lock(...);            |   // nfc_llcp_unregister_device
                             |   nfc_llcp_find_local()
nfc_llcp_find_local(...);    |
                             |   local_cleanup()
if (!local) {                |
    rc = -ENODEV;            |     // nfc_llcp_local_put
    goto exit;               |     kref_put(.., local_release)
}                            |
                             |       // local_release
                             |       list_del(&local->list)
  // nfc_genl_send_params    |       kfree()
  local->dev->idx !!!UAF!!!  |
                             |
To avoid this, we can add a check to dev->shutting_down inside the
device_lock critical section. Therefore, the nfc_genl_llc_get_params will
surely error return if it grabs the lock after the nfc_unregister_device
releases the lock.

This patch applies such check for nfc_genl_llc_{{get/set}_params/sdreq}
as they all use nfc_llcp_find_local and suffer from the race condition.

The crash log for this bug is presented below.
==================================================================
BUG: KASAN: slab-use-after-free in nfc_genl_llc_get_params+0x72f/0x780  net/nfc/netlink.c:1045
Read of size 8 at addr ffff888105b0e410 by task 20114

Call Trace:
 <TASK>
 __dump_stack  lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x72/0xa0  lib/dump_stack.c:106
 print_address_description  mm/kasan/report.c:319 [inline]
 print_report+0xcc/0x620  mm/kasan/report.c:430
 kasan_report+0xb2/0xe0  mm/kasan/report.c:536
 nfc_genl_send_params  net/nfc/netlink.c:999 [inline]
 nfc_genl_llc_get_params+0x72f/0x780  net/nfc/netlink.c:1045
 genl_family_rcv_msg_doit.isra.0+0x1ee/0x2e0  net/netlink/genetlink.c:968
 genl_family_rcv_msg  net/netlink/genetlink.c:1048 [inline]
 genl_rcv_msg+0x503/0x7d0  net/netlink/genetlink.c:1065
 netlink_rcv_skb+0x161/0x430  net/netlink/af_netlink.c:2548
 genl_rcv+0x28/0x40  net/netlink/genetlink.c:1076
 netlink_unicast_kernel  net/netlink/af_netlink.c:1339 [inline]
 netlink_unicast+0x644/0x900  net/netlink/af_netlink.c:1365
 netlink_sendmsg+0x934/0xe70  net/netlink/af_netlink.c:1913
 sock_sendmsg_nosec  net/socket.c:724 [inline]
 sock_sendmsg+0x1b6/0x200  net/socket.c:747
 ____sys_sendmsg+0x6e9/0x890  net/socket.c:2501
 ___sys_sendmsg+0x110/0x1b0  net/socket.c:2555
 __sys_sendmsg+0xf7/0x1d0  net/socket.c:2584
 do_syscall_x64  arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3f/0x90  arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x72/0xdc
RIP: 0033:0x7f34640a2389
RSP: 002b:00007f3463415168 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f34641c1f80 RCX: 00007f34640a2389
RDX: 0000000000000000 RSI: 0000000020000240 RDI: 0000000000000006
RBP: 00007f34640ed493 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffe38449ecf R14: 00007f3463415300 R15: 0000000000022000
 </TASK>

Allocated by task 20116:
 kasan_save_stack+0x22/0x50  mm/kasan/common.c:45
 kasan_set_track+0x25/0x30  mm/kasan/common.c:52
 ____kasan_kmalloc  mm/kasan/common.c:374 [inline]
 __kasan_kmalloc+0x7f/0x90  mm/kasan/common.c:383
 kmalloc  include/linux/slab.h:580 [inline]
 kzalloc  include/linux/slab.h:720 [inline]
 nfc_llcp_register_device+0x49/0xa40  net/nfc/llcp_core.c:1567
 nfc_register_device+0x61/0x260  net/nfc/core.c:1124
 nci_register_device+0x776/0xb20  net/nfc/nci/core.c:1257
 virtual_ncidev_open+0x147/0x230  drivers/nfc/virtual_ncidev.c:148
 misc_open+0x379/0x4a0  drivers/char/misc.c:165
 chrdev_open+0x26c/0x780  fs/char_dev.c:414
 do_dentry_open+0x6c4/0x12a0  fs/open.c:920
 do_open  fs/namei.c:3560 [inline]
 path_openat+0x24fe/0x37e0  fs/namei.c:3715
 do_filp_open+0x1ba/0x410  fs/namei.c:3742
 do_sys_openat2+0x171/0x4c0  fs/open.c:1356
 do_sys_open  fs/open.c:1372 [inline]
 __do_sys_openat  fs/open.c:1388 [inline]
 __se_sys_openat  fs/open.c:1383 [inline]
 __x64_sys_openat+0x143/0x200  fs/open.c:1383
 do_syscall_x64  arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3f/0x90  arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x72/0xdc

Freed by task 20115:
 kasan_save_stack+0x22/0x50  mm/kasan/common.c:45
 kasan_set_track+0x25/0x30  mm/kasan/common.c:52
 kasan_save_free_info+0x2e/0x50  mm/kasan/generic.c:521
 ____kasan_slab_free  mm/kasan/common.c:236 [inline]
 ____kasan_slab_free  mm/kasan/common.c:200 [inline]
 __kasan_slab_free+0x10a/0x190  mm/kasan/common.c:244
 kasan_slab_free  include/linux/kasan.h:162 [inline]
 slab_free_hook  mm/slub.c:1781 [inline]
 slab_free_freelist_hook  mm/slub.c:1807 [inline]
 slab_free  mm/slub.c:3787 [inline]
 __kmem_cache_free+0x7a/0x190  mm/slub.c:3800
 local_release  net/nfc/llcp_core.c:174 [inline]
 kref_put  include/linux/kref.h:65 [inline]
 nfc_llcp_local_put  net/nfc/llcp_core.c:182 [inline]
 nfc_llcp_local_put  net/nfc/llcp_core.c:177 [inline]
 nfc_llcp_unregister_device+0x206/0x290  net/nfc/llcp_core.c:1620
 nfc_unregister_device+0x160/0x1d0  net/nfc/core.c:1179
 virtual_ncidev_close+0x52/0xa0  drivers/nfc/virtual_ncidev.c:163
 __fput+0x252/0xa20  fs/file_table.c:321
 task_work_run+0x174/0x270  kernel/task_work.c:179
 resume_user_mode_work  include/linux/resume_user_mode.h:49 [inline]
 exit_to_user_mode_loop  kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0x108/0x110  kernel/entry/common.c:204
 __syscall_exit_to_user_mode_work  kernel/entry/common.c:286 [inline]
 syscall_exit_to_user_mode+0x21/0x50  kernel/entry/common.c:297
 do_syscall_64+0x4c/0x90  arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x72/0xdc

Last potentially related work creation:
 kasan_save_stack+0x22/0x50  mm/kasan/common.c:45
 __kasan_record_aux_stack+0x95/0xb0  mm/kasan/generic.c:491
 kvfree_call_rcu+0x29/0xa80  kernel/rcu/tree.c:3328
 drop_sysctl_table+0x3be/0x4e0  fs/proc/proc_sysctl.c:1735
 unregister_sysctl_table.part.0+0x9c/0x190  fs/proc/proc_sysctl.c:1773
 unregister_sysctl_table+0x24/0x30  fs/proc/proc_sysctl.c:1753
 neigh_sysctl_unregister+0x5f/0x80  net/core/neighbour.c:3895
 addrconf_notify+0x140/0x17b0  net/ipv6/addrconf.c:3684
 notifier_call_chain+0xbe/0x210  kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x150  net/core/dev.c:1937
 call_netdevice_notifiers_extack  net/core/dev.c:1975 [inline]
 call_netdevice_notifiers  net/core/dev.c:1989 [inline]
 dev_change_name+0x3c3/0x870  net/core/dev.c:1211
 dev_ifsioc+0x800/0xf70  net/core/dev_ioctl.c:376
 dev_ioctl+0x3d9/0xf80  net/core/dev_ioctl.c:542
 sock_do_ioctl+0x160/0x260  net/socket.c:1213
 sock_ioctl+0x3f9/0x670  net/socket.c:1316
 vfs_ioctl  fs/ioctl.c:51 [inline]
 __do_sys_ioctl  fs/ioctl.c:870 [inline]
 __se_sys_ioctl  fs/ioctl.c:856 [inline]
 __x64_sys_ioctl+0x19e/0x210  fs/ioctl.c:856
 do_syscall_x64  arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3f/0x90  arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x72/0xdc

The buggy address belongs to the object at ffff888105b0e400
 which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 16 bytes inside of
 freed 1024-byte region [ffff888105b0e400, ffff888105b0e800)

The buggy address belongs to the physical page:
page:ffffea000416c200 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x105b08
head:ffffea000416c200 order:3 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0x200000000010200(slab|head|node=0|zone=2)
raw: 0200000000010200 ffff8881000430c0 ffffea00044c7010 ffffea0004510e10
raw: 0000000000000000 00000000000a000a 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888105b0e300: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888105b0e380: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff888105b0e400: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                         ^
 ffff888105b0e480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888105b0e500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb

Fixes: 52feb444a903 ("NFC: Extend netlink interface for LTO, RW, and MIUX parameters support")
Signed-off-by: Lin Ma <linma@zju.edu.cn>
---
 net/nfc/netlink.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index b9264e730fd9..7e57846fdfe3 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -1030,6 +1030,11 @@ static int nfc_genl_llc_get_params(struct sk_buff *skb, struct genl_info *info)
 
 	device_lock(&dev->dev);
 
+	if (dev->shutting_down) {
+		rc = -ENODEV;
+		goto exit;
+	}
+
 	local = nfc_llcp_find_local(dev);
 	if (!local) {
 		rc = -ENODEV;
@@ -1096,6 +1101,11 @@ static int nfc_genl_llc_set_params(struct sk_buff *skb, struct genl_info *info)
 
 	device_lock(&dev->dev);
 
+	if (dev->shutting_down) {
+		rc = -ENODEV;
+		goto exit;
+	}
+
 	local = nfc_llcp_find_local(dev);
 	if (!local) {
 		rc = -ENODEV;
@@ -1150,6 +1160,11 @@ static int nfc_genl_llc_sdreq(struct sk_buff *skb, struct genl_info *info)
 
 	device_lock(&dev->dev);
 
+	if (dev->shutting_down) {
+		rc = -ENODEV;
+		goto exit;
+	}
+
 	if (dev->dep_link_up == false) {
 		rc = -ENOLINK;
 		goto exit;
-- 
2.34.1



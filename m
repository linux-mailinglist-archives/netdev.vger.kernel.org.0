Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC5550B658
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 13:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447140AbiDVLrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 07:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447136AbiDVLrJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 07:47:09 -0400
Received: from zg8tmty1ljiyny4xntqumjca.icoremail.net (zg8tmty1ljiyny4xntqumjca.icoremail.net [165.227.154.27])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 277CB546B5;
        Fri, 22 Apr 2022 04:44:13 -0700 (PDT)
Received: from localhost.localdomain (unknown [183.157.163.171])
        by mail-app4 (Coremail) with SMTP id cS_KCgDn76f3lGJi02ScAQ--.35872S4;
        Fri, 22 Apr 2022 19:43:51 +0800 (CST)
From:   Lin Ma <linma@zju.edu.cn>
To:     jk@codeconstruct.com.au, matt@codeconstruct.com.au,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Lin Ma <linma@zju.edu.cn>
Subject: [PATCH v0] mctp: defer the kfree of object mdev->addrs
Date:   Fri, 22 Apr 2022 19:43:40 +0800
Message-Id: <20220422114340.32346-1-linma@zju.edu.cn>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: cS_KCgDn76f3lGJi02ScAQ--.35872S4
X-Coremail-Antispam: 1UD129KBjvJXoW3XrykCrW8Xr47WF4rKr45Wrg_yoWxKF1Upr
        n3ZayxGr48AFyDAr4Dtr1DXw18XF43Za4rJryxKw15AF1Utr1Fqrn09FW5Xr4UGasYkryx
        JFykJFyqvr45Xw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkS14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc2xSY4AK67AK6r4k
        MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr
        0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0E
        wIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJV
        W8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAI
        cVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfU5SdgDUUUU
X-CM-SenderInfo: qtrwiiyqvtljo62m3hxhgxhubq/
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,
        RCVD_IN_BL_SPAMCOP_NET,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function mctp_unregister() reclaims the device's relevant resource
when a netcard detaches. However, a running routine may be unaware of
this and cause the use-after-free of the mdev->addrs object.

The race condition can be demonstrated below

 cleanup thread               another thread
                          |
unregister_netdev()       |  mctp_sendmsg()
...                       |    ...
  mctp_unregister()       |    rt = mctp_route_lookup()
    ...                   |    mctl_local_output()
    kfree(mdev->addrs)    |      ...
                          |      saddr = rt->dev->addrs[0];
                          |

An attacker can adopt the (recent provided) mtcpserial driver with pty
to fake the device detaching and use the userfaultfd to increase the
race success chance (in mctp_sendmsg). The KASan report for such a POC
is shown below:

[   86.051955] ==================================================================
[   86.051955] BUG: KASAN: use-after-free in mctp_local_output+0x4e9/0xb7d
[   86.051955] Read of size 1 at addr ffff888005f298c0 by task poc/295
[   86.051955]
[   86.051955] Call Trace:
[   86.051955]  <TASK>
[   86.051955]  dump_stack_lvl+0x33/0x42
[   86.051955]  print_report.cold.13+0xb2/0x6b3
[   86.051955]  ? preempt_schedule_irq+0x57/0x80
[   86.051955]  ? mctp_local_output+0x4e9/0xb7d
[   86.051955]  kasan_report+0xa5/0x120
[   86.051955]  ? mctp_local_output+0x4e9/0xb7d
[   86.051955]  mctp_local_output+0x4e9/0xb7d
[   86.051955]  ? mctp_dev_set_key+0x79/0x79
[   86.051955]  ? copyin+0x38/0x50
[   86.051955]  ? _copy_from_iter+0x1b6/0xf20
[   86.051955]  ? sysvec_apic_timer_interrupt+0x97/0xb0
[   86.051955]  ? asm_sysvec_apic_timer_interrupt+0x12/0x20
[   86.051955]  ? mctp_local_output+0x1/0xb7d
[   86.051955]  mctp_sendmsg+0x64d/0xdb0
[   86.051955]  ? mctp_sk_close+0x20/0x20
[   86.051955]  ? __fget_light+0x2fd/0x4f0
[   86.051955]  ? mctp_sk_close+0x20/0x20
[   86.051955]  sock_sendmsg+0xdd/0x110
[   86.051955]  __sys_sendto+0x1cc/0x2a0
[   86.051955]  ? __ia32_sys_getpeername+0xa0/0xa0
[   86.051955]  ? new_sync_write+0x335/0x550
[   86.051955]  ? alloc_file+0x22f/0x500
[   86.051955]  ? __ip_do_redirect+0x820/0x1820
[   86.051955]  ? vfs_write+0x44d/0x7b0
[   86.051955]  ? vfs_write+0x44d/0x7b0
[   86.051955]  ? fput_many+0x15/0x120
[   86.051955]  ? ksys_write+0x155/0x1b0
[   86.051955]  ? __ia32_sys_read+0xa0/0xa0
[   86.051955]  __x64_sys_sendto+0xd8/0x1b0
[   86.051955]  ? exit_to_user_mode_prepare+0x2f/0x120
[   86.051955]  ? syscall_exit_to_user_mode+0x12/0x20
[   86.051955]  do_syscall_64+0x3a/0x80
[   86.051955]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[   86.051955] RIP: 0033:0x7f82118a56b3
[   86.051955] RSP: 002b:00007ffdb154b110 EFLAGS: 00000293 ORIG_RAX: 000000000000002c
[   86.051955] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f82118a56b3
[   86.051955] RDX: 0000000000000010 RSI: 00007f8211cd4000 RDI: 0000000000000007
[   86.051955] RBP: 00007ffdb154c1d0 R08: 00007ffdb154b164 R09: 000000000000000c
[   86.051955] R10: 0000000000000000 R11: 0000000000000293 R12: 000055d779800db0
[   86.051955] R13: 00007ffdb154c2b0 R14: 0000000000000000 R15: 0000000000000000
[   86.051955]  </TASK>
[   86.051955]
[   86.051955] Allocated by task 295:
[   86.051955]  kasan_save_stack+0x1c/0x40
[   86.051955]  __kasan_kmalloc+0x84/0xa0
[   86.051955]  mctp_rtm_newaddr+0x242/0x610
[   86.051955]  rtnetlink_rcv_msg+0x2fd/0x8b0
[   86.051955]  netlink_rcv_skb+0x11c/0x340
[   86.051955]  netlink_unicast+0x439/0x630
[   86.051955]  netlink_sendmsg+0x752/0xc00
[   86.051955]  sock_sendmsg+0xdd/0x110
[   86.051955]  __sys_sendto+0x1cc/0x2a0
[   86.051955]  __x64_sys_sendto+0xd8/0x1b0
[   86.051955]  do_syscall_64+0x3a/0x80
[   86.051955]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[   86.051955]
[   86.051955] Freed by task 301:
[   86.051955]  kasan_save_stack+0x1c/0x40
[   86.051955]  kasan_set_track+0x21/0x30
[   86.051955]  kasan_set_free_info+0x20/0x30
[   86.051955]  __kasan_slab_free+0x104/0x170
[   86.051955]  kfree+0x8c/0x290
[   86.051955]  mctp_dev_notify+0x161/0x2c0
[   86.051955]  raw_notifier_call_chain+0x8b/0xc0
[   86.051955]  unregister_netdevice_many+0x299/0x1180
[   86.051955]  unregister_netdevice_queue+0x210/0x2f0
[   86.051955]  unregister_netdev+0x13/0x20
[   86.051955]  mctp_serial_close+0x6d/0xa0
[   86.051955]  tty_ldisc_kill+0x31/0xa0
[   86.051955]  tty_ldisc_hangup+0x24f/0x560
[   86.051955]  __tty_hangup.part.28+0x2ce/0x6b0
[   86.051955]  tty_release+0x327/0xc70
[   86.051955]  __fput+0x1df/0x8b0
[   86.051955]  task_work_run+0xca/0x150
[   86.051955]  exit_to_user_mode_prepare+0x114/0x120
[   86.051955]  syscall_exit_to_user_mode+0x12/0x20
[   86.051955]  do_syscall_64+0x46/0x80
[   86.051955]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[   86.051955]
[   86.051955] The buggy address belongs to the object at ffff888005f298c0
[   86.051955]  which belongs to the cache kmalloc-8 of size 8
[   86.051955] The buggy address is located 0 bytes inside of
[   86.051955]  8-byte region [ffff888005f298c0, ffff888005f298c8)
[   86.051955]
[   86.051955] The buggy address belongs to the physical page:
[   86.051955] flags: 0x100000000000200(slab|node=0|zone=1)
[   86.051955] raw: 0100000000000200 dead000000000100 dead000000000122 ffff888005c42280
[   86.051955] raw: 0000000000000000 0000000080660066 00000001ffffffff 0000000000000000
[   86.051955] page dumped because: kasan: bad access detected
[   86.051955]
[   86.051955] Memory state around the buggy address:
[   86.051955]  ffff888005f29780: 00 fc fc fc fc 00 fc fc fc fc 00 fc fc fc fc 00
[   86.051955]  ffff888005f29800: fc fc fc fc 00 fc fc fc fc 00 fc fc fc fc 00 fc
[   86.051955] >ffff888005f29880: fc fc fc fb fc fc fc fc fa fc fc fc fc fa fc fc
[   86.051955]                                            ^
[   86.051955]  ffff888005f29900: fc fc 00 fc fc fc fc 00 fc fc fc fc 00 fc fc fc
[   86.051955]  ffff888005f29980: fc 00 fc fc fc fc 00 fc fc fc fc 00 fc fc fc fc
[   86.051955] ==================================================================

To this end, just like the commit e04480920d1e ("Bluetooth: defer
cleanup of resources in hci_unregister_dev()")  this patch defers the
destructive kfree(mdev->addrs) in mctp_unregister to the mctp_dev_put,
where the refcount of mdev is zero and the entire device is reclaimed.
This prevents the use-after-free because the sendmsg thread holds the
reference of mdev in the mctp_route object.

Fixes: 583be982d934 (mctp: Add device handling and netlink interface)
Signed-off-by: Lin Ma <linma@zju.edu.cn>
---
 net/mctp/device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mctp/device.c b/net/mctp/device.c
index f49be882e98e..99a3bda8852f 100644
--- a/net/mctp/device.c
+++ b/net/mctp/device.c
@@ -313,6 +313,7 @@ void mctp_dev_hold(struct mctp_dev *mdev)
 void mctp_dev_put(struct mctp_dev *mdev)
 {
 	if (mdev && refcount_dec_and_test(&mdev->refs)) {
+		kfree(mdev->addrs);
 		dev_put(mdev->dev);
 		kfree_rcu(mdev, rcu);
 	}
@@ -441,7 +442,6 @@ static void mctp_unregister(struct net_device *dev)
 
 	mctp_route_remove_dev(mdev);
 	mctp_neigh_remove_dev(mdev);
-	kfree(mdev->addrs);
 
 	mctp_dev_put(mdev);
 }
-- 
2.35.1


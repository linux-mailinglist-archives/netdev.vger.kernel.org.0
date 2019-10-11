Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC7DD3D19
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 12:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727716AbfJKKPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 06:15:07 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:63491 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726458AbfJKKPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 06:15:07 -0400
Received: from fsav403.sakura.ne.jp (fsav403.sakura.ne.jp [133.242.250.102])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id x9BAF3O6061629;
        Fri, 11 Oct 2019 19:15:03 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav403.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav403.sakura.ne.jp);
 Fri, 11 Oct 2019 19:15:03 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav403.sakura.ne.jp)
Received: from [192.168.1.8] (softbank126227201116.bbtec.net [126.227.201.116])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id x9BAEwA6061563
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NO);
        Fri, 11 Oct 2019 19:15:02 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Subject: Re: unregister_netdevice: waiting for DEV to become free (2)
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
References: <00000000000056268e05737dcb95@google.com>
 <0000000000007d22100573d66078@google.com>
Cc:     syzbot <syzbot+30209ea299c09d8785c9@syzkaller.appspotmail.com>,
        ddstreet@ieee.org, dvyukov@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, bpf@vger.kernel.org
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-ID: <063a57ba-7723-6513-043e-ee99c5797271@I-love.SAKURA.ne.jp>
Date:   Fri, 11 Oct 2019 19:14:54 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <0000000000007d22100573d66078@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

I noticed that syzbot is reporting that refcount incremented by bpf(BPF_MAP_UPDATE_ELEM)
syscall is not decremented when unregister_netdevice() is called. Is this a BPF bug?

Kernel: 9e208aa06c2109b45eec6be049a8e47034748c20 on linux.git
Config: https://syzkaller.appspot.com/text?tag=KernelConfig&x=73c2aace7604ab7
Reproducer: https://syzkaller.appspot.com/text?tag=ReproC&x=1215afaf600000
Debug printk patch:
----------------------------------------
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 9eda1c31d1f7..542a47fe6998 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3732,10 +3732,7 @@ void netdev_run_todo(void);
  *
  * Release reference to device to allow it to be freed.
  */
-static inline void dev_put(struct net_device *dev)
-{
-	this_cpu_dec(*dev->pcpu_refcnt);
-}
+extern void dev_put(struct net_device *dev);
 
 /**
  *	dev_hold - get reference to device
@@ -3743,10 +3740,7 @@ static inline void dev_put(struct net_device *dev)
  *
  * Hold reference to device to keep it from being freed.
  */
-static inline void dev_hold(struct net_device *dev)
-{
-	this_cpu_inc(*dev->pcpu_refcnt);
-}
+extern void dev_hold(struct net_device *dev);
 
 /* Carrier loss detection, dial on demand. The functions netif_carrier_on
  * and _off may be called from IRQ context, but it is caller
diff --git a/net/core/dev.c b/net/core/dev.c
index bf3ed413abaf..21f82aa92fad 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8968,8 +8968,8 @@ static void netdev_wait_allrefs(struct net_device *dev)
 		refcnt = netdev_refcnt_read(dev);
 
 		if (refcnt && time_after(jiffies, warning_time + 10 * HZ)) {
-			pr_emerg("unregister_netdevice: waiting for %s to become free. Usage count = %d\n",
-				 dev->name, refcnt);
+			pr_emerg("unregister_netdevice: waiting for %s to become free. Usage count = %d %px\n",
+				 dev->name, refcnt, dev);
 			warning_time = jiffies;
 		}
 	}
@@ -9930,3 +9930,24 @@ static int __init net_dev_init(void)
 }
 
 subsys_initcall(net_dev_init);
+
+
+void dev_put(struct net_device *dev)
+{
+	this_cpu_dec(*dev->pcpu_refcnt);
+	if (!strcmp(dev->name, "bridge_slave_0")) {
+		printk("dev_put: %px %d", dev, netdev_refcnt_read(dev));
+		dump_stack();
+	}
+}
+EXPORT_SYMBOL(dev_put);
+
+void dev_hold(struct net_device *dev)
+{
+	if (!strcmp(dev->name, "bridge_slave_0")) {
+		printk("dev_hold: %px %d", dev, netdev_refcnt_read(dev));
+		dump_stack();
+	}
+	this_cpu_inc(*dev->pcpu_refcnt);
+}
+EXPORT_SYMBOL(dev_hold);
----------------------------------------

----------------------------------------
Oct 11 14:33:06 ubuntu kernel: [  114.251175][ T8866] dev_hold: ffff888091fd2000 100
Oct 11 14:33:06 ubuntu kernel: [  114.251185][ T8866] CPU: 3 PID: 8866 Comm: a.out Not tainted 5.4.0-rc2+ #217
Oct 11 14:33:06 ubuntu kernel: [  114.251199][ T8866] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 04/13/2018
Oct 11 14:33:06 ubuntu kernel: [  114.251208][ T8866] Call Trace:
Oct 11 14:33:06 ubuntu kernel: [  114.251232][ T8866]  dump_stack+0x154/0x1c5
Oct 11 14:33:06 ubuntu kernel: [  114.251253][ T8866]  dev_hold+0x73/0x80
Oct 11 14:33:06 ubuntu kernel: [  114.251267][ T8866]  dev_get_by_index+0x1b3/0x2d0
Oct 11 14:33:06 ubuntu kernel: [  114.251280][ T8866]  __dev_map_alloc_node+0x1c7/0x360
Oct 11 14:33:06 ubuntu kernel: [  114.251299][ T8866]  dev_map_hash_update_elem+0x485/0x670
Oct 11 14:33:06 ubuntu kernel: [  114.251320][ T8866]  __do_sys_bpf+0x35d6/0x38c0
Oct 11 14:33:06 ubuntu kernel: [  114.251337][ T8866]  ? bpf_prog_load+0x1470/0x1470
Oct 11 14:33:06 ubuntu kernel: [  114.251351][ T8866]  ? do_wp_page+0x3c8/0x1310
Oct 11 14:33:06 ubuntu kernel: [  114.251364][ T8866]  ? finish_mkwrite_fault+0x300/0x300
Oct 11 14:33:06 ubuntu kernel: [  114.251381][ T8866]  ? find_held_lock+0x35/0x1e0
Oct 11 14:33:06 ubuntu kernel: [  114.251397][ T8866]  ? __do_page_fault+0x504/0xb60
Oct 11 14:33:06 ubuntu kernel: [  114.251413][ T8866]  ? lock_downgrade+0x900/0x900
Oct 11 14:33:06 ubuntu kernel: [  114.251426][ T8866]  ? __pmd_alloc+0x410/0x410
Oct 11 14:33:06 ubuntu kernel: [  114.251446][ T8866]  ? __kasan_check_write+0x14/0x20
Oct 11 14:33:06 ubuntu kernel: [  114.251457][ T8866]  ? up_read+0x1b6/0x7a0
Oct 11 14:33:06 ubuntu kernel: [  114.251471][ T8866]  ? down_read_nested+0x480/0x480
Oct 11 14:33:06 ubuntu kernel: [  114.251494][ T8866]  ? do_syscall_64+0x26/0x6a0
Oct 11 14:33:06 ubuntu kernel: [  114.251507][ T8866]  ? entry_SYSCALL_64_after_hwframe+0x49/0xbe
Oct 11 14:33:06 ubuntu kernel: [  114.251515][ T8866]  ? do_syscall_64+0x26/0x6a0
Oct 11 14:33:06 ubuntu kernel: [  114.251528][ T8866]  __x64_sys_bpf+0x73/0xb0
Oct 11 14:33:06 ubuntu kernel: [  114.251541][ T8866]  do_syscall_64+0xde/0x6a0
Oct 11 14:33:06 ubuntu kernel: [  114.251559][ T8866]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
(...snipped...)
Oct 11 14:33:10 ubuntu kernel: [  117.459637][ T9584] dev_hold: ffff888091fd2000 200
Oct 11 14:33:10 ubuntu kernel: [  117.459644][ T9584] CPU: 4 PID: 9584 Comm: a.out Not tainted 5.4.0-rc2+ #217
Oct 11 14:33:10 ubuntu kernel: [  117.459652][ T9584] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 04/13/2018
Oct 11 14:33:10 ubuntu kernel: [  117.459656][ T9584] Call Trace:
Oct 11 14:33:10 ubuntu kernel: [  117.459669][ T9584]  dump_stack+0x154/0x1c5
Oct 11 14:33:10 ubuntu kernel: [  117.459682][ T9584]  dev_hold+0x73/0x80
Oct 11 14:33:10 ubuntu kernel: [  117.459695][ T9584]  dev_get_by_index+0x1b3/0x2d0
Oct 11 14:33:10 ubuntu kernel: [  117.459706][ T9584]  __dev_map_alloc_node+0x1c7/0x360
Oct 11 14:33:10 ubuntu kernel: [  117.459720][ T9584]  dev_map_hash_update_elem+0x485/0x670
Oct 11 14:33:10 ubuntu kernel: [  117.459749][ T9584]  __do_sys_bpf+0x35d6/0x38c0
Oct 11 14:33:10 ubuntu kernel: [  117.459762][ T9584]  ? bpf_prog_load+0x1470/0x1470
Oct 11 14:33:10 ubuntu kernel: [  117.459769][ T9584]  ? do_wp_page+0x3c8/0x1310
Oct 11 14:33:10 ubuntu kernel: [  117.459778][ T9584]  ? finish_mkwrite_fault+0x300/0x300
Oct 11 14:33:10 ubuntu kernel: [  117.459787][ T9584]  ? find_held_lock+0x35/0x1e0
Oct 11 14:33:10 ubuntu kernel: [  117.459797][ T9584]  ? __do_page_fault+0x504/0xb60
Oct 11 14:33:10 ubuntu kernel: [  117.459807][ T9584]  ? lock_downgrade+0x900/0x900
Oct 11 14:33:10 ubuntu kernel: [  117.459814][ T9584]  ? __pmd_alloc+0x410/0x410
Oct 11 14:33:10 ubuntu kernel: [  117.459828][ T9584]  ? __kasan_check_write+0x14/0x20
Oct 11 14:33:10 ubuntu kernel: [  117.459835][ T9584]  ? up_read+0x1b6/0x7a0
Oct 11 14:33:10 ubuntu kernel: [  117.459846][ T9584]  ? down_read_nested+0x480/0x480
Oct 11 14:33:10 ubuntu kernel: [  117.459862][ T9584]  ? do_syscall_64+0x26/0x6a0
Oct 11 14:33:10 ubuntu kernel: [  117.459871][ T9584]  ? entry_SYSCALL_64_after_hwframe+0x49/0xbe
Oct 11 14:33:10 ubuntu kernel: [  117.459878][ T9584]  ? do_syscall_64+0x26/0x6a0
Oct 11 14:33:10 ubuntu kernel: [  117.459891][ T9584]  __x64_sys_bpf+0x73/0xb0
Oct 11 14:33:10 ubuntu kernel: [  117.459901][ T9584]  do_syscall_64+0xde/0x6a0
Oct 11 14:33:10 ubuntu kernel: [  117.459911][ T9584]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
(...snipped...)
Oct 11 14:33:26 ubuntu kernel: [  134.146838][T13860] dev_hold: ffff888091fd2000 850
Oct 11 14:33:26 ubuntu kernel: [  134.146847][T13860] CPU: 4 PID: 13860 Comm: a.out Not tainted 5.4.0-rc2+ #217
Oct 11 14:33:26 ubuntu kernel: [  134.146853][T13860] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 04/13/2018
Oct 11 14:33:26 ubuntu kernel: [  134.146859][T13860] Call Trace:
Oct 11 14:33:26 ubuntu kernel: [  134.146872][T13860]  dump_stack+0x154/0x1c5
Oct 11 14:33:26 ubuntu kernel: [  134.146885][T13860]  dev_hold+0x73/0x80
Oct 11 14:33:26 ubuntu kernel: [  134.146893][T13860]  dev_get_by_index+0x1b3/0x2d0
Oct 11 14:33:26 ubuntu kernel: [  134.146903][T13860]  __dev_map_alloc_node+0x1c7/0x360
Oct 11 14:33:26 ubuntu kernel: [  134.146918][T13860]  dev_map_hash_update_elem+0x485/0x670
Oct 11 14:33:26 ubuntu kernel: [  134.146932][T13860]  __do_sys_bpf+0x35d6/0x38c0
Oct 11 14:33:26 ubuntu kernel: [  134.146944][T13860]  ? bpf_prog_load+0x1470/0x1470
Oct 11 14:33:26 ubuntu kernel: [  134.146953][T13860]  ? do_wp_page+0x3c8/0x1310
Oct 11 14:33:26 ubuntu kernel: [  134.146964][T13860]  ? finish_mkwrite_fault+0x300/0x300
Oct 11 14:33:26 ubuntu kernel: [  134.146975][T13860]  ? find_held_lock+0x35/0x1e0
Oct 11 14:33:26 ubuntu kernel: [  134.146985][T13860]  ? __do_page_fault+0x504/0xb60
Oct 11 14:33:26 ubuntu kernel: [  134.146994][T13860]  ? lock_downgrade+0x900/0x900
Oct 11 14:33:26 ubuntu kernel: [  134.147002][T13860]  ? __pmd_alloc+0x410/0x410
Oct 11 14:33:26 ubuntu kernel: [  134.147017][T13860]  ? __kasan_check_write+0x14/0x20
Oct 11 14:33:26 ubuntu kernel: [  134.147024][T13860]  ? up_read+0x1b6/0x7a0
Oct 11 14:33:26 ubuntu kernel: [  134.147033][T13860]  ? down_read_nested+0x480/0x480
Oct 11 14:33:26 ubuntu kernel: [  134.147048][T13860]  ? do_syscall_64+0x26/0x6a0
Oct 11 14:33:26 ubuntu kernel: [  134.147056][T13860]  ? entry_SYSCALL_64_after_hwframe+0x49/0xbe
Oct 11 14:33:26 ubuntu kernel: [  134.147063][T13860]  ? do_syscall_64+0x26/0x6a0
Oct 11 14:33:26 ubuntu kernel: [  134.147074][T13860]  __x64_sys_bpf+0x73/0xb0
Oct 11 14:33:26 ubuntu kernel: [  134.147084][T13860]  do_syscall_64+0xde/0x6a0
Oct 11 14:33:26 ubuntu kernel: [  134.147095][T13860]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
(...snipped...)
Oct 11 14:33:41 ubuntu kernel: [  148.384539][ T4514] unregister_netdevice: waiting for bridge_slave_0 to become free. Usage count = 850 ffff888091fd2000
----------------------------------------


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0114FA77E
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 14:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240111AbiDIMMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Apr 2022 08:12:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241745AbiDIMMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Apr 2022 08:12:17 -0400
Received: from hust.edu.cn (mail.hust.edu.cn [202.114.0.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEA30A6E01;
        Sat,  9 Apr 2022 05:10:08 -0700 (PDT)
Received: from localhost.localdomain ([222.20.126.44])
        (user=dzm91@hust.edu.cn mech=LOGIN bits=0)
        by mx1.hust.edu.cn  with ESMTP id 239C92l5016938-239C92l8016938
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Sat, 9 Apr 2022 20:09:06 +0800
From:   Dongliang Mu <dzm91@hust.edu.cn>
To:     Oliver Neukum <oliver@neukum.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>,
        syzbot+eabbf2aaa999cc507108@syzkaller.appspotmail.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] driver: usb: nullify dangling pointer in cdc_ncm_free
Date:   Sat,  9 Apr 2022 20:09:00 +0800
Message-Id: <20220409120901.267526-1-dzm91@hust.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-FEAS-AUTH-USER: dzm91@hust.edu.cn
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dongliang Mu <mudongliangabcd@gmail.com>

cdc_ncm_bind calls cdc_ncm_bind_common and sets dev->data[0]
with ctx. However, in the unbind function - cdc_ncm_unbind,
it calls cdc_ncm_free and frees ctx, leaving dev->data[0] as
a dangling pointer. The following ioctl operation will trigger
the UAF in the function cdc_ncm_set_dgram_size.

Fix this by setting dev->data[0] as zero.

==================================================================
BUG: KASAN: use-after-free in cdc_ncm_set_dgram_size+0xc91/0xde0
Read of size 8 at addr ffff8880755210b0 by task dhcpcd/3174

Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0xeb/0x495 mm/kasan/report.c:313
 print_report mm/kasan/report.c:429 [inline]
 kasan_report.cold+0xf4/0x1c6 mm/kasan/report.c:491
 cdc_ncm_set_dgram_size+0xc91/0xde0 drivers/net/usb/cdc_ncm.c:608
 cdc_ncm_change_mtu+0x10c/0x140 drivers/net/usb/cdc_ncm.c:798
 __dev_set_mtu net/core/dev.c:8519 [inline]
 dev_set_mtu_ext+0x352/0x5b0 net/core/dev.c:8572
 dev_set_mtu+0x8e/0x120 net/core/dev.c:8596
 dev_ifsioc+0xb87/0x1090 net/core/dev_ioctl.c:332
 dev_ioctl+0x1b9/0xe30 net/core/dev_ioctl.c:586
 sock_do_ioctl+0x15a/0x230 net/socket.c:1136
 sock_ioctl+0x2f1/0x640 net/socket.c:1239
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl fs/ioctl.c:856 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0x80 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f00859e70e7
RSP: 002b:00007ffedd503dd8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f00858f96c8 RCX: 00007f00859e70e7
RDX: 00007ffedd513fc8 RSI: 0000000000008922 RDI: 0000000000000018
RBP: 00007ffedd524178 R08: 00007ffedd513f88 R09: 00007ffedd513f38
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffedd513fc8 R14: 0000000000000028 R15: 0000000000008922
 </TASK>

Allocated by task 26:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:45 [inline]
 set_alloc_info mm/kasan/common.c:436 [inline]
 ____kasan_kmalloc mm/kasan/common.c:515 [inline]
 ____kasan_kmalloc mm/kasan/common.c:474 [inline]
 __kasan_kmalloc+0xa9/0xd0 mm/kasan/common.c:524
 kmalloc include/linux/slab.h:581 [inline]
 kzalloc include/linux/slab.h:714 [inline]
 cdc_ncm_bind_common+0xb8/0x2df0 drivers/net/usb/cdc_ncm.c:826
 cdc_ncm_bind+0x7c/0x1c0 drivers/net/usb/cdc_ncm.c:1069
 usbnet_probe+0xaf8/0x2580 drivers/net/usb/usbnet.c:1747
 usb_probe_interface+0x315/0x7f0 drivers/usb/core/driver.c:396
 call_driver_probe drivers/base/dd.c:541 [inline]
 really_probe+0x23e/0xb20 drivers/base/dd.c:620
 __driver_probe_device+0x338/0x4d0 drivers/base/dd.c:751
 driver_probe_device+0x4c/0x1a0 drivers/base/dd.c:781
 __device_attach_driver+0x20b/0x2f0 drivers/base/dd.c:898
 bus_for_each_drv+0x15f/0x1e0 drivers/base/bus.c:427
 __device_attach+0x228/0x4a0 drivers/base/dd.c:969
 bus_probe_device+0x1e4/0x290 drivers/base/bus.c:487
 device_add+0xb83/0x1e20 drivers/base/core.c:3405
 usb_set_configuration+0x101e/0x1900 drivers/usb/core/message.c:2170
 usb_generic_driver_probe+0xba/0x100 drivers/usb/core/generic.c:238
 usb_probe_device+0xd9/0x2c0 drivers/usb/core/driver.c:293
 call_driver_probe drivers/base/dd.c:541 [inline]
 really_probe+0x23e/0xb20 drivers/base/dd.c:620
 __driver_probe_device+0x338/0x4d0 drivers/base/dd.c:751
 driver_probe_device+0x4c/0x1a0 drivers/base/dd.c:781
 __device_attach_driver+0x20b/0x2f0 drivers/base/dd.c:898
 bus_for_each_drv+0x15f/0x1e0 drivers/base/bus.c:427
 __device_attach+0x228/0x4a0 drivers/base/dd.c:969
 bus_probe_device+0x1e4/0x290 drivers/base/bus.c:487
 device_add+0xb83/0x1e20 drivers/base/core.c:3405
 usb_new_device.cold+0x641/0x1091 drivers/usb/core/hub.c:2566
 hub_port_connect drivers/usb/core/hub.c:5363 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5507 [inline]
 port_event drivers/usb/core/hub.c:5665 [inline]
 hub_event+0x25c6/0x4680 drivers/usb/core/hub.c:5747
 process_one_work+0x996/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298

Freed by task 3742:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track+0x21/0x30 mm/kasan/common.c:45
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:370
 ____kasan_slab_free mm/kasan/common.c:366 [inline]
 ____kasan_slab_free+0x166/0x1a0 mm/kasan/common.c:328
 kasan_slab_free include/linux/kasan.h:200 [inline]
 slab_free_hook mm/slub.c:1728 [inline]
 slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1754
 slab_free mm/slub.c:3510 [inline]
 kfree+0xd6/0x4d0 mm/slub.c:4552
 cdc_ncm_free+0x145/0x1a0 drivers/net/usb/cdc_ncm.c:786
 cdc_ncm_unbind+0x1a7/0x340 drivers/net/usb/cdc_ncm.c:1021
 usbnet_disconnect+0x103/0x270 drivers/net/usb/usbnet.c:1620
 usb_unbind_interface+0x1d8/0x8e0 drivers/usb/core/driver.c:458
 device_remove drivers/base/dd.c:531 [inline]
 device_remove+0x11f/0x170 drivers/base/dd.c:523
 __device_release_driver drivers/base/dd.c:1199 [inline]
 device_release_driver_internal+0x4a3/0x680 drivers/base/dd.c:1222
 bus_remove_device+0x2eb/0x5a0 drivers/base/bus.c:529
 device_del+0x4f3/0xc80 drivers/base/core.c:3592
 usb_disable_device+0x35b/0x7b0 drivers/usb/core/message.c:1419
 usb_disconnect.cold+0x278/0x6ec drivers/usb/core/hub.c:2228
 hub_port_connect drivers/usb/core/hub.c:5207 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5507 [inline]
 port_event drivers/usb/core/hub.c:5665 [inline]
 hub_event+0x1e74/0x4680 drivers/usb/core/hub.c:5747
 process_one_work+0x996/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298

Reported-by: syzbot+eabbf2aaa999cc507108@syzkaller.appspotmail.com
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
---
 drivers/net/usb/cdc_ncm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index 15f91d691bba..9fc2df9f0b63 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -1019,6 +1019,7 @@ void cdc_ncm_unbind(struct usbnet *dev, struct usb_interface *intf)
 
 	usb_set_intfdata(intf, NULL);
 	cdc_ncm_free(ctx);
+	dev->data[0] = 0;
 }
 EXPORT_SYMBOL_GPL(cdc_ncm_unbind);
 
-- 
2.25.1


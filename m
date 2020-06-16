Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEFCA1FA5B5
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 03:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbgFPBkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 21:40:55 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:6328 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725972AbgFPBky (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jun 2020 21:40:54 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 5CCFA8B61821B84F9131;
        Tue, 16 Jun 2020 09:40:46 +0800 (CST)
Received: from huawei.com (10.175.124.27) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Tue, 16 Jun 2020
 09:40:38 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <weiyongjun1@huawei.com>,
        <yangyingliang@huawei.com>
Subject: [PATCH net] net: fix memleak in register_netdevice()
Date:   Tue, 16 Jun 2020 09:39:21 +0000
Message-ID: <20200616093921.2185939-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I got a memleak report when doing some fuzz test:

unreferenced object 0xffff888112584000 (size 13599):
  comm "ip", pid 3048, jiffies 4294911734 (age 343.491s)
  hex dump (first 32 bytes):
    74 61 70 30 00 00 00 00 00 00 00 00 00 00 00 00  tap0............
    00 ee d9 19 81 88 ff ff 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<000000002f60ba65>] __kmalloc_node+0x309/0x3a0
    [<0000000075b211ec>] kvmalloc_node+0x7f/0xc0
    [<00000000d3a97396>] alloc_netdev_mqs+0x76/0xfc0
    [<00000000609c3655>] __tun_chr_ioctl+0x1456/0x3d70
    [<000000001127ca24>] ksys_ioctl+0xe5/0x130
    [<00000000b7d5e66a>] __x64_sys_ioctl+0x6f/0xb0
    [<00000000e1023498>] do_syscall_64+0x56/0xa0
    [<000000009ec0eb12>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
unreferenced object 0xffff888111845cc0 (size 8):
  comm "ip", pid 3048, jiffies 4294911734 (age 343.491s)
  hex dump (first 8 bytes):
    74 61 70 30 00 88 ff ff                          tap0....
  backtrace:
    [<000000004c159777>] kstrdup+0x35/0x70
    [<00000000d8b496ad>] kstrdup_const+0x3d/0x50
    [<00000000494e884a>] kvasprintf_const+0xf1/0x180
    [<0000000097880a2b>] kobject_set_name_vargs+0x56/0x140
    [<000000008fbdfc7b>] dev_set_name+0xab/0xe0
    [<000000005b99e3b4>] netdev_register_kobject+0xc0/0x390
    [<00000000602704fe>] register_netdevice+0xb61/0x1250
    [<000000002b7ca244>] __tun_chr_ioctl+0x1cd1/0x3d70
    [<000000001127ca24>] ksys_ioctl+0xe5/0x130
    [<00000000b7d5e66a>] __x64_sys_ioctl+0x6f/0xb0
    [<00000000e1023498>] do_syscall_64+0x56/0xa0
    [<000000009ec0eb12>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
unreferenced object 0xffff88811886d800 (size 512):
  comm "ip", pid 3048, jiffies 4294911734 (age 343.491s)
  hex dump (first 32 bytes):
    00 00 00 00 ad 4e ad de ff ff ff ff 00 00 00 00  .....N..........
    ff ff ff ff ff ff ff ff c0 66 3d a3 ff ff ff ff  .........f=.....
  backtrace:
    [<0000000050315800>] device_add+0x61e/0x1950
    [<0000000021008dfb>] netdev_register_kobject+0x17e/0x390
    [<00000000602704fe>] register_netdevice+0xb61/0x1250
    [<000000002b7ca244>] __tun_chr_ioctl+0x1cd1/0x3d70
    [<000000001127ca24>] ksys_ioctl+0xe5/0x130
    [<00000000b7d5e66a>] __x64_sys_ioctl+0x6f/0xb0
    [<00000000e1023498>] do_syscall_64+0x56/0xa0
    [<000000009ec0eb12>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

If call_netdevice_notifiers() failed, then rollback_registered()
calls netdev_unregister_kobject() which holds the kobject. The
reference cannot be put because the netdev won't be add to todo
list, so it will leads a memleak, we need put the reference to
avoid memleak.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 net/core/dev.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index a26d87073f71..a44871b39c6d 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8760,6 +8760,13 @@ int register_netdevice(struct net_device *dev)
 		rcu_barrier();
 
 		dev->reg_state = NETREG_UNREGISTERED;
+		/* We should put the kobject that hold in
+		 * netdev_unregister_kobject(), otherwise
+		 * the net device cannot be freed when
+		 * driver calls free_netdev(), because the
+		 * kobject is being hold.
+		 */
+		kobject_put(&dev->dev.kobj);
 	}
 	/*
 	 *	Prevent userspace races by waiting until the network
-- 
2.25.1


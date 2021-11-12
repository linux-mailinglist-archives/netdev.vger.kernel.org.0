Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4820D44E348
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 09:34:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233883AbhKLIhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 03:37:23 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:27202 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230464AbhKLIhW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 03:37:22 -0500
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HrBfn1dqbz8vKH;
        Fri, 12 Nov 2021 16:32:49 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Fri, 12 Nov 2021 16:34:27 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.15; Fri, 12 Nov
 2021 16:34:27 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <stable@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <rds-devel@oss.oracle.com>,
        <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <sashal@kernel.org>,
        <kuba@kernel.org>, <davem@davemloft.net>,
        <santosh.shilimkar@oracle.com>
Subject: [PATCH 5.10 0/1] fix null-ptr-deref in rds_ib_add_one()
Date:   Fri, 12 Nov 2021 16:41:22 +0800
Message-ID: <20211112084123.1091671-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I got this null-ptr-deref report while doing fuzz test:

[  158.820284][T12735] BUG: KASAN: null-ptr-deref in dma_pool_create+0xf7/0x440
[  158.821192][T12735] Read of size 4 at addr 0000000000000298 by task syz-executor.7/12735
[  158.822239][T12735]
[  158.822539][T12735] CPU: 0 PID: 12735 Comm: syz-executor.7 Not tainted 5.10.78 #691
[  158.823494][T12735] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
[  158.824720][T12735] Call Trace:
[  158.825889][T12735]  dump_stack+0x111/0x151
[  158.826458][T12735]  ? dma_pool_create+0xf7/0x440
[  158.827067][T12735]  ? dma_pool_create+0xf7/0x440
[  158.827672][T12735]  kasan_report.cold.11+0x5/0x37
[  158.828289][T12735]  ? dma_pool_create+0xf7/0x440
[  158.828894][T12735]  dma_pool_create+0xf7/0x440
[  158.829480][T12735]  rds_ib_add_one+0x448/0x570
[  158.830062][T12735]  ? rds_ib_remove_one+0x150/0x150
[  158.830702][T12735]  add_client_context+0x2ef/0x440
[  158.831329][T12735]  ? ib_unregister_driver+0x1a0/0x1a0
[  158.832005][T12735]  ? strchr+0x28/0x50
[  158.832527][T12735]  enable_device_and_get+0x199/0x320
[  158.833194][T12735]  ? add_one_compat_dev.part.20+0x3d0/0x3d0
[  158.833924][T12735]  ? rxe_ib_alloc_hw_stats+0x84/0x90
[  158.834590][T12735]  ? setup_hw_stats+0x40/0x520
[  158.835184][T12735]  ? uevent_show+0x1e0/0x1e0
[  158.835758][T12735]  ? rxe_ib_get_hw_stats+0xa0/0xa0
[  158.836398][T12735]  ib_register_device+0x8ef/0x9d0
[  158.837026][T12735]  ? netlink_unicast+0x3e1/0x510
[  158.837644][T12735]  ? alloc_port_data.part.17+0x1f0/0x1f0
[  158.838358][T12735]  ? __alloc_pages_nodemask+0x229/0x450
[  158.839051][T12735]  ? kasan_unpoison_shadow+0x30/0x40
[  158.839710][T12735]  ? __kasan_kmalloc.constprop.12+0xbe/0xd0
[  158.840443][T12735]  ? kmem_cache_alloc_node_trace+0xa3/0x870
[  158.841178][T12735]  ? __crypto_alg_lookup+0x26d/0x2d0
[  158.841841][T12735]  ? __kasan_kmalloc.constprop.12+0xbe/0xd0
[  158.842573][T12735]  ? crypto_shash_init_tfm+0x10d/0x160
[  158.843255][T12735]  ? crc32_pclmul_cra_init+0x12/0x20
[  158.843916][T12735]  ? crypto_create_tfm_node+0xb7/0x1a0
[  158.844594][T12735]  ? crypto_alloc_tfm_node+0x12e/0x260
[  158.845273][T12735]  rxe_register_device+0x21f/0x250
[  158.845904][T12735]  rxe_add+0x9f9/0xa80
[  158.846412][T12735]  rxe_net_add+0x56/0xa0
[  158.846917][T12735]  rxe_newlink+0x8c/0xb0
[  158.847427][T12735]  nldev_newlink+0x23d/0x360
[  158.847973][T12735]  ? nldev_set_doit+0x2b0/0x2b0
[  158.848562][T12735]  ? apparmor_capable+0x2e9/0x4e0
[  158.849159][T12735]  ? apparmor_cred_prepare+0x3f0/0x3f0
[  158.849811][T12735]  ? apparmor_cred_prepare+0x3f0/0x3f0
[  158.850469][T12735]  ? ____sys_sendmsg+0x4db/0x500
[  158.851064][T12735]  ? ___sys_sendmsg+0xf8/0x160
[  158.851648][T12735]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  158.852400][T12735]  ? cap_capable+0x125/0x140
[  158.854398][T12735]  ? ns_capable_common+0x88/0xa0
[  158.855012][T12735]  ? nldev_set_doit+0x2b0/0x2b0
[  158.855611][T12735]  rdma_nl_rcv+0x41f/0x630
[  158.856162][T12735]  ? rdma_nl_multicast+0xa0/0xa0
[  158.856772][T12735]  ? netlink_lookup+0x273/0x3a0
[  158.857374][T12735]  ? netlink_broadcast+0x40/0x40
[  158.857984][T12735]  ? __kasan_kmalloc.constprop.12+0xbe/0xd0
[  158.858724][T12735]  ? __rcu_read_unlock+0x34/0x260
[  158.859349][T12735]  ? netlink_deliver_tap+0x65/0x450
[  158.859991][T12735]  netlink_unicast+0x3e1/0x510
[  158.860586][T12735]  ? netlink_attachskb+0x540/0x540
[  158.861218][T12735]  ? _copy_from_iter_full+0x1b9/0x5e0
[  158.861905][T12735]  ? __check_object_size+0x27c/0x300
[  158.862561][T12735]  netlink_sendmsg+0x4aa/0x870
[  158.863131][T12735]  ? netlink_unicast+0x510/0x510
[  158.863728][T12735]  ? netlink_unicast+0x510/0x510
[  158.864326][T12735]  sock_sendmsg+0x83/0xa0
[  158.864849][T12735]  ____sys_sendmsg+0x4db/0x500
[  158.865429][T12735]  ? __copy_msghdr_from_user+0x310/0x310
[  158.866112][T12735]  ? kernel_sendmsg+0x50/0x50
[  158.866700][T12735]  ? do_syscall_64+0x2d/0x70
[  158.867256][T12735]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  158.867996][T12735]  ___sys_sendmsg+0xf8/0x160
[  158.868552][T12735]  ? sendmsg_copy_msghdr+0x70/0x70
[  158.869175][T12735]  ? kasan_unpoison_shadow+0x30/0x40
[  158.869824][T12735]  ? futex_exit_release+0x80/0x80
[  158.870442][T12735]  ? apparmor_task_setrlimit+0x500/0x500
[  158.871122][T12735]  ? kmem_cache_alloc+0x143/0x810
[  158.871733][T12735]  ? __rcu_read_unlock+0x34/0x260
[  158.872351][T12735]  ? __fget_files+0x14a/0x1b0
[  158.872920][T12735]  ? __fget_light+0xeb/0x140
[  158.873474][T12735]  __sys_sendmsg+0xfe/0x1c0
[  158.874017][T12735]  ? __sys_sendmsg_sock+0x80/0x80
[  158.874625][T12735]  ? _copy_to_user+0x97/0xb0
[  158.875177][T12735]  ? put_timespec64+0xab/0xe0
[  158.875740][T12735]  ? nsecs_to_jiffies+0x30/0x30
[  158.876325][T12735]  ? fpregs_assert_state_consistent+0x8f/0xa0
[  158.877054][T12735]  do_syscall_64+0x2d/0x70
[  158.877585][T12735]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  158.878297][T12735] RIP: 0033:0x45ecc9
[  158.878769][T12735] Code: 1d b1 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 eb b0 fb ff c3 66 2e 0f 1f 84 00 00 00 00
[  158.881085][T12735] RSP: 002b:00007f2c7a09fc68 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
[  158.882086][T12735] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000045ecc9
[  158.883038][T12735] RDX: 0000000000000000 RSI: 00000000200001c0 RDI: 000000000000000a
[  158.883983][T12735] RBP: 000000000119bfe0 R08: 0000000000000000 R09: 0000000000000000
[  158.884929][T12735] R10: 0000000000000000 R11: 0000000000000246 R12: 000000000119bfac
[  158.885877][T12735] R13: 00007fff86afff9f R14: 00007f2c7a0a09c0 R15: 000000000119bfac


In rxe_register_device(), it passes a null pointer to ib_register_device()
the 'device->dma_device' will be set to null, when it used in rds_ib_add_one(),
it leads a null-ptr-deref.

Christoph Hellwig (1):
  rds: stop using dmapool

 net/rds/ib.c      |  10 ----
 net/rds/ib.h      |   6 ---
 net/rds/ib_cm.c   | 128 ++++++++++++++++++++++++++++------------------
 net/rds/ib_recv.c |  18 +++++--
 net/rds/ib_send.c |   8 +++
 5 files changed, 101 insertions(+), 69 deletions(-)

-- 
2.25.1


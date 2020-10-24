Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1251B297C9D
	for <lists+netdev@lfdr.de>; Sat, 24 Oct 2020 15:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1761764AbgJXNiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Oct 2020 09:38:11 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:52525 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1761752AbgJXNiJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Oct 2020 09:38:09 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id CF902CAF;
        Sat, 24 Oct 2020 09:38:07 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 24 Oct 2020 09:38:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=cjqidKcNQOOceQWOj8m7rojktXcvRLtjjhT8bhD56hE=; b=ec65V2mN
        1MrqQHVmX+KQsg2sTijfMO97scIVs8C1Ae9tJAyFMenfp/Tcou/CV8c59P/X/05Z
        W+dvKJ8aEnCnQRDBQHAVWoy5av/tqqtBhMyTi45jFy5pYrL3edzEQWy4FmQwyrbc
        HmgTLkmGwFAw2a1IN2U9nRKleXpyIOBQa2QPcMR2JD/Xwxov5Ky7ty6oRmlmz6Te
        H7UMcrm0qBLH/leUPzPSV4tu40ZDDC6B1u6uKHi5XnKBTR2hzDsrzQl1f+4bX3uB
        5kJkkjyf8R1Jjc6c3fH+odIMyJ3O/OUscLSK7g4YVpvdiKo/mzZKRCkz5HCrieWP
        MX+9ihOsZl8mGg==
X-ME-Sender: <xms:Py6UXz4oZ6tlCw1yZfpvInS_JinabvYGTe_kIGf8W-W7Ah6oi6DnBw>
    <xme:Py6UX47yMc5BQuXHXqrFg7wW-_LxX_24HeFGMpZOPppgkWAzOsYQMPSAIrkkFodGa
    _MVA6HA18LbhYY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrkedvgdeijecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeefteeijedugfejheffffeigeeijeehke
    eltdfgudevgfefieekgefhffetgeduudenucffohhmrghinhepqhgvmhhurdhorhhgnecu
    kfhppeekgedrvddvledrfeejrddvvdeknecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:Py6UX6cyeGEdBS0PWZhmEbe29uGEk7xFumqymThO1Zx6UXx7rQAkVw>
    <xmx:Py6UX0IHh0bD8x2C2ueCwvsNqWBW52AaxVl4ayfRfHkGuph1MtS6oA>
    <xmx:Py6UX3InH4Fpqw7BGBT6sgbHP0Nto4LW02rCmRSjLmVtrxTTnCoqag>
    <xmx:Py6UX_1YFyLVM3xyxHpN8dw40mp7y4Ng3fyTeFV8Q74HkQbJY6MOyQ>
Received: from shredder.mtl.com (igld-84-229-37-228.inter.net.il [84.229.37.228])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0B9343280064;
        Sat, 24 Oct 2020 09:38:05 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net 3/3] mlxsw: core: Fix use-after-free in mlxsw_emad_trans_finish()
Date:   Sat, 24 Oct 2020 16:37:33 +0300
Message-Id: <20201024133733.2107509-4-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201024133733.2107509-1-idosch@idosch.org>
References: <20201024133733.2107509-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Each EMAD transaction stores the skb used to issue the EMAD request
('trans->tx_skb') so that the request could be retried in case of a
timeout. The skb can be freed when a corresponding response is received
or as part of the retry logic (e.g., failed retransmit, exceeded maximum
number of retries).

The two tasks (i.e., response processing and retransmits) are
synchronized by the atomic 'trans->active' field which ensures that
responses to inactive transactions are ignored.

In case of a failed retransmit the transaction is finished and all of
its resources are freed. However, the current code does not mark it as
inactive. Syzkaller was able to hit a race condition in which a
concurrent response is processed while the transaction's resources are
being freed, resulting in a use-after-free [1].

Fix the issue by making sure to mark the transaction as inactive after a
failed retransmit and free its resources only if a concurrent task did
not already do that.

[1]
BUG: KASAN: use-after-free in consume_skb+0x30/0x370
net/core/skbuff.c:833
Read of size 4 at addr ffff88804f570494 by task syz-executor.0/1004

CPU: 0 PID: 1004 Comm: syz-executor.0 Not tainted 5.8.0-rc7+ #68
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0xf6/0x16e lib/dump_stack.c:118
 print_address_description.constprop.0+0x1c/0x250
mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 check_memory_region_inline mm/kasan/generic.c:186 [inline]
 check_memory_region+0x14e/0x1b0 mm/kasan/generic.c:192
 instrument_atomic_read include/linux/instrumented.h:56 [inline]
 atomic_read include/asm-generic/atomic-instrumented.h:27 [inline]
 refcount_read include/linux/refcount.h:147 [inline]
 skb_unref include/linux/skbuff.h:1044 [inline]
 consume_skb+0x30/0x370 net/core/skbuff.c:833
 mlxsw_emad_trans_finish+0x64/0x1c0 drivers/net/ethernet/mellanox/mlxsw/core.c:592
 mlxsw_emad_process_response drivers/net/ethernet/mellanox/mlxsw/core.c:651 [inline]
 mlxsw_emad_rx_listener_func+0x5c9/0xac0 drivers/net/ethernet/mellanox/mlxsw/core.c:672
 mlxsw_core_skb_receive+0x4df/0x770 drivers/net/ethernet/mellanox/mlxsw/core.c:2063
 mlxsw_pci_cqe_rdq_handle drivers/net/ethernet/mellanox/mlxsw/pci.c:595 [inline]
 mlxsw_pci_cq_tasklet+0x12a6/0x2520 drivers/net/ethernet/mellanox/mlxsw/pci.c:651
 tasklet_action_common.isra.0+0x13f/0x3e0 kernel/softirq.c:550
 __do_softirq+0x223/0x964 kernel/softirq.c:292
 asm_call_on_stack+0x12/0x20 arch/x86/entry/entry_64.S:711

Allocated by task 1006:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc mm/kasan/common.c:494 [inline]
 __kasan_kmalloc.constprop.0+0xc2/0xd0 mm/kasan/common.c:467
 slab_post_alloc_hook mm/slab.h:586 [inline]
 slab_alloc_node mm/slub.c:2824 [inline]
 slab_alloc mm/slub.c:2832 [inline]
 kmem_cache_alloc+0xcd/0x2e0 mm/slub.c:2837
 __build_skb+0x21/0x60 net/core/skbuff.c:311
 __netdev_alloc_skb+0x1e2/0x360 net/core/skbuff.c:464
 netdev_alloc_skb include/linux/skbuff.h:2810 [inline]
 mlxsw_emad_alloc drivers/net/ethernet/mellanox/mlxsw/core.c:756 [inline]
 mlxsw_emad_reg_access drivers/net/ethernet/mellanox/mlxsw/core.c:787 [inline]
 mlxsw_core_reg_access_emad+0x1ab/0x1420 drivers/net/ethernet/mellanox/mlxsw/core.c:1817
 mlxsw_reg_trans_query+0x39/0x50 drivers/net/ethernet/mellanox/mlxsw/core.c:1831
 mlxsw_sp_sb_pm_occ_clear drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c:260 [inline]
 mlxsw_sp_sb_occ_max_clear+0xbff/0x10a0 drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c:1365
 mlxsw_devlink_sb_occ_max_clear+0x76/0xb0 drivers/net/ethernet/mellanox/mlxsw/core.c:1037
 devlink_nl_cmd_sb_occ_max_clear_doit+0x1ec/0x280 net/core/devlink.c:1765
 genl_family_rcv_msg_doit net/netlink/genetlink.c:669 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:714 [inline]
 genl_rcv_msg+0x617/0x980 net/netlink/genetlink.c:731
 netlink_rcv_skb+0x152/0x440 net/netlink/af_netlink.c:2470
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:742
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x53a/0x750 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x850/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0x150/0x190 net/socket.c:671
 ____sys_sendmsg+0x6d8/0x840 net/socket.c:2359
 ___sys_sendmsg+0xff/0x170 net/socket.c:2413
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2446
 do_syscall_64+0x56/0xa0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 73:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 kasan_set_free_info mm/kasan/common.c:316 [inline]
 __kasan_slab_free+0x12c/0x170 mm/kasan/common.c:455
 slab_free_hook mm/slub.c:1474 [inline]
 slab_free_freelist_hook mm/slub.c:1507 [inline]
 slab_free mm/slub.c:3072 [inline]
 kmem_cache_free+0xbe/0x380 mm/slub.c:3088
 kfree_skbmem net/core/skbuff.c:622 [inline]
 kfree_skbmem+0xef/0x1b0 net/core/skbuff.c:616
 __kfree_skb net/core/skbuff.c:679 [inline]
 consume_skb net/core/skbuff.c:837 [inline]
 consume_skb+0xe1/0x370 net/core/skbuff.c:831
 mlxsw_emad_trans_finish+0x64/0x1c0 drivers/net/ethernet/mellanox/mlxsw/core.c:592
 mlxsw_emad_transmit_retry.isra.0+0x9d/0xc0 drivers/net/ethernet/mellanox/mlxsw/core.c:613
 mlxsw_emad_trans_timeout_work+0x43/0x50 drivers/net/ethernet/mellanox/mlxsw/core.c:625
 process_one_work+0xa3e/0x17a0 kernel/workqueue.c:2269
 worker_thread+0x9e/0x1050 kernel/workqueue.c:2415
 kthread+0x355/0x470 kernel/kthread.c:291
 ret_from_fork+0x22/0x30 arch/x86/entry/entry_64.S:293

The buggy address belongs to the object at ffff88804f5703c0
 which belongs to the cache skbuff_head_cache of size 224
The buggy address is located 212 bytes inside of
 224-byte region [ffff88804f5703c0, ffff88804f5704a0)
The buggy address belongs to the page:
page:ffffea00013d5c00 refcount:1 mapcount:0 mapping:0000000000000000
index:0x0
flags: 0x100000000000200(slab)
raw: 0100000000000200 dead000000000100 dead000000000122 ffff88806c625400
raw: 0000000000000000 00000000000c000c 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88804f570380: fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb fb
 ffff88804f570400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88804f570480: fb fb fb fb fc fc fc fc fc fc fc fc fc fc fc fc
                         ^
 ffff88804f570500: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff88804f570580: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc

Fixes: caf7297e7ab5f ("mlxsw: core: Introduce support for asynchronous EMAD register access")
Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index a2efbb1e3cf4..937b8e46f8c7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -620,6 +620,9 @@ static void mlxsw_emad_transmit_retry(struct mlxsw_core *mlxsw_core,
 		err = mlxsw_emad_transmit(trans->core, trans);
 		if (err == 0)
 			return;
+
+		if (!atomic_dec_and_test(&trans->active))
+			return;
 	} else {
 		err = -EIO;
 	}
-- 
2.26.2


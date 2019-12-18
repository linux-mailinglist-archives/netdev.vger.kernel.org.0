Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 931D0123E29
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 04:58:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbfLRD6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 22:58:32 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:14111 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726387AbfLRD6c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 22:58:32 -0500
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id xBI3wRdS000886;
        Tue, 17 Dec 2019 19:58:28 -0800
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: [PATCH net v2] cxgb4: fix refcount init for TC-MQPRIO offload
Date:   Wed, 18 Dec 2019 09:19:29 +0530
Message-Id: <1576640969-15807-1-git-send-email-rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Properly initialize refcount to 1 when hardware queue arrays for
TC-MQPRIO offload have been freshly allocated. Otherwise, following
warning is observed. Also fix up error path to only free hardware
queue arrays when refcount reaches 0.

[  130.075342] ------------[ cut here ]------------
[  130.075343] refcount_t: addition on 0; use-after-free.
[  130.075355] WARNING: CPU: 0 PID: 10870 at lib/refcount.c:25
refcount_warn_saturate+0xe1/0x100
[  130.075356] Modules linked in: sch_mqprio iptable_nat ib_iser
libiscsi scsi_transport_iscsi ib_ipoib rdma_ucm ib_umad iw_cxgb4 libcxgb
ib_uverbs x86_pkg_temp_thermal cxgb4 igb
[  130.075361] CPU: 0 PID: 10870 Comm: tc Kdump: loaded Not tainted
5.5.0-rc1+ #11
[  130.075362] Hardware name: Supermicro
X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SRE/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2
01/16/2015
[  130.075363] RIP: 0010:refcount_warn_saturate+0xe1/0x100
[  130.075364] Code: e8 14 41 c1 ff 0f 0b c3 80 3d 44 f4 10 01 00 0f 85
63 ff ff ff 48 c7 c7 38 9f 83 8c 31 c0 c6 05 2e f4 10 01 01 e8 ef 40 c1
ff <0f> 0b c3 48 c7 c7 10 9f 83 8c 31 c0 c6 05 17 f4 10 01 01 e8 d7 40
[  130.075365] RSP: 0018:ffffa48d00c0b768 EFLAGS: 00010286
[  130.075366] RAX: 0000000000000000 RBX: 0000000000000008 RCX:
0000000000000001
[  130.075366] RDX: 0000000000000001 RSI: 0000000000000096 RDI:
ffff8a2e9fa187d0
[  130.075367] RBP: ffff8a2e93890000 R08: 0000000000000398 R09:
000000000000003c
[  130.075367] R10: 00000000000142a0 R11: 0000000000000397 R12:
ffffa48d00c0b848
[  130.075368] R13: ffff8a2e94746498 R14: ffff8a2e966f7000 R15:
0000000000000031
[  130.075368] FS:  00007f689015f840(0000) GS:ffff8a2e9fa00000(0000)
knlGS:0000000000000000
[  130.075369] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  130.075369] CR2: 00000000006762a0 CR3: 00000007cf164005 CR4:
00000000001606f0
[  130.075370] Call Trace:
[  130.075377]  cxgb4_setup_tc_mqprio+0xbee/0xc30 [cxgb4]
[  130.075382]  ? cxgb4_ethofld_restart+0x50/0x50 [cxgb4]
[  130.075384]  ? pfifo_fast_init+0x7e/0xf0
[  130.075386]  mqprio_init+0x5f4/0x630 [sch_mqprio]
[  130.075389]  qdisc_create+0x1bf/0x4a0
[  130.075390]  tc_modify_qdisc+0x1ff/0x770
[  130.075392]  rtnetlink_rcv_msg+0x28b/0x350
[  130.075394]  ? rtnl_calcit.isra.32+0x110/0x110
[  130.075395]  netlink_rcv_skb+0xc6/0x100
[  130.075396]  netlink_unicast+0x1db/0x330
[  130.075397]  netlink_sendmsg+0x2f5/0x460
[  130.075399]  ? _copy_from_user+0x2e/0x60
[  130.075400]  sock_sendmsg+0x59/0x70
[  130.075401]  ____sys_sendmsg+0x1f0/0x230
[  130.075402]  ? copy_msghdr_from_user+0xd7/0x140
[  130.075403]  ___sys_sendmsg+0x77/0xb0
[  130.075404]  ? ___sys_recvmsg+0x84/0xb0
[  130.075406]  ? __handle_mm_fault+0x377/0xaf0
[  130.075407]  __sys_sendmsg+0x53/0xa0
[  130.075409]  do_syscall_64+0x44/0x130
[  130.075412]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  130.075413] RIP: 0033:0x7f688f13af10
[  130.075414] Code: c3 48 8b 05 82 6f 2c 00 f7 db 64 89 18 48 83 cb ff
eb dd 0f 1f 80 00 00 00 00 83 3d 8d d0 2c 00 00 75 10 b8 2e 00 00 00 0f
05 <48> 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 ae cc 00 00 48 89 04 24
[  130.075414] RSP: 002b:00007ffe6c7d9988 EFLAGS: 00000246 ORIG_RAX:
000000000000002e
[  130.075415] RAX: ffffffffffffffda RBX: 00000000006703a0 RCX:
00007f688f13af10
[  130.075415] RDX: 0000000000000000 RSI: 00007ffe6c7d99f0 RDI:
0000000000000003
[  130.075416] RBP: 000000005df38312 R08: 0000000000000002 R09:
0000000000008000
[  130.075416] R10: 00007ffe6c7d93e0 R11: 0000000000000246 R12:
0000000000000000
[  130.075417] R13: 00007ffe6c7e9c50 R14: 0000000000000001 R15:
000000000067c600
[  130.075418] ---[ end trace 8fbb3bf36a8671db ]---

v2:
- Move the refcount_set() closer to where the hardware queue arrays
  are being allocated.
- Fix up error path to only free hardware queue arrays when refcount
  reaches 0.

Fixes: 2d0cb84dd973 ("cxgb4: add ETHOFLD hardware queue support")
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c
index 477973d2e341..8971dddcdb7a 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c
@@ -145,6 +145,10 @@ static int cxgb4_mqprio_alloc_hw_resources(struct net_device *dev)
 			kfree(adap->sge.eohw_rxq);
 			return -ENOMEM;
 		}
+
+		refcount_set(&adap->tc_mqprio->refcnt, 1);
+	} else {
+		refcount_inc(&adap->tc_mqprio->refcnt);
 	}
 
 	if (!(adap->flags & CXGB4_USING_MSIX))
@@ -205,7 +209,6 @@ static int cxgb4_mqprio_alloc_hw_resources(struct net_device *dev)
 			cxgb4_enable_rx(adap, &eorxq->rspq);
 	}
 
-	refcount_inc(&adap->tc_mqprio->refcnt);
 	return 0;
 
 out_free_msix:
@@ -234,9 +237,10 @@ static int cxgb4_mqprio_alloc_hw_resources(struct net_device *dev)
 		t4_sge_free_ethofld_txq(adap, eotxq);
 	}
 
-	kfree(adap->sge.eohw_txq);
-	kfree(adap->sge.eohw_rxq);
-
+	if (refcount_dec_and_test(&adap->tc_mqprio->refcnt)) {
+		kfree(adap->sge.eohw_txq);
+		kfree(adap->sge.eohw_rxq);
+	}
 	return ret;
 }
 
-- 
2.24.0


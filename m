Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1F4E62D637
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 10:15:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239646AbiKQJPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 04:15:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234680AbiKQJPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 04:15:17 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36B585CD0A
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 01:15:15 -0800 (PST)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NCZ4X33BmzRpG4;
        Thu, 17 Nov 2022 17:14:52 +0800 (CST)
Received: from huawei.com (10.67.175.31) by dggpemm500024.china.huawei.com
 (7.185.36.203) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 17 Nov
 2022 17:15:13 +0800
From:   GUO Zihua <guozihua@huawei.com>
To:     <ericvh@gmail.com>, <lucho@ionkov.net>, <asmadeus@codewreck.org>,
        <linux_oss@crudebyte.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <v9fs-developer@lists.sourceforge.net>,
        <netdev@vger.kernel.org>
Subject: [PATCH 1/3 v2] 9p: Fix write overflow in p9_read_work
Date:   Thu, 17 Nov 2022 17:11:57 +0800
Message-ID: <20221117091159.31533-2-guozihua@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221117091159.31533-1-guozihua@huawei.com>
References: <20221117091159.31533-1-guozihua@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.175.31]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500024.china.huawei.com (7.185.36.203)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This error was reported while fuzzing:

BUG: KASAN: slab-out-of-bounds in _copy_to_iter+0xd35/0x1190
Write of size 4043 at addr ffff888008724eb1 by task kworker/1:1/24

CPU: 1 PID: 24 Comm: kworker/1:1 Not tainted 6.1.0-rc5-00002-g1adf73218daa-dirty #223
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.15.0-0-g2dd4b9b3f840-prebuilt.qemu.org 04/01/2014
Workqueue: events p9_read_work
Call Trace:
 <TASK>
 dump_stack_lvl+0x4c/0x64
 print_report+0x178/0x4b0
 kasan_report+0xae/0x130
 kasan_check_range+0x179/0x1e0
 memcpy+0x38/0x60
 _copy_to_iter+0xd35/0x1190
 copy_page_to_iter+0x1d5/0xb00
 pipe_read+0x3a1/0xd90
 __kernel_read+0x2a5/0x760
 kernel_read+0x47/0x60
 p9_read_work+0x463/0x780
 process_one_work+0x91d/0x1300
 worker_thread+0x8c/0x1210
 kthread+0x280/0x330
 ret_from_fork+0x22/0x30
 </TASK>

Allocated by task 457:
 kasan_save_stack+0x1c/0x40
 kasan_set_track+0x21/0x30
 __kasan_kmalloc+0x7e/0x90
 __kmalloc+0x59/0x140
 p9_fcall_init.isra.11+0x5d/0x1c0
 p9_tag_alloc+0x251/0x550
 p9_client_prepare_req+0x162/0x350
 p9_client_rpc+0x18d/0xa90
 p9_client_create+0x670/0x14e0
 v9fs_session_init+0x1fd/0x14f0
 v9fs_mount+0xd7/0xaf0
 legacy_get_tree+0xf3/0x1f0
 vfs_get_tree+0x86/0x2c0
 path_mount+0x885/0x1940
 do_mount+0xec/0x100
 __x64_sys_mount+0x1a0/0x1e0
 do_syscall_64+0x3a/0x90
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

This BUG pops up when trying to reproduce
https://syzkaller.appspot.com/bug?id=6c7cd46c7bdd0e86f95d26ec3153208ad186f9fa.
The callstack is different but the issue is valid and re-producable with
the same re-producer in the link.

The root cause of this issue is that we check the size of the message
received against the msize of the client in p9_read_work. However, it
turns out that capacity is no longer consistent with msize. Thus,
the message size should also be checked against sdata capacity.

Reported-by: syzbot+0f89bd13eaceccc0e126@syzkaller.appspotmail.com
Fixes: 60ece0833b6c ("net/9p: allocate appropriate reduced message buffers")
Signed-off-by: GUO Zihua <guozihua@huawei.com>
---
 net/9p/trans_fd.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index 56a186768750..30f37bf7c598 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -342,6 +342,14 @@ static void p9_read_work(struct work_struct *work)
 			goto error;
 		}
 
+		if (m->rc.size > m->rreq->rc.capacity - m->rc.offset) {
+			p9_debug(P9_DEBUG_ERROR,
+				 "requested packet size too big: %d for tag %d with capacity %zd\n",
+				 m->rc.size, m->rc.tag, m->rreq->rc.capacity);
+			err = -EIO;
+			goto error;
+		}
+
 		if (!m->rreq->rc.sdata) {
 			p9_debug(P9_DEBUG_ERROR,
 				 "No recv fcall for tag %d (req %p), disconnecting!\n",
-- 
2.17.1


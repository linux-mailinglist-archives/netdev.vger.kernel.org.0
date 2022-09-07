Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA745AF950
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 03:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbiIGBHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 21:07:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiIGBHd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 21:07:33 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 587CD86FD0
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 18:07:31 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MMkXY4NGDz1P7GN;
        Wed,  7 Sep 2022 09:03:41 +0800 (CST)
Received: from huawei.com (10.175.101.6) by canpemm500010.china.huawei.com
 (7.192.105.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 7 Sep
 2022 09:07:28 +0800
From:   Liu Jian <liujian56@huawei.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <hawk@kernel.org>, <john.fastabend@gmail.com>,
        <netdev@vger.kernel.org>
CC:     <liujian56@huawei.com>
Subject: [PATCH net] tun: Check tun device queue status in tun_chr_write_iter
Date:   Wed, 7 Sep 2022 09:09:42 +0800
Message-ID: <20220907010942.10096-1-liujian56@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot found below warning:

------------[ cut here ]------------
geneve0 received packet on queue 3, but number of RX queues is 3
WARNING: CPU: 1 PID: 29734 at net/core/dev.c:4611 netif_get_rxqueue net/core/dev.c:4611 [inline]
WARNING: CPU: 1 PID: 29734 at net/core/dev.c:4611 netif_receive_generic_xdp+0xb10/0xb50 net/core/dev.c:4683
Modules linked in:
CPU: 1 PID: 29734 Comm: syz-executor.0 Not tainted 5.10.0 #5
Hardware name: linux,dummy-virt (DT)
pstate: 60400005 (nZCv daif +PAN -UAO -TCO BTYPE=--)
pc : netif_get_rxqueue net/core/dev.c:4611 [inline]
pc : netif_receive_generic_xdp+0xb10/0xb50 net/core/dev.c:4683
lr : netif_get_rxqueue net/core/dev.c:4611 [inline]
lr : netif_receive_generic_xdp+0xb10/0xb50 net/core/dev.c:4683
sp : ffffa00016127770
x29: ffffa00016127770 x28: ffff3f4607d6acb4
x27: ffff3f4607d6acb0 x26: ffff3f4607d6ad20
x25: ffff3f461de3c000 x24: ffff3f4607d6ad28
x23: ffffa00010059000 x22: ffff3f4608719100
x21: 0000000000000003 x20: ffffa000161278a0
x19: ffff3f4607d6ac40 x18: 0000000000000000
x17: 0000000000000000 x16: 00000000f2f2f204
x15: 00000000f2f20000 x14: 6465766965636572
x13: 20306576656e6567 x12: ffff98b8ed3b924d
x11: 1ffff8b8ed3b924c x10: ffff98b8ed3b924c
x9 : ffffc5c76525c9c4 x8 : 0000000000000000
x7 : 0000000000000001 x6 : ffff98b8ed3b924c
x5 : ffff3f460f3b29c0 x4 : dfffa00000000000
x3 : ffffc5c765000000 x2 : 0000000000000000
x1 : 0000000000000000 x0 : ffff3f460f3b29c0
Call trace:
 netif_get_rxqueue net/core/dev.c:4611 [inline]
 netif_receive_generic_xdp+0xb10/0xb50 net/core/dev.c:4683
 do_xdp_generic net/core/dev.c:4777 [inline]
 do_xdp_generic+0x9c/0x190 net/core/dev.c:4770
 tun_get_user+0xd94/0x2010 drivers/net/tun.c:1938
 tun_chr_write_iter+0x98/0x100 drivers/net/tun.c:2036
 call_write_iter include/linux/fs.h:1960 [inline]
 new_sync_write+0x260/0x370 fs/read_write.c:515
 vfs_write+0x51c/0x61c fs/read_write.c:602
 ksys_write+0xfc/0x200 fs/read_write.c:655
 __do_sys_write fs/read_write.c:667 [inline]
 __se_sys_write fs/read_write.c:664 [inline]
 __arm64_sys_write+0x50/0x60 fs/read_write.c:664
 __invoke_syscall arch/arm64/kernel/syscall.c:36 [inline]
 invoke_syscall arch/arm64/kernel/syscall.c:48 [inline]
 el0_svc_common.constprop.0+0xf4/0x414 arch/arm64/kernel/syscall.c:155
 do_el0_svc+0x50/0x11c arch/arm64/kernel/syscall.c:217
 el0_svc+0x20/0x30 arch/arm64/kernel/entry-common.c:353
 el0_sync_handler+0xe4/0x1e0 arch/arm64/kernel/entry-common.c:369
 el0_sync+0x148/0x180 arch/arm64/kernel/entry.S:683

This is because the detached queue is used to send data. Therefore, we need
to check the queue status in the tun_chr_write_iter function.

Signed-off-by: Liu Jian <liujian56@huawei.com>
---
 drivers/net/tun.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 259b2b84b2b3..261411c1a6bb 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2019,6 +2019,11 @@ static ssize_t tun_chr_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	if (!tun)
 		return -EBADFD;
 
+	if (tfile->detached) {
+		tun_put(tun);
+		return -ENETDOWN;
+	}
+
 	if ((file->f_flags & O_NONBLOCK) || (iocb->ki_flags & IOCB_NOWAIT))
 		noblock = 1;
 
-- 
2.17.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3955410576
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 11:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238227AbhIRJak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Sep 2021 05:30:40 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:19992 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232716AbhIRJak (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Sep 2021 05:30:40 -0400
Received: from dggeml757-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HBQQV3K06zbmXh;
        Sat, 18 Sep 2021 17:25:06 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 dggeml757-chm.china.huawei.com (10.1.199.137) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Sat, 18 Sep 2021 17:29:14 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <socketcan@hartkopp.net>
CC:     <mkl@pengutronix.de>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH net] can: isotp: add result check for wait_event_interruptible()
Date:   Sat, 18 Sep 2021 17:28:19 +0800
Message-ID: <20210918092819.156291-1-william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggeml757-chm.china.huawei.com (10.1.199.137)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using wait_event_interruptible() to wait for complete transmission,
but do not check the result of wait_event_interruptible() which can
be interrupted. It will result in tx buffer has multiple accessers
and the later process interferes with the previous process.

Following is one of the problems reported by syzbot.

=============================================================
WARNING: CPU: 0 PID: 0 at net/can/isotp.c:840 isotp_tx_timer_handler+0x2e0/0x4c0
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.13.0-rc7+ #68
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1 04/01/2014
RIP: 0010:isotp_tx_timer_handler+0x2e0/0x4c0
Call Trace:
 <IRQ>
 ? isotp_setsockopt+0x390/0x390
 __hrtimer_run_queues+0xb8/0x610
 hrtimer_run_softirq+0x91/0xd0
 ? rcu_read_lock_sched_held+0x4d/0x80
 __do_softirq+0xe8/0x553
 irq_exit_rcu+0xf8/0x100
 sysvec_apic_timer_interrupt+0x9e/0xc0
 </IRQ>
 asm_sysvec_apic_timer_interrupt+0x12/0x20

Add result check for wait_event_interruptible() in isotp_sendmsg()
to avoid multiple accessers for tx buffer.

Reported-by: syzbot+78bab6958a614b0c80b9@syzkaller.appspotmail.com
Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---
 net/can/isotp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index caaa532ece94..2ac29c2b2ca6 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -865,7 +865,9 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 			return -EAGAIN;
 
 		/* wait for complete transmission of current pdu */
-		wait_event_interruptible(so->wait, so->tx.state == ISOTP_IDLE);
+		err = wait_event_interruptible(so->wait, so->tx.state == ISOTP_IDLE);
+		if (err)
+			return err;
 	}
 
 	if (!size || size > MAX_MSG_LENGTH)
-- 
2.25.1


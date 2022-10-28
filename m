Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC4A6611706
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 18:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbiJ1QHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 12:07:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231131AbiJ1QGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 12:06:51 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C8091DE3EA;
        Fri, 28 Oct 2022 09:06:07 -0700 (PDT)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MzS3r3wbxzpW9k;
        Sat, 29 Oct 2022 00:02:16 +0800 (CST)
Received: from kwepemm600014.china.huawei.com (7.193.23.54) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 29 Oct 2022 00:05:44 +0800
Received: from huawei.com (10.90.53.225) by kwepemm600014.china.huawei.com
 (7.193.23.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sat, 29 Oct
 2022 00:05:44 +0800
From:   Zhang Qilong <zhangqilong3@huawei.com>
To:     <ralf@linux-mips.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <f6bvp@free.fr>
CC:     <linux-hams@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH] rose: Fix NULL pointer dereference in rose_send_frame()
Date:   Sat, 29 Oct 2022 00:10:49 +0800
Message-ID: <20221028161049.113625-1-zhangqilong3@huawei.com>
X-Mailer: git-send-email 2.26.0.106.g9fadedd
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.90.53.225]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600014.china.huawei.com (7.193.23.54)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The syzkaller reported an issue:

KASAN: null-ptr-deref in range [0x0000000000000380-0x0000000000000387]
CPU: 0 PID: 4069 Comm: kworker/0:15 Not tainted 6.0.0-syzkaller-02734-g0326074ff465 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/22/2022
Workqueue: rcu_gp srcu_invoke_callbacks
RIP: 0010:rose_send_frame+0x1dd/0x2f0 net/rose/rose_link.c:101
Call Trace:
 <IRQ>
 rose_transmit_clear_request+0x1d5/0x290 net/rose/rose_link.c:255
 rose_rx_call_request+0x4c0/0x1bc0 net/rose/af_rose.c:1009
 rose_loopback_timer+0x19e/0x590 net/rose/rose_loopback.c:111
 call_timer_fn+0x1a0/0x6b0 kernel/time/timer.c:1474
 expire_timers kernel/time/timer.c:1519 [inline]
 __run_timers.part.0+0x674/0xa80 kernel/time/timer.c:1790
 __run_timers kernel/time/timer.c:1768 [inline]
 run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1803
 __do_softirq+0x1d0/0x9c8 kernel/softirq.c:571
 [...]
 </IRQ>

It triggers NULL pointer dereference when 'neigh->dev->dev_addr' is
called in the rose_send_frame(). It's the first occurrence of the
`neigh` is in rose_loopback_timer() as `rose_loopback_neigh', and
the 'dev' in 'rose_loopback_neigh' is initialized sa nullptr.

It had been fixed by commit 3b3fd068c56e3fbea30090859216a368398e39bf
("rose: Fix Null pointer dereference in rose_send_frame()") ever.
But it's introduced by commit 3c53cd65dece47dd1f9d3a809f32e59d1d87b2b8
("rose: check NULL rose_loopback_neigh->loopback") again.

We fix it by add NULL check in rose_transmit_clear_request(). When
the 'dev' in 'neigh' is NULL, we don't reply the request and just
clear it.

syzkaller don't provide repro, and I provide a syz repro like:
r0 = syz_init_net_socket$bt_sco(0x1f, 0x5, 0x2)
ioctl$sock_inet_SIOCSIFFLAGS(r0, 0x8914, &(0x7f0000000180)={'rose0\x00', 0x201})
r1 = syz_init_net_socket$rose(0xb, 0x5, 0x0)
bind$rose(r1, &(0x7f00000000c0)=@full={0xb, @dev, @null, 0x0, [@null, @null, @netrom, @netrom, @default, @null]}, 0x40)
connect$rose(r1, &(0x7f0000000240)=@short={0xb, @dev={0xbb, 0xbb, 0xbb, 0x1, 0x0}, @remote={0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0xcc, 0x1}, 0x1, @netrom={0xbb, 0xbb, 0xbb, 0xbb, 0xbb, 0x0, 0x0}}, 0x1c)

Fixes: 3c53cd65dece ("rose: check NULL rose_loopback_neigh->loopback")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
---
 net/rose/rose_link.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/rose/rose_link.c b/net/rose/rose_link.c
index 8b96a56d3a49..0f77ae8ef944 100644
--- a/net/rose/rose_link.c
+++ b/net/rose/rose_link.c
@@ -236,6 +236,9 @@ void rose_transmit_clear_request(struct rose_neigh *neigh, unsigned int lci, uns
 	unsigned char *dptr;
 	int len;
 
+	if (!neigh->dev)
+		return;
+
 	len = AX25_BPQ_HEADER_LEN + AX25_MAX_HEADER_LEN + ROSE_MIN_LEN + 3;
 
 	if ((skb = alloc_skb(len, GFP_ATOMIC)) == NULL)
-- 
2.25.1


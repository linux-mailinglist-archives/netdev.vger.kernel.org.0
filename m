Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38850626934
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 12:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233714AbiKLLg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 06:36:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234957AbiKLLgr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 06:36:47 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AA3925EBC;
        Sat, 12 Nov 2022 03:36:39 -0800 (PST)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4N8YRm6Wb0zHvZX;
        Sat, 12 Nov 2022 19:36:04 +0800 (CST)
Received: from kwepemm600001.china.huawei.com (7.193.23.3) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 12 Nov 2022 19:36:19 +0800
Received: from huawei.com (10.175.113.133) by kwepemm600001.china.huawei.com
 (7.193.23.3) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sat, 12 Nov
 2022 19:36:18 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <cong.wang@bytedance.com>,
        <f.fainelli@gmail.com>, <tom@herbertland.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH net] kcm: Fix kernel NULL pointer dereference in requeue_rx_msgs
Date:   Sat, 12 Nov 2022 20:04:23 +0800
Message-ID: <20221112120423.56132-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600001.china.huawei.com (7.193.23.3)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In kcm_rcv_strparser(), the skb is queued to the kcm that is currently
being reserved, and if the queue is full, unreserve_rx_kcm() will be
called. At this point, if KCM_RECV_DISABLE is set, then unreserve_rx_kcm()
will requeue received messages for the current kcm socket to other kcm
sockets. The kcm sock lock is not held during this time, and as long as
someone calls kcm_recvmsg, it will concurrently unlink the same skb, which
ill result in a null pointer reference.

cpu0 			cpu1		        cpu2
kcm_rcv_strparser
 reserve_rx_kcm
                        kcm_setsockopt
                         kcm_recv_disable
                          kcm->rx_disabled = 1;
  kcm_queue_rcv_skb
  unreserve_rx_kcm
   requeue_rx_msgs                              kcm_recvmsg
    __skb_dequeue
     __skb_unlink(skb)				  skb_unlink(skb)
                                                  //double unlink skb

There is no need to re-queue the received msg to other kcm when unreserve
kcm. Remove it.

The following is the error log:

BUG: kernel NULL pointer dereference, address: 0000000000000008
...
RIP: 0010:skb_unlink+0x40/0x50
...
Call Trace:
 kcm_recvmsg+0x143/0x180
 ____sys_recvmsg+0x16a/0x180
 ___sys_recvmsg+0x80/0xc0
 do_recvmmsg+0xc2/0x2a0
 __sys_recvmmsg+0x10c/0x160
 __x64_sys_recvmmsg+0x25/0x40
 do_syscall_64+0x3b/0x90
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Fixes: ab7ac4eb9832 ("kcm: Kernel Connection Multiplexor module")
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 net/kcm/kcmsock.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index a5004228111d..691d40364b8f 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -333,9 +333,8 @@ static void unreserve_rx_kcm(struct kcm_psock *psock,
 		return;
 	}
 
-	if (unlikely(kcm->rx_disabled)) {
-		requeue_rx_msgs(mux, &kcm->sk.sk_receive_queue);
-	} else if (rcv_ready || unlikely(!sk_rmem_alloc_get(&kcm->sk))) {
+	if (likely(!kcm->rx_disabled) &&
+	    (rcv_ready || unlikely(!sk_rmem_alloc_get(&kcm->sk)))) {
 		/* Check for degenerative race with rx_wait that all
 		 * data was dequeued (accounted for in kcm_rfree).
 		 */
-- 
2.17.1


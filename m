Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D94F4CCF58
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 08:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239017AbiCDHyt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 02:54:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239002AbiCDHyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 02:54:44 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 366B0194162;
        Thu,  3 Mar 2022 23:53:57 -0800 (PST)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4K90Nm68x9z1GCD1;
        Fri,  4 Mar 2022 15:49:12 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 4 Mar 2022 15:53:54 +0800
From:   Wang Yufen <wangyufen@huawei.com>
To:     <john.fastabend@gmail.com>, <daniel@iogearbox.net>,
        <jakub@cloudflare.com>, <lmb@cloudflare.com>,
        <davem@davemloft.net>, <bpf@vger.kernel.org>
CC:     <edumazet@google.com>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <kuba@kernel.org>, <ast@kernel.org>,
        <andrii@kernel.org>, <kafai@fb.com>, <songliubraving@fb.com>,
        <yhs@fb.com>, <kpsingh@kernel.org>, <netdev@vger.kernel.org>,
        Wang Yufen <wangyufen@huawei.com>
Subject: [PATCH bpf-next v3 1/4] bpf, sockmap: Fix memleak in sk_psock_queue_msg
Date:   Fri, 4 Mar 2022 16:11:42 +0800
Message-ID: <20220304081145.2037182-2-wangyufen@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220304081145.2037182-1-wangyufen@huawei.com>
References: <20220304081145.2037182-1-wangyufen@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If tcp_bpf_sendmsg is running during a tear down operation we may enqueue
data on the ingress msg queue while tear down is trying to free it.

 sk1 (redirect sk2)                         sk2
 -------------------                      ---------------
tcp_bpf_sendmsg()
 tcp_bpf_send_verdict()
  tcp_bpf_sendmsg_redir()
   bpf_tcp_ingress()
                                          sock_map_close()
                                           lock_sock()
    lock_sock() ... blocking
                                           sk_psock_stop
                                            sk_psock_clear_state(psock, SK_PSOCK_TX_ENABLED);
                                           release_sock(sk);
    lock_sock()
    sk_mem_charge()
    get_page()
    sk_psock_queue_msg()
     sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED);
      drop_sk_msg()
    release_sock()

While drop_sk_msg(), the msg has charged memory form sk by sk_mem_charge
and has sg pages need to put. To fix we use sk_msg_free() and then kfee()
msg.

This issue can cause the following info:
WARNING: CPU: 0 PID: 9202 at net/core/stream.c:205 sk_stream_kill_queues+0xc8/0xe0
Call Trace:
 <IRQ>
 inet_csk_destroy_sock+0x55/0x110
 tcp_rcv_state_process+0xe5f/0xe90
 ? sk_filter_trim_cap+0x10d/0x230
 ? tcp_v4_do_rcv+0x161/0x250
 tcp_v4_do_rcv+0x161/0x250
 tcp_v4_rcv+0xc3a/0xce0
 ip_protocol_deliver_rcu+0x3d/0x230
 ip_local_deliver_finish+0x54/0x60
 ip_local_deliver+0xfd/0x110
 ? ip_protocol_deliver_rcu+0x230/0x230
 ip_rcv+0xd6/0x100
 ? ip_local_deliver+0x110/0x110
 __netif_receive_skb_one_core+0x85/0xa0
 process_backlog+0xa4/0x160
 __napi_poll+0x29/0x1b0
 net_rx_action+0x287/0x300
 __do_softirq+0xff/0x2fc
 do_softirq+0x79/0x90
 </IRQ>

WARNING: CPU: 0 PID: 531 at net/ipv4/af_inet.c:154 inet_sock_destruct+0x175/0x1b0
Call Trace:
 <TASK>
 __sk_destruct+0x24/0x1f0
 sk_psock_destroy+0x19b/0x1c0
 process_one_work+0x1b3/0x3c0
 ? process_one_work+0x3c0/0x3c0
 worker_thread+0x30/0x350
 ? process_one_work+0x3c0/0x3c0
 kthread+0xe6/0x110
 ? kthread_complete_and_exit+0x20/0x20
 ret_from_fork+0x22/0x30
 </TASK>

Fixes: 9635720b7c88 ("bpf, sockmap: Fix memleak on ingress msg enqueue")
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
---
 include/linux/skmsg.h | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index fdb5375f0562..c5a2d6f50f25 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -304,21 +304,16 @@ static inline void sock_drop(struct sock *sk, struct sk_buff *skb)
 	kfree_skb(skb);
 }
 
-static inline void drop_sk_msg(struct sk_psock *psock, struct sk_msg *msg)
-{
-	if (msg->skb)
-		sock_drop(psock->sk, msg->skb);
-	kfree(msg);
-}
-
 static inline void sk_psock_queue_msg(struct sk_psock *psock,
 				      struct sk_msg *msg)
 {
 	spin_lock_bh(&psock->ingress_lock);
 	if (sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED))
 		list_add_tail(&msg->list, &psock->ingress_msg);
-	else
-		drop_sk_msg(psock, msg);
+	else {
+		sk_msg_free(psock->sk, msg);
+		kfree(msg);
+	}
 	spin_unlock_bh(&psock->ingress_lock);
 }
 
-- 
2.25.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5B074CCF5A
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 08:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239018AbiCDHyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 02:54:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239005AbiCDHyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 02:54:46 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7AC1194A8B;
        Thu,  3 Mar 2022 23:53:57 -0800 (PST)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4K90Sj436gzdb0G;
        Fri,  4 Mar 2022 15:52:37 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 4 Mar 2022 15:53:55 +0800
From:   Wang Yufen <wangyufen@huawei.com>
To:     <john.fastabend@gmail.com>, <daniel@iogearbox.net>,
        <jakub@cloudflare.com>, <lmb@cloudflare.com>,
        <davem@davemloft.net>, <bpf@vger.kernel.org>
CC:     <edumazet@google.com>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <kuba@kernel.org>, <ast@kernel.org>,
        <andrii@kernel.org>, <kafai@fb.com>, <songliubraving@fb.com>,
        <yhs@fb.com>, <kpsingh@kernel.org>, <netdev@vger.kernel.org>,
        Wang Yufen <wangyufen@huawei.com>
Subject: [PATCH bpf-next v3 2/4] bpf, sockmap: Fix memleak in tcp_bpf_sendmsg while sk msg is full
Date:   Fri, 4 Mar 2022 16:11:43 +0800
Message-ID: <20220304081145.2037182-3-wangyufen@huawei.com>
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

If tcp_bpf_sendmsg() is running while sk msg is full. When sk_msg_alloc()
returns -ENOMEM error, tcp_bpf_sendmsg() goes to wait_for_memory. If partial
memory has been alloced by sk_msg_alloc(), that is, msg_tx->sg.size is
greater than osize after sk_msg_alloc(), memleak occurs. To fix we use
sk_msg_trim() to release the allocated memory, then goto wait for memory.

Other call paths of sk_msg_alloc() have the similar issue, such as
tls_sw_sendmsg(), so handle sk_msg_trim logic inside sk_msg_alloc(),
as Cong Wang suggested.

This issue can cause the following info:
WARNING: CPU: 3 PID: 7950 at net/core/stream.c:208 sk_stream_kill_queues+0xd4/0x1a0
Call Trace:
 <TASK>
 inet_csk_destroy_sock+0x55/0x110
 __tcp_close+0x279/0x470
 tcp_close+0x1f/0x60
 inet_release+0x3f/0x80
 __sock_release+0x3d/0xb0
 sock_close+0x11/0x20
 __fput+0x92/0x250
 task_work_run+0x6a/0xa0
 do_exit+0x33b/0xb60
 do_group_exit+0x2f/0xa0
 get_signal+0xb6/0x950
 arch_do_signal_or_restart+0xac/0x2a0
 exit_to_user_mode_prepare+0xa9/0x200
 syscall_exit_to_user_mode+0x12/0x30
 do_syscall_64+0x46/0x80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
 </TASK>

WARNING: CPU: 3 PID: 2094 at net/ipv4/af_inet.c:155 inet_sock_destruct+0x13c/0x260
Call Trace:
 <TASK>
 __sk_destruct+0x24/0x1f0
 sk_psock_destroy+0x19b/0x1c0
 process_one_work+0x1b3/0x3c0
 kthread+0xe6/0x110
 ret_from_fork+0x22/0x30
 </TASK>

Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/skmsg.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 8eb671c827f9..38ee73f453f8 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -27,6 +27,7 @@ int sk_msg_alloc(struct sock *sk, struct sk_msg *msg, int len,
 		 int elem_first_coalesce)
 {
 	struct page_frag *pfrag = sk_page_frag(sk);
+	u32 osize = msg->sg.size;
 	int ret = 0;
 
 	len -= msg->sg.size;
@@ -35,13 +36,17 @@ int sk_msg_alloc(struct sock *sk, struct sk_msg *msg, int len,
 		u32 orig_offset;
 		int use, i;
 
-		if (!sk_page_frag_refill(sk, pfrag))
-			return -ENOMEM;
+		if (!sk_page_frag_refill(sk, pfrag)) {
+			ret = -ENOMEM;
+			goto msg_trim;
+		}
 
 		orig_offset = pfrag->offset;
 		use = min_t(int, len, pfrag->size - orig_offset);
-		if (!sk_wmem_schedule(sk, use))
-			return -ENOMEM;
+		if (!sk_wmem_schedule(sk, use)) {
+			ret = -ENOMEM;
+			goto msg_trim;
+		}
 
 		i = msg->sg.end;
 		sk_msg_iter_var_prev(i);
@@ -71,6 +76,10 @@ int sk_msg_alloc(struct sock *sk, struct sk_msg *msg, int len,
 	}
 
 	return ret;
+
+msg_trim:
+	sk_msg_trim(sk, msg, osize);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(sk_msg_alloc);
 
-- 
2.25.1


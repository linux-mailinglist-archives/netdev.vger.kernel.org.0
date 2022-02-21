Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6ADA4BE5C3
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 19:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344755AbiBUKvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 05:51:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355798AbiBUKvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 05:51:17 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 077D857B2F;
        Mon, 21 Feb 2022 02:13:18 -0800 (PST)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4K2J0r0C46zbbc8;
        Mon, 21 Feb 2022 18:08:44 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 21 Feb 2022 18:13:11 +0800
From:   Wang Yufen <wangyufen@huawei.com>
To:     <john.fastabend@gmail.com>, <daniel@iogearbox.net>,
        <jakub@cloudflare.com>, <lmb@cloudflare.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <kuba@kernel.org>,
        <ast@kernel.org>, <andrii@kernel.org>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <kpsingh@kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        Wang Yufen <wangyufen@huawei.com>
Subject: [PATCH net-next 2/4] bpf, sockmap: Fix memleak in tcp_bpf_sendmsg while sk msg is full
Date:   Mon, 21 Feb 2022 18:31:03 +0800
Message-ID: <20220221103105.4028557-3-wangyufen@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220221103105.4028557-1-wangyufen@huawei.com>
References: <20220221103105.4028557-1-wangyufen@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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

If tcp_bpf_sendmsg() is running while sk msg is full, sk_msg_alloc()
returns -ENOSPC, tcp_bpf_sendmsg() goto wait for memory. If partial memory
has been alloced by sk_msg_alloc(), that is, msg_tx->sg.size is greater
than osize after sk_msg_alloc(), memleak occurs. To fix we use
sk_msg_trim() to release the allocated memory, then goto wait for memory.

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
---
 net/ipv4/tcp_bpf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 9b9b02052fd3..ac9f491cc139 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -421,8 +421,10 @@ static int tcp_bpf_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 		osize = msg_tx->sg.size;
 		err = sk_msg_alloc(sk, msg_tx, msg_tx->sg.size + copy, msg_tx->sg.end - 1);
 		if (err) {
-			if (err != -ENOSPC)
+			if (err != -ENOSPC) {
+				sk_msg_trim(sk, msg_tx, osize);
 				goto wait_for_memory;
+			}
 			enospc = true;
 			copy = msg_tx->sg.size - osize;
 		}
-- 
2.25.1


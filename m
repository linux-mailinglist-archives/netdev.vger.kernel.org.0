Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0DA611E0F
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 01:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbiJ1XYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 19:24:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiJ1XYA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 19:24:00 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4612C248C85;
        Fri, 28 Oct 2022 16:23:58 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MzdnR71c3zpW8L;
        Sat, 29 Oct 2022 07:20:27 +0800 (CST)
Received: from localhost.localdomain (10.175.112.70) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 29 Oct 2022 07:23:56 +0800
From:   Wang Yufen <wangyufen@huawei.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <john.fastabend@gmail.com>, <jakub@cloudflare.com>
Subject: [PATCH net v2] bpf, sockmap: fix the sk->sk_forward_alloc warning of sk_stream_kill_queues()
Date:   Sat, 29 Oct 2022 07:44:34 +0800
Message-ID: <1667000674-13237-1-git-send-email-wangyufen@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When running `test_sockmap` selftests, got the following warning:

WARNING: CPU: 2 PID: 197 at net/core/stream.c:205 sk_stream_kill_queues+0xd3/0xf0
Call Trace:
  <TASK>
  inet_csk_destroy_sock+0x55/0x110
  tcp_rcv_state_process+0xd28/0x1380
  ? tcp_v4_do_rcv+0x77/0x2c0
  tcp_v4_do_rcv+0x77/0x2c0
  __release_sock+0x106/0x130
  __tcp_close+0x1a7/0x4e0
  tcp_close+0x20/0x70
  inet_release+0x3c/0x80
  __sock_release+0x3a/0xb0
  sock_close+0x14/0x20
  __fput+0xa3/0x260
  task_work_run+0x59/0xb0
  exit_to_user_mode_prepare+0x1b3/0x1c0
  syscall_exit_to_user_mode+0x19/0x50
  do_syscall_64+0x48/0x90
  entry_SYSCALL_64_after_hwframe+0x44/0xae

The root case is: In commit 84472b436e76 ("bpf, sockmap: Fix more
uncharged while msg has more_data") , I used msg->sg.size replace
tosend rudely, which break the
   if (msg->apply_bytes && msg->apply_bytes < send)
scene.

Fixes: 84472b436e76 ("bpf, sockmap: Fix more uncharged while msg has more_data")
Reported-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
---
v1 -> v2: typo fixup
 net/ipv4/tcp_bpf.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index a1626af..774d481 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -278,7 +278,7 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
 {
 	bool cork = false, enospc = sk_msg_full(msg);
 	struct sock *sk_redir;
-	u32 tosend, delta = 0;
+	u32 tosend, orgsize, sent, delta = 0;
 	u32 eval = __SK_NONE;
 	int ret;
 
@@ -333,10 +333,12 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
 			cork = true;
 			psock->cork = NULL;
 		}
-		sk_msg_return(sk, msg, msg->sg.size);
+		sk_msg_return(sk, msg, tosend);
 		release_sock(sk);
 
+		orgsize = msg->sg.size;
 		ret = tcp_bpf_sendmsg_redir(sk_redir, msg, tosend, flags);
+		sent = orgsize - msg->sg.size;
 
 		if (eval == __SK_REDIRECT)
 			sock_put(sk_redir);
@@ -375,7 +377,7 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
 		    msg->sg.data[msg->sg.start].page_link &&
 		    msg->sg.data[msg->sg.start].length) {
 			if (eval == __SK_REDIRECT)
-				sk_mem_charge(sk, msg->sg.size);
+				sk_mem_charge(sk, tosend - sent);
 			goto more_data;
 		}
 	}
-- 
1.8.3.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A477429D00
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 07:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232396AbhJLFTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 01:19:05 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:13722 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231254AbhJLFTF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 01:19:05 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HT3lK71QFzWdJL;
        Tue, 12 Oct 2021 13:15:25 +0800 (CST)
Received: from dggema772-chm.china.huawei.com (10.1.198.214) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2308.8; Tue, 12 Oct 2021 13:17:01 +0800
Received: from huawei.com (10.175.101.6) by dggema772-chm.china.huawei.com
 (10.1.198.214) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.8; Tue, 12
 Oct 2021 13:17:00 +0800
From:   Liu Jian <liujian56@huawei.com>
To:     <john.fastabend@gmail.com>, <daniel@iogearbox.net>,
        <jakub@cloudflare.com>, <lmb@cloudflare.com>,
        <edumazet@google.com>, <davem@davemloft.net>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <kuba@kernel.org>,
        <ast@kernel.org>, <andrii@kernel.org>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <kpsingh@kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <liujian56@huawei.com>
Subject: [PATHC bpf v2] tcp_bpf: Fix one concurrency problem in the tcp_bpf_send_verdict function
Date:   Tue, 12 Oct 2021 13:20:19 +0800
Message-ID: <20211012052019.184398-1-liujian56@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggema772-chm.china.huawei.com (10.1.198.214)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With two Msgs, msgA and msgB and a user doing nonblocking sendmsg calls (or
multiple cores) on a single socket 'sk' we could get the following flow.

 msgA, sk                               msgB, sk
 -----------                            ---------------
 tcp_bpf_sendmsg()
 lock(sk)
 psock = sk->psock
                                        tcp_bpf_sendmsg()
                                        lock(sk) ... blocking
tcp_bpf_send_verdict
if (psock->eval == NONE)
   psock->eval = sk_psock_msg_verdict
 ..
 < handle SK_REDIRECT case >
   release_sock(sk)                     < lock dropped so grab here >
   ret = tcp_bpf_sendmsg_redir
                                        psock = sk->psock
                                        tcp_bpf_send_verdict
 lock_sock(sk) ... blocking on B
                                        if (psock->eval == NONE) <- boom.
                                         psock->eval will have msgA state

The problem here is we dropped the lock on msgA and grabbed it with msgB.
Now we have old state in psock and importantly psock->eval has not been
cleared. So msgB will run whatever action was done on A and the verdict
program may never see it.

Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: Liu Jian <liujian56@huawei.com>
---
v2: change commit message, and add the fixes tag
 net/ipv4/tcp_bpf.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index d3e9386b493e..9d068153c316 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -232,6 +232,7 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
 	bool cork = false, enospc = sk_msg_full(msg);
 	struct sock *sk_redir;
 	u32 tosend, delta = 0;
+	u32 eval = __SK_NONE;
 	int ret;
 
 more_data:
@@ -275,13 +276,24 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
 	case __SK_REDIRECT:
 		sk_redir = psock->sk_redir;
 		sk_msg_apply_bytes(psock, tosend);
+		if (!psock->apply_bytes) {
+			/* Clean up before releasing the sock lock. */
+			eval = psock->eval;
+			psock->eval = __SK_NONE;
+			psock->sk_redir = NULL;
+		}
 		if (psock->cork) {
 			cork = true;
 			psock->cork = NULL;
 		}
 		sk_msg_return(sk, msg, tosend);
 		release_sock(sk);
+
 		ret = tcp_bpf_sendmsg_redir(sk_redir, msg, tosend, flags);
+
+		if (eval == __SK_REDIRECT)
+			sock_put(sk_redir);
+
 		lock_sock(sk);
 		if (unlikely(ret < 0)) {
 			int free = sk_msg_free_nocharge(sk, msg);
-- 
2.17.1


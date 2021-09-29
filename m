Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23AF341C0E7
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 10:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244815AbhI2IrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 04:47:05 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:26967 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244764AbhI2IrE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 04:47:04 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HK8wZ6RpNzbmrv;
        Wed, 29 Sep 2021 16:41:02 +0800 (CST)
Received: from dggema772-chm.china.huawei.com (10.1.198.214) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 16:45:20 +0800
Received: from huawei.com (10.175.101.6) by dggema772-chm.china.huawei.com
 (10.1.198.214) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.8; Wed, 29
 Sep 2021 16:45:17 +0800
From:   Liu Jian <liujian56@huawei.com>
To:     <john.fastabend@gmail.com>, <daniel@iogearbox.net>,
        <jakub@cloudflare.com>, <lmb@cloudflare.com>,
        <edumazet@google.com>, <davem@davemloft.net>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <kuba@kernel.org>,
        <ast@kernel.org>, <andrii@kernel.org>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <kpsingh@kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <liujian56@huawei.com>
Subject: [PATCH] tcp_bpf: Fix one concurrency problem in the tcp_bpf_send_verdict function
Date:   Wed, 29 Sep 2021 16:45:29 +0800
Message-ID: <20210929084529.96583-1-liujian56@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggema772-chm.china.huawei.com (10.1.198.214)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the following cases:
We need to redirect the first msg to sock1 and the second msg to sock2.
The sock lock needs to be released at __SK_REDIRECT and to get another
sock lock, this will cause the probability that psock->eval is not set to
__SK_NONE when the second msg comes.

If psock does not set apple bytes, fix this by do the cleanup before
releasing the sock lock. And keep the original logic in other cases.

Signed-off-by: Liu Jian <liujian56@huawei.com>
---
 net/ipv4/tcp_bpf.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index d3e9386b493e..02442e43ac4d 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -232,6 +232,7 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
 	bool cork = false, enospc = sk_msg_full(msg);
 	struct sock *sk_redir;
 	u32 tosend, delta = 0;
+	u32 eval = __SK_NONE;
 	int ret;
 
 more_data:
@@ -274,6 +275,12 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
 		break;
 	case __SK_REDIRECT:
 		sk_redir = psock->sk_redir;
+		if (!psock->apply_bytes) {
+			/* Clean up before releasing the sock lock. */
+			eval = psock->eval;
+			psock->eval = __SK_NONE;
+			psock->sk_redir = NULL;
+		}
 		sk_msg_apply_bytes(psock, tosend);
 		if (psock->cork) {
 			cork = true;
@@ -281,7 +288,12 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
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


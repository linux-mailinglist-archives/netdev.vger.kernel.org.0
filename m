Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A45863A72A
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 12:25:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbiK1LZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 06:25:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbiK1LZc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 06:25:32 -0500
Received: from zg8tmtyylji0my4xnjeumjiw.icoremail.net (zg8tmtyylji0my4xnjeumjiw.icoremail.net [162.243.161.220])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 9F745EA3;
        Mon, 28 Nov 2022 03:25:29 -0800 (PST)
Received: from 102.wangsu.com (unknown [59.61.78.232])
        by app2 (Coremail) with SMTP id SyJltADXxwySmoRjSUsAAA--.450S4;
        Mon, 28 Nov 2022 19:25:25 +0800 (CST)
From:   Pengcheng Yang <yangpc@wangsu.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Cc:     Pengcheng Yang <yangpc@wangsu.com>
Subject: [PATCH bpf v2 2/4] bpf, sockmap: Fix missing BPF_F_INGRESS flag when using apply_bytes
Date:   Mon, 28 Nov 2022 19:24:43 +0800
Message-Id: <1669634685-1717-3-git-send-email-yangpc@wangsu.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1669634685-1717-1-git-send-email-yangpc@wangsu.com>
References: <1669634685-1717-1-git-send-email-yangpc@wangsu.com>
X-CM-TRANSID: SyJltADXxwySmoRjSUsAAA--.450S4
X-Coremail-Antispam: 1UD129KBjvJXoW7KFy7uF1xJr47Ar4kKF4xXrb_yoW5Jry3pF
        1vya1fCFW7CrWjgw1fJFWvqF43uw1rKFyjkr1Y9w1ft3ykKr40qFn5GFy3ZF1rArs7Ca1S
        qr4UGrW5CF17Zw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnUUvcSsGvfC2KfnxnUUI43ZEXa7xR_UUUUUUUUU==
X-CM-SenderInfo: p1dqw1nf6zt0xjvxhudrp/
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When redirecting, we use sk_msg_to_ingress() to get the BPF_F_INGRESS
flag from the msg->flags. If apply_bytes is used and it is larger than
the current data being processed, sk_psock_msg_verdict() will not be
called when sendmsg() is called again. At this time, the msg->flags is 0,
and we lost the BPF_F_INGRESS flag.

So we need to save the BPF_F_INGRESS flag in sk_psock and assign it to
msg->flags before redirection.

Fixes: 8934ce2fd081 ("bpf: sockmap redirect ingress support")
Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
---
 include/linux/skmsg.h | 1 +
 net/core/skmsg.c      | 1 +
 net/ipv4/tcp_bpf.c    | 2 ++
 net/tls/tls_sw.c      | 1 +
 4 files changed, 5 insertions(+)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 48f4b64..e1d463f 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -82,6 +82,7 @@ struct sk_psock {
 	u32				apply_bytes;
 	u32				cork_bytes;
 	u32				eval;
+	u32				flags;
 	struct sk_msg			*cork;
 	struct sk_psock_progs		progs;
 #if IS_ENABLED(CONFIG_BPF_STREAM_PARSER)
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 188f855..ab2f8f3 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -888,6 +888,7 @@ int sk_psock_msg_verdict(struct sock *sk, struct sk_psock *psock,
 		if (psock->sk_redir)
 			sock_put(psock->sk_redir);
 		psock->sk_redir = msg->sk_redir;
+		psock->flags = msg->flags;
 		if (!psock->sk_redir) {
 			ret = __SK_DROP;
 			goto out;
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index ef5de4f..ac883c9 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -323,12 +323,14 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
 		break;
 	case __SK_REDIRECT:
 		sk_redir = psock->sk_redir;
+		msg->flags = psock->flags;
 		sk_msg_apply_bytes(psock, tosend);
 		if (!psock->apply_bytes) {
 			/* Clean up before releasing the sock lock. */
 			eval = psock->eval;
 			psock->eval = __SK_NONE;
 			psock->sk_redir = NULL;
+			psock->flags = 0;
 		}
 		if (psock->cork) {
 			cork = true;
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index fe27241..49e424d 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -838,6 +838,7 @@ static int bpf_exec_tx_verdict(struct sk_msg *msg, struct sock *sk,
 		break;
 	case __SK_REDIRECT:
 		sk_redir = psock->sk_redir;
+		msg->flags = psock->flags;
 		memcpy(&msg_redir, msg, sizeof(*msg));
 		if (msg->apply_bytes < send)
 			msg->apply_bytes = 0;
-- 
1.8.3.1


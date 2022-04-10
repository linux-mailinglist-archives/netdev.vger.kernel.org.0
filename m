Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1A254FAEC7
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 18:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239877AbiDJQNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 12:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243490AbiDJQNC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 12:13:02 -0400
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 485884704C
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 09:10:51 -0700 (PDT)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-d6ca46da48so14759613fac.12
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 09:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qIwja98XMjRMXmd1i+cMEo2Fpfxq0B8s/z047qqE0MM=;
        b=RYuYZ+TbecWK4nPULE9PlGlkPhzvzepUCVKUE1W64m0IWXpHk85MeToyxFHwYWZF0R
         Otaw5hy432Woz08r9YZ8CFDpEsTOQBr1kM0ZMIOxGkm4PjhxLHjiOy0/qm0RXavhJUOP
         mTqmprUkffkBuHS5oq6EPAJSBXopLJmCTKTDUjileg3X6u9o8J2sHbQqVS2pgpQnk9h6
         G6pNQddjw8Etu5X/c+bdw3rneLenlAb9pC9VIYJVOGbFKWec7ycL2LyJPsyNtSalDt/a
         GmT1bEo5H27Bj7Pj2KsN83ot7pusDTEJXfy/ucAgZHSnk9VYZrMHiAi2+ZGV8Vhx3exl
         2MfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qIwja98XMjRMXmd1i+cMEo2Fpfxq0B8s/z047qqE0MM=;
        b=qZ0EXuuhSTDUDph+X7wTmkAxWUd1hmkMBivkcxUKDQnrry8fhnIlikCAXcPIyt51FG
         Haiw67oIcSggWFhV6TMT+B+iI65nnC11RD3DZL7BOsd03t979gZBZMLOP7x615l7tr13
         BeuOLJgocYZodKjy6fmjZbejU9UJHWfYMgZ5Y+UacCMcWSvLTaDmyPJXOv9vy6FRA5Cz
         xtfR4cpXPvnOzWMEHh7QlfCPvwhtFpQ+3DhZftmqtbCcLvIgVGWv+e8f2QucSrf5bBNj
         xCwzv3TeXOeeS7/Tvy5F282ZFjRqaFuXvFtEuJwIPHYmMsXfeWshLYKqx2KW+08mTVcL
         1EgA==
X-Gm-Message-State: AOAM532DPIbxmgBUwpHw+oQ9aFEIc1F49p32k+Bdu4bUW7Z/CmGZk1Oz
        wSq79zUHHNzsqbcglocuhTmZArFy9v0=
X-Google-Smtp-Source: ABdhPJw6wswldNmTJpo2VqE0LgSgMDsFLhgqBV9nFMhPYzqoPHFuRiW+0/FS3XRlvscp2STMCupNyg==
X-Received: by 2002:a05:6870:9a16:b0:e2:8bdb:81d5 with SMTP id fo22-20020a0568709a1600b000e28bdb81d5mr5128293oab.102.1649607050537;
        Sun, 10 Apr 2022 09:10:50 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:9a32:f478:4bc0:f027])
        by smtp.gmail.com with ESMTPSA id v21-20020a4ade95000000b00320f814c73bsm10550200oou.47.2022.04.10.09.10.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Apr 2022 09:10:50 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <cong.wang@bytedance.com>,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: [Patch bpf-next v1 1/4] tcp: introduce tcp_read_skb()
Date:   Sun, 10 Apr 2022 09:10:39 -0700
Message-Id: <20220410161042.183540-2-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220410161042.183540-1-xiyou.wangcong@gmail.com>
References: <20220410161042.183540-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

This patch inroduces tcp_read_skb() based on tcp_read_sock(),
a preparation for the next patch which actually introduces
a new sock ops.

TCP is special here, because it has tcp_read_sock() which is
mainly used by splice(). tcp_read_sock() supports partial read
and arbitrary offset, neither of them is needed for sockmap.

Cc: Eric Dumazet <edumazet@google.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/net/tcp.h |  2 ++
 net/ipv4/tcp.c    | 72 +++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 66 insertions(+), 8 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 6d50a662bf89..f0d4ce6855e1 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -667,6 +667,8 @@ void tcp_get_info(struct sock *, struct tcp_info *);
 /* Read 'sendfile()'-style from a TCP socket */
 int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
 		  sk_read_actor_t recv_actor);
+int tcp_read_skb(struct sock *sk, read_descriptor_t *desc,
+		 sk_read_actor_t recv_actor);
 
 void tcp_initialize_rcv_mss(struct sock *sk);
 
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index e31cf137c614..8b054bcc6849 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1619,7 +1619,7 @@ static void tcp_eat_recv_skb(struct sock *sk, struct sk_buff *skb)
 	__kfree_skb(skb);
 }
 
-static struct sk_buff *tcp_recv_skb(struct sock *sk, u32 seq, u32 *off)
+static struct sk_buff *tcp_recv_skb(struct sock *sk, u32 seq, u32 *off, bool unlink)
 {
 	struct sk_buff *skb;
 	u32 offset;
@@ -1632,6 +1632,8 @@ static struct sk_buff *tcp_recv_skb(struct sock *sk, u32 seq, u32 *off)
 		}
 		if (offset < skb->len || (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN)) {
 			*off = offset;
+			if (unlink)
+				__skb_unlink(skb, &sk->sk_receive_queue);
 			return skb;
 		}
 		/* This looks weird, but this can happen if TCP collapsing
@@ -1665,7 +1667,7 @@ int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
 
 	if (sk->sk_state == TCP_LISTEN)
 		return -ENOTCONN;
-	while ((skb = tcp_recv_skb(sk, seq, &offset)) != NULL) {
+	while ((skb = tcp_recv_skb(sk, seq, &offset, false)) != NULL) {
 		if (offset < skb->len) {
 			int used;
 			size_t len;
@@ -1696,7 +1698,7 @@ int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
 			 * getting here: tcp_collapse might have deleted it
 			 * while aggregating skbs from the socket queue.
 			 */
-			skb = tcp_recv_skb(sk, seq - 1, &offset);
+			skb = tcp_recv_skb(sk, seq - 1, &offset, false);
 			if (!skb)
 				break;
 			/* TCP coalescing might have appended data to the skb.
@@ -1721,13 +1723,67 @@ int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
 
 	/* Clean up data we have read: This will do ACK frames. */
 	if (copied > 0) {
-		tcp_recv_skb(sk, seq, &offset);
+		tcp_recv_skb(sk, seq, &offset, false);
 		tcp_cleanup_rbuf(sk, copied);
 	}
 	return copied;
 }
 EXPORT_SYMBOL(tcp_read_sock);
 
+int tcp_read_skb(struct sock *sk, read_descriptor_t *desc,
+		 sk_read_actor_t recv_actor)
+{
+	struct sk_buff *skb;
+	struct tcp_sock *tp = tcp_sk(sk);
+	u32 seq = tp->copied_seq;
+	u32 offset;
+	int copied = 0;
+
+	if (sk->sk_state == TCP_LISTEN)
+		return -ENOTCONN;
+	while ((skb = tcp_recv_skb(sk, seq, &offset, true)) != NULL) {
+		if (offset < skb->len) {
+			int used;
+			size_t len;
+
+			len = skb->len - offset;
+			used = recv_actor(desc, skb, offset, len);
+			if (used <= 0) {
+				if (!copied)
+					copied = used;
+				break;
+			}
+			if (WARN_ON_ONCE(used > len))
+				used = len;
+			seq += used;
+			copied += used;
+			offset += used;
+
+			if (offset != skb->len)
+				continue;
+		}
+		if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN) {
+			kfree_skb(skb);
+			++seq;
+			break;
+		}
+		kfree_skb(skb);
+		if (!desc->count)
+			break;
+		WRITE_ONCE(tp->copied_seq, seq);
+	}
+	WRITE_ONCE(tp->copied_seq, seq);
+
+	tcp_rcv_space_adjust(sk);
+
+	/* Clean up data we have read: This will do ACK frames. */
+	if (copied > 0)
+		tcp_cleanup_rbuf(sk, copied);
+
+	return copied;
+}
+EXPORT_SYMBOL(tcp_read_skb);
+
 int tcp_peek_len(struct socket *sock)
 {
 	return tcp_inq(sock->sk);
@@ -1910,7 +1966,7 @@ static int receive_fallback_to_copy(struct sock *sk,
 		struct sk_buff *skb;
 		u32 offset;
 
-		skb = tcp_recv_skb(sk, tcp_sk(sk)->copied_seq, &offset);
+		skb = tcp_recv_skb(sk, tcp_sk(sk)->copied_seq, &offset, false);
 		if (skb)
 			tcp_zerocopy_set_hint_for_skb(sk, zc, skb, offset);
 	}
@@ -1957,7 +2013,7 @@ static int tcp_zc_handle_leftover(struct tcp_zerocopy_receive *zc,
 	if (skb) {
 		offset = *seq - TCP_SKB_CB(skb)->seq;
 	} else {
-		skb = tcp_recv_skb(sk, *seq, &offset);
+		skb = tcp_recv_skb(sk, *seq, &offset, false);
 		if (TCP_SKB_CB(skb)->has_rxtstamp) {
 			tcp_update_recv_tstamps(skb, tss);
 			zc->msg_flags |= TCP_CMSG_TS;
@@ -2150,7 +2206,7 @@ static int tcp_zerocopy_receive(struct sock *sk,
 				skb = skb->next;
 				offset = seq - TCP_SKB_CB(skb)->seq;
 			} else {
-				skb = tcp_recv_skb(sk, seq, &offset);
+				skb = tcp_recv_skb(sk, seq, &offset, false);
 			}
 
 			if (TCP_SKB_CB(skb)->has_rxtstamp) {
@@ -2206,7 +2262,7 @@ static int tcp_zerocopy_receive(struct sock *sk,
 		tcp_rcv_space_adjust(sk);
 
 		/* Clean up data we have read: This will do ACK frames. */
-		tcp_recv_skb(sk, seq, &offset);
+		tcp_recv_skb(sk, seq, &offset, false);
 		tcp_cleanup_rbuf(sk, length + copylen);
 		ret = 0;
 		if (length == zc->length)
-- 
2.32.0


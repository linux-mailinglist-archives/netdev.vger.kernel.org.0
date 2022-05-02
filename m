Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A74F7517678
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 20:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386850AbiEBS1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 14:27:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238642AbiEBS1a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 14:27:30 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D283265A1;
        Mon,  2 May 2022 11:24:00 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id l16so8759992oil.6;
        Mon, 02 May 2022 11:24:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZlOdm9LHJdhe6OTRhmGuzd9PvHg3DuoSVReEww5/lns=;
        b=alzeGk9t1f7cbHxfcRY/eiJMiNeVN9h3SS6Snzk9LTcXO/1Jm6eua2YoAM0s4Xbn2V
         eKul+c9q+2PxVOwVhklq6nvus43lu5LF8S6yMA3dODXeedWAfvPD21v4AkYXQJDsA6KH
         kle02NTRbK8h1WJbI5+ssNa2yn6D3TH8JBytc4AG+3FzO4clc17vvoDK84Z4KFDaLS+E
         4BzTCqdFwVFEGuRshzXBkRxCA1hC2mIHNdF/gxMYLJDjbgZeNYbD4xV83c5yEyhNyXEQ
         XfcKi7Oq9xsd/olFxT+ZBYu9L8i+foitIrkWQugevJFdv6QlPQX6hnRjfwMfGj57Py7u
         QCrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZlOdm9LHJdhe6OTRhmGuzd9PvHg3DuoSVReEww5/lns=;
        b=ule8e5uFlURQ0fvoDJVk/F5uQCc8H8Ezd5d0ppbpUl2/wl+NmnPgXRi4IM9MTziuQz
         4Qkc9PKQuHMtrH4lH5PNJVcxrt/Z6A3BhY3aTs5dJmjbi0RkED/gzKx4syttdNakMUvV
         reW+d/SgcssQB4MRqBo3mQEuK7XK0+IwYLbukF361cZXy9uzEPxpRlQemPrRX2ILwFzv
         J9mziPXJgrUxng/semySedh4nOIVSLgNfVXf1wbmfXjy85VS4xRI3aXMwSiCGx/8R3pK
         D6l4ZbtoGxZALS1xIDDLlr7Js+umiOLLgyE7t1YV+20wssE28mB7uogZAvgs1mM3mj6v
         ag8A==
X-Gm-Message-State: AOAM533KBtO5SfuaaCpOvbHk8YawsNh2eLQkrNXiuAMm05F+UKONMozs
        xK0TLJVk0X1EeWyvg7LlBfyVgB8Zo1Q=
X-Google-Smtp-Source: ABdhPJztpTRBUBqzvrVjPvL4D3egtwLF+C9i5eL3SvEE7XnsHcCNmjk4NX9ch3GtoHsgAJn7k+RewA==
X-Received: by 2002:a54:4f12:0:b0:325:e:49ff with SMTP id e18-20020a544f12000000b00325000e49ffmr208848oiy.261.1651515840068;
        Mon, 02 May 2022 11:24:00 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:7340:5d9f:8575:d25d])
        by smtp.gmail.com with ESMTPSA id t13-20020a05683014cd00b0060603221245sm3129915otq.21.2022.05.02.11.23.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 11:23:59 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: [Patch bpf-next v2 1/4] tcp: introduce tcp_read_skb()
Date:   Mon,  2 May 2022 11:23:42 -0700
Message-Id: <20220502182345.306970-2-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220502182345.306970-1-xiyou.wangcong@gmail.com>
References: <20220502182345.306970-1-xiyou.wangcong@gmail.com>
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
 net/ipv4/tcp.c    | 63 +++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 57 insertions(+), 8 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 94a52ad1101c..ab7516e5cc56 100644
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
index db55af9eb37b..8d48126e3694 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1600,7 +1600,7 @@ static void tcp_eat_recv_skb(struct sock *sk, struct sk_buff *skb)
 	__kfree_skb(skb);
 }
 
-static struct sk_buff *tcp_recv_skb(struct sock *sk, u32 seq, u32 *off)
+static struct sk_buff *tcp_recv_skb(struct sock *sk, u32 seq, u32 *off, bool unlink)
 {
 	struct sk_buff *skb;
 	u32 offset;
@@ -1613,6 +1613,8 @@ static struct sk_buff *tcp_recv_skb(struct sock *sk, u32 seq, u32 *off)
 		}
 		if (offset < skb->len || (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN)) {
 			*off = offset;
+			if (unlink)
+				__skb_unlink(skb, &sk->sk_receive_queue);
 			return skb;
 		}
 		/* This looks weird, but this can happen if TCP collapsing
@@ -1646,7 +1648,7 @@ int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
 
 	if (sk->sk_state == TCP_LISTEN)
 		return -ENOTCONN;
-	while ((skb = tcp_recv_skb(sk, seq, &offset)) != NULL) {
+	while ((skb = tcp_recv_skb(sk, seq, &offset, false)) != NULL) {
 		if (offset < skb->len) {
 			int used;
 			size_t len;
@@ -1677,7 +1679,7 @@ int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
 			 * getting here: tcp_collapse might have deleted it
 			 * while aggregating skbs from the socket queue.
 			 */
-			skb = tcp_recv_skb(sk, seq - 1, &offset);
+			skb = tcp_recv_skb(sk, seq - 1, &offset, false);
 			if (!skb)
 				break;
 			/* TCP coalescing might have appended data to the skb.
@@ -1702,13 +1704,58 @@ int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
 
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
+	struct tcp_sock *tp = tcp_sk(sk);
+	u32 seq = tp->copied_seq;
+	struct sk_buff *skb;
+	int copied = 0;
+	u32 offset;
+
+	if (sk->sk_state == TCP_LISTEN)
+		return -ENOTCONN;
+
+	while ((skb = tcp_recv_skb(sk, seq, &offset, true)) != NULL) {
+		int used = recv_actor(desc, skb, 0, skb->len);
+
+		if (used <= 0) {
+			if (!copied)
+				copied = used;
+			break;
+		}
+		seq += used;
+		copied += used;
+
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
@@ -1890,7 +1937,7 @@ static int receive_fallback_to_copy(struct sock *sk,
 		struct sk_buff *skb;
 		u32 offset;
 
-		skb = tcp_recv_skb(sk, tcp_sk(sk)->copied_seq, &offset);
+		skb = tcp_recv_skb(sk, tcp_sk(sk)->copied_seq, &offset, false);
 		if (skb)
 			tcp_zerocopy_set_hint_for_skb(sk, zc, skb, offset);
 	}
@@ -1937,7 +1984,7 @@ static int tcp_zc_handle_leftover(struct tcp_zerocopy_receive *zc,
 	if (skb) {
 		offset = *seq - TCP_SKB_CB(skb)->seq;
 	} else {
-		skb = tcp_recv_skb(sk, *seq, &offset);
+		skb = tcp_recv_skb(sk, *seq, &offset, false);
 		if (TCP_SKB_CB(skb)->has_rxtstamp) {
 			tcp_update_recv_tstamps(skb, tss);
 			zc->msg_flags |= TCP_CMSG_TS;
@@ -2130,7 +2177,7 @@ static int tcp_zerocopy_receive(struct sock *sk,
 				skb = skb->next;
 				offset = seq - TCP_SKB_CB(skb)->seq;
 			} else {
-				skb = tcp_recv_skb(sk, seq, &offset);
+				skb = tcp_recv_skb(sk, seq, &offset, false);
 			}
 
 			if (TCP_SKB_CB(skb)->has_rxtstamp) {
@@ -2186,7 +2233,7 @@ static int tcp_zerocopy_receive(struct sock *sk,
 		tcp_rcv_space_adjust(sk);
 
 		/* Clean up data we have read: This will do ACK frames. */
-		tcp_recv_skb(sk, seq, &offset);
+		tcp_recv_skb(sk, seq, &offset, false);
 		tcp_cleanup_rbuf(sk, length + copylen);
 		ret = 0;
 		if (length == zc->length)
-- 
2.32.0


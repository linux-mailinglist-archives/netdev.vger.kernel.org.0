Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E12D6D8A58
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 00:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbjDEWJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 18:09:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234096AbjDEWJf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 18:09:35 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6D94729F;
        Wed,  5 Apr 2023 15:09:18 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id e15-20020a17090ac20f00b0023d1b009f52so40959734pjt.2;
        Wed, 05 Apr 2023 15:09:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680732558; x=1683324558;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8yeZPZUNMOPRMqDverjuWL58c5aE5QrYlYRCPTWyTzg=;
        b=Joc7z4LuWUk0VezoKsv18jgIJdkFrTcfpVM1ZgKcCxIjOECPfeVC8BUtTLwi9N04Qd
         PkhuO2HXRTJh5ESWX8yDjvDGZwIifHyg3g953cAD4hsHjtcn2uaHs+EyMVaMO/IGpsjM
         YW1S09zFRagaCIJkpxD66KgJ6aB+f2s+CVaPFyJldyoFmamfQVHjir06Cz5XHMtNTaUa
         uN0O45WBvAceZaMZmBUbrN6pKBGIXQkmNA4YtCOXxPrz+r4UqZYT0plL2/0PfC6C4Q4y
         RqNddw2OyNgk+ttyoZlOGduhWTWHJBk9Kl/w5xVblcMDW2MJfPbECKXZug7cLm89/CjO
         WVvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680732558; x=1683324558;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8yeZPZUNMOPRMqDverjuWL58c5aE5QrYlYRCPTWyTzg=;
        b=Ql8VKsTO4+mvMBtIKWQ5v0o6/ucG+uBtltI+JzK5P/sWRDYZeYVZ52HWfzBRwZZ5lW
         ocsCeDK62XQ1VERiRSUsuv0yFTsoDfCNmsRhpkO85gP08f70pUsrvuPkDXx7vFBVHtLn
         V4OYviVYevjqDHkyo7IdomD16MMvgwF1P0MVFFDg9ld+9FNjoQBmQQWwUUd/tXQeYcjf
         sKnpVZk/8+Xohr11v+y3erkQwCYw+vTrgNiJDWtvpuo7DhgcoRZiG3YZKKH8hKn1OoK8
         NOXu4r5ElS2Chfskmqh++qRkUPIYjqLuhAx97qhKzxAWej2k695PDY39twhPaUTAE197
         ab3A==
X-Gm-Message-State: AAQBX9fjEGgzIuSSVY+hE5V6ZYeeXuBqgyiAKkWAY0cb1OTwUE+lq3fw
        Xk4NqzM125W7kekvSObOEHc=
X-Google-Smtp-Source: AKy350ZjfOLAO7+zS4XommEpJ9ay5hgbrAlJfAPOn1fGDZxOn3CfyDXNgjGyR9kmsJNWcRk2aAHLJQ==
X-Received: by 2002:a17:90b:3a81:b0:236:73d5:82cf with SMTP id om1-20020a17090b3a8100b0023673d582cfmr8848056pjb.9.1680732558253;
        Wed, 05 Apr 2023 15:09:18 -0700 (PDT)
Received: from john.lan ([2605:59c8:4c5:7110:5120:4bff:95ea:9ce0])
        by smtp.gmail.com with ESMTPSA id gz11-20020a17090b0ecb00b00230ffcb2e24sm1865697pjb.13.2023.04.05.15.09.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 15:09:17 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub@cloudflare.com, daniel@iogearbox.net, edumazet@google.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        will@isovalent.com
Subject: [PATCH bpf v4 07/12] bpf: sockmap incorrectly handling copied_seq
Date:   Wed,  5 Apr 2023 15:08:59 -0700
Message-Id: <20230405220904.153149-8-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230405220904.153149-1-john.fastabend@gmail.com>
References: <20230405220904.153149-1-john.fastabend@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The read_skb() logic is incrementing the tcp->copied_seq which is used for
among other things calculating how many outstanding bytes can be read by
the application. This results in application errors, if the application
does an ioctl(FIONREAD) we return zero because this is calculated from
the copied_seq value.

To fix this we move tcp->copied_seq accounting into the recv handler so
that we update these when the recvmsg() hook is called and data is in
fact copied into user buffers. This gives an accurate FIONREAD value
as expected and improves ACK handling. Before we were calling the
tcp_rcv_space_adjust() which would update 'number of bytes copied to
user in last RTT' which is wrong for programs returning SK_PASS. The
bytes are only copied to the user when recvmsg is handled.

Doing the fix for recvmsg is straightforward, but fixing redirect and
SK_DROP pkts is a bit tricker. Build a tcp_psock_eat() helper and then
call this from skmsg handlers. This fixes another issue where a broken
socket with a BPF program doing a resubmit could hang the receiver. This
happened because although read_skb() consumed the skb through sock_drop()
it did not update the copied_seq. Now if a single reccv socket is
redirecting to many sockets (for example for lb) the receiver sk will be
hung even though we might expect it to continue. The hang comes from
not updating the copied_seq numbers and memory pressure resulting from
that.

We have a slight layer problem of calling tcp_eat_skb even if its not
a TCP socket. To fix we could refactor and create per type receiver
handlers. I decided this is more work than we want in the fix and we
already have some small tweaks depending on caller that use the
helper skb_bpf_strparser(). So we extend that a bit and always set
the strparser bit when it is in use and then we can gate the
seq_copied updates on this.

Fixes: 04919bed948dc ("tcp: Introduce tcp_read_skb()")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 include/net/tcp.h  |  3 +++
 net/core/skmsg.c   |  7 +++++--
 net/ipv4/tcp.c     | 10 +---------
 net/ipv4/tcp_bpf.c | 28 +++++++++++++++++++++++++++-
 4 files changed, 36 insertions(+), 12 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index db9f828e9d1e..c62860060b9f 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1467,6 +1467,8 @@ static inline void tcp_adjust_rcv_ssthresh(struct sock *sk)
 }
 
 void tcp_cleanup_rbuf(struct sock *sk, int copied);
+void __tcp_cleanup_rbuf(struct sock *sk, int copied);
+
 
 /* We provision sk_rcvbuf around 200% of sk_rcvlowat.
  * If 87.5 % (7/8) of the space has been consumed, we want to override
@@ -2323,6 +2325,7 @@ int tcp_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore);
 void tcp_bpf_clone(const struct sock *sk, struct sock *newsk);
 #endif /* CONFIG_BPF_SYSCALL */
 
+void tcp_eat_skb(struct sock *sk, struct sk_buff *skb);
 int tcp_bpf_sendmsg_redir(struct sock *sk, bool ingress,
 			  struct sk_msg *msg, u32 bytes, int flags);
 #endif /* CONFIG_NET_SOCK_MSG */
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index a2e83d2aacf8..69983f40fbec 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -1053,11 +1053,14 @@ static int sk_psock_verdict_apply(struct sk_psock *psock, struct sk_buff *skb,
 		mutex_unlock(&psock->work_mutex);
 		break;
 	case __SK_REDIRECT:
+		tcp_eat_skb(psock->sk, skb);
 		err = sk_psock_skb_redirect(psock, skb);
 		break;
 	case __SK_DROP:
 	default:
 out_free:
+		tcp_eat_skb(psock->sk, skb);
+		skb_bpf_redirect_clear(skb);
 		sock_drop(psock->sk, skb);
 	}
 
@@ -1102,8 +1105,7 @@ static void sk_psock_strp_read(struct strparser *strp, struct sk_buff *skb)
 		skb_dst_drop(skb);
 		skb_bpf_redirect_clear(skb);
 		ret = bpf_prog_run_pin_on_cpu(prog, skb);
-		if (ret == SK_PASS)
-			skb_bpf_set_strparser(skb);
+		skb_bpf_set_strparser(skb);
 		ret = sk_psock_map_verd(ret, skb_bpf_redirect_fetch(skb));
 		skb->sk = NULL;
 	}
@@ -1211,6 +1213,7 @@ static int sk_psock_verdict_recv(struct sock *sk, struct sk_buff *skb)
 	psock = sk_psock(sk);
 	if (unlikely(!psock)) {
 		len = 0;
+		tcp_eat_skb(sk, skb);
 		sock_drop(sk, skb);
 		goto out;
 	}
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 1be305e3d3c7..5610f8341b38 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1568,7 +1568,7 @@ static int tcp_peek_sndq(struct sock *sk, struct msghdr *msg, int len)
  * calculation of whether or not we must ACK for the sake of
  * a window update.
  */
-static void __tcp_cleanup_rbuf(struct sock *sk, int copied)
+void __tcp_cleanup_rbuf(struct sock *sk, int copied)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	bool time_to_ack = false;
@@ -1783,14 +1783,6 @@ int tcp_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 			break;
 		}
 	}
-	WRITE_ONCE(tp->copied_seq, seq);
-
-	tcp_rcv_space_adjust(sk);
-
-	/* Clean up data we have read: This will do ACK frames. */
-	if (copied > 0)
-		__tcp_cleanup_rbuf(sk, copied);
-
 	return copied;
 }
 EXPORT_SYMBOL(tcp_read_skb);
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index ae6c7130551c..9e94864ce130 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -11,6 +11,24 @@
 #include <net/inet_common.h>
 #include <net/tls.h>
 
+void tcp_eat_skb(struct sock *sk, struct sk_buff *skb)
+{
+	struct tcp_sock *tcp;
+	int copied;
+
+	if (!skb || !skb->len || !sk_is_tcp(sk))
+		return;
+
+	if (skb_bpf_strparser(skb))
+		return;
+
+	tcp = tcp_sk(sk);
+	copied = tcp->copied_seq + skb->len;
+	WRITE_ONCE(tcp->copied_seq, copied);
+	tcp_rcv_space_adjust(sk);
+	__tcp_cleanup_rbuf(sk, skb->len);
+}
+
 static int bpf_tcp_ingress(struct sock *sk, struct sk_psock *psock,
 			   struct sk_msg *msg, u32 apply_bytes, int flags)
 {
@@ -198,8 +216,10 @@ static int tcp_bpf_recvmsg_parser(struct sock *sk,
 				  int flags,
 				  int *addr_len)
 {
+	struct tcp_sock *tcp = tcp_sk(sk);
+	u32 seq = tcp->copied_seq;
 	struct sk_psock *psock;
-	int copied;
+	int copied = 0;
 
 	if (unlikely(flags & MSG_ERRQUEUE))
 		return inet_recv_error(sk, msg, len, addr_len);
@@ -244,9 +264,11 @@ static int tcp_bpf_recvmsg_parser(struct sock *sk,
 
 		if (is_fin) {
 			copied = 0;
+			seq++;
 			goto out;
 		}
 	}
+	seq += copied;
 	if (!copied) {
 		long timeo;
 		int data;
@@ -284,6 +306,10 @@ static int tcp_bpf_recvmsg_parser(struct sock *sk,
 		copied = -EAGAIN;
 	}
 out:
+	WRITE_ONCE(tcp->copied_seq, seq);
+	tcp_rcv_space_adjust(sk);
+	if (copied > 0)
+		__tcp_cleanup_rbuf(sk, copied);
 	release_sock(sk);
 	sk_psock_put(sk, psock);
 	return copied;
-- 
2.33.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA43B6C3D0D
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 22:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbjCUVwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 17:52:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbjCUVwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 17:52:38 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB22158B6E;
        Tue, 21 Mar 2023 14:52:30 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id c18so17493872ple.11;
        Tue, 21 Mar 2023 14:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679435550;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aMnc+04Pbpcqj9zq7iu5DADhV34QBm8AEW4HKab4X5M=;
        b=ArUgyPZdMS7/HRhKUi4a/EIWxBqxxU3iF9n2pR6lhWkYmOd29eWZ6rz4VK4Hd8Rvqq
         wMus7hPnfIUF52HX3z+QLBIql8nqJE9MQ1jLG1qHNc2hf4jZb3glwCme9yECzx1OhOV0
         I31sI0FX6eyS9iBh9ETX7UNQ8R/V61+UkLguwTYgj/svZhjgoZpgPkQ30qUGbg+/t5mD
         +vCsooUZqt2z1N3dJXdgRphdCmcPtlV7rntZgtm15aeR/OJo/pWmQLmFu3Lt701RnQ5l
         QszDT/kvllhmJwYSm3wqek3iCMqiT1/r8TghO/keTVNS/ycy2Y/weWrGfvqhYedaYk/M
         x5ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679435550;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aMnc+04Pbpcqj9zq7iu5DADhV34QBm8AEW4HKab4X5M=;
        b=i66j6eL0z8PzVxm/4cF5g7T/mkjc8g6OygHxsgB5I52bqUQ1pkat8wekhVJo14TEGD
         rF/lXQ6FEfRL4CWIS5CcGvMi8MWXqLLXNX0T0XXOUxcPXO1twhqEZTpbd5XN5vjErdMX
         BIQDDEDk9bin6Ka80QxgLq7LAgaVATidZQQQe/GsUDFLu+Og570MCcT/oU1X9WoYJK6p
         emKQ3BpI/u4qDta8tayopfqgMNHYyUlp6MNI4ScVYRSoCMI+EHUBRcZVTpCNolG2JH+c
         pAWtD08bqnCzQrXjTTeQD0/yZ2VEKt6WxCBjuLYJNQdsPRjNXiksOl8N/CofdFhJvm1O
         a4Ag==
X-Gm-Message-State: AO0yUKWgIZ8KpFQ8Tpy5r6/nRmrlhNFMDiJbaUmHVso9MYkQFY+wEKGw
        7cjQiojh6CXYOWoWT9U0cm4=
X-Google-Smtp-Source: AK7set+bx8eGDvMdqo6Fgzq1cmNMW5+QOTn+o/P/8jWKOcnSuA48bUuBJMVHznCWDVpLzxCh72WYmw==
X-Received: by 2002:a17:90a:e7cd:b0:23d:35d9:d065 with SMTP id kb13-20020a17090ae7cd00b0023d35d9d065mr885671pjb.48.1679435550101;
        Tue, 21 Mar 2023 14:52:30 -0700 (PDT)
Received: from john.lan ([98.97.36.54])
        by smtp.gmail.com with ESMTPSA id m3-20020a63fd43000000b004facdf070d6sm8661331pgj.39.2023.03.21.14.52.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 14:52:29 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub@cloudflare.com, daniel@iogearbox.net, lmb@isovalent.com,
        cong.wang@bytedance.com
Cc:     bpf@vger.kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, edumazet@google.com, ast@kernel.org,
        andrii@kernel.org, will@isovalent.com
Subject: [PATCH bpf 07/11] bpf: sockmap incorrectly handling copied_seq
Date:   Tue, 21 Mar 2023 14:52:08 -0700
Message-Id: <20230321215212.525630-8-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230321215212.525630-1-john.fastabend@gmail.com>
References: <20230321215212.525630-1-john.fastabend@gmail.com>
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
index db9f828e9d1e..674044b8bdaf 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1467,6 +1467,8 @@ static inline void tcp_adjust_rcv_ssthresh(struct sock *sk)
 }
 
 void tcp_cleanup_rbuf(struct sock *sk, int copied);
+void __tcp_cleanup_rbuf(struct sock *sk, int copied);
+
 
 /* We provision sk_rcvbuf around 200% of sk_rcvlowat.
  * If 87.5 % (7/8) of the space has been consumed, we want to override
@@ -2321,6 +2323,7 @@ struct sk_psock;
 struct proto *tcp_bpf_get_proto(struct sock *sk, struct sk_psock *psock);
 int tcp_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore);
 void tcp_bpf_clone(const struct sock *sk, struct sock *newsk);
+void tcp_eat_skb(struct sock *sk, struct sk_buff *skb);
 #endif /* CONFIG_BPF_SYSCALL */
 
 int tcp_bpf_sendmsg_redir(struct sock *sk, bool ingress,
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 10e5481da662..b141b422697c 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -1051,11 +1051,14 @@ static int sk_psock_verdict_apply(struct sk_psock *psock, struct sk_buff *skb,
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
 
@@ -1100,8 +1103,7 @@ static void sk_psock_strp_read(struct strparser *strp, struct sk_buff *skb)
 		skb_dst_drop(skb);
 		skb_bpf_redirect_clear(skb);
 		ret = bpf_prog_run_pin_on_cpu(prog, skb);
-		if (ret == SK_PASS)
-			skb_bpf_set_strparser(skb);
+		skb_bpf_set_strparser(skb);
 		ret = sk_psock_map_verd(ret, skb_bpf_redirect_fetch(skb));
 		skb->sk = NULL;
 	}
@@ -1207,6 +1209,7 @@ static int sk_psock_verdict_recv(struct sock *sk, struct sk_buff *skb)
 	psock = sk_psock(sk);
 	if (unlikely(!psock)) {
 		len = 0;
+		tcp_eat_skb(sk, skb);
 		sock_drop(sk, skb);
 		goto out;
 	}
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 6572962b0237..e2594d8e3429 100644
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
index b1ba58be0c5a..c0e5680dccc0 100644
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
+	WRITE_ONCE(tcp->copied_seq, skb->len);
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
@@ -241,9 +261,11 @@ static int tcp_bpf_recvmsg_parser(struct sock *sk,
 
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
@@ -281,6 +303,10 @@ static int tcp_bpf_recvmsg_parser(struct sock *sk,
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


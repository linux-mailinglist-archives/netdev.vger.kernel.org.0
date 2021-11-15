Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1608451D8E
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 01:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232263AbhKPAbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 19:31:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345806AbhKOT3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 14:29:24 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BF88C0BC9B4
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 11:03:19 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id cq22-20020a17090af99600b001a9550a17a5so60199pjb.2
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 11:03:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4ARyKQTpLRBIJL2Jucr9pSu+Ghn03sNWkhfxMBkGUTY=;
        b=cO+d2CSnB7UxweIOMHjoGZ+VzVrkL66UGF0iay4WKs6IWv5o0A9SUYaBCCwqf9bvVS
         2m0WxW3u7xXpoC/8liQVzb8a4RDIxqwslhoLdrdcjEIwmva+oxPwDEMDZvVsRUG0qdZ0
         PKk4OKNhc2SNZr4UucEQpsHdxbFKaKKS5uHKwHcXoHelmBjo/Tl8bSiQ5kI7LlehlXTW
         D8/lomua5NNADnxXWyArudVIF78f5YY2z/9Ve2khBXVdQzeIw5BA8hPMbGHRxUqcitdM
         gFz90olrbrRLTRryh3Ytu1t672U+N/mXBHt7QRqO2NRXAieHFdy1QrxuyWJ4LI2vvTPQ
         PwXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4ARyKQTpLRBIJL2Jucr9pSu+Ghn03sNWkhfxMBkGUTY=;
        b=dF5gf+Am2woxjnu5afCP8ea4uLjjEMSLx6Z5cAq6Abn5r3RMcrQN0BEX7WtJdtGGVD
         WptTH9jeJnjft5IZ8bkYkJzE8oPiKZM3kcbfzXSpGOhGO6GWZHileY0P4u5hKfy/gcP+
         8fj1dEW41zeYf57Tco9qnzT26MDuDS90N1IZqlKRqWugf/QcX/LBz2DIgrfV5e7cU5ND
         f37R7e2JWT4XNluPb2S/p0+d20j4v9zK2YhHOOVU/Sx8Xp2w7M3oGJUSyCUVi9OzgynU
         YsixiJRszROpCdTE00mf3M7KH53ULZxFeqLhMXY1k7CXj1RYs8olmKMwQ0Y8EDa37VGe
         IEmw==
X-Gm-Message-State: AOAM533BUh5Q5SmKRcf0SmrFUU1t1rf0OZhhwhxMA1pqd2smJUlr0TuR
        S2QcHcGuB8b5jK4O2kJrfo0=
X-Google-Smtp-Source: ABdhPJz7KsjZXLBh/vPVSj0gbGAfEZoR8LHBnek3RbbZs7dAjpiFFRveqvxoTBNzIJU03fYq2xBiUw==
X-Received: by 2002:a17:90b:17cc:: with SMTP id me12mr952723pjb.179.1637002999035;
        Mon, 15 Nov 2021 11:03:19 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4994:f3d6:2eb1:61cb])
        by smtp.gmail.com with ESMTPSA id f21sm11850834pfe.69.2021.11.15.11.03.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 11:03:18 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Arjun Roy <arjunroy@google.com>
Subject: [PATCH net-next 14/20] tcp: annotate races around tp->urg_data
Date:   Mon, 15 Nov 2021 11:02:43 -0800
Message-Id: <20211115190249.3936899-15-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
In-Reply-To: <20211115190249.3936899-1-eric.dumazet@gmail.com>
References: <20211115190249.3936899-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

tcp_poll() and tcp_ioctl() are reading tp->urg_data without socket lock
owned.

Also, it is faster to first check tp->urg_data in tcp_poll(),
then tp->urg_seq == tp->copied_seq, because tp->urg_seq is
located in a different/cold cache line.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp.c       | 17 +++++++++--------
 net/ipv4/tcp_input.c |  4 ++--
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 267b2b18f048c4df4cabd819433a99bf8b3f2678..313cf648c349a24ab7a04729180ec9b76b2f6aa2 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -545,10 +545,11 @@ __poll_t tcp_poll(struct file *file, struct socket *sock, poll_table *wait)
 	if (state != TCP_SYN_SENT &&
 	    (state != TCP_SYN_RECV || rcu_access_pointer(tp->fastopen_rsk))) {
 		int target = sock_rcvlowat(sk, 0, INT_MAX);
+		u16 urg_data = READ_ONCE(tp->urg_data);
 
-		if (READ_ONCE(tp->urg_seq) == READ_ONCE(tp->copied_seq) &&
-		    !sock_flag(sk, SOCK_URGINLINE) &&
-		    tp->urg_data)
+		if (urg_data &&
+		    READ_ONCE(tp->urg_seq) == READ_ONCE(tp->copied_seq) &&
+		    !sock_flag(sk, SOCK_URGINLINE))
 			target++;
 
 		if (tcp_stream_is_readable(sk, target))
@@ -573,7 +574,7 @@ __poll_t tcp_poll(struct file *file, struct socket *sock, poll_table *wait)
 		} else
 			mask |= EPOLLOUT | EPOLLWRNORM;
 
-		if (tp->urg_data & TCP_URG_VALID)
+		if (urg_data & TCP_URG_VALID)
 			mask |= EPOLLPRI;
 	} else if (state == TCP_SYN_SENT && inet_sk(sk)->defer_connect) {
 		/* Active TCP fastopen socket with defer_connect
@@ -607,7 +608,7 @@ int tcp_ioctl(struct sock *sk, int cmd, unsigned long arg)
 		unlock_sock_fast(sk, slow);
 		break;
 	case SIOCATMARK:
-		answ = tp->urg_data &&
+		answ = READ_ONCE(tp->urg_data) &&
 		       READ_ONCE(tp->urg_seq) == READ_ONCE(tp->copied_seq);
 		break;
 	case SIOCOUTQ:
@@ -1465,7 +1466,7 @@ static int tcp_recv_urg(struct sock *sk, struct msghdr *msg, int len, int flags)
 		char c = tp->urg_data;
 
 		if (!(flags & MSG_PEEK))
-			tp->urg_data = TCP_URG_READ;
+			WRITE_ONCE(tp->urg_data, TCP_URG_READ);
 
 		/* Read urgent data. */
 		msg->msg_flags |= MSG_OOB;
@@ -2465,7 +2466,7 @@ static int tcp_recvmsg_locked(struct sock *sk, struct msghdr *msg, size_t len,
 
 skip_copy:
 		if (tp->urg_data && after(tp->copied_seq, tp->urg_seq)) {
-			tp->urg_data = 0;
+			WRITE_ONCE(tp->urg_data, 0);
 			tcp_fast_path_check(sk);
 		}
 
@@ -2959,7 +2960,7 @@ int tcp_disconnect(struct sock *sk, int flags)
 	tcp_clear_xmit_timers(sk);
 	__skb_queue_purge(&sk->sk_receive_queue);
 	WRITE_ONCE(tp->copied_seq, tp->rcv_nxt);
-	tp->urg_data = 0;
+	WRITE_ONCE(tp->urg_data, 0);
 	tcp_write_queue_purge(sk);
 	tcp_fastopen_active_disable_ofo_check(sk);
 	skb_rbtree_purge(&tp->out_of_order_queue);
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 246ab7b5e857eb9e802c4805075e89c98cf00636..5ee07a337652696bdebb1117334ff39d88fd0276 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5591,7 +5591,7 @@ static void tcp_check_urg(struct sock *sk, const struct tcphdr *th)
 		}
 	}
 
-	tp->urg_data = TCP_URG_NOTYET;
+	WRITE_ONCE(tp->urg_data, TCP_URG_NOTYET);
 	WRITE_ONCE(tp->urg_seq, ptr);
 
 	/* Disable header prediction. */
@@ -5617,7 +5617,7 @@ static void tcp_urg(struct sock *sk, struct sk_buff *skb, const struct tcphdr *t
 			u8 tmp;
 			if (skb_copy_bits(skb, ptr, &tmp, 1))
 				BUG();
-			tp->urg_data = TCP_URG_VALID | tmp;
+			WRITE_ONCE(tp->urg_data, TCP_URG_VALID | tmp);
 			if (!sock_flag(sk, SOCK_DEAD))
 				sk->sk_data_ready(sk);
 		}
-- 
2.34.0.rc1.387.gb447b232ab-goog


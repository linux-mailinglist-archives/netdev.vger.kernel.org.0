Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14FA52B0D5C
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 20:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727155AbgKLTCq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 14:02:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727147AbgKLTCp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 14:02:45 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65B79C0613D1
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 11:02:45 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id w4so4949124pgg.13
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 11:02:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KfiOB8ZGjLkvBBtrQum1ZpB66ELEgJ/gdPcqJ2w29Go=;
        b=pR4Fsl1SoLnDSYE5ittiLwVN83rnMwMfmUJulGzOiiHwCyZDchn8RREnBYVntT9M+y
         ADnJKI4Gph7rr0112y0GSkczDDLy7HDHwaRuLG5g9nfIArtH3Tyj1+W4aQSBX1IEqdf3
         ecPWHAzGwsFxrmlI2A50QoKGLcp1UgK1AIhfZb76ryJ8GBqhs+6kFUaMUkQj9WTJ8Vu0
         Pe4Dz7rTaYx0mAeAFsQ4E2DZu+AERgWX7XsGWeYNsT+Y2OfhoglecRsNetXPEeKt82vb
         sZX2gdOetNRnfLXqI6fgaHxIwdhoRyMeeYrFjWnV+rI9oZDUzQDtvOnsb7aueYjrolD7
         NTPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KfiOB8ZGjLkvBBtrQum1ZpB66ELEgJ/gdPcqJ2w29Go=;
        b=bFbnZWh6/vfAHnPL73MdcYCaI3jOlGJIOgWMTsaiLHoHdG6Ykw80OdqGBEiXN26Klt
         DK9aYE2oPar03uOXhO8vPxCV2zQZa6R/C5zBjMyb1O3EyZEXdcAt0iFtJFoVikfN2EgB
         1l1dr3Q7laG+makmz9RlmivwnUl8OPwmIX8nqnOx7sKjEN80oeNo2rfnlDG3KKHghVPV
         6v9/U9BWZUNXWyBWZcKhFBwOHQc1kc+ycSIjJsrlRV1p4/EK/+vYKYqSHcemcoReg6ye
         1r0GGZu4bJ9rfH+hngyPMl7oB2O1z4ya2JoY+JT5jlStWj2pWn8octuy4IUV9VbCfsHK
         4uLw==
X-Gm-Message-State: AOAM53368meGALVXF9AE85J08ayQsYl0Y9EonYPB+oT7kI8U/OjuJAyz
        Ki3oG1olmTRV4GuJvnCNxIY=
X-Google-Smtp-Source: ABdhPJw5vbsLVIYPCSmKvpUUCWvzB0hEfkgHn9fkIHA2z+JjP5fIkZRf4T+9UA6OZI9boh74SLg4ow==
X-Received: by 2002:a17:90b:14c:: with SMTP id em12mr683138pjb.170.1605207764705;
        Thu, 12 Nov 2020 11:02:44 -0800 (PST)
Received: from phantasmagoria.svl.corp.google.com ([2620:15c:2c4:201:f693:9fff:feea:f0b9])
        by smtp.gmail.com with ESMTPSA id z7sm7458809pfq.214.2020.11.12.11.02.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 11:02:44 -0800 (PST)
From:   Arjun Roy <arjunroy.kdev@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     arjunroy@google.com, edumazet@google.com, soheil@google.com
Subject: [net-next 2/8] tcp: Introduce tcp_recvmsg_locked().
Date:   Thu, 12 Nov 2020 11:01:59 -0800
Message-Id: <20201112190205.633640-3-arjunroy.kdev@gmail.com>
X-Mailer: git-send-email 2.29.2.222.g5d2a92d10f8-goog
In-Reply-To: <20201112190205.633640-1-arjunroy.kdev@gmail.com>
References: <20201112190205.633640-1-arjunroy.kdev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arjun Roy <arjunroy@google.com>

Refactor tcp_recvmsg() by splitting it into locked and unlocked
portions. Callers already holding the socket lock and not using
ERRQUEUE/cmsg/busy polling can simply call tcp_recvmsg_locked().
This is in preparation for a short-circuit copy performed by
TCP receive zerocopy for small (< PAGE_SIZE, or otherwise requested
by the user) reads.

Signed-off-by: Arjun Roy <arjunroy@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>

---
 net/ipv4/tcp.c | 68 ++++++++++++++++++++++++++++----------------------
 1 file changed, 38 insertions(+), 30 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index f86ccf221c0b..49e33222a68b 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2061,36 +2061,27 @@ static int tcp_inq_hint(struct sock *sk)
  *	Probably, code can be easily improved even more.
  */
 
-int tcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int nonblock,
-		int flags, int *addr_len)
+static int tcp_recvmsg_locked(struct sock *sk, struct msghdr *msg, size_t len,
+			      int nonblock, int flags,
+			      struct scm_timestamping_internal *tss, int *cmsg_flags)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	int copied = 0;
 	u32 peek_seq;
 	u32 *seq;
 	unsigned long used;
-	int err, inq;
+	int err;
 	int target;		/* Read at least this many bytes */
 	long timeo;
 	struct sk_buff *skb, *last;
 	u32 urg_hole = 0;
-	struct scm_timestamping_internal tss;
-	int cmsg_flags;
-
-	if (unlikely(flags & MSG_ERRQUEUE))
-		return inet_recv_error(sk, msg, len, addr_len);
-
-	if (sk_can_busy_loop(sk) && skb_queue_empty_lockless(&sk->sk_receive_queue) &&
-	    (sk->sk_state == TCP_ESTABLISHED))
-		sk_busy_loop(sk, nonblock);
-
-	lock_sock(sk);
 
 	err = -ENOTCONN;
 	if (sk->sk_state == TCP_LISTEN)
 		goto out;
 
-	cmsg_flags = tp->recvmsg_inq ? 1 : 0;
+	if (tp->recvmsg_inq)
+		*cmsg_flags = 1;
 	timeo = sock_rcvtimeo(sk, nonblock);
 
 	/* Urgent data needs to be handled specially. */
@@ -2270,8 +2261,8 @@ int tcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int nonblock,
 		}
 
 		if (TCP_SKB_CB(skb)->has_rxtstamp) {
-			tcp_update_recv_tstamps(skb, &tss);
-			cmsg_flags |= 2;
+			tcp_update_recv_tstamps(skb, tss);
+			*cmsg_flags |= 2;
 		}
 
 		if (used + offset < skb->len)
@@ -2297,22 +2288,9 @@ int tcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int nonblock,
 
 	/* Clean up data we have read: This will do ACK frames. */
 	tcp_cleanup_rbuf(sk, copied);
-
-	release_sock(sk);
-
-	if (cmsg_flags) {
-		if (cmsg_flags & 2)
-			tcp_recv_timestamp(msg, sk, &tss);
-		if (cmsg_flags & 1) {
-			inq = tcp_inq_hint(sk);
-			put_cmsg(msg, SOL_TCP, TCP_CM_INQ, sizeof(inq), &inq);
-		}
-	}
-
 	return copied;
 
 out:
-	release_sock(sk);
 	return err;
 
 recv_urg:
@@ -2323,6 +2301,36 @@ int tcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int nonblock,
 	err = tcp_peek_sndq(sk, msg, len);
 	goto out;
 }
+
+int tcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int nonblock,
+		int flags, int *addr_len)
+{
+	int cmsg_flags = 0, ret, inq;
+	struct scm_timestamping_internal tss;
+
+	if (unlikely(flags & MSG_ERRQUEUE))
+		return inet_recv_error(sk, msg, len, addr_len);
+
+	if (sk_can_busy_loop(sk) &&
+	    skb_queue_empty_lockless(&sk->sk_receive_queue) &&
+	    sk->sk_state == TCP_ESTABLISHED)
+		sk_busy_loop(sk, nonblock);
+
+	lock_sock(sk);
+	ret = tcp_recvmsg_locked(sk, msg, len, nonblock, flags, &tss,
+				 &cmsg_flags);
+	release_sock(sk);
+
+	if (cmsg_flags && ret >= 0) {
+		if (cmsg_flags & 2)
+			tcp_recv_timestamp(msg, sk, &tss);
+		if (cmsg_flags & 1) {
+			inq = tcp_inq_hint(sk);
+			put_cmsg(msg, SOL_TCP, TCP_CM_INQ, sizeof(inq), &inq);
+		}
+	}
+	return ret;
+}
 EXPORT_SYMBOL(tcp_recvmsg);
 
 void tcp_set_state(struct sock *sk, int state)
-- 
2.29.2.222.g5d2a92d10f8-goog


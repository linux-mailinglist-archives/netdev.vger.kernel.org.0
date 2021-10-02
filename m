Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD01641F8C2
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 02:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232182AbhJBAjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 20:39:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232039AbhJBAjA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 20:39:00 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B607C061775;
        Fri,  1 Oct 2021 17:37:15 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id l16-20020a9d6a90000000b0053b71f7dc83so13555464otq.7;
        Fri, 01 Oct 2021 17:37:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HzPJUTvz/bSzmVaZOvd5k1WvBZ2gneG2hoQ0KV2QWMM=;
        b=l0Aq0T1Q52ty5Z/mS/FAQTvcAt9RIuLW3HPGRRxjv1iSxhur045hmVafhKFE3ADvPR
         bq8ZNQufBblKQ+lnCi9sJeWK4UOwUyOuMYoIM53ji42uBM70uqYNO+D/anVAmPMCYM2+
         Sj9Kz12I9ndfyTq2d/VNh4xIvlBZG+Z8afvhBEcYgBQmHuCucWw65GhQQLMf/v/6hwDy
         TPbd7Q/1q/heCSE3Z2BPMdvLtck/MJwsBImisKI2na2ONJ04fn9F7AyYtCas+KWW1MNy
         r26cqaVaU/TBmDrT90sDzKvmgMClEhDSLwJ+ttnrWB0vno+URdOagq602OQg1/UNo5mU
         DBcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HzPJUTvz/bSzmVaZOvd5k1WvBZ2gneG2hoQ0KV2QWMM=;
        b=rxrypXEGGgGbDMpMMWTKvhqrCnc/bDp5yXDYarBVp5iKbBpli4XS4W1U9TiB9dPYtS
         i2Bx9sGmBlTlRq3jmoeDTkhUB3CWs66AWoR3Or2271+thq9klzL3v8MqnYMboTVG2MBe
         2dsT7Bx2IKbUqCasCRCXxGAnp5qAbZpCWSisPLy5xGemj7/0W19Hj1bzPd19tMUyFGeB
         tD0AZhj9z1MO6Q9IkiGqutmoa2tiMbVjaQR9Md0kgljUkQmWpkteSUbMOZx7IHrusL75
         n+L0G8FzIIeMog7AYTBEOnci2xEwDYZVAyyKa+FwTlYC1HSXVUeBE1mjOSHiNA/vjvDu
         kcew==
X-Gm-Message-State: AOAM530uR9BPPN5yVHpdh/xTU28PrSMf6uZ0k6GgSjlSWHm2z3r9Ojto
        We/dQlQI+RohuQibw43jdZz9HcWBZIk=
X-Google-Smtp-Source: ABdhPJzBLnByCd79P4V7owzJmvo5J8jPbGVS5mA0paG1CUk1YcxYCunNl4cEuAlJKOvTlpYekZfEgA==
X-Received: by 2002:a9d:7751:: with SMTP id t17mr657360otl.276.1633135034728;
        Fri, 01 Oct 2021 17:37:14 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:a62e:a53d:c4bc:b137])
        by smtp.gmail.com with ESMTPSA id p18sm1545017otk.7.2021.10.01.17.37.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 17:37:14 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Yucong Sun <sunyucong@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf v3 3/4] net: implement ->sock_is_readable() for UDP and AF_UNIX
Date:   Fri,  1 Oct 2021 17:37:05 -0700
Message-Id: <20211002003706.11237-4-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211002003706.11237-1-xiyou.wangcong@gmail.com>
References: <20211002003706.11237-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Yucong noticed we can't poll() sockets in sockmap even
when they are the destination sockets of redirections.
This is because we never poll any psock queues in ->poll(),
except for TCP. With ->sock_is_readable() now we can
overwrite >sock_is_readable(), invoke and implement it for
both UDP and AF_UNIX sockets.

Reported-by: Yucong Sun <sunyucong@gmail.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/ipv4/udp.c      | 2 ++
 net/ipv4/udp_bpf.c  | 1 +
 net/unix/af_unix.c  | 4 ++++
 net/unix/unix_bpf.c | 2 ++
 4 files changed, 9 insertions(+)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 2a7825a5b842..4a7e15a43a68 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2866,6 +2866,8 @@ __poll_t udp_poll(struct file *file, struct socket *sock, poll_table *wait)
 	    !(sk->sk_shutdown & RCV_SHUTDOWN) && first_packet_length(sk) == -1)
 		mask &= ~(EPOLLIN | EPOLLRDNORM);
 
+	if (sk_is_readable(sk))
+		mask |= EPOLLIN | EPOLLRDNORM;
 	return mask;
 
 }
diff --git a/net/ipv4/udp_bpf.c b/net/ipv4/udp_bpf.c
index 7a1d5f473878..bbe6569c9ad3 100644
--- a/net/ipv4/udp_bpf.c
+++ b/net/ipv4/udp_bpf.c
@@ -114,6 +114,7 @@ static void udp_bpf_rebuild_protos(struct proto *prot, const struct proto *base)
 	*prot        = *base;
 	prot->close  = sock_map_close;
 	prot->recvmsg = udp_bpf_recvmsg;
+	prot->sock_is_readable = sk_msg_is_readable;
 }
 
 static void udp_bpf_check_v6_needs_rebuild(struct proto *ops)
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index f505b89bda6a..3e65d9f5531d 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -3029,6 +3029,8 @@ static __poll_t unix_poll(struct file *file, struct socket *sock, poll_table *wa
 	/* readable? */
 	if (!skb_queue_empty_lockless(&sk->sk_receive_queue))
 		mask |= EPOLLIN | EPOLLRDNORM;
+	if (sk_is_readable(sk))
+		mask |= EPOLLIN | EPOLLRDNORM;
 
 	/* Connection-based need to check for termination and startup */
 	if ((sk->sk_type == SOCK_STREAM || sk->sk_type == SOCK_SEQPACKET) &&
@@ -3068,6 +3070,8 @@ static __poll_t unix_dgram_poll(struct file *file, struct socket *sock,
 	/* readable? */
 	if (!skb_queue_empty_lockless(&sk->sk_receive_queue))
 		mask |= EPOLLIN | EPOLLRDNORM;
+	if (sk_is_readable(sk))
+		mask |= EPOLLIN | EPOLLRDNORM;
 
 	/* Connection-based need to check for termination and startup */
 	if (sk->sk_type == SOCK_SEQPACKET) {
diff --git a/net/unix/unix_bpf.c b/net/unix/unix_bpf.c
index b927e2baae50..452376c6f419 100644
--- a/net/unix/unix_bpf.c
+++ b/net/unix/unix_bpf.c
@@ -102,6 +102,7 @@ static void unix_dgram_bpf_rebuild_protos(struct proto *prot, const struct proto
 	*prot        = *base;
 	prot->close  = sock_map_close;
 	prot->recvmsg = unix_bpf_recvmsg;
+	prot->sock_is_readable = sk_msg_is_readable;
 }
 
 static void unix_stream_bpf_rebuild_protos(struct proto *prot,
@@ -110,6 +111,7 @@ static void unix_stream_bpf_rebuild_protos(struct proto *prot,
 	*prot        = *base;
 	prot->close  = sock_map_close;
 	prot->recvmsg = unix_bpf_recvmsg;
+	prot->sock_is_readable = sk_msg_is_readable;
 	prot->unhash  = sock_map_unhash;
 }
 
-- 
2.30.2


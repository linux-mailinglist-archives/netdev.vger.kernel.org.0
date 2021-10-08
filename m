Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B31AF427257
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 22:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242845AbhJHUfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 16:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242687AbhJHUfR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 16:35:17 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 218ECC061570;
        Fri,  8 Oct 2021 13:33:22 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id bk7so1669636qkb.13;
        Fri, 08 Oct 2021 13:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CYvMgF3Mg6V2OX7HnsOshqPQnZjQe8a0VLiCDJf1sy8=;
        b=H3P8aXRB9l5j4qQlBtSvUFf3J+Bfw8CHV3NpqyKZxkK7mYVIKJmcwqzatHQzYYVJOt
         YLcwwYllLsOVA0rs4DBq60Tr8oWTUxG63FxjRhUQFAsqPsWiBvx199wg/nSgrUR2HJ1L
         /SH9npr56DrN8r4OHUrTmBcunXA08SCDJNuevi5rWaaOzVLmxXgmm/F6VoPgFwzElKKU
         j5iTD5v9abh6l3DVSx7LUlhAs3Ds/3ED6VCDs/tsSHXSiWi+b29rXJRydFsRfXN09Vbe
         3QpIBSvSyK76ixXBqdv5aGbk0igK9G4M76kPCcdpXq375CrNqMkQku0mB2t5JD68ZkDp
         ndUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CYvMgF3Mg6V2OX7HnsOshqPQnZjQe8a0VLiCDJf1sy8=;
        b=FehE4IItKXQ95zFNgEdeCXGQ1ol/mpCcEkDVVnqQoYSYikz0dtCroEsyyo15pV1VC9
         gyOmqGlGmAzqdJoXSS296iaOnYagXKHeQ5DfmCPCEsFHXf5R3CX1mCbo/sS2zvyllvXK
         62CJNou7Kz5fwc0Mh5nL9o+Zv2Z+aKBGx2ySzLK1o+ybs/1hIovibeNVcAAVY3C96Gbf
         KlTR0k8mjjsNY53HbhBwpe+EN41F85gCPfjbuq6Ra30LMbS28vMB6GdwtAbV1aIcIKBu
         Av9nfkNQRYpil2xqkQ7WOr3kq18q8OZCj58oqpRYxqN5xrbcXqSRolf/erlV2HclQOwV
         mvEQ==
X-Gm-Message-State: AOAM530/8vqY9His86a6Bw+JoLPBuRSFSiemHO9m/WGEYVqkQWEwxqZc
        GgmR9Q4bwwUyneWl4Ehb8jS8mTJBk2Y=
X-Google-Smtp-Source: ABdhPJzrWWXH+h7JaIsRQpOWRR4LdVjzGpQrvobGBDFmoigDqibKoBQyvywykHvloAF5R9COgfNLSA==
X-Received: by 2002:a37:a944:: with SMTP id s65mr4708867qke.263.1633725201025;
        Fri, 08 Oct 2021 13:33:21 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:795f:367d:1f1e:4801])
        by smtp.gmail.com with ESMTPSA id c8sm381945qtb.9.2021.10.08.13.33.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 13:33:20 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Yucong Sun <sunyucong@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf v4 3/4] net: implement ->sock_is_readable() for UDP and AF_UNIX
Date:   Fri,  8 Oct 2021 13:33:05 -0700
Message-Id: <20211008203306.37525-4-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211008203306.37525-1-xiyou.wangcong@gmail.com>
References: <20211008203306.37525-1-xiyou.wangcong@gmail.com>
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
 net/ipv4/udp.c      | 3 +++
 net/ipv4/udp_bpf.c  | 1 +
 net/unix/af_unix.c  | 4 ++++
 net/unix/unix_bpf.c | 2 ++
 4 files changed, 10 insertions(+)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 8536b2a7210b..2fffcf2b54f3 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2867,6 +2867,9 @@ __poll_t udp_poll(struct file *file, struct socket *sock, poll_table *wait)
 	    !(sk->sk_shutdown & RCV_SHUTDOWN) && first_packet_length(sk) == -1)
 		mask &= ~(EPOLLIN | EPOLLRDNORM);
 
+	/* psock ingress_msg queue should not contain any bad checksum frames */
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
index 0878ab86597b..9e62d83ffd3e 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -3052,6 +3052,8 @@ static __poll_t unix_poll(struct file *file, struct socket *sock, poll_table *wa
 	/* readable? */
 	if (!skb_queue_empty_lockless(&sk->sk_receive_queue))
 		mask |= EPOLLIN | EPOLLRDNORM;
+	if (sk_is_readable(sk))
+		mask |= EPOLLIN | EPOLLRDNORM;
 
 	/* Connection-based need to check for termination and startup */
 	if ((sk->sk_type == SOCK_STREAM || sk->sk_type == SOCK_SEQPACKET) &&
@@ -3091,6 +3093,8 @@ static __poll_t unix_dgram_poll(struct file *file, struct socket *sock,
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


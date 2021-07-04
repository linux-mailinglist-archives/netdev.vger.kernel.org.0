Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 490763BAE82
	for <lists+netdev@lfdr.de>; Sun,  4 Jul 2021 21:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbhGDTFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Jul 2021 15:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbhGDTFp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Jul 2021 15:05:45 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD280C061762;
        Sun,  4 Jul 2021 12:03:08 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id 10so3554099oiq.9;
        Sun, 04 Jul 2021 12:03:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bDERu2k2qh4yLQIjY6JR0wS/RgqKkVi34LrMb4kp8OA=;
        b=M0Pw6ylYNuhgLplLwYQK2eTOR7D1uT7nQsWDDqwBPPhrR/TuVKoCYSaybogjW5/KsE
         YZ+CZGkZmowL9zSzxTdzcx+wlzYK81NvOImzd1ng/ljba5owvpd9buGub0S/A8t3hF/l
         IOgrtgnRmVKlErKKjI6Hk+4RRQln26vLgb60Ur3ARle7bl8xGbwOzkERbog2jZGe4smI
         oaHH1U4IMcCfinf5MdRXDW3M3IJE6RnlXdV/i15R8Cc5SGiZfG8Pm/nPGFs9Qxjc1pHp
         gmhuOwIniB2wSoff9HtxKv533s/ZRi4YGfxJFL0whEO0U6DKfV1IORuov3L06H4HFcM4
         8Irw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bDERu2k2qh4yLQIjY6JR0wS/RgqKkVi34LrMb4kp8OA=;
        b=qLgZ23iV6TUbvIsDhyruUQjUPfjGc6nKcHmIpxtU6N4bfPm3Hcog0w3v/niU5JzAOC
         oTZrBkjWr/cnLyLJuAR+GFeaV0PI/KYKSB4xOKlXuSsOWlMf2tSwmmR+/6YGBwWIHWVn
         kWkihLPq43RPSLG+9KbUPaxfyA4tkGMCvaQRxJTjYZ/Ix3Cn32jide21606KZlQDJ1uC
         2OIqlhPKu/KMjiXAjQsb6PvEHTjGM+GvQfRGwUbl0fHmYExn7cV4ijoe88Xp7eFs1aiK
         Harv/9f4YzpQkyzbhdoPhCiodaaRTPJUdxV8vwP889Y6WZ3TXeFJdUK3EUBe6Dpsk7FB
         scpg==
X-Gm-Message-State: AOAM5326WhxZwtZEw06uFHj4qLInSgE7SqOMeicHev6L+QBimGxtZYLA
        U/mDrdqm0mv/SXHHl61uHnwBEJpIXP0=
X-Google-Smtp-Source: ABdhPJylYnH4wsGB2A4n9yoyvDw6gO0KP7qB5bTI+s7VfrsmTOdAnivCRSDgufjle7/N8905v+iOfw==
X-Received: by 2002:aca:4482:: with SMTP id r124mr7581257oia.153.1625425388171;
        Sun, 04 Jul 2021 12:03:08 -0700 (PDT)
Received: from unknown.attlocal.net (76-217-55-94.lightspeed.sntcca.sbcglobal.net. [76.217.55.94])
        by smtp.gmail.com with ESMTPSA id 186sm1865848ooe.28.2021.07.04.12.03.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jul 2021 12:03:07 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf-next v5 02/11] sock_map: lift socket state restriction for datagram sockets
Date:   Sun,  4 Jul 2021 12:02:43 -0700
Message-Id: <20210704190252.11866-3-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210704190252.11866-1-xiyou.wangcong@gmail.com>
References: <20210704190252.11866-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

TCP and other connection oriented sockets have accept()
for each incoming connection on the server side, hence
they can just insert those fd's from accept() to sockmap,
which are of course established.

Now with datagram sockets begin to support sockmap and
redirection, the restriction is no longer applicable to
them, as they have no accept(). So we have to lift this
restriction for them. This is fine, because inside
bpf_sk_redirect_map() we still have another socket status
check, sock_map_redirect_allowed(), as a guard.

This also means they do not have to be removed from
sockmap when disconnecting.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/core/sock_map.c                           | 21 +------------------
 net/ipv4/udp_bpf.c                            |  1 -
 .../selftests/bpf/prog_tests/sockmap_listen.c |  8 ++++---
 3 files changed, 6 insertions(+), 24 deletions(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 60decd6420ca..3c427e7e6df9 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -211,8 +211,6 @@ static struct sk_psock *sock_map_psock_get_checked(struct sock *sk)
 	return psock;
 }
 
-static bool sock_map_redirect_allowed(const struct sock *sk);
-
 static int sock_map_link(struct bpf_map *map, struct sock *sk)
 {
 	struct sk_psock_progs *progs = sock_map_progs(map);
@@ -223,13 +221,6 @@ static int sock_map_link(struct bpf_map *map, struct sock *sk)
 	struct sk_psock *psock;
 	int ret;
 
-	/* Only sockets we can redirect into/from in BPF need to hold
-	 * refs to parser/verdict progs and have their sk_data_ready
-	 * and sk_write_space callbacks overridden.
-	 */
-	if (!sock_map_redirect_allowed(sk))
-		goto no_progs;
-
 	stream_verdict = READ_ONCE(progs->stream_verdict);
 	if (stream_verdict) {
 		stream_verdict = bpf_prog_inc_not_zero(stream_verdict);
@@ -264,7 +255,6 @@ static int sock_map_link(struct bpf_map *map, struct sock *sk)
 		}
 	}
 
-no_progs:
 	psock = sock_map_psock_get_checked(sk);
 	if (IS_ERR(psock)) {
 		ret = PTR_ERR(psock);
@@ -527,12 +517,6 @@ static bool sk_is_tcp(const struct sock *sk)
 	       sk->sk_protocol == IPPROTO_TCP;
 }
 
-static bool sk_is_udp(const struct sock *sk)
-{
-	return sk->sk_type == SOCK_DGRAM &&
-	       sk->sk_protocol == IPPROTO_UDP;
-}
-
 static bool sock_map_redirect_allowed(const struct sock *sk)
 {
 	if (sk_is_tcp(sk))
@@ -550,10 +534,7 @@ static bool sock_map_sk_state_allowed(const struct sock *sk)
 {
 	if (sk_is_tcp(sk))
 		return (1 << sk->sk_state) & (TCPF_ESTABLISHED | TCPF_LISTEN);
-	else if (sk_is_udp(sk))
-		return sk_hashed(sk);
-
-	return false;
+	return true;
 }
 
 static int sock_hash_update_common(struct bpf_map *map, void *key,
diff --git a/net/ipv4/udp_bpf.c b/net/ipv4/udp_bpf.c
index 45b8782aec0c..cb1d113ce6fd 100644
--- a/net/ipv4/udp_bpf.c
+++ b/net/ipv4/udp_bpf.c
@@ -112,7 +112,6 @@ static struct proto udp_bpf_prots[UDP_BPF_NUM_PROTS];
 static void udp_bpf_rebuild_protos(struct proto *prot, const struct proto *base)
 {
 	*prot        = *base;
-	prot->unhash = sock_map_unhash;
 	prot->close  = sock_map_close;
 	prot->recvmsg = udp_bpf_recvmsg;
 }
diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
index 515229f24a93..b8934ae694e5 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
@@ -351,9 +351,11 @@ static void test_insert_opened(int family, int sotype, int mapfd)
 	errno = 0;
 	value = s;
 	err = bpf_map_update_elem(mapfd, &key, &value, BPF_NOEXIST);
-	if (!err || errno != EOPNOTSUPP)
-		FAIL_ERRNO("map_update: expected EOPNOTSUPP");
-
+	if (sotype == SOCK_STREAM) {
+		if (!err || errno != EOPNOTSUPP)
+			FAIL_ERRNO("map_update: expected EOPNOTSUPP");
+	} else if (err)
+		FAIL_ERRNO("map_update: expected success");
 	xclose(s);
 }
 
-- 
2.27.0


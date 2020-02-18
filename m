Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19D72162BAF
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 18:10:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbgBRRKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 12:10:38 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41436 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726847AbgBRRKg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 12:10:36 -0500
Received: by mail-wr1-f66.google.com with SMTP id c9so24906222wrw.8
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 09:10:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CjSlu/lOnptTh+Zx1yeQA7ma7ofo9FuDmUeqTd8NUSA=;
        b=mN1zQHyJ2PyzjX7v3ky8hQKPl9cznU1ZaO7/1SYIcfTjeznLBpUhLas4keNsjc2UTk
         ki71HMqIBMqV2XKQh2RgyBC133n2y/6cIEklJYy98lfuPiX5XShPryg5VaReA4PhkbLa
         GhYhLgxIfsMnoqgOnFTZSGqWg+MlenaBHAjAQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CjSlu/lOnptTh+Zx1yeQA7ma7ofo9FuDmUeqTd8NUSA=;
        b=IDsMdEmqbUcTzggzg7hGuopqbW34gHvAn+/F92Mv7n6cfmDl7Xfkp7krfzBQnyLth5
         Chk3SHc3TFPK7O0UzT5JP3F2/jAqzEVBZdUs6G1PpOSMPD/tSOXeiOna5KAiTokDvn3F
         KtkTlAvJDp86G2xhWXk7BSO09FeSm6AVCHZN0RDkcqnDUpoIjsdv0Wt982khdk34n+45
         J4ISPoBspMKa8tMi+BSkI9c06hJXbrRqIZIGBaW5AVaR37E6MapR3kfFtSGrR2PA6oWE
         kzFKvjeQBOT1enNKOtMZ4DY2e35VFzX8LOFu7QM5FL6LlB96R30Q+Lh8jQogfXLpS81f
         5BFg==
X-Gm-Message-State: APjAAAVsEhm14Yi/jFlShPU8QpbfWZtU+A71QkPwcgim6i9WoGw7Ftqd
        Upiq5wJlm95Ywdn9rpUe6Jw2Zg==
X-Google-Smtp-Source: APXvYqzph/CuSVMUcP6sAV0d25nptIjOOhSXPJJelyhUGqKs1X5oG89mnpikKKLIpBUPR9Po3H0BEg==
X-Received: by 2002:adf:bc87:: with SMTP id g7mr30552988wrh.121.1582045833575;
        Tue, 18 Feb 2020 09:10:33 -0800 (PST)
Received: from cloudflare.com ([88.157.168.82])
        by smtp.gmail.com with ESMTPSA id 133sm4551621wmd.5.2020.02.18.09.10.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 09:10:33 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, Martin Lau <kafai@fb.com>
Subject: [PATCH bpf-next v7 05/11] bpf, sockmap: Don't set up upcalls and progs for listening sockets
Date:   Tue, 18 Feb 2020 17:10:17 +0000
Message-Id: <20200218171023.844439-6-jakub@cloudflare.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200218171023.844439-1-jakub@cloudflare.com>
References: <20200218171023.844439-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that sockmap/sockhash can hold listening sockets, when setting up the
psock we will (i) grab references to verdict/parser progs, and (2) override
socket upcalls sk_data_ready and sk_write_space.

However, since we cannot redirect to listening sockets so we don't need to
link the socket to the BPF progs. And more importantly we don't want the
listening socket to have overridden upcalls because they would get
inherited by child sockets cloned from it.

Introduce a separate initialization path for listening sockets that does
not change the upcalls and ignores the BPF progs.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 net/core/sock_map.c | 52 +++++++++++++++++++++++++++++++++++++++------
 1 file changed, 45 insertions(+), 7 deletions(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index dd92a3556d73..a5103112a344 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -228,6 +228,30 @@ static int sock_map_link(struct bpf_map *map, struct sk_psock_progs *progs,
 	return ret;
 }
 
+static int sock_map_link_no_progs(struct bpf_map *map, struct sock *sk)
+{
+	struct sk_psock *psock;
+	int ret;
+
+	psock = sk_psock_get_checked(sk);
+	if (IS_ERR(psock))
+		return PTR_ERR(psock);
+
+	if (psock) {
+		tcp_bpf_reinit(sk);
+		return 0;
+	}
+
+	psock = sk_psock_init(sk, map->numa_node);
+	if (!psock)
+		return -ENOMEM;
+
+	ret = tcp_bpf_init(sk);
+	if (ret < 0)
+		sk_psock_put(sk, psock);
+	return ret;
+}
+
 static void sock_map_free(struct bpf_map *map)
 {
 	struct bpf_stab *stab = container_of(map, struct bpf_stab, map);
@@ -334,6 +358,11 @@ static int sock_map_get_next_key(struct bpf_map *map, void *key, void *next)
 	return 0;
 }
 
+static bool sock_map_redirect_allowed(const struct sock *sk)
+{
+	return sk->sk_state != TCP_LISTEN;
+}
+
 static int sock_map_update_common(struct bpf_map *map, u32 idx,
 				  struct sock *sk, u64 flags)
 {
@@ -356,7 +385,14 @@ static int sock_map_update_common(struct bpf_map *map, u32 idx,
 	if (!link)
 		return -ENOMEM;
 
-	ret = sock_map_link(map, &stab->progs, sk);
+	/* Only sockets we can redirect into/from in BPF need to hold
+	 * refs to parser/verdict progs and have their sk_data_ready
+	 * and sk_write_space callbacks overridden.
+	 */
+	if (sock_map_redirect_allowed(sk))
+		ret = sock_map_link(map, &stab->progs, sk);
+	else
+		ret = sock_map_link_no_progs(map, sk);
 	if (ret < 0)
 		goto out_free;
 
@@ -406,11 +442,6 @@ static bool sock_map_sk_state_allowed(const struct sock *sk)
 	return (1 << sk->sk_state) & (TCPF_ESTABLISHED | TCPF_LISTEN);
 }
 
-static bool sock_map_redirect_allowed(const struct sock *sk)
-{
-	return sk->sk_state != TCP_LISTEN;
-}
-
 static int sock_map_update_elem(struct bpf_map *map, void *key,
 				void *value, u64 flags)
 {
@@ -700,7 +731,14 @@ static int sock_hash_update_common(struct bpf_map *map, void *key,
 	if (!link)
 		return -ENOMEM;
 
-	ret = sock_map_link(map, &htab->progs, sk);
+	/* Only sockets we can redirect into/from in BPF need to hold
+	 * refs to parser/verdict progs and have their sk_data_ready
+	 * and sk_write_space callbacks overridden.
+	 */
+	if (sock_map_redirect_allowed(sk))
+		ret = sock_map_link(map, &htab->progs, sk);
+	else
+		ret = sock_map_link_no_progs(map, sk);
 	if (ret < 0)
 		goto out_free;
 
-- 
2.24.1


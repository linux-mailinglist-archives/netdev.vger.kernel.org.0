Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27B8F34F6C8
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 04:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233484AbhCaCdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 22:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233411AbhCaCc5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 22:32:57 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DD62C061574;
        Tue, 30 Mar 2021 19:32:57 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id y19-20020a0568301d93b02901b9f88a238eso17551924oti.11;
        Tue, 30 Mar 2021 19:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eV9B2QnitCddGO0nj6V/hwG740QNXO2GVWdy3iY1rK8=;
        b=W5SqZGz5ex6DpRpip8TagcaHzh7QO5IqIITTzTAwPtW/E7mr9y0qF+SVEMmdFULAp7
         QU0GBYwVyIQAwVdr6qFZ7vA7wQYUJ8WFnHM21M8DMsXCT/klt014840j+C2LZmvvBWkV
         ARZtkppWc4maz2AIIa5jIgivyoI4/+GBQ7TG0gcoI4CMPyefoB3PeOV0TyIUYdvL+rHE
         LnxIUg+a+0SQTXPjCRPPFSyO2yR0P3N35F5n/hltlt9JzKCRjs2+ReO0CyEytHl8nA/4
         cRIDKPR27jWmdahbYU2vrGrgo8SnN1ghstNK/7NomlRgVfeUWinlgACX2687L4GQMH7b
         UOEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eV9B2QnitCddGO0nj6V/hwG740QNXO2GVWdy3iY1rK8=;
        b=J/Em9nEJNzyqK3kcgOznY54OrWsoEZTX5v0NsNWEzr8lEIgNI+NCIHPKj5kxzLiOQE
         WQ0QFu91PFXx4gXZ+Id1hzfsn2RjQzLHnhjIwqBti6D0FY9B8iiJDX8Y6lnxynDqX7ef
         M7gbDyH6uHZGVJn7UFJr2EazDMW2CPeElYf3qlhzloX5OSLeZjBtIl7byp/y+zkkSZ4j
         0xzIwG1G2Dn4bClEQufURXSfVf628gFh0Y0fXZp9NjfjdFkXfdKTANJd3tLoQpRqkFs6
         FCkFqE68uhHiMFnPeX1why0P4F1tCdmpoyuVKzsa20PQdw5/gTYfpkSPIrhwn+YH49fI
         ZQEQ==
X-Gm-Message-State: AOAM5314glak06rEN/XHSqjVR1fTjuYDqwrkCDM7QEGoa6Zc3t3UL7/Q
        6VnFir/cBJYRq9zLGgnSEYItttXBvkfx2g==
X-Google-Smtp-Source: ABdhPJxLLLNvq5B/Fbm+tI+py5eRYLmeL1o3zN1/MJk/VAV4FWJrR49yCDhc8LF45n9C49Ib5xIIgA==
X-Received: by 2002:a05:6830:1c6e:: with SMTP id s14mr769987otg.17.1617157976749;
        Tue, 30 Mar 2021 19:32:56 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:a099:767b:2b62:48df])
        by smtp.gmail.com with ESMTPSA id 7sm188125ois.20.2021.03.30.19.32.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Mar 2021 19:32:56 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [Patch bpf-next v8 08/16] sock_map: kill sock_map_link_no_progs()
Date:   Tue, 30 Mar 2021 19:32:29 -0700
Message-Id: <20210331023237.41094-9-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210331023237.41094-1-xiyou.wangcong@gmail.com>
References: <20210331023237.41094-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Now we can fold sock_map_link_no_progs() into sock_map_link()
and get rid of sock_map_link_no_progs().

Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/core/sock_map.c | 55 +++++++++++++--------------------------------
 1 file changed, 15 insertions(+), 40 deletions(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index d06face0f16c..42d797291d34 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -225,13 +225,24 @@ static struct sk_psock *sock_map_psock_get_checked(struct sock *sk)
 	return psock;
 }
 
+static bool sock_map_redirect_allowed(const struct sock *sk);
+
 static int sock_map_link(struct bpf_map *map, struct sock *sk)
 {
-	struct bpf_prog *msg_parser, *stream_parser, *stream_verdict;
 	struct sk_psock_progs *progs = sock_map_progs(map);
+	struct bpf_prog *stream_verdict = NULL;
+	struct bpf_prog *stream_parser = NULL;
+	struct bpf_prog *msg_parser = NULL;
 	struct sk_psock *psock;
 	int ret;
 
+	/* Only sockets we can redirect into/from in BPF need to hold
+	 * refs to parser/verdict progs and have their sk_data_ready
+	 * and sk_write_space callbacks overridden.
+	 */
+	if (!sock_map_redirect_allowed(sk))
+		goto no_progs;
+
 	stream_verdict = READ_ONCE(progs->stream_verdict);
 	if (stream_verdict) {
 		stream_verdict = bpf_prog_inc_not_zero(stream_verdict);
@@ -257,6 +268,7 @@ static int sock_map_link(struct bpf_map *map, struct sock *sk)
 		}
 	}
 
+no_progs:
 	psock = sock_map_psock_get_checked(sk);
 	if (IS_ERR(psock)) {
 		ret = PTR_ERR(psock);
@@ -316,27 +328,6 @@ static int sock_map_link(struct bpf_map *map, struct sock *sk)
 	return ret;
 }
 
-static int sock_map_link_no_progs(struct bpf_map *map, struct sock *sk)
-{
-	struct sk_psock *psock;
-	int ret;
-
-	psock = sock_map_psock_get_checked(sk);
-	if (IS_ERR(psock))
-		return PTR_ERR(psock);
-
-	if (!psock) {
-		psock = sk_psock_init(sk, map->numa_node);
-		if (IS_ERR(psock))
-			return PTR_ERR(psock);
-	}
-
-	ret = sock_map_init_proto(sk, psock);
-	if (ret < 0)
-		sk_psock_put(sk, psock);
-	return ret;
-}
-
 static void sock_map_free(struct bpf_map *map)
 {
 	struct bpf_stab *stab = container_of(map, struct bpf_stab, map);
@@ -467,8 +458,6 @@ static int sock_map_get_next_key(struct bpf_map *map, void *key, void *next)
 	return 0;
 }
 
-static bool sock_map_redirect_allowed(const struct sock *sk);
-
 static int sock_map_update_common(struct bpf_map *map, u32 idx,
 				  struct sock *sk, u64 flags)
 {
@@ -488,14 +477,7 @@ static int sock_map_update_common(struct bpf_map *map, u32 idx,
 	if (!link)
 		return -ENOMEM;
 
-	/* Only sockets we can redirect into/from in BPF need to hold
-	 * refs to parser/verdict progs and have their sk_data_ready
-	 * and sk_write_space callbacks overridden.
-	 */
-	if (sock_map_redirect_allowed(sk))
-		ret = sock_map_link(map, sk);
-	else
-		ret = sock_map_link_no_progs(map, sk);
+	ret = sock_map_link(map, sk);
 	if (ret < 0)
 		goto out_free;
 
@@ -1000,14 +982,7 @@ static int sock_hash_update_common(struct bpf_map *map, void *key,
 	if (!link)
 		return -ENOMEM;
 
-	/* Only sockets we can redirect into/from in BPF need to hold
-	 * refs to parser/verdict progs and have their sk_data_ready
-	 * and sk_write_space callbacks overridden.
-	 */
-	if (sock_map_redirect_allowed(sk))
-		ret = sock_map_link(map, sk);
-	else
-		ret = sock_map_link_no_progs(map, sk);
+	ret = sock_map_link(map, sk);
 	if (ret < 0)
 		goto out_free;
 
-- 
2.25.1


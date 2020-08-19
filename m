Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD8A249978
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 11:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727868AbgHSJiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 05:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbgHSJhu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 05:37:50 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6D35C061344
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 02:37:48 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id c15so20782892wrs.11
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 02:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WiWRWCNZNwwliRoiTcSOlw+lhqkkpwfiYRA5mQGxIvs=;
        b=Ik1xBFOYB1oLNrhbKRJfScNWGubdlq191L2B4NjYIPulQZJcQPCjvxJfSPRW4zp0GK
         HPn5WDA1HimM6dkKxefxcxZncDhCNvZeh4drUEtFPScHtgaCGPslxL5MYxGcPi1H24uN
         3IL4QxUHMPqQPMZtocn1D1Y4izV7fpIxZaiPs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WiWRWCNZNwwliRoiTcSOlw+lhqkkpwfiYRA5mQGxIvs=;
        b=rjIEjlHzLsvl8wnfuT8ef7v+LsPLcLtygAp7W/nqHI29qEclzSQVA7D/iTpTQOedX2
         1uiLVHt90P3fFHxLmzsnsUNMBX2ZTYmVtqBIaLIabDhBf8kwsrhriaPmCAj1QB9thQGU
         miGZW89Gyng9AsX2QTqAVN3VvEjGTMZJewnWvNQfEorACSrNJrU42MR6+M9DoHDzBdBb
         P3uO0ApBv7mNqEDmdY6ObJCeFC+KKjL0/OoS252+zucipAJo84LDr7BSUNg0Kvn4Iv+V
         zo9T1yAmXLzQGnov0DtnnI8tT56I5TQle/RTJxwMXpe0TTb86dwCdpAEMPWCz4e0/1nA
         2gVw==
X-Gm-Message-State: AOAM533IA8t41GZkxQqKnagrD1F47aYLNI5ldb77DAkB0wqJdfoB7EQz
        oxLhsTNdofTY9APZWGGImuqJiA==
X-Google-Smtp-Source: ABdhPJySI28r+GBXPnpyhbIrRBb8xxRx5WXhP//f4XWwnNBnnNvfO5NxPeNkEKOgTPqNsb1zjAbBRg==
X-Received: by 2002:a5d:6381:: with SMTP id p1mr23604730wru.112.1597829867403;
        Wed, 19 Aug 2020 02:37:47 -0700 (PDT)
Received: from antares.lan (c.d.0.4.4.2.3.3.e.9.1.6.6.d.0.6.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:60d6:619e:3324:40dc])
        by smtp.gmail.com with ESMTPSA id 3sm4204565wms.36.2020.08.19.02.37.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 02:37:46 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     jakub@cloudflare.com, john.fastabend@gmail.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next 2/6] bpf: sockmap: merge sockmap and sockhash update functions
Date:   Wed, 19 Aug 2020 10:24:32 +0100
Message-Id: <20200819092436.58232-3-lmb@cloudflare.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200819092436.58232-1-lmb@cloudflare.com>
References: <20200819092436.58232-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Merge the two very similar functions sock_map_update_elem and
sock_hash_update_elem into one.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 net/core/sock_map.c | 53 ++++++++-------------------------------------
 1 file changed, 9 insertions(+), 44 deletions(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index abe4bac40db9..f464a0ebc871 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -559,10 +559,12 @@ static bool sock_map_sk_state_allowed(const struct sock *sk)
 	return false;
 }
 
-static int sock_map_update_elem(struct bpf_map *map, void *key,
-				void *value, u64 flags)
+static int sock_hash_update_common(struct bpf_map *map, void *key,
+				   struct sock *sk, u64 flags);
+
+int sock_map_update_elem(struct bpf_map *map, void *key,
+			 void *value, u64 flags)
 {
-	u32 idx = *(u32 *)key;
 	struct socket *sock;
 	struct sock *sk;
 	int ret;
@@ -591,8 +593,10 @@ static int sock_map_update_elem(struct bpf_map *map, void *key,
 	sock_map_sk_acquire(sk);
 	if (!sock_map_sk_state_allowed(sk))
 		ret = -EOPNOTSUPP;
+	else if (map->map_type == BPF_MAP_TYPE_SOCKMAP)
+		ret = sock_map_update_common(map, *(u32 *)key, sk, flags);
 	else
-		ret = sock_map_update_common(map, idx, sk, flags);
+		ret = sock_hash_update_common(map, key, sk, flags);
 	sock_map_sk_release(sk);
 out:
 	fput(sock->file);
@@ -909,45 +913,6 @@ static int sock_hash_update_common(struct bpf_map *map, void *key,
 	return ret;
 }
 
-static int sock_hash_update_elem(struct bpf_map *map, void *key,
-				 void *value, u64 flags)
-{
-	struct socket *sock;
-	struct sock *sk;
-	int ret;
-	u64 ufd;
-
-	if (map->value_size == sizeof(u64))
-		ufd = *(u64 *)value;
-	else
-		ufd = *(u32 *)value;
-	if (ufd > S32_MAX)
-		return -EINVAL;
-
-	sock = sockfd_lookup(ufd, &ret);
-	if (!sock)
-		return ret;
-	sk = sock->sk;
-	if (!sk) {
-		ret = -EINVAL;
-		goto out;
-	}
-	if (!sock_map_sk_is_suitable(sk)) {
-		ret = -EOPNOTSUPP;
-		goto out;
-	}
-
-	sock_map_sk_acquire(sk);
-	if (!sock_map_sk_state_allowed(sk))
-		ret = -EOPNOTSUPP;
-	else
-		ret = sock_hash_update_common(map, key, sk, flags);
-	sock_map_sk_release(sk);
-out:
-	fput(sock->file);
-	return ret;
-}
-
 static int sock_hash_get_next_key(struct bpf_map *map, void *key,
 				  void *key_next)
 {
@@ -1216,7 +1181,7 @@ const struct bpf_map_ops sock_hash_ops = {
 	.map_alloc		= sock_hash_alloc,
 	.map_free		= sock_hash_free,
 	.map_get_next_key	= sock_hash_get_next_key,
-	.map_update_elem	= sock_hash_update_elem,
+	.map_update_elem	= sock_map_update_elem,
 	.map_delete_elem	= sock_hash_delete_elem,
 	.map_lookup_elem	= sock_hash_lookup,
 	.map_lookup_elem_sys_only = sock_hash_lookup_sys,
-- 
2.25.1


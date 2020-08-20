Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95CE624C021
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 16:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728938AbgHTOI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 10:08:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731171AbgHTN6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 09:58:19 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E979EC061344
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 06:58:07 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id r2so2111320wrs.8
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 06:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dIlmZJB9+eDgtcHSXwLK+yE9xrsf8loBEu9kCmv2aII=;
        b=ISzJ/yiz5+C1y/r+rRZ0TH2WqW8foBXQtXCtMXa3Ni88vEdoiMbBvipWviQ5t6C7U+
         ORFWwpN8EzD38dgFERXavPfGAQat4AxfLfBVhlOMlqMqevnkYtJalb12WuMsaDkzuLbZ
         BCq0OrLB3+/+Pwp7+CpmjceQJ6GuZBxxXxT9k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dIlmZJB9+eDgtcHSXwLK+yE9xrsf8loBEu9kCmv2aII=;
        b=gCQsFYoUSxiRFLpaDTGb2/XNpESoqmvzqLUgybT0BGnef4iESavvtMj6bD/fygbkxk
         F8tpbvNL5Ya63E3JAHzdqOvQkzQF6Zds1aQTjKEhU4uqAoYfuA2hErI7dHSk/890t27n
         dLmfW5vJwQz43MrFnW2H37+GWjwyoksgiBiJ23tJx4xdnkPff6ue6h08R/wPztWM8TOT
         4GHG6rGXAGrCt9bKza/Rac3mf8u7iSLYPxtrEEQGAsRLkA+Cn7FC+LjRqal97eMfeDGD
         YQwn4t51/UWodWC1dRUlbC7GBCrObJwDiKZdatc6iDqW206BsuUiRA5teUN8fRskHILj
         Zxeg==
X-Gm-Message-State: AOAM532CDJJdoYPp0vxXtjTaqHguwXmjBhPTMxcjUrt2zZyNW84lh6YX
        NenALGTA0WXA6XSNB6qE+s0srQ==
X-Google-Smtp-Source: ABdhPJy88DpUAqZntYnMkF6kISfRxqrYXFVdlbWXeJsDdhysjZI6wBEPNnqgskjI2emFz26INYdKOg==
X-Received: by 2002:a5d:4bcf:: with SMTP id l15mr3325677wrt.384.1597931886563;
        Thu, 20 Aug 2020 06:58:06 -0700 (PDT)
Received: from antares.lan (d.0.f.e.b.c.7.2.d.c.3.8.4.8.d.9.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:9d84:83cd:27cb:ef0d])
        by smtp.gmail.com with ESMTPSA id l81sm4494215wmf.4.2020.08.20.06.58.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2020 06:58:06 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     jakub@cloudflare.com, john.fastabend@gmail.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v2 2/6] bpf: sockmap: merge sockmap and sockhash update functions
Date:   Thu, 20 Aug 2020 14:57:25 +0100
Message-Id: <20200820135729.135783-3-lmb@cloudflare.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200820135729.135783-1-lmb@cloudflare.com>
References: <20200820135729.135783-1-lmb@cloudflare.com>
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
 net/core/sock_map.c | 49 +++++++--------------------------------------
 1 file changed, 7 insertions(+), 42 deletions(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index abe4bac40db9..905e2dd765aa 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -559,10 +559,12 @@ static bool sock_map_sk_state_allowed(const struct sock *sk)
 	return false;
 }
 
+static int sock_hash_update_common(struct bpf_map *map, void *key,
+				   struct sock *sk, u64 flags);
+
 static int sock_map_update_elem(struct bpf_map *map, void *key,
 				void *value, u64 flags)
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


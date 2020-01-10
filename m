Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 017BE136B58
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 11:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727690AbgAJKum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 05:50:42 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44085 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727663AbgAJKul (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 05:50:41 -0500
Received: by mail-wr1-f66.google.com with SMTP id q10so1321543wrm.11
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 02:50:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oiPw4/6oV9rzvVkwxQAKnK2T2rCP9urPC1Q8lzDcz/I=;
        b=YVemnUSh/hhYJz9QyHUn/IruB64JX3lLsFdtMd/lEI+j7fL7zGIBBObu00xRfwft5O
         c3Fy1PASvKW/yDjp5zdP4LNZ12nYk4WFi14nvfYCaWublzMXQMF0H/itNZrKY+z4Y1Tt
         vP+z/yQYkSbaQLjdD6I4jvtEN2gwgSGCsE+wk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oiPw4/6oV9rzvVkwxQAKnK2T2rCP9urPC1Q8lzDcz/I=;
        b=IQ29Wd9yN4xnaxGdsK9Kxw2pJWdfpAemjFxcv3//GQNBmX06mVCW/fuLcpEA3jKptu
         5kZbFnFdFVafC+9AVoV2iPKQpBdqc6vcVNsVncEsEv3nZgHtyE/oHM1VuphDtiKT0WGB
         hh5/R0K/EWs3E0kKhsjVDsdYC1xE6B2Pnyx2M9XF0RDsku0W28lEh+zZg6GR8+joE/ML
         A9m0HNW5eifZUMPrrMzz16vrpiwQWY+ckyd5FW/xb45MkRQxOwjgm3F4XWhg24gcmWld
         BVffsjAF6g7yEyjLW9P6eORlQ1F7P5w4SNNulc3obVUgNSMnEGCZXOeIXLCT21IfdBVH
         M3ww==
X-Gm-Message-State: APjAAAX5UxM76UXb0e7ZbhkPjl++O+AP8ZQqLEM4nKrfdMA4Zk2gzRj/
        yGsksjzCAiTmB8A7aSpaptFg6Q==
X-Google-Smtp-Source: APXvYqy0h7vE+rp3xL+IBKMQEgddIMtMkVdFBIAyUfTfm/ENWo1vRchu8HPfJXr2xH46Y/SR8kAacw==
X-Received: by 2002:a5d:4f90:: with SMTP id d16mr2690138wru.395.1578653439053;
        Fri, 10 Jan 2020 02:50:39 -0800 (PST)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id 4sm1718626wmg.22.2020.01.10.02.50.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 02:50:38 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH bpf-next v2 07/11] bpf, sockmap: Return socket cookie on lookup from syscall
Date:   Fri, 10 Jan 2020 11:50:23 +0100
Message-Id: <20200110105027.257877-8-jakub@cloudflare.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200110105027.257877-1-jakub@cloudflare.com>
References: <20200110105027.257877-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tooling that populates the SOCKMAP with sockets from user-space needs a way
to inspect its contents. Returning the struct sock * that SOCKMAP holds to
user-space is neither safe nor useful. An approach established by
REUSEPORT_SOCKARRAY is to return a socket cookie (a unique identifier)
instead.

Since socket cookies are u64 values SOCKMAP needs to support such a value
size for lookup to be possible. This requires special handling on update,
though. Attempts to do a lookup on SOCKMAP holding u32 values will be met
with ENOSPC error.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 net/core/sock_map.c | 31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index d1a91e41ff82..3731191a7d1e 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -10,6 +10,7 @@
 #include <linux/skmsg.h>
 #include <linux/list.h>
 #include <linux/jhash.h>
+#include <linux/sock_diag.h>
 
 struct bpf_stab {
 	struct bpf_map map;
@@ -31,7 +32,8 @@ static struct bpf_map *sock_map_alloc(union bpf_attr *attr)
 		return ERR_PTR(-EPERM);
 	if (attr->max_entries == 0 ||
 	    attr->key_size    != 4 ||
-	    attr->value_size  != 4 ||
+	    (attr->value_size != sizeof(u32) &&
+	     attr->value_size != sizeof(u64)) ||
 	    attr->map_flags & ~SOCK_CREATE_FLAG_MASK)
 		return ERR_PTR(-EINVAL);
 
@@ -298,6 +300,23 @@ static void *sock_map_lookup(struct bpf_map *map, void *key)
 	return ERR_PTR(-EOPNOTSUPP);
 }
 
+static void *sock_map_lookup_sys(struct bpf_map *map, void *key)
+{
+	struct sock *sk;
+
+	WARN_ON_ONCE(!rcu_read_lock_held());
+
+	if (map->value_size != sizeof(u64))
+		return ERR_PTR(-ENOSPC);
+
+	sk = __sock_map_lookup_elem(map, *(u32 *)key);
+	if (!sk)
+		return ERR_PTR(-ENOENT);
+
+	sock_gen_cookie(sk);
+	return &sk->sk_cookie;
+}
+
 static int __sock_map_delete(struct bpf_stab *stab, struct sock *sk_test,
 			     struct sock **psk)
 {
@@ -448,12 +467,19 @@ static bool sock_map_redirect_okay(const struct sock *sk)
 static int sock_map_update_elem(struct bpf_map *map, void *key,
 				void *value, u64 flags)
 {
-	u32 ufd = *(u32 *)value;
 	u32 idx = *(u32 *)key;
 	struct socket *sock;
 	struct sock *sk;
+	u64 ufd;
 	int ret;
 
+	if (map->value_size == sizeof(u64))
+		ufd = *(u64 *)value;
+	else
+		ufd = *(u32 *)value;
+	if (ufd > S32_MAX)
+		return -EINVAL;
+
 	sock = sockfd_lookup(ufd, &ret);
 	if (!sock)
 		return ret;
@@ -562,6 +588,7 @@ const struct bpf_map_ops sock_map_ops = {
 	.map_alloc		= sock_map_alloc,
 	.map_free		= sock_map_free,
 	.map_get_next_key	= sock_map_get_next_key,
+	.map_lookup_elem_sys_only = sock_map_lookup_sys,
 	.map_update_elem	= sock_map_update_elem,
 	.map_delete_elem	= sock_map_delete_elem,
 	.map_lookup_elem	= sock_map_lookup,
-- 
2.24.1


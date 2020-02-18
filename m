Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F805162BB0
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 18:10:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbgBRRKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 12:10:40 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51281 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbgBRRKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 12:10:37 -0500
Received: by mail-wm1-f65.google.com with SMTP id t23so3573158wmi.1
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 09:10:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5wT5YmZaXRIbm7ejB9zEZFmHSHKFjMJlKhfMjZNLGTA=;
        b=dttY1S/0jTsxaj88aqteUE/XtCb5Pqe7xi5qq0J5JpGq8NBXxuQgVJjhkmRL4pWtdu
         39DZ1cpNnMd5Zves9gjcvk5VHT0zQ4FNvLIP5s81t5avgrsjDaGMtS/sb02l6YnFz5ys
         WjFtponoDJBU9g2EBSV2HWMYJnuC6Qn/JLBDM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5wT5YmZaXRIbm7ejB9zEZFmHSHKFjMJlKhfMjZNLGTA=;
        b=MeTx/luiXXCwu7+EYe0dOXXYHxuWrFYeEau+H9SfbiKjpjrRl7xtIvY6LACDKThOyB
         eypMNoRFt0jZ69AqlfqyCOBeC3WACDbZM9EvRjVa75Hl02HjJbJvilJlQh+F+vNHTxV5
         cl8gDIikTVr0F26fozqUS+RGWd1Q1Bdk2ZGzh9QA0wMoQVlPfszwGeB4Ty5EYxPlOZhe
         HbH1+MVUizUIOUF9HKDJG2NZK6fHskAneXHTxFqP/spCkGa13nSEcexNjKQILYtlkDbi
         Z53Pik/D1RnrralW45ZKtQGLFt+rkHiA2gbHuhgor8nQXMGNrHAlXKpJYYCuSAbw35Vk
         Z42Q==
X-Gm-Message-State: APjAAAX3DsRpTDut4GQjO/cVvtqT1rlrZpDXHou5QXwAIPMGA85q14AA
        /lrqCXOAyJ8+J91dAreqnYeTjz//a637DHFg
X-Google-Smtp-Source: APXvYqxv1NtV6MO7EFHyO/rn0AosiQxulZRR1WK11a9trLs9SKXQVoF1Tp2yDy5Xx1BQiCP8DJqRww==
X-Received: by 2002:a1c:490b:: with SMTP id w11mr3972315wma.96.1582045835187;
        Tue, 18 Feb 2020 09:10:35 -0800 (PST)
Received: from cloudflare.com ([88.157.168.82])
        by smtp.gmail.com with ESMTPSA id a16sm7019701wrx.87.2020.02.18.09.10.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 09:10:34 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, Martin Lau <kafai@fb.com>
Subject: [PATCH bpf-next v7 06/11] bpf, sockmap: Return socket cookie on lookup from syscall
Date:   Tue, 18 Feb 2020 17:10:18 +0000
Message-Id: <20200218171023.844439-7-jakub@cloudflare.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200218171023.844439-1-jakub@cloudflare.com>
References: <20200218171023.844439-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tooling that populates the SOCK{MAP,HASH} with sockets from user-space
needs a way to inspect its contents. Returning the struct sock * that the
map holds to user-space is neither safe nor useful. An approach established
by REUSEPORT_SOCKARRAY is to return a socket cookie (a unique identifier)
instead.

Since socket cookies are u64 values, SOCK{MAP,HASH} need to support such a
value size for lookup to be possible. This requires special handling on
update, though. Attempts to do a lookup on a map holding u32 values will be
met with ENOSPC error.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 net/core/sock_map.c | 57 +++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 53 insertions(+), 4 deletions(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index a5103112a344..f48c934d5da0 100644
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
 
@@ -302,6 +304,21 @@ static void *sock_map_lookup(struct bpf_map *map, void *key)
 	return ERR_PTR(-EOPNOTSUPP);
 }
 
+static void *sock_map_lookup_sys(struct bpf_map *map, void *key)
+{
+	struct sock *sk;
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
@@ -445,11 +462,18 @@ static bool sock_map_sk_state_allowed(const struct sock *sk)
 static int sock_map_update_elem(struct bpf_map *map, void *key,
 				void *value, u64 flags)
 {
-	u32 ufd = *(u32 *)value;
 	u32 idx = *(u32 *)key;
 	struct socket *sock;
 	struct sock *sk;
 	int ret;
+	u64 ufd;
+
+	if (map->value_size == sizeof(u64))
+		ufd = *(u64 *)value;
+	else
+		ufd = *(u32 *)value;
+	if (ufd > S32_MAX)
+		return -EINVAL;
 
 	sock = sockfd_lookup(ufd, &ret);
 	if (!sock)
@@ -557,6 +581,7 @@ const struct bpf_map_ops sock_map_ops = {
 	.map_alloc		= sock_map_alloc,
 	.map_free		= sock_map_free,
 	.map_get_next_key	= sock_map_get_next_key,
+	.map_lookup_elem_sys_only = sock_map_lookup_sys,
 	.map_update_elem	= sock_map_update_elem,
 	.map_delete_elem	= sock_map_delete_elem,
 	.map_lookup_elem	= sock_map_lookup,
@@ -787,10 +812,17 @@ static int sock_hash_update_common(struct bpf_map *map, void *key,
 static int sock_hash_update_elem(struct bpf_map *map, void *key,
 				 void *value, u64 flags)
 {
-	u32 ufd = *(u32 *)value;
 	struct socket *sock;
 	struct sock *sk;
 	int ret;
+	u64 ufd;
+
+	if (map->value_size == sizeof(u64))
+		ufd = *(u64 *)value;
+	else
+		ufd = *(u32 *)value;
+	if (ufd > S32_MAX)
+		return -EINVAL;
 
 	sock = sockfd_lookup(ufd, &ret);
 	if (!sock)
@@ -866,7 +898,8 @@ static struct bpf_map *sock_hash_alloc(union bpf_attr *attr)
 		return ERR_PTR(-EPERM);
 	if (attr->max_entries == 0 ||
 	    attr->key_size    == 0 ||
-	    attr->value_size  != 4 ||
+	    (attr->value_size != sizeof(u32) &&
+	     attr->value_size != sizeof(u64)) ||
 	    attr->map_flags & ~SOCK_CREATE_FLAG_MASK)
 		return ERR_PTR(-EINVAL);
 	if (attr->key_size > MAX_BPF_STACK)
@@ -943,6 +976,21 @@ static void sock_hash_free(struct bpf_map *map)
 	kfree(htab);
 }
 
+static void *sock_hash_lookup_sys(struct bpf_map *map, void *key)
+{
+	struct sock *sk;
+
+	if (map->value_size != sizeof(u64))
+		return ERR_PTR(-ENOSPC);
+
+	sk = __sock_hash_lookup_elem(map, key);
+	if (!sk)
+		return ERR_PTR(-ENOENT);
+
+	sock_gen_cookie(sk);
+	return &sk->sk_cookie;
+}
+
 static void sock_hash_release_progs(struct bpf_map *map)
 {
 	psock_progs_drop(&container_of(map, struct bpf_htab, map)->progs);
@@ -1032,6 +1080,7 @@ const struct bpf_map_ops sock_hash_ops = {
 	.map_update_elem	= sock_hash_update_elem,
 	.map_delete_elem	= sock_hash_delete_elem,
 	.map_lookup_elem	= sock_map_lookup,
+	.map_lookup_elem_sys_only = sock_hash_lookup_sys,
 	.map_release_uref	= sock_hash_release_progs,
 	.map_check_btf		= map_check_no_btf,
 };
-- 
2.24.1


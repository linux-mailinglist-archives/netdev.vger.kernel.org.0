Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50067146D77
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 16:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729061AbgAWPzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 10:55:50 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37741 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728992AbgAWPzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 10:55:47 -0500
Received: by mail-wr1-f66.google.com with SMTP id w15so3665285wru.4
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 07:55:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VVLv1nOpcm8g71RlGNU+JDanGJ7QnKmZ4x0azYDRngs=;
        b=B2Jq7Iy4QUtzJrwz1A1nwILtdxg/B/16ouDihBZS+EiodNyGu6LJXbszyNZ9ht/6Gn
         B6V+ioOzGYwSygItm+xcVAja9c+ExfIGKO2XAMCVps4d3/YZB8+aMXyyydxpqy39Mn0h
         198Fwe4GYbL7Qny/+OnPQQXNQlTVpi130r4js=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VVLv1nOpcm8g71RlGNU+JDanGJ7QnKmZ4x0azYDRngs=;
        b=Bi2USlUDomzDVBIeoKOrxqCIHwomZwHkB29lZWxXVBJdiw5tGGNYvCefQFbhDvtGcv
         aFMC/MDRvwHlIQYYgnfS1TwC6EKHwZil+ssAyQuZlgrKHAd5NqiJOLIzXJZoMRQJP9+j
         qKmwGK8qpfo0gpCc5iyxZ92s+7zsgOLtVVsqTWM97BmM2NmDreEWJ2QgaCnNY9STY76D
         HFVNKC/NS7IqS8FcKdCD3YUsohJ3UeiHlE1AYJpJUERbxtDh+xfcaX+t1ya+BLkuBx4J
         And1ztj8dJ5qjat3B7Lav692cn3AWYmzztBFGTFtZAnQ7CtjgLT5uSZKb+1RwSydO3fI
         /pbw==
X-Gm-Message-State: APjAAAWarSB3KN8GuDBuEFFup4cve1WnCSupd5npDfsN4TGGGISgBi9k
        eB8V26C0QKv4lNnn7Y+VgoTSEQ==
X-Google-Smtp-Source: APXvYqwsGxZP/OSMOEPRohkvmQeQm4Jdsa4I0e9fADufRzS4mZO2BsuOFbeUvAfS2tnV3jgVRja2rQ==
X-Received: by 2002:adf:806e:: with SMTP id 101mr18279107wrk.300.1579794944869;
        Thu, 23 Jan 2020 07:55:44 -0800 (PST)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id p5sm3394270wrt.79.2020.01.23.07.55.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 07:55:44 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, Martin Lau <kafai@fb.com>
Subject: [PATCH bpf-next v4 07/12] bpf, sockmap: Return socket cookie on lookup from syscall
Date:   Thu, 23 Jan 2020 16:55:29 +0100
Message-Id: <20200123155534.114313-8-jakub@cloudflare.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200123155534.114313-1-jakub@cloudflare.com>
References: <20200123155534.114313-1-jakub@cloudflare.com>
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

Since socket cookies are u64 values, SOCKMAP needs to support such a value
size for lookup to be possible. This requires special handling on update,
though. Attempts to do a lookup on SOCKMAP holding u32 values will be met
with ENOSPC error.

Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 net/core/sock_map.c | 29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 2ff545e04f6e..441f213bd4c5 100644
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
 
@@ -298,6 +300,21 @@ static void *sock_map_lookup(struct bpf_map *map, void *key)
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
@@ -459,12 +476,19 @@ static bool sock_hash_sk_is_suitable(const struct sock *sk)
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
@@ -568,6 +592,7 @@ const struct bpf_map_ops sock_map_ops = {
 	.map_alloc		= sock_map_alloc,
 	.map_free		= sock_map_free,
 	.map_get_next_key	= sock_map_get_next_key,
+	.map_lookup_elem_sys_only = sock_map_lookup_sys,
 	.map_update_elem	= sock_map_update_elem,
 	.map_delete_elem	= sock_map_delete_elem,
 	.map_lookup_elem	= sock_map_lookup,
-- 
2.24.1


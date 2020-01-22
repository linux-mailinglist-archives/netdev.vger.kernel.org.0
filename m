Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1151454C4
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 14:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729242AbgAVNGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 08:06:05 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:44568 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729045AbgAVNGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 08:06:03 -0500
Received: by mail-lj1-f193.google.com with SMTP id q8so6673054ljj.11
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 05:06:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WDO2nKU1fG1HYrmFQY9JEu5IKkozhVaPgoSVYJJKkMI=;
        b=V4wQrNgvRxPPH5lCCP8EnDGbaVYaDdy/hxai5VL5n1Q1L23749AhnMb/6STX2ELlI8
         Y6XIahqQOiz4QE/oFc9stVAAfRpu6c19Xl3sCN8v0c9xuJHyIal/Os63u2PfKFxZZXSy
         YkDOS6p1nYxXqPv5iIRvftR78ghX0yxeNZMMw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WDO2nKU1fG1HYrmFQY9JEu5IKkozhVaPgoSVYJJKkMI=;
        b=D4sCChIKoGSsRoonf0hnKb3u1HYsvDzNhRZdvMg0eUHzUhL34la6Fc0lkY1oy/8ono
         zbKlx4U2xi5KuA4HaPkcX51qNrzR0PoCogWMWTOxOkUChAHfGsFb97u1hf102R4iKGhN
         F/0KEfjeI+/uTD1wg8/iHbCEqQ+6ct+OvFrAzBGBY4gBwUVO6QnPaOPyDl8253THDGDn
         wGBGPBajJQ2sev3hc9jkDJxrnsvi8r3PSKBdy6Esgc5a5xy4hO/FXQ5D6dQ200ze/BmC
         fX+W60ig56Ya4hfDJ8WkS2Y+mdEcZ80fCRI2YHPSzz2IdeB1Di0Jq4VCqiPXBfJoR7dj
         F6TQ==
X-Gm-Message-State: APjAAAWQcc8Ny480lJWKzV+856o7cgsazsUA+OwWMDsNsmeJNE6dZIr9
        mPEiCaloz9j4C/2EVsaYbL2ILw==
X-Google-Smtp-Source: APXvYqzBx66ktUhe3bGrmjmUCTeJGlUkEDWVtDztQ01dKIAxptJxribVaCAh0jxNbtnxboNvZkDq7w==
X-Received: by 2002:a2e:b4cb:: with SMTP id r11mr19168856ljm.68.1579698361831;
        Wed, 22 Jan 2020 05:06:01 -0800 (PST)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id t13sm20242233ljk.78.2020.01.22.05.06.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 05:06:01 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, Martin Lau <kafai@fb.com>
Subject: [PATCH bpf-next v3 07/12] bpf, sockmap: Return socket cookie on lookup from syscall
Date:   Wed, 22 Jan 2020 14:05:44 +0100
Message-Id: <20200122130549.832236-8-jakub@cloudflare.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200122130549.832236-1-jakub@cloudflare.com>
References: <20200122130549.832236-1-jakub@cloudflare.com>
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
index 439f1e0b995e..cabe85892ba3 100644
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
@@ -460,12 +477,19 @@ static bool sock_map_redirect_okay(const struct sock *sk)
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
@@ -569,6 +593,7 @@ const struct bpf_map_ops sock_map_ops = {
 	.map_alloc		= sock_map_alloc,
 	.map_free		= sock_map_free,
 	.map_get_next_key	= sock_map_get_next_key,
+	.map_lookup_elem_sys_only = sock_map_lookup_sys,
 	.map_update_elem	= sock_map_update_elem,
 	.map_delete_elem	= sock_map_delete_elem,
 	.map_lookup_elem	= sock_map_lookup,
-- 
2.24.1


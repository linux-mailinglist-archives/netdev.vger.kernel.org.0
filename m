Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4340724C01E
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 16:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbgHTOIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 10:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731174AbgHTN6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 09:58:19 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC005C061346
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 06:58:09 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id p14so1695752wmg.1
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 06:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=69sOyCq0/PTkMt8U0eelreX//j7fcPl/BZSpBurBpUo=;
        b=NKfVAWDAIR8ZJHZC8OWpm5CRXjVZNw1xe2VottFCPq++d/jsD8EFS1L0ojf6qvkwVZ
         jEfIyyEkjij6YrI1IUlDkK/wadvu3F9SQIrQ11eAu8IkmqMLcLUu3GssdT0MqqJ/xvUy
         DiriGLoRa/+8DwfCJqeVs74lZBBtWmOQ+N1oU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=69sOyCq0/PTkMt8U0eelreX//j7fcPl/BZSpBurBpUo=;
        b=VfT6ucJOCxvYzQERpu3uIM9eEI9/w56Mj+H489Xy54/HT0GFJJZlk/z9YeptdbUztL
         FxsOaHlzxn1C2zcPZgrvf6l3y1pmUf2rxGrdw+ADHrMFwtN0wV/x84DvRFq3uQXOiSPl
         0TTnuV8XKRiqrFiqAoo1+Fs5gPmKKAhqQWHBOGrb2QMm23+MICtmG7r6FA/zXULG62zL
         oz/J6QvOcNrlg9/kRi0G6fD0mreM6Ny0RYVVFka/cgzb3Wy44WgnHhETHxPasvuiIB5J
         jbW5abljDcTHiDT+dIqVS5Flis5UxB0Xn5UHKQkx8bAVYMGHRDjPBwtvWP4FDayCyW7F
         vOtQ==
X-Gm-Message-State: AOAM530ZtVMpx6cw0pJYeyRQdmIWMpiiFPbNfivILWNZDEZfbWuf5Juw
        eXXePFAlZ2MLudJHsGo6oMt4Cw==
X-Google-Smtp-Source: ABdhPJzD8vDLcFblQmfX4aUyNnt/Gc39BT6d02C3tokVGEXi2rhXaql2gBukZFCwM7QpTEEZCsLmog==
X-Received: by 2002:a7b:c056:: with SMTP id u22mr3671470wmc.188.1597931888431;
        Thu, 20 Aug 2020 06:58:08 -0700 (PDT)
Received: from antares.lan (d.0.f.e.b.c.7.2.d.c.3.8.4.8.d.9.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:9d84:83cd:27cb:ef0d])
        by smtp.gmail.com with ESMTPSA id l81sm4494215wmf.4.2020.08.20.06.58.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2020 06:58:07 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     jakub@cloudflare.com, john.fastabend@gmail.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v2 3/6] bpf: sockmap: call sock_map_update_elem directly
Date:   Thu, 20 Aug 2020 14:57:26 +0100
Message-Id: <20200820135729.135783-4-lmb@cloudflare.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200820135729.135783-1-lmb@cloudflare.com>
References: <20200820135729.135783-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't go via map->ops to call sock_map_update_elem, since we know
what function to call in bpf_map_update_value. Since we currently
don't allow calling map_update_elem from BPF context, we can remove
ops->map_update_elem and rename the function to sock_map_update_elem_sys.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 include/linux/bpf.h  | 7 +++++++
 kernel/bpf/syscall.c | 5 +++--
 net/core/sock_map.c  | 6 ++----
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index cef4ef0d2b4e..cf3416d1b8c2 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1635,6 +1635,7 @@ int sock_map_prog_update(struct bpf_map *map, struct bpf_prog *prog,
 			 struct bpf_prog *old, u32 which);
 int sock_map_get_from_fd(const union bpf_attr *attr, struct bpf_prog *prog);
 int sock_map_prog_detach(const union bpf_attr *attr, enum bpf_prog_type ptype);
+int sock_map_update_elem_sys(struct bpf_map *map, void *key, void *value, u64 flags);
 void sock_map_unhash(struct sock *sk);
 void sock_map_close(struct sock *sk, long timeout);
 #else
@@ -1656,6 +1657,12 @@ static inline int sock_map_prog_detach(const union bpf_attr *attr,
 {
 	return -EOPNOTSUPP;
 }
+
+static inline int sock_map_update_elem_sys(struct bpf_map *map, void *key, void *value,
+					   u64 flags)
+{
+	return -EOPNOTSUPP;
+}
 #endif /* CONFIG_BPF_STREAM_PARSER */
 
 #if defined(CONFIG_INET) && defined(CONFIG_BPF_SYSCALL)
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 2f343ce15747..5867cf615a3c 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -157,10 +157,11 @@ static int bpf_map_update_value(struct bpf_map *map, struct fd f, void *key,
 	if (bpf_map_is_dev_bound(map)) {
 		return bpf_map_offload_update_elem(map, key, value, flags);
 	} else if (map->map_type == BPF_MAP_TYPE_CPUMAP ||
-		   map->map_type == BPF_MAP_TYPE_SOCKHASH ||
-		   map->map_type == BPF_MAP_TYPE_SOCKMAP ||
 		   map->map_type == BPF_MAP_TYPE_STRUCT_OPS) {
 		return map->ops->map_update_elem(map, key, value, flags);
+	} else if (map->map_type == BPF_MAP_TYPE_SOCKHASH ||
+		   map->map_type == BPF_MAP_TYPE_SOCKMAP) {
+		return sock_map_update_elem_sys(map, key, value, flags);
 	} else if (IS_FD_PROG_ARRAY(map)) {
 		return bpf_fd_array_map_update_elem(map, f.file, key, value,
 						    flags);
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 905e2dd765aa..48e83f93ee66 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -562,8 +562,8 @@ static bool sock_map_sk_state_allowed(const struct sock *sk)
 static int sock_hash_update_common(struct bpf_map *map, void *key,
 				   struct sock *sk, u64 flags);
 
-static int sock_map_update_elem(struct bpf_map *map, void *key,
-				void *value, u64 flags)
+int sock_map_update_elem_sys(struct bpf_map *map, void *key, void *value,
+			     u64 flags)
 {
 	struct socket *sock;
 	struct sock *sk;
@@ -687,7 +687,6 @@ const struct bpf_map_ops sock_map_ops = {
 	.map_free		= sock_map_free,
 	.map_get_next_key	= sock_map_get_next_key,
 	.map_lookup_elem_sys_only = sock_map_lookup_sys,
-	.map_update_elem	= sock_map_update_elem,
 	.map_delete_elem	= sock_map_delete_elem,
 	.map_lookup_elem	= sock_map_lookup,
 	.map_release_uref	= sock_map_release_progs,
@@ -1181,7 +1180,6 @@ const struct bpf_map_ops sock_hash_ops = {
 	.map_alloc		= sock_hash_alloc,
 	.map_free		= sock_hash_free,
 	.map_get_next_key	= sock_hash_get_next_key,
-	.map_update_elem	= sock_map_update_elem,
 	.map_delete_elem	= sock_hash_delete_elem,
 	.map_lookup_elem	= sock_hash_lookup,
 	.map_lookup_elem_sys_only = sock_hash_lookup_sys,
-- 
2.25.1


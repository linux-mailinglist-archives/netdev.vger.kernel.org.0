Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66A903F530D
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 23:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233027AbhHWVyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 17:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232808AbhHWVx7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 17:53:59 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B8B9C061575;
        Mon, 23 Aug 2021 14:53:16 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id q6so10585224qvs.12;
        Mon, 23 Aug 2021 14:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references:reply-to
         :mime-version:content-transfer-encoding;
        bh=3uiK9gtjB0S4i1poBW9ZjT+AKRBDj1R5XFX8+4rV54g=;
        b=XFV2ixZOR6KvosBFXA2XTZEBqcLgtQM8aMyBx1m1GCcvqj9xA3EZ2ivAiiRydunu5e
         oLyFHfYeuiitTTyPTZbaUKXLXu+TgonZjBLr0x1kIH1Ee8nXWBZoNmhSzvoBUNekeczd
         UtX4+tBBOUxehE+ieTUYNIwa6eD6mectrCgz+k3txKBy1UWMMNOQ5BLd6suCQ0lBXdTF
         qC0PxulxYvIg2GajDN5HanUS14MzLWiihxvOeQOk1bEhXRdk9KGdRo9WJU6E3fdIdpWx
         1XqVjIzDa1Jz5mvUVgQ7oHLxPnX3lKgnG+3SlnmAVPLgwr8ofilhFu/wvH/VALxoSLA8
         ZeVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:reply-to:mime-version:content-transfer-encoding;
        bh=3uiK9gtjB0S4i1poBW9ZjT+AKRBDj1R5XFX8+4rV54g=;
        b=B1Vr7A5iXkvo4/esSIJRJdjV88yNfE3+YfK4Hb56zESJl+R+zTCXYB9aG3tLclk4Zn
         uEPJP6xCuhng1LGNpzBQ0B/aC02Un70HHFDfxEF1Gn+RUBYw+5bK4Ocr5gcuYTg1MPor
         /pT60v761vVbPJTNwEh61nDzm1JbnIFj9o3guyGQW7XcW/iCg8Nsm0O61tgwN+iCjOAQ
         joHNZ2JfWYb7USKNjuhQ+wbEg1VbR05XJsMNJtM+meR3JgEjDzIGRk30fJqyrT2YmQHZ
         74Vhq+8q5HjI2Qo3k4stGDqJdFnoltgg435THO4e2LE0aXC4a02uNLf11PI29axzFrew
         OBaQ==
X-Gm-Message-State: AOAM532gEbRF2ti9LNDtrlC9gJLOj0CJQ91MUndpLbxKCflvRyVyXrV0
        GURImwcqhlxaEaBs4OdnRx1YbT+6g7eSPFLi
X-Google-Smtp-Source: ABdhPJwYq0RXC2Hie2/uzedPeibN1JJ4k06AykQITcgX41CZh6DLBZtmBsT9OYPQDxsBNJamtbFyBw==
X-Received: by 2002:ad4:59cf:: with SMTP id el15mr8512630qvb.55.1629755595213;
        Mon, 23 Aug 2021 14:53:15 -0700 (PDT)
Received: from localhost.localdomain (cpe-74-65-249-7.nyc.res.rr.com. [74.65.249.7])
        by smtp.gmail.com with ESMTPSA id 18sm7004261qtx.76.2021.08.23.14.53.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 14:53:14 -0700 (PDT)
From:   Hans Montero <hansmontero99@gmail.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     hjm2133@columbia.edu, sdf@google.com, ppenkov@google.com
Subject: [RFC PATCH bpf-next 1/2] bpf: Implement shared sk_storage optimization
Date:   Mon, 23 Aug 2021 17:52:51 -0400
Message-Id: <20210823215252.15936-2-hansmontero99@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210823215252.15936-1-hansmontero99@gmail.com>
References: <20210823215252.15936-1-hansmontero99@gmail.com>
Reply-To: hjm2133@columbia.edu
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hans Montero <hjm2133@columbia.edu>

Shared sk_storage mode inlines the data directly into the socket,
providing fast and persistent storage.

Suggested-by: Stanislav Fomichev <sdf@google.com>
Signed-off-by: Hans Montero <hjm2133@columbia.edu>
---
 include/net/sock.h             |  3 +++
 include/uapi/linux/bpf.h       |  6 +++++
 kernel/bpf/Kconfig             | 11 ++++++++
 kernel/bpf/bpf_local_storage.c |  3 ++-
 net/core/bpf_sk_storage.c      | 47 +++++++++++++++++++++++++++++++++-
 5 files changed, 68 insertions(+), 2 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 6e761451c927..ccb9c867824b 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -528,6 +528,9 @@ struct sock {
 	struct sock_reuseport __rcu	*sk_reuseport_cb;
 #ifdef CONFIG_BPF_SYSCALL
 	struct bpf_local_storage __rcu	*sk_bpf_storage;
+#if CONFIG_BPF_SHARED_LOCAL_STORAGE_SIZE > 0
+	u8 bpf_shared_local_storage[CONFIG_BPF_SHARED_LOCAL_STORAGE_SIZE];
+#endif
 #endif
 	struct rcu_head		sk_rcu;
 };
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index c4f7892edb2b..ef09e49a9381 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1210,6 +1210,12 @@ enum {
 
 /* Create a map that is suitable to be an inner map with dynamic max entries */
 	BPF_F_INNER_MAP		= (1U << 12),
+
+/* Instead of accessing local storage via map lookup, the local storage API
+ * will use the CONFIG_BPF_SHARED_LOCAL_STORAGE_SIZE bytes inlined directly
+ * into struct sock. This flag is ignored for non-SK_STORAGE maps.
+ */
+	BPF_F_SHARED_LOCAL_STORAGE = (1U << 13),
 };
 
 /* Flags for BPF_PROG_QUERY. */
diff --git a/kernel/bpf/Kconfig b/kernel/bpf/Kconfig
index a82d6de86522..88798f26b535 100644
--- a/kernel/bpf/Kconfig
+++ b/kernel/bpf/Kconfig
@@ -35,6 +35,17 @@ config BPF_SYSCALL
 	  Enable the bpf() system call that allows to manipulate BPF programs
 	  and maps via file descriptors.
 
+config BPF_SHARED_LOCAL_STORAGE_SIZE
+	int "BPF Socket Local Storage Optimization Buffer Size"
+	depends on BPF_SYSCALL
+	default 0
+	help
+	  Enable shared socket storage mode where the data is inlined directly
+	  into the socket. Provides fast and persistent storage, see
+	  BPF_F_SHARED_LOCAL_STORAGE. This option controls how many bytes to
+	  pre-allocate in each socket.
+
+
 config BPF_JIT
 	bool "Enable BPF Just In Time compiler"
 	depends on BPF
diff --git a/kernel/bpf/bpf_local_storage.c b/kernel/bpf/bpf_local_storage.c
index b305270b7a4b..6f97927aa1d7 100644
--- a/kernel/bpf/bpf_local_storage.c
+++ b/kernel/bpf/bpf_local_storage.c
@@ -12,7 +12,8 @@
 #include <uapi/linux/sock_diag.h>
 #include <uapi/linux/btf.h>
 
-#define BPF_LOCAL_STORAGE_CREATE_FLAG_MASK (BPF_F_NO_PREALLOC | BPF_F_CLONE)
+#define BPF_LOCAL_STORAGE_CREATE_FLAG_MASK \
+	(BPF_F_NO_PREALLOC | BPF_F_CLONE | BPF_F_SHARED_LOCAL_STORAGE)
 
 static struct bpf_local_storage_map_bucket *
 select_bucket(struct bpf_local_storage_map *smap,
diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
index 68d2cbf8331a..9173b89f9d3b 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -92,6 +92,16 @@ static void bpf_sk_storage_map_free(struct bpf_map *map)
 	bpf_local_storage_map_free(smap, NULL);
 }
 
+static int bpf_sk_storage_map_alloc_check(union bpf_attr *attr)
+{
+#if CONFIG_BPF_SHARED_LOCAL_STORAGE_SIZE > 0
+	if (attr->map_flags & BPF_F_SHARED_LOCAL_STORAGE &&
+	    attr->value_size > CONFIG_BPF_SHARED_LOCAL_STORAGE_SIZE)
+		return -E2BIG;
+#endif
+	return bpf_local_storage_map_alloc_check(attr);
+}
+
 static struct bpf_map *bpf_sk_storage_map_alloc(union bpf_attr *attr)
 {
 	struct bpf_local_storage_map *smap;
@@ -119,6 +129,10 @@ static void *bpf_fd_sk_storage_lookup_elem(struct bpf_map *map, void *key)
 	fd = *(int *)key;
 	sock = sockfd_lookup(fd, &err);
 	if (sock) {
+#if CONFIG_BPF_SHARED_LOCAL_STORAGE_SIZE > 0
+		if (map->map_flags & BPF_F_SHARED_LOCAL_STORAGE)
+			return sock->sk->bpf_shared_local_storage;
+#endif
 		sdata = bpf_sk_storage_lookup(sock->sk, map, true);
 		sockfd_put(sock);
 		return sdata ? sdata->data : NULL;
@@ -137,6 +151,13 @@ static int bpf_fd_sk_storage_update_elem(struct bpf_map *map, void *key,
 	fd = *(int *)key;
 	sock = sockfd_lookup(fd, &err);
 	if (sock) {
+#if CONFIG_BPF_SHARED_LOCAL_STORAGE_SIZE > 0
+		if (map_flags & BPF_F_SHARED_LOCAL_STORAGE) {
+			memcpy(sock->sk->bpf_shared_local_storage, value,
+			       sizeof(sock->sk->bpf_shared_local_storage));
+			return 0;
+		}
+#endif
 		sdata = bpf_local_storage_update(
 			sock->sk, (struct bpf_local_storage_map *)map, value,
 			map_flags);
@@ -155,6 +176,13 @@ static int bpf_fd_sk_storage_delete_elem(struct bpf_map *map, void *key)
 	fd = *(int *)key;
 	sock = sockfd_lookup(fd, &err);
 	if (sock) {
+#if CONFIG_BPF_SHARED_LOCAL_STORAGE_SIZE > 0
+		if (map->map_flags & BPF_F_SHARED_LOCAL_STORAGE) {
+			memset(sock->sk->bpf_shared_local_storage, 0,
+			       sizeof(sock->sk->bpf_shared_local_storage));
+			return 0;
+		}
+#endif
 		err = bpf_sk_storage_del(sock->sk, map);
 		sockfd_put(sock);
 		return err;
@@ -261,6 +289,15 @@ BPF_CALL_4(bpf_sk_storage_get, struct bpf_map *, map, struct sock *, sk,
 	if (!sk || !sk_fullsock(sk) || flags > BPF_SK_STORAGE_GET_F_CREATE)
 		return (unsigned long)NULL;
 
+#if CONFIG_BPF_SHARED_LOCAL_STORAGE_SIZE > 0
+	if (map->map_flags & BPF_F_SHARED_LOCAL_STORAGE) {
+		if (unlikely(value || flags & BPF_SK_STORAGE_GET_F_CREATE))
+			return (unsigned long)NULL;
+
+		return (unsigned long)sk->bpf_shared_local_storage;
+	}
+#endif
+
 	sdata = bpf_sk_storage_lookup(sk, map, true);
 	if (sdata)
 		return (unsigned long)sdata->data;
@@ -291,6 +328,14 @@ BPF_CALL_2(bpf_sk_storage_delete, struct bpf_map *, map, struct sock *, sk)
 	if (!sk || !sk_fullsock(sk))
 		return -EINVAL;
 
+#if CONFIG_BPF_SHARED_LOCAL_STORAGE_SIZE > 0
+	if (map->map_flags & BPF_F_SHARED_LOCAL_STORAGE) {
+		memset(sk->bpf_shared_local_storage, 0,
+		       sizeof(sk->bpf_shared_local_storage));
+		return 0;
+	}
+#endif
+
 	if (refcount_inc_not_zero(&sk->sk_refcnt)) {
 		int err;
 
@@ -336,7 +381,7 @@ bpf_sk_storage_ptr(void *owner)
 static int sk_storage_map_btf_id;
 const struct bpf_map_ops sk_storage_map_ops = {
 	.map_meta_equal = bpf_map_meta_equal,
-	.map_alloc_check = bpf_local_storage_map_alloc_check,
+	.map_alloc_check = bpf_sk_storage_map_alloc_check,
 	.map_alloc = bpf_sk_storage_map_alloc,
 	.map_free = bpf_sk_storage_map_free,
 	.map_get_next_key = notsupp_get_next_key,
-- 
2.30.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3388C8DC06
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 19:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728585AbfHNRiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 13:38:01 -0400
Received: from mail-yb1-f202.google.com ([209.85.219.202]:57226 "EHLO
        mail-yb1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728520AbfHNRiB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 13:38:01 -0400
Received: by mail-yb1-f202.google.com with SMTP id y9so1082958ybs.23
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 10:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=a7H16UQmJw6VgKiMqqu0R0QEkK8DCgpC0fmnX/y6MpI=;
        b=odigD1yiSpXcvenlUb3RoKMjOjsUPHNirq43Q9GruOcDZeVGkqQxi88qiRC48KbB/o
         FZRLsa6mZuygL1e7LhWPeyq+ykzbiUV9k2xlKMRIHoAukPx34lBYHWugZYpfD6UnSwAo
         Nb/QGJY0e93Ij3RNZKEknIQWQJJ1Fee8vkJWWp9Hoi0FyJq2qcSPzLBIuw5ne3FW/jqT
         susA0L+wnxF6V0AaFdUSRoP4Abb8kppjeFYTf9010Efs+MsBf2P/reaHsguI/oOVs/x4
         akz28JIrM/jmgpzZvT8mQrsNhZNROFKLYuaDhfDiITKPuLqf3z/edbjKb41eJhPliZI9
         eglQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=a7H16UQmJw6VgKiMqqu0R0QEkK8DCgpC0fmnX/y6MpI=;
        b=V7+Gxjt99YeZxfxBsa4Wu1tCGEDbHL0r2Zb9nlifOa7W0LYUHjrRWc5SiIGOpqlGYK
         fqAB0L8ZC+y0CgE93X45I7aNdhQh8/VQiUuQ02KKHkYK8OEJbPFDj4kxfrS/OeE88dWV
         lWbbOrZmRAaxe3jRwG6sS7FhC0qzTGTtjWUx0sfelIxIYTwaPt5dnf5fuBRHfBzdlQHn
         ajuN7AGWZNNc1Jr5wp1va3miOOtOIdmokT8O5TfUbU3iU6ePXelxjGHIQwCpSIrXA5qV
         Cpb3Dwo9nBYKT3cArw0k6qIr2rUOShHQuDLucPxZ+Meonj/VfHaQmpDivViMqn2Sz1D4
         Ee2A==
X-Gm-Message-State: APjAAAVDCQdARrTmHYQ04zF3fbHHBU7xkVvffEs84LB61EMd4+b+UxH0
        SbCXV0AsLnaRu7mo8jOGFQZemUem+ei1OKAYHyVWttrsnTnbhruHnPNwK7my7CZnOSsQzd376Wc
        Y1wo41Z6F8GTOhl8SGfyxfmZLDzhPTBV6L1lwRnnFpodwXpAFKIfmiA==
X-Google-Smtp-Source: APXvYqxxkcCMAbUMycc6zxfAX9dGuoLco/71gWMwv1KmFCtZf3F+SQMcptqLLomHQOBpUl7VtY5pLPw=
X-Received: by 2002:a25:9202:: with SMTP id b2mr27850ybo.65.1565804280099;
 Wed, 14 Aug 2019 10:38:00 -0700 (PDT)
Date:   Wed, 14 Aug 2019 10:37:49 -0700
In-Reply-To: <20190814173751.31806-1-sdf@google.com>
Message-Id: <20190814173751.31806-3-sdf@google.com>
Mime-Version: 1.0
References: <20190814173751.31806-1-sdf@google.com>
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
Subject: [PATCH bpf-next v4 2/4] bpf: support cloning sk storage on accept()
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new helper bpf_sk_storage_clone which optionally clones sk storage
and call it from sk_clone_lock.

Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 include/net/bpf_sk_storage.h |  10 ++++
 include/uapi/linux/bpf.h     |   3 +
 net/core/bpf_sk_storage.c    | 104 ++++++++++++++++++++++++++++++++++-
 net/core/sock.c              |   9 ++-
 4 files changed, 120 insertions(+), 6 deletions(-)

diff --git a/include/net/bpf_sk_storage.h b/include/net/bpf_sk_storage.h
index b9dcb02e756b..8e4f831d2e52 100644
--- a/include/net/bpf_sk_storage.h
+++ b/include/net/bpf_sk_storage.h
@@ -10,4 +10,14 @@ void bpf_sk_storage_free(struct sock *sk);
 extern const struct bpf_func_proto bpf_sk_storage_get_proto;
 extern const struct bpf_func_proto bpf_sk_storage_delete_proto;
 
+#ifdef CONFIG_BPF_SYSCALL
+int bpf_sk_storage_clone(const struct sock *sk, struct sock *newsk);
+#else
+static inline int bpf_sk_storage_clone(const struct sock *sk,
+				       struct sock *newsk)
+{
+	return 0;
+}
+#endif
+
 #endif /* _BPF_SK_STORAGE_H */
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 4393bd4b2419..0ef594ac3899 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -337,6 +337,9 @@ enum bpf_attach_type {
 #define BPF_F_RDONLY_PROG	(1U << 7)
 #define BPF_F_WRONLY_PROG	(1U << 8)
 
+/* Clone map from listener for newly accepted socket */
+#define BPF_F_CLONE		(1U << 9)
+
 /* flags for BPF_PROG_QUERY */
 #define BPF_F_QUERY_EFFECTIVE	(1U << 0)
 
diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
index 94c7f77ecb6b..da5639a5bd3b 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -12,6 +12,9 @@
 
 static atomic_t cache_idx;
 
+#define SK_STORAGE_CREATE_FLAG_MASK					\
+	(BPF_F_NO_PREALLOC | BPF_F_CLONE)
+
 struct bucket {
 	struct hlist_head list;
 	raw_spinlock_t lock;
@@ -209,7 +212,6 @@ static void selem_unlink_sk(struct bpf_sk_storage_elem *selem)
 		kfree_rcu(sk_storage, rcu);
 }
 
-/* sk_storage->lock must be held and sk_storage->list cannot be empty */
 static void __selem_link_sk(struct bpf_sk_storage *sk_storage,
 			    struct bpf_sk_storage_elem *selem)
 {
@@ -509,7 +511,7 @@ static int sk_storage_delete(struct sock *sk, struct bpf_map *map)
 	return 0;
 }
 
-/* Called by __sk_destruct() */
+/* Called by __sk_destruct() & bpf_sk_storage_clone() */
 void bpf_sk_storage_free(struct sock *sk)
 {
 	struct bpf_sk_storage_elem *selem;
@@ -557,6 +559,11 @@ static void bpf_sk_storage_map_free(struct bpf_map *map)
 
 	smap = (struct bpf_sk_storage_map *)map;
 
+	/* Note that this map might be concurrently cloned from
+	 * bpf_sk_storage_clone. Wait for any existing bpf_sk_storage_clone
+	 * RCU read section to finish before proceeding. New RCU
+	 * read sections should be prevented via bpf_map_inc_not_zero.
+	 */
 	synchronize_rcu();
 
 	/* bpf prog and the userspace can no longer access this map
@@ -601,7 +608,9 @@ static void bpf_sk_storage_map_free(struct bpf_map *map)
 
 static int bpf_sk_storage_map_alloc_check(union bpf_attr *attr)
 {
-	if (attr->map_flags != BPF_F_NO_PREALLOC || attr->max_entries ||
+	if (attr->map_flags & ~SK_STORAGE_CREATE_FLAG_MASK ||
+	    !(attr->map_flags & BPF_F_NO_PREALLOC) ||
+	    attr->max_entries ||
 	    attr->key_size != sizeof(int) || !attr->value_size ||
 	    /* Enforce BTF for userspace sk dumping */
 	    !attr->btf_key_type_id || !attr->btf_value_type_id)
@@ -739,6 +748,95 @@ static int bpf_fd_sk_storage_delete_elem(struct bpf_map *map, void *key)
 	return err;
 }
 
+static struct bpf_sk_storage_elem *
+bpf_sk_storage_clone_elem(struct sock *newsk,
+			  struct bpf_sk_storage_map *smap,
+			  struct bpf_sk_storage_elem *selem)
+{
+	struct bpf_sk_storage_elem *copy_selem;
+
+	copy_selem = selem_alloc(smap, newsk, NULL, true);
+	if (!copy_selem)
+		return NULL;
+
+	if (map_value_has_spin_lock(&smap->map))
+		copy_map_value_locked(&smap->map, SDATA(copy_selem)->data,
+				      SDATA(selem)->data, true);
+	else
+		copy_map_value(&smap->map, SDATA(copy_selem)->data,
+			       SDATA(selem)->data);
+
+	return copy_selem;
+}
+
+int bpf_sk_storage_clone(const struct sock *sk, struct sock *newsk)
+{
+	struct bpf_sk_storage *new_sk_storage = NULL;
+	struct bpf_sk_storage *sk_storage;
+	struct bpf_sk_storage_elem *selem;
+	int ret = 0;
+
+	RCU_INIT_POINTER(newsk->sk_bpf_storage, NULL);
+
+	rcu_read_lock();
+	sk_storage = rcu_dereference(sk->sk_bpf_storage);
+
+	if (!sk_storage || hlist_empty(&sk_storage->list))
+		goto out;
+
+	hlist_for_each_entry_rcu(selem, &sk_storage->list, snode) {
+		struct bpf_sk_storage_elem *copy_selem;
+		struct bpf_sk_storage_map *smap;
+		struct bpf_map *map;
+
+		smap = rcu_dereference(SDATA(selem)->smap);
+		if (!(smap->map.map_flags & BPF_F_CLONE))
+			continue;
+
+		/* Note that for lockless listeners adding new element
+		 * here can race with cleanup in bpf_sk_storage_map_free.
+		 * Try to grab map refcnt to make sure that it's still
+		 * alive and prevent concurrent removal.
+		 */
+		map = bpf_map_inc_not_zero(&smap->map, false);
+		if (IS_ERR(map))
+			continue;
+
+		copy_selem = bpf_sk_storage_clone_elem(newsk, smap, selem);
+		if (!copy_selem) {
+			ret = -ENOMEM;
+			bpf_map_put(map);
+			goto out;
+		}
+
+		if (new_sk_storage) {
+			selem_link_map(smap, copy_selem);
+			__selem_link_sk(new_sk_storage, copy_selem);
+		} else {
+			ret = sk_storage_alloc(newsk, smap, copy_selem);
+			if (ret) {
+				kfree(copy_selem);
+				atomic_sub(smap->elem_size,
+					   &newsk->sk_omem_alloc);
+				bpf_map_put(map);
+				goto out;
+			}
+
+			new_sk_storage = rcu_dereference(copy_selem->sk_storage);
+		}
+		bpf_map_put(map);
+	}
+
+out:
+	rcu_read_unlock();
+
+	/* In case of an error, don't free anything explicitly here, the
+	 * caller is responsible to call bpf_sk_storage_free.
+	 */
+
+	return ret;
+}
+
 BPF_CALL_4(bpf_sk_storage_get, struct bpf_map *, map, struct sock *, sk,
 	   void *, value, u64, flags)
 {
diff --git a/net/core/sock.c b/net/core/sock.c
index d57b0cc995a0..f5e801a9cea4 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1851,9 +1851,12 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
 			goto out;
 		}
 		RCU_INIT_POINTER(newsk->sk_reuseport_cb, NULL);
-#ifdef CONFIG_BPF_SYSCALL
-		RCU_INIT_POINTER(newsk->sk_bpf_storage, NULL);
-#endif
+
+		if (bpf_sk_storage_clone(sk, newsk)) {
+			sk_free_unlock_clone(newsk);
+			newsk = NULL;
+			goto out;
+		}
 
 		newsk->sk_err	   = 0;
 		newsk->sk_err_soft = 0;
-- 
2.23.0.rc1.153.gdeed80330f-goog


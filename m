Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE3908BE7A
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 18:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728086AbfHMQ0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 12:26:40 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:52285 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728037AbfHMQ0k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 12:26:40 -0400
Received: by mail-pf1-f201.google.com with SMTP id a20so68745692pfn.19
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 09:26:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=0eZpwWo8VKrZyzhNGjkeRdWzsShI5Q7vYkqK3O6Q2gQ=;
        b=KZMm0bPJRQp8hZEaIrYZ0r2yLnj6LSI5bl0Iqf+GHvkRc2ARDpr+EI4ljMb5gBCOMB
         DXu20DpxgDr2ezCZX+ZieDh3IcgfhvwkjByeCRzAu9cauA1GN6Fc5dPan2GfDBD7YqbY
         cwYL8j5SinO+dMr7u0hb01er0ZA+nA+/F/yfdhBJpc8B148bboJx/B/fOhSk/E8H0PTt
         c2mkjp/o08AkF02Syg+D2pgc2dm4OUS4FZZq2BgIDllvnLCcGCaaU/AfzBC+njp9F+xu
         Q9Pb2e/FKK58dX1Y4vXbzQTJkRtvtPB3HlLrMcBF4ecyHH498ESYbpn5IlYeYuVsmWRC
         HKSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=0eZpwWo8VKrZyzhNGjkeRdWzsShI5Q7vYkqK3O6Q2gQ=;
        b=ECFQAN2bHJfdXXHKDI7tHBCLSpfkIB06/2h7oU6RC7vJ+wdp3T62fmyhvJw/Gf4a76
         nTyU+TsWCOPdgNvg4gdIqP15PST4gErY5wt8m1AcOtRaK8DludYk4+bnhJNUg/0RSup2
         TYQtYkANs4TqtYUd+NbC+JBYjgkZdZzt/+RtiwtI4EF/VCeHrWsC6iQrL1YF8cNeZBrm
         3Ag+CnEmN76Ppkxe/Ld+/jHy2TL9Epf9C0htLoowtZmmswR8cEQlwluH3mlYlVnY37Je
         ql0NtRmxJRElez8WQGKYMMFWnT4CwFnOFkkMgOW1Ui5gnFpgcSXVPd7pQYjeLM/Xmqhu
         squA==
X-Gm-Message-State: APjAAAXjMRiNY/JC+dh2ZDbN2SrgFoJgp1Eo8vLtgzIc/qjQn/sYImOT
        KvAauFi5JVxFqz3rw4ltiVoRokPksaf2/EJfpp1IGdTo40LGx/IT9b31jRKnNCH95eQmIoWztM5
        H8cNEW59Jz3n0HfNwoixsS5i6CnWEBbUBCnqlggc4JpaPKdHhwMzqLg==
X-Google-Smtp-Source: APXvYqw6ApShJiDfG9BfBdAApHdAvhqN6O+obB4P7OaqluKNK26WIpsmTGeqvoj6FhTla3T1jwcWcAE=
X-Received: by 2002:a63:5f01:: with SMTP id t1mr8658607pgb.200.1565713598275;
 Tue, 13 Aug 2019 09:26:38 -0700 (PDT)
Date:   Tue, 13 Aug 2019 09:26:28 -0700
In-Reply-To: <20190813162630.124544-1-sdf@google.com>
Message-Id: <20190813162630.124544-3-sdf@google.com>
Mime-Version: 1.0
References: <20190813162630.124544-1-sdf@google.com>
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
Subject: [PATCH bpf-next v3 2/4] bpf: support cloning sk storage on accept()
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
Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 include/net/bpf_sk_storage.h |  10 ++++
 include/uapi/linux/bpf.h     |   3 +
 net/core/bpf_sk_storage.c    | 103 ++++++++++++++++++++++++++++++++++-
 net/core/sock.c              |   9 ++-
 4 files changed, 119 insertions(+), 6 deletions(-)

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
index 94c7f77ecb6b..1bc7de7e18ba 100644
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
@@ -739,6 +748,94 @@ static int bpf_fd_sk_storage_delete_elem(struct bpf_map *map, void *key)
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
+	int ret;
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
+		map = bpf_map_inc_not_zero(&smap->map, false);
+		if (IS_ERR(map))
+			continue;
+
+		copy_selem = bpf_sk_storage_clone_elem(newsk, smap, selem);
+		if (!copy_selem) {
+			ret = -ENOMEM;
+			bpf_map_put(map);
+			goto err;
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
+				goto err;
+			}
+
+			new_sk_storage = rcu_dereference(copy_selem->sk_storage);
+		}
+		bpf_map_put(map);
+	}
+
+out:
+	rcu_read_unlock();
+	return 0;
+
+err:
+	rcu_read_unlock();
+
+	/* Don't free anything explicitly here, caller is responsible to
+	 * call bpf_sk_storage_free in case of an error.
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


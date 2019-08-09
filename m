Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB5887F0E
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 18:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437076AbfHIQKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 12:10:47 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:45026 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437054AbfHIQKq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 12:10:46 -0400
Received: by mail-pg1-f202.google.com with SMTP id i134so22771541pgd.11
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 09:10:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=St6gCboTFsecODZFjGWbop1aBmTwfi1oqupff6AR/2o=;
        b=rmaF/r+bTmAg2FBT1H2BCdITicz/5GZbhjvBL12thfAL3oe6tFcm82OZOM2SMscfJx
         yNhndZTwvN/Qg/TetbcsEWNrvPoHWFmfPsaE39YRLH2wy0aqs5Qks0CDyz9ZcXsO69VB
         0gb6ZbHpN0V8AZpQZs/7OqZ23vWBbU5jL3BBwckEZu83EOpfmGCT6tHY3dl5BVZbddhj
         IkaA84N3PNkFqJ++fOWOMa0S7e4GE+mtARf6B1gw0xS9p+Vcv06iq2ixo4h0AmJ9pEHX
         j71lnJWIVZ7aWS04O68c20ml1ZluD4tsj85Usz9E9pC+TV69n9Wsaah/AXDQhVso/+BF
         D5oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=St6gCboTFsecODZFjGWbop1aBmTwfi1oqupff6AR/2o=;
        b=C2imnt63musG0qddTEe/4mFsFhSk9/txPLUXMm5tmomlGJDe7FAdoZTysmygcAp5ZF
         mSEjhQzQSd5ZpbbHyIDE96cCOlcuFD5hG+TjspPYSpPqhI0rRwkmA90u093qZAsgyYtu
         jaUSVPV3gt5KLEyEkZPcthZu8o8GfE/sIiviQ/jf1CWsOZCFlL5hUUKnxHNb90qMk5yF
         C02nVm21qHeyfBgUg0QQGXiAymvZOyfov2DC/FcVhQMcsgWrrL3+PzNuHpY74fpkYieL
         MHD0nvP7LXydIdsDbHsBEtw4vcp5pUf2aKm0ftsPaM8AU/IRcVj1WQnlDXsiEP0Krofy
         S3Jw==
X-Gm-Message-State: APjAAAXuuLi+cRbd/5SlYSEX3nLP/Q25He2Kpj7UpO3sovM+ZiWXSsnz
        GLHt2RqcGUaKd4NMJI+pDdQYAK4HntepqcSvXlGAXrBWQvQxqrBspH3BBjLGpoQiEp/DZWIkr4Z
        jydC9oIxHurzcXstKJ+RH/Rv5oPzUf78EqRrRxkLec6NfMGZ0jah8Xw==
X-Google-Smtp-Source: APXvYqwBTRuC16P6jswveJNdrNvAXCdep50j64KIDHaqTzLzG2sI2hHncS3/wZLbARPvAmQPvPt8k/E=
X-Received: by 2002:a65:464d:: with SMTP id k13mr16233870pgr.99.1565367045630;
 Fri, 09 Aug 2019 09:10:45 -0700 (PDT)
Date:   Fri,  9 Aug 2019 09:10:36 -0700
In-Reply-To: <20190809161038.186678-1-sdf@google.com>
Message-Id: <20190809161038.186678-3-sdf@google.com>
Mime-Version: 1.0
References: <20190809161038.186678-1-sdf@google.com>
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
Subject: [PATCH bpf-next v2 2/4] bpf: support cloning sk storage on accept()
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
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 include/net/bpf_sk_storage.h |  10 ++++
 include/uapi/linux/bpf.h     |   3 ++
 net/core/bpf_sk_storage.c    | 100 +++++++++++++++++++++++++++++++++--
 net/core/sock.c              |   9 ++--
 4 files changed, 116 insertions(+), 6 deletions(-)

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
index 94c7f77ecb6b..584e08ee0ca3 100644
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
@@ -601,7 +608,8 @@ static void bpf_sk_storage_map_free(struct bpf_map *map)
 
 static int bpf_sk_storage_map_alloc_check(union bpf_attr *attr)
 {
-	if (attr->map_flags != BPF_F_NO_PREALLOC || attr->max_entries ||
+	if (attr->map_flags & ~SK_STORAGE_CREATE_FLAG_MASK ||
+	    attr->max_entries ||
 	    attr->key_size != sizeof(int) || !attr->value_size ||
 	    /* Enforce BTF for userspace sk dumping */
 	    !attr->btf_key_type_id || !attr->btf_value_type_id)
@@ -739,6 +747,92 @@ static int bpf_fd_sk_storage_delete_elem(struct bpf_map *map, void *key)
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
+		int refold;
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
+	bpf_sk_storage_free(newsk);
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 471F785035
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 17:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388761AbfHGPr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 11:47:28 -0400
Received: from mail-ua1-f73.google.com ([209.85.222.73]:32943 "EHLO
        mail-ua1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388756AbfHGPr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 11:47:28 -0400
Received: by mail-ua1-f73.google.com with SMTP id p19so8567332uar.0
        for <netdev@vger.kernel.org>; Wed, 07 Aug 2019 08:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=VLXnKbrJ5BJ+5Tv3HxDjr0Ckwkfl2QJDY6DeBzafrPU=;
        b=TolBqeekETGlTybEM0sPuTnaflnOj9I+kmkiybYbnlZbCNLvrNk2zgvrNYPjnn/q8J
         774AblQyF74REyviq4zDzVKk7oDn/qNGu+aUvTzKhHsg3y8hmZJ5KxO4/2O8LaL5jaCy
         wpAVzw4E+cAFz2RbrbrcEBuForWhoLimaic7DmZy8oEajtmThAtJxESxeF+z+4duPYBd
         eiAzbpqEuir/3lxdyK+lYRNvGzsY9uNrf5Bi3NfDz8EPj7nu97D8ybIIJnzkOBPfhhBh
         rgojO2R4lBRO7ohq1+jcF/Ip+NGv03qG22gINxdSrhUfdlDIU6P/zkwSuZQhR5sz9SL3
         nNiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=VLXnKbrJ5BJ+5Tv3HxDjr0Ckwkfl2QJDY6DeBzafrPU=;
        b=sccvUQDpf2SvLPlkVb5fku4f8jwntUa196kSP6H0wLZMRU1tRMwr6fZ1H3IcNfPa9L
         X0jQpkD4KtiYtoImnMJuGUssOcse8fNiV/lKvv5OtCHa6h23JJPo5ZaDT0cW+a9/6Ra8
         Go856VMGfGpqRBPZ9J9S7VRU6UV5qw4SYzKV2yHJUp9bkABLL3V5NPQT+qz5YsOz+ukw
         QFYIB0+RmF48shNh+Dm/tkw7HoN5/dhfBiVNLJEu/m1qkRpCRRuLNp5FuxwGRLzIuk7U
         7sh9XVZVD37mex/leK5bgpetK8SnplbFYltMvph5dImDChRXRvkiWzmGz+R5V0tOB9vT
         bgXQ==
X-Gm-Message-State: APjAAAXbKPmrpdKFCc+LsIS9CfMoVsNX8KBAFi8ykxGo4voAFq2vAK+k
        aHoX/sEuz6X7Ofocr10uZoRjtx/MFPOfGY1kPN9UpZf1iw/7xzfmbkOwnPdeoKoNQ7duwXmJTCG
        v2ERiyU5LeAeyRjrbUK2HUGwNI8OO5T+PMTN3UtVVSJHCB8quVL8TKg==
X-Google-Smtp-Source: APXvYqwjSlyIAHHsUsVvXsEG3Y3rKTBkguiPnUorpBDcaTNjaTu2RO0kDjB5diyby28ixQvNJz4CoX4=
X-Received: by 2002:a1f:d687:: with SMTP id n129mr3365819vkg.71.1565192847022;
 Wed, 07 Aug 2019 08:47:27 -0700 (PDT)
Date:   Wed,  7 Aug 2019 08:47:18 -0700
In-Reply-To: <20190807154720.260577-1-sdf@google.com>
Message-Id: <20190807154720.260577-2-sdf@google.com>
Mime-Version: 1.0
References: <20190807154720.260577-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.770.g0f2c4a37fd-goog
Subject: [PATCH bpf-next 1/3] bpf: support cloning sk storage on accept()
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new helper bpf_sk_storage_clone which optionally clones sk storage
and call it from bpf_sk_storage_clone. Reuse the gap in
bpf_sk_storage_elem to store clone/non-clone flag.

Cc: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 include/net/bpf_sk_storage.h |  10 ++++
 include/uapi/linux/bpf.h     |   1 +
 net/core/bpf_sk_storage.c    | 102 +++++++++++++++++++++++++++++++++--
 net/core/sock.c              |   9 ++--
 4 files changed, 115 insertions(+), 7 deletions(-)

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
index 4393bd4b2419..00459ca4c8cf 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2931,6 +2931,7 @@ enum bpf_func_id {
 
 /* BPF_FUNC_sk_storage_get flags */
 #define BPF_SK_STORAGE_GET_F_CREATE	(1ULL << 0)
+#define BPF_SK_STORAGE_GET_F_CLONE	(1ULL << 1)
 
 /* Mode for BPF_FUNC_skb_adjust_room helper. */
 enum bpf_adj_room_mode {
diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
index 94c7f77ecb6b..b6dea67965bc 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -12,6 +12,9 @@
 
 static atomic_t cache_idx;
 
+#define BPF_SK_STORAGE_GET_F_MASK	(BPF_SK_STORAGE_GET_F_CREATE | \
+					 BPF_SK_STORAGE_GET_F_CLONE)
+
 struct bucket {
 	struct hlist_head list;
 	raw_spinlock_t lock;
@@ -66,7 +69,8 @@ struct bpf_sk_storage_elem {
 	struct hlist_node snode;	/* Linked to bpf_sk_storage */
 	struct bpf_sk_storage __rcu *sk_storage;
 	struct rcu_head rcu;
-	/* 8 bytes hole */
+	u8 clone:1;
+	/* 7 bytes hole */
 	/* The data is stored in aother cacheline to minimize
 	 * the number of cachelines access during a cache hit.
 	 */
@@ -509,7 +513,7 @@ static int sk_storage_delete(struct sock *sk, struct bpf_map *map)
 	return 0;
 }
 
-/* Called by __sk_destruct() */
+/* Called by __sk_destruct() & bpf_sk_storage_clone() */
 void bpf_sk_storage_free(struct sock *sk)
 {
 	struct bpf_sk_storage_elem *selem;
@@ -739,19 +743,106 @@ static int bpf_fd_sk_storage_delete_elem(struct bpf_map *map, void *key)
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
+		return ERR_PTR(-ENOMEM);
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
+		struct bpf_sk_storage_map *smap;
+		struct bpf_sk_storage_elem *copy_selem;
+
+		if (!selem->clone)
+			continue;
+
+		smap = rcu_dereference(SDATA(selem)->smap);
+		if (!smap)
+			continue;
+
+		copy_selem = bpf_sk_storage_clone_elem(newsk, smap, selem);
+		if (IS_ERR(copy_selem)) {
+			ret = PTR_ERR(copy_selem);
+			goto err;
+		}
+
+		if (!new_sk_storage) {
+			ret = sk_storage_alloc(newsk, smap, copy_selem);
+			if (ret) {
+				kfree(copy_selem);
+				atomic_sub(smap->elem_size,
+					   &newsk->sk_omem_alloc);
+				goto err;
+			}
+
+			new_sk_storage = rcu_dereference(copy_selem->sk_storage);
+			continue;
+		}
+
+		raw_spin_lock_bh(&new_sk_storage->lock);
+		selem_link_map(smap, copy_selem);
+		__selem_link_sk(new_sk_storage, copy_selem);
+		raw_spin_unlock_bh(&new_sk_storage->lock);
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
 	struct bpf_sk_storage_data *sdata;
 
-	if (flags > BPF_SK_STORAGE_GET_F_CREATE)
+	if (flags & ~BPF_SK_STORAGE_GET_F_MASK)
+		return (unsigned long)NULL;
+
+	if ((flags & BPF_SK_STORAGE_GET_F_CLONE) &&
+	    !(flags & BPF_SK_STORAGE_GET_F_CREATE))
 		return (unsigned long)NULL;
 
 	sdata = sk_storage_lookup(sk, map, true);
 	if (sdata)
 		return (unsigned long)sdata->data;
 
-	if (flags == BPF_SK_STORAGE_GET_F_CREATE &&
+	if ((flags & BPF_SK_STORAGE_GET_F_CREATE) &&
 	    /* Cannot add new elem to a going away sk.
 	     * Otherwise, the new elem may become a leak
 	     * (and also other memory issues during map
@@ -762,6 +853,9 @@ BPF_CALL_4(bpf_sk_storage_get, struct bpf_map *, map, struct sock *, sk,
 		/* sk must be a fullsock (guaranteed by verifier),
 		 * so sock_gen_put() is unnecessary.
 		 */
+		if (!IS_ERR(sdata))
+			SELEM(sdata)->clone =
+				!!(flags & BPF_SK_STORAGE_GET_F_CLONE);
 		sock_put(sk);
 		return IS_ERR(sdata) ?
 			(unsigned long)NULL : (unsigned long)sdata->data;
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
2.22.0.770.g0f2c4a37fd-goog


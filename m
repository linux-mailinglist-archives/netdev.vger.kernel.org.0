Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28FE316F2E7
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 00:04:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729379AbgBYXEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 18:04:38 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:59966 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729336AbgBYXEh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 18:04:37 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01PMt83V000646
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 15:04:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=77qdx8kZlVArBTIp25wJ3IVHE6t0XHkIF0fCbhfXlRg=;
 b=fXql2irzSiedDCuGiq3aAI63v+ECeY/yXI6oVne7KE1lXAQIwUqwLEpM/s+x97ViE8Ov
 MiC1qaRsJqcMqbilz8uXJIi0cKGCbZdh/sjCSb2E8gDFZPZtxmrNpil+tYISg1evb8Vl
 0fmrxs/Kroo++HG4Q5jlzeTBDjA7VKvWSpI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ydcj0r3gf-13
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 15:04:33 -0800
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Tue, 25 Feb 2020 15:04:24 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id B41BB2940827; Tue, 25 Feb 2020 15:04:21 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v2 3/4] bpf: INET_DIAG support in bpf_sk_storage
Date:   Tue, 25 Feb 2020 15:04:21 -0800
Message-ID: <20200225230421.1975729-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200225230402.1974723-1-kafai@fb.com>
References: <20200225230402.1974723-1-kafai@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-25_09:2020-02-25,2020-02-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 spamscore=0
 bulkscore=0 lowpriorityscore=0 suspectscore=43 phishscore=0 clxscore=1015
 impostorscore=0 priorityscore=1501 malwarescore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002250161
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds INET_DIAG support to bpf_sk_storage.

1. Although this series adds bpf_sk_storage diag capability to inet sk,
   bpf_sk_storage is in general applicable to all fullsock.  Hence, the
   bpf_sk_storage logic will operate on SK_DIAG_* nlattr.  The caller
   will pass in its specific nesting nlattr (e.g. INET_DIAG_*) as
   the argument.

2. The request will be like:
	INET_DIAG_REQ_SK_BPF_STORAGES (nla_nest) (defined in latter patch)
		SK_DIAG_BPF_STORAGE_REQ_MAP_FD (nla_put_u32)
		SK_DIAG_BPF_STORAGE_REQ_MAP_FD (nla_put_u32)
		......

   Considering there could have multiple bpf_sk_storages in a sk,
   instead of reusing INET_DIAG_INFO ("ss -i"),  the user can select
   some specific bpf_sk_storage to dump by specifying an array of
   SK_DIAG_BPF_STORAGE_REQ_MAP_FD.

   If no SK_DIAG_BPF_STORAGE_REQ_MAP_FD is specified (i.e. an empty
   INET_DIAG_REQ_SK_BPF_STORAGES), it will dump all bpf_sk_storages
   of a sk.

3. The reply will be like:
	INET_DIAG_BPF_SK_STORAGES (nla_nest) (defined in latter patch)
		SK_DIAG_BPF_STORAGE (nla_nest)
			SK_DIAG_BPF_STORAGE_MAP_ID (nla_put_u32)
			SK_DIAG_BPF_STORAGE_MAP_VALUE (nla_reserve_64bit)
		SK_DIAG_BPF_STORAGE (nla_nest)
			SK_DIAG_BPF_STORAGE_MAP_ID (nla_put_u32)
			SK_DIAG_BPF_STORAGE_MAP_VALUE (nla_reserve_64bit)
		......

4. Unlike other INET_DIAG info of a sk which is pretty static, the size
   required to dump the bpf_sk_storage(s) of a sk is dynamic as the
   system adding more bpf_sk_storage_map.  It is hard to set a static
   min_dump_alloc size.

   Hence, this series learns it at the runtime and adjust the
   cb->min_dump_alloc as it iterates all sk(s) of a system.  The
   "unsigned int *res_diag_size" in bpf_sk_storage_diag_put()
   is for this purpose.

   The next patch will update the cb->min_dump_alloc as it
   iterates the sk(s).

Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/linux/bpf.h            |   1 +
 include/net/bpf_sk_storage.h   |  27 ++++
 include/uapi/linux/sock_diag.h |  26 +++
 kernel/bpf/syscall.c           |  15 ++
 net/core/bpf_sk_storage.c      | 283 ++++++++++++++++++++++++++++++++-
 5 files changed, 346 insertions(+), 6 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 1acd5bf70350..3b6973d4d6d5 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1023,6 +1023,7 @@ void __bpf_free_used_maps(struct bpf_prog_aux *aux,
 void bpf_prog_free_id(struct bpf_prog *prog, bool do_idr_lock);
 void bpf_map_free_id(struct bpf_map *map, bool do_idr_lock);
 
+struct bpf_map *bpf_map_get(u32 ufd);
 struct bpf_map *bpf_map_get_with_uref(u32 ufd);
 struct bpf_map *__bpf_map_get(struct fd f);
 void bpf_map_inc(struct bpf_map *map);
diff --git a/include/net/bpf_sk_storage.h b/include/net/bpf_sk_storage.h
index 8e4f831d2e52..5036c94c0503 100644
--- a/include/net/bpf_sk_storage.h
+++ b/include/net/bpf_sk_storage.h
@@ -10,14 +10,41 @@ void bpf_sk_storage_free(struct sock *sk);
 extern const struct bpf_func_proto bpf_sk_storage_get_proto;
 extern const struct bpf_func_proto bpf_sk_storage_delete_proto;
 
+struct bpf_sk_storage_diag;
+struct sk_buff;
+struct nlattr;
+struct sock;
+
 #ifdef CONFIG_BPF_SYSCALL
 int bpf_sk_storage_clone(const struct sock *sk, struct sock *newsk);
+struct bpf_sk_storage_diag *
+bpf_sk_storage_diag_alloc(const struct nlattr *nla_stgs);
+void bpf_sk_storage_diag_free(struct bpf_sk_storage_diag *diag);
+int bpf_sk_storage_diag_put(struct bpf_sk_storage_diag *diag,
+			    struct sock *sk, struct sk_buff *skb,
+			    int stg_array_type,
+			    unsigned int *res_diag_size);
 #else
 static inline int bpf_sk_storage_clone(const struct sock *sk,
 				       struct sock *newsk)
 {
 	return 0;
 }
+static inline struct bpf_sk_storage_diag *
+bpf_sk_storage_diag_alloc(const struct nlattr *nla)
+{
+	return NULL;
+}
+static inline void bpf_sk_storage_diag_free(struct bpf_sk_storage_diag *diag)
+{
+}
+static inline int bpf_sk_storage_diag_put(struct bpf_sk_storage_diag *diag,
+					  struct sock *sk, struct sk_buff *skb,
+					  int stg_array_type,
+					  unsigned int *res_diag_size)
+{
+	return 0;
+}
 #endif
 
 #endif /* _BPF_SK_STORAGE_H */
diff --git a/include/uapi/linux/sock_diag.h b/include/uapi/linux/sock_diag.h
index e5925009a652..5f74a5f6091d 100644
--- a/include/uapi/linux/sock_diag.h
+++ b/include/uapi/linux/sock_diag.h
@@ -36,4 +36,30 @@ enum sknetlink_groups {
 };
 #define SKNLGRP_MAX	(__SKNLGRP_MAX - 1)
 
+enum {
+	SK_DIAG_BPF_STORAGE_REQ_NONE,
+	SK_DIAG_BPF_STORAGE_REQ_MAP_FD,
+	__SK_DIAG_BPF_STORAGE_REQ_MAX,
+};
+
+#define SK_DIAG_BPF_STORAGE_REQ_MAX	(__SK_DIAG_BPF_STORAGE_REQ_MAX - 1)
+
+enum {
+	SK_DIAG_BPF_STORAGE_REP_NONE,
+	SK_DIAG_BPF_STORAGE,
+	__SK_DIAG_BPF_STORAGE_REP_MAX,
+};
+
+#define SK_DIAB_BPF_STORAGE_REP_MAX	(__SK_DIAG_BPF_STORAGE_REP_MAX - 1)
+
+enum {
+	SK_DIAG_BPF_STORAGE_NONE,
+	SK_DIAG_BPF_STORAGE_PAD,
+	SK_DIAG_BPF_STORAGE_MAP_ID,
+	SK_DIAG_BPF_STORAGE_MAP_VALUE,
+	__SK_DIAG_BPF_STORAGE_MAX,
+};
+
+#define SK_DIAG_BPF_STORAGE_MAX        (__SK_DIAG_BPF_STORAGE_MAX - 1)
+
 #endif /* _UAPI__SOCK_DIAG_H__ */
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index a79743a89815..c536c65256ad 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -902,6 +902,21 @@ void bpf_map_inc_with_uref(struct bpf_map *map)
 }
 EXPORT_SYMBOL_GPL(bpf_map_inc_with_uref);
 
+struct bpf_map *bpf_map_get(u32 ufd)
+{
+	struct fd f = fdget(ufd);
+	struct bpf_map *map;
+
+	map = __bpf_map_get(f);
+	if (IS_ERR(map))
+		return map;
+
+	bpf_map_inc(map);
+	fdput(f);
+
+	return map;
+}
+
 struct bpf_map *bpf_map_get_with_uref(u32 ufd)
 {
 	struct fd f = fdget(ufd);
diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
index 3ab23f698221..3415a4896c59 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -8,6 +8,7 @@
 #include <linux/bpf.h>
 #include <net/bpf_sk_storage.h>
 #include <net/sock.h>
+#include <uapi/linux/sock_diag.h>
 #include <uapi/linux/btf.h>
 
 static atomic_t cache_idx;
@@ -606,6 +607,14 @@ static void bpf_sk_storage_map_free(struct bpf_map *map)
 	kfree(map);
 }
 
+/* U16_MAX is much more than enough for sk local storage
+ * considering a tcp_sock is ~2k.
+ */
+#define MAX_VALUE_SIZE							\
+	min_t(u32,							\
+	      (KMALLOC_MAX_SIZE - MAX_BPF_STACK - sizeof(struct bpf_sk_storage_elem)), \
+	      (U16_MAX - sizeof(struct bpf_sk_storage_elem)))
+
 static int bpf_sk_storage_map_alloc_check(union bpf_attr *attr)
 {
 	if (attr->map_flags & ~SK_STORAGE_CREATE_FLAG_MASK ||
@@ -619,12 +628,7 @@ static int bpf_sk_storage_map_alloc_check(union bpf_attr *attr)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (attr->value_size >= KMALLOC_MAX_SIZE -
-	    MAX_BPF_STACK - sizeof(struct bpf_sk_storage_elem) ||
-	    /* U16_MAX is much more than enough for sk local storage
-	     * considering a tcp_sock is ~2k.
-	     */
-	    attr->value_size > U16_MAX - sizeof(struct bpf_sk_storage_elem))
+	if (attr->value_size > MAX_VALUE_SIZE)
 		return -E2BIG;
 
 	return 0;
@@ -910,3 +914,270 @@ const struct bpf_func_proto bpf_sk_storage_delete_proto = {
 	.arg1_type	= ARG_CONST_MAP_PTR,
 	.arg2_type	= ARG_PTR_TO_SOCKET,
 };
+
+struct bpf_sk_storage_diag {
+	u32 nr_maps;
+	struct bpf_map *maps[];
+};
+
+/* The reply will be like:
+ * INET_DIAG_BPF_SK_STORAGES (nla_nest)
+ *	SK_DIAG_BPF_STORAGE (nla_nest)
+ *		SK_DIAG_BPF_STORAGE_MAP_ID (nla_put_u32)
+ *		SK_DIAG_BPF_STORAGE_MAP_VALUE (nla_reserve_64bit)
+ *	SK_DIAG_BPF_STORAGE (nla_nest)
+ *		SK_DIAG_BPF_STORAGE_MAP_ID (nla_put_u32)
+ *		SK_DIAG_BPF_STORAGE_MAP_VALUE (nla_reserve_64bit)
+ *	....
+ */
+static int nla_value_size(u32 value_size)
+{
+	/* SK_DIAG_BPF_STORAGE (nla_nest)
+	 *	SK_DIAG_BPF_STORAGE_MAP_ID (nla_put_u32)
+	 *	SK_DIAG_BPF_STORAGE_MAP_VALUE (nla_reserve_64bit)
+	 */
+	return nla_total_size(0) + nla_total_size(sizeof(u32)) +
+		nla_total_size_64bit(value_size);
+}
+
+void bpf_sk_storage_diag_free(struct bpf_sk_storage_diag *diag)
+{
+	u32 i;
+
+	if (!diag)
+		return;
+
+	for (i = 0; i < diag->nr_maps; i++)
+		bpf_map_put(diag->maps[i]);
+
+	kfree(diag);
+}
+EXPORT_SYMBOL_GPL(bpf_sk_storage_diag_free);
+
+static bool diag_check_dup(const struct bpf_sk_storage_diag *diag,
+			   const struct bpf_map *map)
+{
+	u32 i;
+
+	for (i = 0; i < diag->nr_maps; i++) {
+		if (diag->maps[i] == map)
+			return true;
+	}
+
+	return false;
+}
+
+struct bpf_sk_storage_diag *
+bpf_sk_storage_diag_alloc(const struct nlattr *nla_stgs)
+{
+	struct bpf_sk_storage_diag *diag;
+	struct nlattr *nla;
+	u32 nr_maps = 0;
+	int rem, err;
+
+	/* bpf_sk_storage_map is currently limited to CAP_SYS_ADMIN as
+	 * the map_alloc_check() side also does.
+	 */
+	if (!capable(CAP_SYS_ADMIN))
+		return ERR_PTR(-EPERM);
+
+	nla_for_each_nested(nla, nla_stgs, rem) {
+		if (nla_type(nla) == SK_DIAG_BPF_STORAGE_REQ_MAP_FD)
+			nr_maps++;
+	}
+
+	diag = kzalloc(sizeof(*diag) + sizeof(diag->maps[0]) * nr_maps,
+		       GFP_KERNEL);
+	if (!diag)
+		return ERR_PTR(-ENOMEM);
+
+	nla_for_each_nested(nla, nla_stgs, rem) {
+		struct bpf_map *map;
+		int map_fd;
+
+		if (nla_type(nla) != SK_DIAG_BPF_STORAGE_REQ_MAP_FD)
+			continue;
+
+		map_fd = nla_get_u32(nla);
+		map = bpf_map_get(map_fd);
+		if (IS_ERR(map)) {
+			err = PTR_ERR(map);
+			goto err_free;
+		}
+		if (map->map_type != BPF_MAP_TYPE_SK_STORAGE) {
+			bpf_map_put(map);
+			err = -EINVAL;
+			goto err_free;
+		}
+		if (diag_check_dup(diag, map)) {
+			bpf_map_put(map);
+			err = -EEXIST;
+			goto err_free;
+		}
+		diag->maps[diag->nr_maps++] = map;
+	}
+
+	return diag;
+
+err_free:
+	bpf_sk_storage_diag_free(diag);
+	return ERR_PTR(err);
+}
+EXPORT_SYMBOL_GPL(bpf_sk_storage_diag_alloc);
+
+static int diag_get(struct bpf_sk_storage_data *sdata, struct sk_buff *skb)
+{
+	struct nlattr *nla_stg, *nla_value;
+	struct bpf_sk_storage_map *smap;
+
+	/* It cannot exceed max nlattr's payload */
+	BUILD_BUG_ON(U16_MAX - NLA_HDRLEN < MAX_VALUE_SIZE);
+
+	nla_stg = nla_nest_start(skb, SK_DIAG_BPF_STORAGE);
+	if (!nla_stg)
+		return -EMSGSIZE;
+
+	smap = rcu_dereference(sdata->smap);
+	if (nla_put_u32(skb, SK_DIAG_BPF_STORAGE_MAP_ID, smap->map.id))
+		goto errout;
+
+	nla_value = nla_reserve_64bit(skb, SK_DIAG_BPF_STORAGE_MAP_VALUE,
+				      smap->map.value_size,
+				      SK_DIAG_BPF_STORAGE_PAD);
+	if (!nla_value)
+		goto errout;
+
+	if (map_value_has_spin_lock(&smap->map))
+		copy_map_value_locked(&smap->map, nla_data(nla_value),
+				      sdata->data, true);
+	else
+		copy_map_value(&smap->map, nla_data(nla_value), sdata->data);
+
+	nla_nest_end(skb, nla_stg);
+	return 0;
+
+errout:
+	nla_nest_cancel(skb, nla_stg);
+	return -EMSGSIZE;
+}
+
+static int bpf_sk_storage_diag_put_all(struct sock *sk, struct sk_buff *skb,
+				       int stg_array_type,
+				       unsigned int *res_diag_size)
+{
+	/* stg_array_type (e.g. INET_DIAG_BPF_SK_STORAGES) */
+	unsigned int diag_size = nla_total_size(0);
+	struct bpf_sk_storage *sk_storage;
+	struct bpf_sk_storage_elem *selem;
+	struct bpf_sk_storage_map *smap;
+	struct nlattr *nla_stgs;
+	unsigned int saved_len;
+	int err = 0;
+
+	rcu_read_lock();
+
+	sk_storage = rcu_dereference(sk->sk_bpf_storage);
+	if (!sk_storage || hlist_empty(&sk_storage->list)) {
+		rcu_read_unlock();
+		return 0;
+	}
+
+	nla_stgs = nla_nest_start(skb, stg_array_type);
+	if (!nla_stgs)
+		/* Continue to learn diag_size */
+		err = -EMSGSIZE;
+
+	saved_len = skb->len;
+	hlist_for_each_entry_rcu(selem, &sk_storage->list, snode) {
+		smap = rcu_dereference(SDATA(selem)->smap);
+		diag_size += nla_value_size(smap->map.value_size);
+
+		if (nla_stgs && diag_get(SDATA(selem), skb))
+			/* Continue to learn diag_size */
+			err = -EMSGSIZE;
+	}
+
+	rcu_read_unlock();
+
+	if (nla_stgs) {
+		if (saved_len == skb->len)
+			nla_nest_cancel(skb, nla_stgs);
+		else
+			nla_nest_end(skb, nla_stgs);
+	}
+
+	if (diag_size == nla_total_size(0)) {
+		*res_diag_size = 0;
+		return 0;
+	}
+
+	*res_diag_size = diag_size;
+	return err;
+}
+
+int bpf_sk_storage_diag_put(struct bpf_sk_storage_diag *diag,
+			    struct sock *sk, struct sk_buff *skb,
+			    int stg_array_type,
+			    unsigned int *res_diag_size)
+{
+	/* stg_array_type (e.g. INET_DIAG_BPF_SK_STORAGES) */
+	unsigned int diag_size = nla_total_size(0);
+	struct bpf_sk_storage *sk_storage;
+	struct bpf_sk_storage_data *sdata;
+	struct nlattr *nla_stgs;
+	unsigned int saved_len;
+	int err = 0;
+	u32 i;
+
+	*res_diag_size = 0;
+
+	/* No map has been specified.  Dump all. */
+	if (!diag->nr_maps)
+		return bpf_sk_storage_diag_put_all(sk, skb, stg_array_type,
+						   res_diag_size);
+
+	rcu_read_lock();
+	sk_storage = rcu_dereference(sk->sk_bpf_storage);
+	if (!sk_storage || hlist_empty(&sk_storage->list)) {
+		rcu_read_unlock();
+		return 0;
+	}
+
+	nla_stgs = nla_nest_start(skb, stg_array_type);
+	if (!nla_stgs)
+		/* Continue to learn diag_size */
+		err = -EMSGSIZE;
+
+	saved_len = skb->len;
+	for (i = 0; i < diag->nr_maps; i++) {
+		sdata = __sk_storage_lookup(sk_storage,
+				(struct bpf_sk_storage_map *)diag->maps[i],
+				false);
+
+		if (!sdata)
+			continue;
+
+		diag_size += nla_value_size(diag->maps[i]->value_size);
+
+		if (nla_stgs && diag_get(sdata, skb))
+			/* Continue to learn diag_size */
+			err = -EMSGSIZE;
+	}
+	rcu_read_unlock();
+
+	if (nla_stgs) {
+		if (saved_len == skb->len)
+			nla_nest_cancel(skb, nla_stgs);
+		else
+			nla_nest_end(skb, nla_stgs);
+	}
+
+	if (diag_size == nla_total_size(0)) {
+		*res_diag_size = 0;
+		return 0;
+	}
+
+	*res_diag_size = diag_size;
+	return err;
+}
+EXPORT_SYMBOL_GPL(bpf_sk_storage_diag_put);
-- 
2.17.1


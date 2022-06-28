Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C29A55EE3C
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231901AbiF1TxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:53:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231344AbiF1Tuy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:50:54 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8A3032A;
        Tue, 28 Jun 2022 12:49:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656445775; x=1687981775;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aCT7NnW5qPpXUE6PtAGgHOwhQXci7vR5TCit02FfCKA=;
  b=LtdfgLRuo4Hoh3h0n/cMTHpuB6VfSrVy6ps0knn7S4Om2jj2Pt8Kmzkd
   i0qFl8Smyr0rmsIhjfRZ2AhNVPpo7gDRdkEQas2T4xhWWcNJ3Nlqoc0Xv
   sCwMxkDoDDmmBvzwVF2ljLfHR0q5iJ1F9hyByFuP5cU89sCFmZs2DuAxh
   fbKey+CYfRjaIB6uG4Q2uw4biD02nntbi2tqGk8P/Bq+0LqDYT/qjowkt
   8Sj7n/VhrFecUB4YZmXKi0pGYRPWhAloYk0RfljWYa/m8GmVcJXw5aZPM
   b3/hYojjhwxa/HJPjriU6SYNnJ+1z+Dp1ntoYk7s7hvdKFazObhpP3hGI
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="282568197"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="282568197"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 12:49:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="587988541"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga007.jf.intel.com with ESMTP; 28 Jun 2022 12:49:30 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25SJmr9Q022013;
        Tue, 28 Jun 2022 20:49:28 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Toke Hoiland-Jorgensen <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Yajun Deng <yajun.deng@linux.dev>,
        Willem de Bruijn <willemb@google.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xdp-hints@xdp-project.net
Subject: [PATCH RFC bpf-next 26/52] bpf, btf: add a pair of function to work with the BTF ID + type ID pair
Date:   Tue, 28 Jun 2022 21:47:46 +0200
Message-Id: <20220628194812.1453059-27-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
References: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a kernel counterpart of libbpf_get_type_btf_id() to easily get
the pair of BTF ID << 32 | type ID for the provided type. Drivers
and the XDP core will use it to handle different XDP generic
metadata formats.

Also add a function to return matching type string (e.g.
"struct foo") index from an array of such strings for a given BTF
ID + type ID pair. The intention is to be able to quickly identify
the ID received from somewhere else and to assign some own constant
identifiers to the supported types.
To not do:

	priv->foo_id = bpf_get_type_btf_id("struct foo");
	priv->bar_id = bpf_get_type_btf_id("struct bar");

[...]

	if (id == priv->foo_id)
		do_smth_for_foo();
	else if (id == priv->bar_id)
		do_smth_for_bar();
	else
		unsupp();

but instead:

const char * const supp[] = {
	[FOO_ID] = "struct foo",
	[BAR_ID] = "struct bar",
	NULL,				// serves as a terminator, can be ""
};

[...]

	type = bpf_match_type_btf_id(supp, id);
	switch(type) {
	case FOO_ID:
		do_smth_for_foo();
		break;
	case BAR_ID:
		do_smth_for_bar();
		break;
	default:
		unsupp();
		break;
	}

Aux function:
 * btf_kind_from_str(): returns the kind of the provided full type
   string and removes the kind identifier to e.g. be able to pass it
   directly to btf_find_by_name_kind(). For example, "struct foo"
   becomes "foo" and the return value will be BTF_KIND_STRUCT.
 * btf_get_by_id() is a shorthand to quickly get the BTF by its ID,
   factored-out from btf_get_fd_by_id().

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 include/linux/btf.h |  13 +++++
 kernel/bpf/btf.c    | 133 ++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 140 insertions(+), 6 deletions(-)

diff --git a/include/linux/btf.h b/include/linux/btf.h
index 1bfed7fa0428..36bc9c499409 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -386,6 +386,8 @@ int register_btf_kfunc_id_set(enum bpf_prog_type prog_type,
 s32 btf_find_dtor_kfunc(struct btf *btf, u32 btf_id);
 int register_btf_id_dtor_kfuncs(const struct btf_id_dtor_kfunc *dtors, u32 add_cnt,
 				struct module *owner);
+int bpf_get_type_btf_id(const char *type, u64 *res_id);
+int bpf_match_type_btf_id(const char * const *list, u64 id);
 #else
 static inline const struct btf_type *btf_type_by_id(const struct btf *btf,
 						    u32 type_id)
@@ -418,6 +420,17 @@ static inline int register_btf_id_dtor_kfuncs(const struct btf_id_dtor_kfunc *dt
 {
 	return 0;
 }
+static inline int bpf_get_type_btf_id(const char *type, u64 *res_id)
+{
+	if (res_id)
+		*res_id = 0;
+
+	return -ENOSYS;
+}
+static inline int bpf_match_type_btf_id(const char * const *list, u64 id)
+{
+	return -ENOSYS;
+}
 #endif
 
 #endif
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 2e2066d6af94..dc316c43a348 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -317,6 +317,28 @@ const char *btf_type_str(const struct btf_type *t)
 	return btf_kind_str[BTF_INFO_KIND(t->info)];
 }
 
+static u32 btf_kind_from_str(const char **type)
+{
+	const char *pos, *orig = *type;
+	u32 kind;
+	int len;
+
+	pos = strchr(orig, ' ');
+	if (pos) {
+		len = pos - orig;
+		*type = pos + 1;
+	} else {
+		len = strlen(orig);
+	}
+
+	for (kind = BTF_KIND_UNKN; kind < NR_BTF_KINDS; kind++) {
+		if (!strncasecmp(orig, btf_kind_str[kind], len))
+			break;
+	}
+
+	return kind < NR_BTF_KINDS ? kind : BTF_KIND_UNKN;
+}
+
 /* Chunk size we use in safe copy of data to be shown. */
 #define BTF_SHOW_OBJ_SAFE_SIZE		32
 
@@ -579,6 +601,110 @@ static s32 bpf_find_btf_id(const char *name, u32 kind, struct btf **btf_p)
 	return ret;
 }
 
+/**
+ * bpf_get_type_btf_id - get the pair BTF ID + type ID for a given type
+ * @type: pointer to the name of the type to look for
+ * @res_id: pointer to write the result to
+ *
+ * Tries to find the BTF corresponding to the provided type (full string) and
+ * write the pair of BTF ID << 32 | type ID. Such coded __u64 are being used
+ * in XDP generic-compatible metadata to distinguish between different
+ * metadata structures.
+ * @res_id can be %NULL to only check if a particular type exists within
+ * the BTF.
+ *
+ * Returns 0 in case of success, an error code otherwise.
+ */
+int bpf_get_type_btf_id(const char *type, u64 *res_id)
+{
+	struct btf *btf = NULL;
+	s32 type_id;
+	u32 kind;
+
+	if (res_id)
+		*res_id = 0;
+
+	if (!type || !*type)
+		return -EINVAL;
+
+	kind = btf_kind_from_str(&type);
+
+	type_id = bpf_find_btf_id(type, kind, &btf);
+	if (type_id > 0 && res_id)
+		*res_id = ((u64)btf_obj_id(btf) << 32) | type_id;
+
+	btf_put(btf);
+
+	return min(type_id, 0);
+}
+EXPORT_SYMBOL_GPL(bpf_get_type_btf_id);
+
+static struct btf *btf_get_by_id(u32 id)
+{
+	struct btf *btf;
+
+	rcu_read_lock();
+	btf = idr_find(&btf_idr, id);
+	if (!btf || !refcount_inc_not_zero(&btf->refcnt))
+		btf = ERR_PTR(-ENOENT);
+	rcu_read_unlock();
+
+	return btf;
+}
+
+/**
+ * bpf_match_type_btf_id - find a type name corresponding to a given full ID
+ * @list: pointer to the %NULL-terminated list of type names
+ * @id: full ID (BTF ID + type ID) of the type to look
+ *
+ * Do the opposite to what bpf_get_type_btf_id() does: looks over the
+ * candidates in %NULL-terminated @list and tries to find a match for
+ * the given ID. If found, returns its index.
+ *
+ * Returns a string array element index on success, an error code otherwise.
+ */
+int bpf_match_type_btf_id(const char * const *list, u64 id)
+{
+	const struct btf_type *t;
+	int ret = -ENOENT;
+	const char *name;
+	struct btf *btf;
+	u32 kind;
+
+	btf = btf_get_by_id(upper_32_bits(id));
+	if (IS_ERR(btf))
+		return PTR_ERR(btf);
+
+	t = btf_type_by_id(btf, lower_32_bits(id));
+	if (!t)
+		goto err_put;
+
+	name = btf_name_by_offset(btf, t->name_off);
+	if (!name) {
+		ret = -EINVAL;
+		goto err_put;
+	}
+
+	kind = BTF_INFO_KIND(t->info);
+
+	for (u32 i = 0; ; i++) {
+		const char *cand = list[i];
+
+		if (!cand)
+			break;
+
+		if (btf_kind_from_str(&cand) == kind && !strcmp(cand, name)) {
+			ret = i;
+			break;
+		}
+	}
+
+err_put:
+	btf_put(btf);
+
+	return ret;
+}
+
 const struct btf_type *btf_type_skip_modifiers(const struct btf *btf,
 					       u32 id, u32 *res_id)
 {
@@ -6804,12 +6930,7 @@ int btf_get_fd_by_id(u32 id)
 	struct btf *btf;
 	int fd;
 
-	rcu_read_lock();
-	btf = idr_find(&btf_idr, id);
-	if (!btf || !refcount_inc_not_zero(&btf->refcnt))
-		btf = ERR_PTR(-ENOENT);
-	rcu_read_unlock();
-
+	btf = btf_get_by_id(id);
 	if (IS_ERR(btf))
 		return PTR_ERR(btf);
 
-- 
2.36.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2BCF55EE27
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbiF1TvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:51:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232173AbiF1Tut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:50:49 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DC983A707;
        Tue, 28 Jun 2022 12:49:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656445744; x=1687981744;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=k1Fba8eV9f/mQyTWxsBVzDTB/kS8fIdX5n6chBSOvzk=;
  b=PeyzOwfvIBUvtl2KqOEYIf4ibqZUcb86+o14U0P7ii9pMyxpzEE6N3bG
   w3bOQrzdSsdus6YzVvLnM3jOw38A0SKJ1+0KJQ1ZQ7f7yOB0HC0dJaXIR
   rAr5M+PxKrOpPN7tZhW2/i8uOgSULA4FNwvRiwJfRRw+3xj6iBbWm9qP3
   KCI+jPfVpcKSS6oMKuxJWuuWFCdjMnYB0c81f5VO1mv8rRjWjy64kTOm6
   yGOS9PiX4ZP0QvV1rUgZAsRmmG338xksedMi+y7wuEriDG0vSK81wu0IO
   wyCpawc5qXMLx3VMMv4KK7Gxq21kcwTx7jyWFCb3a6EZNmJ/ce4lk2O+K
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="345828284"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="345828284"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 12:49:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="680182418"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by FMSMGA003.fm.intel.com with ESMTP; 28 Jun 2022 12:48:59 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25SJmr93022013;
        Tue, 28 Jun 2022 20:48:57 +0100
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
Subject: [PATCH RFC bpf-next 03/52] libbpf: add function to get the pair BTF ID + type ID for a given type
Date:   Tue, 28 Jun 2022 21:47:23 +0200
Message-Id: <20220628194812.1453059-4-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
References: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new libbpf API function libbpf_get_type_btf_id() to provide a
short way to get the pair of BTF ID << 32 | type ID for the provided
type. The primary purpose is to use it in userspace BPF prog loaders
to pass those IDs to the kernel to tell what XDP generic metadata to
create, as well as in AF_XDP programs to be able to compare them
against the ones from frame metadata.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 tools/lib/bpf/libbpf.c   | 113 +++++++++++++++++++++++++++++++++++++++
 tools/lib/bpf/libbpf.h   |   1 +
 tools/lib/bpf/libbpf.map |   1 +
 3 files changed, 115 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 8e27bad5e80f..9bda111c8167 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -2252,6 +2252,28 @@ const char *btf_kind_str(const struct btf_type *t)
 	return __btf_kind_str(btf_kind(t));
 }
 
+static __u32 btf_kind_from_str(const char **type)
+{
+	const char *pos, *orig = *type;
+	__u32 kind;
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
+		if (!strncmp(orig, __btf_kind_str(kind), len))
+			break;
+	}
+
+	return kind < NR_BTF_KINDS ? kind : BTF_KIND_UNKN;
+}
+
 /*
  * Fetch integer attribute of BTF map definition. Such attributes are
  * represented using a pointer to an array, in which dimensionality of array
@@ -9617,6 +9639,97 @@ int libbpf_find_vmlinux_btf_id(const char *name,
 	return libbpf_err(err);
 }
 
+static __s32 libbpf_find_btf_id(const char *type, __u32 kind,
+				struct btf **res_btf)
+{
+	char name[BTF_NAME_BUF_LEN] = { };
+	struct btf *vmlinux_btf, *btf;
+	struct bpf_btf_info info;
+	__u32 id = 0;
+	__s32 ret;
+
+	if (res_btf)
+		*res_btf = NULL;
+
+	if (!type || !*type)
+		return -EINVAL;
+
+	vmlinux_btf = btf__load_vmlinux_btf();
+	ret = libbpf_get_error(vmlinux_btf);
+	if (ret < 0)
+		goto free_vmlinux;
+
+	ret = btf__find_by_name_kind(vmlinux_btf, type, kind);
+	if (ret > 0) {
+		btf = vmlinux_btf;
+		goto out;
+	}
+
+	while (true) {
+		memset(&info, 0, sizeof(info));
+		info.name = ptr_to_u64(name);
+		info.name_len = sizeof(name);
+
+		btf = btf_load_next_with_info(id, &info, vmlinux_btf, false);
+		ret = libbpf_get_error(btf);
+		if (ret)
+			break;
+
+		ret = btf__find_by_name_kind(btf, type, kind);
+		if (ret > 0)
+			break;
+
+		id = btf_obj_id(btf);
+		btf__free(btf);
+	}
+
+free_vmlinux:
+	btf__free(vmlinux_btf);
+
+out:
+	if (ret > 0 && res_btf)
+		*res_btf = btf;
+
+	return ret ? : -ESRCH;
+}
+
+/**
+ * libbpf_get_type_btf_id - get the pair BTF ID + type ID for a given type
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
+ * Returns 0 in case of success, -errno otherwise.
+ */
+int libbpf_get_type_btf_id(const char *type, __u64 *res_id)
+{
+	struct btf *btf = NULL;
+	__s32 type_id;
+	__u32 kind;
+
+	if (res_id)
+		*res_id = 0;
+
+	if (!type || !*type)
+		return libbpf_err(-EINVAL);
+
+	kind = btf_kind_from_str(&type);
+
+	type_id = libbpf_find_btf_id(type, kind, &btf);
+	if (type_id > 0 && res_id)
+		*res_id = ((__u64)btf_obj_id(btf) << 32) | type_id;
+
+	btf__free(btf);
+
+	return libbpf_err(min(type_id, 0));
+}
+
 static int libbpf_find_prog_btf_id(const char *name, __u32 attach_prog_fd)
 {
 	struct bpf_prog_info info = {};
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index fa27969da0da..4056e9038086 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -295,6 +295,7 @@ LIBBPF_API int libbpf_attach_type_by_name(const char *name,
 					  enum bpf_attach_type *attach_type);
 LIBBPF_API int libbpf_find_vmlinux_btf_id(const char *name,
 					  enum bpf_attach_type attach_type);
+LIBBPF_API int libbpf_get_type_btf_id(const char *type, __u64 *id);
 
 /* Accessors of bpf_program */
 struct bpf_program;
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 116a2a8ee7c2..f0987df15b7a 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -468,6 +468,7 @@ LIBBPF_1.0.0 {
 		libbpf_bpf_link_type_str;
 		libbpf_bpf_map_type_str;
 		libbpf_bpf_prog_type_str;
+		libbpf_get_type_btf_id;
 
 	local: *;
 };
-- 
2.36.1


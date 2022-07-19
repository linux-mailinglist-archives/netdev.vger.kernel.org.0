Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 849A757A09C
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 16:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238659AbiGSOIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 10:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238468AbiGSOH7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 10:07:59 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93B6F52FCD;
        Tue, 19 Jul 2022 06:24:38 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id sz17so27132633ejc.9;
        Tue, 19 Jul 2022 06:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=P5a228g83nX88yA9CZii9+LIDBbZDlqneAHpFoJ933Y=;
        b=D9vslTAkoycx+kzpHSFktS2SfONZDXsXBGgWKrrWoS9CpQyWWwJPFOXlHW3k6iVGGs
         pmWBs8THga5YU14/2pghM1MWKFnjdLuLzB9Xm9OXq68qQOLEQ//mndvOChhccRX36XwL
         onpIl61l4Gc4tQj7/e9paO/iv5ewIUpuJhwfoeFD9/35njkUWQgEgGtsWQI/Pytk6exV
         7SqE43Bzibh51mhfv0pek9l3tbSDK3h/Z0eOVAGpVXXmUSnzBJVqcvh80u1pcgHhWT/n
         IMjq/bx+dtq9k3xZrMsFSZYg5vRybLj0IXIkKx8yGyFJls7y8OyOrf14r5AiBPRyXr/S
         ACsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P5a228g83nX88yA9CZii9+LIDBbZDlqneAHpFoJ933Y=;
        b=wNpSQao59YJYfIkTrlpcktkJFCuOiKamhyDpjLPQ5MZjaM1LPe8TFky9Paj4ssIclR
         zgkl6VxZqI253j548u6jMms657pVJs9ET3E4RAfRTXcv4qfBneJuoCUdy+tvo5zZ5vpI
         tAg/2c61K/pcSB6TqJgpCH8/U2vao4fcGw4osi5sSNA/bEIPTRBTZ1FnTFxeAJS9M2Cy
         Yl7+p+1tOxdFN+PBz2q19n7uZ5aF0RGZm2tqs0ezVpnKML+Clgwzpo7O441tYSm1nsqW
         kF72WttKlYxwWs+/aqWQSPMMiyFUQsz0hmNWreg6jTdwwkoJT6Xnx84u/Z/r02Bfb1xG
         eXvQ==
X-Gm-Message-State: AJIora+C6bUL4Axl4x+VQhTleLac1sqcCTKtroFqQlNb5pmIqqj/wkWF
        BgI7yvJCE6Ng6xw2N3fMSQEj3XhtJ0IG5w==
X-Google-Smtp-Source: AGRyM1utx2cdrq1JGzu6N9ZFvMiWV4st8KRLZucOe0ygsCZy22Yh7Vr72Tf2lmGjEp3TM75VdCygWg==
X-Received: by 2002:a17:907:75d3:b0:72b:48de:e540 with SMTP id jl19-20020a17090775d300b0072b48dee540mr30711173ejc.547.1658237076795;
        Tue, 19 Jul 2022 06:24:36 -0700 (PDT)
Received: from localhost (icdhcp-1-189.epfl.ch. [128.178.116.189])
        by smtp.gmail.com with ESMTPSA id 12-20020a170906318c00b0072b3391193dsm6742599ejy.154.2022.07.19.06.24.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 06:24:36 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: [PATCH bpf-next v6 02/13] tools/resolve_btfids: Add support for resolving kfunc flags
Date:   Tue, 19 Jul 2022 15:24:19 +0200
Message-Id: <20220719132430.19993-3-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220719132430.19993-1-memxor@gmail.com>
References: <20220719132430.19993-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7788; i=memxor@gmail.com; h=from:subject; bh=jXUK0o8IGaFR3pP9Ax5hsszdgFDeSSn/IYM9y7CqzWw=; b=owEBbQKS/ZANAwAKAUzgyIZIvxHKAcsmYgBi1rBlqRuW+Pmkq8toijOnPyV/vMEDpRaS6IF4PuH9 pxPx6y+JAjMEAAEKAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYtawZQAKCRBM4MiGSL8RytdKEA CcoKnArIdGirMh+3Ob1n3URlSST+cDQBNe8NIA9ixNHXkNhVRY8FFD9GAluLqUcW0l38g4+o/NfTKg QrBPKAO4UkD1YJwyUsfWQbqQ06+zATRKmYeZk9KicoN/0QjNWJmXRnAU/iNCDtzW/JZnBkbdy0gc2X HxcUXFdjVfNZSLTlG03GWfNCJWyK/YD6cmycNq1N0zKajzVGcSfrkqLPQcre+JrfmRbjFdTVCyvU+U GL8oOhXEIBBYCxxYeENDfEVoaK0xPixY6JivNcv4VNbTlUyetwEz/yWE2z0x7EG//9ngdwA/dtWFY/ vwS71dINvUPcQx8DmYJEekp1SgDXH/7IMLL0S4FyhR04+RoeSZlSOemDxbXpiKYVFd56VkyKpzzONL x89Ezmna7rBL4QNxnt5llwE3DSKtrXcmWEAQv6j5WQW0uvCmPLkvuaAfU7n2NucnLQGOjKrKQaLrw2 LHgMG3TSU8RZBNhZ8L7nJc+xoE/SwPU8w1u4i9Urp3EOcj7gGh57+4GjynztCYvziMkdGbNCU5tI5u 1/UWdBW2QclPdtxOd5szCfyMfgdR5/OzaNh98RXd0QLkl9axpqGDKMv5IuV/SAZpY/boT8hnsjo+Hj xICcrewOo8nlUgPi5mE09e95Q44U8qaMKpLBiPFfl36Nn5OOkptZXBY0Toqg==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A flag is a 4-byte symbol that may follow a BTF ID in a set8. This is
used in the kernel to tag kfuncs in BTF sets with certain flags. Add
support to resolve_btfids to resolve and patch these in so they are
available for lookup in the kernel by directly searching into the BTF
set.

Since we don't need lookup support for the flags, we can simply store
them in a list instead of rbtree.

Cc: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/bpf/resolve_btfids/main.c | 115 ++++++++++++++++++++++++++++++--
 1 file changed, 108 insertions(+), 7 deletions(-)

diff --git a/tools/bpf/resolve_btfids/main.c b/tools/bpf/resolve_btfids/main.c
index 5d26f3c6f918..4d1b7224bc38 100644
--- a/tools/bpf/resolve_btfids/main.c
+++ b/tools/bpf/resolve_btfids/main.c
@@ -35,6 +35,10 @@
  *             __BTF_ID__typedef__pid_t__1:
  *             .zero 4
  *
+ *   flags   - store specified flag values after ORing them into the data:
+ *	       __BTF_ID__flags__0x0_0x0_0x0_0x0_0x0__1:
+ *	       .zero 4
+ *
  *   set     - store symbol size into first 4 bytes and sort following
  *             ID list
  *
@@ -45,6 +49,21 @@
  *             .zero 4
  *             __BTF_ID__func__vfs_fallocate__4:
  *             .zero 4
+ *
+ *   set8    - store symbol size into first 4 bytes and sort following
+ *             ID list
+ *
+ *             __BTF_ID__set8__list:
+ *             .zero 8
+ *             list:
+ *             __BTF_ID__func__vfs_getattr__3:
+ *             .zero 4
+ *	       __BTF_ID__flags__0x0_0x0_0x0_0x0_0x0__4:
+ *             .zero 4
+ *             __BTF_ID__func__vfs_fallocate__5:
+ *             .zero 4
+ *	       __BTF_ID__flags__0x0_0x0_0x0_0x0_0x0__6:
+ *             .zero 4
  */
 
 #define  _GNU_SOURCE
@@ -57,6 +76,7 @@
 #include <sys/stat.h>
 #include <fcntl.h>
 #include <errno.h>
+#include <linux/list.h>
 #include <linux/rbtree.h>
 #include <linux/zalloc.h>
 #include <linux/err.h>
@@ -71,12 +91,17 @@
 #define BTF_UNION	"union"
 #define BTF_TYPEDEF	"typedef"
 #define BTF_FUNC	"func"
+#define BTF_FLAGS	"flags"
 #define BTF_SET		"set"
+#define BTF_SET8	"set8"
 
 #define ADDR_CNT	100
 
 struct btf_id {
-	struct rb_node	 rb_node;
+	union {
+		struct rb_node	 rb_node;
+		struct list_head ls_node;
+	};
 	char		*name;
 	union {
 		int	 id;
@@ -84,6 +109,8 @@ struct btf_id {
 	};
 	int		 addr_cnt;
 	bool		 is_set;
+	bool		 is_set8;
+	bool		 is_flag;
 	Elf64_Addr	 addr[ADDR_CNT];
 };
 
@@ -109,6 +136,8 @@ struct object {
 	struct rb_root	typedefs;
 	struct rb_root	funcs;
 
+	struct list_head flags;
+
 	int nr_funcs;
 	int nr_structs;
 	int nr_unions;
@@ -198,6 +227,20 @@ btf_id__add(struct rb_root *root, char *name, bool unique)
 	return id;
 }
 
+static struct btf_id *
+btf_id_flags__add(struct list_head *list, char *name)
+{
+	struct btf_id *id;
+
+	id = zalloc(sizeof(*id));
+	if (id) {
+		pr_debug("adding flags %s\n", name);
+		id->name = name;
+		list_add(&id->ls_node, list);
+	}
+	return id;
+}
+
 static char *get_id(const char *prefix_end)
 {
 	/*
@@ -231,14 +274,14 @@ static char *get_id(const char *prefix_end)
 	return id;
 }
 
-static struct btf_id *add_set(struct object *obj, char *name)
+static struct btf_id *add_set(struct object *obj, char *name, bool is_set8)
 {
 	/*
 	 * __BTF_ID__set__name
 	 * name =    ^
 	 * id   =         ^
 	 */
-	char *id = name + sizeof(BTF_SET "__") - 1;
+	char *id = name + (is_set8 ? sizeof(BTF_SET8 "__") : sizeof(BTF_SET "__")) - 1;
 	int len = strlen(name);
 
 	if (id >= name + len) {
@@ -262,6 +305,19 @@ static struct btf_id *add_symbol(struct rb_root *root, char *name, size_t size)
 	return btf_id__add(root, id, false);
 }
 
+static struct btf_id *add_flags(struct list_head *list, char *name, size_t size)
+{
+	char *id;
+
+	id = get_id(name + size);
+	if (!id) {
+		pr_err("FAILED to parse symbol name: %s\n", name);
+		return NULL;
+	}
+
+	return btf_id_flags__add(list, id);
+}
+
 /* Older libelf.h and glibc elf.h might not yet define the ELF compression types. */
 #ifndef SHF_COMPRESSED
 #define SHF_COMPRESSED (1 << 11) /* Section with compressed data. */
@@ -444,9 +500,26 @@ static int symbols_collect(struct object *obj)
 		} else if (!strncmp(prefix, BTF_FUNC, sizeof(BTF_FUNC) - 1)) {
 			obj->nr_funcs++;
 			id = add_symbol(&obj->funcs, prefix, sizeof(BTF_FUNC) - 1);
+		/* flags */
+		} else if (!strncmp(prefix, BTF_FLAGS, sizeof(BTF_FLAGS) - 1)) {
+			id = add_flags(&obj->flags, prefix, sizeof(BTF_FLAGS) - 1);
+			if (id)
+				id->is_flag = true;
+		/* set8 */
+		} else if (!strncmp(prefix, BTF_SET8, sizeof(BTF_SET8) - 1)) {
+			id = add_set(obj, prefix, true);
+			/*
+			 * SET8 objects store list's count, which is encoded
+			 * in symbol's size, together with 'cnt' field hence
+			 * that - 1.
+			 */
+			if (id) {
+				id->cnt = sym.st_size / sizeof(uint64_t) - 1;
+				id->is_set8 = true;
+			}
 		/* set */
 		} else if (!strncmp(prefix, BTF_SET, sizeof(BTF_SET) - 1)) {
-			id = add_set(obj, prefix);
+			id = add_set(obj, prefix, false);
 			/*
 			 * SET objects store list's count, which is encoded
 			 * in symbol's size, together with 'cnt' field hence
@@ -482,6 +555,7 @@ static int symbols_resolve(struct object *obj)
 	int nr_unions   = obj->nr_unions;
 	int nr_funcs    = obj->nr_funcs;
 	struct btf *base_btf = NULL;
+	struct btf_id *flags_id;
 	int err, type_id;
 	struct btf *btf;
 	__u32 nr_types;
@@ -558,6 +632,17 @@ static int symbols_resolve(struct object *obj)
 		}
 	}
 
+	/* Resolve all the BTF ID flags */
+	list_for_each_entry(flags_id, &obj->flags, ls_node) {
+		int f1, f2, f3, f4, f5;
+
+		if (sscanf(flags_id->name, "0x%x_0x%x_0x%x_0x%x_0x%x", &f1, &f2, &f3, &f4, &f5) != 5) {
+			pr_err("FAILED: malformed flags, can't resolve: %s\n", flags_id->name);
+			goto out;
+		}
+		flags_id->id = f1 | f2 | f3 | f4 | f5;
+	}
+
 	err = 0;
 out:
 	btf__free(base_btf);
@@ -571,7 +656,8 @@ static int id_patch(struct object *obj, struct btf_id *id)
 	int *ptr = data->d_buf;
 	int i;
 
-	if (!id->id && !id->is_set)
+	/* For set, set8, and flags, id->id may be 0 */
+	if (!id->id && !id->is_set && !id->is_set8 && !id->is_flag)
 		pr_err("WARN: resolve_btfids: unresolved symbol %s\n", id->name);
 
 	for (i = 0; i < id->addr_cnt; i++) {
@@ -611,6 +697,17 @@ static int __symbols_patch(struct object *obj, struct rb_root *root)
 	return 0;
 }
 
+static int flags_patch(struct object *obj)
+{
+	struct btf_id *flags_id;
+
+	list_for_each_entry(flags_id, &obj->flags, ls_node) {
+		if (id_patch(obj, flags_id))
+			return -1;
+	}
+	return 0;
+}
+
 static int cmp_id(const void *pa, const void *pb)
 {
 	const int *a = pa, *b = pb;
@@ -643,13 +740,13 @@ static int sets_patch(struct object *obj)
 		}
 
 		idx = idx / sizeof(int);
-		base = &ptr[idx] + 1;
+		base = &ptr[idx] + (id->is_set8 ? 2 : 1);
 		cnt = ptr[idx];
 
 		pr_debug("sorting  addr %5lu: cnt %6d [%s]\n",
 			 (idx + 1) * sizeof(int), cnt, id->name);
 
-		qsort(base, cnt, sizeof(int), cmp_id);
+		qsort(base, cnt, id->is_set8 ? sizeof(uint64_t) : sizeof(int), cmp_id);
 
 		next = rb_next(next);
 	}
@@ -667,6 +764,9 @@ static int symbols_patch(struct object *obj)
 	    __symbols_patch(obj, &obj->sets))
 		return -1;
 
+	if (flags_patch(obj))
+		return -1;
+
 	if (sets_patch(obj))
 		return -1;
 
@@ -715,6 +815,7 @@ int main(int argc, const char **argv)
 	};
 	int err = -1;
 
+	INIT_LIST_HEAD(&obj.flags);
 	argc = parse_options(argc, argv, btfid_options, resolve_btfids_usage,
 			     PARSE_OPT_STOP_AT_NON_OPTION);
 	if (argc != 1)
-- 
2.34.1


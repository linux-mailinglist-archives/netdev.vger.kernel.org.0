Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1A0057CC4F
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 15:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbiGUNnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 09:43:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbiGUNmz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 09:42:55 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EDA08239C;
        Thu, 21 Jul 2022 06:42:53 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id bk26so2321744wrb.11;
        Thu, 21 Jul 2022 06:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ixm0TpOqb7EkbcZmFxoYYjjun9V4WdmLtfPgexkV81E=;
        b=fnuECT4WkBw1F0kfOU1C8ZVm68ls3Q5nTCTAPfDuQuWBeu+5nwA4cCeBSABicn1ee9
         X9O0kn/3XySyssCv3diiJ0xoLlw2eZ/D9TTZA1iFdafTjyG6CQv2bs0qTaHd7TExJH96
         wXPwQ8XwEnf2J87v3Q3uy96/+mlsSnCjHLdrn0jqEwbWtZPPx3aLFPgQQxcpxH09Biz6
         fAm29eUaDMOpSIUaAFPWLb6IUpDAnv8sTMkYY6+iKQlKj/znQdEE7yztGhc3fLtQKMAe
         Ck696Qm3z1lQYNZ0HYweflTbGoyaNYPg+tMMfz2HHLFNCgULqwh3Q9iIdj8XADVuYzj/
         IFAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ixm0TpOqb7EkbcZmFxoYYjjun9V4WdmLtfPgexkV81E=;
        b=VoQ4ZgoqZo9zh5tWQ41oo2Nn1LXvrMgW4ONBUE+zu7IkhOFv6hMNF+h16tTzbFF8F/
         qqy78WYv23Zo6eq1Os0LVEBlznBHN4osVNaO4DFaKGIoNN/C2NyJZtSjkTpU+JGvha8Q
         /DUQzJqwgNXYQ6+FdqcvkWKE5NcQuyFpfe6nempBkKVXPSpyU+glX2RQ5aKSo/dkXzkt
         CF3rFSmAtZ4qFBnVZA1W6L+6hs9bIm3dTtHmDuCQviB3SCGPi9ktN2RmZ4tecVnb2w5e
         P8iVBnL0QXGorpFs4QuJd3xZ6Nj9wKX4c7clsG/LN5CNP41rp3rRZr8iw3xL48tpkRPj
         YMSA==
X-Gm-Message-State: AJIora8nthSXU17383F4qQrAsTLfNRnQq+f5uAie//gp7O+XEL+0v0m/
        7yAJ09vGS5B2G6trhDApsJHjFnYrxljVBw==
X-Google-Smtp-Source: AGRyM1uDITsFaWtdl0LbaSZzHTAVUahP1Da7igpBjfKuawGhKAPb9Dx+biyLFpae4D2Qlua55xBh7A==
X-Received: by 2002:a5d:584d:0:b0:21d:b7f8:7d19 with SMTP id i13-20020a5d584d000000b0021db7f87d19mr34095407wrf.260.1658410970850;
        Thu, 21 Jul 2022 06:42:50 -0700 (PDT)
Received: from localhost (212.191.202.62.dynamic.cgnat.res.cust.swisscom.ch. [62.202.191.212])
        by smtp.gmail.com with ESMTPSA id t11-20020a5d460b000000b0021b970a68f9sm1930740wrq.26.2022.07.21.06.42.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 06:42:50 -0700 (PDT)
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
Subject: [PATCH bpf-next v7 02/13] tools/resolve_btfids: Add support for 8-byte BTF sets
Date:   Thu, 21 Jul 2022 15:42:34 +0200
Message-Id: <20220721134245.2450-3-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220721134245.2450-1-memxor@gmail.com>
References: <20220721134245.2450-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3720; i=memxor@gmail.com; h=from:subject; bh=ouOEzgiZrkDu5OXi7dfFyFaLhODxyDcFNQ/GHcdVKRc=; b=owEBbQKS/ZANAwAKAUzgyIZIvxHKAcsmYgBi2VfNrmYwg0/YXwLTZrgylzTjjk8SF8Sjnf80B00x 8zQzP6OJAjMEAAEKAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYtlXzQAKCRBM4MiGSL8RysWpEA CTLZwz7rPIFu0tLaSqbtjlTyr4OOwZQl/5qr/rtyYdmtnpx/9tAUrXnYespixLalOf1aBX85mgOJLe HWo4vUSFAHzLpxPpxEmU2Ue7shC5kiPRs8Zs7RpfSmOxZ5u3pJBw5tjijjVi2CrGlqcONglDOYZCPe CqbKQ6JNSvE6j5BSI6iSrLjEx9AIVAqurYE5PrMT7EU9V6RbYX8GVBidmL2XFx7OSH2tYvsYuI3/d7 nGzvw12LyqtzkK6ezwiPNnsH6927H9AyPjfomBosKLExVXWBQnclXuJ+WsGf/m0AiEmTboL0w23L1v nd0Fcp6Y4WDJyFaNvqfJuUc7QFLeYoqt4fRUJ3jhBsqAtEbrLGP6IHai7PhRn90D6th2tQUH5KeIGh JF9EU2CvvNLdUVssIoRi+wqARxF7IJUtn20tnVbqkAypq3ASLVX12dWsJ8FR4r64O/reWLMj94iQ/E RCdeU+HLBpcJUss1TdpwosOrz5I49kjBXQnSsKxch1dHDphCSu57l2zzRbjcu743JaY1ngJ/w05k2O OuDv7m02su6rfxmctu71lljNIe3a2s88oSLdWrZteWRHqMCQ/9ElRgILePEkvw2OJJge2RLGwhfqEE mYknEJOburfAh5ZRggh5TkknnQ/40slVksJKQnW28anrOWRnpe3yGkWR4uFg==
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
support to adjust the sorting code so that it passes size as 8 bytes
for 8-byte BTF sets.

Cc: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/bpf/resolve_btfids/main.c | 40 ++++++++++++++++++++++++++++-----
 1 file changed, 34 insertions(+), 6 deletions(-)

diff --git a/tools/bpf/resolve_btfids/main.c b/tools/bpf/resolve_btfids/main.c
index 5d26f3c6f918..80cd7843c677 100644
--- a/tools/bpf/resolve_btfids/main.c
+++ b/tools/bpf/resolve_btfids/main.c
@@ -45,6 +45,19 @@
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
+ *	       .word (1 << 0) | (1 << 2)
+ *             __BTF_ID__func__vfs_fallocate__5:
+ *             .zero 4
+ *	       .word (1 << 3) | (1 << 1) | (1 << 2)
  */
 
 #define  _GNU_SOURCE
@@ -72,6 +85,7 @@
 #define BTF_TYPEDEF	"typedef"
 #define BTF_FUNC	"func"
 #define BTF_SET		"set"
+#define BTF_SET8	"set8"
 
 #define ADDR_CNT	100
 
@@ -84,6 +98,7 @@ struct btf_id {
 	};
 	int		 addr_cnt;
 	bool		 is_set;
+	bool		 is_set8;
 	Elf64_Addr	 addr[ADDR_CNT];
 };
 
@@ -231,14 +246,14 @@ static char *get_id(const char *prefix_end)
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
@@ -444,9 +459,21 @@ static int symbols_collect(struct object *obj)
 		} else if (!strncmp(prefix, BTF_FUNC, sizeof(BTF_FUNC) - 1)) {
 			obj->nr_funcs++;
 			id = add_symbol(&obj->funcs, prefix, sizeof(BTF_FUNC) - 1);
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
@@ -571,7 +598,8 @@ static int id_patch(struct object *obj, struct btf_id *id)
 	int *ptr = data->d_buf;
 	int i;
 
-	if (!id->id && !id->is_set)
+	/* For set, set8, id->id may be 0 */
+	if (!id->id && !id->is_set && !id->is_set8)
 		pr_err("WARN: resolve_btfids: unresolved symbol %s\n", id->name);
 
 	for (i = 0; i < id->addr_cnt; i++) {
@@ -643,13 +671,13 @@ static int sets_patch(struct object *obj)
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
-- 
2.34.1


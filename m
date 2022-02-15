Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18BA94B7AED
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 23:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244722AbiBOW7v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 17:59:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244734AbiBOW7s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 17:59:48 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 005CAF8B8F
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 14:59:35 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id b5so357792qtq.11
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 14:59:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zT3uK29FMhfhh8DewxMCadQW6mKbGtNQ3FzMrNuYVHw=;
        b=D/lIXVd+MDiOWDoEabTMuoFkPvPCPWMHigtsYkCs+cfFzJM64fJvhKHeAYU9dVjZam
         YFf9kh+seOhpkIhSTazrAWa9lDgLZvIbAeIUfyrNPB6Yn5YTXdYW7ef7Hui/LzKlz/ab
         5XfDMbFp4Rv1Lc3c+PTfQ7uWJCmvjIcGt4a8I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zT3uK29FMhfhh8DewxMCadQW6mKbGtNQ3FzMrNuYVHw=;
        b=TyBrL0IpRpnjNO8s7XDBMi9MmtgXdIKsqUKBUp6CePMJhPrcAyEfvq5wxc5utQIICD
         z8sa85HQ3hXmMK3YXBfT5916UmH8z5T739FMOixtfJengZPTW3i5bTchGABpmYnM3SGn
         sA3tWkGluaYVP2TCugxfJyr9sfMyHtw8DY4jB+/cUW4Fa29gz2X+EDlAJ5BdZlkATHKl
         dCepgnokvNO3+vagnB3/wkRQNVG5psoBqB6s3ztQxTLkFxa6+sD07QNfKrm4RjNBVNEb
         V4kY4Vw3mXsb2H4g3AzxU6uAzC88yNJvw2cMAOOZdXi/g4TojSRCPvNniOXJWM6iwl+O
         /keA==
X-Gm-Message-State: AOAM531+BQS5nkcOtqxqEGkZRk9BUvNFHJZ0nbA+GrDps5GQjTtPD0fI
        dDpdcF1bAaEQVNezRXNKlauvsrQpeTzdqHIL7J5w43LmwA0hHzX2BN+IRAHAVn8NKRmZFwGVyO1
        8x9jtaelFUxyOe+e/c6L0AYQSF3ZKqa3ulpqprd27iUmcp+wyz1UCJqThupGU2VpdN8UBHg==
X-Google-Smtp-Source: ABdhPJx7sfTWQxfkUplLloleC+98bFLx389D3qdkBCBg6gyujx77OJsCFvEcE90gSTFh9NgFbW31gg==
X-Received: by 2002:a05:622a:1454:b0:2db:65c9:3a89 with SMTP id v20-20020a05622a145400b002db65c93a89mr184382qtx.129.1644965972491;
        Tue, 15 Feb 2022 14:59:32 -0800 (PST)
Received: from localhost.localdomain ([181.136.110.101])
        by smtp.gmail.com with ESMTPSA id w19sm15520021qkp.6.2022.02.15.14.59.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 14:59:32 -0800 (PST)
From:   =?UTF-8?q?Mauricio=20V=C3=A1squez?= <mauricio@kinvolk.io>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Subject: [PATCH bpf-next v7 5/7] bpftool: Implement btfgen_get_btf()
Date:   Tue, 15 Feb 2022 17:58:54 -0500
Message-Id: <20220215225856.671072-6-mauricio@kinvolk.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220215225856.671072-1-mauricio@kinvolk.io>
References: <20220215225856.671072-1-mauricio@kinvolk.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The last part of the BTFGen algorithm is to create a new BTF object with
all the types that were recorded in the previous steps.

This function performs two different steps:
1. Add the types to the new BTF object by using btf__add_type(). Some
special logic around struct and unions is implemented to only add the
members that are really used in the field-based relocations. The type
ID on the new and old BTF objects is stored on a map.
2. Fix all the type IDs on the new BTF object by using the IDs saved in
the previous step.

Signed-off-by: Mauricio Vásquez <mauricio@kinvolk.io>
Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
---
 tools/bpf/bpftool/gen.c | 100 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 99 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index 806001020841..25a336846d9f 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -1505,10 +1505,108 @@ static int btfgen_record_obj(struct btfgen_info *info, const char *obj_path)
 	return err;
 }
 
+static int btfgen_remap_id(__u32 *type_id, void *ctx)
+{
+	unsigned int *ids = ctx;
+
+	*type_id = ids[*type_id];
+
+	return 0;
+}
+
 /* Generate BTF from relocation information previously recorded */
 static struct btf *btfgen_get_btf(struct btfgen_info *info)
 {
-	return ERR_PTR(-EOPNOTSUPP);
+	struct btf *btf_new = NULL;
+	unsigned int *ids = NULL;
+	unsigned int i, n = btf__type_cnt(info->marked_btf);
+	int err = 0;
+
+	btf_new = btf__new_empty();
+	if (!btf_new) {
+		err = -errno;
+		goto err_out;
+	}
+
+	ids = calloc(n, sizeof(*ids));
+	if (!ids) {
+		err = -errno;
+		goto err_out;
+	}
+
+	/* first pass: add all marked types to btf_new and add their new ids to the ids map */
+	for (i = 1; i < n; i++) {
+		const struct btf_type *cloned_type, *type;
+		const char *name;
+		int new_id;
+
+		cloned_type = btf__type_by_id(info->marked_btf, i);
+
+		if (cloned_type->name_off != MARKED)
+			continue;
+
+		type = btf__type_by_id(info->src_btf, i);
+
+		/* add members for struct and union */
+		if (btf_is_composite(type)) {
+			struct btf_member *cloned_m, *m;
+			unsigned short vlen;
+			int idx_src;
+
+			name = btf__str_by_offset(info->src_btf, type->name_off);
+
+			if (btf_is_struct(type))
+				err = btf__add_struct(btf_new, name, type->size);
+			else
+				err = btf__add_union(btf_new, name, type->size);
+
+			if (err < 0)
+				goto err_out;
+			new_id = err;
+
+			cloned_m = btf_members(cloned_type);
+			m = btf_members(type);
+			vlen = btf_vlen(cloned_type);
+			for (idx_src = 0; idx_src < vlen; idx_src++, cloned_m++, m++) {
+				/* add only members that are marked as used */
+				if (cloned_m->name_off != MARKED)
+					continue;
+
+				name = btf__str_by_offset(info->src_btf, m->name_off);
+				err = btf__add_field(btf_new, name, m->type,
+						     BTF_MEMBER_BIT_OFFSET(m->offset),
+						     BTF_MEMBER_BITFIELD_SIZE(m->offset));
+				if (err < 0)
+					goto err_out;
+			}
+		} else {
+			err = btf__add_type(btf_new, info->src_btf, type);
+			if (err < 0)
+				goto err_out;
+			new_id = err;
+		}
+
+		/* add ID mapping */
+		ids[i] = new_id;
+	}
+
+	/* second pass: fix up type ids */
+	for (i = 1; i < btf__type_cnt(btf_new); i++) {
+		struct btf_type *btf_type = (struct btf_type *) btf__type_by_id(btf_new, i);
+
+		err = btf_type_visit_type_ids(btf_type, btfgen_remap_id, ids);
+		if (err)
+			goto err_out;
+	}
+
+	free(ids);
+	return btf_new;
+
+err_out:
+	btf__free(btf_new);
+	free(ids);
+	errno = -err;
+	return NULL;
 }
 
 /* Create minimized BTF file for a set of BPF objects.
-- 
2.25.1


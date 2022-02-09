Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7314B0031
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 23:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235601AbiBIW2i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 17:28:38 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:59330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235569AbiBIW2Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 17:28:25 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82010E015649
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 14:27:43 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id o3so3302580qtm.12
        for <netdev@vger.kernel.org>; Wed, 09 Feb 2022 14:27:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xcPa28Cy25WoANEeaXLZrreqoOMkyJYWDgWdVWp2OFg=;
        b=KRYe4me4LxBtrqLehSrA1W8X+pX/NYEM2eLB9UMXoDlMnAWiHJR5cukTm9PvwH3IDs
         4jHnDxD0xvkIfX+kpGxKS6MHudso0USaN63XSB1acRYnpDiw+Ac714BUhWlGdDP6ix+O
         FE4uYcSb1tEksiobfBXnhhIVm2tgh+qp+4eUA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xcPa28Cy25WoANEeaXLZrreqoOMkyJYWDgWdVWp2OFg=;
        b=WX7XH8Dm7h0BtcezsDWR8UeYpVljr/DHRv4cmHGeLLZLZZBGS+Ct8lup6ScS5N/WER
         WO84X36mdXIYcz5m9gMvMxTy0IIsAB2ZA58vJGtqH7BxGx/+NmMLPdcEetUYDA77Dy0E
         bxuHhDMUtG6h8aYIQM60qUzFV+wpJpNmE9XBPd+9nmk9LCP5YJv+uWhqjciKOGX/FoiA
         Qa5bVk68fiWwsbfewWymOjAo+k3hMplkHuxu+NlH0GUJJ+mbWpvvNOcdjRHApEW7SGZ7
         gNKUAET6P8R60qeQpXK/E+oQTUdQmbi3Z+cruP/2OMIpyq8wc1Oow7L1s7XZki7FAl30
         DgLQ==
X-Gm-Message-State: AOAM532oz9o0r3HNFtENNl32FUJtJOuPszWUFqrb9dUuZqmcXvjNPrc2
        6AY9wdnUq7/2NVDbc+NN/CffNgIAc1c3UADC1MK5NOTeIsWodVAkGpkudEQ5BUdKpW8KHq2BZkM
        QQ/CCe5SoxTA0qgc41J4ORzrJizcfSBKYbB4agtp9AmSUSkrD8mHisfuL/sMTMqdmzykS6A==
X-Google-Smtp-Source: ABdhPJz1rAv6qaa1pM9fKMBVr5EVj2gP9AjXVC36XcmNwn56/9SBP7cyzQe4Sj0KTrFe7c4KGxjeWw==
X-Received: by 2002:ac8:41cf:: with SMTP id o15mr2938178qtm.254.1644445661960;
        Wed, 09 Feb 2022 14:27:41 -0800 (PST)
Received: from localhost.localdomain ([181.136.110.101])
        by smtp.gmail.com with ESMTPSA id h6sm9706287qtx.65.2022.02.09.14.27.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 14:27:41 -0800 (PST)
From:   =?UTF-8?q?Mauricio=20V=C3=A1squez?= <mauricio@kinvolk.io>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Subject: [PATCH bpf-next v6 5/7] bpftool: Implement btfgen_get_btf()
Date:   Wed,  9 Feb 2022 17:26:44 -0500
Message-Id: <20220209222646.348365-6-mauricio@kinvolk.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220209222646.348365-1-mauricio@kinvolk.io>
References: <20220209222646.348365-1-mauricio@kinvolk.io>
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
 tools/bpf/bpftool/gen.c | 136 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 135 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index c3e34db2ec8a..1efc7f3c64b2 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -1481,10 +1481,144 @@ static int btfgen_record_obj(struct btfgen_info *info, const char *obj_path)
 	return err;
 }
 
+static unsigned int btfgen_get_id(struct hashmap *ids, unsigned int old)
+{
+	uintptr_t new;
+
+	if (!hashmap__find(ids, uint_as_hash_key(old), (void **)&new))
+		/* return id for BTF_KIND_VOID as it's possible that the
+		 * ID we're looking for is the type of a pointer that
+		 * we're not adding.
+		 */
+		return 0;
+
+	return (unsigned int)(uintptr_t)new;
+}
+
+static int btfgen_add_id(struct hashmap *ids, unsigned int old, unsigned int new)
+{
+	return hashmap__add(ids, uint_as_hash_key(old), uint_as_hash_key(new));
+}
+
+static int btfgen_remap_id(__u32 *type_id, void *ctx)
+{
+	struct hashmap *ids = ctx;
+
+	*type_id = btfgen_get_id(ids, *type_id);
+
+	return 0;
+}
+
 /* Generate BTF from relocation information previously recorded */
 static struct btf *btfgen_get_btf(struct btfgen_info *info)
 {
-	return ERR_PTR(-EOPNOTSUPP);
+	struct btf *btf_new = NULL;
+	struct hashmap *ids = NULL;
+	unsigned int i;
+	int err = 0;
+
+	btf_new = btf__new_empty();
+	if (!btf_new) {
+		err = -errno;
+		goto err_out;
+	}
+
+	ids = hashmap__new(btfgen_hash_fn, btfgen_equal_fn, NULL);
+	if (IS_ERR(ids)) {
+		err = PTR_ERR(ids);
+		goto err_out;
+	}
+
+	/* first pass: add all marked types to btf_new and add their new ids to the ids map */
+	for (i = 1; i < btf__type_cnt(info->marked_btf); i++) {
+		const struct btf_type *cloned_type, *btf_type;
+		int new_id;
+
+		cloned_type = btf__type_by_id(info->marked_btf, i);
+
+		if (cloned_type->name_off != MARKED)
+			continue;
+
+		btf_type = btf__type_by_id(info->src_btf, i);
+
+		/* add members for struct and union */
+		if (btf_is_struct(btf_type) || btf_is_union(btf_type)) {
+			struct btf_type *btf_type_cpy;
+			int nmembers = 0, idx_dst, idx_src;
+			size_t new_size;
+
+			/* calculate nmembers */
+			for (idx_src = 0; idx_src < btf_vlen(cloned_type); idx_src++) {
+				struct btf_member *cloned_m = btf_members(cloned_type) + idx_src;
+
+				if (cloned_m->name_off == MARKED)
+					nmembers++;
+			}
+
+			new_size = sizeof(struct btf_type) + nmembers * sizeof(struct btf_member);
+
+			btf_type_cpy = malloc(new_size);
+			if (!btf_type_cpy)
+				goto err_out;
+
+			/* copy btf type */
+			*btf_type_cpy = *btf_type;
+
+			idx_dst = 0;
+			for (idx_src = 0; idx_src < btf_vlen(cloned_type); idx_src++) {
+				struct btf_member *btf_member_src, *btf_member_dst;
+				struct btf_member *cloned_m = btf_members(cloned_type) + idx_src;
+
+				/* copy only members that are marked as used */
+				if (cloned_m->name_off != MARKED)
+					continue;
+
+				btf_member_src = btf_members(btf_type) + idx_src;
+				btf_member_dst = btf_members(btf_type_cpy) + idx_dst;
+
+				*btf_member_dst = *btf_member_src;
+
+				idx_dst++;
+			}
+
+			/* set new vlen */
+			btf_type_cpy->info = btf_type_info(btf_kind(btf_type_cpy), nmembers,
+							   btf_kflag(btf_type_cpy));
+
+			err = btf__add_type(btf_new, info->src_btf, btf_type_cpy);
+			free(btf_type_cpy);
+		} else {
+			err = btf__add_type(btf_new, info->src_btf, btf_type);
+		}
+
+		if (err < 0)
+			goto err_out;
+
+		new_id = err;
+
+		/* add ID mapping */
+		err = btfgen_add_id(ids, i, new_id);
+		if (err)
+			goto err_out;
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
+	hashmap__free(ids);
+	return btf_new;
+
+err_out:
+	btf__free(btf_new);
+	hashmap__free(ids);
+	errno = -err;
+	return NULL;
 }
 
 /* Create minimized BTF file for a set of BPF objects.
-- 
2.25.1


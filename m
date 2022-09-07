Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC875B08F7
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 17:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbiIGPpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 11:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbiIGPpU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 11:45:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28E8F58B4B
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 08:45:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662565518;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZZZ1CMV6frSOfS2BKbh9jMknLjABN4hNwTIR62lrj00=;
        b=PljEm0h5iFfzLyuZKiguA2J6hMCEqcgBalQvTIj/aKDtOWecyo+HC4+HUTH4nmlxK8Zymz
        XEti0PNUbyKtXie8GYtK9+4UuJyVDbmXL0yOTKP9FMr47MvQTWLnZIthgdSB1RYgt8859P
        kV+P3deOwBaLSx4/RrBOCObKCaFUyZw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-44-I-foaCp-OTi7PdC-mStS6w-1; Wed, 07 Sep 2022 11:45:17 -0400
X-MC-Unique: I-foaCp-OTi7PdC-mStS6w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BD855101A56C;
        Wed,  7 Sep 2022 15:45:16 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 776682026D4C;
        Wed,  7 Sep 2022 15:45:16 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id C81B730721A6C;
        Wed,  7 Sep 2022 17:45:15 +0200 (CEST)
Subject: [PATCH RFCv2 bpf-next 03/18] libbpf: patch module BTF obj+type ID
 into BPF insns
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        xdp-hints@xdp-project.net, larysa.zaremba@intel.com,
        memxor@gmail.com, Lorenzo Bianconi <lorenzo@kernel.org>,
        mtahhan@redhat.com,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        dave@dtucker.co.uk, Magnus Karlsson <magnus.karlsson@intel.com>,
        bjorn@kernel.org
Date:   Wed, 07 Sep 2022 17:45:15 +0200
Message-ID: <166256551578.1434226.1711667214489185920.stgit@firesoul>
In-Reply-To: <166256538687.1434226.15760041133601409770.stgit@firesoul>
References: <166256538687.1434226.15760041133601409770.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Larysa Zaremba <larysa.zaremba@intel.com>

Return both BTF type id and BTF object id from bpf_core_type_id_kernel().
Earlier only type id was returned despite the fact that llvm
has enabled the 64-bit return type for this instruction [1].
This was done as a preparation to the patch [2], which
also strongly served as a inspiration for this implementation.

[1] https://reviews.llvm.org/D91489
[2] https://lore.kernel.org/all/20201205025140.443115-1-andrii@kernel.org

Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 tools/lib/bpf/bpf_core_read.h |    3 ++-
 tools/lib/bpf/relo_core.c     |    8 +++++++-
 tools/lib/bpf/relo_core.h     |    1 +
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/bpf_core_read.h b/tools/lib/bpf/bpf_core_read.h
index 496e6a8ee0dc..f033ec65fc01 100644
--- a/tools/lib/bpf/bpf_core_read.h
+++ b/tools/lib/bpf/bpf_core_read.h
@@ -168,7 +168,8 @@ enum bpf_enum_value_kind {
  * Convenience macro to get BTF type ID of a target kernel's type that matches
  * specified local type.
  * Returns:
- *    - valid 32-bit unsigned type ID in kernel BTF;
+ *    - valid 64-bit unsigned integer: the upper 32 bits is the BTF object ID
+ *      and the lower 32 bits is the BTF type ID within the BTF object.
  *    - 0, if no matching type was found in a target kernel BTF.
  */
 #define bpf_core_type_id_kernel(type)					    \
diff --git a/tools/lib/bpf/relo_core.c b/tools/lib/bpf/relo_core.c
index c4b0e81ae293..ca94f8e2c698 100644
--- a/tools/lib/bpf/relo_core.c
+++ b/tools/lib/bpf/relo_core.c
@@ -892,6 +892,7 @@ static int bpf_core_calc_relo(const char *prog_name,
 	res->fail_memsz_adjust = false;
 	res->orig_sz = res->new_sz = 0;
 	res->orig_type_id = res->new_type_id = 0;
+	res->btf_obj_id = 0;
 
 	if (core_relo_is_field_based(relo->kind)) {
 		err = bpf_core_calc_field_relo(prog_name, relo, local_spec,
@@ -942,6 +943,8 @@ static int bpf_core_calc_relo(const char *prog_name,
 	} else if (core_relo_is_type_based(relo->kind)) {
 		err = bpf_core_calc_type_relo(relo, local_spec, &res->orig_val, &res->validate);
 		err = err ?: bpf_core_calc_type_relo(relo, targ_spec, &res->new_val, NULL);
+		if (!err && relo->kind == BPF_CORE_TYPE_ID_TARGET)
+			res->btf_obj_id = btf_obj_id(targ_spec->btf);
 	} else if (core_relo_is_enumval_based(relo->kind)) {
 		err = bpf_core_calc_enumval_relo(relo, local_spec, &res->orig_val);
 		err = err ?: bpf_core_calc_enumval_relo(relo, targ_spec, &res->new_val);
@@ -1133,7 +1136,10 @@ int bpf_core_patch_insn(const char *prog_name, struct bpf_insn *insn,
 		}
 
 		insn[0].imm = new_val;
-		insn[1].imm = new_val >> 32;
+		/* For type IDs, upper 32 bits are used for BTF object ID */
+		insn[1].imm = relo->kind == BPF_CORE_TYPE_ID_TARGET ?
+					    res->btf_obj_id :
+					    (new_val >> 32);
 		pr_debug("prog '%s': relo #%d: patched insn #%d (LDIMM64) imm64 %llu -> %llu\n",
 			 prog_name, relo_idx, insn_idx,
 			 (unsigned long long)imm, (unsigned long long)new_val);
diff --git a/tools/lib/bpf/relo_core.h b/tools/lib/bpf/relo_core.h
index 1c0566daf8e8..52de7c018fb8 100644
--- a/tools/lib/bpf/relo_core.h
+++ b/tools/lib/bpf/relo_core.h
@@ -66,6 +66,7 @@ struct bpf_core_relo_res {
 	__u32 orig_type_id;
 	__u32 new_sz;
 	__u32 new_type_id;
+	__u32 btf_obj_id;
 };
 
 int __bpf_core_types_are_compat(const struct btf *local_btf, __u32 local_id,



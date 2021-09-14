Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62FEF40ADF7
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 14:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233016AbhINMjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 08:39:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232975AbhINMji (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 08:39:38 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD385C061760;
        Tue, 14 Sep 2021 05:38:21 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id j6so11762104pfa.4;
        Tue, 14 Sep 2021 05:38:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/JqEGDgo9QAxQWCfqMkHbW50F2FbnzIMeTf5fXEX65o=;
        b=cU4F/xWic8PF946vqRjKPyxM6TbXGuPC5c0bsKmABGoNTfulMsAxQwKBSVXn6FPOUP
         b+5FCHtZ+8AtZvHLrX7BxFPG9XbzpUQDwVf6h5o978wOUE7onKP743+7FpyPRe55Bzfc
         FiT+zvyuy5UuHiL/X3nv86BwFWCEI5bYjq8cqAbDXzmb9SHoPZbHaVDsj4hiJqJReNLS
         p/AaQYUFnHM5f5FGgsisk7h8tzxkpQe2Af1yZLI3mHe0iafLl7JVVs+V1cJbUfSIU8g3
         NH6emvIHG2uggzETLaD4XwnHzkbxYb/fK1mT/Pw1xY+6vq8nhyOw847kJ7ykZqEKhy4r
         0s+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/JqEGDgo9QAxQWCfqMkHbW50F2FbnzIMeTf5fXEX65o=;
        b=TLaRET8p5ms0U/tzcQ8eVutUrV92ZejKQM2hCbVeTRTHA6DrjuoPNThFwOqeC3oqh3
         d8z1mulE4oRSxHbGO/PC0M1dnAdSfJ685Fx4jmcZTmv2NOfJv3O+xIpvWdw1NHeFwNMj
         3xZT/EAUfEVqgkqihmEe2oPKynEU21vylFmt8Lxsi3KdmVLYVyRVTyGeZLC4MUlilfvg
         YbIBVFvQC6GLc/zn59s8C9CwyGIMcmaGfQ5WNYMiUgQH4Z8daalBBA8clumwsuM2+cMy
         1rh6cYZINVAxEdsEnU44JZfXQkhyL+7y8N6ymoEH2qCVIimThe4HrH3m5YJ9KMEhGOf/
         xvVQ==
X-Gm-Message-State: AOAM532vS//KeIQB3Q5VgJBbGTNrCXvj5txvPJiSBqvSior3qH9Ml8Lw
        Megnd66pGySV2w2tgtG/56AabNb8V3TbUw==
X-Google-Smtp-Source: ABdhPJw0JAfegqXd6ciYVqKN5WCSQ3ZhvICuxuhAL8GtdR1B6Y5sRNkW32wDOmu5NddRkKqR3+KzBA==
X-Received: by 2002:a65:6107:: with SMTP id z7mr15312305pgu.43.1631623101065;
        Tue, 14 Sep 2021 05:38:21 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id i5sm1564973pjk.47.2021.09.14.05.38.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 05:38:20 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v2 08/10] libbpf: Resolve invalid weak kfunc calls with imm = 0, off = 0
Date:   Tue, 14 Sep 2021 18:07:47 +0530
Message-Id: <20210914123750.460750-9-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210914123750.460750-1-memxor@gmail.com>
References: <20210914123750.460750-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2121; h=from:subject; bh=rZU9k+Cv2J6k/VY3eXGkvA4+HCz67lZYgXlspqSObDQ=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhQJdXdG1+CGM1VJ/ZpXQLhLzk3deoejsZNIRvDpvc sDVlYD6JAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYUCXVwAKCRBM4MiGSL8Ryt/jD/ 0bvzwt+9hV+MGlLUqQbZJ+/1FR4JWodIXgRfTE8Go/KBh7YNd7grTUqnMd/7FmzArKpJMJOYMmrsLx 7p6f+VVZdYV4pnir1PPB4Qdz3nTAehgtZ5mpPcuhee7EtxuvV3lGmlcabEx+oUr7B2I8VRM8nFLmwR 3mOgXcjkUU0pvXfhkywS+arCKYO7ybMoaE8wPNr3m/DTRzVWcpJfXfR4EIgfuAPLOqlWE8toWgXnCn FwwPi0DQjipa/mNnYOMsF7TImTPOMv6ZfDP4YygDYYU65dsbJOsRqGUwo9r2/1E/HhvGMxVvdNLhKO y5DCZrP9pESwVJh0YO1b1UqPfcm+KNVqOPEo933MwHTSw+lFZHcZ3yfhY2na5L+H727b2pBdCbBqhp VvZMIQf8FgGpUkdJIeJWh1ZXmg0/P1bSLoFpJcuQydqr+HfqEO1B2tsxmS444psfuqcLVfRwTNnWc8 OgQd+zQOzXNi4l8/V7qUy32qg0sp9ydfHl55tTmcEti8D2w36meGOgGBKNgC3MXWNw3Ln6Em0+tApB bqFLHj4oza5ODIrTXY/Ah3XBOCr7RmruSAYy9mLzSKRoGzGcp0ypFai9ouueFaxs30X/bUE07uB1AE 92Cwu15rBtHjVzYQE772OE6enruCH2zC8HvDpuW46Ctgjd1gcfke9UCZP4IA==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Preserve these calls as it allows verifier to succeed in loading the
program if they are determined to be unreachable after dead code
elimination during program load. If not, the verifier will fail at
runtime. This is done for ext->is_weak symbols similar to the case for
variable ksyms.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/lib/bpf/libbpf.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index e78ae57e4379..9c6c1aa73e35 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3409,11 +3409,6 @@ static int bpf_object__collect_externs(struct bpf_object *obj)
 				return -ENOTSUP;
 			}
 		} else if (strcmp(sec_name, KSYMS_SEC) == 0) {
-			if (btf_is_func(t) && ext->is_weak) {
-				pr_warn("extern weak function %s is unsupported\n",
-					ext->name);
-				return -ENOTSUP;
-			}
 			ksym_sec = sec;
 			ext->type = EXT_KSYM;
 			skip_mods_and_typedefs(obj->btf, t->type,
@@ -5342,8 +5337,12 @@ bpf_object__relocate_data(struct bpf_object *obj, struct bpf_program *prog)
 		case RELO_EXTERN_FUNC:
 			ext = &obj->externs[relo->sym_off];
 			insn[0].src_reg = BPF_PSEUDO_KFUNC_CALL;
-			insn[0].imm = ext->ksym.kernel_btf_id;
-			insn[0].off = ext->ksym.offset;
+			if (ext->is_set) {
+				insn[0].imm = ext->ksym.kernel_btf_id;
+				insn[0].off = ext->ksym.offset;
+			} else { /* unresolved weak kfunc */
+				insn[0].imm = insn[0].off = 0;
+			}
 			break;
 		case RELO_SUBPROG_ADDR:
 			if (insn[0].src_reg != BPF_PSEUDO_FUNC) {
@@ -6734,8 +6733,10 @@ static int bpf_object__resolve_ksym_func_btf_id(struct bpf_object *obj,
 
 	kfunc_id = find_ksym_btf_id(obj, ext->name, BTF_KIND_FUNC,
 				    &kern_btf, &kern_btf_fd);
-	if (kfunc_id < 0) {
-		pr_warn("extern (func ksym) '%s': not found in kernel BTF\n",
+	if (kfunc_id == -ESRCH && ext->is_weak) {
+		return 0;
+	} else if (kfunc_id < 0) {
+		pr_warn("extern (func ksym) '%s': not found in kernel or module BTFs\n",
 			ext->name);
 		return kfunc_id;
 	}
-- 
2.33.0


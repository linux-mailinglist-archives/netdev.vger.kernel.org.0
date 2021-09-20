Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D33C4116A3
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 16:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240050AbhITOR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 10:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231276AbhITORU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 10:17:20 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C865C061764;
        Mon, 20 Sep 2021 07:15:54 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id g184so17466543pgc.6;
        Mon, 20 Sep 2021 07:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=te9g4sIFu/T32nk42OfmNuAINw4PTbgEMbJ1MLNAZRY=;
        b=PEujym+HhOfZ6b/S6Ai3WOVRqS6uh6YyEq5OdFo+6kX1qn1dmBH5p2NjAU5MymteQ2
         eDlbUfblawUklzBO/JvOVBxCsU4qeFa1EYrQhsHGzCPH3nlmVR1MNjkxTLXqUCHmdKYK
         lspA7IwN/1J0jxFkxzqUHdqPjegcssj+sROaz5bGNXslb/1sDdUmVicpaObYDg6ArzIW
         G+LShCKyiaVTrUM7ym+6XsningCAdhrK1MoAEuij9/8dBPTgtl7wYh+kdXKKrwsb7cLc
         NJX1EdGRW+Z2nBSc4z9M/FUguTbwjZuasQ4m5vdx7sX1emcSTGnQsxspi5KV5Xjz2Ndy
         qlfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=te9g4sIFu/T32nk42OfmNuAINw4PTbgEMbJ1MLNAZRY=;
        b=hdGzNDO5myloIrOkjeSelJFy6JFFDVu1Jrud3HDHdUzQPND/h4Axm1xzAxtFyAOWtE
         O83k+lN/vMtNlVSFx3U0wpTsxQvXsGFUmrkt5T1POCvWXaZDz/7e1x+pALQOH8BqukqD
         8/dt2fk8S3yYfTNY4sXxYvUSatsQPRq8JBqJ5Qd1p8QUAo6uQh+M1wVwDWCj7IMhOUou
         5NK4KzLAH1jNL8VJ9425+FnN1m8zrkqzCIQolRu7k8nLmr5ueDuJHnWY/Ag38lv8tdhY
         zhNlNupElGOuPOH/HVs3DimjijH1jc9x3XCrHOW/I7Klsp5ehppvT8iHFa289CuetwJR
         LqHw==
X-Gm-Message-State: AOAM5302lZ+3yzT1+tngETO9kwbMg8xiCjlc95G8bB0iRlkP8iINlmZK
        jo/DoLym2oEpMwmQToE9fvE+NwgN8vTzHA==
X-Google-Smtp-Source: ABdhPJwxWKG7W0EPGaX4wdLYUy25V7c9ZBwRQDCOV4lMepVVbvUpf/l2h2Z2UrcYbj4xSurqd4qEhg==
X-Received: by 2002:a65:51c7:: with SMTP id i7mr23617938pgq.300.1632147353456;
        Mon, 20 Sep 2021 07:15:53 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id e7sm5149504pfc.114.2021.09.20.07.15.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 07:15:53 -0700 (PDT)
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
Subject: [PATCH bpf-next v4 07/11] libbpf: Resolve invalid weak kfunc calls with imm = 0, off = 0
Date:   Mon, 20 Sep 2021 19:45:22 +0530
Message-Id: <20210920141526.3940002-8-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920141526.3940002-1-memxor@gmail.com>
References: <20210920141526.3940002-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2121; h=from:subject; bh=DIKZk02eVbFz8E418BE9H99i/d/b1w8QfPx3AHedmCw=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhSJaE6bY7tiJUVYdXMNqPlgqVEb1XuP3C5mvGecT0 TVm4drGJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYUiWhAAKCRBM4MiGSL8RyusxD/ 9mcB4O+uz9l2RhaLJsLWuGjve1XsV//MBEyGg8Xt+3wBUE1OIE1T0xPU1TMeC9A2TznHA4zYCjNwZq aIW2hqJA4WLtGRguBeADXbpq8WK3Je7oWWoVsZX6qKMIqs3b7y5NfWd8+G7lD05KFEHWGWd+DWvJi+ zzBAq/+FFmP0MuQeybmdEVIMJxhp/PNwBdKDIwOQmpBhIc4mjQZCNqAgISqHlSrF6kNXme6p1WhzwP MqeSNaVOc/B8p2THOaR+/3kzueyVSD1+wqTxmmNzRs+PfaFAEDRpB9Ov8WzlBb+MtdW6YFdoeTgYf1 4XGb44bOrLLUA0OZasGwIsWVzDFP6ca6fERtp5rEn1yOsJ2bhRf93IBjY9uWG+bomXilFopQkfgf5v wqHXgQB4BviioxRo3HjDMG5VDO1594n8e2VRtiZ7FlCgUHCIGK/6b7ekzjc8BNMkH+T2tpGt+icn7R ubnZhqrNnXQxZqBAxfu/URagAUjfyhya1hDXL68Gu5HKpX2qNMwtFIAWgi1s/jkJSeaAblBZ3JcDxq bXl4+MLdvy7BvYUguw0QPmYRGCD70yx+HZQq1nk7qvHTwj5JffIaauQuDRhvfxB8hFUM0OU4ZxH9kG zJQEJf6r0LC0wsOSMsDVybtR3v127RjjFZ7NNHApzFqEQ3oJayWx0LH/00vQ==
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
index 3049dfc6088e..3c195eaadf56 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3413,11 +3413,6 @@ static int bpf_object__collect_externs(struct bpf_object *obj)
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
@@ -5366,8 +5361,12 @@ bpf_object__relocate_data(struct bpf_object *obj, struct bpf_program *prog)
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
@@ -6768,8 +6767,10 @@ static int bpf_object__resolve_ksym_func_btf_id(struct bpf_object *obj,
 
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3BA41F917
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 03:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232348AbhJBBUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 21:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232304AbhJBBUH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 21:20:07 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 847F3C0613E4;
        Fri,  1 Oct 2021 18:18:22 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id y1so7347128plk.10;
        Fri, 01 Oct 2021 18:18:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wewkhhwNYcJ+qazuMZ8MfxHrMXyhhOXfh1BDJibl6zU=;
        b=h9pATacWZMN3oFswcHjvK/gvNgBovRzkeSLSaV86eU0sdTZBS3LRA627/hEVNsFrCc
         e8Nf1r8W2Qy7oVqPgUvszTWHruhRL46U6XZKF0vF+j6NvgZmqPCImKmt/x8oBNa7Pmg4
         qoYMS/eycInL0VFc8S+dRjfVN8JQOGsk6yfLSCaUIBcEExoDlTSxC1l9+c01qXfN5uJC
         xxlVQ6c2G0EUVFHmE3MS1FqCGYtLEy5ZX4qumQA+bsTypXGWHXiuLJzd5lbD5EWxIdtr
         dz1aQ3b1tOt6rJl2zGpayIUKxlT79Vd6n6iQrjxUNPmVtTqQvkr8CjcPKkBui2UVPL52
         kG5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wewkhhwNYcJ+qazuMZ8MfxHrMXyhhOXfh1BDJibl6zU=;
        b=DWasIV5GYeVCgARRSNeWt9wgtJvcXpEAvwoaCqtgsr2jPKEEUuyztjkuGCPWAMOqUe
         xT4Q03QBKKr3MAKKPhKYw3Mp3IVn+NHDBe0j0NFqgMzXXNUccHq2s9D8s0Wm46M/p6OS
         67TZ9nFCfABI4PXkZMmjrlRraMjzIA+L/uVu+Po8ajGLq3KV5UIvlmUOa3mYsuCPzWyt
         9Ie9ZOizFHOv+KnjSbr76SqBYSdvzBJVNvDBE/XxA6b4L6Hha4JeXCEWrFuUfnLef+qQ
         vDMhaMRJVmdJ+zrEEqpAUESxIHSe4sRmgvJSc7/0TC54GMlx7ImovFW+q+fRWk86Gj6k
         Z6sA==
X-Gm-Message-State: AOAM530Tnh/gDHzRJO6U5mOxFXbs1SMnwz8UIdl+CKXE4p6oz6iLA6Xp
        X2ei4UGfqSBLEGO81YFZGsRyV5XPE38=
X-Google-Smtp-Source: ABdhPJwjzqcfrhf8Z6xFfQ9nrPaMi6f+d583rBwichqVgOzUPc6N2WpbfWEpKJKFtbiaPCzu1ajDlA==
X-Received: by 2002:a17:90a:6c97:: with SMTP id y23mr16734818pjj.117.1633137501929;
        Fri, 01 Oct 2021 18:18:21 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id e8sm6931825pfn.45.2021.10.01.18.18.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 18:18:21 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v7 7/9] libbpf: Resolve invalid weak kfunc calls with imm = 0, off = 0
Date:   Sat,  2 Oct 2021 06:47:55 +0530
Message-Id: <20211002011757.311265-8-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211002011757.311265-1-memxor@gmail.com>
References: <20211002011757.311265-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2575; h=from:subject; bh=38TYx4WvwVhwS/xCGMtko+uMr4vgLxfodQ07csI7Woo=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhV7MRq0APtx+ptnUKQ6aPO6mdVkLn+FSMYPA7jQw+ hM82jJOJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYVezEQAKCRBM4MiGSL8RyofJEA Crp30LsRan41PMgYImiTHAUBzaHKnTgdsamwYozktUDVdGd12pqST+hmSrMDWWpo+a0uHshLw0ynKX P3yvF+js7iWRVKWvwr7AMvWJsoWHjQ43HljhYJxCdxDZPbj4XC1P340F4LK7/FJ/RwMfCYuq0F9yZp lgvVGLSiFKOuDroJhaYsRMiiRSUtxplAcNPAJalN65IDSTVYeQsF+dU9vqY1Molq82vbJmZ3Lo5T90 uMpPiYpyr8IjkM1EQfmRLfEGi01cf5ETW28pco9uVv3HjTlNIWsqRbQszOl0ONd/Eob2ylY6xRHsoi i8mnHHprb5ku3eIoHy4uZCvRi8NCailxGaBAIaYQKFB3VxccI5OwHNfEyeMMbkPV+SKjKV8SAfWe4m v6lyGofoCyNEtfK2/+yzCnXA1l/MlvD0RmMeQm4j3cLU9km9HF7i+MqcvXySlx5tnviNVRyps7aGJJ Ra4MDPMOCjKj8m4IE+ImPV2yZPgB1qQ/nG6OzWjgOfxja4QMja1Vsmpk44xS/hdmhE37VZcPlTvXk7 1RAHT248/v7Gl1KMltvfcMVtMPSBMc5MqYc7By5Eif60JdDI6WgP0j95CeRfomrCSBiQ5MgkCgAdfs 7vfUV834w4UFvDm4oMUcOXXq0/WRkerZ+zizB9Mtk1hOF2pi/sWj+CyTexTg==
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

Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/lib/bpf/libbpf.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index ea1c51dbc0f3..092cf4bd1879 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3439,11 +3439,6 @@ static int bpf_object__collect_externs(struct bpf_object *obj)
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
@@ -5416,8 +5411,13 @@ bpf_object__relocate_data(struct bpf_object *obj, struct bpf_program *prog)
 		case RELO_EXTERN_FUNC:
 			ext = &obj->externs[relo->sym_off];
 			insn[0].src_reg = BPF_PSEUDO_KFUNC_CALL;
-			insn[0].imm = ext->ksym.kernel_btf_id;
-			insn[0].off = ext->ksym.btf_fd_idx;
+			if (ext->is_set) {
+				insn[0].imm = ext->ksym.kernel_btf_id;
+				insn[0].off = ext->ksym.btf_fd_idx;
+			} else { /* unresolved weak kfunc */
+				insn[0].imm = 0;
+				insn[0].off = 0;
+			}
 			break;
 		case RELO_SUBPROG_ADDR:
 			if (insn[0].src_reg != BPF_PSEUDO_FUNC) {
@@ -6807,9 +6807,9 @@ static int bpf_object__resolve_ksym_var_btf_id(struct bpf_object *obj,
 	int id, err;
 
 	id = find_ksym_btf_id(obj, ext->name, BTF_KIND_VAR, &btf, &mod_btf);
-	if (id == -ESRCH && ext->is_weak) {
-		return 0;
-	} else if (id < 0) {
+	if (id < 0) {
+		if (id == -ESRCH && ext->is_weak)
+			return 0;
 		pr_warn("extern (var ksym) '%s': not found in kernel BTF\n",
 			ext->name);
 		return id;
@@ -6862,7 +6862,9 @@ static int bpf_object__resolve_ksym_func_btf_id(struct bpf_object *obj,
 
 	kfunc_id = find_ksym_btf_id(obj, ext->name, BTF_KIND_FUNC, &kern_btf, &mod_btf);
 	if (kfunc_id < 0) {
-		pr_warn("extern (func ksym) '%s': not found in kernel BTF\n",
+		if (kfunc_id == -ESRCH && ext->is_weak)
+			return 0;
+		pr_warn("extern (func ksym) '%s': not found in kernel or module BTFs\n",
 			ext->name);
 		return kfunc_id;
 	}
-- 
2.33.0


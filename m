Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F386221300F
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 01:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbgGBX1A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 19:27:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726682AbgGBX0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 19:26:46 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 405EFC08C5F3
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 16:26:46 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id g17so11895026plq.12
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 16:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qF2CZLD/R1jGbARFMDcuALfF7zwKKffMFtAaWgLK3W0=;
        b=i9T8ozZ9ILF7cYgT0p8o+yUm2cFKjkJXBGmvy79jB5e88qD3+7WZFNa+uSSHVHSFJd
         EwEBbQ8tE9q532P4nAt96j1X64DwrXyFjcqNDRCZg7Gfgub7t+fL2hufnw5nF5Kyer+T
         5i79oPAisVKS5G1ySfNLaEKNytZQ7DaEPquhA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qF2CZLD/R1jGbARFMDcuALfF7zwKKffMFtAaWgLK3W0=;
        b=jbJtQN3OCO96n11FDtLEpNicBaMyGFinsXL+xh9CUn3XDuS+Z+NXCRCJkFnB8ucSml
         xA/eZDbOQggiZx3CsgXamSEjZlZwZcByReXwqp8VDYV+EHFOJ3EF2OzB92oUysYofkXa
         QskMTX8C4tjKJR4cWUBMfXqd1ian39q7VPRxBNoWZkhwsXKcDzHaH1U91NUnrJB6cIgT
         kX45jytHFEy74qKsLdaO5VM60AWO4GWHMPwog8zaLVy+xL64c+opmFgA95L273Ob/1fa
         EXSavmb/rQeweiqad+CLhv4cQH+vqYblC+7h+5RJNuIedzIF/ftNOwHAXbaif+3AxGb2
         zMHw==
X-Gm-Message-State: AOAM531hS8Q6vsP+RRlHgiBFrMAjqNVJW+uKXJNNgrydfFtBPUfC67bc
        GW0Nj1F12OwhIQtf0DqMyOAXWQ==
X-Google-Smtp-Source: ABdhPJz+z5PcmwjIbTbZn2qz8H3DMOipoQ1ecGl4gDxfvJgwEl9tv9acCNS3vGQ8KUBm7wSNRITMkw==
X-Received: by 2002:a17:90a:db8a:: with SMTP id h10mr27506485pjv.58.1593732405796;
        Thu, 02 Jul 2020 16:26:45 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id q24sm9468589pgg.3.2020.07.02.16.26.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 16:26:44 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Dominik Czarnota <dominik.czarnota@trailofbits.com>
Cc:     Kees Cook <keescook@chromium.org>, stable@vger.kernel.org,
        Jessica Yu <jeyu@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Will Deacon <will@kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Marc Zyngier <maz@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Matteo Croce <mcroce@redhat.com>,
        Edward Cree <ecree@solarflare.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Alexander Lobakin <alobakin@dlink.ru>,
        Thomas Richter <tmricht@linux.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] bpf: Check correct cred for CAP_SYSLOG in bpf_dump_raw_ok()
Date:   Thu,  2 Jul 2020 16:26:38 -0700
Message-Id: <20200702232638.2946421-6-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702232638.2946421-1-keescook@chromium.org>
References: <20200702232638.2946421-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When evaluating access control over kallsyms visibility, credentials at
open() time need to be used, not the "current" creds (though in BPF's
case, this has likely always been the same). Plumb access to associated
file->f_cred down through bpf_dump_raw_ok() and its callers now that
kallsysm_show_value() has been refactored to take struct cred.

Cc: stable@vger.kernel.org
Fixes: 7105e828c087 ("bpf: allow for correlation of maps and helpers in dump")
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/filter.h     |  4 ++--
 kernel/bpf/syscall.c       | 37 +++++++++++++++++++++----------------
 net/core/sysctl_net_core.c |  2 +-
 3 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 55104f6c78e8..0b0144752d78 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -884,12 +884,12 @@ void bpf_jit_compile(struct bpf_prog *prog);
 bool bpf_jit_needs_zext(void);
 bool bpf_helper_changes_pkt_data(void *func);
 
-static inline bool bpf_dump_raw_ok(void)
+static inline bool bpf_dump_raw_ok(const struct cred *cred)
 {
 	/* Reconstruction of call-sites is dependent on kallsyms,
 	 * thus make dump the same restriction.
 	 */
-	return kallsyms_show_value(current_cred());
+	return kallsyms_show_value(cred);
 }
 
 struct bpf_prog *bpf_patch_insn_single(struct bpf_prog *prog, u32 off,
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 8da159936bab..859053ddf05b 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3139,7 +3139,8 @@ static const struct bpf_map *bpf_map_from_imm(const struct bpf_prog *prog,
 	return NULL;
 }
 
-static struct bpf_insn *bpf_insn_prepare_dump(const struct bpf_prog *prog)
+static struct bpf_insn *bpf_insn_prepare_dump(const struct bpf_prog *prog,
+					      const struct cred *f_cred)
 {
 	const struct bpf_map *map;
 	struct bpf_insn *insns;
@@ -3165,7 +3166,7 @@ static struct bpf_insn *bpf_insn_prepare_dump(const struct bpf_prog *prog)
 		    code == (BPF_JMP | BPF_CALL_ARGS)) {
 			if (code == (BPF_JMP | BPF_CALL_ARGS))
 				insns[i].code = BPF_JMP | BPF_CALL;
-			if (!bpf_dump_raw_ok())
+			if (!bpf_dump_raw_ok(f_cred))
 				insns[i].imm = 0;
 			continue;
 		}
@@ -3221,7 +3222,8 @@ static int set_info_rec_size(struct bpf_prog_info *info)
 	return 0;
 }
 
-static int bpf_prog_get_info_by_fd(struct bpf_prog *prog,
+static int bpf_prog_get_info_by_fd(struct file *file,
+				   struct bpf_prog *prog,
 				   const union bpf_attr *attr,
 				   union bpf_attr __user *uattr)
 {
@@ -3290,11 +3292,11 @@ static int bpf_prog_get_info_by_fd(struct bpf_prog *prog,
 		struct bpf_insn *insns_sanitized;
 		bool fault;
 
-		if (prog->blinded && !bpf_dump_raw_ok()) {
+		if (prog->blinded && !bpf_dump_raw_ok(file->f_cred)) {
 			info.xlated_prog_insns = 0;
 			goto done;
 		}
-		insns_sanitized = bpf_insn_prepare_dump(prog);
+		insns_sanitized = bpf_insn_prepare_dump(prog, file->f_cred);
 		if (!insns_sanitized)
 			return -ENOMEM;
 		uinsns = u64_to_user_ptr(info.xlated_prog_insns);
@@ -3328,7 +3330,7 @@ static int bpf_prog_get_info_by_fd(struct bpf_prog *prog,
 	}
 
 	if (info.jited_prog_len && ulen) {
-		if (bpf_dump_raw_ok()) {
+		if (bpf_dump_raw_ok(file->f_cred)) {
 			uinsns = u64_to_user_ptr(info.jited_prog_insns);
 			ulen = min_t(u32, info.jited_prog_len, ulen);
 
@@ -3363,7 +3365,7 @@ static int bpf_prog_get_info_by_fd(struct bpf_prog *prog,
 	ulen = info.nr_jited_ksyms;
 	info.nr_jited_ksyms = prog->aux->func_cnt ? : 1;
 	if (ulen) {
-		if (bpf_dump_raw_ok()) {
+		if (bpf_dump_raw_ok(file->f_cred)) {
 			unsigned long ksym_addr;
 			u64 __user *user_ksyms;
 			u32 i;
@@ -3394,7 +3396,7 @@ static int bpf_prog_get_info_by_fd(struct bpf_prog *prog,
 	ulen = info.nr_jited_func_lens;
 	info.nr_jited_func_lens = prog->aux->func_cnt ? : 1;
 	if (ulen) {
-		if (bpf_dump_raw_ok()) {
+		if (bpf_dump_raw_ok(file->f_cred)) {
 			u32 __user *user_lens;
 			u32 func_len, i;
 
@@ -3451,7 +3453,7 @@ static int bpf_prog_get_info_by_fd(struct bpf_prog *prog,
 	else
 		info.nr_jited_line_info = 0;
 	if (info.nr_jited_line_info && ulen) {
-		if (bpf_dump_raw_ok()) {
+		if (bpf_dump_raw_ok(file->f_cred)) {
 			__u64 __user *user_linfo;
 			u32 i;
 
@@ -3497,7 +3499,8 @@ static int bpf_prog_get_info_by_fd(struct bpf_prog *prog,
 	return 0;
 }
 
-static int bpf_map_get_info_by_fd(struct bpf_map *map,
+static int bpf_map_get_info_by_fd(struct file *file,
+				  struct bpf_map *map,
 				  const union bpf_attr *attr,
 				  union bpf_attr __user *uattr)
 {
@@ -3540,7 +3543,8 @@ static int bpf_map_get_info_by_fd(struct bpf_map *map,
 	return 0;
 }
 
-static int bpf_btf_get_info_by_fd(struct btf *btf,
+static int bpf_btf_get_info_by_fd(struct file *file,
+				  struct btf *btf,
 				  const union bpf_attr *attr,
 				  union bpf_attr __user *uattr)
 {
@@ -3555,7 +3559,8 @@ static int bpf_btf_get_info_by_fd(struct btf *btf,
 	return btf_get_info_by_fd(btf, attr, uattr);
 }
 
-static int bpf_link_get_info_by_fd(struct bpf_link *link,
+static int bpf_link_get_info_by_fd(struct file *file,
+				  struct bpf_link *link,
 				  const union bpf_attr *attr,
 				  union bpf_attr __user *uattr)
 {
@@ -3608,15 +3613,15 @@ static int bpf_obj_get_info_by_fd(const union bpf_attr *attr,
 		return -EBADFD;
 
 	if (f.file->f_op == &bpf_prog_fops)
-		err = bpf_prog_get_info_by_fd(f.file->private_data, attr,
+		err = bpf_prog_get_info_by_fd(f.file, f.file->private_data, attr,
 					      uattr);
 	else if (f.file->f_op == &bpf_map_fops)
-		err = bpf_map_get_info_by_fd(f.file->private_data, attr,
+		err = bpf_map_get_info_by_fd(f.file, f.file->private_data, attr,
 					     uattr);
 	else if (f.file->f_op == &btf_fops)
-		err = bpf_btf_get_info_by_fd(f.file->private_data, attr, uattr);
+		err = bpf_btf_get_info_by_fd(f.file, f.file->private_data, attr, uattr);
 	else if (f.file->f_op == &bpf_link_fops)
-		err = bpf_link_get_info_by_fd(f.file->private_data,
+		err = bpf_link_get_info_by_fd(f.file, f.file->private_data,
 					      attr, uattr);
 	else
 		err = -EINVAL;
diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index f93f8ace6c56..6ada114bbcca 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -274,7 +274,7 @@ static int proc_dointvec_minmax_bpf_enable(struct ctl_table *table, int write,
 	ret = proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
 	if (write && !ret) {
 		if (jit_enable < 2 ||
-		    (jit_enable == 2 && bpf_dump_raw_ok())) {
+		    (jit_enable == 2 && bpf_dump_raw_ok(current_cred()))) {
 			*(int *)table->data = jit_enable;
 			if (jit_enable == 2)
 				pr_warn("bpf_jit_enable = 2 was set! NEVER use this in production, only for JIT debugging!\n");
-- 
2.25.1


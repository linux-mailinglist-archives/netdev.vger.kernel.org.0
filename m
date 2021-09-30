Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF2D41D35E
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 08:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348359AbhI3Gbl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 02:31:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348121AbhI3Gbj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 02:31:39 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF9C3C06161C;
        Wed, 29 Sep 2021 23:29:56 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id u7so4026140pfg.13;
        Wed, 29 Sep 2021 23:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bVwuyX9fAp2tKhkzcO8y6Eg2QuE05iMepjLtwR/q/qw=;
        b=OizwjSevXMymLpdIzdOST1GrDR0zWJ5UxH6keGlqycNMnnQUPpF+gzLrnjZBRY+GkX
         Kv+hSv1E25+x43xpMHaYbkv36Q7uVDpyjro9fwnUIzbFfEB+pPpJGbiYaCaunPKOlxKa
         yCOjnHUu4nJXVbBlIdJvbzOrZccEIc3AZ/p4AsFaZQ+wXMCbw2kuCQitoiJ/Llyoh6Jt
         od56pwIT8eCFFzHbj8NVmh/1eAc8zOVRO09oX0SbdO3BV/VLiuOG4kZ+u9dqWWCUfc9M
         YAt9f8J1N8i0kbOY2MMGwJvp+emG5QzFY0IKZVHcf1JRGfdMcoDo5LGSQFJyC9NT0Oig
         Yu8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bVwuyX9fAp2tKhkzcO8y6Eg2QuE05iMepjLtwR/q/qw=;
        b=kO/94jEWDNRLdCpjfXmu4P72VdRqxTdcmccd4ZQbeHqaI7fDbs/znya7Jwl34UGNNA
         hi7U0N48IhAB5Mm4x3FnzGXak+GWy6C6m8j4GzKUHtr+z4qtFdKVJZ5bzfIEBlStyYUc
         EGuInGmcf6hbOQKKOlRxe3M1vYV1BXJzPAT1tKo8pJhR3T8y3C4YE+pVNHgHWdpUnifb
         s7vl5Jto1AvtuU28Yusfm1RcRZdQOIopDEXeNJdxdIXw0r5JrIp9WKGK2AqnGi3JwoQi
         CTbjiS6HhejbsB96YFhMr4L+PwcQKpsE+2X4Y29hcawY64ACgC7QArqe9QeLL/p+MLiH
         +mmA==
X-Gm-Message-State: AOAM533gl74mDyVROSJgc64F2bmd9OBQhuqMD9Iwa9bovQCglqPjyNF9
        5kpVrfyMwXPlNxIFS6iWJ0GNRQBOCF4=
X-Google-Smtp-Source: ABdhPJzQ43ZIC7U89FWd9x3bDoJkQWDvNTCxiZEU8NO9e3Qj1bP90OUu6pRiNCBEehsN50I1ig39/A==
X-Received: by 2002:a63:4c1f:: with SMTP id z31mr3539617pga.50.1632983396334;
        Wed, 29 Sep 2021 23:29:56 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id w5sm1519947pgp.79.2021.09.29.23.29.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 23:29:56 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v6 2/9] bpf: Be conservative while processing invalid kfunc calls
Date:   Thu, 30 Sep 2021 11:59:41 +0530
Message-Id: <20210930062948.1843919-3-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210930062948.1843919-1-memxor@gmail.com>
References: <20210930062948.1843919-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2214; h=from:subject; bh=x3YVMt/L0MGY0B3nxUM4mcwj3vHm+wmx831D+QS1NxQ=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhVVlBzI8YoaaH397Aj63CBNuXY/7jTT0W5O2i4Xp/ 8oeFOpSJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYVVZQQAKCRBM4MiGSL8Ryp2xEA CwCAwqfVtIlBTslqe7zx/TNKlCZWrNIhfrU1fl5FfrCbkPA3CQZAh0OMeG2ty6e+4Tf/vg9IVr4T9Y B72ngv0VNw3Ay4gPVoXwZpliMaSy+Ksz1J0eQns5ydivUwJnUFw86/OiK3aucVJplAUh4Ft4nBgUwI WpdjlMnOYWfjDYXWFFA+o+ksj77tXztGNNCF+NbmQU37SMmQ3CT+r2I+NCkjaFnT95m2Zhj8GUASdp QsZ/pWbw1rsKGImwdMjOso5dvQYN0XMsvf8T4iGR/Ug1PZ1uVfh3uPPoe6pOk9JHb5xYnGpn59qkrJ tFpM+nvCMz95yWn5v/FdiEWb+T3BUlHY5OlOmvKU2xyo3NtQlKsEi6Ib2tjgTvaABcmQia4lctThTt vASyXT4GZ53zmsWt5KWklj/muR5/mTaPQ3HY9Qm08DMAsShNfCPO8W4XgzIZAgb5oSJBLFD4VzNM3Y E06PKwEDP37pun6gY8xskXwMWoYoDfXbE/vEHTQjs50wMENFCLYZQMZF3mnluZCH8uJg3Ryr39eywu RhNK/QCPKVqmaco3hpZnr3Phwzr2bT54d0bgGVlchxOKAcHNoD+E4XOphd+/q7U7at9M5Eu9k04ZcB GEGoTGtClzhPQq0fJ7TZ1CHueMCvPlziEPYOrLV/BNNsWmeBekkdrEmGzUDg==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch also modifies the BPF verifier to only return error for
invalid kfunc calls specially marked by userspace (with insn->imm == 0,
insn->off == 0) after the verifier has eliminated dead instructions.
This can be handled in the fixup stage, and skip processing during add
and check stages.

If such an invalid call is dropped, the fixup stage will not encounter
insn->imm as 0, otherwise it bails out and returns an error.

This will be exposed as weak ksym support in libbpf in later patches.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 kernel/bpf/verifier.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 1d6d10265cab..68d6862de82e 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1834,6 +1834,15 @@ static int add_kfunc_call(struct bpf_verifier_env *env, u32 func_id, s16 offset)
 		prog_aux->kfunc_tab = tab;
 	}
 
+	/* func_id == 0 is always invalid, but instead of returning an error, be
+	 * conservative and wait until the code elimination pass before returning
+	 * error, so that invalid calls that get pruned out can be in BPF programs
+	 * loaded from userspace.  It is also required that offset be untouched
+	 * for such calls.
+	 */
+	if (!func_id && !offset)
+		return 0;
+
 	if (!btf_tab && offset) {
 		btf_tab = kzalloc(sizeof(*btf_tab), GFP_KERNEL);
 		if (!btf_tab)
@@ -6675,6 +6684,10 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn)
 	struct btf *desc_btf;
 	int err;
 
+	/* skip for now, but return error when we find this in fixup_kfunc_call */
+	if (!insn->imm)
+		return 0;
+
 	desc_btf = find_kfunc_desc_btf(env, insn->imm, insn->off, &btf_mod);
 	if (IS_ERR(desc_btf))
 		return PTR_ERR(desc_btf);
@@ -12810,6 +12823,11 @@ static int fixup_kfunc_call(struct bpf_verifier_env *env,
 {
 	const struct bpf_kfunc_desc *desc;
 
+	if (!insn->imm) {
+		verbose(env, "invalid kernel function call not eliminated in verifier pass\n");
+		return -EINVAL;
+	}
+
 	/* insn->imm has the btf func_id. Replace it with
 	 * an address (relative to __bpf_base_call).
 	 */
-- 
2.33.0


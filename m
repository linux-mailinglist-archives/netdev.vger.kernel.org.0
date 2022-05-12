Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6C77524FF3
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 16:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355006AbiELO3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 10:29:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344674AbiELO3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 10:29:14 -0400
Received: from mail.nfschina.com (unknown [IPv6:2400:dd01:100f:2:72e2:84ff:fe10:5f45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AB5FC62127;
        Thu, 12 May 2022 07:29:12 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id 5F0391E80D22;
        Thu, 12 May 2022 22:23:35 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id xYV0EK951nP4; Thu, 12 May 2022 22:23:32 +0800 (CST)
Received: from localhost.localdomain (unknown [180.167.10.98])
        (Authenticated sender: liqiong@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id C13A21E80D04;
        Thu, 12 May 2022 22:23:31 +0800 (CST)
From:   liqiong <liqiong@nfschina.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, hukun@nfschina.com,
        qixu@nfschina.com, yuzhe@nfschina.com, renyu@nfschina.com,
        liqiong <liqiong@nfschina.com>
Subject: [PATCH 1/2] kernel/bpf: change "char *" string form to "char []"
Date:   Thu, 12 May 2022 22:28:14 +0800
Message-Id: <20220512142814.26705-1-liqiong@nfschina.com>
X-Mailer: git-send-email 2.11.0
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The string form of "char []" declares a single variable. It is better
than "char *" which creates two variables.

Signed-off-by: liqiong <liqiong@nfschina.com>
---
 kernel/bpf/btf.c      | 4 ++--
 kernel/bpf/verifier.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 0918a39279f6..218a8ac73644 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -894,10 +894,10 @@ static const struct btf_type *btf_type_skip_qualifiers(const struct btf *btf,
 static const char *btf_show_name(struct btf_show *show)
 {
 	/* BTF_MAX_ITER array suffixes "[]" */
-	const char *array_suffixes = "[][][][][][][][][][]";
+	static const char array_suffixes[] = "[][][][][][][][][][]";
 	const char *array_suffix = &array_suffixes[strlen(array_suffixes)];
 	/* BTF_MAX_ITER pointer suffixes "*" */
-	const char *ptr_suffixes = "**********";
+	static const char ptr_suffixes[] = "**********";
 	const char *ptr_suffix = &ptr_suffixes[strlen(ptr_suffixes)];
 	const char *name = NULL, *prefix = "", *parens = "";
 	const struct btf_member *m = show->state.member;
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index d175b70067b3..78a090fcbc72 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7346,7 +7346,7 @@ static int sanitize_err(struct bpf_verifier_env *env,
 			const struct bpf_reg_state *off_reg,
 			const struct bpf_reg_state *dst_reg)
 {
-	static const char *err = "pointer arithmetic with it prohibited for !root";
+	static const char err[] = "pointer arithmetic with it prohibited for !root";
 	const char *op = BPF_OP(insn->code) == BPF_ADD ? "add" : "sub";
 	u32 dst = insn->dst_reg, src = insn->src_reg;
 
-- 
2.25.1


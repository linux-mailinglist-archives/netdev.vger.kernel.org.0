Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55A8640BF26
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 07:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235968AbhIOFLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 01:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbhIOFLN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 01:11:13 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 408A1C061574;
        Tue, 14 Sep 2021 22:09:55 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id m26so1643835pff.3;
        Tue, 14 Sep 2021 22:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xAvBHOTWuUkmeV+A/AO7zoClGILIcsHPtYu1pQO27Xs=;
        b=luUgSbVOS5O6HwP2W/5tNKObWxkS057JudcuCteshLskxa6W0oHb6UHON2Ooxdk6sa
         vsugkrDkKQ4KWXeuGQRFX061UyFSNQU50att0/kZE3BrybNAvBJrdSu6WtQRJIbrMVVz
         +WszBsdcslQb7ajlfSbawkCmBaWfkXzMM2JI5vaoqfYxuIBO7hyqheZHtqDpZCPK5ZA7
         ilOxAuqenPKZpZp7BQYHUmwTL6yj4BI0JlJkvbnnpxxy+1s+gclQzweLlicMfH8N2ivb
         WbnYOpJ3HQEa3QeAvUxZU3DotYrHHXbxbMGzfeO21OusdD0u7tLsFuevVKcC9cROvW+z
         C1qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xAvBHOTWuUkmeV+A/AO7zoClGILIcsHPtYu1pQO27Xs=;
        b=Mzai9xeWR1m8v0KDNiOkZ76zilMTSryeCGC1aCJb+0Lrc85ZNrWleStkDuW6qlM99C
         LvOs0XAGpPiMQfHQk9qg7iVFt+JMv84bP3yf3LYf0IfcyddSFYnzF7u4Q5O48inEp7zl
         cN4/Y5tVmd9BX8jmS+YbwjALrLFukdyR8+4uXH+Ov/+tOAN0WAJYOZWZPKftK2boaZJV
         qPm/oDm5mgA+xxn+av/13LSOqxRJyEdYCa7f2Av/1x4X7C2q8X3PD2NDeiihxQaq3ot6
         LczWc+NfcB1LP4nzurt7kuIEeLV8OC6GAQysUCMZkxJqcyWEZAgBEzDbIgFWTWhSBYA/
         2tiQ==
X-Gm-Message-State: AOAM5305wZS9clFyjgSRiUqaIhg57HZykkWVLBHDnRi3y9BRxXYMQMyx
        Vhsuk9I7JuMNWiv6tJSQKvEOn9n0nbq/mw==
X-Google-Smtp-Source: ABdhPJw1OqqOEbe4CGc46R9LHf1cE5HCKykkKTEzGX/xGUfSJxq/TOAlfY7sLykcn1lUQSYTrf4QSg==
X-Received: by 2002:a63:62c7:: with SMTP id w190mr18551154pgb.105.1631682594578;
        Tue, 14 Sep 2021 22:09:54 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id g3sm13906038pgf.1.2021.09.14.22.09.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 22:09:54 -0700 (PDT)
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
Subject: [PATCH bpf-next v3 02/10] bpf: Be conservative while processing invalid kfunc calls
Date:   Wed, 15 Sep 2021 10:39:35 +0530
Message-Id: <20210915050943.679062-3-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210915050943.679062-1-memxor@gmail.com>
References: <20210915050943.679062-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2253; h=from:subject; bh=O5gYOSXqCNlH+1VViFI7jzfd613VWblQYlzpwF80hCo=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhQX4bolg/KkYC9TNtMYZRAC0KbMePhKGiu5kTpUKh QIbtibyJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYUF+GwAKCRBM4MiGSL8RypIID/ 43O/ORFWMJHJMpk01URIGHE1WXgnixOvkbdIMuHFyfg8/y+jzMN6vidLFEYr0uGzBwdKGiahwtuwCJ m4vu5xfvW+b4oHHvB1RDq3DvWt8dD1lGhpYgrdItqlNZmQjPxuhGZ+aYIYt3GglZExf2T0GM/Q6AK8 NJowk7c+5n5HT1GYzrFi62HbTrqOQg4NFXSGNcb7mr/4BUj12hmYE32mMLdaLOZPUCgvEmx4vvG8ps XyToHuuPu5WMXb7mUI5ius7YqTmnbphQ8g/dX9KSOXr8cih8fiPxWuBrFU/z9XX2XUWcvf3gXHmloq KJuRtBqqxpO2qXkQDJpdV3YK93C9RzzPhlpwwNNunOe1CQRgE3CqAV3AWNvYvOe6KrNrv7KoJ/0zOH IoAGn5I53o+SfFvsb3FExwg7yyrN7NWt98+kreMSpey030pdp+RAQ/zg3DDJnHmBnre566NfMcJym5 WRW3fZMir8Kc2GvmJ2NVYJfpe5RPhyO9NUtCRpOiwPBDUHcBIrFKse/jlbK2ir8U2QP2o6xhOdGnVI sWohlEE3o4FHTUxoM7pUjxdGazRs2yDw6UDKvIuh7x1wsDmvhxHFpFiyWvdJCmE3qNMMqM89vUtMvz Dn8bfrNIMRagdUEOH1DFAurFTQVPCquwr4BeE2KUSGhmdVbTqsJ+FSS6CsHg==
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

This will be exposed as weak ksym support in libbpf in subsequent patch.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 kernel/bpf/verifier.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 3a35af7d1180..f241ba78b970 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1817,6 +1817,15 @@ static int add_kfunc_call(struct bpf_verifier_env *env, u32 func_id, s16 offset)
 		prog_aux->kfunc_tab = tab;
 	}
 
+	/* btf idr allocates IDs from 1, so func_id == 0 is always invalid, but
+	 * instead of returning an error, be conservative and wait until the
+	 * code elimination pass before returning error, so that invalid calls
+	 * that get pruned out can be in BPF programs loaded from userspace.
+	 * It is also required that offset be untouched (0) for such calls.
+	 */
+	if (!func_id && !offset)
+		return 0;
+
 	if (!btf_tab && offset) {
 		btf_tab = kzalloc(sizeof(*btf_tab), GFP_KERNEL);
 		if (!btf_tab)
@@ -6627,6 +6636,10 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn)
 	struct btf *desc_btf;
 	int err;
 
+	/* skip for now, but return error when we find this in fixup_kfunc_call */
+	if (!insn->imm)
+		return 0;
+
 	desc_btf = find_kfunc_desc_btf(env, insn->imm, insn->off, &btf_mod);
 	if (IS_ERR(desc_btf))
 		return PTR_ERR(desc_btf);
@@ -12761,6 +12774,11 @@ static int fixup_kfunc_call(struct bpf_verifier_env *env,
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


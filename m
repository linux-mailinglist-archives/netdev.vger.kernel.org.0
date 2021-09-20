Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C474411699
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 16:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237135AbhITORK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 10:17:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235714AbhITORF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 10:17:05 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D62FC061574;
        Mon, 20 Sep 2021 07:15:38 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id 203so8517977pfy.13;
        Mon, 20 Sep 2021 07:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YC/5g23SPpiZ7A5VfOJx+Ff2nYKoj2UfUfHHpa2IJDY=;
        b=eaNr/HPJ4eandUEJWIhsl4IOLgaT6YvdDpDWsyGDUU+/+oHxEXfIpqM3DH+07neDIf
         uVI/p+Qh9k+sE2NrU5Jkwl040jh0YZHfe5Ob9titrCz6WIipCQDRDkJS8cjxVlPpeGqx
         IrpK2e6MwSBUisU+FpBWNdzqWLsfsG6JMIc1FMYGiGl2sLTZ6wZxu1dBg9aLYnP45mAl
         2+167W8zWqnWrBKxv37F9A0c04s6sIi+3Hz19IlI7eUfw864tFydJWlq38f4Y5cJVyfj
         kYGuoANocoUxZDZg7w7zWS5b5pOzjx4pdZGvMGVL/fBQ+H0O9jDTPcIeCVAiKbIz9N+Y
         UGnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YC/5g23SPpiZ7A5VfOJx+Ff2nYKoj2UfUfHHpa2IJDY=;
        b=6aUWn0sucRyMJTcuGMq2tZfMEQExtmaQaFHpDxzfiS8SW3J/LAzRFl8yaHp5o7t6hi
         eXXPfoinx4QUAe1is6LUoQNgW0hwZhuABfuitoKtCHnEiTeVWWqlRLlF06bRv970E5iL
         BghQLLuiY+YsFJ6WfNkppkj67IJPXR8hEGGoHsQiqAubR4P6OmTfv4Vn8B10ge3ohQp0
         D2uJ0H90D7g5qX25iteD5qh1v21o5wknXPIdTN1QuoTlhLPSAYeebdK/yV7fpK2CIi5t
         hlGqj0Ut0iyuPdp+zjaSjqO6br5XSRDM8OIP4JIyjqDwSgsoz4hxDMT2HnnhfA6fwAgj
         STZg==
X-Gm-Message-State: AOAM5329OzoDIj3++sJeRwlB+zIrGHqTDDmlieLfmzcHKuQuxqC2S04O
        uU6NV3RbLCsfd4nydVG+afah7dnsVFIwUg==
X-Google-Smtp-Source: ABdhPJz7y59Bho1YPw+kRTpPQoB66EGTzsySXGLQyLYvimG1ktBXhhtYErND7p9c9vuvvQPY7Kp63g==
X-Received: by 2002:a63:515f:: with SMTP id r31mr23484743pgl.41.1632147337780;
        Mon, 20 Sep 2021 07:15:37 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id e13sm10360574pfn.212.2021.09.20.07.15.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 07:15:37 -0700 (PDT)
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
Subject: [PATCH bpf-next v4 02/11] bpf: Be conservative while processing invalid kfunc calls
Date:   Mon, 20 Sep 2021 19:45:17 +0530
Message-Id: <20210920141526.3940002-3-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920141526.3940002-1-memxor@gmail.com>
References: <20210920141526.3940002-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2214; h=from:subject; bh=FKRyNZlxBXZubpWKuL4SYjb1veTjvmV2mok2OrudHXU=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhSJaDvRD+YlTis4ZpxqZMjImP98Z2FoCqLKhYqPfs a52iZuSJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYUiWgwAKCRBM4MiGSL8Rymj6D/ 9lL7f3voRclVpm4wPEixV6+/oIwsq5tfzBkKkQZBJWZywiiRdmLoY0D+drfbvt9GjO2xcIkpi4+kno EjyM6jEhXEvRzMY2Dz5qkxSCYopLliC/e3ORc2gVBqWGyi1XUE7d5RsCKDHA+x1o+hyAcJfIA8gpRj bdYxBw8EdCHAOdwoFa/XcMLveTUKuj0N/dzv66euCkEc9qXxS+TyJhdlHlXXdZ0fcwNRf20qS34P7Q zi0JmctCyC3Ih+GkZhVwpNJfvNaV4INguAPv1xdrJnAQwToFH4eqicPcnmsTUOV0m8etZp6Yf84ldS +DsW05rPhpxwdB4UpUwwSFsxAb0daJe/zE/G8ViT2kvzo9FflFkrbQUrEyctfYBz0l+zB6yJvcmCBh Hpv3kRSK0eaL/kE/u2vmYCLm+NFT3gYehSoQrIjlkFwwehj1k9267o3Xsd4bmArc6R2+Nd+FJjFhLh nm8yvqvuwRhGFdHvCZL19DFWH0DhdgoAjI0mNuHMebqkSJHuem2l94MPfiBM94Yrz5+R8TRcqjhlc+ IlCxfWHlp4xcPToJqmzqb/jzsShTlKkkG7bAeAhyW0MRqXB8bdfOT6h+SGX9Y64Avm7M3FkNjIpdlh xFOB0l/Pn5SMNFgBBWraYSGdvyp1NIrlQJBuGn5nJdZykKucXh1p8pMSNidg==
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
index 5b465d67cf65..58c86670dc55 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1820,6 +1820,15 @@ static int add_kfunc_call(struct bpf_verifier_env *env, u32 func_id, s16 offset)
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
@@ -6630,6 +6639,10 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn)
 	struct btf *desc_btf;
 	int err;
 
+	/* skip for now, but return error when we find this in fixup_kfunc_call */
+	if (!insn->imm)
+		return 0;
+
 	desc_btf = find_kfunc_desc_btf(env, insn->imm, insn->off, &btf_mod);
 	if (IS_ERR(desc_btf))
 		return PTR_ERR(desc_btf);
@@ -12766,6 +12779,11 @@ static int fixup_kfunc_call(struct bpf_verifier_env *env,
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


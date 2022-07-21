Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66B5457CC56
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 15:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbiGUNoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 09:44:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbiGUNnQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 09:43:16 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 329BE81484;
        Thu, 21 Jul 2022 06:43:02 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id id17so1075292wmb.1;
        Thu, 21 Jul 2022 06:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oJaG/VmMic1gA0kUbrF0F+FR+0HnyQc1s91sPztb7fQ=;
        b=IlPs5MYzp4s/CyiLlfaoUONkSKJltjAqsXdFxZkMFZ6t2y0DXRq9JGQvKudcgud/3m
         toU5S/iWI4YMozQTXsO4qa3Br8F94914nnzN2Sp3FFtdgcJZcVJ0yfjjyqNqJlFAWEy1
         YukgOO2tkIpwiL6QCkiwFO9kjyjd7oJ8zRWzjx2FuVMVipbXqP0q0HMkGi6tGXZWet+y
         OXEIodk54VCKqZwlFPGnCsdT+yov+sNmBgvCGjHSML+8ckfo++VnJRt4qBdeSfRMOjKR
         WlZKviuxRjl5flpTCpxzcI267nNoVP1rD8LkkZ0Fz85abFRO0Fs5nkrlJmZ9NcI0oIL+
         5HmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oJaG/VmMic1gA0kUbrF0F+FR+0HnyQc1s91sPztb7fQ=;
        b=CFFjC8g0rdPzt8dpVm2DhzsHvHRNwUvUBCwUGF5AJz0j4inK3Mfdk5oQtjmVPrVoWz
         GMT+4WFbN/7150FysSwYO/8qQl+TNaswu640E5rjnLM7XQc3toqWCZ0C/He+G/9s1+06
         yZn+bHlD9mA0EcTzsVNal33kABsvsHELcQjirO3VIBTynRluDDxZ052xLf+8QogT8amY
         krNvYzZ+qDz9ThLNbIk/ESkdtxpSggoNeRO0kg2H4rsgFmCMI7ojE5QJoCgOko/TB5zq
         tz8FpTJ6gB8vUPs8yai30cITSl/LqVEdQ8Pl9S+e5rPSLRlmH8IxG/blgnft2l0LsDis
         2QVQ==
X-Gm-Message-State: AJIora89Cvi3Fqpe1hUZeCj3VQbjVoKHmLK0Yq0y807TsKgn9FYLE755
        YSJZkXTE1/FopU+zjSKp0QsCIhA+0IdG9g==
X-Google-Smtp-Source: AGRyM1uXO/pXLhsXmDHGZSnvgtbr/uYG8RTZkft7V+M6+LQLizrvXgd42ob90JjfgP1la3dj23b1IA==
X-Received: by 2002:a05:600c:22c2:b0:3a3:19e3:a55 with SMTP id 2-20020a05600c22c200b003a319e30a55mr8434758wmg.53.1658410980540;
        Thu, 21 Jul 2022 06:43:00 -0700 (PDT)
Received: from localhost (212.191.202.62.dynamic.cgnat.res.cust.swisscom.ch. [62.202.191.212])
        by smtp.gmail.com with ESMTPSA id x15-20020a5d490f000000b0021e43b4edf0sm1993945wrq.20.2022.07.21.06.42.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 06:43:00 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: [PATCH bpf-next v7 10/13] selftests/bpf: Add verifier tests for trusted kfunc args
Date:   Thu, 21 Jul 2022 15:42:42 +0200
Message-Id: <20220721134245.2450-11-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220721134245.2450-1-memxor@gmail.com>
References: <20220721134245.2450-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2710; i=memxor@gmail.com; h=from:subject; bh=05K1J2eUnBt0cSOtFvj14bJImp6Ksy5W7PBDUKEJ/4E=; b=owEBbQKS/ZANAwAKAUzgyIZIvxHKAcsmYgBi2VfOQhxV3hTsuPzBv5/b1ieDZMj7Ixd2Z2WfCkrl jHhQzxKJAjMEAAEKAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYtlXzgAKCRBM4MiGSL8RylmuEA ChSz+YWqiFH81mS7znecf+L4MhbeKUj/PCxnAT68XlCHTKEgKEBsnFdbjAps3yzThtX02ChgEjNnFN Y0OS32EihK5LVUG6WC4l1/MXf6AtEHR+FrMWEJCmc/JLwHsoq8jm4Pw2FEd8P4RqxJmawHooSHrROC mYDzyEu+LdRudvxKJ9X19S2KnsMeEgUH3ovRFSzptn2zg0/B52QTig7OQ5xjOBuKqxIZ3lAjuMbTPT S4KB0EmraDNCj3bi00H8yJKZlPZa52XooC/USSw2/c6Rq2d16HvEsjPZy53CGYK5gNwtA8wXROe2p2 DB5unfi47ahbxyVP27IkgUjKyYwq11i3kUHn4oQR6439H1L2CZeouViI104odeNPJ2XBW/mRh2/2Zd X3MS5Wm7mO7k3+RNLt/JUGs5b4toRiAsKU39R+YZ6Z9iEES01RcXY427veZY025D0z7z0aZYEAOXZf 1T3Xtlxo+ImJ9fFxF3/83aUlJO2y2MkLlaMOArO7VzfYtZlzJiL4/wxaQ83+z+ZyuvpPTwrl5AMg38 L1vO+gYhnO2fcbq+6EeTHbte365DosZTCj0rRpA6JRIzJqiyKpqYBu2+j8gF1C4ZjHWIetEg+U8SBF 8PZJZMyHPl/6t8iHneCjOI63tgDBwqwZ/HosdrYAih9nBwC76eX1sB4GshSA==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure verifier rejects the bad cases and ensure the good case keeps
working. The selftests make use of the bpf_kfunc_call_test_ref kfunc
added in the previous patch only for verification.

Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/testing/selftests/bpf/verifier/calls.c | 53 ++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/tools/testing/selftests/bpf/verifier/calls.c b/tools/testing/selftests/bpf/verifier/calls.c
index 743ed34c1238..3fb4f69b1962 100644
--- a/tools/testing/selftests/bpf/verifier/calls.c
+++ b/tools/testing/selftests/bpf/verifier/calls.c
@@ -218,6 +218,59 @@
 	.result = REJECT,
 	.errstr = "variable ptr_ access var_off=(0x0; 0x7) disallowed",
 },
+{
+	"calls: invalid kfunc call: referenced arg needs refcounted PTR_TO_BTF_ID",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, -8),
+	BPF_ST_MEM(BPF_DW, BPF_REG_1, 0, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, BPF_PSEUDO_KFUNC_CALL, 0, 0),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_0),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, BPF_PSEUDO_KFUNC_CALL, 0, 0),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_6, 16),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, BPF_PSEUDO_KFUNC_CALL, 0, 0),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
+	.fixup_kfunc_btf_id = {
+		{ "bpf_kfunc_call_test_acquire", 3 },
+		{ "bpf_kfunc_call_test_ref", 8 },
+		{ "bpf_kfunc_call_test_ref", 10 },
+	},
+	.result_unpriv = REJECT,
+	.result = REJECT,
+	.errstr = "R1 must be referenced",
+},
+{
+	"calls: valid kfunc call: referenced arg needs refcounted PTR_TO_BTF_ID",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, -8),
+	BPF_ST_MEM(BPF_DW, BPF_REG_1, 0, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, BPF_PSEUDO_KFUNC_CALL, 0, 0),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_0),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, BPF_PSEUDO_KFUNC_CALL, 0, 0),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, BPF_PSEUDO_KFUNC_CALL, 0, 0),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
+	.fixup_kfunc_btf_id = {
+		{ "bpf_kfunc_call_test_acquire", 3 },
+		{ "bpf_kfunc_call_test_ref", 8 },
+		{ "bpf_kfunc_call_test_release", 10 },
+	},
+	.result_unpriv = REJECT,
+	.result = ACCEPT,
+},
 {
 	"calls: basic sanity",
 	.insns = {
-- 
2.34.1


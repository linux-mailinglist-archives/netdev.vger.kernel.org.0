Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8C1F57A0AE
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 16:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238750AbiGSOI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 10:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238383AbiGSOIH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 10:08:07 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A6402674;
        Tue, 19 Jul 2022 06:24:47 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id x91so19592220ede.1;
        Tue, 19 Jul 2022 06:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oJaG/VmMic1gA0kUbrF0F+FR+0HnyQc1s91sPztb7fQ=;
        b=WktfzFGX407JcjfDXdcPVGBPMvPbfFhDzNjFJkaU2SBP3qEksvGXsBN/2y0xv9I512
         KR1EZKIZ9uK2fsylA5JrlgTNgOkl8oPmu9c4DaPo6pNDXyjmbslE3oBFzjE1SAKOINT3
         Dg3/VsmWN3Wgxy8drAAYZ4rXZrg/IGjrHDDBGhBQVOOxUCH7xVM+0Jf2hQV1YoidEc0y
         1rx724WXvr7r3rH27saI3QN0cQ3+eHWPlWuNUijEkYtlmw2MURhSHuD96P9ZHlQdmyV1
         yrviP9jZ9GBc0Jfle0gLYN3RZBgmgG95v3gs74OhGlI3izGZfHSgeiAGG5Kb+X3/QGe/
         IJzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oJaG/VmMic1gA0kUbrF0F+FR+0HnyQc1s91sPztb7fQ=;
        b=AuTqkhAwvr7fX6NjPio4bmVmrt2NO3ZW/E61H74FIOcwkzVOvllIvQRVBGGy4FwaLO
         kxdDMkRqDyRI5EA87gmKCpKejllneBygz1prjXbRw+lOKpi2k5Gzt0M1gsYy07Y15Rhv
         5bs3ZAaVz5qD0yIZzNPUXzcGQICjKaOK1zCw5vY82osMttSz8JOxWDjr69Igk2bRq49F
         OF7z7ij6627NWGk0FfnYUbePYfl9EzFxqcJ/5LQ9h+imoQsL7FJN2CvQbFOpzRWDEUuY
         /1ObJNuSny9Cc6T2TdRvTswLBlpZUovxLhMxcnBo3VnvGu7QotF2Ski3tJZvxm6o7peP
         OnlQ==
X-Gm-Message-State: AJIora+cIt9bcKaG35oP31hWXO7gFdmKtp4NbVlXWCKqSoOR8aWnfn7y
        IhR0PRPjWPA4uM2AAK/m9hY2pqdRUiQdNg==
X-Google-Smtp-Source: AGRyM1sToVsgm2nNntLyA+aDBDeS6BuQOJZnggJsPhw/VUtR1XP1FIygcadGgOd3KUO746TZsstERg==
X-Received: by 2002:a05:6402:4410:b0:434:f35f:132e with SMTP id y16-20020a056402441000b00434f35f132emr43775183eda.215.1658237085693;
        Tue, 19 Jul 2022 06:24:45 -0700 (PDT)
Received: from localhost (icdhcp-1-189.epfl.ch. [128.178.116.189])
        by smtp.gmail.com with ESMTPSA id z13-20020aa7d40d000000b0043adc6552d6sm10407786edq.20.2022.07.19.06.24.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 06:24:45 -0700 (PDT)
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
Subject: [PATCH bpf-next v6 10/13] selftests/bpf: Add verifier tests for trusted kfunc args
Date:   Tue, 19 Jul 2022 15:24:27 +0200
Message-Id: <20220719132430.19993-11-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220719132430.19993-1-memxor@gmail.com>
References: <20220719132430.19993-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2710; i=memxor@gmail.com; h=from:subject; bh=05K1J2eUnBt0cSOtFvj14bJImp6Ksy5W7PBDUKEJ/4E=; b=owEBbQKS/ZANAwAKAUzgyIZIvxHKAcsmYgBi1rBlQhxV3hTsuPzBv5/b1ieDZMj7Ixd2Z2WfCkrl jHhQzxKJAjMEAAEKAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYtawZQAKCRBM4MiGSL8Ryr7NEA CmxUReK+k5KmwKBB3h0wjGXUVLrMviUljbiTk3o4rLs1E1oolX7B9ur6WUPyi2E5fEZ7YXd7lR6r3k WU0BrZJukorYmXSE1Lx1lLsvklRb8rFoU4PaOQcpd8UlBXIxRk+yP7+xOsG1phtQKrtcNyimBbDV0C SGQfVMEL5DEfdgCg/Dzwte+VpxPPwn30TsAF/Z145qprzR8y98LfI8gkHO94ipmSimhE96MZtmotR9 3d2MYdFd/FlgrK+dqy0Jed4asxac8ezRqY819D2TAYycsZh6tg014ciH2qmqcmSPD02YdI3Rt0YshT 1Coh59ZQl1es5RNedHefx754hiyc+egs0BElulYp8BRf433OL8145v+cTtJaTp3G4f9yvIpkZjEvQP HCQlfOZSNEoTEAm4kpOJjn++7ZGYjmLAWPmomNCSQHpgvl8/7CY0/nv1OJNu+eVvDsbCRB5U27Ro7X NlqYkowSt2gsQ2twAJbjYxrFs1tKfrwB+87AaOQktLRD7sHBDI5EnXAtYj1xZA/eD+qpvzkWNFUAG3 v5TmAp9r65XTJpZnaPA3qs/oonR6QwpCuZGHdgPC3G6nWsLptD0zX5kBHlYskmPlrm729qfXTpp+oL 6ObCVr1SoRtzRpwh+otQc8j6E8LWtpjCtWcSvZIVFm3Dh3xbrLWdgzy8UW8g==
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


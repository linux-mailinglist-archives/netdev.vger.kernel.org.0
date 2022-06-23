Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFDCC55892B
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 21:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbiFWTjB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 15:39:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231139AbiFWTij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 15:38:39 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5675525C52;
        Thu, 23 Jun 2022 12:27:16 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id c4so94626plc.8;
        Thu, 23 Jun 2022 12:27:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rTdBog/fVFVehsGVVg5MRfeHgkRypizQwrV37IOZOC0=;
        b=LH961ZVaZ+4TpGICrA0Ysm2sOIh2aB/w9DkZzYS3J1s1PoomPTcK/xur8rjraxeLr7
         ip3pLJKGZv0Y7PkOINkmF9Z5JIiAX1cMrerrDYAcsJi8noEBi7RXMLNTTjSvw7qE4O7H
         Sh1kQ2NHJYTzgRfowgjpuakl1e9rpb8hlXPRnYUZtBfFdImAgckVf/9tWVUySiy0RhmA
         I4L5TkCEizDKvngKqAavK6hyj6tWJN5P5dOpLD4C3yaLaJaC0asDmDN3Ft856H5GuXnB
         TDJ+bxfPilmdoq1DJr4H5hujW5BIY0XCPyM6C4kvEQGZ7ExMZMm24zIr9QL4peCTvl9f
         DJpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rTdBog/fVFVehsGVVg5MRfeHgkRypizQwrV37IOZOC0=;
        b=6zBvtywxtxLdYmL7fEFVDxTAwuvv5ltjSiVAvbqyso5VGpeUsIDFuV2FJK1udkf0sT
         NkuRF6iNumDV9R1VK35VCxBoxW456klVe1xw6CuTBDPRkYzAYxffNnM4qRFh0TQZkZ+k
         dYsFCMVVzkBofTlWcRiR8hLjLMk0nmP5ngvkWe5ldJ+AFfwFvOPfsWgYa4sEq2mcnAPe
         nM9JeezSvRVPGnyhqsW9krZ0WYSGzf6luBrzXvNeZI7EKyBYrbEBfifzhBR/RfpwTJak
         TmpDeSjmyqAfzBR4EP0hQsI/ILddKQmNFG20yJ3K0E+zTu/1UEKnxzpHgzkj9InaPdi0
         l/HA==
X-Gm-Message-State: AJIora+uWe+uLorUZPtH+q9PraGRpfPfsQiR0R5V7VHp29boZcgUsK2N
        0/4/eoqddPKC1uyp0OO7eVoEF/cpbmcHpw==
X-Google-Smtp-Source: AGRyM1v9UAyXk9cXUO1Pqi1LYbOWNTg46tyFDoePSSOKj7onXnCp+gJzwXewi3pZVZdzF8gAb5d9Fw==
X-Received: by 2002:a17:90a:5e0e:b0:1ec:aa3f:8dc1 with SMTP id w14-20020a17090a5e0e00b001ecaa3f8dc1mr5438166pjf.145.1656012435754;
        Thu, 23 Jun 2022 12:27:15 -0700 (PDT)
Received: from localhost ([2405:201:6014:d0c0:79de:f3f4:353c:8616])
        by smtp.gmail.com with ESMTPSA id a20-20020a621a14000000b005251bea0d53sm13600pfa.83.2022.06.23.12.27.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 12:27:15 -0700 (PDT)
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
Subject: [PATCH bpf-next v5 6/8] selftests/bpf: Add verifier tests for forced kfunc ref args
Date:   Fri, 24 Jun 2022 00:56:35 +0530
Message-Id: <20220623192637.3866852-7-memxor@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623192637.3866852-1-memxor@gmail.com>
References: <20220623192637.3866852-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2710; h=from:subject; bh=KTldfN2HxtfUAqDwOHNrh3Yr2EfzeShwwjvJTjpRhqk=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBitL5MjDBcoslWjE16JopPpwfWHBhS2it21L/4BeYr akvSp0OJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYrS+TAAKCRBM4MiGSL8RyvNBD/ oCfvnkB15/EP+Pgg6ojn5xklwM3LCuksnfxCU9g5cw26iOrJJRT/Smi3JOFIqlp76t6SCRwcx4h2tO QArDBNix4fSZ5/zCNDmmKZ3w/IPE/XzUxDHFKDFkBPK75gRVF9cn8tJJa+DiXqrvSwcCDJ7XWW4mNC NvD/5IrOfafdru+Jn6Bj+hvOUAADrLXRrYT9vaGZr9AapHjgC5XXHRV9gCirR4U44M6N9DbKysVIGr 3/d94dvD67WhRhicqUR0EIv3ITt44fwWOlzhumyfFLYDhIHv/knH3q6bg7AE+/HHedSXjTWT3SZfCe cKovIvMbQty/RoXMmzlefjA0jME29aYBAqlbY1xAhOGrEzsxQR8ZK7IDQwGa/ORSPIwuyBczFP9Sod B4ynm5zXnGYolYtyDXdPfFznzdafe4CcG6lq1okB+Sp7K0Xw6/fCnkpc1Ch6Rwjn39izNgfQXhvLGD dtLQvGmZg3aEklw/nwDP2qWpvxEs75P9AjSGq2lgun7Q7NfH2YcURat7/PlN82xMeMdH+UVIRc8Nmo 0zOfxynoW49TjLO2MrIJYD9kvGefwF854EQc0a9RbEZpTvOIGLkojxoGCC269wsKKROpEAVWdctE6A +S5M74D0XbH1kX6XqSQGZ489fRJS9EjBzvOsMu/xk3XUyumHZi76XdZfYcjg==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
2.36.1


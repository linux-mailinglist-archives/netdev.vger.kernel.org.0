Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE0B152FD97
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 17:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244817AbiEUPNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 11:13:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241662AbiEUPNp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 11:13:45 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBFDF554A3;
        Sat, 21 May 2022 08:13:44 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id h13so3757862pfq.5;
        Sat, 21 May 2022 08:13:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LbhcB3YHNqKynKttP0KjjWCMDlfixCXwusmnm/NYx0A=;
        b=KZ4hcy/La625YXR2kT4LQSvC7ofjEGGn5R4OCf5Azd5fYGSckwqppA+N8sjZwRDlPz
         hHx5AVMjdevHD56FYnsc5wWQD0Vg9TlriYnTHuH0bEdah4m/Gi+tGMxRPlHY2GEezS6L
         p0eW8UMzmsSo9XSdZYrcc6GJKaIntSuhbcuFyL2dAQsv3W4uMubRb+LjKZQ8mbLGjnV6
         yo2K+R7Dlr2oEfxTlkS/gUeLq2BdO7bt3WR1xbFzBfM90oWi2Yz6yfsvPYnNrIKj+8ZW
         4mr9btjVlU7ESodu/qqBzTsiU3Q9bdtxCXok0O+iTlIZj7kK+zujPk5RTb9TSZ/7/px1
         eHeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LbhcB3YHNqKynKttP0KjjWCMDlfixCXwusmnm/NYx0A=;
        b=XJbWqB0PY3mMNN9TpwGc0JIl7P9TcWnNZ/E0Y43GsDzV2HnLDfCAA8u+U73MKsblRm
         Zqk5anRYgHrEdtWOVJNo1jOFj57FxOz773HnuaMrA3AexjFp4InyOZOYpEbuA7MaOv0Z
         pScmpBwuN3TEgmK/CMYfws4pc4TcTP9L5s4SaUf8Bf4auFUchZGNLjJeqsDaGGN2/jTh
         bpRm6+4nRmS7B7zDio9TM9LKQEv/PJ5hVLkhA52GnpKR7C4hwVSG3albCb1yYGL6IN8e
         +FSM85x02HUB2rFN455RlEvGnSC+0vmo4Dxblpqn7UZtlqC8MDGCR/w7e/UgduAmN12z
         dW2g==
X-Gm-Message-State: AOAM531HEcLDXvwvRwX3ZzjD6/UIdowY6rh/khiWiTpGiuwBzEtwz2KN
        aRT2aLzcaRSqdFfYTiqA3yQ=
X-Google-Smtp-Source: ABdhPJz28g5r6L61tgSyG/mhNaBfJU55V1hDA6V2h6Yza2rVPm1FKMGPwK/4Znn6kewASDCoiRJGPA==
X-Received: by 2002:a63:5d10:0:b0:3c5:e836:ffd2 with SMTP id r16-20020a635d10000000b003c5e836ffd2mr13173642pgb.32.1653146024229;
        Sat, 21 May 2022 08:13:44 -0700 (PDT)
Received: from localhost.localdomain ([223.212.58.71])
        by smtp.gmail.com with ESMTPSA id d17-20020a170903209100b0015e8e7db067sm1749565plc.4.2022.05.21.08.13.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 May 2022 08:13:43 -0700 (PDT)
From:   Yuntao Wang <ytcoode@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yuntao Wang <ytcoode@gmail.com>
Subject: [PATCH bpf-next] selftests/bpf: Fix test_run logic in fexit_stress.c
Date:   Sat, 21 May 2022 23:13:29 +0800
Message-Id: <20220521151329.648013-1-ytcoode@gmail.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
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

In the commit da00d2f117a0 ("bpf: Add test ops for BPF_PROG_TYPE_TRACING"),
the bpf_fentry_test1 function was moved into bpf_prog_test_run_tracing(),
which is the test_run function of the tracing BPF programs.

Thus calling 'bpf_prog_test_run_opts(filter_fd, &topts)' will not trigger
bpf_fentry_test1 function as filter_fd is a sk_filter BPF program.

Fix it by replacing filter_fd with fexit_fd in the bpf_prog_test_run_opts()
function.

Fixes: da00d2f117a0 ("bpf: Add test ops for BPF_PROG_TYPE_TRACING")
Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
---
 .../selftests/bpf/prog_tests/fexit_stress.c   | 32 +++----------------
 1 file changed, 4 insertions(+), 28 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/fexit_stress.c b/tools/testing/selftests/bpf/prog_tests/fexit_stress.c
index a7e74297f15f..5a7e6011f6bf 100644
--- a/tools/testing/selftests/bpf/prog_tests/fexit_stress.c
+++ b/tools/testing/selftests/bpf/prog_tests/fexit_stress.c
@@ -7,11 +7,9 @@
 
 void serial_test_fexit_stress(void)
 {
-	char test_skb[128] = {};
 	int fexit_fd[CNT] = {};
 	int link_fd[CNT] = {};
-	char error[4096];
-	int err, i, filter_fd;
+	int err, i;
 
 	const struct bpf_insn trace_program[] = {
 		BPF_MOV64_IMM(BPF_REG_0, 0),
@@ -20,25 +18,9 @@ void serial_test_fexit_stress(void)
 
 	LIBBPF_OPTS(bpf_prog_load_opts, trace_opts,
 		.expected_attach_type = BPF_TRACE_FEXIT,
-		.log_buf = error,
-		.log_size = sizeof(error),
 	);
 
-	const struct bpf_insn skb_program[] = {
-		BPF_MOV64_IMM(BPF_REG_0, 0),
-		BPF_EXIT_INSN(),
-	};
-
-	LIBBPF_OPTS(bpf_prog_load_opts, skb_opts,
-		.log_buf = error,
-		.log_size = sizeof(error),
-	);
-
-	LIBBPF_OPTS(bpf_test_run_opts, topts,
-		.data_in = test_skb,
-		.data_size_in = sizeof(test_skb),
-		.repeat = 1,
-	);
+	LIBBPF_OPTS(bpf_test_run_opts, topts);
 
 	err = libbpf_find_vmlinux_btf_id("bpf_fentry_test1",
 					 trace_opts.expected_attach_type);
@@ -58,15 +40,9 @@ void serial_test_fexit_stress(void)
 			goto out;
 	}
 
-	filter_fd = bpf_prog_load(BPF_PROG_TYPE_SOCKET_FILTER, NULL, "GPL",
-				  skb_program, sizeof(skb_program) / sizeof(struct bpf_insn),
-				  &skb_opts);
-	if (!ASSERT_GE(filter_fd, 0, "test_program_loaded"))
-		goto out;
+	err = bpf_prog_test_run_opts(fexit_fd[0], &topts);
+	ASSERT_OK(err, "bpf_prog_test_run_opts");
 
-	err = bpf_prog_test_run_opts(filter_fd, &topts);
-	close(filter_fd);
-	CHECK_FAIL(err);
 out:
 	for (i = 0; i < CNT; i++) {
 		if (link_fd[i])
-- 
2.36.1


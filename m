Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78FD34DAFA9
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 13:27:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355689AbiCPM0i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 08:26:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355685AbiCPM0a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 08:26:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 547B04D9D1;
        Wed, 16 Mar 2022 05:25:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07F81B81A79;
        Wed, 16 Mar 2022 12:25:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7093AC340E9;
        Wed, 16 Mar 2022 12:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647433511;
        bh=1VtKvNS32Uyyjrtz0RgYiCNNkAcpWfsJmRROWcx7eLU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NpCoI/nH9se+UJHpP6DsKdrrvFn3UTE9ISi+6Ikejpofff1rDIgkygROo7gJsS8Fh
         +879CxOxcFV6HpGFzRCAr36mn51O05nkatxcHiQVHj21vqTWbe5ypDRzcoaskBcR0r
         ZilJ7vnGVbsZPzSgDn6ppd2WMCerAJyx0OJD3auG+9anHwgHK7giW4clKb3OoDhODW
         ++2lklc2xcqwF3eQyNJLxJEqfAHijnmHaOlrcwNUjwpDp9cYgzr9GFo4mY4ENOePIk
         0+CI+UBt/uSFdgvbCg/KthgSpxxvwD7YwaIixi3glDudahH+HEvt9BgjoU3CX/dKO2
         QHNaJBBSPOH4Q==
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCHv3 bpf-next 04/13] bpf: Add bpf_get_func_ip kprobe helper for multi kprobe link
Date:   Wed, 16 Mar 2022 13:24:10 +0100
Message-Id: <20220316122419.933957-5-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220316122419.933957-1-jolsa@kernel.org>
References: <20220316122419.933957-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding support to call bpf_get_func_ip helper from kprobe
programs attached by multi kprobe link.

Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/trace/bpf_trace.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index fffa2171fae4..250750932228 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1037,6 +1037,18 @@ static const struct bpf_func_proto bpf_get_func_ip_proto_kprobe = {
 	.arg1_type	= ARG_PTR_TO_CTX,
 };
 
+BPF_CALL_1(bpf_get_func_ip_kprobe_multi, struct pt_regs *, regs)
+{
+	return instruction_pointer(regs);
+}
+
+static const struct bpf_func_proto bpf_get_func_ip_proto_kprobe_multi = {
+	.func		= bpf_get_func_ip_kprobe_multi,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_CTX,
+};
+
 BPF_CALL_1(bpf_get_attach_cookie_trace, void *, ctx)
 {
 	struct bpf_trace_run_ctx *run_ctx;
@@ -1280,7 +1292,9 @@ kprobe_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_override_return_proto;
 #endif
 	case BPF_FUNC_get_func_ip:
-		return &bpf_get_func_ip_proto_kprobe;
+		return prog->expected_attach_type == BPF_TRACE_KPROBE_MULTI ?
+			&bpf_get_func_ip_proto_kprobe_multi :
+			&bpf_get_func_ip_proto_kprobe;
 	case BPF_FUNC_get_attach_cookie:
 		return &bpf_get_attach_cookie_proto_trace;
 	default:
-- 
2.35.1


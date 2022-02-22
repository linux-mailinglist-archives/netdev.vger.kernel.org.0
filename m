Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3CB04BFFB0
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 18:07:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234529AbiBVRHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 12:07:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234539AbiBVRHV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 12:07:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CC0E5FE9;
        Tue, 22 Feb 2022 09:06:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A14761275;
        Tue, 22 Feb 2022 17:06:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97465C340E8;
        Tue, 22 Feb 2022 17:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645549611;
        bh=p5PicBOIuVA+SoWxZQRqV4TOwd/YJ2sG+ZPpG5D+684=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OdsWzxzJx2xkyGyAmYZTmZ38Reg/3AiKowy5ly4yX0yJr7Cq8G3elHagDPWyGAJJL
         y+ZPhGuhJ+T3tItIbE/IJtBXso/4rxm1f0mYLJ+VLApKsKeqtjDTKsCowOo0ZY8pty
         r3vrsTsnX2iR5MwUxUxguH7rO3QkiXxf1CpxAjnlnpH3UNKp7AizTD7LoBYXGcmaEr
         hJyKlrfB9b2LqcWPH5EnK1HylpFCejlSr0n/qjK/z3LtKJ+9T6ByQQhOampXFMwbWp
         x1ianJ7B27x+dm9Z5S7W9CYoJCpFi0RfcM98Y5YA+ryNRN3t3MqkAzDmNef7hzOHV3
         /TrXOfaO+S/LQ==
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
Subject: [PATCH 03/10] bpf: Add bpf_get_func_ip kprobe helper for multi kprobe link
Date:   Tue, 22 Feb 2022 18:05:53 +0100
Message-Id: <20220222170600.611515-4-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220222170600.611515-1-jolsa@kernel.org>
References: <20220222170600.611515-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/trace/bpf_trace.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index df3771bfd6e5..64891b7b0885 100644
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


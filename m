Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7E964BFFBD
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 18:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234564AbiBVRIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 12:08:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234573AbiBVRIS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 12:08:18 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6EE965795;
        Tue, 22 Feb 2022 09:07:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 55986CE13B8;
        Tue, 22 Feb 2022 17:07:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F5A7C340E8;
        Tue, 22 Feb 2022 17:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645549662;
        bh=fhc+sE0bQphu+0+3eMvHc0aupFbhQC00veXlE3qmN9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sK8S8oMDQBBikKCVCz066nSXb9LuPrYuTR5wcmFfqQeuAwAqZB+4XN+gTFJIROa0x
         tDaVSiiRa3YFgjkfXjDvu6mWfNDEnU4en0nTvL2GpaSET9fynsc9llElVBx4FSE+yH
         Q9QC98NekX1ACIJn9YIHPgUJL1TdvgOgwRDExjo9WZr5rrdMv6ueBBGm+rmh+BQdaP
         lQlOtXOIjjUbj9RXjZ9B+6hfiE+fhTKsxY0q/w5o5OkqFWgyQTclq4XX7E/duGrTGe
         7Cj5n4ivnKUjtBP04GuZsoRyTCpHudlfvESAIFOJm9GQbPuq5NGIF1ZEXUTEJpnyqs
         1I9rjEdWHUFGg==
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
Subject: [PATCH 07/10] libbpf: Add bpf_link_create support for multi kprobes
Date:   Tue, 22 Feb 2022 18:05:57 +0100
Message-Id: <20220222170600.611515-8-jolsa@kernel.org>
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

Adding new kprobe_multi struct to bpf_link_create_opts object
to pass multiple kprobe data to link_create attr uapi.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/lib/bpf/bpf.c | 7 +++++++
 tools/lib/bpf/bpf.h | 9 ++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 418b259166f8..5e180def2cef 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -853,6 +853,13 @@ int bpf_link_create(int prog_fd, int target_fd,
 		if (!OPTS_ZEROED(opts, perf_event))
 			return libbpf_err(-EINVAL);
 		break;
+	case BPF_TRACE_KPROBE_MULTI:
+		attr.link_create.kprobe_multi.syms = OPTS_GET(opts, kprobe_multi.syms, 0);
+		attr.link_create.kprobe_multi.addrs = OPTS_GET(opts, kprobe_multi.addrs, 0);
+		attr.link_create.kprobe_multi.cookies = OPTS_GET(opts, kprobe_multi.cookies, 0);
+		attr.link_create.kprobe_multi.cnt = OPTS_GET(opts, kprobe_multi.cnt, 0);
+		attr.link_create.kprobe_multi.flags = OPTS_GET(opts, kprobe_multi.flags, 0);
+		break;
 	default:
 		if (!OPTS_ZEROED(opts, flags))
 			return libbpf_err(-EINVAL);
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 16b21757b8bf..bd285a8f3420 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -413,10 +413,17 @@ struct bpf_link_create_opts {
 		struct {
 			__u64 bpf_cookie;
 		} perf_event;
+		struct {
+			__u64 syms;
+			__u64 addrs;
+			__u64 cookies;
+			__u32 cnt;
+			__u32 flags;
+		} kprobe_multi;
 	};
 	size_t :0;
 };
-#define bpf_link_create_opts__last_field perf_event
+#define bpf_link_create_opts__last_field kprobe_multi.flags
 
 LIBBPF_API int bpf_link_create(int prog_fd, int target_fd,
 			       enum bpf_attach_type attach_type,
-- 
2.35.1


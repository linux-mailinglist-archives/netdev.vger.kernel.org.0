Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 873584DAFAF
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 13:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355730AbiCPM1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 08:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355731AbiCPM1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 08:27:15 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B2966229;
        Wed, 16 Mar 2022 05:26:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 38510CE1EE0;
        Wed, 16 Mar 2022 12:25:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5DDFC340E9;
        Wed, 16 Mar 2022 12:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647433557;
        bh=7F7TJvtKCCF1Hs+It/UzXoEWVpmuxrzcP3Tpga7WQMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CfIkXcorWfuWyFHxYNMmr+6RDFcqdbT/kxZoo0qgPrZCi//yjYt4BBNN0Z+FsHpN1
         nDBq6+83EYR4oD5AjDy45ZL2eFT7+EJDjxNbJhWTaqs7Ln7/SWS6bkEzc14EA1bKoX
         dbfGaSULn/gIw8DTsn0xvc1ewbwBOXoJU+PvGfQKBYcTxwLAJrugGHKgqn0zMPz5+v
         7hO6fp8LAFWx/qHaYLDKRbEDjxyD//1iPwqEtaHOFE9pv48mkiN4M9J0pawBADbsw1
         peHmscsp/c4cjHWwDDXsNjYfV2fDS4dieMmzdrDbIJKNEBANtx1TTNFrmSHX3z03xN
         6F8nm2iRFRMyw==
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
Subject: [PATCHv3 bpf-next 08/13] libbpf: Add bpf_link_create support for multi kprobes
Date:   Wed, 16 Mar 2022 13:24:14 +0100
Message-Id: <20220316122419.933957-9-jolsa@kernel.org>
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

Adding new kprobe_multi struct to bpf_link_create_opts object
to pass multiple kprobe data to link_create attr uapi.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/lib/bpf/bpf.c | 9 +++++++++
 tools/lib/bpf/bpf.h | 9 ++++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index f69ce3a01385..cf27251adb92 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -854,6 +854,15 @@ int bpf_link_create(int prog_fd, int target_fd,
 		if (!OPTS_ZEROED(opts, perf_event))
 			return libbpf_err(-EINVAL);
 		break;
+	case BPF_TRACE_KPROBE_MULTI:
+		attr.link_create.kprobe_multi.flags = OPTS_GET(opts, kprobe_multi.flags, 0);
+		attr.link_create.kprobe_multi.cnt = OPTS_GET(opts, kprobe_multi.cnt, 0);
+		attr.link_create.kprobe_multi.syms = ptr_to_u64(OPTS_GET(opts, kprobe_multi.syms, 0));
+		attr.link_create.kprobe_multi.addrs = ptr_to_u64(OPTS_GET(opts, kprobe_multi.addrs, 0));
+		attr.link_create.kprobe_multi.cookies = ptr_to_u64(OPTS_GET(opts, kprobe_multi.cookies, 0));
+		if (!OPTS_ZEROED(opts, kprobe_multi))
+			return libbpf_err(-EINVAL);
+		break;
 	default:
 		if (!OPTS_ZEROED(opts, flags))
 			return libbpf_err(-EINVAL);
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 5253cb4a4c0a..f4b4afb6d4ba 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -413,10 +413,17 @@ struct bpf_link_create_opts {
 		struct {
 			__u64 bpf_cookie;
 		} perf_event;
+		struct {
+			__u32 flags;
+			__u32 cnt;
+			const char **syms;
+			const unsigned long *addrs;
+			const __u64 *cookies;
+		} kprobe_multi;
 	};
 	size_t :0;
 };
-#define bpf_link_create_opts__last_field perf_event
+#define bpf_link_create_opts__last_field kprobe_multi.cookies
 
 LIBBPF_API int bpf_link_create(int prog_fd, int target_fd,
 			       enum bpf_attach_type attach_type,
-- 
2.35.1


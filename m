Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C493150A9CC
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 22:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392184AbiDUUO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 16:14:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232946AbiDUUO0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 16:14:26 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8FCC5F79
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 13:11:35 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id y23-20020a62b517000000b004fd8affa86aso3562148pfe.12
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 13:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=xl86mN30osJz9axtr4HGKyAY6n8mDzLbZshrFbw38w0=;
        b=gFkWCHa0kM5FoJwOLehhGiuzSVMGJFSP6kpu5y/jfku9ja7w/KaVHxwr7SiVN7dhFO
         TXcrvIApr+h5KMnT2X5rpNveSJ6aHKpjUvDM3w79BsZcM2ru/CGt14N3SsqsaYPgjt/e
         CZJdiFv/XNMSBdAvQMT3hisULGE/bSJbkU+TCDUV+yWaEl1yotxLjNG0psnSxzUAZq5V
         uufSROGLvdW6S9kxg8WdJdZwW+jaKUJ7nGD0pDRdz7J/uhOiiOznfNi5OkTLPxdEYA55
         gxWqgGgIPlT2kwSvHimP3dM8Y1cDh09Qm5Q7FUH6xOg02fuLdsIhmDoS5twaC/e8fq42
         yyPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=xl86mN30osJz9axtr4HGKyAY6n8mDzLbZshrFbw38w0=;
        b=kBea0W+GIMVa7UMaboYOTBJSrmZs1o+6qyQlUnd9sIhErzE8hmeVqrY64nGC4bI620
         vxP4Bj4jqyydLOgrtfrrvF0Hd2fWEtHz2XwEMaPCcBP4D5hJaG6EhqC7ZPjQfUfM+8pT
         LIBdzoW9ZucnSPbs617+B8ZaT3qp2mGuoQxi9j0VqxgR18REKrJzhuEdRWj9qH/jdf3B
         i3rRGrQnzEHOONLI2xxqmsPVyQC70jjzrt2jMwbEnD8D4fubP05nowWhEA6nxlmBxXrz
         abMCUdKZ51nkCii27X/mnOV2wkGEkUo0JbWlxmYKYSN7BXJ+rxq3rWkK43sCg1VBnlf7
         Oy/A==
X-Gm-Message-State: AOAM531BmWwuRfbkcdizoFN2ByqphsKNP1k5DW6sRzl7882AA5skO39m
        TKPclRSDE5cCSl8uNxYNSRm55bHf28tY
X-Google-Smtp-Source: ABdhPJxyvpg4HtUlA89af+J7Dme3WMKLPbKVtxgtzLdRK7v4TUf4kWl54uuECS4cN+EmT6zJ1xdxlQoD39xX
X-Received: from connoro.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:a99])
 (user=connoro job=sendgmr) by 2002:a17:902:f605:b0:14d:9e11:c864 with SMTP id
 n5-20020a170902f60500b0014d9e11c864mr1097012plg.54.1650571895188; Thu, 21 Apr
 2022 13:11:35 -0700 (PDT)
Date:   Thu, 21 Apr 2022 20:11:25 +0000
Message-Id: <20220421201125.13907-1-connoro@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH bpf-next] libbpf: also check /sys/kernel/tracing for tracefs files
From:   "Connor O'Brien" <connoro@google.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Connor O'Brien" <connoro@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

libbpf looks for tracefs files only under debugfs, but tracefs may be
mounted even if debugfs is not. When /sys/kernel/debug/tracing is
absent, try looking under /sys/kernel/tracing instead.

Signed-off-by: Connor O'Brien <connoro@google.com>
---
 tools/lib/bpf/libbpf.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 68cc134d070d..6ef587329eb2 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -10140,10 +10140,16 @@ static void gen_kprobe_legacy_event_name(char *buf, size_t buf_sz,
 		 __sync_fetch_and_add(&index, 1));
 }
 
+static bool debugfs_available(void)
+{
+	return !access("/sys/kernel/debug/tracing", F_OK);
+}
+
 static int add_kprobe_event_legacy(const char *probe_name, bool retprobe,
 				   const char *kfunc_name, size_t offset)
 {
-	const char *file = "/sys/kernel/debug/tracing/kprobe_events";
+	const char *file = debugfs_available() ? "/sys/kernel/debug/tracing/kprobe_events" :
+		"/sys/kernel/tracing/kprobe_events";
 
 	return append_to_file(file, "%c:%s/%s %s+0x%zx",
 			      retprobe ? 'r' : 'p',
@@ -10153,7 +10159,8 @@ static int add_kprobe_event_legacy(const char *probe_name, bool retprobe,
 
 static int remove_kprobe_event_legacy(const char *probe_name, bool retprobe)
 {
-	const char *file = "/sys/kernel/debug/tracing/kprobe_events";
+	const char *file = debugfs_available() ? "/sys/kernel/debug/tracing/kprobe_events" :
+		"/sys/kernel/tracing/kprobe_events";
 
 	return append_to_file(file, "-:%s/%s", retprobe ? "kretprobes" : "kprobes", probe_name);
 }
@@ -10163,7 +10170,8 @@ static int determine_kprobe_perf_type_legacy(const char *probe_name, bool retpro
 	char file[256];
 
 	snprintf(file, sizeof(file),
-		 "/sys/kernel/debug/tracing/events/%s/%s/id",
+		 debugfs_available() ? "/sys/kernel/debug/tracing/events/%s/%s/id" :
+		 "/sys/kernel/tracing/events/%s/%s/id",
 		 retprobe ? "kretprobes" : "kprobes", probe_name);
 
 	return parse_uint_from_file(file, "%d\n");
@@ -10493,7 +10501,8 @@ static void gen_uprobe_legacy_event_name(char *buf, size_t buf_sz,
 static inline int add_uprobe_event_legacy(const char *probe_name, bool retprobe,
 					  const char *binary_path, size_t offset)
 {
-	const char *file = "/sys/kernel/debug/tracing/uprobe_events";
+	const char *file = debugfs_available() ? "/sys/kernel/debug/tracing/uprobe_events" :
+		"/sys/kernel/tracing/uprobe_events";
 
 	return append_to_file(file, "%c:%s/%s %s:0x%zx",
 			      retprobe ? 'r' : 'p',
@@ -10503,7 +10512,8 @@ static inline int add_uprobe_event_legacy(const char *probe_name, bool retprobe,
 
 static inline int remove_uprobe_event_legacy(const char *probe_name, bool retprobe)
 {
-	const char *file = "/sys/kernel/debug/tracing/uprobe_events";
+	const char *file = debugfs_available() ? "/sys/kernel/debug/tracing/uprobe_events" :
+		"/sys/kernel/tracing/uprobe_events";
 
 	return append_to_file(file, "-:%s/%s", retprobe ? "uretprobes" : "uprobes", probe_name);
 }
@@ -10513,7 +10523,8 @@ static int determine_uprobe_perf_type_legacy(const char *probe_name, bool retpro
 	char file[512];
 
 	snprintf(file, sizeof(file),
-		 "/sys/kernel/debug/tracing/events/%s/%s/id",
+		 debugfs_available() ? "/sys/kernel/debug/tracing/events/%s/%s/id" :
+		 "/sys/kernel/tracing/events/%s/%s/id",
 		 retprobe ? "uretprobes" : "uprobes", probe_name);
 
 	return parse_uint_from_file(file, "%d\n");
@@ -11071,7 +11082,8 @@ static int determine_tracepoint_id(const char *tp_category,
 	int ret;
 
 	ret = snprintf(file, sizeof(file),
-		       "/sys/kernel/debug/tracing/events/%s/%s/id",
+		       debugfs_available() ? "/sys/kernel/debug/tracing/events/%s/%s/id" :
+		       "/sys/kernel/tracing/events/%s/%s/id",
 		       tp_category, tp_name);
 	if (ret < 0)
 		return -errno;
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0340666AFAB
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 08:18:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbjAOHSB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 02:18:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbjAOHQz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 02:16:55 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4407FCDE2;
        Sat, 14 Jan 2023 23:16:42 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id q64so26310982pjq.4;
        Sat, 14 Jan 2023 23:16:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0fmkqPUWv3S5ReG8IilYKGmgBx5rYCR8nInPLJsrUdA=;
        b=JckQO82bMaW8AJrI+vTWUAL9lZhEC4wxvZXMRVmnkGdG8M8ReExIaHLtVGHq8OmBFj
         RcyOu8uCUgWi8SMAmV6Xkp8/NlsqFJ39hI63fKEp3AMLTIpcS1Te9mEIJ6BpMFv49S1y
         HwO/uVIAw7h+Xr+9eOfjRYbVAeTmecS6eeC8JCC7sQxEJtCW3+ehkhQXVWT3rOKA4yiq
         waRx+zRreaeI2uDF068Xe2Giz0kOx6bjANWYgZzOy0buFxAlvbwED7JATDY22JQYWuy8
         OygjQhx9MBWHD7871tic2eSlu7LoXDuYCEnpTlfU0R/EhU/8IUlqF7JYsHFtVKr1we01
         m41g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0fmkqPUWv3S5ReG8IilYKGmgBx5rYCR8nInPLJsrUdA=;
        b=wsPgwAnAvVymIBfqb++hu/J6I/dZulm3z7GId+t1niL+6ejWIPc7lwHn/nf79CF2nH
         6+mHTzXU6v2toWeOIZlzvOamiPVos0QQULN01DkbFeBhj+WeTL5EDPY06BG18DoD72sV
         t2SBmQLlT83enzKV2egjgtQhl9RyGorcfaP1Ag1hul+QUmMajqhEj9AW32RVmtict4db
         DOl7L5CvPQjSvFgShVZMYsXHSvB3Phxu6ttWvO94d5P73g6HNGgzMPjJfENB6Qsxm/Bh
         1cX2dBA90mcSpk6lFosVHKTCDa+jXvNEDcAdkbyJdD9P+F4/L2FUp0IwuLKiLN1S7ZvP
         jx7A==
X-Gm-Message-State: AFqh2koEMkEOYcjQ60U3kPu7NUt2lC1QTbLdgYoLfMAJp5Mg8PIJpBQ8
        LC/Jk87E6wV+LdK5uDUNswJd7rdW8SAGSf8=
X-Google-Smtp-Source: AMrXdXsYxrj9wnq3uEG9mh9To8xNgk2FIcPF6nBG4DffLGDUaAdzZgQsUjwDGa9lnErgWosKKmCegg==
X-Received: by 2002:a05:6a20:2a98:b0:b8:66d3:30b8 with SMTP id v24-20020a056a202a9800b000b866d330b8mr1799168pzh.20.1673767001751;
        Sat, 14 Jan 2023 23:16:41 -0800 (PST)
Received: from WDIR.. ([182.209.58.25])
        by smtp.gmail.com with ESMTPSA id z13-20020aa7990d000000b0058a313f4e4esm10272796pff.149.2023.01.14.23.16.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Jan 2023 23:16:41 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [bpf-next 06/10] samples/bpf: replace legacy map with the BTF-defined map
Date:   Sun, 15 Jan 2023 16:16:09 +0900
Message-Id: <20230115071613.125791-7-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230115071613.125791-1-danieltimlee@gmail.com>
References: <20230115071613.125791-1-danieltimlee@gmail.com>
MIME-Version: 1.0
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

With libbpf 1.0 release, support for legacy BPF map declaration syntax
had been dropped. If you run a program using legacy BPF in the latest
libbpf, the following error will be output.

    libbpf: map 'lwt_len_hist_map' (legacy): legacy map definitions are deprecated, use BTF-defined maps instead
    libbpf: Use of BPF_ANNOTATE_KV_PAIR is deprecated, use BTF-defined maps in .maps section instead

This commit replaces legacy map with the BTF-defined map.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/bpf/lwt_len_hist_kern.c  | 24 +++++++-----------------
 samples/bpf/test_cgrp2_tc_kern.c | 25 +++++++------------------
 2 files changed, 14 insertions(+), 35 deletions(-)

diff --git a/samples/bpf/lwt_len_hist_kern.c b/samples/bpf/lwt_len_hist_kern.c
index 1fa14c54963a..44ea7b56760e 100644
--- a/samples/bpf/lwt_len_hist_kern.c
+++ b/samples/bpf/lwt_len_hist_kern.c
@@ -16,23 +16,13 @@
 #include <uapi/linux/in.h>
 #include <bpf/bpf_helpers.h>
 
-struct bpf_elf_map {
-	__u32 type;
-	__u32 size_key;
-	__u32 size_value;
-	__u32 max_elem;
-	__u32 flags;
-	__u32 id;
-	__u32 pinning;
-};
-
-struct bpf_elf_map SEC("maps") lwt_len_hist_map = {
-	.type = BPF_MAP_TYPE_PERCPU_HASH,
-	.size_key = sizeof(__u64),
-	.size_value = sizeof(__u64),
-	.pinning = 2,
-	.max_elem = 1024,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_HASH);
+	__type(key, u64);
+	__type(value, u64);
+	__uint(pinning, LIBBPF_PIN_BY_NAME);
+	__uint(max_entries, 1024);
+} lwt_len_hist_map SEC(".maps");
 
 static unsigned int log2(unsigned int v)
 {
diff --git a/samples/bpf/test_cgrp2_tc_kern.c b/samples/bpf/test_cgrp2_tc_kern.c
index 4dd532a312b9..737ce3eb8944 100644
--- a/samples/bpf/test_cgrp2_tc_kern.c
+++ b/samples/bpf/test_cgrp2_tc_kern.c
@@ -19,24 +19,13 @@ struct eth_hdr {
 	unsigned short  h_proto;
 };
 
-#define PIN_GLOBAL_NS		2
-struct bpf_elf_map {
-	__u32 type;
-	__u32 size_key;
-	__u32 size_value;
-	__u32 max_elem;
-	__u32 flags;
-	__u32 id;
-	__u32 pinning;
-};
-
-struct bpf_elf_map SEC("maps") test_cgrp2_array_pin = {
-	.type		= BPF_MAP_TYPE_CGROUP_ARRAY,
-	.size_key	= sizeof(uint32_t),
-	.size_value	= sizeof(uint32_t),
-	.pinning	= PIN_GLOBAL_NS,
-	.max_elem	= 1,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_CGROUP_ARRAY);
+	__type(key, u32);
+	__type(value, u32);
+	__uint(pinning, LIBBPF_PIN_BY_NAME);
+	__uint(max_entries, 1);
+} test_cgrp2_array_pin SEC(".maps");
 
 SEC("filter")
 int handle_egress(struct __sk_buff *skb)
-- 
2.34.1


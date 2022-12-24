Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42A456558D4
	for <lists+netdev@lfdr.de>; Sat, 24 Dec 2022 08:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbiLXHPn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Dec 2022 02:15:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbiLXHPl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Dec 2022 02:15:41 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AD8B10048;
        Fri, 23 Dec 2022 23:15:40 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id u15-20020a17090a3fcf00b002191825cf02so6761420pjm.2;
        Fri, 23 Dec 2022 23:15:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XwZeuqk4CHrbQ3Wjbdmra5o77wm0nPLeqHrABP97XAY=;
        b=bt2AQnE8vjO0hClbz4duSXyIhTempWvd5MoHivKJwx8EyE50RWpEnVFUmce4FynvyM
         hp5hAqNZc8zHkmFjrANfgpr/XyoK2KL7dFDLcUhUpmXfdFaAjN28zZfaBa5wdX9XwUju
         kMjxw7/pcpd2+aCMoV6EXq5wI/ldGhUSwdpAXxsqWivywq3DzfPKhw+BU72tNllhkCnA
         DQJmhdni51cYy2596S0/Sa82Ocap954XzTLywNHJlMH+oHCcbG/H747+5xRvwBGpr/2A
         RD8zRdJn6Gp1ZqIQ0NsKd6mwBYvAT49sqDkreB8ld5eYDL2YjJyd7qT9oEzf+216mGQv
         0G/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XwZeuqk4CHrbQ3Wjbdmra5o77wm0nPLeqHrABP97XAY=;
        b=ytdQg4y1dndgcpwRfGgTJqhoYx2V062o1pcTNPAyEJgqXQdtzZ/pp4so5bxJZPSbmK
         8H7QYcSEVTbv9dKPMUdDcHeyaChl54pSIZzs4s0LsJ3MSftKE686WSkyyDKAWpW6d9tw
         5roUtrGV5VFnIFA1PFyi1+kCs0StJCgMHlt/Q6ha04m+WkT62NU4bYy1KMC0FdRUlH0c
         DV9+RnfU00cATZHG2O3QPZN1Pqed8+y201r8G9e399l78SxJu1BXlWW1CnaUwkwlMjUs
         knrDDmQyOH64gahSbgKyvIHjX6Eansqd3QFQ0EPE6JPre0bd5IOnu1eo9kxuwQ9Hll1o
         xcRw==
X-Gm-Message-State: AFqh2kpu1bK2N78+k3WywT9B6+C/i2KE3DkMFB0nnW4nBOwOxRyIBct9
        uQ3qENPaqMD6QmtLlkiSJg==
X-Google-Smtp-Source: AMrXdXuxRzTJUdPrJ/5rvozuGJf6xtUKw9ciVHgqumK5TGmJhZVWml9DoZBOo8QAC9Ed6c2XjaW3iA==
X-Received: by 2002:a17:903:1305:b0:189:d025:aa23 with SMTP id iy5-20020a170903130500b00189d025aa23mr12660954plb.53.1671866140064;
        Fri, 23 Dec 2022 23:15:40 -0800 (PST)
Received: from WDIR.. ([182.209.58.25])
        by smtp.gmail.com with ESMTPSA id bf4-20020a170902b90400b00186b7443082sm3433222plb.195.2022.12.23.23.15.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Dec 2022 23:15:39 -0800 (PST)
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
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [bpf-next v3 2/6] samples/bpf: use vmlinux.h instead of implicit headers in syscall tracing program
Date:   Sat, 24 Dec 2022 16:15:23 +0900
Message-Id: <20221224071527.2292-3-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221224071527.2292-1-danieltimlee@gmail.com>
References: <20221224071527.2292-1-danieltimlee@gmail.com>
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

This commit applies vmlinux.h to syscall tracing program. This change
allows the bpf program to refer to the internal structure as a single
"vmlinux.h" instead of including each header referenced by the bpf
program.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/bpf/map_perf_test_kern.c                  | 5 ++---
 samples/bpf/test_current_task_under_cgroup_kern.c | 4 +---
 samples/bpf/test_probe_write_user_kern.c          | 5 ++---
 samples/bpf/trace_output_kern.c                   | 3 +--
 samples/bpf/tracex2_kern.c                        | 4 +---
 5 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/samples/bpf/map_perf_test_kern.c b/samples/bpf/map_perf_test_kern.c
index 874e2f7e3d5d..0c7885057ffe 100644
--- a/samples/bpf/map_perf_test_kern.c
+++ b/samples/bpf/map_perf_test_kern.c
@@ -4,10 +4,9 @@
  * modify it under the terms of version 2 of the GNU General Public
  * License as published by the Free Software Foundation.
  */
-#include <linux/skbuff.h>
-#include <linux/netdevice.h>
+#include "vmlinux.h"
+#include <errno.h>
 #include <linux/version.h>
-#include <uapi/linux/bpf.h>
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
 #include <bpf/bpf_core_read.h>
diff --git a/samples/bpf/test_current_task_under_cgroup_kern.c b/samples/bpf/test_current_task_under_cgroup_kern.c
index 541fc861b984..0b059cee3cba 100644
--- a/samples/bpf/test_current_task_under_cgroup_kern.c
+++ b/samples/bpf/test_current_task_under_cgroup_kern.c
@@ -5,11 +5,9 @@
  * License as published by the Free Software Foundation.
  */
 
-#include <linux/ptrace.h>
-#include <uapi/linux/bpf.h>
+#include "vmlinux.h"
 #include <linux/version.h>
 #include <bpf/bpf_helpers.h>
-#include <uapi/linux/utsname.h>
 
 struct {
 	__uint(type, BPF_MAP_TYPE_CGROUP_ARRAY);
diff --git a/samples/bpf/test_probe_write_user_kern.c b/samples/bpf/test_probe_write_user_kern.c
index d60cabaaf753..a0f10c5ca273 100644
--- a/samples/bpf/test_probe_write_user_kern.c
+++ b/samples/bpf/test_probe_write_user_kern.c
@@ -4,9 +4,8 @@
  * modify it under the terms of version 2 of the GNU General Public
  * License as published by the Free Software Foundation.
  */
-#include <linux/skbuff.h>
-#include <linux/netdevice.h>
-#include <uapi/linux/bpf.h>
+#include "vmlinux.h"
+#include <string.h>
 #include <linux/version.h>
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
diff --git a/samples/bpf/trace_output_kern.c b/samples/bpf/trace_output_kern.c
index a481abf8c4c5..565a73b51b04 100644
--- a/samples/bpf/trace_output_kern.c
+++ b/samples/bpf/trace_output_kern.c
@@ -1,6 +1,5 @@
-#include <linux/ptrace.h>
+#include "vmlinux.h"
 #include <linux/version.h>
-#include <uapi/linux/bpf.h>
 #include <bpf/bpf_helpers.h>
 
 struct {
diff --git a/samples/bpf/tracex2_kern.c b/samples/bpf/tracex2_kern.c
index ecdca9620ece..4b9d956a3e2c 100644
--- a/samples/bpf/tracex2_kern.c
+++ b/samples/bpf/tracex2_kern.c
@@ -4,10 +4,8 @@
  * modify it under the terms of version 2 of the GNU General Public
  * License as published by the Free Software Foundation.
  */
-#include <linux/skbuff.h>
-#include <linux/netdevice.h>
+#include "vmlinux.h"
 #include <linux/version.h>
-#include <uapi/linux/bpf.h>
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
 
-- 
2.34.1


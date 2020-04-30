Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 519021BFE03
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 16:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728303AbgD3OYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 10:24:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728095AbgD3OY1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 10:24:27 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64248C08E934
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 07:24:27 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id v6so6621421qkd.9
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 07:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=eiWqfc49ogrYbZ/4/xuGkLOd4BeleFiuwlczI7sArlo=;
        b=KXWVO5D3T7Fomi7k+CxkMwTCRn/Gm7qkS3cSTZgrk+kGvtu1xoviEaLbD0Ok51qIQT
         +K4bHuqIx+5Kk+213YFGQwJ+Kbc4UHVZKhR/Ha5p14s0NafCwnlyN4rad0O6WhgXCocK
         YoZwxqxyoqERo2uQjbtswlTvdAvG/G8KXRNYcrs/MnatY9lQ3P7L4q4tgrk2suGCIj2v
         Mk7rUxhqzS42uvRRIZUxTr8F4KDECyHDS0s483Ls1deEvTMNB8nZGDyrMECHMbrKieLS
         y2xv/taGYsuvY+hN0tMVqkpbh69h1T+ylpvlQA5UoxPDLT1GtGNn9eRSe0OX/LQnefUx
         4zKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=eiWqfc49ogrYbZ/4/xuGkLOd4BeleFiuwlczI7sArlo=;
        b=GVCNYjfpGNu7l/bSAPXxzjSKfLUd5bWzX2bOR+o6NcnxYXYA8feTQbux5avsg4Uh3F
         O03Tll6oNYExXc0esduVyu8ignO9PdUpdILvA6t9U26SE1mTHiKegh3OhzjZjjWpSdAA
         u9+LLzf6ri2HfNrtiuF+BMDXDp1mRP4/BknPTkCSbRR9/wGCtn2tEZVb3Kpisr/ZYjbX
         vDlkrUWALcYp17vOYk9WsOmurgIKG5hYC0hLpZ7G7nPCu321cptwe51X+po3SCMBRDoV
         /anfSasYwjLYxGPnVXhGACKkIElBq9OwqDCTaKaS13dalAHpS4AiBhEp+mLyST04U41/
         nOMw==
X-Gm-Message-State: AGi0PuZFTXNdVqORGHEBgIAnovPgLqdbLbhgn9k8znBWuE0fyQGCTbZa
        htE84agVyGL7/FlzsOWOKe1vZ5q6+AC5
X-Google-Smtp-Source: APiQypJbyuOjdXxvUcI406eMztVyGKYyj6BDRAqVBS2mQxU0HaWiDh+IEUfbY7Ffn3DVN1Ok4X1CvrJwBQEY
X-Received: by 2002:a0c:a692:: with SMTP id t18mr3256841qva.56.1588256666426;
 Thu, 30 Apr 2020 07:24:26 -0700 (PDT)
Date:   Thu, 30 Apr 2020 07:24:17 -0700
In-Reply-To: <20200430142419.252180-1-irogers@google.com>
Message-Id: <20200430142419.252180-3-irogers@google.com>
Mime-Version: 1.0
References: <20200430142419.252180-1-irogers@google.com>
X-Mailer: git-send-email 2.26.2.303.gf8c07b1a785-goog
Subject: [PATCH v13 2/4] tools feature: add support for detecting libpfm4
From:   Ian Rogers <irogers@google.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Igor Lubashev <ilubashe@akamai.com>,
        Alexey Budankov <alexey.budankov@linux.intel.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Jiwei Sun <jiwei.sun@windriver.com>,
        yuzhoujian <yuzhoujian@didichuxing.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Leo Yan <leo.yan@linaro.org>,
        John Garry <john.garry@huawei.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-perf-users@vger.kernel.org
Cc:     Stephane Eranian <eranian@google.com>,
        Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

libpfm4 provides an alternate command line encoding of perf events.

Signed-off-by: Stephane Eranian <eranian@google.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
 tools/build/Makefile.feature       | 3 ++-
 tools/build/feature/Makefile       | 6 +++++-
 tools/build/feature/test-libpfm4.c | 9 +++++++++
 3 files changed, 16 insertions(+), 2 deletions(-)
 create mode 100644 tools/build/feature/test-libpfm4.c

diff --git a/tools/build/Makefile.feature b/tools/build/Makefile.feature
index 3e0c019ef297..3abd4316cd4f 100644
--- a/tools/build/Makefile.feature
+++ b/tools/build/Makefile.feature
@@ -98,7 +98,8 @@ FEATURE_TESTS_EXTRA :=                  \
          llvm                           \
          llvm-version                   \
          clang                          \
-         libbpf
+         libbpf                         \
+         libpfm4
 
 FEATURE_TESTS ?= $(FEATURE_TESTS_BASIC)
 
diff --git a/tools/build/feature/Makefile b/tools/build/feature/Makefile
index 92012381393a..84f845b9627d 100644
--- a/tools/build/feature/Makefile
+++ b/tools/build/feature/Makefile
@@ -69,7 +69,8 @@ FILES=                                          \
          test-libaio.bin			\
          test-libzstd.bin			\
          test-clang-bpf-global-var.bin		\
-         test-file-handle.bin
+         test-file-handle.bin			\
+         test-libpfm4.bin
 
 FILES := $(addprefix $(OUTPUT),$(FILES))
 
@@ -331,6 +332,9 @@ $(OUTPUT)test-clang-bpf-global-var.bin:
 $(OUTPUT)test-file-handle.bin:
 	$(BUILD)
 
+$(OUTPUT)test-libpfm4.bin:
+	$(BUILD) -lpfm
+
 ###############################
 
 clean:
diff --git a/tools/build/feature/test-libpfm4.c b/tools/build/feature/test-libpfm4.c
new file mode 100644
index 000000000000..af49b259459e
--- /dev/null
+++ b/tools/build/feature/test-libpfm4.c
@@ -0,0 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <sys/types.h>
+#include <perfmon/pfmlib.h>
+
+int main(void)
+{
+	pfm_initialize();
+	return 0;
+}
-- 
2.26.2.303.gf8c07b1a785-goog


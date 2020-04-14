Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DBBA1A88C1
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 20:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503474AbgDNSMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 14:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2503479AbgDNSLF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 14:11:05 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B677C061BD3
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 11:11:04 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id d11so14164201pjh.4
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 11:11:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=R8mSLoA4yKGeDKyGJ46zmAHwFa4kk4RkB3OQPR7SZNk=;
        b=soPE3YbSyYsetKYuTK1j8cBgfL1ufL/chbR0V1Nlr/KGFsEhqXTx37PrP+FQqZ0VYS
         NctD2fvmwY0Mz0T3Tcm3+G7nBpf9rZrXjJUeST7ysZvyAr/mrERTRZWTCT2/0UIRi5/Z
         q3KMJmhn4tEpliFy/lSZC8i7J7aWbJfQN21+4ZFDhmKviV5dV+ltPNrogtJFbmI87/hL
         dh42b3mlezccKwMiD+jM5ivV64HZ+tLkq/7I3cFlXr6jqHlMyidiBdgzeBrS9/3wb9yA
         VoQgrEmq7kcUFtWJiiCr5r+X2ChTmphrOZS/2BOjmBmPijYVLcQ4/ngHh9BbhtWWjdSe
         cODQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=R8mSLoA4yKGeDKyGJ46zmAHwFa4kk4RkB3OQPR7SZNk=;
        b=YCKexYBkdY8HTNeDWyql3+sHLz4xx4nLmCSjb7R38jR6+WB3OM7o9sN0Axb0tbw4FP
         lqz8a7D4VEko9BS9zeCje+fP7pNN2ZXKU9Q8pYyhtV2zT5duUCfDTOgB0rZKaagvmsSn
         dxqF4Veg3OtKRK4tqj/TsMD/Kk4EJSXNz/0dGJg5Y2sdDCA+4lWOt+nOzIlBF7G9+iXM
         y4vGYziUHcOuXEO+FA/l5jPCrcusFoUXxh/Ch8knwDY6T6INzoMRHmT3tTBVVX8Dn90e
         P29RTTQS/8ZSHIPp+Lk0NAw0V9GWNCqQQ/umykCnBLDqqvEOR2ScJHWf1bUGcBv1ErTo
         P/tw==
X-Gm-Message-State: AGi0PuZhUc9nPRDlsx61FDvRt+sXlk3vaBy7Lg1/8055ad7zKQCdsUR+
        /NT47PAcuxMGfoGYDRRUi8M59tkbum37
X-Google-Smtp-Source: APiQypKS42oeOJ/EEIPZ1vIkACtXeNF9CLv/+ToiDrm8HpPrn9vyCpP3q9r8jnr+W/V+4FlFShEz/09JUiYJ
X-Received: by 2002:a17:90a:14c6:: with SMTP id k64mr1503515pja.39.1586887863831;
 Tue, 14 Apr 2020 11:11:03 -0700 (PDT)
Date:   Tue, 14 Apr 2020 11:10:52 -0700
In-Reply-To: <20200414181054.22435-1-irogers@google.com>
Message-Id: <20200414181054.22435-3-irogers@google.com>
Mime-Version: 1.0
References: <20200414181054.22435-1-irogers@google.com>
X-Mailer: git-send-email 2.26.0.110.g2183baf09c-goog
Subject: [PATCH v9 2/4] tools feature: add support for detecting libpfm4
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
index 621f528f7822..a6eded94a36b 100644
--- a/tools/build/feature/Makefile
+++ b/tools/build/feature/Makefile
@@ -68,7 +68,8 @@ FILES=                                          \
          test-llvm-version.bin			\
          test-libaio.bin			\
          test-libzstd.bin			\
-         test-file-handle.bin
+         test-file-handle.bin			\
+         test-libpfm4.bin
 
 FILES := $(addprefix $(OUTPUT),$(FILES))
 
@@ -325,6 +326,9 @@ $(OUTPUT)test-libzstd.bin:
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
2.26.0.110.g2183baf09c-goog


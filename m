Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B43AC1AD2AF
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 00:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729280AbgDPWPO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 18:15:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729255AbgDPWPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 18:15:12 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B05C0C061A0F
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 15:15:10 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id w12so193313qto.19
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 15:15:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=i6zi1rxo51fT0gF/9bIKSou9eRtAcSwwYlA8EKV06Zo=;
        b=SrGxGy8s4ytPw4timT44/yvzlyEckdI3kUPwh456UpVj+LH7jd6GHSbiMnnJ0MMkCK
         x3Gakjw88HjZMraj2upA2jKbx/ISFXBxkkeB27X00Y1lETyNKLH8mYCC6R47lGkLqK8H
         vaGoRx5tBFnwy99b1MwAMkT6YLcectvICoCWacgNsja+p9ctvAjpwOAAesNLUmJX7taD
         WcQY7D6bc60UFTOr8KFamArKB2FJCWlZnpwhXlNAYWuT7NCCSIw1ggP+LNTKo1sMV/eV
         NpbDezVvXmlEYFQuDLR6W3vLBIcb10wxLruXG5CwXfAYZUs+8GwYN5flnTWlTfh0/pkS
         Okvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=i6zi1rxo51fT0gF/9bIKSou9eRtAcSwwYlA8EKV06Zo=;
        b=hKykIJzoCvlQfW9961gNoQ2xI8BneQV08wEghTEKk5PfXjM1K6dnNr3sdfzqFydfF8
         QHmi6q1nRgaF9PwxpGMOCrCJ9agP35aPhXu29anrOVirNDQ41eDEychAP8HrN/WhvCt9
         TAqUkgo5TbES+wVVh/vkQP/S6sw9pPpok6INPrwsXsMmisHQOlrU4dReByPZ7n50SO4n
         bKOgTMv0qWeUDe1ERnKh0Tu0uyGqZ5EqfSd4KxvgHkEz0ZuEcpp8rvgjlrmTaUZsh6dQ
         uogsbnJnc7BpD/Emz9rm28V2oei4UmAd9fvHFW+tZwnS/0i5FO6cp923qaHIUqoOVEB0
         WSpA==
X-Gm-Message-State: AGi0PuYpDrRI3ilurHSJK2OhXeMK/yRpRW7XtubNYY2vAeCLdLZNl++t
        DA7WCsTBZDOVWLx0Vyb2zpph665+xXWj
X-Google-Smtp-Source: APiQypLk4PUpjzE7K8jVUtavsUcybhrkLlxmuvUCKxRqtRx63IfICXBx4LOCUTvKNzrUFxmZzcER8r+wwzh6
X-Received: by 2002:a05:6214:1248:: with SMTP id q8mr12436429qvv.66.1587075309771;
 Thu, 16 Apr 2020 15:15:09 -0700 (PDT)
Date:   Thu, 16 Apr 2020 15:14:55 -0700
In-Reply-To: <20200416221457.46710-1-irogers@google.com>
Message-Id: <20200416221457.46710-3-irogers@google.com>
Mime-Version: 1.0
References: <20200416221457.46710-1-irogers@google.com>
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
Subject: [PATCH v11 2/4] tools feature: add support for detecting libpfm4
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
2.26.1.301.g55bc3eb7cb9-goog


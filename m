Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1F3B877C3
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 12:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbfHIKsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 06:48:10 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42083 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbfHIKsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 06:48:10 -0400
Received: by mail-pf1-f195.google.com with SMTP id q10so45838318pff.9
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 03:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=SWSgHhHu/9BjvEKvg6DvYw5jthq0QCStuXD5Y25D++k=;
        b=olBzn9Iae3J+Se9iHRoHNcpUalAkm0ZD09Av8Rhf0Un1Erb82ltsMGyfBJNHsDpsio
         LlbQvDyOt9ixqafHrC8B30eZNQFydT4ALlqO+PDtaXDqR4t+msvvRbMRJA9mlCGEu1hk
         OWPdIUoClXdonkrlZl0wMf7etys7/V0IUfhh6KzMsReQc8ryg6G4ekAD7BMSlJ7V2qmU
         erp/KwrNpRh1Rsx4z65y13/nqjod+Jpum23/PTaXvdW+hSPFj9YiD2+AqR4K2BRVzNSd
         eap5YaVNNKHXwu78ZyVTVLyxgl5j7Dke93bjTNx2H5SEjKGaVOV9aCWV5DhSzXE2AMVB
         pBMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=SWSgHhHu/9BjvEKvg6DvYw5jthq0QCStuXD5Y25D++k=;
        b=eJBiRigWnJvCYgZ2ZUcAoqpe9MvJNRJZiE2Ses2j04f2D8xluV2SGdX00WyEM0yqam
         qMkvHYjKhGEQos8/W5YCfTredMIUi4geQfwIc8af4PrhUsPgFM1kocKqdajFah9pGcv+
         ygM0qSGUgoux9pjXZZOUR8GDD59T4kp5kgGlT861iwbYPDTH+7+uurhlx5LlP+sZpHQb
         sXnu7wd3sTLHb6p2Tol3CwStn6RfzmhyHs7dEv07SzwcuLuyXJh/MEOqEjPNWWV5+pdL
         fEKBgDiVySl3x69JNBWi8/5dt9zlCLHFAGJgep8qyE5OU2kW1vjb3k1KjwaLZ5YPRF14
         BDjw==
X-Gm-Message-State: APjAAAXJFARO994H3R/Au5eJGW1h59Haaw5ECeLtQzhDNG0Dx3uiU8kX
        93L2e3KhMZG5OsPTzYIZ9lL2zA==
X-Google-Smtp-Source: APXvYqxgJ7LJSyfYIqCUqyw0nl4BRa1wS+HCiJ9jJJusPxs6KdjJu0Q2m1OI1WoKhxp7olOZNBxCag==
X-Received: by 2002:aa7:82da:: with SMTP id f26mr20912390pfn.82.1565347689544;
        Fri, 09 Aug 2019 03:48:09 -0700 (PDT)
Received: from localhost.localdomain (li456-16.members.linode.com. [50.116.10.16])
        by smtp.gmail.com with ESMTPSA id l44sm4651449pje.29.2019.08.09.03.48.05
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 09 Aug 2019 03:48:08 -0700 (PDT)
From:   Leo Yan <leo.yan@linaro.org>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     Leo Yan <leo.yan@linaro.org>
Subject: [PATCH] perf trace: Fix segmentation fault when access syscall info
Date:   Fri,  9 Aug 2019 18:47:52 +0800
Message-Id: <20190809104752.27338-1-leo.yan@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'perf trace' reports the segmentation fault as below on Arm64:

  # perf trace -e string -e augmented_raw_syscalls.c
  LLVM: dumping tools/perf/examples/bpf/augmented_raw_syscalls.o
  perf: Segmentation fault
  Obtained 12 stack frames.
  perf(sighandler_dump_stack+0x47) [0xaaaaac96ac87]
  linux-vdso.so.1(+0x5b7) [0xffffadbeb5b7]
  /lib/aarch64-linux-gnu/libc.so.6(strlen+0x10) [0xfffface7d5d0]
  /lib/aarch64-linux-gnu/libc.so.6(_IO_vfprintf+0x1ac7) [0xfffface49f97]
  /lib/aarch64-linux-gnu/libc.so.6(__vsnprintf_chk+0xc7) [0xffffacedfbe7]
  perf(scnprintf+0x97) [0xaaaaac9ca3ff]
  perf(+0x997bb) [0xaaaaac8e37bb]
  perf(cmd_trace+0x28e7) [0xaaaaac8ec09f]
  perf(+0xd4a13) [0xaaaaac91ea13]
  perf(main+0x62f) [0xaaaaac8a147f]
  /lib/aarch64-linux-gnu/libc.so.6(__libc_start_main+0xe3) [0xfffface22d23]
  perf(+0x57723) [0xaaaaac8a1723]
  Segmentation fault

This issue is introduced by commit 30a910d7d3e0 ("perf trace:
Preallocate the syscall table"), it allocates trace->syscalls.table[]
array and the element count is 'trace->sctbl->syscalls.nr_entries';
but on Arm64, the system call number is not continuously used; e.g. the
syscall maximum id is 436 but the real entries is only 281.  So the
table is allocated with 'nr_entries' as the element count, but it
accesses the table with the syscall id, which might be out of the bound
of the array and cause the segmentation fault.

This patch allocates trace->syscalls.table[] with the element count is
'trace->sctbl->syscalls.max_id + 1', this allows any id to access the
table without out of the bound.

Fixes: 30a910d7d3e0 ("perf trace: Preallocate the syscall table")
Signed-off-by: Leo Yan <leo.yan@linaro.org>
---
 tools/perf/builtin-trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 75eb3811e942..d553d06a9aeb 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1492,7 +1492,7 @@ static int trace__read_syscall_info(struct trace *trace, int id)
 	const char *name = syscalltbl__name(trace->sctbl, id);
 
 	if (trace->syscalls.table == NULL) {
-		trace->syscalls.table = calloc(trace->sctbl->syscalls.nr_entries, sizeof(*sc));
+		trace->syscalls.table = calloc(trace->sctbl->syscalls.max_id + 1, sizeof(*sc));
 		if (trace->syscalls.table == NULL)
 			return -ENOMEM;
 	}
-- 
2.17.1


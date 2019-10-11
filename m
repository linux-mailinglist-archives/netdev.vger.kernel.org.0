Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35A4AD4900
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 22:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729314AbfJKUHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 16:07:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:43848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729055AbfJKUHs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Oct 2019 16:07:48 -0400
Received: from quaco.ghostprotocols.net (189-94-137-67.3g.claro.net.br [189.94.137.67])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57FDC2196E;
        Fri, 11 Oct 2019 20:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570824467;
        bh=zduB2sJcKOz0TDgbMM1Vx+VolWWgz6xXIgdx6oi4Okk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jr397YbLOzCQmd+fjJU17h+jfwUGBgOResoDBHfI+1d97rLH6RsfoMNEiSRMpnpvz
         EGQ6Cir9KVVTbe/IUOihmCOESgtKB/1cc/+4Txl6MEOAcV4OWM+asZLXo/yOHOX5jx
         RKGPyvEOSgpioAiMTbZxBdOLo7pgLiqNxhVFu16A=
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Clark Williams <williams@redhat.com>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Song Liu <songliubraving@fb.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 15/69] perf tools: Make usage of test_attr__* optional for perf-sys.h
Date:   Fri, 11 Oct 2019 17:05:05 -0300
Message-Id: <20191011200559.7156-16-acme@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191011200559.7156-1-acme@kernel.org>
References: <20191011200559.7156-1-acme@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

For users of perf-sys.h outside perf, e.g. samples/bpf/bpf_load.c, it's
convenient not to depend on test_attr__*.

After commit 91854f9a077e ("perf tools: Move everything related to
sys_perf_event_open() to perf-sys.h"), all users of perf-sys.h will
depend on test_attr__enabled and test_attr__open.

This commit enables a user to define HAVE_ATTR_TEST to zero in order
to omit the test dependency.

Fixes: 91854f9a077e ("perf tools: Move everything related to sys_perf_event_open() to perf-sys.h")
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
Acked-by: Song Liu <songliubraving@fb.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: bpf@vger.kernel.org
Cc: netdev@vger.kernel.org
Link: http://lore.kernel.org/lkml/20191001113307.27796-2-bjorn.topel@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/perf-sys.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/perf-sys.h b/tools/perf/perf-sys.h
index 63e4349a772a..15e458e150bd 100644
--- a/tools/perf/perf-sys.h
+++ b/tools/perf/perf-sys.h
@@ -15,7 +15,9 @@ void test_attr__init(void);
 void test_attr__open(struct perf_event_attr *attr, pid_t pid, int cpu,
 		     int fd, int group_fd, unsigned long flags);
 
-#define HAVE_ATTR_TEST
+#ifndef HAVE_ATTR_TEST
+#define HAVE_ATTR_TEST 1
+#endif
 
 static inline int
 sys_perf_event_open(struct perf_event_attr *attr,
@@ -27,7 +29,7 @@ sys_perf_event_open(struct perf_event_attr *attr,
 	fd = syscall(__NR_perf_event_open, attr, pid, cpu,
 		     group_fd, flags);
 
-#ifdef HAVE_ATTR_TEST
+#if HAVE_ATTR_TEST
 	if (unlikely(test_attr__enabled))
 		test_attr__open(attr, pid, cpu, fd, group_fd, flags);
 #endif
-- 
2.21.0


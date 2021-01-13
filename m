Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4C92F57AC
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 04:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729392AbhANCEU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 21:04:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729384AbhAMWg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 17:36:58 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03A9EC061786
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 14:36:17 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id z20so2325755pgh.18
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 14:36:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=RvmtRhkONMmfhKRRv0A/mu12QKo6Pw33tPGzPMsnY7U=;
        b=eNg+TgZVgGKOKdnt+s9s+B/MNQiswvTMCwgmo8Ii3RPSXI63/n0z2lZa0uLfn6edAe
         CqelYSNlg/KPvUyYhf+1H/U2Ulf9zF+gH256Rntm3+MEw48hdJACm34mL+qcU+1QgjSn
         YBhqF6hrnorqu+sZO3j380PcokaYnk0LzyiFjAUBJyuhyOvdf0DCMwsyjKOJ2wMgNroG
         f8AJqhwiK5daTSrJdQskC2X+vFNAX78I7MABZIYr6BguQ6hN/u8GeUpaw4C+v7kWNO1x
         ayhVFWgdpJdPlDacSn3uevpU+Qdpduf0rkz1PDStxciqbonDSVJPOoyXwRVrGRN9xz87
         tg3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=RvmtRhkONMmfhKRRv0A/mu12QKo6Pw33tPGzPMsnY7U=;
        b=M/Gxj69/4u69TCwF3aTaqtED9lMB88WQrd5qSpqmwQZhUhjpKlAE5dVQYO255+5HSu
         0Gsu0HtpU7OSVOoG0XpNfNrJbOKkQXXV0/Z09+MM7l5EjIOLvor+3KX4zSth2Arz/IoQ
         +o24wYlqUs1h/sfIsu1qHAw1jW/EoSXXysGolsMCsaUuDH0G4xd7/tG9LxFK8fQVCZIx
         mUas+w1cGoRZB6HaOPsf6VVNZXwT2veI5MMr/QYmlaiyj37R0XUpzO0t/yHqwSv3Wa4J
         9sw3D9Xpzmxachy3Ik0VwwHIJ+0tQnaurVhrRFyKHMt9LWEs4tngaUnheDWlC4IWphyM
         sfOA==
X-Gm-Message-State: AOAM531FY5L57TylSHAUGqtZN0609F+06PYaDPAZmbACR5R04M5HLg59
        excTdqq/XAwe2+VRkVXk3HymLqF7Wuk7
X-Google-Smtp-Source: ABdhPJxuT5GN8uIB0Yk80LlDAp87gi4fAKPUBt19+DQuoK0Q2qZEJ//A/7To9qS2YuaQflTY45diDpaAilnm
Sender: "irogers via sendgmr" <irogers@irogers.svl.corp.google.com>
X-Received: from irogers.svl.corp.google.com ([2620:15c:2cd:2:f693:9fff:fef4:4583])
 (user=irogers job=sendgmr) by 2002:a17:902:12c:b029:da:e63c:dc92 with SMTP id
 41-20020a170902012cb02900dae63cdc92mr4528156plb.71.1610577376422; Wed, 13 Jan
 2021 14:36:16 -0800 (PST)
Date:   Wed, 13 Jan 2021 14:36:08 -0800
Message-Id: <20210113223609.3358812-1-irogers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH 1/2] bpf, libbpf: Avoid unused function warning on bpf_tail_call_static
From:   Ian Rogers <irogers@google.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Tobias Klauser <tklauser@distanz.ch>,
        Ilya Leoshkevich <iii@linux.ibm.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add inline to __always_inline making it match the linux/compiler.h.
Adding this avoids an unused function warning on bpf_tail_call_static
when compining with -Wall.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/lib/bpf/bpf_helpers.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
index 72b251110c4d..ae6c975e0b87 100644
--- a/tools/lib/bpf/bpf_helpers.h
+++ b/tools/lib/bpf/bpf_helpers.h
@@ -30,7 +30,7 @@
 #define SEC(NAME) __attribute__((section(NAME), used))
 
 #ifndef __always_inline
-#define __always_inline __attribute__((always_inline))
+#define __always_inline inline __attribute__((always_inline))
 #endif
 #ifndef __noinline
 #define __noinline __attribute__((noinline))
-- 
2.30.0.284.gd98b1dd5eaa7-goog


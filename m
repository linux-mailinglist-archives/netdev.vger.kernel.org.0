Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6EA1D5E64
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 06:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgEPEGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 00:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725275AbgEPEGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 00:06:19 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 525FAC061A0C;
        Fri, 15 May 2020 21:06:19 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id t40so1926772pjb.3;
        Fri, 15 May 2020 21:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sQ9HhbFB9QvY0hAGX3tFVfP5FHUoCH0IDZmIiW0bwUY=;
        b=sUj03xQcQSGqVd2Ud8X82x9+O4WSHfgz47657WDjbuwIaLuRQaOlaNKh0HqILTtVUJ
         YzafWfgSg3nd9qL0jOqXTtkkd8eFlAXS9LQzye5HNJyDdoVVU2gfupo1OqtFDfroyMV1
         ytyNxVQyTi3ICnlrLV3G6tKvbwRcEoufaXojGV2m+0YpSlMlYfdcrc7iw3qPjndX5QFY
         /sleGZ+UxDP5XGFznxPTWEKFEZTJeQZ5l5VGcfweshf3S3qVzgLytZP51zSWWRwVsWIW
         AGO9lyi2odv9Bnw3Vkrfdk8Z+NPBbqNM4TlucBLijgt2G6K5eLPkFOVbDU0dM1pxPUDq
         cXJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sQ9HhbFB9QvY0hAGX3tFVfP5FHUoCH0IDZmIiW0bwUY=;
        b=ftk/+nSPfnIlf2MYKCSKKjLeiIkv+Q9RUoiqVtrGHmnfKH4ZXz7jCBZINN6bNUvumx
         yG3HSacSuSJcauiljT5ZEi5r22y2XHOcf0zHJdXq64OTUpjXOg2zpqfaZP+uBrGvk3/U
         Wubwg/byiVULuNz6tgavtgyqXP41reTyamSMqfYcmH4goDwzUBCwyr2X1uFU511aWcbp
         6zugzB/2DKWhJzefjAcdfY3xV4gcz3wkzI4hm1OrDkd5/obI0P1VTMDTVO2KqEQLA6JQ
         poAbKDTebssc/t6M0VII9MQske2siM18NTaYfhK6+Gp72ZHO8XdLlwVi1OtuNufg2B9f
         rWAA==
X-Gm-Message-State: AOAM531U0Oq2TW9tYeIFzFYed+0kpDwXc0N5W4267UbH5dxfRW3BYiT1
        I8cMpWKDXz/Wx9+eXAIi+w==
X-Google-Smtp-Source: ABdhPJy+/4iX6bC+geeCdYHjpTVUPUHX2/ZfXoWB5tvdU5fjszbjjshXI559Elk/hk/1xmVDKVQVmg==
X-Received: by 2002:a17:90a:68c1:: with SMTP id q1mr6995800pjj.35.1589601978892;
        Fri, 15 May 2020 21:06:18 -0700 (PDT)
Received: from localhost.localdomain ([219.255.158.173])
        by smtp.gmail.com with ESMTPSA id b11sm98663pjz.54.2020.05.15.21.06.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 21:06:18 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>
Subject: [PATCH bpf-next v2 1/5] samples: bpf: refactor pointer error check with libbpf
Date:   Sat, 16 May 2020 13:06:04 +0900
Message-Id: <20200516040608.1377876-2-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200516040608.1377876-1-danieltimlee@gmail.com>
References: <20200516040608.1377876-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current method of checking pointer error is not user friendly.
Especially the __must_check define makes this less intuitive.

Since, libbpf has an API libbpf_get_error() which checks pointer error,
this commit refactors existing pointer error check logic with libbpf.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/bpf/sampleip_user.c         | 7 ++-----
 samples/bpf/trace_event_user.c      | 9 +++------
 samples/bpf/xdp_redirect_cpu_user.c | 5 +----
 3 files changed, 6 insertions(+), 15 deletions(-)

diff --git a/samples/bpf/sampleip_user.c b/samples/bpf/sampleip_user.c
index 4372d2da2f9e..921c505bb567 100644
--- a/samples/bpf/sampleip_user.c
+++ b/samples/bpf/sampleip_user.c
@@ -18,9 +18,6 @@
 #include "perf-sys.h"
 #include "trace_helpers.h"
 
-#define __must_check
-#include <linux/err.h>
-
 #define DEFAULT_FREQ	99
 #define DEFAULT_SECS	5
 #define MAX_IPS		8192
@@ -57,7 +54,7 @@ static int sampling_start(int freq, struct bpf_program *prog,
 			return 1;
 		}
 		links[i] = bpf_program__attach_perf_event(prog, pmu_fd);
-		if (IS_ERR(links[i])) {
+		if (libbpf_get_error(links[i])) {
 			fprintf(stderr, "ERROR: Attach perf event\n");
 			links[i] = NULL;
 			close(pmu_fd);
@@ -182,7 +179,7 @@ int main(int argc, char **argv)
 
 	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
 	obj = bpf_object__open_file(filename, NULL);
-	if (IS_ERR(obj)) {
+	if (libbpf_get_error(obj)) {
 		fprintf(stderr, "ERROR: opening BPF object file failed\n");
 		obj = NULL;
 		goto cleanup;
diff --git a/samples/bpf/trace_event_user.c b/samples/bpf/trace_event_user.c
index b6cd358d0418..ac1ba368195c 100644
--- a/samples/bpf/trace_event_user.c
+++ b/samples/bpf/trace_event_user.c
@@ -16,9 +16,6 @@
 #include "perf-sys.h"
 #include "trace_helpers.h"
 
-#define __must_check
-#include <linux/err.h>
-
 #define SAMPLE_FREQ 50
 
 static int pid;
@@ -159,7 +156,7 @@ static void test_perf_event_all_cpu(struct perf_event_attr *attr)
 			goto all_cpu_err;
 		}
 		links[i] = bpf_program__attach_perf_event(prog, pmu_fd);
-		if (IS_ERR(links[i])) {
+		if (libbpf_get_error(links[i])) {
 			printf("bpf_program__attach_perf_event failed\n");
 			links[i] = NULL;
 			close(pmu_fd);
@@ -198,7 +195,7 @@ static void test_perf_event_task(struct perf_event_attr *attr)
 		goto err;
 	}
 	link = bpf_program__attach_perf_event(prog, pmu_fd);
-	if (IS_ERR(link)) {
+	if (libbpf_get_error(link)) {
 		printf("bpf_program__attach_perf_event failed\n");
 		link = NULL;
 		close(pmu_fd);
@@ -314,7 +311,7 @@ int main(int argc, char **argv)
 	}
 
 	obj = bpf_object__open_file(filename, NULL);
-	if (IS_ERR(obj)) {
+	if (libbpf_get_error(obj)) {
 		printf("opening BPF object file failed\n");
 		obj = NULL;
 		goto cleanup;
diff --git a/samples/bpf/xdp_redirect_cpu_user.c b/samples/bpf/xdp_redirect_cpu_user.c
index 9b8f21abeac4..f3468168982e 100644
--- a/samples/bpf/xdp_redirect_cpu_user.c
+++ b/samples/bpf/xdp_redirect_cpu_user.c
@@ -19,9 +19,6 @@ static const char *__doc__ =
 #include <time.h>
 #include <linux/limits.h>
 
-#define __must_check
-#include <linux/err.h>
-
 #include <arpa/inet.h>
 #include <linux/if_link.h>
 
@@ -622,7 +619,7 @@ static struct bpf_link * attach_tp(struct bpf_object *obj,
 	}
 
 	link = bpf_program__attach_tracepoint(prog, tp_category, tp_name);
-	if (IS_ERR(link))
+	if (libbpf_get_error(link))
 		exit(EXIT_FAIL_BPF);
 
 	return link;
-- 
2.25.1


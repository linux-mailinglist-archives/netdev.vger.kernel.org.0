Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E084550B490
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 12:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446165AbiDVKED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 06:04:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348202AbiDVKEB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 06:04:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A292D53B4E;
        Fri, 22 Apr 2022 03:01:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5EA7EB82B7E;
        Fri, 22 Apr 2022 10:01:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26809C385A4;
        Fri, 22 Apr 2022 10:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650621666;
        bh=qjGK3fbxdhgDQNS87gNp4USM55RS7Z4iOxgE1kHd7lM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P15evWdThpim+dKsPlve4yeyjZcu7/2zKARb3kEi/e5zit9Ks0eroXcHtUz2mijqe
         fOwMRxNae2lCmGnixBiQE9wBPbwhWOga9hSD53c0vwOMkCoJ4gkkxw0VXyTkY2Kv2V
         J9oOaiASh6iQ606kzHGyv06aDoSb1ZNO95F/RBvcz8eSLDRS9Okg0UxKHEimI8pjvE
         5jSoPhtyVeBU+baN6AWwLE9IuvKL8F7naLLLiuwrf/14x94RgjMXmniIVM2/nZde42
         4eIG6T95uM82AtHdr7QqHb2Ir5Z+d9PQDskfyn+i5dWuGyopzcmBrjDHBg9KeAhEku
         1NTyat87QCwPg==
From:   Jiri Olsa <jolsa@kernel.org>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     linux-perf-users@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Ian Rogers <irogers@google.com>
Subject: [PATCH perf/core 3/5] perf tools: Move libbpf init in libbpf_init function
Date:   Fri, 22 Apr 2022 12:00:23 +0200
Message-Id: <20220422100025.1469207-4-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220422100025.1469207-1-jolsa@kernel.org>
References: <20220422100025.1469207-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Moving the libbpf init code into single function,
so we have single place doing that.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/bpf-loader.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/bpf-loader.c b/tools/perf/util/bpf-loader.c
index b72cef1ae959..f8ad581ea247 100644
--- a/tools/perf/util/bpf-loader.c
+++ b/tools/perf/util/bpf-loader.c
@@ -99,16 +99,26 @@ static int bpf_perf_object__add(struct bpf_object *obj)
 	return perf_obj ? 0 : -ENOMEM;
 }
 
+static int libbpf_init(void)
+{
+	if (libbpf_initialized)
+		return 0;
+
+	libbpf_set_print(libbpf_perf_print);
+	libbpf_initialized = true;
+	return 0;
+}
+
 struct bpf_object *
 bpf__prepare_load_buffer(void *obj_buf, size_t obj_buf_sz, const char *name)
 {
 	LIBBPF_OPTS(bpf_object_open_opts, opts, .object_name = name);
 	struct bpf_object *obj;
+	int err;
 
-	if (!libbpf_initialized) {
-		libbpf_set_print(libbpf_perf_print);
-		libbpf_initialized = true;
-	}
+	err = libbpf_init();
+	if (err)
+		return ERR_PTR(err);
 
 	obj = bpf_object__open_mem(obj_buf, obj_buf_sz, &opts);
 	if (IS_ERR_OR_NULL(obj)) {
@@ -135,14 +145,13 @@ struct bpf_object *bpf__prepare_load(const char *filename, bool source)
 {
 	LIBBPF_OPTS(bpf_object_open_opts, opts, .object_name = filename);
 	struct bpf_object *obj;
+	int err;
 
-	if (!libbpf_initialized) {
-		libbpf_set_print(libbpf_perf_print);
-		libbpf_initialized = true;
-	}
+	err = libbpf_init();
+	if (err)
+		return ERR_PTR(err);
 
 	if (source) {
-		int err;
 		void *obj_buf;
 		size_t obj_buf_sz;
 
-- 
2.35.1


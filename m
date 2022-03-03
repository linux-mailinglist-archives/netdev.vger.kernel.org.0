Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51CDB4CB41F
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 02:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbiCCBDS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 20:03:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231204AbiCCBDR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 20:03:17 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61FC3DEEA;
        Wed,  2 Mar 2022 17:02:13 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id e15so1846103pfv.11;
        Wed, 02 Mar 2022 17:02:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RAL3hdQzDPJBJDPviupEa5iJmAtcqnWIkzPTN5WWFRk=;
        b=ANc5nsQR46yz5q8JWZ0HfBXXDXO3SYIkdLhFjQOa2LHneW7UuyTfdwgUGmnyJ+pt2+
         z/ueEO019yu3Jt5o8Wk/U+B8r7rjRL5O4jO4l8QDRg1+qatp+5Ym/2L1q5p9IQtlVyUF
         rx3q24xb/vqvgBrLMbldKXR6mxrOvb4AuYoHoFo50907NzqE5UJva5wr+V8mPrZK7VpM
         pTI3PyJ7dr1cYW5e7ei/sFTJ8j3wVBr2PhjowUug3FwVj4uoRkq7l7196eRp+ykLDZar
         ME+LZNwrd8/oLMMqPQ1gt7fhm8Ix9wOwGRIiSdUSMFtNWwOfEgwJZd6+AW1SNniV2NqL
         SVWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RAL3hdQzDPJBJDPviupEa5iJmAtcqnWIkzPTN5WWFRk=;
        b=iPdEmaxhs2KEFkAF3h+1LYuMCc1tQ8cEIFTo3pd7hiq6/gfZehTWhOQ6m2O5Qp8WJk
         w9r1pkCSnlWPPBqLxXFCauAasFbB0zbvxHHQFk3BbyqV0lCx1ncc1rYXJUaf6XU232Po
         1D/YMoCUSXt/pntL10cYHnEytUDM6VXuyIOMfR/49cNLyWVqSmYTvZIHvtThPUCKZLw6
         Eik6QBuZzJwYSGzfrfKUEnPYkJevADcg3GA1j72E/eeuEYwGfXgs4MPDhmyviKNHy05B
         RtrHBe+ibIhAE3JNoirAH4GViB5yVc8iVB1g4x3n+3Uj3iG9LmMbCZwlu513g/O05Pb9
         sM+w==
X-Gm-Message-State: AOAM530u9fDcAvhsAzf9UJcS8d0krEwASufPmhQfy7fd48n/z8hBynTp
        /6p2dlM9T6rqZBf48jpjd0Hl04X4ZtLRrOXG
X-Google-Smtp-Source: ABdhPJyvRYLWHHMzoAWYl2wbaSpQ7rq6ierqyUXMpHzPtpPbnx5Im4f24PfwMzPLbGZfM2MtlfJa8Q==
X-Received: by 2002:a05:6a00:114e:b0:4c8:55f7:faad with SMTP id b14-20020a056a00114e00b004c855f7faadmr35483932pfm.86.1646269332784;
        Wed, 02 Mar 2022 17:02:12 -0800 (PST)
Received: from localhost.localdomain ([223.212.58.71])
        by smtp.gmail.com with ESMTPSA id k195-20020a636fcc000000b0037c4e3bc503sm298976pgc.77.2022.03.02.17.02.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 17:02:12 -0800 (PST)
From:   Yuntao Wang <ytcoode@gmail.com>
To:     andrii.nakryiko@gmail.com
Cc:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com, yhs@fb.com,
        ytcoode@gmail.com
Subject: [PATCH bpf-next v2] libbpf: Add a check to ensure that page_cnt is non-zero
Date:   Thu,  3 Mar 2022 08:59:21 +0800
Message-Id: <20220303005921.53436-1-ytcoode@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <CAEf4BzYYaRyTh=W+ceb6V=Dj+SzoKNV_O24by4j8Fn4oG3gq2A@mail.gmail.com>
References: <CAEf4BzYYaRyTh=W+ceb6V=Dj+SzoKNV_O24by4j8Fn4oG3gq2A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The page_cnt parameter is used to specify the number of memory pages
allocated for each per-CPU buffer, it must be non-zero and a power of 2.

Currently, the __perf_buffer__new() function attempts to validate that
the page_cnt is a power of 2 but forgets checking for the case where
page_cnt is zero, we can fix it by replacing 'page_cnt & (page_cnt - 1)'
with 'page_cnt == 0 || (page_cnt & (page_cnt - 1))'.

If so, we also don't need to add a check in perf_buffer__new_v0_6_0() to
make sure that page_cnt is non-zero and the check for zero in
perf_buffer__new_raw_v0_6_0() can also be removed.

The code will be cleaner and more readable.

Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
---
v1 -> v2: remove dependency on linux/log2.h header

 tools/lib/bpf/libbpf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index be6480e260c4..81bf01d67671 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -10951,7 +10951,7 @@ struct perf_buffer *perf_buffer__new_raw_v0_6_0(int map_fd, size_t page_cnt,
 {
 	struct perf_buffer_params p = {};
 
-	if (page_cnt == 0 || !attr)
+	if (!attr)
 		return libbpf_err_ptr(-EINVAL);
 
 	if (!OPTS_VALID(opts, perf_buffer_raw_opts))
@@ -10992,7 +10992,7 @@ static struct perf_buffer *__perf_buffer__new(int map_fd, size_t page_cnt,
 	__u32 map_info_len;
 	int err, i, j, n;
 
-	if (page_cnt & (page_cnt - 1)) {
+	if (page_cnt == 0 || (page_cnt & (page_cnt - 1))) {
 		pr_warn("page count should be power of two, but is %zu\n",
 			page_cnt);
 		return ERR_PTR(-EINVAL);
-- 
2.35.1


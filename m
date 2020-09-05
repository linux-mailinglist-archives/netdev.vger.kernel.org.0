Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E002B25E8D6
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 17:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728323AbgIEPlz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 11:41:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728369AbgIEPlu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Sep 2020 11:41:50 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 913A7C061245;
        Sat,  5 Sep 2020 08:41:48 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id d22so6261867pfn.5;
        Sat, 05 Sep 2020 08:41:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wlqvmaWtT+p3nw0YK85+/WSJDRrxvtYaZTroZ/zyrlg=;
        b=C/QdQs8CxjhfYlhz03tg0kfUBty4/mUAnLHMsCOGGhIRWPwnwCF1/7RcrJrB0eeQTE
         FKTtL4FSztuyhBWMtHfEEwZCk5dI0GNWCqLWcxgFV8NHMA+OAAPvEOnTTV4rP+zkRC4v
         IBY62xHZ4jzh3UKKOnGyM0O8yJ4GbCoHtIzWBwkwF0Y0ObVFPzP2pLm9ojUTOVsxPvKC
         TtJy5z5Ssy3oLNbkQL4+W2RaFWW5SGKyDrCejiDWDGDhROVWXEpuCe55zz6I+xmsjaV0
         p9DTiAQsE9VcVUVYfvyECZ1yvjCA3hg5aDUlypa77YJl12TURT+QQrbjhwfiyNDXH1dl
         Iufw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wlqvmaWtT+p3nw0YK85+/WSJDRrxvtYaZTroZ/zyrlg=;
        b=REK6Ua+T0WUtMYjpFevEuyiwGQpj/g91ah8qOuHPNXhG+Ag2RvECHeQ12c3qyTW4VY
         LBVhZTuRygS/dv1kr1ixyxUvPCvKCkcYU/vpwJDWyfs4/KkpUxt+y7tgimJM2AUXMRRu
         bIG+xiuMztSKedup1deZl5uQ6l5W0OALYBpMP2A24WW+rGl6J2ach/MtOA8oc9FX5Nn9
         F6ihlbk4HAuqDT9pewT8RDVEzCqgW1A+X8s3kcCu8gqlqi86//gO28bOAXsTvbtnzQMT
         FJDCBH4WSVGqAftWvUYuzIFMZ8XldtzeW+is92siaJTJ5uo+WzYPROOojsTPxeZQrH7E
         9/ag==
X-Gm-Message-State: AOAM5308I1NEIo74UVDK7VxXuNFoBjsKCg6p3bz3rpjd7+JEwLMEiq4m
        wHx4mQMZ8xUG9aVYnY1ldA==
X-Google-Smtp-Source: ABdhPJxCVS4zyKzD4dYmxNTfjn04NfflnRd1J+jjr8eeV4fVigYH1H2GusuZK0TVrQSPfE2QGMGOjw==
X-Received: by 2002:a62:e40a:0:b029:138:8fd6:7fd5 with SMTP id r10-20020a62e40a0000b02901388fd67fd5mr11859405pfh.1.1599320506919;
        Sat, 05 Sep 2020 08:41:46 -0700 (PDT)
Received: from localhost.localdomain ([182.209.58.45])
        by smtp.gmail.com with ESMTPSA id j13sm9993571pfn.166.2020.09.05.08.41.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2020 08:41:46 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next] samples: bpf: refactor xdp_sample_pkts_kern with BTF-defined map
Date:   Sun,  6 Sep 2020 00:41:37 +0900
Message-Id: <20200905154137.24800-1-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most of the samples were converted to use the new BTF-defined MAP as
they moved to libbbpf, but some of the samples were missing.

Instead of using the previous BPF MAP definition, this commit refactors
xdp_sample_pkts_kern MAP definition with the new BTF-defined MAP format.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/bpf/xdp_sample_pkts_kern.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/samples/bpf/xdp_sample_pkts_kern.c b/samples/bpf/xdp_sample_pkts_kern.c
index 33377289e2a8..b15172b7d455 100644
--- a/samples/bpf/xdp_sample_pkts_kern.c
+++ b/samples/bpf/xdp_sample_pkts_kern.c
@@ -7,12 +7,12 @@
 #define SAMPLE_SIZE 64ul
 #define MAX_CPUS 128
 
-struct bpf_map_def SEC("maps") my_map = {
-	.type = BPF_MAP_TYPE_PERF_EVENT_ARRAY,
-	.key_size = sizeof(int),
-	.value_size = sizeof(u32),
-	.max_entries = MAX_CPUS,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_PERF_EVENT_ARRAY);
+	__uint(key_size, sizeof(int));
+	__uint(value_size, sizeof(u32));
+	__uint(max_entries, MAX_CPUS);
+} my_map SEC(".maps");
 
 SEC("xdp_sample")
 int xdp_sample_prog(struct xdp_md *ctx)
-- 
2.25.1


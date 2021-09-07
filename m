Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 036224030E7
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 00:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347663AbhIGWZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 18:25:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347678AbhIGWZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 18:25:00 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A7BDC0613CF
        for <netdev@vger.kernel.org>; Tue,  7 Sep 2021 15:23:52 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id jg16so62592ejc.1
        for <netdev@vger.kernel.org>; Tue, 07 Sep 2021 15:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hsJRd+5H/xBdXI0ewID2C2LPT2CelRazFOfPu6EBp7o=;
        b=KnQcCDG4joN/ogi3ID8wzVS6karwjlbEwsmI67W1We6ekzxA3sSe4MG1ZhP+xhqgyw
         cZanzYaFXh5Yf+Vulpsi9QJaER1febT1m84fhk8aor7I2gF026jU55KOMvl1X/29ixJs
         DYQr7J/6PZZTwGmaf6IR1g3GBroXDSzV9SNw0fkL/KoLy0K41fmRPL36YT069rAbNiop
         w6gjyJqZ8ON6Uu3m2K2tSF0wn8dMfG3FCwGNRQIm7SESUaISV5vfX8tT6bpj41che9cI
         RiRpW0vE4Lkyc1oaewfKsLW5ha0oUtkn8JGhzOPgujhTfDTS0WbIIgx/zjqkhjzA3fPD
         F5Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hsJRd+5H/xBdXI0ewID2C2LPT2CelRazFOfPu6EBp7o=;
        b=rlc8JXtCVB3NlL0jaVDvE9/AnPo1cIAGGKpLu5WGQgt3ZVdyusxmFl+cRthYrxf3Tx
         tWanJenAqC78gA6thXvjoIlJAmi50pp7FUFtWQkGJnoS5z9iWpxFyhjzlx/wTDdd9bsV
         Gi9BlvdlFCEwVxfQgEQSUcMVpR6k5BBnPmEp+RuBjXDYd/bJRGu/+xd5SGlvWdM8RKFG
         AWsYNFi8b24OMjVjkGii3IDrW9hL4tG+b+IbBJRihkinR6hrj7buggQW3wAxv6lhHmSO
         CGY1DM/vuQFvYT/maKHgcDR29g01lF+HuxDC3MWKyBCYGVBdSMJ7kIejrAfQmg5mJ9EM
         7bFQ==
X-Gm-Message-State: AOAM533a0heRY/+7sY/iJIb4pyAKeF7cW0cKIHZrVyFsbzCypDkIKNS/
        7Hk955VKNn2ix9CersBCg1a6zQ==
X-Google-Smtp-Source: ABdhPJzSWwoZYW+9Of+HubxRBa+2Uw7JHyRAXZP30LZNmKsw14bmsUh43lowozO/j0JJTmMgynmOFA==
X-Received: by 2002:a17:906:4482:: with SMTP id y2mr621958ejo.484.1631053430981;
        Tue, 07 Sep 2021 15:23:50 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id gb24sm71772ejc.53.2021.09.07.15.23.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 15:23:50 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, iii@linux.ibm.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH bpf-next v2 02/13] bpf/tests: Reduce memory footprint of test suite
Date:   Wed,  8 Sep 2021 00:23:28 +0200
Message-Id: <20210907222339.4130924-3-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210907222339.4130924-1-johan.almbladh@anyfinetworks.com>
References: <20210907222339.4130924-1-johan.almbladh@anyfinetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The test suite used to call any fill_helper callbacks to generate eBPF
program data for all test cases at once. This caused ballooning memory
requirements as more extensive test cases were added. Now the each
fill_helper is called before the test is run and the allocated memory
released afterwards, before the next test case is processed.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
---
 lib/test_bpf.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index c8bd3e9ab10a..f0651dc6450b 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -8694,8 +8694,6 @@ static __init int find_test_index(const char *test_name)
 
 static __init int prepare_bpf_tests(void)
 {
-	int i;
-
 	if (test_id >= 0) {
 		/*
 		 * if a test_id was specified, use test_range to
@@ -8739,23 +8737,11 @@ static __init int prepare_bpf_tests(void)
 		}
 	}
 
-	for (i = 0; i < ARRAY_SIZE(tests); i++) {
-		if (tests[i].fill_helper &&
-		    tests[i].fill_helper(&tests[i]) < 0)
-			return -ENOMEM;
-	}
-
 	return 0;
 }
 
 static __init void destroy_bpf_tests(void)
 {
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(tests); i++) {
-		if (tests[i].fill_helper)
-			kfree(tests[i].u.ptr.insns);
-	}
 }
 
 static bool exclude_test(int test_id)
@@ -8959,7 +8945,19 @@ static __init int test_bpf(void)
 
 		pr_info("#%d %s ", i, tests[i].descr);
 
+		if (tests[i].fill_helper &&
+		    tests[i].fill_helper(&tests[i]) < 0) {
+			pr_cont("FAIL to prog_fill\n");
+			continue;
+		}
+
 		fp = generate_filter(i, &err);
+
+		if (tests[i].fill_helper) {
+			kfree(tests[i].u.ptr.insns);
+			tests[i].u.ptr.insns = NULL;
+		}
+
 		if (fp == NULL) {
 			if (err == 0) {
 				pass_cnt++;
-- 
2.25.1


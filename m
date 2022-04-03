Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1C404F0A56
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 16:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358543AbiDCOpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 10:45:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349257AbiDCOpF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 10:45:05 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90C1D3388D;
        Sun,  3 Apr 2022 07:43:11 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id w7so6654405pfu.11;
        Sun, 03 Apr 2022 07:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=b08Jd4YgKGr0lzJ8+d7+I0YJDT94b5X1ccud/BP7cUc=;
        b=Lp43tFnEj5TEr7qsXgZv9MNlKXoP99rH82SOAethLHVB2ZpyVvWS/ivkt9NM66a8/M
         oOf4Aq1rmKYUVawxSXkMYaSsZMwgAUYioPkuF5dhAxx39GTtOaHFRgKJQLUid7eu0fln
         A2s6GTX1EGPKW63jwqtsWpphqk/bz6smetY/KvVmnds9IW+BzuTcJ1KnKfpH3lUHsZ9g
         vXkCib5dYc3ZdTGPSqKlJrsj2CZL21jHHILtLvhkn6+0kCxp7dTzpemWC7A3m7x1FjtR
         LY/KIABQXLoP1TNeZjG/zRESbeqrSCWUD1pk71PJGYLxoLOrql9DbIws+veoJ8hq+zlo
         bZTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b08Jd4YgKGr0lzJ8+d7+I0YJDT94b5X1ccud/BP7cUc=;
        b=SGBQrlDsCE7yJRtrjcLiEBAr8XowzQ0u/dAgt+QLpWmvGKclZopuy7JX2zhioPo6FV
         4wq4fLb1NCInK5b1LpQIGYAZ9s1xu03n0/AVaJbKxKmwlw8n7t7JSrW5xQptjWmitQOM
         P8wsG1GkqZXMrsiBUmGo90fZzteAF2mct0+jkNn5syhNpZJTlSXG5pFJRut8LV0cEo6o
         6Q1iZua5ois1rOEQPeq0pGpxnPLV6Ts/54AyFQkS2YkBb3B5XvGdFuY8oQlpXZWLnH7p
         T2lPUOQdvDCg5TN2huScaXeqwpdmn5Ydnf4g+gyPjz+YOwm8kfY07mjQF00RL0hY4nMG
         uszA==
X-Gm-Message-State: AOAM530KJ+LtHY/qjpxQfmac1tiI6Ok4Fo3kxJxQcORx5RkPJ87I+eOG
        PY+i31c8Fidt+F3dfbE9pas=
X-Google-Smtp-Source: ABdhPJxE+S+SYzDeKPX0k3yehx1kwsMWE+iEkRr5fQEPrC56I6sqKdCI615wx+1C0cTwOebGYjWH9Q==
X-Received: by 2002:a63:35c3:0:b0:380:6a04:cecc with SMTP id c186-20020a6335c3000000b003806a04ceccmr22638794pga.455.1648996990959;
        Sun, 03 Apr 2022 07:43:10 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:51a7:5400:3ff:feee:9f61])
        by smtp.gmail.com with ESMTPSA id c18-20020a056a000ad200b004cdccd3da08sm9464910pfl.44.2022.04.03.07.43.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 07:43:10 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next v2 1/9] bpf: selftests: Use libbpf 1.0 API mode in bpf constructor
Date:   Sun,  3 Apr 2022 14:42:52 +0000
Message-Id: <20220403144300.6707-2-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220403144300.6707-1-laoar.shao@gmail.com>
References: <20220403144300.6707-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In libbpf 1.0 API mode, it will bump rlimit automatically if there's no
memcg-basaed accounting, so we can use libbpf 1.0 API mode instead in case
we want to run it in an old kernel.

The constructor is renamed to bpf_strict_all_ctor().

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 tools/testing/selftests/bpf/bpf_rlimit.h | 26 +++---------------------
 1 file changed, 3 insertions(+), 23 deletions(-)

diff --git a/tools/testing/selftests/bpf/bpf_rlimit.h b/tools/testing/selftests/bpf/bpf_rlimit.h
index 9dac9b30f8ef..d050f7d0bb5c 100644
--- a/tools/testing/selftests/bpf/bpf_rlimit.h
+++ b/tools/testing/selftests/bpf/bpf_rlimit.h
@@ -1,28 +1,8 @@
 #include <sys/resource.h>
 #include <stdio.h>
 
-static  __attribute__((constructor)) void bpf_rlimit_ctor(void)
+static  __attribute__((constructor)) void bpf_strict_all_ctor(void)
 {
-	struct rlimit rlim_old, rlim_new = {
-		.rlim_cur	= RLIM_INFINITY,
-		.rlim_max	= RLIM_INFINITY,
-	};
-
-	getrlimit(RLIMIT_MEMLOCK, &rlim_old);
-	/* For the sake of running the test cases, we temporarily
-	 * set rlimit to infinity in order for kernel to focus on
-	 * errors from actual test cases and not getting noise
-	 * from hitting memlock limits. The limit is on per-process
-	 * basis and not a global one, hence destructor not really
-	 * needed here.
-	 */
-	if (setrlimit(RLIMIT_MEMLOCK, &rlim_new) < 0) {
-		perror("Unable to lift memlock rlimit");
-		/* Trying out lower limit, but expect potential test
-		 * case failures from this!
-		 */
-		rlim_new.rlim_cur = rlim_old.rlim_cur + (1UL << 20);
-		rlim_new.rlim_max = rlim_old.rlim_max + (1UL << 20);
-		setrlimit(RLIMIT_MEMLOCK, &rlim_new);
-	}
+	/* Use libbpf 1.0 API mode */
+	libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
 }
-- 
2.17.1


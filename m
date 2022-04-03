Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A59DE4F0A55
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 16:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359055AbiDCOpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 10:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359020AbiDCOpG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 10:45:06 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D9193388D;
        Sun,  3 Apr 2022 07:43:12 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id h19so6706789pfv.1;
        Sun, 03 Apr 2022 07:43:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sOFjfSMnG30lHn+Yoz/l/DHCL+27lA4clMfQyl/6D4M=;
        b=AZeBJQGFjUUiY05NywDQp7gONkA2ExEMeJ/V9L3yHIPWABY5HdK88n34COlKJQuneY
         v0xz1VhnG0U7TKkERZUwRGsh8TifdcHiTKH25NtIa40681AWHVnLPTNvjXhQup3YdF9e
         i++O0iiQ6UflQO5DEwQvH4YvrNSVeZ54oTYSho1KIe7k8yb8az+Ey+msAvMxvCZ9g6Ih
         lXt3oO/RrAdOfX2Xsld1Qi7uLJMntLHqSBtMskaw5hEWA6g6P3x9CYAPpupCl+M0GPQ+
         WfGehlwe1HfcMMq8XwZdoIfXuT/h6UING84Yyr6Z0B9wnQybH2jJVkWQS8qu6J1B1jgM
         RJfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sOFjfSMnG30lHn+Yoz/l/DHCL+27lA4clMfQyl/6D4M=;
        b=nOGBEZnNJZRP7Y7G7DdjJ+Qh5HDekYaivYMT5yHygeEnwYPmywaMJDSV6tSKx1Ptr6
         H8T+k1DwrvCysklPBPMse9gpNCj15aEQ81QMVOWaR3HWZi433zi3LUw7ueAXLt//CSkZ
         MXL1tMqCQ/uEP1q2hwjwoHh5SLGNQWsqpCap9XDM1bBjM0o13M1CwOy5rKj8e1t4sBBX
         oObhTmrJzTTvbLCjMcR4Rj/aWNJ+WukQWmRkJ/pEtVqL73RB6nTRebED3V1/xVVJfNGX
         L8xD3v1R2e3AtJAlRBWoovzKz1C3Ci7ri9AcC4ZNFNBbK/rqxPEUEYDEynJkF+iEgaaP
         DgqQ==
X-Gm-Message-State: AOAM530LnvHChAEdX+QG7UZ/kuZdOSJ0VnMLvL2cLNpw1mp4uAzFDLkX
        kUWY6aT2xjVe3qE/qJBN9uA=
X-Google-Smtp-Source: ABdhPJyyxnF8DPsdX9vUroivyQCzmBsQQWqM6ohN4nuucYbQAslXphejm0NZv5oxIme/EBBjf0hvcA==
X-Received: by 2002:a05:6a00:438b:b0:4fa:a67c:7ca0 with SMTP id bt11-20020a056a00438b00b004faa67c7ca0mr19795268pfb.5.1648996992065;
        Sun, 03 Apr 2022 07:43:12 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:51a7:5400:3ff:feee:9f61])
        by smtp.gmail.com with ESMTPSA id c18-20020a056a000ad200b004cdccd3da08sm9464910pfl.44.2022.04.03.07.43.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 07:43:11 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next v2 2/9] bpf: selftests: Use bpf strict all ctor in xdping
Date:   Sun,  3 Apr 2022 14:42:53 +0000
Message-Id: <20220403144300.6707-3-laoar.shao@gmail.com>
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

Aoid using the deprecated RLIMIT_MEMLOCK.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 tools/testing/selftests/bpf/xdping.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdping.c b/tools/testing/selftests/bpf/xdping.c
index c567856fd1bc..46ba0d7f73e8 100644
--- a/tools/testing/selftests/bpf/xdping.c
+++ b/tools/testing/selftests/bpf/xdping.c
@@ -12,7 +12,6 @@
 #include <string.h>
 #include <unistd.h>
 #include <libgen.h>
-#include <sys/resource.h>
 #include <net/if.h>
 #include <sys/types.h>
 #include <sys/socket.h>
@@ -20,6 +19,7 @@
 
 #include "bpf/bpf.h"
 #include "bpf/libbpf.h"
+#include "bpf_rlimit.h"
 
 #include "xdping.h"
 #include "testing_helpers.h"
@@ -89,7 +89,6 @@ int main(int argc, char **argv)
 {
 	__u32 mode_flags = XDP_FLAGS_DRV_MODE | XDP_FLAGS_SKB_MODE;
 	struct addrinfo *a, hints = { .ai_family = AF_INET };
-	struct rlimit r = {RLIM_INFINITY, RLIM_INFINITY};
 	__u16 count = XDPING_DEFAULT_COUNT;
 	struct pinginfo pinginfo = { 0 };
 	const char *optstr = "c:I:NsS";
@@ -167,11 +166,6 @@ int main(int argc, char **argv)
 		freeaddrinfo(a);
 	}
 
-	if (setrlimit(RLIMIT_MEMLOCK, &r)) {
-		perror("setrlimit(RLIMIT_MEMLOCK)");
-		return 1;
-	}
-
 	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
 
 	if (bpf_prog_test_load(filename, BPF_PROG_TYPE_XDP, &obj, &prog_fd)) {
-- 
2.17.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 450064F4546
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 00:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240203AbiDEO1W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 10:27:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239482AbiDEOUx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 10:20:53 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6496658E48;
        Tue,  5 Apr 2022 06:09:23 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id h19so12061863pfv.1;
        Tue, 05 Apr 2022 06:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=257UF497YzpH4axpMO23MTlyv62KXWe/JQIPveGu7x0=;
        b=cc3He2l9unwgcLEgnFCejwUU9HOJEqcK1qrfuzYjSXxEINMjHxiyldSzuXMAe6Uz2F
         VGLieNjcTr80gISBzDcJApdOAbyrae6QWWrdwT9DpQpwdOoX0Rf8uOAyQxuex/8vF8Np
         L1JfXMniRRYdI+HH1gAtq4i1DQJiBp5FU1s0lPb7oMqr/sDnZM3VrkUokBSx1Nm4jYaG
         d0aj9YiNdSDH44+UgiSQVEpYU/Ig1fpdD1zyCDy+J0g2l3JGqv8ygZAWYOJQMgekiArE
         8NecHAuZW5Ww6MjwyJ7Ef7DcJnmluGRtDutGHtFQyXFLAyR/GK3PaFXuFRWnrNq2nsRm
         ZhwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=257UF497YzpH4axpMO23MTlyv62KXWe/JQIPveGu7x0=;
        b=vN+CtbSxRHvzM5k9DKS82KT9QWDQV6r0l091Xi660AjrQiuAsxQBgXmMo7Ui4yyQxc
         FBqQAgkoMbH7kDKAPMRPTrpAx/t3EJiMVCzyWFllWVzb5yd5h9x/sBe5VUPgaFAjE9Qm
         r38uGKMqiB/ITQPTuX9vxsjwlfnQSBq1RNO/ckkT/oBdLaqkwskYaxjhhSp7q0JlAd6k
         /JdadXbWo0kCh0GIMVYa1hjN7mGeT/wDogPHP7hqAEpRk17V8bVKoTEUBZJih+I8HOyB
         dHlTp9SQhLOlMV2K4PS8R48WFW3POOLXj/p6VBcql2keRN6Qhm5JzpAT0m47HfVBUoZF
         N7vA==
X-Gm-Message-State: AOAM531KWNIDWbji4okg6NITQ/XqtvDV705EX76drdDC4QLo9mxq0UBp
        b7aaMOoYGgqOie4fILhyiTk=
X-Google-Smtp-Source: ABdhPJzrdYbhVOFSa9+rRNVnL42WkJTmZfIjE7TVOu4tYajWSkj2tRh7/v4dFVVBj3gi1tlw5iGA2A==
X-Received: by 2002:a05:6a00:801:b0:4fd:f66a:b36c with SMTP id m1-20020a056a00080100b004fdf66ab36cmr3431942pfk.68.1649164162787;
        Tue, 05 Apr 2022 06:09:22 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:5271:5400:3ff:feef:3aee])
        by smtp.gmail.com with ESMTPSA id s135-20020a63778d000000b0038259e54389sm13147257pgc.19.2022.04.05.06.09.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 06:09:22 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next v3 06/27] bpf: selftests: Set libbpf 1.0 API mode explicitly in test_cgroup_storage
Date:   Tue,  5 Apr 2022 13:08:37 +0000
Message-Id: <20220405130858.12165-7-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220405130858.12165-1-laoar.shao@gmail.com>
References: <20220405130858.12165-1-laoar.shao@gmail.com>
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

Let's set libbpf 1.0 API mode explicitly, then we can get rid of the
included bpf_rlimit.h.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 tools/testing/selftests/bpf/test_cgroup_storage.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_cgroup_storage.c b/tools/testing/selftests/bpf/test_cgroup_storage.c
index d6a1be4d8020..059507445c6e 100644
--- a/tools/testing/selftests/bpf/test_cgroup_storage.c
+++ b/tools/testing/selftests/bpf/test_cgroup_storage.c
@@ -6,7 +6,6 @@
 #include <stdlib.h>
 #include <sys/sysinfo.h>
 
-#include "bpf_rlimit.h"
 #include "cgroup_helpers.h"
 #include "testing_helpers.h"
 
@@ -51,6 +50,9 @@ int main(int argc, char **argv)
 		goto err;
 	}
 
+	/* Use libbpf 1.0 API mode */
+	libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
+
 	map_fd = bpf_map_create(BPF_MAP_TYPE_CGROUP_STORAGE, NULL, sizeof(key),
 				sizeof(value), 0, NULL);
 	if (map_fd < 0) {
-- 
2.17.1


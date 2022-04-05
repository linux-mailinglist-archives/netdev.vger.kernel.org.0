Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 145A74F4648
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 01:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236914AbiDEO0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 10:26:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238977AbiDEOUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 10:20:44 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22FEF5549B;
        Tue,  5 Apr 2022 06:09:18 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id k14so11022227pga.0;
        Tue, 05 Apr 2022 06:09:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D9yWoQxE74uWounzZsZbgmdR8XONo5+WgLUX+EXW7Z8=;
        b=KURZ5TfwC+Mjg5DvYFjx2YrvBBBFYOoLqPy/A7esmpRI6qm0mhLgIHNQpmAQeUUdjD
         ufmt7CakkG43pjH0ZBp5gfw/uUn0cIcey0jiZ4jGjnGZG5+iuTAl3lZ2ICO4silCOA+L
         XQir94lJuO3g8buPBrt/KMMs7GAjcOtA/yynOC+EkuRlp3AKWjPLooOB2YaJfflm27xW
         KI+dzb/5xGwtDATy7d5u16tWforC/Olatz+xV9EMNhtenyCDKvwRM8YSEDMeOLuT7xYl
         O+BYrjdLWgQPF8et51KrCOChlZncbVhb/rKHKpt7KV7Eq9HA0qs25wFYwN7xmlUQXfdy
         CpZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D9yWoQxE74uWounzZsZbgmdR8XONo5+WgLUX+EXW7Z8=;
        b=XFHAhspHtJRKOJ7RxFbQXuIF2kJBh56FQAJN+lbpcsGZ8otoTzZjMUErtus0qt3IJv
         mNT/B/FSX5ATavVLeYaKtd5KMIDifomwmtLxjbViMzz/9oYccvRaPjIVuCsAgYsHbPgy
         zT6mKhl8hWu6bkKmMngIRTBq66sBenESguDozCkGl3PnHCOXYyIjCfqpO8uLwQk9lNT7
         MMcK3FN6I2se3JdY73aGC2Ma//bdbVGvCRXXjgC/dg6oPB/K6C/BInt6GWsl2dRNb3zX
         mONHqXP+APgguFD45nAAHHxtj5CPPZ3GxgVyQGgx/GpdIMVLsw9CvSiHOYYoOQVo1I91
         mujw==
X-Gm-Message-State: AOAM533OiCJexn2bW4AfWEwZULjQymaxG2YX8nh5tJOwAMa2fjgvxWVt
        abWeRxO7pkwl1zChTB9mkcc=
X-Google-Smtp-Source: ABdhPJy2vJ2L1malfBBRM4cUlBP0TGqjnTwoaOudz/gCM9UJz+7FLPzRsYKm3er60S2yrMqPr+FaVA==
X-Received: by 2002:a63:2cd5:0:b0:398:997f:a440 with SMTP id s204-20020a632cd5000000b00398997fa440mr2932196pgs.344.1649164157652;
        Tue, 05 Apr 2022 06:09:17 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:5271:5400:3ff:feef:3aee])
        by smtp.gmail.com with ESMTPSA id s135-20020a63778d000000b0038259e54389sm13147257pgc.19.2022.04.05.06.09.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 06:09:17 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next v3 02/27] bpf: selftests: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK in xdpxceiver
Date:   Tue,  5 Apr 2022 13:08:33 +0000
Message-Id: <20220405130858.12165-3-laoar.shao@gmail.com>
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

Explicitly set libbpf 1.0 API mode, then we can avoid using the deprecated
RLIMIT_MEMLOCK.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 5f8296d29e77..cfcb031323c5 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -90,7 +90,6 @@
 #include <string.h>
 #include <stddef.h>
 #include <sys/mman.h>
-#include <sys/resource.h>
 #include <sys/types.h>
 #include <sys/queue.h>
 #include <time.h>
@@ -1448,14 +1447,13 @@ static void ifobject_delete(struct ifobject *ifobj)
 
 int main(int argc, char **argv)
 {
-	struct rlimit _rlim = { RLIM_INFINITY, RLIM_INFINITY };
 	struct pkt_stream *pkt_stream_default;
 	struct ifobject *ifobj_tx, *ifobj_rx;
 	struct test_spec test;
 	u32 i, j;
 
-	if (setrlimit(RLIMIT_MEMLOCK, &_rlim))
-		exit_with_error(errno);
+	/* Use libbpf 1.0 API mode */
+	libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
 
 	ifobj_tx = ifobject_create();
 	if (!ifobj_tx)
-- 
2.17.1


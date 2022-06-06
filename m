Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 430BC53E2E6
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 10:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231545AbiFFHxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 03:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231530AbiFFHxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 03:53:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 145FF11816
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 00:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654501984;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=efmsQ2arxZifYajSmsr75p7XJe4C+xw36T3Z4hPU4g4=;
        b=f7jar+M22j1Du49MApBbM3EafLLpVzE0abqOWggEMB6FGRWmuy9Q9K4a6WsP2EtjDLb+4r
        WxMvhCi94V9uDdw1SrnbOZLTueC18hEWev6/tehA4FrA2Tzh8oaZa5b7dPZIQ3Q4UZxbNO
        dEuRgfFiTi9cl85Cv7uZmOel0rTDrkA=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-185-nKohALySPg-t38VPRhKN3g-1; Mon, 06 Jun 2022 03:53:02 -0400
X-MC-Unique: nKohALySPg-t38VPRhKN3g-1
Received: by mail-ej1-f72.google.com with SMTP id t15-20020a1709066bcf00b0070dedeacb2cso2906000ejs.9
        for <netdev@vger.kernel.org>; Mon, 06 Jun 2022 00:53:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=efmsQ2arxZifYajSmsr75p7XJe4C+xw36T3Z4hPU4g4=;
        b=OdONKphIUdpPezC84+sOnQsL68RXlBawALKKDAIboTrBk002/+p2r7JFTrhEfi47wM
         cmfjw1qJGcjA4QpGxPRz3jR4W4L/XaRraY3hdgdP+KxtCp9m08JFpQ4Md7Obl2GPWXpY
         2XLciHy1u9SXXynApoiS1rH5pI87PqgHnzsfZwAfAKYLbqZ+cmzQ+KA1isSl+S6A+257
         g9BbC+5GZnz2yQv+VkBHpOLH6l+oWvBzFmBuwSeiNcZdWUQqbAqs/Ss/ItJ481wO5cvd
         fsc83zLkUI9hlZZnbXKJeGIIhqaldGfCZx57AnOsW0qSbIK7WHU80sEUEAu2V0Lb6NKO
         5xXg==
X-Gm-Message-State: AOAM532Op9ehLx/BfJAsqq8kdMO2UnXk0tKG/2rn2V/Yz2+dW0JLIfLO
        0LDviFz4Sthh6zh+AloIZiGwOoRtuDLF9Q/HHiJBO2aaKhSOyLDazBuwcHLBq+iUpZXNdkrtssf
        fTlK6iIES7hvwPbH+
X-Received: by 2002:a05:6402:5114:b0:42f:b5f3:1f96 with SMTP id m20-20020a056402511400b0042fb5f31f96mr13720315edd.260.1654501980963;
        Mon, 06 Jun 2022 00:53:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxmnCNxtltGYWawiS61eUdc/EIKyqZ4BcsfNsSbSw7Z/52LixKveyxGp66T7W5LCa1zwgdktg==
X-Received: by 2002:a05:6402:5114:b0:42f:b5f3:1f96 with SMTP id m20-20020a056402511400b0042fb5f31f96mr13720288edd.260.1654501980669;
        Mon, 06 Jun 2022 00:53:00 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id p23-20020a170906499700b0070f36b8cb39sm3568239eju.103.2022.06.06.00.52.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 00:52:59 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 9DADA4055A1; Mon,  6 Jun 2022 09:52:57 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH bpf v2 2/2] selftests/bpf: Add selftest for calling global functions from freplace
Date:   Mon,  6 Jun 2022 09:52:52 +0200
Message-Id: <20220606075253.28422-2-toke@redhat.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220606075253.28422-1-toke@redhat.com>
References: <20220606075253.28422-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a selftest that calls a global function with a context object parameter
from an freplace function to check that the program context type is
correctly converted to the freplace target when fetching the context type
from the kernel BTF.

v2:
- Trim includes
- Get rid of global function
- Use __noinline

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c   | 14 ++++++++++++++
 .../selftests/bpf/progs/freplace_global_func.c | 18 ++++++++++++++++++
 2 files changed, 32 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/freplace_global_func.c

diff --git a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c b/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
index d9aad15e0d24..02bb8cbf9194 100644
--- a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
+++ b/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
@@ -395,6 +395,18 @@ static void test_func_map_prog_compatibility(void)
 				     "./test_attach_probe.o");
 }
 
+static void test_func_replace_global_func(void)
+{
+	const char *prog_name[] = {
+		"freplace/test_pkt_access",
+	};
+
+	test_fexit_bpf2bpf_common("./freplace_global_func.o",
+				  "./test_pkt_access.o",
+				  ARRAY_SIZE(prog_name),
+				  prog_name, false, NULL);
+}
+
 /* NOTE: affect other tests, must run in serial mode */
 void serial_test_fexit_bpf2bpf(void)
 {
@@ -416,4 +428,6 @@ void serial_test_fexit_bpf2bpf(void)
 		test_func_replace_multi();
 	if (test__start_subtest("fmod_ret_freplace"))
 		test_fmod_ret_freplace();
+	if (test__start_subtest("func_replace_global_func"))
+		test_func_replace_global_func();
 }
diff --git a/tools/testing/selftests/bpf/progs/freplace_global_func.c b/tools/testing/selftests/bpf/progs/freplace_global_func.c
new file mode 100644
index 000000000000..96cb61a6ce87
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/freplace_global_func.c
@@ -0,0 +1,18 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+__noinline
+int test_ctx_global_func(struct __sk_buff *skb)
+{
+	volatile int retval = 1;
+	return retval;
+}
+
+SEC("freplace/test_pkt_access")
+int new_test_pkt_access(struct __sk_buff *skb)
+{
+	return test_ctx_global_func(skb);
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.36.1


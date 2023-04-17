Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B144A6E422A
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 10:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbjDQIIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 04:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbjDQIIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 04:08:48 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 240BD4C1B
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 01:08:19 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id w11so25220978pjh.5
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 01:08:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1681718898; x=1684310898;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1pw86lkQMgAq2RDg8SbWVwn8vGT1h12ZQk1wvkYIReo=;
        b=hjF133/QONFZyitenmtjp0ZYeV3xbNysg6Km7omFX2WmTCji5Q0JNOY1YRay8T8RtG
         f+2xfP4i1GEDVWsEWu4nqWyEVKCAdlfn7LYHPQiiBeMnkYw5dlsobVnqFQzohR3zgpAA
         DSbF3zfJH6AqSwVO+gOARdL5BahZ5qhS+QLAugiTWX1UDaltFt9UFV3wcVPD464HDeY5
         fgsbbVTnwHJlBBXd4yHWdEH7L4rwCi+fjhM7c4wahS7qWRM9l/7SdPeMZsToa+ortz0v
         cEh+gwpdv+tPlN2YtPzacZo54zM8pQhtc9X1omgDjbw3tq+bVUY+NCVyE5B+gi4HpHq4
         kmzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681718898; x=1684310898;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1pw86lkQMgAq2RDg8SbWVwn8vGT1h12ZQk1wvkYIReo=;
        b=Io227wZGl/hUIVORKAbXNcN1/VVw/0X/aHeV5aZ0aVnVMvceQDRUA8K+R4QcTmVs5W
         M0+zY2XeIKEGK3klvL+IBG2ayDCDHBvb6fblmhZ/XHIndX95p3IqJq+BgywPd4AArf9M
         ON9d8DzBk6qnIfV2orf6NCNe+BTZCkWLTFbwLldmpJJbg5dwgN+IfJ/0l5wmTLJfmSQJ
         RGfctjZbBmfCq22psJVzVSITlNzyiDjExUNYp8OYc2w+JPAV8B+qlM1+0CIkfiAdvPhk
         MqachbxD7yC/lqu4Z9wZXSwkhpjgGxxxwrCX6r2tip2tPQ6LY6LACODvzWrPKOdaVB3X
         jx8A==
X-Gm-Message-State: AAQBX9fl5lYyUETb38V+mlUiQ8Lkwk+cKmYrtfb10qdVg4cx7taNcOBS
        sLa1Gu4Pxi0XUg4wv8FwJ8BqBQ==
X-Google-Smtp-Source: AKy350Z8s7HBWoiUwUgBaoQgtBCq8ongGM5SOTp6XKSAx/VbvU1WfA8zD0I7T0xDwVZMO4CjZfb9tw==
X-Received: by 2002:a17:902:e804:b0:1a6:b98b:eea9 with SMTP id u4-20020a170902e80400b001a6b98beea9mr8184873plg.20.1681718898555;
        Mon, 17 Apr 2023 01:08:18 -0700 (PDT)
Received: from C02F52LSML85.bytedance.net ([139.177.225.238])
        by smtp.gmail.com with ESMTPSA id jc3-20020a17090325c300b0019a97a4324dsm7114135plb.5.2023.04.17.01.08.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 01:08:18 -0700 (PDT)
From:   Feng zhou <zhoufeng.zf@bytedance.com>
To:     martin.lau@linux.dev, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        mykolal@fb.com, shuah@kernel.org
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        yangzhenze@bytedance.com, wangdongdong.6@bytedance.com,
        zhouchengming@bytedance.com, zhoufeng.zf@bytedance.com
Subject: [PATCH 2/2] selftests/bpf: Add test to access integer type of variable array
Date:   Mon, 17 Apr 2023 16:07:49 +0800
Message-Id: <20230417080749.39074-3-zhoufeng.zf@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20230417080749.39074-1-zhoufeng.zf@bytedance.com>
References: <20230417080749.39074-1-zhoufeng.zf@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Feng Zhou <zhoufeng.zf@bytedance.com>

Add prog test for accessing integer type of variable array in tracing
program.

Co-developed-by: Chengming Zhou <zhouchengming@bytedance.com>
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
---
 .../selftests/bpf/bpf_testmod/bpf_testmod.c   | 20 +++++++++++++++++++
 .../selftests/bpf/prog_tests/tracing_struct.c |  2 ++
 .../selftests/bpf/progs/tracing_struct.c      | 13 ++++++++++++
 3 files changed, 35 insertions(+)

diff --git a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
index fe847ebfb731..52785ba671e6 100644
--- a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
+++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
@@ -28,6 +28,11 @@ struct bpf_testmod_struct_arg_2 {
 	long b;
 };
 
+struct bpf_testmod_struct_arg_3 {
+	int a;
+	int b[];
+};
+
 __diag_push();
 __diag_ignore_all("-Wmissing-prototypes",
 		  "Global functions as their definitions will be in bpf_testmod.ko BTF");
@@ -63,6 +68,12 @@ bpf_testmod_test_struct_arg_5(void) {
 	return bpf_testmod_test_struct_arg_result;
 }
 
+noinline int
+bpf_testmod_test_struct_arg_6(struct bpf_testmod_struct_arg_3 *a) {
+	bpf_testmod_test_struct_arg_result = a->b[0];
+	return bpf_testmod_test_struct_arg_result;
+}
+
 __bpf_kfunc void
 bpf_testmod_test_mod_kfunc(int i)
 {
@@ -195,6 +206,7 @@ bpf_testmod_test_read(struct file *file, struct kobject *kobj,
 	};
 	struct bpf_testmod_struct_arg_1 struct_arg1 = {10};
 	struct bpf_testmod_struct_arg_2 struct_arg2 = {2, 3};
+	struct bpf_testmod_struct_arg_3 *struct_arg3;
 	int i = 1;
 
 	while (bpf_testmod_return_ptr(i))
@@ -206,6 +218,14 @@ bpf_testmod_test_read(struct file *file, struct kobject *kobj,
 	(void)bpf_testmod_test_struct_arg_4(struct_arg1, 1, 2, 3, struct_arg2);
 	(void)bpf_testmod_test_struct_arg_5();
 
+	struct_arg3 = kmalloc((sizeof(struct bpf_testmod_struct_arg_3) +
+				sizeof(int)), GFP_KERNEL);
+	if (struct_arg3 != NULL) {
+		struct_arg3->b[0] = 1;
+		(void)bpf_testmod_test_struct_arg_6(struct_arg3);
+		kfree(struct_arg3);
+	}
+
 	/* This is always true. Use the check to make sure the compiler
 	 * doesn't remove bpf_testmod_loop_test.
 	 */
diff --git a/tools/testing/selftests/bpf/prog_tests/tracing_struct.c b/tools/testing/selftests/bpf/prog_tests/tracing_struct.c
index 48dc9472e160..1c75a32186d6 100644
--- a/tools/testing/selftests/bpf/prog_tests/tracing_struct.c
+++ b/tools/testing/selftests/bpf/prog_tests/tracing_struct.c
@@ -53,6 +53,8 @@ static void test_fentry(void)
 
 	ASSERT_EQ(skel->bss->t5_ret, 1, "t5 ret");
 
+	ASSERT_EQ(skel->bss->t6, 1, "t6 ret");
+
 	tracing_struct__detach(skel);
 destroy_skel:
 	tracing_struct__destroy(skel);
diff --git a/tools/testing/selftests/bpf/progs/tracing_struct.c b/tools/testing/selftests/bpf/progs/tracing_struct.c
index e718f0ebee7d..c435a3a8328a 100644
--- a/tools/testing/selftests/bpf/progs/tracing_struct.c
+++ b/tools/testing/selftests/bpf/progs/tracing_struct.c
@@ -13,12 +13,18 @@ struct bpf_testmod_struct_arg_2 {
 	long b;
 };
 
+struct bpf_testmod_struct_arg_3 {
+	int a;
+	int b[];
+};
+
 long t1_a_a, t1_a_b, t1_b, t1_c, t1_ret, t1_nregs;
 __u64 t1_reg0, t1_reg1, t1_reg2, t1_reg3;
 long t2_a, t2_b_a, t2_b_b, t2_c, t2_ret;
 long t3_a, t3_b, t3_c_a, t3_c_b, t3_ret;
 long t4_a_a, t4_b, t4_c, t4_d, t4_e_a, t4_e_b, t4_ret;
 long t5_ret;
+int t6;
 
 SEC("fentry/bpf_testmod_test_struct_arg_1")
 int BPF_PROG2(test_struct_arg_1, struct bpf_testmod_struct_arg_2, a, int, b, int, c)
@@ -117,4 +123,11 @@ int BPF_PROG2(test_struct_arg_10, int, ret)
 	return 0;
 }
 
+SEC("fentry/bpf_testmod_test_struct_arg_6")
+int BPF_PROG2(test_struct_arg_11, struct bpf_testmod_struct_arg_3 *, a)
+{
+	t6 = a->b[0];
+	return 0;
+}
+
 char _license[] SEC("license") = "GPL";
-- 
2.20.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12BB34CEEB5
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 00:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234477AbiCFXo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 18:44:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234485AbiCFXo1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 18:44:27 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF32441FA6;
        Sun,  6 Mar 2022 15:43:31 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id n2so2779801plf.4;
        Sun, 06 Mar 2022 15:43:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lJBUsmq/FnvtLIHjhXncbj5Tidl/UCuplMGGTlXujII=;
        b=LQi92m9Afpnf1TM82RlMQxFYjgT3szmcMSDg2sQr/BnC9mXVyV9VbKDAdPfa40RKnz
         SHwzoxd6RC5AwfNOh8syL+fTj1yP++/ShUCiGxyo5nHn/0DMX85x+26hJK1qhZDiTv6Y
         Yr3XEMM+d3fn9xwQIpUTCNaq0TLe6QXeMEoa/lUy+R5xNuQbcDMpAiT/dEUe7+qVv3Hy
         NcTcvcGXAOSR9eSEFIK5KB4eArj0JEDR7B0DPbs/Ylg+pjXljzCWePQNNaT/a58bZPmY
         Iu13eLaei/BRSzLhNs2ukpMtarQX1vFowagoJv2ALwpqtZN0opRlHhScyFsj+jBzxfWy
         jkuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lJBUsmq/FnvtLIHjhXncbj5Tidl/UCuplMGGTlXujII=;
        b=M5EZij4657QiKS9aqkTpEzhxaqic0boPxYJe4kUaIawqcZE5J1P1D4Ucq3Mr4OHmLj
         Niibvdc2Ygfk/OSTGuCXvPsMTBg/dIkTMD+cL2SdJwoxwn4cOCCVB2zeBlgJm5y33w7c
         Li7gcz7ivbsgk5vFhGIsLRipQ0oSeL4yPvX1gkLimQvUOtzB891KdaslIR3mm3vwDLtD
         rFJhjPPynMPlAP3E2ERzK9TyGWa2BvwAiF42Dbq+H5TAAVIK+A1XWHdWypAU95exUeME
         UJ94H7JKo/IINO+sySdkk4WODPdXUDaAQcnFUTfh9z/Y3mPbOknlyCKqAlGSVmx9Ilr0
         sncw==
X-Gm-Message-State: AOAM5300o7CgSLZ3jpfMYAUnlTu007P3SRWAo8dLfRaEB0I+MC7N4/uc
        ybm5GZKkj1I2R5ddqmnaIKO1mk7GGNQ=
X-Google-Smtp-Source: ABdhPJxihHw79IwcWUHPwD503YUhnpkHhvXyT4+4bwOqEiG1Du8iSfrW3MOGY9klGUHDH05qTfKyzA==
X-Received: by 2002:a17:903:4a:b0:151:be09:3de9 with SMTP id l10-20020a170903004a00b00151be093de9mr9484280pla.138.1646610211165;
        Sun, 06 Mar 2022 15:43:31 -0800 (PST)
Received: from localhost ([2405:201:6014:d0c0:6243:316e:a9e1:adda])
        by smtp.gmail.com with ESMTPSA id e18-20020a63d952000000b00372a1295210sm9821274pgj.51.2022.03.06.15.43.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Mar 2022 15:43:30 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Lorenz Bauer <linux@lmb.io>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v1 5/5] selftests/bpf: Update xdp_adjust_frags to use bpf_packet_pointer
Date:   Mon,  7 Mar 2022 05:13:11 +0530
Message-Id: <20220306234311.452206-6-memxor@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220306234311.452206-1-memxor@gmail.com>
References: <20220306234311.452206-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6576; h=from:subject; bh=OXZz41oVugK2/7L6N3ycV+OTCSur4CL6HLpmzD2oez4=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBiJUWoJznMM5rS0a5JMG902uKhYP4qtu8Mca9o8Ucm coegemaJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYiVFqAAKCRBM4MiGSL8RyuxpEA COV26IS1uGo85apqHNO1zlSf8il4NxnYojYQ1jMEKDcqb+E+IPiUTuu26dWXLPdiSbms/zfJ/m3Uef WA7UKrOmO6+/a7IBtmpjbvSFGfauA29EjmWI4NwzwZCLE2sHXpoK1HbnPLdkvn5RsicATgaVjotdfN FUypDdl8l/r6+3uzT9E4mWJtHgZv2ERP5GPmE1dZdynm75eyfUlQLja0AtRbphjcF2gAUyvcht6EgJ 1LyJxO/Lz9g1yI4L2l7BZFfD4dCrrTo/LCFhvZq+L07JZoFABlc/vxVMVvtP7t4WxJwatLfUhNslf8 IuHKIGcwd00r9SQqZg+PoMqIuHYrGzSNKYBsxTbm2FXTTe0VdJIUvqPAc0kZB5uCuUFGxGhZBgcNbs B21TWnC//R1oJutDhkbUkWjgLnmmi2IvqjI40LxU/38WONXtZfr1Hlb2tr7po6aTsZaWHRqQDBVPip vT3qbJlQSTQqXJejU5YKKtEJFirhnQHeqricQ4MKaTj/Vycr21fVeHMmP9hAIo0RJjJYlPTFVJV1sV z7/+s3p8jIGTU2yGDBrKOgEzdCeiXQuq0bYQ5i9vxUG9ByIKxalB4BQ5hxdW8gVJnbD/HUdO1bEk6K hbWCoE16vlp+IumeqecBoLA5o0cAXS7ul9FTKjyD6JG6YTK40RgoKmyxVnng==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
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

Test that in case of linear region, we always are able to do DPA without
any errors. Note how offset is clamped to range [0, 0xffff] and len is a
constant. Ensure that helper vs DPA is detected and tested.

Add a force_helper mode, that forces use of bpf_xdp_load_bytes and
bpf_xdp_store_bytes instead of using bpf_packet_pointer, even for
contiguous regions, to make sure that case keeps working.

Also, we can take this opportunity to convert it to use BPF skeleton.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 .../bpf/prog_tests/xdp_adjust_frags.c         | 46 +++++++++++++------
 .../bpf/progs/test_xdp_update_frags.c         | 46 +++++++++++++------
 2 files changed, 65 insertions(+), 27 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_frags.c b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_frags.c
index 2f033da4cd45..cfb50a575b11 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_frags.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_frags.c
@@ -2,26 +2,24 @@
 #include <test_progs.h>
 #include <network_helpers.h>
 
-static void test_xdp_update_frags(void)
+#include "test_xdp_update_frags.skel.h"
+
+static void test_xdp_update_frags(bool force_helper)
 {
-	const char *file = "./test_xdp_update_frags.o";
 	int err, prog_fd, max_skb_frags, buf_size, num;
-	struct bpf_program *prog;
-	struct bpf_object *obj;
+	LIBBPF_OPTS(bpf_test_run_opts, topts);
+	struct test_xdp_update_frags *skel;
 	__u32 *offset;
 	__u8 *buf;
 	FILE *f;
-	LIBBPF_OPTS(bpf_test_run_opts, topts);
 
-	obj = bpf_object__open(file);
-	if (libbpf_get_error(obj))
+	skel = test_xdp_update_frags__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "test_xdp_update_frags__open_and_load"))
 		return;
 
-	prog = bpf_object__next_program(obj, NULL);
-	if (bpf_object__load(obj))
-		return;
+	skel->bss->force_helper = force_helper;
 
-	prog_fd = bpf_program__fd(prog);
+	prog_fd = bpf_program__fd(skel->progs.xdp_adjust_frags);
 
 	buf = malloc(128);
 	if (!ASSERT_OK_PTR(buf, "alloc buf 128b"))
@@ -45,6 +43,13 @@ static void test_xdp_update_frags(void)
 	ASSERT_EQ(topts.retval, XDP_PASS, "xdp_update_frag retval");
 	ASSERT_EQ(buf[16], 0xbb, "xdp_update_frag buf[16]");
 	ASSERT_EQ(buf[31], 0xbb, "xdp_update_frag buf[31]");
+	if (force_helper) {
+		ASSERT_EQ(skel->bss->used_dpa, false, "did not use DPA");
+		ASSERT_EQ(skel->bss->used_helper, true, "used helper");
+	} else {
+		ASSERT_EQ(skel->bss->used_dpa, true, "used DPA");
+		ASSERT_EQ(skel->bss->used_helper, false, "did not use helper");
+	}
 
 	free(buf);
 
@@ -70,6 +75,13 @@ static void test_xdp_update_frags(void)
 	ASSERT_EQ(topts.retval, XDP_PASS, "xdp_update_frag retval");
 	ASSERT_EQ(buf[5000], 0xbb, "xdp_update_frag buf[5000]");
 	ASSERT_EQ(buf[5015], 0xbb, "xdp_update_frag buf[5015]");
+	if (force_helper) {
+		ASSERT_EQ(skel->bss->used_dpa, false, "did not use DPA");
+		ASSERT_EQ(skel->bss->used_helper, true, "used helper");
+	} else {
+		ASSERT_EQ(skel->bss->used_dpa, true, "used DPA");
+		ASSERT_EQ(skel->bss->used_helper, false, "did not use helper");
+	}
 
 	memset(buf, 0, 9000);
 	offset = (__u32 *)buf;
@@ -84,6 +96,8 @@ static void test_xdp_update_frags(void)
 	ASSERT_EQ(topts.retval, XDP_PASS, "xdp_update_frag retval");
 	ASSERT_EQ(buf[3510], 0xbb, "xdp_update_frag buf[3510]");
 	ASSERT_EQ(buf[3525], 0xbb, "xdp_update_frag buf[3525]");
+	ASSERT_EQ(skel->bss->used_dpa, false, "did not use DPA");
+	ASSERT_EQ(skel->bss->used_helper, true, "used helper");
 
 	memset(buf, 0, 9000);
 	offset = (__u32 *)buf;
@@ -98,6 +112,8 @@ static void test_xdp_update_frags(void)
 	ASSERT_EQ(topts.retval, XDP_PASS, "xdp_update_frag retval");
 	ASSERT_EQ(buf[7606], 0xbb, "xdp_update_frag buf[7606]");
 	ASSERT_EQ(buf[7621], 0xbb, "xdp_update_frag buf[7621]");
+	ASSERT_EQ(skel->bss->used_dpa, false, "did not use DPA");
+	ASSERT_EQ(skel->bss->used_helper, true, "used helper");
 
 	free(buf);
 
@@ -136,11 +152,13 @@ static void test_xdp_update_frags(void)
 		  "unsupported buf size, possible non-default /proc/sys/net/core/max_skb_flags?");
 	free(buf);
 out:
-	bpf_object__close(obj);
+	test_xdp_update_frags__destroy(skel);
 }
 
 void test_xdp_adjust_frags(void)
 {
-	if (test__start_subtest("xdp_adjust_frags"))
-		test_xdp_update_frags();
+	if (test__start_subtest("xdp_adjust_frags-force-nodpa"))
+		test_xdp_update_frags(true);
+	if (test__start_subtest("xdp_adjust_frags-dpa+memcpy"))
+		test_xdp_update_frags(false);
 }
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_update_frags.c b/tools/testing/selftests/bpf/progs/test_xdp_update_frags.c
index 2a3496d8e327..1ad5c45e06e0 100644
--- a/tools/testing/selftests/bpf/progs/test_xdp_update_frags.c
+++ b/tools/testing/selftests/bpf/progs/test_xdp_update_frags.c
@@ -4,37 +4,57 @@
  * modify it under the terms of version 2 of the GNU General Public
  * License as published by the Free Software Foundation.
  */
-#include <linux/bpf.h>
-#include <linux/if_ether.h>
+#include <vmlinux.h>
 #include <bpf/bpf_helpers.h>
 
 int _version SEC("version") = 1;
 
+bool force_helper;
+bool used_dpa;
+bool used_helper;
+
+#define XDP_LEN 16
+
 SEC("xdp.frags")
 int xdp_adjust_frags(struct xdp_md *xdp)
 {
 	__u8 *data_end = (void *)(long)xdp->data_end;
 	__u8 *data = (void *)(long)xdp->data;
-	__u8 val[16] = {};
+	__u8 val[XDP_LEN] = {};
+	__u8 *ptr = NULL;
 	__u32 offset;
 	int err;
 
+	used_dpa = false;
+	used_helper = false;
+
 	if (data + sizeof(__u32) > data_end)
 		return XDP_DROP;
 
 	offset = *(__u32 *)data;
-	err = bpf_xdp_load_bytes(xdp, offset, val, sizeof(val));
-	if (err < 0)
+	offset &= 0xffff;
+	if (!force_helper)
+		ptr = bpf_packet_pointer(xdp, offset, XDP_LEN);
+	if (!ptr) {
+		used_helper = true;
+		err = bpf_xdp_load_bytes(xdp, offset, val, sizeof(val));
+		if (err < 0)
+			return XDP_DROP;
+		ptr = val;
+	} else {
+		used_dpa = true;
+	}
+
+	if (ptr[0] != 0xaa || ptr[15] != 0xaa) /* marker */
 		return XDP_DROP;
 
-	if (val[0] != 0xaa || val[15] != 0xaa) /* marker */
-		return XDP_DROP;
-
-	val[0] = 0xbb; /* update the marker */
-	val[15] = 0xbb;
-	err = bpf_xdp_store_bytes(xdp, offset, val, sizeof(val));
-	if (err < 0)
-		return XDP_DROP;
+	ptr[0] = 0xbb; /* update the marker */
+	ptr[15] = 0xbb;
+	if (ptr == val) {
+		err = bpf_xdp_store_bytes(xdp, offset, val, sizeof(val));
+		if (err < 0)
+			return XDP_DROP;
+	}
 
 	return XDP_PASS;
 }
-- 
2.35.1


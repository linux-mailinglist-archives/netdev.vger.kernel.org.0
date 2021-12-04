Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74121468541
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 15:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385154AbhLDOKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 09:10:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59290 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1385108AbhLDOKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 09:10:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638626843;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xJf9C0dhuJV/fGk+WK+oK43/VAjCjanQdJUfa6jH1EQ=;
        b=DBrWw/kszsYYuXDLgdyliEl5pSqbeNxMAnR8lMPGFOvClZbNV/C/givJgBBDPSCTVxg+hY
        2el9AaweFuCOx4tmu9Gks3dw0PAqbLdJ8sHAlUkYb/syPmjKDb6zGEDy85ymnCZePVzZii
        06Lyclh2s5Ag9vq0VbInPaksMEY7qTA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-490-zTeqYRJQMpiaB76ZPCkmNg-1; Sat, 04 Dec 2021 09:07:22 -0500
X-MC-Unique: zTeqYRJQMpiaB76ZPCkmNg-1
Received: by mail-wm1-f70.google.com with SMTP id r129-20020a1c4487000000b00333629ed22dso5118763wma.6
        for <netdev@vger.kernel.org>; Sat, 04 Dec 2021 06:07:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xJf9C0dhuJV/fGk+WK+oK43/VAjCjanQdJUfa6jH1EQ=;
        b=1aQjHcuyDU9Dn8fTnxa0oX1AGqCNzcOVMnEafNSXdo/+/q/T7K62t4hawhDScoeAm6
         hkg1UsjGSbMIEhUv5PJ7+/9JSCpElgO+4KRvEfBRG8GhYvzooHiSaWAzBjFxnpqGZAOs
         tbGyGGO3B0bAhWEvxHhR9TxTj7FqyI/DfSIE8d+tre0RXyYs/pqGzS+9A1uyuqwHqzph
         fZfiFUYK2bHj3F8rto8+9jnebNuKPatICoWXGYDp4ZMNqyCcUQGtmQjnriXQkWyaoetc
         6eVTcn/C0HEY9CCH6hX4Va0l4VrJOdV9YMEdrM3CiCESfx4Tk6m2HdTd4S9U/uTpc6Lb
         H+WA==
X-Gm-Message-State: AOAM532Ek8sDRGDax989rJ0hRTeYLH69NXkAgj4m81+0hryNSmEQi2+c
        nmYkjkKgipPH6yBof2u27i1ug01oIONkQDDDPAvaZRuziS8D2qc+ncJhv1oCTc64hPTIyXEhcWJ
        DCKNfPVRSDI7waOgF
X-Received: by 2002:a5d:668d:: with SMTP id l13mr29008090wru.526.1638626841190;
        Sat, 04 Dec 2021 06:07:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwFCANVYaPz6Xh18KXAWYo8vePvEtaC0QfF327uDX68NOoVG67qXW5ATetlU2gakUrOzc7tfg==
X-Received: by 2002:a5d:668d:: with SMTP id l13mr29008065wru.526.1638626841023;
        Sat, 04 Dec 2021 06:07:21 -0800 (PST)
Received: from krava.redhat.com (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id d9sm5573503wre.52.2021.12.04.06.07.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Dec 2021 06:07:20 -0800 (PST)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: [PATCH bpf-next 3/3] selftests/bpf: Add tests for get_func_[arg|ret|arg_cnt] helpers
Date:   Sat,  4 Dec 2021 15:07:00 +0100
Message-Id: <20211204140700.396138-4-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211204140700.396138-1-jolsa@kernel.org>
References: <20211204140700.396138-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding tests for get_func_[arg|ret|arg_cnt] helpers.
Using these helpers in fentry/fexit/fmod_ret programs.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../bpf/prog_tests/get_func_args_test.c       |  38 ++++++
 .../selftests/bpf/progs/get_func_args_test.c  | 112 ++++++++++++++++++
 2 files changed, 150 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/get_func_args_test.c
 create mode 100644 tools/testing/selftests/bpf/progs/get_func_args_test.c

diff --git a/tools/testing/selftests/bpf/prog_tests/get_func_args_test.c b/tools/testing/selftests/bpf/prog_tests/get_func_args_test.c
new file mode 100644
index 000000000000..c24807ae4361
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/get_func_args_test.c
@@ -0,0 +1,38 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include "get_func_args_test.skel.h"
+
+void test_get_func_args_test(void)
+{
+	struct get_func_args_test *skel = NULL;
+	__u32 duration = 0, retval;
+	int err, prog_fd;
+
+	skel = get_func_args_test__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "get_func_args_test__open_and_load"))
+		return;
+
+	err = get_func_args_test__attach(skel);
+	if (!ASSERT_OK(err, "get_func_args_test__attach"))
+		goto cleanup;
+
+	prog_fd = bpf_program__fd(skel->progs.test1);
+	err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
+				NULL, NULL, &retval, &duration);
+	ASSERT_OK(err, "test_run");
+	ASSERT_EQ(retval, 0, "test_run");
+
+	prog_fd = bpf_program__fd(skel->progs.fmod_ret_test);
+	err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
+				NULL, NULL, &retval, &duration);
+	ASSERT_OK(err, "test_run");
+	ASSERT_EQ(retval, 1234, "test_run");
+
+	ASSERT_EQ(skel->bss->test1_result, 1, "test1_result");
+	ASSERT_EQ(skel->bss->test2_result, 1, "test2_result");
+	ASSERT_EQ(skel->bss->test3_result, 1, "test3_result");
+	ASSERT_EQ(skel->bss->test4_result, 1, "test4_result");
+
+cleanup:
+	get_func_args_test__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/get_func_args_test.c b/tools/testing/selftests/bpf/progs/get_func_args_test.c
new file mode 100644
index 000000000000..0d0a67c849ae
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/get_func_args_test.c
@@ -0,0 +1,112 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include <errno.h>
+
+char _license[] SEC("license") = "GPL";
+
+__u64 test1_result = 0;
+SEC("fentry/bpf_fentry_test1")
+int BPF_PROG(test1)
+{
+	__u64 cnt = bpf_get_func_arg_cnt(ctx);
+	__u64 a = 0, z = 0, ret = 0;
+	__s64 err;
+
+	test1_result = cnt == 1;
+
+	/* valid arguments */
+	err = bpf_get_func_arg(ctx, 0, &a);
+	test1_result &= err == 0 && (int) a == 1;
+
+	/* not valid argument */
+	err = bpf_get_func_arg(ctx, 1, &z);
+	test1_result &= err == -EINVAL;
+
+	/* return value fails in fentry */
+	err = bpf_get_func_ret(ctx, &ret);
+	test1_result &= err == -EINVAL;
+	return 0;
+}
+
+__u64 test2_result = 0;
+SEC("fexit/bpf_fentry_test2")
+int BPF_PROG(test2)
+{
+	__u64 cnt = bpf_get_func_arg_cnt(ctx);
+	__u64 a = 0, b = 0, z = 0, ret = 0;
+	__s64 err;
+
+	test2_result = cnt == 2;
+
+	/* valid arguments */
+	err = bpf_get_func_arg(ctx, 0, &a);
+	test2_result &= err == 0 && (int) a == 2;
+
+	err = bpf_get_func_arg(ctx, 1, &b);
+	test2_result &= err == 0 && b == 3;
+
+	/* not valid argument */
+	err = bpf_get_func_arg(ctx, 2, &z);
+	test2_result &= err == -EINVAL;
+
+	/* return value */
+	err = bpf_get_func_ret(ctx, &ret);
+	test2_result &= err == 0 && ret == 5;
+	return 0;
+}
+
+__u64 test3_result = 0;
+SEC("fmod_ret/bpf_modify_return_test")
+int BPF_PROG(fmod_ret_test, int _a, int *_b, int _ret)
+{
+	__u64 cnt = bpf_get_func_arg_cnt(ctx);
+	__u64 a = 0, b = 0, z = 0, ret = 0;
+	__s64 err;
+
+	test3_result = cnt == 2;
+
+	/* valid arguments */
+	err = bpf_get_func_arg(ctx, 0, &a);
+	test3_result &= err == 0 && (int) a == 1;
+
+	err = bpf_get_func_arg(ctx, 1, &b);
+	test3_result &= err == 0;
+
+	/* not valid argument */
+	err = bpf_get_func_arg(ctx, 2, &z);
+	test3_result &= err == -EINVAL;
+
+	/* return value */
+	err = bpf_get_func_ret(ctx, &ret);
+	test3_result &= err == 0 && ret == 0;
+	return 1234;
+}
+
+__u64 test4_result = 0;
+SEC("fexit/bpf_modify_return_test")
+int BPF_PROG(fexit_test, int _a, __u64 _b, int _ret)
+{
+	__u64 cnt = bpf_get_func_arg_cnt(ctx);
+	__u64 a = 0, b = 0, z = 0, ret = 0;
+	__s64 err;
+
+	test4_result = cnt == 2;
+
+	/* valid arguments */
+	err = bpf_get_func_arg(ctx, 0, &a);
+	test4_result &= err == 0 && (int) a == 1;
+
+	err = bpf_get_func_arg(ctx, 1, &b);
+	test4_result &= err == 0;
+
+	/* not valid argument */
+	err = bpf_get_func_arg(ctx, 2, &z);
+	test4_result &= err == -EINVAL;
+
+	/* return value */
+	err = bpf_get_func_ret(ctx, &ret);
+	test4_result &= err == 0 && ret == 1234;
+	return 0;
+}
-- 
2.33.1


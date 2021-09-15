Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14F1C40BE21
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 05:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235259AbhIODZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 23:25:12 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:9871 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbhIODZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 23:25:12 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4H8QRx5Hw6z8yX3;
        Wed, 15 Sep 2021 11:19:25 +0800 (CST)
Received: from dggpeml500025.china.huawei.com (7.185.36.35) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 15 Sep 2021 11:23:52 +0800
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Wed, 15 Sep
 2021 11:23:51 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <houtao1@huawei.com>
Subject: [RFC PATCH bpf-next 2/3] selftests/bpf: call dummy struct_ops in bpf_testmode
Date:   Wed, 15 Sep 2021 11:37:52 +0800
Message-ID: <20210915033753.1201597-3-houtao1@huawei.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210915033753.1201597-1-houtao1@huawei.com>
References: <20210915033753.1201597-1-houtao1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dummy BPF STRUCT_OPS in kernel, in order to test it, we need
provide a way to call its method and return state to userspace.

So a new sysfs file /sys/kernel/bpf_test/dummy_ops_ctl is created.
Its expected input is: "test_case_name [optinal_integer_state]",
When the content is written to the file, the specific method of
dummy struct_ops will be called and the returned state will be checked.

Now only two test cases are added: one to check the return value of
init() method, another to check the value returned by pointer
assignment.

It may be better to split the dummy struct_ops related code into
a separated file.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 .../selftests/bpf/bpf_testmod/bpf_testmod.c   | 152 +++++++++++++++++-
 1 file changed, 150 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
index 141d8da687d2..1286758b999c 100644
--- a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
+++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
@@ -6,11 +6,22 @@
 #include <linux/percpu-defs.h>
 #include <linux/sysfs.h>
 #include <linux/tracepoint.h>
+#include <linux/string.h>
+#include <linux/bpf_dummy_ops.h>
 #include "bpf_testmod.h"
 
 #define CREATE_TRACE_POINTS
 #include "bpf_testmod-events.h"
 
+typedef int (*dummy_ops_test_fn)(struct bpf_dummy_ops *ops,
+				 const char *buf, size_t cnt);
+struct dummy_ops_test {
+	const char *name;
+	dummy_ops_test_fn fn;
+};
+
+static struct kobject *bpf_test_kobj;
+
 DEFINE_PER_CPU(int, bpf_testmod_ksym_percpu) = 123;
 
 noinline ssize_t
@@ -55,14 +66,151 @@ static struct bin_attribute bin_attr_bpf_testmod_file __ro_after_init = {
 	.write = bpf_testmod_test_write,
 };
 
+static int dummy_ops_chk_ret(struct bpf_dummy_ops *ops,
+			     const char *buf, size_t cnt)
+{
+	int exp;
+	int err;
+
+	if (cnt <= 1)
+		return -EINVAL;
+
+	if (kstrtoint(buf + 1, 0, &exp))
+		return -EINVAL;
+
+	err = ops->init(NULL);
+	if (err != exp)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int dummy_ops_chk_ret_by_ptr(struct bpf_dummy_ops *ops,
+				    const char *buf, size_t cnt)
+{
+	int exp;
+	int err;
+	struct bpf_dummy_ops_state state;
+
+	if (cnt <= 1)
+		return -EINVAL;
+
+	if (kstrtoint(buf + 1, 0, &exp))
+		return -EINVAL;
+
+	memset(&state, 0, sizeof(state));
+	err = ops->init(&state);
+	if (err || state.val != exp)
+		return -EINVAL;
+
+	return 0;
+}
+
+static const struct dummy_ops_test tests[] = {
+	{.name = "init_1", .fn = dummy_ops_chk_ret},
+	{.name = "init_2", .fn = dummy_ops_chk_ret_by_ptr},
+};
+
+static const struct dummy_ops_test *dummy_ops_find_test(const char *buf,
+							size_t cnt)
+{
+	char *c;
+	size_t nm_len;
+	unsigned int i;
+
+	/*
+	 * There may be test-specific string (e.g, return value)
+	 * after the name of test. The delimiter is one space.
+	 */
+	c = strchr(buf, ' ');
+	if (c)
+		nm_len = c - buf;
+	else
+		nm_len = cnt;
+	for (i = 0; i < ARRAY_SIZE(tests); i++) {
+		if (nm_len >= strlen(tests[i].name) &&
+		    !strncmp(buf, tests[i].name, nm_len))
+			return &tests[i];
+	}
+
+	return NULL;
+}
+
+static ssize_t dummy_ops_ctl_store(struct kobject *kobj,
+				   struct kobj_attribute *attr,
+				   const char *buf, size_t cnt)
+{
+	struct bpf_dummy_ops *ops = bpf_get_dummy_ops();
+	const struct dummy_ops_test *test;
+	size_t nm_len;
+	int err;
+
+	/* dummy struct_ops is disabled, so always return success */
+	if (!ops)
+		return cnt;
+	if (IS_ERR(ops))
+		return PTR_ERR(ops);
+
+	test = dummy_ops_find_test(buf, cnt);
+	if (!test) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	nm_len = strlen(test->name);
+	err = test->fn(ops, buf + nm_len, cnt - nm_len);
+	if (!err)
+		err = cnt;
+out:
+	bpf_put_dummy_ops(ops);
+	return err;
+}
+
+static struct kobj_attribute dummy_ops_ctl = __ATTR_WO(dummy_ops_ctl);
+
+static struct attribute *bpf_test_attrs[] = {
+	&dummy_ops_ctl.attr,
+	NULL,
+};
+
+static const struct attribute_group bpf_test_attr_group = {
+	.attrs = bpf_test_attrs,
+};
+
 static int bpf_testmod_init(void)
 {
-	return sysfs_create_bin_file(kernel_kobj, &bin_attr_bpf_testmod_file);
+	int err;
+
+	bpf_test_kobj = kobject_create_and_add("bpf_test", kernel_kobj);
+	if (!bpf_test_kobj) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	err = sysfs_create_group(bpf_test_kobj, &bpf_test_attr_group);
+	if (err)
+		goto put_out;
+
+	err = sysfs_create_bin_file(kernel_kobj, &bin_attr_bpf_testmod_file);
+	if (err)
+		goto rm_grp_out;
+
+	return 0;
+
+rm_grp_out:
+	sysfs_remove_group(bpf_test_kobj, &bpf_test_attr_group);
+put_out:
+	kobject_put(bpf_test_kobj);
+	bpf_test_kobj = NULL;
+out:
+	return err;
 }
 
 static void bpf_testmod_exit(void)
 {
-	return sysfs_remove_bin_file(kernel_kobj, &bin_attr_bpf_testmod_file);
+	sysfs_remove_bin_file(kernel_kobj, &bin_attr_bpf_testmod_file);
+	sysfs_remove_group(bpf_test_kobj, &bpf_test_attr_group);
+	kobject_put(bpf_test_kobj);
 }
 
 module_init(bpf_testmod_init);
-- 
2.29.2


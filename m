Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E54794C2A6F
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 12:09:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233592AbiBXLKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 06:10:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233830AbiBXLKJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 06:10:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0DB3114F2B0
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 03:09:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645700979;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4xV2lmIzjMYY4MLS/LARIvSo701YdKE1gxInO7k6PmQ=;
        b=dm2usxyeiNDimHLqXlreBnTixbnqXKdNQltDEusPcS9Et8lPyKC9CKXqJTJshRgYM/5Gn0
        DkFhUIXcATbqh6GJzJ2QRNbeZ3jc1RBAffw3xjK2MtGnKJS89HeUj7MNMHOfhsct57m9sB
        maMCVZSNooK8N2OjlaWp1Ru872teSlk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-507-NF33J5o-OI60gJ1uevKL0w-1; Thu, 24 Feb 2022 06:09:35 -0500
X-MC-Unique: NF33J5o-OI60gJ1uevKL0w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 72DF3800496;
        Thu, 24 Feb 2022 11:09:33 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.194.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BB50C79A22;
        Thu, 24 Feb 2022 11:09:18 +0000 (UTC)
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>
Cc:     Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH bpf-next v1 4/6] HID: bpf: add new BPF type to trigger commands from userspace
Date:   Thu, 24 Feb 2022 12:08:26 +0100
Message-Id: <20220224110828.2168231-5-benjamin.tissoires@redhat.com>
In-Reply-To: <20220224110828.2168231-1-benjamin.tissoires@redhat.com>
References: <20220224110828.2168231-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Given that we can not call bpf_hid_raw_request() from within an IRQ,
userspace needs to have a way to communicate with the device when
it needs.

Implement a new type that the caller can run at will without being in
an IRQ context.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 include/linux/bpf-hid.h                      |   3 +
 include/uapi/linux/bpf.h                     |   1 +
 include/uapi/linux/bpf_hid.h                 |   9 ++
 kernel/bpf/hid.c                             | 117 +++++++++++++++++++
 kernel/bpf/syscall.c                         |   2 +
 tools/include/uapi/linux/bpf.h               |   1 +
 tools/lib/bpf/libbpf.c                       |   1 +
 tools/testing/selftests/bpf/prog_tests/hid.c |  56 +++++++++
 tools/testing/selftests/bpf/progs/hid.c      |  10 ++
 9 files changed, 200 insertions(+)

diff --git a/include/linux/bpf-hid.h b/include/linux/bpf-hid.h
index 07cbd5cf595c..00ac4555aa5b 100644
--- a/include/linux/bpf-hid.h
+++ b/include/linux/bpf-hid.h
@@ -15,6 +15,7 @@ enum bpf_hid_attach_type {
 	BPF_HID_ATTACH_INVALID = -1,
 	BPF_HID_ATTACH_DEVICE_EVENT = 0,
 	BPF_HID_ATTACH_RDESC_FIXUP,
+	BPF_HID_ATTACH_USER_EVENT,
 	MAX_BPF_HID_ATTACH_TYPE
 };
 
@@ -34,6 +35,8 @@ to_bpf_hid_attach_type(enum bpf_attach_type attach_type)
 		return BPF_HID_ATTACH_DEVICE_EVENT;
 	case BPF_HID_RDESC_FIXUP:
 		return BPF_HID_ATTACH_RDESC_FIXUP;
+	case BPF_HID_USER_EVENT:
+		return BPF_HID_ATTACH_USER_EVENT;
 	default:
 		return BPF_HID_ATTACH_INVALID;
 	}
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 0571d9b954c9..a374cc4aade6 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1000,6 +1000,7 @@ enum bpf_attach_type {
 	BPF_PERF_EVENT,
 	BPF_HID_DEVICE_EVENT,
 	BPF_HID_RDESC_FIXUP,
+	BPF_HID_USER_EVENT,
 	__MAX_BPF_ATTACH_TYPE
 };
 
diff --git a/include/uapi/linux/bpf_hid.h b/include/uapi/linux/bpf_hid.h
index c0801d7174c3..7a263568e132 100644
--- a/include/uapi/linux/bpf_hid.h
+++ b/include/uapi/linux/bpf_hid.h
@@ -19,6 +19,7 @@ enum hid_bpf_event {
 	HID_BPF_UNDEF = 0,
 	HID_BPF_DEVICE_EVENT,
 	HID_BPF_RDESC_FIXUP,
+	HID_BPF_USER_EVENT,
 };
 
 /* type is HID_BPF_DEVICE_EVENT */
@@ -33,6 +34,13 @@ struct hid_bpf_ctx_rdesc_fixup {
 	unsigned long size;
 };
 
+/* type is HID_BPF_USER_EVENT */
+struct hid_bpf_ctx_user_event {
+	__u8 data[HID_BPF_MAX_BUFFER_SIZE];
+	unsigned long size;
+	int retval;
+};
+
 struct hid_bpf_ctx {
 	enum hid_bpf_event type;
 	struct hid_device *hdev;
@@ -40,6 +48,7 @@ struct hid_bpf_ctx {
 	union {
 		struct hid_bpf_ctx_device_event device;
 		struct hid_bpf_ctx_rdesc_fixup rdesc;
+		struct hid_bpf_ctx_user_event user;
 	} u;
 };
 
diff --git a/kernel/bpf/hid.c b/kernel/bpf/hid.c
index 9eb7bd6ac6c8..3714413e1eb6 100644
--- a/kernel/bpf/hid.c
+++ b/kernel/bpf/hid.c
@@ -52,6 +52,9 @@ BPF_CALL_3(bpf_hid_get_data, void*, ctx, u64, offset, u8, n)
 	case HID_BPF_RDESC_FIXUP:
 		buf = bpf_ctx->u.rdesc.data;
 		break;
+	case HID_BPF_USER_EVENT:
+		buf = bpf_ctx->u.user.data;
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -83,6 +86,9 @@ BPF_CALL_4(bpf_hid_set_data, void*, ctx, u64, offset, u8, n, u32, data)
 	case HID_BPF_RDESC_FIXUP:
 		buf = bpf_ctx->u.rdesc.data;
 		break;
+	case HID_BPF_USER_EVENT:
+		buf = bpf_ctx->u.user.data;
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -385,6 +391,8 @@ static int bpf_hid_max_progs(enum bpf_hid_attach_type type)
 		return 64;
 	case BPF_HID_ATTACH_RDESC_FIXUP:
 		return 1;
+	case BPF_HID_ATTACH_USER_EVENT:
+		return 64;
 	default:
 		return 0;
 	}
@@ -479,7 +487,116 @@ int bpf_hid_link_create(const union bpf_attr *attr, struct bpf_prog *prog)
 	return bpf_link_settle(&link_primer);
 }
 
+static int hid_bpf_prog_test_run(struct bpf_prog *prog,
+				 const union bpf_attr *attr,
+				 union bpf_attr __user *uattr)
+{
+	struct hid_device *hdev = NULL;
+	struct bpf_prog_array *progs;
+	struct hid_bpf_ctx *ctx = NULL;
+	bool valid_prog = false;
+	int i;
+	int target_fd, ret;
+	void __user *data_out = u64_to_user_ptr(attr->test.data_out);
+	void __user *data_in = u64_to_user_ptr(attr->test.data_in);
+	u32 user_size = attr->test.data_size_in;
+
+	if (!hid_hooks.hdev_from_fd)
+		return -EOPNOTSUPP;
+
+	if (attr->test.ctx_size_in != sizeof(int))
+		return -EINVAL;
+
+	if (copy_from_user(&target_fd, (void *)attr->test.ctx_in, attr->test.ctx_size_in))
+		return -EFAULT;
+
+	hdev = hid_hooks.hdev_from_fd(target_fd);
+	if (IS_ERR(hdev))
+		return PTR_ERR(hdev);
+
+	ret = mutex_lock_interruptible(&bpf_hid_mutex);
+	if (ret)
+		return ret;
+
+	/* check if the given program is of correct type and registered */
+	progs = rcu_dereference_protected(hdev->bpf.run_array[BPF_HID_ATTACH_USER_EVENT],
+					  lockdep_is_held(&bpf_hid_mutex));
+	if (!progs) {
+		ret = -EFAULT;
+		goto unlock;
+	}
+
+	for (i = 0; i < bpf_prog_array_length(progs); i++) {
+		if (progs->items[i].prog == prog) {
+			valid_prog = true;
+			break;
+		}
+	}
+
+	if (!valid_prog) {
+		ret = -EINVAL;
+		goto unlock;
+	}
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx) {
+		ret = -ENOMEM;
+		goto unlock;
+	}
+
+	ctx->hdev = hdev;
+	ctx->type = HID_BPF_USER_EVENT;
+
+	/* copy data_in from userspace */
+	if (user_size) {
+		if (user_size > HID_BPF_MAX_BUFFER_SIZE)
+			user_size = HID_BPF_MAX_BUFFER_SIZE;
+
+		if (copy_from_user(ctx->u.user.data, data_in, user_size)) {
+			ret = -EFAULT;
+			goto unlock;
+		}
+
+		ctx->u.user.size = user_size;
+	}
+
+	migrate_disable();
+
+	ret = bpf_prog_run(prog, ctx);
+
+	migrate_enable();
+
+	user_size = attr->test.data_size_out;
+
+	if (user_size && data_out) {
+		if (user_size > ctx->u.user.size)
+			user_size = ctx->u.user.size;
+
+		if (copy_to_user(data_out, ctx->u.user.data, user_size)) {
+			ret = -EFAULT;
+			goto unlock;
+		}
+
+		if (copy_to_user(&uattr->test.data_size_out, &user_size, sizeof(user_size))) {
+			ret = -EFAULT;
+			goto unlock;
+		}
+	}
+
+	if (copy_to_user(&uattr->test.retval, &ctx->u.user.retval, sizeof(ctx->u.user.retval))) {
+		ret = -EFAULT;
+		goto unlock;
+	}
+
+unlock:
+	kfree(ctx);
+
+	mutex_unlock(&bpf_hid_mutex);
+	return ret;
+}
+
 const struct bpf_prog_ops hid_prog_ops = {
+	.test_run = hid_bpf_prog_test_run,
 };
 
 int bpf_hid_init(struct hid_device *hdev)
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 62889cc71a02..0a6d08dabe59 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3192,6 +3192,7 @@ attach_type_to_prog_type(enum bpf_attach_type attach_type)
 		return BPF_PROG_TYPE_XDP;
 	case BPF_HID_DEVICE_EVENT:
 	case BPF_HID_RDESC_FIXUP:
+	case BPF_HID_USER_EVENT:
 		return BPF_PROG_TYPE_HID;
 	default:
 		return BPF_PROG_TYPE_UNSPEC;
@@ -3338,6 +3339,7 @@ static int bpf_prog_query(const union bpf_attr *attr,
 		return sock_map_bpf_prog_query(attr, uattr);
 	case BPF_HID_DEVICE_EVENT:
 	case BPF_HID_RDESC_FIXUP:
+	case BPF_HID_USER_EVENT:
 		return bpf_hid_prog_query(attr, uattr);
 	default:
 		return -EINVAL;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 0571d9b954c9..a374cc4aade6 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1000,6 +1000,7 @@ enum bpf_attach_type {
 	BPF_PERF_EVENT,
 	BPF_HID_DEVICE_EVENT,
 	BPF_HID_RDESC_FIXUP,
+	BPF_HID_USER_EVENT,
 	__MAX_BPF_ATTACH_TYPE
 };
 
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index b7af873116fb..290864d2f865 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -8678,6 +8678,7 @@ static const struct bpf_sec_def section_defs[] = {
 	SEC_DEF("sk_lookup",		SK_LOOKUP, BPF_SK_LOOKUP, SEC_ATTACHABLE | SEC_SLOPPY_PFX),
 	SEC_DEF("hid/device_event",	HID, BPF_HID_DEVICE_EVENT, SEC_ATTACHABLE_OPT | SEC_SLOPPY_PFX),
 	SEC_DEF("hid/rdesc_fixup",	HID, BPF_HID_RDESC_FIXUP, SEC_ATTACHABLE_OPT | SEC_SLOPPY_PFX),
+	SEC_DEF("hid/user_event",	HID, BPF_HID_USER_EVENT, SEC_ATTACHABLE_OPT | SEC_SLOPPY_PFX),
 };
 
 #define MAX_TYPE_NAME_SIZE 32
diff --git a/tools/testing/selftests/bpf/prog_tests/hid.c b/tools/testing/selftests/bpf/prog_tests/hid.c
index 7d4f740a0a08..d297a571e910 100644
--- a/tools/testing/selftests/bpf/prog_tests/hid.c
+++ b/tools/testing/selftests/bpf/prog_tests/hid.c
@@ -336,6 +336,59 @@ static int test_hid_set_get_data(struct hid *hid_skel, int uhid_fd, int sysfs_fd
 	return ret;
 }
 
+/*
+ * Attach hid_user to the given uhid device,
+ * call the bpf program from userspace
+ * check that the program is called and does the expected.
+ */
+static int test_hid_user_call(struct hid *hid_skel, int uhid_fd, int sysfs_fd)
+{
+	int err, prog_fd;
+	u8 buf[10] = {0};
+	int ret = -1;
+
+	LIBBPF_OPTS(bpf_test_run_opts, run_attrs,
+		    .repeat = 1,
+		    .ctx_in = &sysfs_fd,
+		    .ctx_size_in = sizeof(sysfs_fd),
+		    .data_in = buf,
+		    .data_size_in = sizeof(buf),
+		    .data_out = buf,
+		    .data_size_out = sizeof(buf),
+	);
+
+	/* attach hid_user program */
+	hid_skel->links.hid_user = bpf_program__attach_hid(hid_skel->progs.hid_user, sysfs_fd);
+	if (!ASSERT_OK_PTR(hid_skel->links.hid_user,
+			   "attach_hid(hid_user)"))
+		return PTR_ERR(hid_skel->links.hid_user);
+
+	buf[0] = 39;
+
+	prog_fd = bpf_program__fd(hid_skel->progs.hid_user);
+
+	err = bpf_prog_test_run_opts(prog_fd, &run_attrs);
+	if (!ASSERT_EQ(err, 0, "bpf_prog_test_run_xattr"))
+		goto cleanup;
+
+	if (!ASSERT_EQ(run_attrs.retval, 72, "bpf_prog_test_run_xattr_retval"))
+		goto cleanup;
+
+	if (!ASSERT_EQ(buf[1], 42, "hid_user_check_in"))
+		goto cleanup;
+
+	if (!ASSERT_EQ(buf[2], 4, "hid_user_check_static_out"))
+		goto cleanup;
+
+	ret = 0;
+
+cleanup:
+
+	hid__detach(hid_skel);
+
+	return ret;
+}
+
 /*
  * Attach hid_rdesc_fixup to the given uhid device,
  * retrieve and open the matching hidraw node,
@@ -437,6 +490,9 @@ void serial_test_hid_bpf(void)
 	err = test_hid_set_get_data(hid_skel, uhid_fd, sysfs_fd);
 	ASSERT_OK(err, "hid_set_get_data");
 
+	err = test_hid_user_call(hid_skel, uhid_fd, sysfs_fd);
+	ASSERT_OK(err, "hid_user");
+
 	err = test_rdesc_fixup(hid_skel, uhid_fd, sysfs_fd);
 	ASSERT_OK(err, "hid_rdesc_fixup");
 
diff --git a/tools/testing/selftests/bpf/progs/hid.c b/tools/testing/selftests/bpf/progs/hid.c
index 01d9c556a3a1..b2db809b3367 100644
--- a/tools/testing/selftests/bpf/progs/hid.c
+++ b/tools/testing/selftests/bpf/progs/hid.c
@@ -80,3 +80,13 @@ int hid_set_get_data(struct hid_bpf_ctx *ctx)
 
 	return 0;
 }
+
+SEC("hid/user_event")
+int hid_user(struct hid_bpf_ctx *ctx)
+{
+	ctx->u.user.data[1] = ctx->u.user.data[0] + 3;
+	ctx->u.user.data[2] = 4;
+	ctx->u.user.retval = 72;
+
+	return 0;
+}
-- 
2.35.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAE994CDAC1
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 18:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241230AbiCDReb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 12:34:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241319AbiCDReN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 12:34:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8F37A5521C
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 09:33:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646415190;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=olWbYkTvC+e+vMVbk45dm+kEMM67iGwcmeNrgiVuKYI=;
        b=iWzO/iFKvP+PE/rWALG4v0W2Vkcy8i212KiraB9LqFkZVoJtDEOrlMLv9PIBBjcq5KFG8y
        AsCPNs3Kjwc0dAItPvOmaXsPP/Mmv7pEHUb4qq91bpa13OE+KODoL2eAI7SVR2xbWleslO
        SAalXhHbjFPtUV7fAZI45acXMdXUKF0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-198-G47TMMIbM7CXeohmMcgQ0w-1; Fri, 04 Mar 2022 12:33:07 -0500
X-MC-Unique: G47TMMIbM7CXeohmMcgQ0w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DCAF66C50A;
        Fri,  4 Mar 2022 17:33:04 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D69C28659E;
        Fri,  4 Mar 2022 17:32:44 +0000 (UTC)
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
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
Subject: [PATCH bpf-next v2 15/28] bpf/hid: add new BPF type to trigger commands from userspace
Date:   Fri,  4 Mar 2022 18:28:39 +0100
Message-Id: <20220304172852.274126-16-benjamin.tissoires@redhat.com>
In-Reply-To: <20220304172852.274126-1-benjamin.tissoires@redhat.com>
References: <20220304172852.274126-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

changes in v2:
- split the series by bpf/libbpf/hid/selftests and samples
- unsigned long -> __u16 in uapi/linux/bpf_hid.h
- int -> __32 in uapi/linux/bpf_hid.h
---
 include/linux/bpf-hid.h        |   3 +
 include/uapi/linux/bpf.h       |   1 +
 include/uapi/linux/bpf_hid.h   |  10 +++
 kernel/bpf/hid.c               | 116 +++++++++++++++++++++++++++++++++
 kernel/bpf/syscall.c           |   2 +
 tools/include/uapi/linux/bpf.h |   1 +
 6 files changed, 133 insertions(+)

diff --git a/include/linux/bpf-hid.h b/include/linux/bpf-hid.h
index 69bb28523ceb..4cf2e99109fe 100644
--- a/include/linux/bpf-hid.h
+++ b/include/linux/bpf-hid.h
@@ -16,6 +16,7 @@ enum bpf_hid_attach_type {
 	BPF_HID_ATTACH_INVALID = -1,
 	BPF_HID_ATTACH_DEVICE_EVENT = 0,
 	BPF_HID_ATTACH_RDESC_FIXUP,
+	BPF_HID_ATTACH_USER_EVENT,
 	MAX_BPF_HID_ATTACH_TYPE
 };
 
@@ -35,6 +36,8 @@ to_bpf_hid_attach_type(enum bpf_attach_type attach_type)
 		return BPF_HID_ATTACH_DEVICE_EVENT;
 	case BPF_HID_RDESC_FIXUP:
 		return BPF_HID_ATTACH_RDESC_FIXUP;
+	case BPF_HID_USER_EVENT:
+		return BPF_HID_ATTACH_USER_EVENT;
 	default:
 		return BPF_HID_ATTACH_INVALID;
 	}
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 4845a20e6f96..b3063384d380 100644
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
index 634f17c0b1cb..14a3c0405345 100644
--- a/include/uapi/linux/bpf_hid.h
+++ b/include/uapi/linux/bpf_hid.h
@@ -25,6 +25,12 @@ enum hid_bpf_event {
 	HID_BPF_UNDEF = 0,
 	HID_BPF_DEVICE_EVENT,		/* when attach type is BPF_HID_DEVICE_EVENT */
 	HID_BPF_RDESC_FIXUP,		/* ................... BPF_HID_RDESC_FIXUP */
+	HID_BPF_USER_EVENT,		/* ................... BPF_HID_USER_EVENT */
+};
+
+/* type is HID_BPF_USER_EVENT */
+struct hid_bpf_ctx_user_event {
+	__s32 retval;
 };
 
 struct hid_bpf_ctx {
@@ -32,6 +38,10 @@ struct hid_bpf_ctx {
 	__u16 allocated_size;		/* the allocated size of data below (RO) */
 	struct hid_device *hdev;	/* read-only */
 
+	union {
+		struct hid_bpf_ctx_user_event user;	/* read-write */
+	} u;
+
 	__u16 size;			/* used size in data (RW) */
 	__u8 data[];			/* data buffer (RW) */
 };
diff --git a/kernel/bpf/hid.c b/kernel/bpf/hid.c
index 640e55ba66ec..de003dbd7d01 100644
--- a/kernel/bpf/hid.c
+++ b/kernel/bpf/hid.c
@@ -370,6 +370,8 @@ static int bpf_hid_max_progs(enum bpf_hid_attach_type type)
 		return 64;
 	case BPF_HID_ATTACH_RDESC_FIXUP:
 		return 1;
+	case BPF_HID_ATTACH_USER_EVENT:
+		return 64;
 	default:
 		return 0;
 	}
@@ -464,7 +466,121 @@ int bpf_hid_link_create(const union bpf_attr *attr, struct bpf_prog *prog)
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
+	u32 user_size_in = attr->test.data_size_in;
+	u32 user_size_out = attr->test.data_size_out;
+
+	if (!hid_hooks.hdev_from_fd)
+		return -EOPNOTSUPP;
+
+	if (attr->test.ctx_size_in != sizeof(int))
+		return -EINVAL;
+
+	if (user_size_in > HID_BPF_MAX_BUFFER_SIZE)
+		return -E2BIG;
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
+	ctx = bpf_hid_allocate_ctx(hdev, max(user_size_in, user_size_out));
+	if (IS_ERR(ctx)) {
+		ret = PTR_ERR(ctx);
+		goto unlock;
+	}
+
+	ctx->type = HID_BPF_USER_EVENT;
+
+	/* copy data_in from userspace */
+	if (user_size_in) {
+		if (user_size_in > ctx->allocated_size) {
+			/* should never happen, given that size is < HID_BPF_MAX_BUFFER_SIZE */
+			ret = -E2BIG;
+			goto unlock;
+		}
+
+		if (copy_from_user(ctx->data, data_in, user_size_in)) {
+			ret = -EFAULT;
+			goto unlock;
+		}
+
+		ctx->size = user_size_in;
+	}
+
+	migrate_disable();
+
+	ret = bpf_prog_run(prog, ctx);
+
+	migrate_enable();
+
+	if (user_size_out && data_out) {
+		user_size_out = min3(user_size_out, (u32)ctx->size, (u32)ctx->allocated_size);
+
+		if (copy_to_user(data_out, ctx->data, user_size_out)) {
+			ret = -EFAULT;
+			goto unlock;
+		}
+
+		if (copy_to_user(&uattr->test.data_size_out,
+				 &user_size_out,
+				 sizeof(user_size_out))) {
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
index 7428a1a512c6..74d13ec826df 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3204,6 +3204,7 @@ attach_type_to_prog_type(enum bpf_attach_type attach_type)
 		return BPF_PROG_TYPE_XDP;
 	case BPF_HID_DEVICE_EVENT:
 	case BPF_HID_RDESC_FIXUP:
+	case BPF_HID_USER_EVENT:
 		return BPF_PROG_TYPE_HID;
 	default:
 		return BPF_PROG_TYPE_UNSPEC;
@@ -3350,6 +3351,7 @@ static int bpf_prog_query(const union bpf_attr *attr,
 		return sock_map_bpf_prog_query(attr, uattr);
 	case BPF_HID_DEVICE_EVENT:
 	case BPF_HID_RDESC_FIXUP:
+	case BPF_HID_USER_EVENT:
 		return bpf_hid_prog_query(attr, uattr);
 	default:
 		return -EINVAL;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 4845a20e6f96..b3063384d380 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1000,6 +1000,7 @@ enum bpf_attach_type {
 	BPF_PERF_EVENT,
 	BPF_HID_DEVICE_EVENT,
 	BPF_HID_RDESC_FIXUP,
+	BPF_HID_USER_EVENT,
 	__MAX_BPF_ATTACH_TYPE
 };
 
-- 
2.35.1


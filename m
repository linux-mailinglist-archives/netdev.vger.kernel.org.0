Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA074DDE61
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 17:18:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235735AbiCRQTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 12:19:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238746AbiCRQRs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 12:17:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B8B12200945
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 09:16:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647620187;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=St07ONfkvmvN0qLjqwmycr5927HY++X1tTrlEyiBJwM=;
        b=FjHu9SNmhqu9H+nPiJAe2IUGvcGEmr6UKVVuZ90F79wrOXNwtljbb1jGSsauZB4E0ep1w9
        5qORSOngLC0eJOfI7NM11hiLW1YSpbLu+/+5jLTi2TBmT+vHk3nF/qXoboBRK2WzmI/ucY
        K4qj/6j5NwsnnwfEwSLQVoSWsJYcW44=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-138-TLK_ueiRPpmZUr8d5FSMKA-1; Fri, 18 Mar 2022 12:16:24 -0400
X-MC-Unique: TLK_ueiRPpmZUr8d5FSMKA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F141C811E75;
        Fri, 18 Mar 2022 16:16:18 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2CD1033250;
        Fri, 18 Mar 2022 16:16:02 +0000 (UTC)
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
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>
Cc:     Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH bpf-next v3 02/17] bpf: introduce hid program type
Date:   Fri, 18 Mar 2022 17:15:13 +0100
Message-Id: <20220318161528.1531164-3-benjamin.tissoires@redhat.com>
In-Reply-To: <20220318161528.1531164-1-benjamin.tissoires@redhat.com>
References: <20220318161528.1531164-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

HID is a protocol that could benefit from using BPF too.

This patch implements a net-like use of BPF capability for HID.
Any incoming report coming from the device can be injected into a series
of BPF programs that can modify it or even discard it by setting the
size in the context to 0.

The kernel/bpf implementation is based on net-namespace.c, with only
the bpf_link part kept, there is no real points in keeping the
bpf_prog_{attach|detach} API.

The implementation here is only focusing on the bpf changes. The HID
changes that hooks onto this are coming in separate patches.

Given that HID can be compiled in as a module, and the functions that
kernel/bpf/hid.c needs to call in hid.ko are exported in struct hid_hooks.

This patch also adds a new flag to BPF_LINK_CREATE that allows to chose
the position of the inserted program: at the beginning or at the end.

This way, we can have a tracing program that compare the raw event from
the device and the transformed stream from all the other bpf programs.

This patch introduces the various attachment types the HID BPF programs
need:
- BPF_HID_DEVICE_EVENT for filtering events coming from the device
- BPF_HID_USER_EVENT to initiate a call in a BPF program from userspace
- BPF_HID_DRIVER_EVENT for getting notified of a driver action
- BPF_HID_RDESC_FIXUP to be able to patch the report descriptor

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

changes in v3:
- squashed multiple patches from v2
- use of .convert_ctx_access to hide internal kernel API from
  userspace
- also calls HID hook when a program has been updated (useful
  for reconnecting the device is the report descriptor fixup
  is used)
- add BPF_HID_DRIVER_EVENT
- s/hidraw_ino/hidraw_number/
- s/link_attach/pre_link_attach/
- s/link_attached/post_link_attach/
- s/array_detached/post_array_detach/

changes in v2:
- split the series by bpf/libbpf/hid/selftests and samples
- unsigned long -> __u16 in uapi/linux/bpf_hid.h
- change the bpf_ctx to be of variable size, with a min of 1024 bytes
- make this 1 kB available directly from bpf program, the rest will
  need a helper
- add some more doc comments in uapi
---
 include/linux/bpf-hid.h      | 113 ++++++
 include/linux/bpf_types.h    |   4 +
 include/linux/hid.h          |   5 +
 include/uapi/linux/bpf.h     |  31 ++
 include/uapi/linux/bpf_hid.h |  31 ++
 kernel/bpf/Makefile          |   3 +
 kernel/bpf/btf.c             |   1 +
 kernel/bpf/hid.c             | 643 +++++++++++++++++++++++++++++++++++
 kernel/bpf/syscall.c         |  14 +
 9 files changed, 845 insertions(+)
 create mode 100644 include/linux/bpf-hid.h
 create mode 100644 include/uapi/linux/bpf_hid.h
 create mode 100644 kernel/bpf/hid.c

diff --git a/include/linux/bpf-hid.h b/include/linux/bpf-hid.h
new file mode 100644
index 000000000000..9c8dbd389995
--- /dev/null
+++ b/include/linux/bpf-hid.h
@@ -0,0 +1,113 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _BPF_HID_H
+#define _BPF_HID_H
+
+#include <linux/mutex.h>
+#include <uapi/linux/bpf.h>
+#include <uapi/linux/bpf_hid.h>
+#include <linux/list.h>
+#include <linux/slab.h>
+
+struct bpf_prog;
+struct bpf_prog_array;
+struct hid_device;
+
+enum bpf_hid_attach_type {
+	BPF_HID_ATTACH_INVALID = -1,
+	BPF_HID_ATTACH_DEVICE_EVENT = 0,
+	BPF_HID_ATTACH_RDESC_FIXUP,
+	BPF_HID_ATTACH_USER_EVENT,
+	BPF_HID_ATTACH_DRIVER_EVENT,
+	MAX_BPF_HID_ATTACH_TYPE
+};
+
+struct hid_bpf_ctx_kern {
+	enum hid_bpf_event type;	/* read-only */
+	struct hid_device *hdev;	/* read-only */
+
+	u16 size;			/* used size in data (RW) */
+	u8 *data;			/* data buffer (RW) */
+	u32 allocated_size;		/* allocated size of data (RO) */
+
+	s32 retval;			/* in use when BPF_HID_ATTACH_USER_EVENT (RW) */
+};
+
+struct bpf_hid {
+	u8 *device_data;		/* allocated when a bpf program of type
+					 * SEC(hid/device_event) has been attached
+					 * to this HID device
+					 */
+	u32 allocated_data;
+
+	/* Array of programs to run compiled from links */
+	struct bpf_prog_array __rcu *run_array[MAX_BPF_HID_ATTACH_TYPE];
+	struct list_head links[MAX_BPF_HID_ATTACH_TYPE];
+};
+
+static inline enum bpf_hid_attach_type
+to_bpf_hid_attach_type(enum bpf_attach_type attach_type)
+{
+	switch (attach_type) {
+	case BPF_HID_DEVICE_EVENT:
+		return BPF_HID_ATTACH_DEVICE_EVENT;
+	case BPF_HID_RDESC_FIXUP:
+		return BPF_HID_ATTACH_RDESC_FIXUP;
+	case BPF_HID_USER_EVENT:
+		return BPF_HID_ATTACH_USER_EVENT;
+	case BPF_HID_DRIVER_EVENT:
+		return BPF_HID_ATTACH_DRIVER_EVENT;
+	default:
+		return BPF_HID_ATTACH_INVALID;
+	}
+}
+
+union bpf_attr;
+struct bpf_prog;
+
+#if IS_ENABLED(CONFIG_HID)
+int bpf_hid_prog_query(const union bpf_attr *attr,
+		       union bpf_attr __user *uattr);
+int bpf_hid_link_create(const union bpf_attr *attr,
+			struct bpf_prog *prog);
+#else
+static inline int bpf_hid_prog_query(const union bpf_attr *attr,
+				     union bpf_attr __user *uattr)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int bpf_hid_link_create(const union bpf_attr *attr,
+				      struct bpf_prog *prog)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+
+static inline bool bpf_hid_link_empty(struct bpf_hid *bpf,
+				      enum bpf_hid_attach_type type)
+{
+	return list_empty(&bpf->links[type]);
+}
+
+struct bpf_hid_hooks {
+	struct hid_device *(*hdev_from_fd)(int fd);
+	int (*pre_link_attach)(struct hid_device *hdev, enum bpf_hid_attach_type type);
+	void (*post_link_attach)(struct hid_device *hdev, enum bpf_hid_attach_type type);
+	void (*array_detach)(struct hid_device *hdev, enum bpf_hid_attach_type type);
+};
+
+#ifdef CONFIG_BPF
+int bpf_hid_init(struct hid_device *hdev);
+void bpf_hid_exit(struct hid_device *hdev);
+void bpf_hid_set_hooks(struct bpf_hid_hooks *hooks);
+#else
+static inline int bpf_hid_init(struct hid_device *hdev)
+{
+	return 0;
+}
+
+static inline void bpf_hid_exit(struct hid_device *hdev) {}
+static inline void bpf_hid_set_hooks(struct bpf_hid_hooks *hooks) {}
+#endif
+
+#endif /* _BPF_HID_H */
diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index 48a91c51c015..bb0190356949 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -76,6 +76,10 @@ BPF_PROG_TYPE(BPF_PROG_TYPE_EXT, bpf_extension,
 BPF_PROG_TYPE(BPF_PROG_TYPE_LSM, lsm,
 	       void *, void *)
 #endif /* CONFIG_BPF_LSM */
+#if IS_ENABLED(CONFIG_HID)
+BPF_PROG_TYPE(BPF_PROG_TYPE_HID, hid,
+	      struct hid_bpf_ctx, struct hid_bpf_ctx_kern)
+#endif
 #endif
 BPF_PROG_TYPE(BPF_PROG_TYPE_SYSCALL, bpf_syscall,
 	      void *, void *)
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 7487b0586fe6..56f6f4ad45a7 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -15,6 +15,7 @@
 
 
 #include <linux/bitops.h>
+#include <linux/bpf-hid.h>
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/list.h>
@@ -639,6 +640,10 @@ struct hid_device {							/* device report descriptor */
 	struct list_head debug_list;
 	spinlock_t  debug_list_lock;
 	wait_queue_head_t debug_wait;
+
+#ifdef CONFIG_BPF
+	struct bpf_hid bpf;
+#endif
 };
 
 #define to_hid_device(pdev) \
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 99fab54ae9c0..0e8438e93768 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -952,6 +952,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_LSM,
 	BPF_PROG_TYPE_SK_LOOKUP,
 	BPF_PROG_TYPE_SYSCALL, /* a program that can execute syscalls */
+	BPF_PROG_TYPE_HID,
 };
 
 enum bpf_attach_type {
@@ -997,6 +998,10 @@ enum bpf_attach_type {
 	BPF_SK_REUSEPORT_SELECT,
 	BPF_SK_REUSEPORT_SELECT_OR_MIGRATE,
 	BPF_PERF_EVENT,
+	BPF_HID_DEVICE_EVENT,
+	BPF_HID_RDESC_FIXUP,
+	BPF_HID_USER_EVENT,
+	BPF_HID_DRIVER_EVENT,
 	__MAX_BPF_ATTACH_TYPE
 };
 
@@ -1011,6 +1016,7 @@ enum bpf_link_type {
 	BPF_LINK_TYPE_NETNS = 5,
 	BPF_LINK_TYPE_XDP = 6,
 	BPF_LINK_TYPE_PERF_EVENT = 7,
+	BPF_LINK_TYPE_HID = 8,
 
 	MAX_BPF_LINK_TYPE,
 };
@@ -1118,6 +1124,16 @@ enum bpf_link_type {
  */
 #define BPF_F_XDP_HAS_FRAGS	(1U << 5)
 
+/* HID flag used in BPF_LINK_CREATE command
+ *
+ * NONE(default): The bpf program will be added at the tail of the list
+ * of existing bpf program for this type.
+ *
+ * BPF_F_INSERT_HEAD: The bpf program will be added at the beginning
+ * of the list of existing bpf program for this type..
+ */
+#define BPF_F_INSERT_HEAD	(1U << 0)
+
 /* When BPF ldimm64's insn[0].src_reg != 0 then this can have
  * the following extensions:
  *
@@ -5129,6 +5145,16 @@ union bpf_attr {
  *		The **hash_algo** is returned on success,
  *		**-EOPNOTSUP** if the hash calculation failed or **-EINVAL** if
  *		invalid arguments are passed.
+ *
+ * void *bpf_hid_get_data(void *ctx, u64 offset, u64 size)
+ *	Description
+ *		Returns a pointer to the data associated with context at the given
+ *		offset and size (in bytes).
+ *
+ *		Note: the returned pointer is refcounted and must be dereferenced
+ *		by a call to bpf_hid_discard;
+ *	Return
+ *		The pointer to the data. On error, a null value is returned.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5325,6 +5351,7 @@ union bpf_attr {
 	FN(copy_from_user_task),	\
 	FN(skb_set_tstamp),		\
 	FN(ima_file_hash),		\
+	FN(hid_get_data),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
@@ -5925,6 +5952,10 @@ struct bpf_link_info {
 		struct {
 			__u32 ifindex;
 		} xdp;
+		struct  {
+			__s32 hidraw_number;
+			__u32 attach_type;
+		} hid;
 	};
 } __attribute__((aligned(8)));
 
diff --git a/include/uapi/linux/bpf_hid.h b/include/uapi/linux/bpf_hid.h
new file mode 100644
index 000000000000..64a8b9dd8809
--- /dev/null
+++ b/include/uapi/linux/bpf_hid.h
@@ -0,0 +1,31 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later WITH Linux-syscall-note */
+
+/*
+ *  HID BPF public headers
+ *
+ *  Copyright (c) 2022 Benjamin Tissoires
+ */
+
+#ifndef _UAPI__LINUX_BPF_HID_H__
+#define _UAPI__LINUX_BPF_HID_H__
+
+#include <linux/types.h>
+
+enum hid_bpf_event {
+	HID_BPF_UNDEF = 0,
+	HID_BPF_DEVICE_EVENT,		/* when attach type is BPF_HID_DEVICE_EVENT */
+	HID_BPF_RDESC_FIXUP,		/* ................... BPF_HID_RDESC_FIXUP */
+	HID_BPF_USER_EVENT,		/* ................... BPF_HID_USER_EVENT */
+};
+
+/* User accessible data for HID programs. Add new fields at the end. */
+struct hid_bpf_ctx {
+	__u32	type;			/* enum hid_bpf_event, RO */
+	__u32	allocated_size;		/* allocated size of data, RO */
+
+	__u32	size;			/* valid data in data field, RW */
+	__s32	retval;			/* when type is HID_BPF_USER_EVENT, RW */
+};
+
+#endif /* _UAPI__LINUX_BPF_HID_H__ */
+
diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
index c1a9be6a4b9f..8d5619d3d7e5 100644
--- a/kernel/bpf/Makefile
+++ b/kernel/bpf/Makefile
@@ -35,6 +35,9 @@ ifeq ($(CONFIG_BPF_JIT),y)
 obj-$(CONFIG_BPF_SYSCALL) += bpf_struct_ops.o
 obj-${CONFIG_BPF_LSM} += bpf_lsm.o
 endif
+ifneq ($(CONFIG_HID),)
+obj-$(CONFIG_BPF_SYSCALL) += hid.o
+endif
 obj-$(CONFIG_BPF_PRELOAD) += preload/
 
 obj-$(CONFIG_BPF_SYSCALL) += relo_core.o
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 8b34563a832e..a389626fdf75 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -16,6 +16,7 @@
 #include <linux/kernel.h>
 #include <linux/idr.h>
 #include <linux/sort.h>
+#include <linux/bpf-hid.h>
 #include <linux/bpf_verifier.h>
 #include <linux/btf.h>
 #include <linux/btf_ids.h>
diff --git a/kernel/bpf/hid.c b/kernel/bpf/hid.c
new file mode 100644
index 000000000000..c21dc05f6207
--- /dev/null
+++ b/kernel/bpf/hid.c
@@ -0,0 +1,643 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/bpf.h>
+#include <linux/bpf-hid.h>
+#include <linux/filter.h>
+#include <linux/hid.h>
+#include <linux/hidraw.h>
+
+/*
+ * Functions to manage BPF programs attached to hid
+ */
+
+struct bpf_hid_link {
+	struct bpf_link link;
+	enum bpf_attach_type type;
+	enum bpf_hid_attach_type hid_type;
+
+	/* Must be accessed with bpf_hid_mutex held. */
+	struct hid_device *hdev;
+	struct list_head node; /* node in list of links attached to hid */
+};
+
+/* Protects updates to bpf_hid */
+DEFINE_MUTEX(bpf_hid_mutex);
+
+static struct bpf_hid_hooks hid_hooks = {0};
+
+void bpf_hid_set_hooks(struct bpf_hid_hooks *hooks)
+{
+	if (hooks)
+		hid_hooks = *hooks;
+	else
+		memset(&hid_hooks, 0, sizeof(hid_hooks));
+}
+EXPORT_SYMBOL_GPL(bpf_hid_set_hooks);
+
+BPF_CALL_3(bpf_hid_get_data, struct hid_bpf_ctx_kern*, ctx, u64, offset, u64, size)
+{
+	if (!size)
+		return 0UL;
+
+	if (offset + size > ctx->allocated_size)
+		return 0UL;
+
+	return (unsigned long)(ctx->data + offset);
+}
+
+static const struct bpf_func_proto bpf_hid_get_data_proto = {
+	.func      = bpf_hid_get_data,
+	.gpl_only  = true,
+	.ret_type  = RET_PTR_TO_ALLOC_MEM_OR_NULL,
+	.arg1_type = ARG_PTR_TO_CTX,
+	.arg2_type = ARG_ANYTHING,
+	.arg3_type = ARG_CONST_ALLOC_SIZE_OR_ZERO,
+};
+
+static const struct bpf_func_proto *
+hid_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
+{
+	switch (func_id) {
+	case BPF_FUNC_hid_get_data:
+		return &bpf_hid_get_data_proto;
+	default:
+		return bpf_base_func_proto(func_id);
+	}
+}
+
+static bool hid_is_valid_access(int off, int size,
+				enum bpf_access_type access_type,
+				const struct bpf_prog *prog,
+				struct bpf_insn_access_aux *info)
+{
+	/* everything not in ctx is prohibited */
+	const int size_default = sizeof(__u32);
+
+	if (off < 0 || off >= sizeof(struct hid_bpf_ctx))
+		return false;
+
+	if (off % size != 0)
+		return false;
+
+	switch (off) {
+	/* type is read-only */
+	case offsetof(struct hid_bpf_ctx, type):
+		if (size != size_default)
+			return false;
+		return access_type == BPF_READ;
+
+	/* allocated_size is read-only */
+	case offsetof(struct hid_bpf_ctx, allocated_size):
+		if (size != size_default)
+			return false;
+		return access_type == BPF_READ;
+
+	case offsetof(struct hid_bpf_ctx, retval):
+		if (size != size_default)
+			return false;
+		return (prog->expected_attach_type == BPF_HID_USER_EVENT ||
+			prog->expected_attach_type == BPF_HID_DRIVER_EVENT);
+	default:
+		if (size != size_default)
+			return false;
+		break;
+	}
+
+	/* everything else is read/write */
+	return true;
+}
+
+#define HID_ACCESS_FIELD(T, F)						\
+	T(BPF_FIELD_SIZEOF(struct hid_bpf_ctx_kern, F),			\
+	  si->dst_reg, si->src_reg,					\
+	  offsetof(struct hid_bpf_ctx_kern, F))
+
+static u32 hid_convert_ctx_access(enum bpf_access_type type,
+				  const struct bpf_insn *si,
+				  struct bpf_insn *insn_buf,
+				  struct bpf_prog *prog,
+				  u32 *target_size)
+{
+	struct bpf_insn *insn = insn_buf;
+
+	switch (si->off) {
+	case offsetof(struct hid_bpf_ctx, type):
+		*insn++ = HID_ACCESS_FIELD(BPF_LDX_MEM, type);
+		break;
+	case offsetof(struct hid_bpf_ctx, allocated_size):
+		*insn++ = HID_ACCESS_FIELD(BPF_LDX_MEM, allocated_size);
+		break;
+	case offsetof(struct hid_bpf_ctx, size):
+		if (type == BPF_WRITE)
+			*insn++ = HID_ACCESS_FIELD(BPF_STX_MEM, size);
+		else
+			*insn++ = HID_ACCESS_FIELD(BPF_LDX_MEM, size);
+		break;
+	case offsetof(struct hid_bpf_ctx, retval):
+		if (type == BPF_WRITE)
+			*insn++ = HID_ACCESS_FIELD(BPF_STX_MEM, retval);
+		else
+			*insn++ = HID_ACCESS_FIELD(BPF_LDX_MEM, retval);
+		break;
+	}
+
+	return insn - insn_buf;
+}
+
+const struct bpf_verifier_ops hid_verifier_ops = {
+	.get_func_proto  = hid_func_proto,
+	.is_valid_access = hid_is_valid_access,
+	.convert_ctx_access = hid_convert_ctx_access,
+};
+
+/* Must be called with bpf_hid_mutex held. */
+static void bpf_hid_run_array_detach(struct hid_device *hdev,
+				     enum bpf_hid_attach_type type)
+{
+	struct bpf_prog_array *run_array;
+
+	run_array = rcu_replace_pointer(hdev->bpf.run_array[type], NULL,
+					lockdep_is_held(&bpf_hid_mutex));
+	bpf_prog_array_free(run_array);
+
+	if (hid_hooks.array_detach)
+		hid_hooks.array_detach(hdev, type);
+}
+
+static int link_index(struct hid_device *hdev, enum bpf_hid_attach_type type,
+		      struct bpf_hid_link *link)
+{
+	struct bpf_hid_link *pos;
+	int i = 0;
+
+	list_for_each_entry(pos, &hdev->bpf.links[type], node) {
+		if (pos == link)
+			return i;
+		i++;
+	}
+	return -ENOENT;
+}
+
+static int link_count(struct hid_device *hdev, enum bpf_hid_attach_type type)
+{
+	struct list_head *pos;
+	int i = 0;
+
+	list_for_each(pos, &hdev->bpf.links[type])
+		i++;
+	return i;
+}
+
+static void fill_prog_array(struct hid_device *hdev, enum bpf_hid_attach_type type,
+			    struct bpf_prog_array *prog_array)
+{
+	struct bpf_hid_link *pos;
+	unsigned int i = 0;
+
+	list_for_each_entry(pos, &hdev->bpf.links[type], node) {
+		prog_array->items[i].prog = pos->link.prog;
+		i++;
+	}
+}
+
+static void bpf_hid_link_release(struct bpf_link *link)
+{
+	struct bpf_hid_link *hid_link =
+		container_of(link, struct bpf_hid_link, link);
+	enum bpf_hid_attach_type type = hid_link->hid_type;
+	struct bpf_prog_array *old_array, *new_array;
+	struct hid_device *hdev;
+	int cnt, idx;
+
+	mutex_lock(&bpf_hid_mutex);
+
+	hdev = hid_link->hdev;
+	if (!hdev)
+		goto out_unlock;
+
+	/* Remember link position in case of safe delete */
+	idx = link_index(hdev, type, hid_link);
+	list_del(&hid_link->node);
+
+	cnt = link_count(hdev, type);
+	if (!cnt) {
+		bpf_hid_run_array_detach(hdev, type);
+		goto out_unlock;
+	}
+
+	old_array = rcu_dereference_protected(hdev->bpf.run_array[type],
+					      lockdep_is_held(&bpf_hid_mutex));
+	new_array = bpf_prog_array_alloc(cnt, GFP_KERNEL);
+	if (!new_array) {
+		WARN_ON(bpf_prog_array_delete_safe_at(old_array, idx));
+		goto out_unlock;
+	}
+	fill_prog_array(hdev, type, new_array);
+	rcu_assign_pointer(hdev->bpf.run_array[type], new_array);
+	bpf_prog_array_free(old_array);
+
+out_unlock:
+	hid_link->hdev = NULL;
+	mutex_unlock(&bpf_hid_mutex);
+}
+
+static int bpf_hid_link_detach(struct bpf_link *link)
+{
+	bpf_hid_link_release(link);
+	return 0;
+}
+
+static void bpf_hid_link_dealloc(struct bpf_link *link)
+{
+	struct bpf_hid_link *hid_link =
+		container_of(link, struct bpf_hid_link, link);
+
+	kfree(hid_link);
+}
+
+static int bpf_hid_link_update_prog(struct bpf_link *link,
+				    struct bpf_prog *new_prog,
+				    struct bpf_prog *old_prog)
+{
+	struct bpf_hid_link *hid_link =
+		container_of(link, struct bpf_hid_link, link);
+	enum bpf_hid_attach_type type = hid_link->hid_type;
+	struct bpf_prog_array *run_array;
+	struct hid_device *hdev;
+	int idx, ret;
+
+	if (old_prog && old_prog != link->prog)
+		return -EPERM;
+	if (new_prog->type != link->prog->type)
+		return -EINVAL;
+
+	mutex_lock(&bpf_hid_mutex);
+
+	hdev = hid_link->hdev;
+	if (!hdev) {
+		/* hid dying */
+		ret = -ENOLINK;
+		goto out_unlock;
+	}
+
+	run_array = rcu_dereference_protected(hdev->bpf.run_array[type],
+					      lockdep_is_held(&bpf_hid_mutex));
+	idx = link_index(hdev, type, hid_link);
+	ret = bpf_prog_array_update_at(run_array, idx, new_prog);
+	if (ret)
+		goto out_unlock;
+
+	old_prog = xchg(&link->prog, new_prog);
+	bpf_prog_put(old_prog);
+
+	if (hid_hooks.post_link_attach)
+		hid_hooks.post_link_attach(hdev, type);
+
+out_unlock:
+	mutex_unlock(&bpf_hid_mutex);
+	return ret;
+}
+
+static int bpf_hid_link_fill_info(const struct bpf_link *link,
+				  struct bpf_link_info *info)
+{
+	const struct bpf_hid_link *hid_link =
+		container_of(link, struct bpf_hid_link, link);
+	int hidraw_number = -1;
+	struct hid_device *hdev;
+	struct hidraw *hidraw;
+
+	mutex_lock(&bpf_hid_mutex);
+	hdev = hid_link->hdev;
+	if (hdev && hdev->hidraw) {
+		hidraw = hdev->hidraw;
+		hidraw_number = hidraw->minor;
+	}
+	mutex_unlock(&bpf_hid_mutex);
+
+	info->hid.hidraw_number = hidraw_number;
+	info->hid.attach_type = hid_link->type;
+	return 0;
+}
+
+static void bpf_hid_link_show_fdinfo(const struct bpf_link *link,
+				     struct seq_file *seq)
+{
+	struct bpf_link_info info = {};
+
+	bpf_hid_link_fill_info(link, &info);
+	seq_printf(seq,
+		   "hidraw_number:\t%u\n"
+		   "attach_type:\t%u\n",
+		   info.hid.hidraw_number,
+		   info.hid.attach_type);
+}
+
+static const struct bpf_link_ops bpf_hid_link_ops = {
+	.release = bpf_hid_link_release,
+	.dealloc = bpf_hid_link_dealloc,
+	.detach = bpf_hid_link_detach,
+	.update_prog = bpf_hid_link_update_prog,
+	.fill_link_info = bpf_hid_link_fill_info,
+	.show_fdinfo = bpf_hid_link_show_fdinfo,
+};
+
+/* Must be called with bpf_hid_mutex held. */
+static int __bpf_hid_prog_query(const union bpf_attr *attr,
+				union bpf_attr __user *uattr,
+				  struct hid_device *hdev,
+				  enum bpf_hid_attach_type type)
+{
+	__u32 __user *prog_ids = u64_to_user_ptr(attr->query.prog_ids);
+	struct bpf_prog_array *run_array;
+	u32 prog_cnt = 0, flags = 0;
+
+	run_array = rcu_dereference_protected(hdev->bpf.run_array[type],
+					      lockdep_is_held(&bpf_hid_mutex));
+	if (run_array)
+		prog_cnt = bpf_prog_array_length(run_array);
+
+	if (copy_to_user(&uattr->query.attach_flags, &flags, sizeof(flags)))
+		return -EFAULT;
+	if (copy_to_user(&uattr->query.prog_cnt, &prog_cnt, sizeof(prog_cnt)))
+		return -EFAULT;
+	if (!attr->query.prog_cnt || !prog_ids || !prog_cnt)
+		return 0;
+
+	return bpf_prog_array_copy_to_user(run_array, prog_ids,
+					   attr->query.prog_cnt);
+}
+
+int bpf_hid_prog_query(const union bpf_attr *attr,
+		       union bpf_attr __user *uattr)
+{
+	enum bpf_hid_attach_type type;
+	struct hid_device *hdev;
+	int ret;
+
+	if (attr->query.query_flags || !hid_hooks.hdev_from_fd)
+		return -EINVAL;
+
+	type = to_bpf_hid_attach_type(attr->query.attach_type);
+	if (type < 0)
+		return -EINVAL;
+
+	hdev = hid_hooks.hdev_from_fd(attr->query.target_fd);
+	if (IS_ERR(hdev))
+		return PTR_ERR(hdev);
+
+	mutex_lock(&bpf_hid_mutex);
+	ret = __bpf_hid_prog_query(attr, uattr, hdev, type);
+	mutex_unlock(&bpf_hid_mutex);
+
+	return ret;
+}
+
+static int bpf_hid_max_progs(enum bpf_hid_attach_type type)
+{
+	switch (type) {
+	case BPF_HID_ATTACH_DEVICE_EVENT:
+		return 64;
+	case BPF_HID_ATTACH_RDESC_FIXUP:
+		return 1;
+	case BPF_HID_ATTACH_USER_EVENT:
+		return 64;
+	case BPF_HID_ATTACH_DRIVER_EVENT:
+		return 64;
+	default:
+		return 0;
+	}
+}
+
+static int bpf_hid_link_attach(struct hid_device *hdev, struct bpf_link *link,
+			       enum bpf_hid_attach_type type, u32 flags)
+{
+	struct bpf_hid_link *hid_link =
+		container_of(link, struct bpf_hid_link, link);
+	struct bpf_prog_array *run_array;
+	int cnt, err = 0;
+
+	mutex_lock(&bpf_hid_mutex);
+
+	cnt = link_count(hdev, type);
+	if (cnt >= bpf_hid_max_progs(type)) {
+		err = -E2BIG;
+		goto out_unlock;
+	}
+
+	if (hid_hooks.pre_link_attach) {
+		err = hid_hooks.pre_link_attach(hdev, type);
+		if (err)
+			goto out_unlock;
+	}
+
+	run_array = bpf_prog_array_alloc(cnt + 1, GFP_KERNEL);
+	if (!run_array) {
+		err = -ENOMEM;
+		goto out_unlock;
+	}
+
+	if (flags & BPF_F_INSERT_HEAD)
+		list_add(&hid_link->node, &hdev->bpf.links[type]);
+	else
+		list_add_tail(&hid_link->node, &hdev->bpf.links[type]);
+
+	fill_prog_array(hdev, type, run_array);
+	run_array = rcu_replace_pointer(hdev->bpf.run_array[type], run_array,
+					lockdep_is_held(&bpf_hid_mutex));
+	bpf_prog_array_free(run_array);
+
+	if (hid_hooks.post_link_attach)
+		hid_hooks.post_link_attach(hdev, type);
+
+out_unlock:
+	mutex_unlock(&bpf_hid_mutex);
+	return err;
+}
+
+int bpf_hid_link_create(const union bpf_attr *attr, struct bpf_prog *prog)
+{
+	enum bpf_hid_attach_type hid_type;
+	struct bpf_link_primer link_primer;
+	struct bpf_hid_link *hid_link;
+	enum bpf_attach_type type;
+	struct hid_device *hdev;
+	int err;
+
+	if ((attr->link_create.flags & ~BPF_F_INSERT_HEAD) || !hid_hooks.hdev_from_fd)
+		return -EINVAL;
+
+	type = attr->link_create.attach_type;
+	hid_type = to_bpf_hid_attach_type(type);
+	if (hid_type < 0)
+		return -EINVAL;
+
+	hdev = hid_hooks.hdev_from_fd(attr->link_create.target_fd);
+	if (IS_ERR(hdev))
+		return PTR_ERR(hdev);
+
+	hid_link = kzalloc(sizeof(*hid_link), GFP_USER);
+	if (!hid_link)
+		return -ENOMEM;
+
+	bpf_link_init(&hid_link->link, BPF_LINK_TYPE_HID,
+		      &bpf_hid_link_ops, prog);
+	hid_link->hdev = hdev;
+	hid_link->type = type;
+	hid_link->hid_type = hid_type;
+
+	err = bpf_link_prime(&hid_link->link, &link_primer);
+	if (err) {
+		kfree(hid_link);
+		return err;
+	}
+
+	err = bpf_hid_link_attach(hdev, &hid_link->link, hid_type, attr->link_create.flags);
+	if (err) {
+		bpf_link_cleanup(&link_primer);
+		return err;
+	}
+
+	return bpf_link_settle(&link_primer);
+}
+
+static int hid_bpf_prog_test_run(struct bpf_prog *prog,
+				 const union bpf_attr *attr,
+				 union bpf_attr __user *uattr)
+{
+	struct hid_device *hdev = NULL;
+	struct bpf_prog_array *progs;
+	bool valid_prog = false;
+	int i;
+	int target_fd, ret;
+	void __user *data_out = u64_to_user_ptr(attr->test.data_out);
+	void __user *data_in = u64_to_user_ptr(attr->test.data_in);
+	u32 user_size_in = attr->test.data_size_in;
+	u32 user_size_out = attr->test.data_size_out;
+	u32 allocated_size = max(user_size_in, user_size_out);
+	struct hid_bpf_ctx_kern ctx = {
+		.type = HID_BPF_USER_EVENT,
+		.allocated_size = allocated_size,
+	};
+
+	if (!hid_hooks.hdev_from_fd)
+		return -EOPNOTSUPP;
+
+	if (attr->test.ctx_size_in != sizeof(int))
+		return -EINVAL;
+
+	if (allocated_size > HID_MAX_BUFFER_SIZE)
+		return -E2BIG;
+
+	if (copy_from_user(&target_fd, (void *)attr->test.ctx_in, attr->test.ctx_size_in))
+		return -EFAULT;
+
+	hdev = hid_hooks.hdev_from_fd(target_fd);
+	if (IS_ERR(hdev))
+		return PTR_ERR(hdev);
+
+	if (allocated_size) {
+		ctx.data = kzalloc(allocated_size, GFP_KERNEL);
+		if (!ctx.data)
+			return -ENOMEM;
+
+		ctx.allocated_size = allocated_size;
+	}
+	ctx.hdev = hdev;
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
+	/* copy data_in from userspace */
+	if (user_size_in) {
+		if (copy_from_user(ctx.data, data_in, user_size_in)) {
+			ret = -EFAULT;
+			goto unlock;
+		}
+
+		ctx.size = user_size_in;
+	}
+
+	migrate_disable();
+
+	ret = bpf_prog_run(prog, &ctx);
+
+	migrate_enable();
+
+	if (user_size_out && data_out) {
+		user_size_out = min3(user_size_out, (u32)ctx.size, allocated_size);
+
+		if (copy_to_user(data_out, ctx.data, user_size_out)) {
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
+	if (copy_to_user(&uattr->test.retval, &ctx.retval, sizeof(ctx.retval)))
+		ret = -EFAULT;
+
+unlock:
+	kfree(ctx.data);
+
+	mutex_unlock(&bpf_hid_mutex);
+	return ret;
+}
+
+const struct bpf_prog_ops hid_prog_ops = {
+	.test_run = hid_bpf_prog_test_run,
+};
+
+int bpf_hid_init(struct hid_device *hdev)
+{
+	int type;
+
+	for (type = 0; type < MAX_BPF_HID_ATTACH_TYPE; type++)
+		INIT_LIST_HEAD(&hdev->bpf.links[type]);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(bpf_hid_init);
+
+void bpf_hid_exit(struct hid_device *hdev)
+{
+	enum bpf_hid_attach_type type;
+	struct bpf_hid_link *hid_link;
+
+	mutex_lock(&bpf_hid_mutex);
+	for (type = 0; type < MAX_BPF_HID_ATTACH_TYPE; type++) {
+		bpf_hid_run_array_detach(hdev, type);
+		list_for_each_entry(hid_link, &hdev->bpf.links[type], node) {
+			hid_link->hdev = NULL; /* auto-detach link */
+		}
+	}
+	mutex_unlock(&bpf_hid_mutex);
+}
+EXPORT_SYMBOL_GPL(bpf_hid_exit);
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index b88688264ad0..d1c05011e5ab 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3,6 +3,7 @@
  */
 #include <linux/bpf.h>
 #include <linux/bpf-cgroup.h>
+#include <linux/bpf-hid.h>
 #include <linux/bpf_trace.h>
 #include <linux/bpf_lirc.h>
 #include <linux/bpf_verifier.h>
@@ -2205,6 +2206,7 @@ static bool is_sys_admin_prog_type(enum bpf_prog_type prog_type)
 {
 	switch (prog_type) {
 	case BPF_PROG_TYPE_LIRC_MODE2:
+	case BPF_PROG_TYPE_HID:
 		return true;
 	default:
 		return false;
@@ -3199,6 +3201,11 @@ attach_type_to_prog_type(enum bpf_attach_type attach_type)
 		return BPF_PROG_TYPE_SK_LOOKUP;
 	case BPF_XDP:
 		return BPF_PROG_TYPE_XDP;
+	case BPF_HID_DEVICE_EVENT:
+	case BPF_HID_RDESC_FIXUP:
+	case BPF_HID_USER_EVENT:
+	case BPF_HID_DRIVER_EVENT:
+		return BPF_PROG_TYPE_HID;
 	default:
 		return BPF_PROG_TYPE_UNSPEC;
 	}
@@ -3342,6 +3349,11 @@ static int bpf_prog_query(const union bpf_attr *attr,
 	case BPF_SK_MSG_VERDICT:
 	case BPF_SK_SKB_VERDICT:
 		return sock_map_bpf_prog_query(attr, uattr);
+	case BPF_HID_DEVICE_EVENT:
+	case BPF_HID_RDESC_FIXUP:
+	case BPF_HID_USER_EVENT:
+	case BPF_HID_DRIVER_EVENT:
+		return bpf_hid_prog_query(attr, uattr);
 	default:
 		return -EINVAL;
 	}
@@ -4336,6 +4348,8 @@ static int link_create(union bpf_attr *attr, bpfptr_t uattr)
 		ret = bpf_perf_link_attach(attr, prog);
 		break;
 #endif
+	case BPF_PROG_TYPE_HID:
+		return bpf_hid_link_create(attr, prog);
 	default:
 		ret = -EINVAL;
 	}
-- 
2.35.1


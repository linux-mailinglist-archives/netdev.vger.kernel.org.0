Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 323774CDAA5
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 18:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241249AbiCDRdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 12:33:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241198AbiCDRdr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 12:33:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A91301B785
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 09:32:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646415161;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jxX8RNUdMtQkr8agXKyQdLygFyl1w1wHLWAQzrI5Jww=;
        b=EBbGMnAbYdDaqhREQNZFD/dwJVWKGoEqux53IwUGg94ln9ZkWzABDKyoNPgBlMb0Q4Dh5B
        wiGDlGpBgMEz/7m7J+9cG32JO3gbqQCkkhkWB4KFwOe2wA3aDyzqMaGybBxshiWkFklt6r
        Aa3+iQKX2R/ONY6kKWJMR1PoeQJutlE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-604-rlFpjqNtNyGRyAZNWq3Ftw-1; Fri, 04 Mar 2022 12:32:38 -0500
X-MC-Unique: rlFpjqNtNyGRyAZNWq3Ftw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D0971824FA8;
        Fri,  4 Mar 2022 17:32:35 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AA1FE86595;
        Fri,  4 Mar 2022 17:32:10 +0000 (UTC)
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
Subject: [PATCH bpf-next v2 12/28] bpf/hid: add hid_{get|set}_data helpers
Date:   Fri,  4 Mar 2022 18:28:36 +0100
Message-Id: <20220304172852.274126-13-benjamin.tissoires@redhat.com>
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

When we process an incoming HID report, it is common to have to account
for fields that are not aligned in the report. HID is using 2 helpers
hid_field_extract() and implement() to pick up any data at any offset
within the report.

Export those 2 helpers in BPF programs so users can also rely on them.
The second net worth advantage of those helpers is that now we can
fetch data anywhere in the report without knowing at compile time the
location of it. The boundary checks are done in hid-bpf.c, to prevent
a memory leak.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

changes in v2:
- split the patch with libbpf and HID left outside.
---
 include/linux/bpf-hid.h        |  4 +++
 include/uapi/linux/bpf.h       | 32 ++++++++++++++++++++
 kernel/bpf/hid.c               | 53 ++++++++++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h | 32 ++++++++++++++++++++
 4 files changed, 121 insertions(+)

diff --git a/include/linux/bpf-hid.h b/include/linux/bpf-hid.h
index 0c5000b28b20..69bb28523ceb 100644
--- a/include/linux/bpf-hid.h
+++ b/include/linux/bpf-hid.h
@@ -93,6 +93,10 @@ struct bpf_hid_hooks {
 	int (*link_attach)(struct hid_device *hdev, enum bpf_hid_attach_type type);
 	void (*link_attached)(struct hid_device *hdev, enum bpf_hid_attach_type type);
 	void (*array_detached)(struct hid_device *hdev, enum bpf_hid_attach_type type);
+	int (*hid_get_data)(struct hid_device *hdev, u8 *buf, size_t buf_size,
+			    u64 offset, u32 n, u8 *data, u64 data_size);
+	int (*hid_set_data)(struct hid_device *hdev, u8 *buf, size_t buf_size,
+			    u64 offset, u32 n, u8 *data, u64 data_size);
 };
 
 #ifdef CONFIG_BPF
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index a7a8d9cfcf24..4845a20e6f96 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5090,6 +5090,36 @@ union bpf_attr {
  *	Return
  *		0 on success, or a negative error in case of failure. On error
  *		*dst* buffer is zeroed out.
+ *
+ * int bpf_hid_get_data(void *ctx, u64 offset, u32 n, u8 *data, u64 size)
+ *	Description
+ *		Get the data of size n (in bits) at the given offset (bits) in the
+ *		ctx->event.data field and store it into data.
+ *
+ *		if n is less or equal than 32, we can address with bit precision,
+ *		the value in the buffer. However, data must be a pointer to a u32
+ *		and size must be 4.
+ *
+ *		if n is greater than 32, offset and n must be a multiple of 8
+ *		and the result is working with a memcpy internally.
+ *	Return
+ *		The length of data copied into data. On error, a negative value
+ *		is returned.
+ *
+ * int bpf_hid_set_data(void *ctx, u64 offset, u32 n, u8 *data, u64 size)
+ *	Description
+ *		Set the data of size n (in bits) at the given offset (bits) in the
+ *		ctx->event.data field.
+ *
+ *		if n is less or equal than 32, we can address with bit precision,
+ *		the value in the buffer. However, data must be a pointer to a u32
+ *		and size must be 4.
+ *
+ *		if n is greater than 32, offset and n must be a multiple of 8
+ *		and the result is working with a memcpy internally.
+ *	Return
+ *		The length of data copied into ctx->event.data. On error, a negative
+ *		value is returned.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5284,6 +5314,8 @@ union bpf_attr {
 	FN(xdp_load_bytes),		\
 	FN(xdp_store_bytes),		\
 	FN(copy_from_user_task),	\
+	FN(hid_get_data),		\
+	FN(hid_set_data),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/bpf/hid.c b/kernel/bpf/hid.c
index 37500313e270..640e55ba66ec 100644
--- a/kernel/bpf/hid.c
+++ b/kernel/bpf/hid.c
@@ -37,10 +37,63 @@ void bpf_hid_set_hooks(struct bpf_hid_hooks *hooks)
 }
 EXPORT_SYMBOL_GPL(bpf_hid_set_hooks);
 
+BPF_CALL_5(bpf_hid_get_data, void*, ctx, u64, offset, u32, n, void*, data, u64, size)
+{
+	struct hid_bpf_ctx *bpf_ctx = ctx;
+
+	if (!hid_hooks.hid_get_data)
+		return -EOPNOTSUPP;
+
+	return hid_hooks.hid_get_data(bpf_ctx->hdev,
+				      bpf_ctx->data, bpf_ctx->allocated_size,
+				      offset, n,
+				      data, size);
+}
+
+static const struct bpf_func_proto bpf_hid_get_data_proto = {
+	.func      = bpf_hid_get_data,
+	.gpl_only  = true,
+	.ret_type  = RET_INTEGER,
+	.arg1_type = ARG_PTR_TO_CTX,
+	.arg2_type = ARG_ANYTHING,
+	.arg3_type = ARG_ANYTHING,
+	.arg4_type = ARG_PTR_TO_MEM,
+	.arg5_type = ARG_CONST_SIZE_OR_ZERO,
+};
+
+BPF_CALL_5(bpf_hid_set_data, void*, ctx, u64, offset, u32, n, void*, data, u64, size)
+{
+	struct hid_bpf_ctx *bpf_ctx = ctx;
+
+	if (!hid_hooks.hid_set_data)
+		return -EOPNOTSUPP;
+
+	hid_hooks.hid_set_data(bpf_ctx->hdev,
+			       bpf_ctx->data, bpf_ctx->allocated_size,
+			       offset, n,
+			       data, size);
+	return 0;
+}
+
+static const struct bpf_func_proto bpf_hid_set_data_proto = {
+	.func      = bpf_hid_set_data,
+	.gpl_only  = true,
+	.ret_type  = RET_INTEGER,
+	.arg1_type = ARG_PTR_TO_CTX,
+	.arg2_type = ARG_ANYTHING,
+	.arg3_type = ARG_ANYTHING,
+	.arg4_type = ARG_PTR_TO_MEM,
+	.arg5_type = ARG_CONST_SIZE_OR_ZERO,
+};
+
 static const struct bpf_func_proto *
 hid_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 {
 	switch (func_id) {
+	case BPF_FUNC_hid_get_data:
+		return &bpf_hid_get_data_proto;
+	case BPF_FUNC_hid_set_data:
+		return &bpf_hid_set_data_proto;
 	default:
 		return bpf_base_func_proto(func_id);
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index a7a8d9cfcf24..4845a20e6f96 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5090,6 +5090,36 @@ union bpf_attr {
  *	Return
  *		0 on success, or a negative error in case of failure. On error
  *		*dst* buffer is zeroed out.
+ *
+ * int bpf_hid_get_data(void *ctx, u64 offset, u32 n, u8 *data, u64 size)
+ *	Description
+ *		Get the data of size n (in bits) at the given offset (bits) in the
+ *		ctx->event.data field and store it into data.
+ *
+ *		if n is less or equal than 32, we can address with bit precision,
+ *		the value in the buffer. However, data must be a pointer to a u32
+ *		and size must be 4.
+ *
+ *		if n is greater than 32, offset and n must be a multiple of 8
+ *		and the result is working with a memcpy internally.
+ *	Return
+ *		The length of data copied into data. On error, a negative value
+ *		is returned.
+ *
+ * int bpf_hid_set_data(void *ctx, u64 offset, u32 n, u8 *data, u64 size)
+ *	Description
+ *		Set the data of size n (in bits) at the given offset (bits) in the
+ *		ctx->event.data field.
+ *
+ *		if n is less or equal than 32, we can address with bit precision,
+ *		the value in the buffer. However, data must be a pointer to a u32
+ *		and size must be 4.
+ *
+ *		if n is greater than 32, offset and n must be a multiple of 8
+ *		and the result is working with a memcpy internally.
+ *	Return
+ *		The length of data copied into ctx->event.data. On error, a negative
+ *		value is returned.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5284,6 +5314,8 @@ union bpf_attr {
 	FN(xdp_load_bytes),		\
 	FN(xdp_store_bytes),		\
 	FN(copy_from_user_task),	\
+	FN(hid_get_data),		\
+	FN(hid_set_data),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.35.1


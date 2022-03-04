Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3BC4CDB00
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 18:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241349AbiCDRft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 12:35:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241393AbiCDRfR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 12:35:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 41D941D21F8
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 09:34:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646415248;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6gple0WPBUTESb5NzCZwiTEsdsSCzabkmqhh6wKvZG0=;
        b=PJrJnQ61yVIMxErFmFEmm7l8Gv8PDcjjM431BTcOylyYcjpkf9lYAT31qdRz/6PzslLmX3
        jQOilvWraA9vDmEGr3IeB2qFH/fjzFUt9TGw9evjXqwTBF+RQZ59EE5idpQtA6m6ebANg6
        /FJ/15v1RfEO5Jt+ytIoASgO/JmQJeo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-643-s2olJurQOcWQo2M85ZZEbQ-1; Fri, 04 Mar 2022 12:34:05 -0500
X-MC-Unique: s2olJurQOcWQo2M85ZZEbQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE03E18766D0;
        Fri,  4 Mar 2022 17:34:02 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 50CC686596;
        Fri,  4 Mar 2022 17:33:36 +0000 (UTC)
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
Subject: [PATCH bpf-next v2 19/28] bpf/hid: add bpf_hid_raw_request helper function
Date:   Fri,  4 Mar 2022 18:28:43 +0100
Message-Id: <20220304172852.274126-20-benjamin.tissoires@redhat.com>
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

When we are in a user_event context, we can talk to the device to fetch
or set features/outputs/inputs reports.
Add a bpf helper to do so. This helper is thus only available to
user_events, because calling this function while in IRQ context (any
other BPF type) is forbidden.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

changes in v2:
- split the series by bpf/libbpf/hid/selftests and samples
---
 include/linux/bpf-hid.h        |  2 ++
 include/uapi/linux/bpf.h       |  8 ++++++++
 kernel/bpf/hid.c               | 26 ++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h |  8 ++++++++
 4 files changed, 44 insertions(+)

diff --git a/include/linux/bpf-hid.h b/include/linux/bpf-hid.h
index 4cf2e99109fe..bd548f6a4a26 100644
--- a/include/linux/bpf-hid.h
+++ b/include/linux/bpf-hid.h
@@ -100,6 +100,8 @@ struct bpf_hid_hooks {
 			    u64 offset, u32 n, u8 *data, u64 data_size);
 	int (*hid_set_data)(struct hid_device *hdev, u8 *buf, size_t buf_size,
 			    u64 offset, u32 n, u8 *data, u64 data_size);
+	int (*hid_raw_request)(struct hid_device *hdev, u8 *buf, size_t size,
+			       u8 rtype, u8 reqtype);
 };
 
 #ifdef CONFIG_BPF
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index b3063384d380..417cf1c31579 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5121,6 +5121,13 @@ union bpf_attr {
  *	Return
  *		The length of data copied into ctx->event.data. On error, a negative
  *		value is returned.
+ *
+ * int bpf_hid_raw_request(void *ctx, void *buf, u64 size, u8 rtype, u8 reqtype)
+ *	Description
+ *		communicate with the HID device
+ *	Return
+ *		0 on success.
+ *		negative value on error.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5317,6 +5324,7 @@ union bpf_attr {
 	FN(copy_from_user_task),	\
 	FN(hid_get_data),		\
 	FN(hid_set_data),		\
+	FN(hid_raw_request),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/bpf/hid.c b/kernel/bpf/hid.c
index de003dbd7d01..653d10c0f4e6 100644
--- a/kernel/bpf/hid.c
+++ b/kernel/bpf/hid.c
@@ -86,6 +86,28 @@ static const struct bpf_func_proto bpf_hid_set_data_proto = {
 	.arg5_type = ARG_CONST_SIZE_OR_ZERO,
 };
 
+BPF_CALL_5(bpf_hid_raw_request, void*, ctx, void*, buf, u64, size,
+	   u8, rtype, u8, reqtype)
+{
+	struct hid_bpf_ctx *bpf_ctx = ctx;
+
+	if (!hid_hooks.hid_raw_request)
+		return -EOPNOTSUPP;
+
+	return hid_hooks.hid_raw_request(bpf_ctx->hdev, buf, size, rtype, reqtype);
+}
+
+static const struct bpf_func_proto bpf_hid_raw_request_proto = {
+	.func      = bpf_hid_raw_request,
+	.gpl_only  = true, /* hid_raw_request is EXPORT_SYMBOL_GPL */
+	.ret_type  = RET_INTEGER,
+	.arg1_type = ARG_PTR_TO_CTX,
+	.arg2_type = ARG_PTR_TO_MEM,
+	.arg3_type = ARG_CONST_SIZE_OR_ZERO,
+	.arg4_type = ARG_ANYTHING,
+	.arg5_type = ARG_ANYTHING,
+};
+
 static const struct bpf_func_proto *
 hid_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 {
@@ -94,6 +116,10 @@ hid_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_hid_get_data_proto;
 	case BPF_FUNC_hid_set_data:
 		return &bpf_hid_set_data_proto;
+	case BPF_FUNC_hid_raw_request:
+		if (prog->expected_attach_type != BPF_HID_DEVICE_EVENT)
+			return &bpf_hid_raw_request_proto;
+		return NULL;
 	default:
 		return bpf_base_func_proto(func_id);
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index b3063384d380..417cf1c31579 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5121,6 +5121,13 @@ union bpf_attr {
  *	Return
  *		The length of data copied into ctx->event.data. On error, a negative
  *		value is returned.
+ *
+ * int bpf_hid_raw_request(void *ctx, void *buf, u64 size, u8 rtype, u8 reqtype)
+ *	Description
+ *		communicate with the HID device
+ *	Return
+ *		0 on success.
+ *		negative value on error.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5317,6 +5324,7 @@ union bpf_attr {
 	FN(copy_from_user_task),	\
 	FN(hid_get_data),		\
 	FN(hid_set_data),		\
+	FN(hid_raw_request),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.35.1


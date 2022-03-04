Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F15D54CDAAE
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 18:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241191AbiCDRdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 12:33:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241037AbiCDRdt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 12:33:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B931720F53
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 09:32:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646415167;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WeTIWQC6fVAlk6Saj5kWD691Ja7Vds/ypH8GpPfWruc=;
        b=Qq/QFcehw+WHXNYiQumYzGr3D5khM3jfGfLoWlRK1tK0xxniP3m10I3avXArNII93j0Ktq
        g2wP7no/elJ3Y1IPwvF6B21DojuLHRgWSV1r916ND/hqgAxRVoOMn2ZtV1+Xp49ulF4hME
        /MsNssYTZZbQTDsslvOndVUjMiT32OU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-394-0nhDjJoCOhe0PWVuPWThqg-1; Fri, 04 Mar 2022 12:32:42 -0500
X-MC-Unique: 0nhDjJoCOhe0PWVuPWThqg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5BF2B8066F3;
        Fri,  4 Mar 2022 17:32:40 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2F2038659E;
        Fri,  4 Mar 2022 17:32:36 +0000 (UTC)
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
Subject: [PATCH bpf-next v2 13/28] HID: bpf: implement hid_bpf_get|set_data
Date:   Fri,  4 Mar 2022 18:28:37 +0100
Message-Id: <20220304172852.274126-14-benjamin.tissoires@redhat.com>
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

We have 2 cases of usage here:
- either n <= 32: we are addressing individual bits at the given offset

- either n > 32: we are using a memcpy to transmit the data to the caller,
  meaning that we need to be byte-aligned.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

changes in v2:
- split the series by bpf/libbpf/hid/selftests and samples
- allow for n > 32, by relying on memcpy
---
 drivers/hid/hid-bpf.c  | 68 ++++++++++++++++++++++++++++++++++++++++++
 drivers/hid/hid-core.c |  4 +--
 include/linux/hid.h    |  2 ++
 3 files changed, 72 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-bpf.c b/drivers/hid/hid-bpf.c
index 510e24f4307c..8ae247fba5bc 100644
--- a/drivers/hid/hid-bpf.c
+++ b/drivers/hid/hid-bpf.c
@@ -105,6 +105,72 @@ static void hid_bpf_array_detached(struct hid_device *hdev, enum bpf_hid_attach_
 	}
 }
 
+int hid_bpf_get_data(struct hid_device *hdev, u8 *buf, size_t buf_size, u64 offset, u32 n,
+		     u8 *data, u64 data_size)
+{
+	u32 *value = (u32 *)data;
+
+	if (((offset + n) >> 3) >= buf_size)
+		return -E2BIG;
+
+	if (n <= 32) {
+		/* data must be a pointer to a u32 */
+		if (data_size != 4)
+			return -EINVAL;
+
+		*value = hid_field_extract(hdev, buf, offset, n);
+		return 4;
+	}
+
+	/* if n > 32, use memcpy, but ensure we are dealing with full bytes */
+	if ((n | offset) & 0x7)
+		return -EINVAL;
+
+	/* work on bytes now */
+	offset = offset >> 3;
+	n = n >> 3;
+
+	if (n > data_size)
+		return -EINVAL;
+
+	memcpy(data, buf + offset, n);
+
+	return n;
+}
+
+int hid_bpf_set_data(struct hid_device *hdev, u8 *buf, size_t buf_size, u64 offset, u32 n,
+		     u8 *data, u64 data_size)
+{
+	u32 *value = (u32 *)data;
+
+	if (((offset + n) >> 3) >= buf_size)
+		return -E2BIG;
+
+	if (n <= 32) {
+		/* data must be a pointer to a u32 */
+		if (data_size != 4)
+			return -EINVAL;
+
+		implement(hdev, buf, offset, n, *value);
+		return 4;
+	}
+
+	/* if n > 32, use memcpy, but ensure we are dealing with full bytes */
+	if ((n | offset) & 0x7)
+		return -EINVAL;
+
+	/* work on bytes now */
+	offset = offset >> 3;
+	n = n >> 3;
+
+	if (n > data_size)
+		return -EINVAL;
+
+	memcpy(buf + offset, data, n);
+
+	return n;
+}
+
 static int hid_bpf_run_progs(struct hid_device *hdev, enum bpf_hid_attach_type type,
 			     struct hid_bpf_ctx *ctx, u8 *data, int size)
 {
@@ -204,6 +270,8 @@ int __init hid_bpf_module_init(void)
 		.link_attach = hid_bpf_link_attach,
 		.link_attached = hid_bpf_link_attached,
 		.array_detached = hid_bpf_array_detached,
+		.hid_get_data = hid_bpf_get_data,
+		.hid_set_data = hid_bpf_set_data,
 	};
 
 	bpf_hid_set_hooks(&hooks);
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 0eb8189faaee..d3f4499ee4cd 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1416,8 +1416,8 @@ static void __implement(u8 *report, unsigned offset, int n, u32 value)
 	}
 }
 
-static void implement(const struct hid_device *hid, u8 *report,
-		      unsigned offset, unsigned n, u32 value)
+void implement(const struct hid_device *hid, u8 *report, unsigned int offset, unsigned int n,
+	       u32 value)
 {
 	if (unlikely(n > 32)) {
 		hid_warn(hid, "%s() called with n (%d) > 32! (%s)\n",
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 66d949d10b78..7454e844324c 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -944,6 +944,8 @@ bool hid_compare_device_paths(struct hid_device *hdev_a,
 s32 hid_snto32(__u32 value, unsigned n);
 __u32 hid_field_extract(const struct hid_device *hid, __u8 *report,
 		     unsigned offset, unsigned n);
+void implement(const struct hid_device *hid, u8 *report, unsigned int offset, unsigned int n,
+	       u32 value);
 
 #ifdef CONFIG_PM
 int hid_driver_suspend(struct hid_device *hdev, pm_message_t state);
-- 
2.35.1


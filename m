Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBCB34DDE35
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 17:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238848AbiCRQTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 12:19:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238936AbiCRQTV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 12:19:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CAA6816F044
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 09:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647620278;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8nJYYlBY7G+EkGr1cCCnY5dDxM56e+iZoTRwhxTl+8k=;
        b=G+9YJJjLU4ndS6ZzuDom4Lp3zk1XTyed/tjH9gnqjExKdtsONFnUsjGxnlCaD5oQ70WkuG
        CCE/MLQCrkdX7WfCbDdSHRNTvVSZWSmEmZCi1Rjpr7WMsR9SfnVlEriu11kPmR9wKveLvB
        3EFDXrhMSxGa6k3jRL3M7uMxgUJjhd8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-622-qlLdcQmqOwKSVMP1eIqycg-1; Fri, 18 Mar 2022 12:17:55 -0400
X-MC-Unique: qlLdcQmqOwKSVMP1eIqycg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D534D38035BB;
        Fri, 18 Mar 2022 16:17:53 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B208A7AD1;
        Fri, 18 Mar 2022 16:17:50 +0000 (UTC)
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
Subject: [PATCH bpf-next v3 13/17] HID: bpf: implement hid_bpf_get|set_bits
Date:   Fri, 18 Mar 2022 17:15:24 +0100
Message-Id: <20220318161528.1531164-14-benjamin.tissoires@redhat.com>
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

Export implement() outside of hid-core.c and use this and
hid_field_extract() to implement the helprs for hid-bpf.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

changes in v3:
- renamed hid_{get|set}_data into hid_{get|set}_bits

changes in v2:
- split the series by bpf/libbpf/hid/selftests and samples
- allow for n > 32, by relying on memcpy
---
 drivers/hid/hid-bpf.c  | 29 +++++++++++++++++++++++++++++
 drivers/hid/hid-core.c |  4 ++--
 include/linux/hid.h    |  2 ++
 3 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-bpf.c b/drivers/hid/hid-bpf.c
index 45c87ff47324..650dd5e54919 100644
--- a/drivers/hid/hid-bpf.c
+++ b/drivers/hid/hid-bpf.c
@@ -122,6 +122,33 @@ static void hid_bpf_array_detach(struct hid_device *hdev, enum bpf_hid_attach_ty
 	}
 }
 
+static int hid_bpf_get_bits(struct hid_device *hdev, u8 *buf, size_t buf_size, u64 offset, u32 n,
+			    u32 *data)
+{
+	if (n > 32)
+		return -EINVAL;
+
+	if (((offset + n) >> 3) >= buf_size)
+		return -E2BIG;
+
+	*data = hid_field_extract(hdev, buf, offset, n);
+	return n;
+}
+
+static int hid_bpf_set_bits(struct hid_device *hdev, u8 *buf, size_t buf_size, u64 offset, u32 n,
+			    u32 data)
+{
+	if (n > 32)
+		return -EINVAL;
+
+	if (((offset + n) >> 3) >= buf_size)
+		return -E2BIG;
+
+	/* data must be a pointer to a u32 */
+	implement(hdev, buf, offset, n, data);
+	return n;
+}
+
 static int hid_bpf_run_progs(struct hid_device *hdev, struct hid_bpf_ctx_kern *ctx)
 {
 	enum bpf_hid_attach_type type;
@@ -223,6 +250,8 @@ int __init hid_bpf_module_init(void)
 		.pre_link_attach = hid_bpf_pre_link_attach,
 		.post_link_attach = hid_bpf_post_link_attach,
 		.array_detach = hid_bpf_array_detach,
+		.hid_get_bits = hid_bpf_get_bits,
+		.hid_set_bits = hid_bpf_set_bits,
 	};
 
 	bpf_hid_set_hooks(&hooks);
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 3182c39db006..4f669dcddc08 100644
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


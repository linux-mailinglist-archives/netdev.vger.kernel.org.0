Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66DA84CDB01
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 18:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241398AbiCDRgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 12:36:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241250AbiCDRgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 12:36:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E11F11D1780
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 09:34:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646415275;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6D49UDKOrGqHPDx4/UWVPGxY1Jg6fRi4v4NPaaelVcs=;
        b=REs4LvZQVmXvZ4E5QTyuszPIGSWDWZJYO9c/RMVmiIYpsOCcVtsCrqlEHB7iIe1UWXwF3s
        eD4MKYaI/DlrPjqQjzILv8+8EkybTxjHwU5+3GrD7CtFxtOMagnXAutswlIHmnAQaRx6Lm
        jP2lyw42GT1tteFREkGMomKslBRrFI4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-635-4zNjMA1AP86pw5KyP-IlSg-1; Fri, 04 Mar 2022 12:34:32 -0500
X-MC-Unique: 4zNjMA1AP86pw5KyP-IlSg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5AC7C5EF;
        Fri,  4 Mar 2022 17:34:30 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 50EE986595;
        Fri,  4 Mar 2022 17:34:26 +0000 (UTC)
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
Subject: [PATCH bpf-next v2 23/28] HID: bpf: compute only the required buffer size for the device
Date:   Fri,  4 Mar 2022 18:28:47 +0100
Message-Id: <20220304172852.274126-24-benjamin.tissoires@redhat.com>
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

There is no point in using 16 kB of memory if the device needs less
for all of its reports (uwhich is usually the case).

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

new in v2
---
 drivers/hid/hid-bpf.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-bpf.c b/drivers/hid/hid-bpf.c
index b8c0060f3180..d56fbad990ed 100644
--- a/drivers/hid/hid-bpf.c
+++ b/drivers/hid/hid-bpf.c
@@ -61,11 +61,24 @@ static int hid_reconnect(struct hid_device *hdev)
 static int hid_bpf_link_attach(struct hid_device *hdev, enum bpf_hid_attach_type type)
 {
 	int err = 0;
+	unsigned int i, j, max_report_len = 0;
+
+	/* compute the maximum report length for this device */
+	for (i = 0; i < HID_REPORT_TYPES; i++) {
+		struct hid_report_enum *report_enum = hdev->report_enum + i;
+
+		for (j = 0; j < HID_MAX_IDS; j++) {
+			struct hid_report *report = report_enum->report_id_hash[j];
+
+			if (report)
+				max_report_len = max(max_report_len, hid_report_len(report));
+		}
+	}
 
 	switch (type) {
 	case BPF_HID_ATTACH_DEVICE_EVENT:
 		if (!hdev->bpf.ctx) {
-			hdev->bpf.ctx = bpf_hid_allocate_ctx(hdev, HID_BPF_MAX_BUFFER_SIZE);
+			hdev->bpf.ctx = bpf_hid_allocate_ctx(hdev, max_report_len);
 			if (IS_ERR(hdev->bpf.ctx)) {
 				err = PTR_ERR(hdev->bpf.ctx);
 				hdev->bpf.ctx = NULL;
-- 
2.35.1


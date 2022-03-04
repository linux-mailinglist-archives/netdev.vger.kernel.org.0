Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6400C4CDAE2
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 18:36:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241317AbiCDRg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 12:36:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241386AbiCDRgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 12:36:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0257A1D3AC6
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 09:34:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646415280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T7C9fiyEzdqJww9q8MHw/Ezwfh03XjAvosyY3fabJCA=;
        b=M+dmyIQzmX9GiSB/vjtqwani+gFsLf6ib8UR68aMfDsGxOH2/QXHmFsDj2oUYW66zhQRQw
        DwO19EsZ/Yqi6slCz9dDwDawq8yS/1kWV4YbC35LerkyW2qsju0iHeSahYu8b0d5uW3sxf
        DaNrKgQhTMq7THBTNG2kPNga9JtXiFc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-424-vDZVZTx9PuGg1UxPErrkZQ-1; Fri, 04 Mar 2022 12:34:37 -0500
X-MC-Unique: vDZVZTx9PuGg1UxPErrkZQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 98CE75EF;
        Fri,  4 Mar 2022 17:34:34 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AAE9186595;
        Fri,  4 Mar 2022 17:34:30 +0000 (UTC)
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
Subject: [PATCH bpf-next v2 24/28] HID: bpf: only call hid_bpf_raw_event() if a ctx is available
Date:   Fri,  4 Mar 2022 18:28:48 +0100
Message-Id: <20220304172852.274126-25-benjamin.tissoires@redhat.com>
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

the context is allocated the first time a program of type DEVICE_EVENT
is attached to the device. To not add too much jumps in the code for
the general device handling, call hid_bpf_raw_event() only if we know
that a program has been attached once during the life of the device.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

new in v2
---
 drivers/hid/hid-core.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index d0e015986e17..2b49f6064a40 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1751,10 +1751,13 @@ int hid_report_raw_event(struct hid_device *hid, int type, u8 *data, u32 size,
 	u8 *cdata;
 	int ret = 0;
 
-	data = hid_bpf_raw_event(hid, data, &size);
-	if (IS_ERR(data)) {
-		ret = PTR_ERR(data);
-		goto out;
+	/* we pre-test if ctx is available here to cut the calls at the earliest */
+	if (hid->bpf.ctx) {
+		data = hid_bpf_raw_event(hid, data, &size);
+		if (IS_ERR(data)) {
+			ret = PTR_ERR(data);
+			goto out;
+		}
 	}
 
 	report = hid_get_report(report_enum, data);
-- 
2.35.1


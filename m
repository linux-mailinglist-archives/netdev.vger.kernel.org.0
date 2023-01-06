Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAC4865FED4
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 11:26:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234249AbjAFKZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 05:25:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233869AbjAFKY4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 05:24:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A42E96C2B0
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 02:24:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673000645;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TEHObZijjJUTNDtqqI8JM1N/tfOCpCjHguBWcNndJb4=;
        b=UBnEGapDepP17RXsYiXTuGO8fU3nIcUJoPevxBdDmJGLvyy2Mmc9HoGQob9bO5LhNRWNjT
        5xdjHeC+JRIPvlAPXty8NVN3TKkTqYJsgQQx52IG+PZtfUZQ5P/NWxF+umscavbjUQnkou
        zaS9aXsIknSAcqv6wcaufq8DC38MQg8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-568-tWF9Y5jIPEmZn9-cpEBG-g-1; Fri, 06 Jan 2023 05:24:00 -0500
X-MC-Unique: tWF9Y5jIPEmZn9-cpEBG-g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4D6D41C05AE7;
        Fri,  6 Jan 2023 10:24:00 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5D6FBC15BAD;
        Fri,  6 Jan 2023 10:23:58 +0000 (UTC)
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH HID for-next v1 9/9] HID: bpf: reorder BPF registration
Date:   Fri,  6 Jan 2023 11:23:32 +0100
Message-Id: <20230106102332.1019632-10-benjamin.tissoires@redhat.com>
In-Reply-To: <20230106102332.1019632-1-benjamin.tissoires@redhat.com>
References: <20230106102332.1019632-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Given that our initial BPF program is not using any kfuncs anymore,
we can reorder the initialization to first try to load it and then
register the kfuncs. This has the advantage of not exporting kfuncs
when HID-BPF is not working.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/bpf/hid_bpf_dispatch.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/bpf/hid_bpf_dispatch.c b/drivers/hid/bpf/hid_bpf_dispatch.c
index 26117b4ec016..8a034a555d4c 100644
--- a/drivers/hid/bpf/hid_bpf_dispatch.c
+++ b/drivers/hid/bpf/hid_bpf_dispatch.c
@@ -514,15 +514,16 @@ static int __init hid_bpf_init(void)
 		return 0;
 	}
 
-	err = register_btf_kfunc_id_set(BPF_PROG_TYPE_TRACING, &hid_bpf_kfunc_set);
+	err = hid_bpf_preload_skel();
 	if (err) {
-		pr_warn("error while setting HID BPF tracing kfuncs: %d", err);
+		pr_warn("error while preloading HID BPF dispatcher: %d", err);
 		return 0;
 	}
 
-	err = hid_bpf_preload_skel();
+	/* register tracing kfuncs after we are sure we can load our preloaded bpf program */
+	err = register_btf_kfunc_id_set(BPF_PROG_TYPE_TRACING, &hid_bpf_kfunc_set);
 	if (err) {
-		pr_warn("error while preloading HID BPF dispatcher: %d", err);
+		pr_warn("error while setting HID BPF tracing kfuncs: %d", err);
 		return 0;
 	}
 
-- 
2.38.1


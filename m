Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFE36644780
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 16:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232839AbiLFPHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 10:07:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234868AbiLFPG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 10:06:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAAFD36C42
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 06:59:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670338790;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oqtAUCO0SEZJgsVoKCePLBtYNI2eYf5kC10HYrGr3GM=;
        b=VlqmHrsx3oVh1u121Oh1pnQpPaLZHc7JdjYp+OgraCmPsr3QjWV+WEdfS7zmIb6k25gadI
        M2clnrPUMesocNaVH/YCswX540F4Jth4Jg4mMMRABo1AcblX8i6A2fzOtJQuqYEFS8awKN
        vVOxEZAnn7NpLhy7JuV+4rSaLuCuw6s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-620-Q6O4LbPCNOWLfG69VKMC1g-1; Tue, 06 Dec 2022 09:59:48 -0500
X-MC-Unique: Q6O4LbPCNOWLfG69VKMC1g-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 340DB811E75;
        Tue,  6 Dec 2022 14:59:48 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.193.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9327F4A9254;
        Tue,  6 Dec 2022 14:59:46 +0000 (UTC)
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Florent Revest <revest@chromium.org>,
        Jon Hunter <jonathanh@nvidia.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH HID for-next v3 3/5] HID: bpf: enforce HID_BPF dependencies
Date:   Tue,  6 Dec 2022 15:59:34 +0100
Message-Id: <20221206145936.922196-4-benjamin.tissoires@redhat.com>
In-Reply-To: <20221206145936.922196-1-benjamin.tissoires@redhat.com>
References: <20221206145936.922196-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As mentioned in the link below, having JIT and BPF is not enough to
have fentry/fexit/fmod_ret APIs. This resolves the error that
happens on a system without tracing enabled when hid-bpf tries to
load itself.

Link: https://lore.kernel.org/r/CABRcYmKyRchQhabi1Vd9RcMQFCcb=EtWyEbFDFRTc-L-U8WhgA@mail.gmail.com
Fixes: f5c27da4e3c8 ("HID: initial BPF implementation")
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

no changes in v3

changes in v2:
- dropped ALLOW_ERROR_INJECTION requirement
---
 drivers/hid/bpf/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/bpf/Kconfig b/drivers/hid/bpf/Kconfig
index 298634fc3335..03f52145b83b 100644
--- a/drivers/hid/bpf/Kconfig
+++ b/drivers/hid/bpf/Kconfig
@@ -4,7 +4,8 @@ menu "HID-BPF support"
 config HID_BPF
 	bool "HID-BPF support"
 	default HID_SUPPORT
-	depends on BPF && BPF_SYSCALL
+	depends on BPF && BPF_SYSCALL && \
+		   DYNAMIC_FTRACE_WITH_DIRECT_CALLS
 	help
 	This option allows to support eBPF programs on the HID subsystem.
 	eBPF programs can fix HID devices in a lighter way than a full
-- 
2.38.1


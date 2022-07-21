Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B219D57CF94
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 17:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232132AbiGUPi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 11:38:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231961AbiGUPhz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 11:37:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 508F788CE7
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 08:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658417829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Kmo7Mx7f8ta1oYVd70MON4db/P4ycD4f88q03sBW1Gs=;
        b=Gx9oMqxEYDst+Vgb8klZNUryF2IhS54vtp2z3SWPB9UYS/dVoInGkJBQ8Dx2xt0t6DVD5C
        bRd1FcufNDs9z/rxk93vB0YfAitdjlU9bvR7kKn6sfdUfTKO1cvSF1vVQIjuGlkKel3lcg
        Pydj8jnp8CTpnqrJmBNPoi4KJ1H6T74=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-473-B0hQuiYdPNCj0Wx8_Prxeg-1; Thu, 21 Jul 2022 11:37:03 -0400
X-MC-Unique: B0hQuiYdPNCj0Wx8_Prxeg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B0A303C025C9;
        Thu, 21 Jul 2022 15:37:02 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.194.200])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7A7CB2166B26;
        Thu, 21 Jul 2022 15:36:59 +0000 (UTC)
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>
Cc:     Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH bpf-next v7 09/24] HID: core: store the unique system identifier in hid_device
Date:   Thu, 21 Jul 2022 17:36:10 +0200
Message-Id: <20220721153625.1282007-10-benjamin.tissoires@redhat.com>
In-Reply-To: <20220721153625.1282007-1-benjamin.tissoires@redhat.com>
References: <20220721153625.1282007-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This unique identifier is currently used only for ensuring uniqueness in
sysfs. However, this could be handful for userspace to refer to a specific
hid_device by this id.

2 use cases are in my mind: LEDs (and their naming convention), and
HID-BPF.

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

no changes in v7

no changes in v6

new in v5
---
 drivers/hid/hid-core.c | 4 +++-
 include/linux/hid.h    | 2 ++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 00154a1cd2d8..11874d264728 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -2739,10 +2739,12 @@ int hid_add_device(struct hid_device *hdev)
 			hid_warn(hdev, "bad device descriptor (%d)\n", ret);
 	}
 
+	hdev->id = atomic_inc_return(&id);
+
 	/* XXX hack, any other cleaner solution after the driver core
 	 * is converted to allow more than 20 bytes as the device name? */
 	dev_set_name(&hdev->dev, "%04X:%04X:%04X.%04X", hdev->bus,
-		     hdev->vendor, hdev->product, atomic_inc_return(&id));
+		     hdev->vendor, hdev->product, hdev->id);
 
 	hid_debug_register(hdev, dev_name(&hdev->dev));
 	ret = device_add(&hdev->dev);
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 4363a63b9775..a43dd17bc78f 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -658,6 +658,8 @@ struct hid_device {							/* device report descriptor */
 	struct list_head debug_list;
 	spinlock_t  debug_list_lock;
 	wait_queue_head_t debug_wait;
+
+	unsigned int id;						/* system unique id */
 };
 
 #define to_hid_device(pdev) \
-- 
2.36.1


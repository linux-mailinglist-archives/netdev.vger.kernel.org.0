Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7633859FBC2
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 15:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236994AbiHXNms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 09:42:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238516AbiHXNmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 09:42:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18D1C86077
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 06:41:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661348505;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HB5wU7h84cJ6Ms4A8ZuAsmOjFfahU//QmTTB8tJcR9Y=;
        b=LRAKzYbf4kwkOOYB0mDMLYb7lz7xukKkno/y8aHE/w/icILlmDbBJDJSUYwzz4NeLYTlcj
        nJZiYfJW4LNSZdUCha/8NXZwulkNcSREE7yRCUdY+thfSzY9DI8yXfNiKMU6hAA4pEZG7C
        mX7cb+crUtNTYau6OuaW0NsTH8aG3ao=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-515-dsIDciH2M3SDeSNbUTHY8Q-1; Wed, 24 Aug 2022 09:41:41 -0400
X-MC-Unique: dsIDciH2M3SDeSNbUTHY8Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 48C9B3801164;
        Wed, 24 Aug 2022 13:41:40 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1B31F18ECC;
        Wed, 24 Aug 2022 13:41:36 +0000 (UTC)
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
Subject: [PATCH bpf-next v9 11/23] HID: Kconfig: split HID support and hid-core compilation
Date:   Wed, 24 Aug 2022 15:40:41 +0200
Message-Id: <20220824134055.1328882-12-benjamin.tissoires@redhat.com>
In-Reply-To: <20220824134055.1328882-1-benjamin.tissoires@redhat.com>
References: <20220824134055.1328882-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, we step into drivers/hid/ based on the value of
CONFIG_HID.

However, that value is a tristate, meaning that it can be a module.

As per the documentation, if we jump into the subdirectory by
following an obj-m, we can not compile anything inside that
subdirectory in vmlinux. It is considered as a bug.

To make things more friendly to HID-BPF, split HID (the HID core
parameter) from HID_SUPPORT (do we want any kind of HID support in the
system?), and make this new config a boolean.

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

no changes in v9

no changes in v8

new in v7
---
 drivers/Makefile    |  2 +-
 drivers/hid/Kconfig | 20 +++++++++++---------
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/Makefile b/drivers/Makefile
index 057857258bfd..a24e6be80764 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -137,7 +137,7 @@ obj-$(CONFIG_CRYPTO)		+= crypto/
 obj-$(CONFIG_SUPERH)		+= sh/
 obj-y				+= clocksource/
 obj-$(CONFIG_DCA)		+= dca/
-obj-$(CONFIG_HID)		+= hid/
+obj-$(CONFIG_HID_SUPPORT)	+= hid/
 obj-$(CONFIG_PPC_PS3)		+= ps3/
 obj-$(CONFIG_OF)		+= of/
 obj-$(CONFIG_SSB)		+= ssb/
diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 6ce92830b5d1..4f24e42372dc 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -2,12 +2,18 @@
 #
 # HID driver configuration
 #
-menu "HID support"
-     depends on INPUT
+menuconfig HID_SUPPORT
+	bool "HID bus support"
+	default y
+	depends on INPUT
+	help
+	  This option adds core support for human interface device (HID).
+	  You will also need drivers from the following menu to make use of it.
+
+if HID_SUPPORT
 
 config HID
-	tristate "HID bus support"
-	depends on INPUT
+	tristate "HID bus core support"
 	default y
 	help
 	  A human interface device (HID) is a type of computer device that
@@ -24,8 +30,6 @@ config HID
 
 	  If unsure, say Y.
 
-if HID
-
 config HID_BATTERY_STRENGTH
 	bool "Battery level reporting for HID devices"
 	depends on HID
@@ -1324,8 +1328,6 @@ config HID_KUNIT_TEST
 
 endmenu
 
-endif # HID
-
 source "drivers/hid/usbhid/Kconfig"
 
 source "drivers/hid/i2c-hid/Kconfig"
@@ -1336,4 +1338,4 @@ source "drivers/hid/amd-sfh-hid/Kconfig"
 
 source "drivers/hid/surface-hid/Kconfig"
 
-endmenu
+endif # HID_SUPPORT
-- 
2.36.1


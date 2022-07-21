Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6AE957CFA8
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 17:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232847AbiGUPji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 11:39:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232951AbiGUPiZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 11:38:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8905D88139
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 08:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658417840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CTXOqz6zICJFSaFGA/ApHo6EX3Vnr2pJ/lheNomvy8g=;
        b=eCWp1SRm9a3lHsU/aOlJf/2+iXUjOpD9rqkX8/t5UHzO8vX2ZeCw/n+J+qYt6WpMxDNBxl
        kN2z5SjzsnLofBMDt9HHo5D9XzDxlzAu5vXIvxa2vpXgR5vPcD65i92TBokTiTXOVafi6n
        8wfG3oYz98cDOD2gpxUnDEgEuonXaHo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-563-URK2OKCFPnehalNzP4nMjw-1; Thu, 21 Jul 2022 11:37:14 -0400
X-MC-Unique: URK2OKCFPnehalNzP4nMjw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D910585A584;
        Thu, 21 Jul 2022 15:37:12 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.194.200])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BA7912166B26;
        Thu, 21 Jul 2022 15:37:09 +0000 (UTC)
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
Subject: [PATCH bpf-next v7 12/24] HID: Kconfig: split HID support and hid-core compilation
Date:   Thu, 21 Jul 2022 17:36:13 +0200
Message-Id: <20220721153625.1282007-13-benjamin.tissoires@redhat.com>
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

Currently, we step into drivers/hid/ based on the value of
CONFIG_HID.

However, that value is a tristate, meaning that it can be a module.

As per the documentation, if we jump into the subdirectory by
following an obj-m, we can not compile anything inside that
subdirectory in vmlinux. It is considered as a bug.

To make things more friendly to HID-BPF, split HID (the HID core
parameter) from HID_SUPPORT (do we want any kind of HID support in the
system?), and make this new config a boolean.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

new in v7
---
 drivers/Makefile    |  2 +-
 drivers/hid/Kconfig | 20 +++++++++++---------
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/Makefile b/drivers/Makefile
index 9a30842b22c5..7832431aa173 100644
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
index 70da5931082f..9fa21583c709 100644
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
@@ -1308,8 +1312,6 @@ config HID_MCP2221
 
 endmenu
 
-endif # HID
-
 source "drivers/hid/usbhid/Kconfig"
 
 source "drivers/hid/i2c-hid/Kconfig"
@@ -1320,4 +1322,4 @@ source "drivers/hid/amd-sfh-hid/Kconfig"
 
 source "drivers/hid/surface-hid/Kconfig"
 
-endmenu
+endif # HID_SUPPORT
-- 
2.36.1


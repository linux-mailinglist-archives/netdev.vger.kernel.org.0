Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6B2577C66
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 09:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233818AbiGRHXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 03:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233288AbiGRHXJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 03:23:09 -0400
X-Greylist: delayed 67 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 18 Jul 2022 00:23:08 PDT
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7CC12639C
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 00:23:08 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-277-AgST6BwiNTG9NjgWcQgQBg-1; Mon, 18 Jul 2022 03:21:54 -0400
X-MC-Unique: AgST6BwiNTG9NjgWcQgQBg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9F8D7811E80;
        Mon, 18 Jul 2022 07:21:53 +0000 (UTC)
Received: from dreadlord.bne.redhat.com (fdacunha.bne.redhat.com [10.64.0.157])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 69304141511A;
        Mon, 18 Jul 2022 07:21:49 +0000 (UTC)
From:   Dave Airlie <airlied@gmail.com>
To:     torvalds@linux-foundation.org, Jonathan Corbet <corbet@lwn.net>,
        linux-doc@vger.kernel.org, gregkh@linuxfoundation.org,
        Daniel Vetter <daniel@ffwll.ch>, mcgrof@kernel.org
Cc:     linux-kernel@vger.kernel.org, dri-devel@lists.sf.net,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-media@vger.kernel.org,
        linux-block@vger.kernel.org, Dave Airlie <airlied@redhat.com>
Subject: [PATCH] docs: driver-api: firmware: add driver firmware guidelines.
Date:   Mon, 18 Jul 2022 17:21:44 +1000
Message-Id: <20220718072144.2699487-1-airlied@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_SOFTFAIL,SPOOFED_FREEMAIL,SPOOF_GMAIL_MID
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dave Airlie <airlied@redhat.com>

A recent snafu where Intel ignored upstream feedback on a firmware
change, led to a late rc6 fix being required. In order to avoid this
in the future we should document some expectations around
linux-firmware.

I was originally going to write this for drm, but it seems quite generic
advice.

I'm cc'ing this quite widely to reach subsystems which use fw a lot.

Signed-off-by: Dave Airlie <airlied@redhat.com>
---
 Documentation/driver-api/firmware/core.rst    |  1 +
 .../firmware/firmware-usage-guidelines.rst    | 34 +++++++++++++++++++
 2 files changed, 35 insertions(+)
 create mode 100644 Documentation/driver-api/firmware/firmware-usage-guidelines.rst

diff --git a/Documentation/driver-api/firmware/core.rst b/Documentation/driver-api/firmware/core.rst
index 1d1688cbc078..803cd574bbd7 100644
--- a/Documentation/driver-api/firmware/core.rst
+++ b/Documentation/driver-api/firmware/core.rst
@@ -13,4 +13,5 @@ documents these features.
    direct-fs-lookup
    fallback-mechanisms
    lookup-order
+   firmware-usage-guidelines
 
diff --git a/Documentation/driver-api/firmware/firmware-usage-guidelines.rst b/Documentation/driver-api/firmware/firmware-usage-guidelines.rst
new file mode 100644
index 000000000000..34d2412e78c6
--- /dev/null
+++ b/Documentation/driver-api/firmware/firmware-usage-guidelines.rst
@@ -0,0 +1,34 @@
+===================
+Firmware Guidelines
+===================
+
+Drivers that use firmware from linux-firmware should attempt to follow
+the rules in this guide.
+
+* Firmware should be versioned with at least a major/minor version. It
+  is suggested that the firmware files in linux-firmware be named with
+  some device specific name, and just the major version. The
+  major/minor/patch versions should be stored in a header in the
+  firmware file for the driver to detect any non-ABI fixes/issues. The
+  firmware files in linux-firmware should be overwritten with the newest
+  compatible major version. Newer major version firmware should remain
+  compatible with all kernels that load that major number.
+
+* Users should *not* have to install newer firmware to use existing
+  hardware when they install a newer kernel.  If the hardware isn't
+  enabled by default or under development, this can be ignored, until
+  the first kernel release that enables that hardware.  This means no
+  major version bumps without the kernel retaining backwards
+  compatibility for the older major versions.  Minor version bumps
+  should not introduce new features that newer kernels depend on
+  non-optionally.
+
+* If a security fix needs lockstep firmware and kernel fixes in order to
+  be successful, then all supported major versions in the linux-firmware
+  repo should be updated with the security fix, and the kernel patches
+  should detect if the firmware is new enough to declare if the security
+  issue is fixed.  All communications around security fixes should point
+  at both the firmware and kernel fixes. If a security fix requires
+  deprecating old major versions, then this should only be done as a
+  last option, and be stated clearly in all communications.
+
-- 
2.36.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 115FF4C0530
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 00:18:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236211AbiBVXSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 18:18:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236193AbiBVXS1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 18:18:27 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ACC59027F;
        Tue, 22 Feb 2022 15:18:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645571881; x=1677107881;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KUNQWjpDSRdh+ji0vwxWvKmA2fta9psHurefSdvpBeQ=;
  b=L+XnAUwd/4uMnuDK2vIDaXYGU9boeVLLMExhNuk93qhLQv18HYXb7/Gd
   67AntiT0VnhQbfM6oExGoLkALkf1RX+Fidb0D/TL6hzpMN2+jEoQPPgA9
   wbhRotrUHWXpxylGzQ7ZOEpAyqiUxT1htxPHuAd+N1iuRYgGD6EegVZ3r
   tIb4OB/k8YWcc3X0v6Vq7nlBmlRAlx0AmmO3QRyKhthZ7qCPEAUFgvmB+
   S+/sl9h749lZuUK/ah8gw3eK9FbJzXhbQBV0+4kM0P7wi6UgRAs9cSmde
   qQUR0w542Q+GJakeuSZWxaqbCCzc73vev55pqZyAFpKYnWy7M6X3TOeYq
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10266"; a="231810096"
X-IronPort-AV: E=Sophos;i="5.88,389,1635231600"; 
   d="scan'208";a="231810096"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2022 15:18:01 -0800
X-IronPort-AV: E=Sophos;i="5.88,389,1635231600"; 
   d="scan'208";a="776476639"
Received: from skoppolu-mobl4.amr.corp.intel.com (HELO skuppusw-desk1.amr.corp.intel.com) ([10.252.138.103])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2022 15:18:00 -0800
From:   Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <mgross@linux.intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     "H . Peter Anvin" <hpa@zytor.com>,
        Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Kuppuswamy Sathyanarayanan <knsathya@kernel.org>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH v1 3/6] x86/tdx: Add SetupEventNotifyInterrupt TDX hypercall support
Date:   Tue, 22 Feb 2022 15:17:32 -0800
Message-Id: <20220222231735.268919-4-sathyanarayanan.kuppuswamy@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220222231735.268919-1-sathyanarayanan.kuppuswamy@linux.intel.com>
References: <20220222231735.268919-1-sathyanarayanan.kuppuswamy@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SetupEventNotifyInterrupt TDX hypercall is used by guest TD to specify
which interrupt vector to use as an event-notify vector to the VMM.
Such registered vector is also used by Host VMM to notify about
completion of GetQuote requests to the Guest TD.

Add tdx_hcall_set_notify_intr() helper function to implement the
SetupEventNotifyInterrupt hypercall.

This will be used by the TD guest attestation driver.

Details about the SetupEventNotifyInterrupt TDVMCALL can be found in
TDX Guest-Host Communication Interface (GHCI) Specification, sec 3.5
"VP.VMCALL<SetupEventNotifyInterrupt>".

Reviewed-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
---
 arch/x86/coco/tdx.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/arch/x86/coco/tdx.c b/arch/x86/coco/tdx.c
index 2c07f9551d3b..d18508e6150f 100644
--- a/arch/x86/coco/tdx.c
+++ b/arch/x86/coco/tdx.c
@@ -22,6 +22,7 @@
 /* TDX hypercall Leaf IDs */
 #define TDVMCALL_MAP_GPA		0x10001
 #define TDVMCALL_GET_QUOTE		0x10002
+#define TDVMCALL_SETUP_NOTIFY_INTR	0x10004
 
 /* MMIO direction */
 #define EPT_READ	0
@@ -175,6 +176,38 @@ int tdx_hcall_get_quote(void *data)
 }
 EXPORT_SYMBOL_GPL(tdx_hcall_get_quote);
 
+/*
+ * tdx_hcall_set_notify_intr() - Setup Event Notify Interrupt Vector.
+ *
+ * @vector        : Vector address to be used for notification.
+ *
+ * return 0 on success or failure error number.
+ */
+static int tdx_hcall_set_notify_intr(u8 vector)
+{
+	u64 ret;
+
+	/* Minimum vector value allowed is 32 */
+	if (vector < 32)
+		return -EINVAL;
+
+	/*
+	 * Register callback vector address with VMM. More details
+	 * about the ABI can be found in TDX Guest-Host-Communication
+	 * Interface (GHCI), sec titled
+	 * "TDG.VP.VMCALL<SetupEventNotifyInterrupt>".
+	 */
+	ret = _tdx_hypercall(TDVMCALL_SETUP_NOTIFY_INTR, vector, 0, 0, 0);
+
+	if (ret) {
+		if (ret == TDCALL_INVALID_OPERAND)
+			return -EINVAL;
+		return -EIO;
+	}
+
+	return 0;
+}
+
 static void get_info(void)
 {
 	struct tdx_module_output out;
-- 
2.25.1


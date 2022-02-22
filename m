Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0C34C052C
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 00:18:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233405AbiBVXS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 18:18:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235489AbiBVXS0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 18:18:26 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE7BD90FF6;
        Tue, 22 Feb 2022 15:18:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645571880; x=1677107880;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7grz1QJ3374vaI95vOpZhd1dAyuBLzPtAYC2SN7sRog=;
  b=DEP+WJqzdLp+Bdb243fFe37UnNCS0vSeeMHiWoH7e8cjTYN72IbCXM8K
   YIGyvfc3rlMGjEzjRufS3prpI8pfpR3+M/EZwP6QL56gJkf4Oss0ntS4i
   SvRgRIx9GrLhxGq8K22q8WWkW4/456lG1HrefH8iniP5p81ILICSyYoJq
   3vWn7sPxi0y+/OkNrQPGd74kteBYKrGic7gsUHLdkjbTqG45zK2Etk3My
   Y2fD4dbqFOFwPOkLNT9OIbvLgjvfl1dMiurvpxwziBWutc5T5bYd2KmJN
   OdjcDUmsTCxx9k/Kjx6gnHgbkIy3iDqC8+YGVoHQeym5WDJ5XWuoHIPVE
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10266"; a="231810094"
X-IronPort-AV: E=Sophos;i="5.88,389,1635231600"; 
   d="scan'208";a="231810094"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2022 15:18:00 -0800
X-IronPort-AV: E=Sophos;i="5.88,389,1635231600"; 
   d="scan'208";a="776476633"
Received: from skoppolu-mobl4.amr.corp.intel.com (HELO skuppusw-desk1.amr.corp.intel.com) ([10.252.138.103])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2022 15:17:59 -0800
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
Subject: [PATCH v1 2/6] x86/tdx: Add tdx_hcall_get_quote() API support
Date:   Tue, 22 Feb 2022 15:17:31 -0800
Message-Id: <20220222231735.268919-3-sathyanarayanan.kuppuswamy@linux.intel.com>
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

The second stage in the attestation process is for the guest to request
the VMM generate and sign a quote based on the TDREPORT acquired
earlier. More details about the steps involved in attestation process
can be found in TDX Guest-Host Communication Interface (GHCI) for Intel
TDX 1.5, section titled "TD attestation"

Add tdx_hcall_get_quote() helper function to implement the GetQuote
hypercall.

More details about the GetQuote TDVMCALL are in the Guest-Host
Communication Interface (GHCI) Specification, sec 3.3, titled
"VP.VMCALL<GetQuote>".

This will be used by the TD attestation driver in follow-on patches.

Reviewed-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
---
 arch/x86/coco/tdx.c        | 46 ++++++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/tdx.h |  2 ++
 2 files changed, 48 insertions(+)

diff --git a/arch/x86/coco/tdx.c b/arch/x86/coco/tdx.c
index f01b03e41572..2c07f9551d3b 100644
--- a/arch/x86/coco/tdx.c
+++ b/arch/x86/coco/tdx.c
@@ -21,6 +21,7 @@
 
 /* TDX hypercall Leaf IDs */
 #define TDVMCALL_MAP_GPA		0x10001
+#define TDVMCALL_GET_QUOTE		0x10002
 
 /* MMIO direction */
 #define EPT_READ	0
@@ -38,6 +39,10 @@
 #define TDCALL_INVALID_OPERAND		0x8000000000000000
 #define TDCALL_OPERAND_BUSY		0x8000020000000000
 
+/* TDX hypercall error codes */
+#define TDVMCALL_INVALID_OPERAND	0x8000000000000000
+#define TDVMCALL_GPA_IN_USE		0x8000000000000001
+
 static struct {
 	unsigned int gpa_width;
 	unsigned long attributes;
@@ -129,6 +134,47 @@ int tdx_mcall_tdreport(void *data, void *reportdata)
 }
 EXPORT_SYMBOL_GPL(tdx_mcall_tdreport);
 
+/*
+ * tdx_hcall_get_quote() - Generate TDQUOTE using TDREPORT_STRUCT.
+ *
+ * @data        : Address of 8KB GPA memory which contains
+ *                TDREPORT_STRUCT.
+ *
+ * return 0 on success or failure error number.
+ */
+int tdx_hcall_get_quote(void *data)
+{
+	u64 ret;
+
+	/*
+	 * Use confidential guest TDX check to ensure this API is only
+	 * used by TDX guest platforms.
+	 */
+	if (!data || !cpu_feature_enabled(X86_FEATURE_TDX_GUEST))
+		return -EINVAL;
+
+	/*
+	 * Pass the physical address of tdreport data to the VMM
+	 * and trigger the tdquote generation. Quote data will be
+	 * stored back in the same physical address space. More info
+	 * about ABI can be found in TDX Guest-Host-Communication
+	 * Interface (GHCI), sec titled "TDG.VP.VMCALL<GetQuote>".
+	 */
+	ret = _tdx_hypercall(TDVMCALL_GET_QUOTE, cc_mkdec(virt_to_phys(data)),
+			     0, 0, 0);
+
+	if (ret) {
+		if (ret == TDVMCALL_INVALID_OPERAND)
+			return -EINVAL;
+		else if (ret == TDVMCALL_GPA_IN_USE)
+			return -EBUSY;
+		return -EIO;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(tdx_hcall_get_quote);
+
 static void get_info(void)
 {
 	struct tdx_module_output out;
diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index b2e76ae8fdf1..e93ca229d512 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -60,6 +60,8 @@ bool tdx_early_handle_ve(struct pt_regs *regs);
 
 int tdx_mcall_tdreport(void *data, void *reportdata);
 
+int tdx_hcall_get_quote(void *data);
+
 #else
 
 static inline void tdx_early_init(void) { };
-- 
2.25.1


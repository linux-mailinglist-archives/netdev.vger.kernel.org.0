Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0D974C052A
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 00:18:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236192AbiBVXS1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 18:18:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235525AbiBVXS0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 18:18:26 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B586A90FF5;
        Tue, 22 Feb 2022 15:18:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645571880; x=1677107880;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KfWWny0tde+zNt6efZi6Huwq5vdDEsQjuFuEw8RHIIc=;
  b=Rq9jOsAwcsIxyegM6U4NzO+yj0HUEhEf+FSP+Ru3g8LO0rUkENg6Yupp
   lfMMiWhhSUxexDSwLCxVdmenBZeqxH6iw8vvI+CGARdPPvMIJ40DVmiNA
   v9rYfE3pGKJwHWpiG8ES2PZlcfCqr8oF7XcLne3+xT5k/ZFEXSi/CtXXl
   FmjbmLuSLlCYV7YwSeu071xYsMNGlCbqGIGNmn1BV1ossb8oLvDVCXqVC
   5Iy8Op3EyE08Aa7zZUlE6TCG3K6p/8hTpe/ZjfzJQ/O8R38xfmHEWLM9q
   yW6F1R877KJjvafNmYSc8cNO9I6DD2WuepmetyblXcfRrl3571k5CVyKo
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10266"; a="231810093"
X-IronPort-AV: E=Sophos;i="5.88,389,1635231600"; 
   d="scan'208";a="231810093"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2022 15:17:59 -0800
X-IronPort-AV: E=Sophos;i="5.88,389,1635231600"; 
   d="scan'208";a="776476625"
Received: from skoppolu-mobl4.amr.corp.intel.com (HELO skuppusw-desk1.amr.corp.intel.com) ([10.252.138.103])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2022 15:17:58 -0800
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
Subject: [PATCH v1 1/6] x86/tdx: Add tdx_mcall_tdreport() API support
Date:   Tue, 22 Feb 2022 15:17:30 -0800
Message-Id: <20220222231735.268919-2-sathyanarayanan.kuppuswamy@linux.intel.com>
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

In TDX guest, attestation is mainly used to verify the trust worthiness
of a TD to the 3rd party key servers. First step in attestation process
is to get the TDREPORT data and the generated data is further used in
subsequent steps of attestation process. TDREPORT data contains details
like TDX module version information, measurement of the TD, along with a
TD-specified nonce

Add a wrapper function (tdx_mcall_tdreport()) to get the TDREPORT from
the TDX Module.

More details about the TDREPORT TDCALL can be found in TDX Guest-Host
Communication Interface (GHCI) for Intel TDX 1.5, section titled
"TDCALL [MR.REPORT]".

Steps involved in attestation process can be found in TDX Guest-Host
Communication Interface (GHCI) for Intel TDX 1.5, section titled
"TD attestation"

[Xiaoyao: Proposed error code fix]
Reviewed-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
---
 arch/x86/coco/tdx.c        | 51 ++++++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/tdx.h |  2 ++
 2 files changed, 53 insertions(+)

diff --git a/arch/x86/coco/tdx.c b/arch/x86/coco/tdx.c
index 8a7826fe49e3..f01b03e41572 100644
--- a/arch/x86/coco/tdx.c
+++ b/arch/x86/coco/tdx.c
@@ -16,6 +16,7 @@
 /* TDX module Call Leaf IDs */
 #define TDX_GET_INFO			1
 #define TDX_GET_VEINFO			3
+#define TDX_GET_REPORT			4
 #define TDX_ACCEPT_PAGE			6
 
 /* TDX hypercall Leaf IDs */
@@ -31,6 +32,12 @@
 #define VE_GET_PORT_NUM(e)	((e) >> 16)
 #define VE_IS_IO_STRING(e)	((e) & BIT(4))
 
+/* TDX Module call error codes */
+#define TDCALL_RETURN_CODE_MASK		0xffffffff00000000
+#define TDCALL_RETURN_CODE(a)		((a) & TDCALL_RETURN_CODE_MASK)
+#define TDCALL_INVALID_OPERAND		0x8000000000000000
+#define TDCALL_OPERAND_BUSY		0x8000020000000000
+
 static struct {
 	unsigned int gpa_width;
 	unsigned long attributes;
@@ -78,6 +85,50 @@ static inline void tdx_module_call(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
 		panic("TDCALL %lld failed (Buggy TDX module!)\n", fn);
 }
 
+/*
+ * tdx_mcall_tdreport() - Generate TDREPORT_STRUCT using TDCALL.
+ *
+ * @data        : Address of 1024B aligned data to store
+ *                TDREPORT_STRUCT.
+ * @reportdata  : Address of 64B aligned report data
+ *
+ * return 0 on success or failure error number.
+ */
+int tdx_mcall_tdreport(void *data, void *reportdata)
+{
+	u64 ret;
+
+	/*
+	 * Use confidential guest TDX check to ensure this API is only
+	 * used by TDX guest platforms.
+	 */
+	if (!data || !reportdata || !cpu_feature_enabled(X86_FEATURE_TDX_GUEST))
+		return -EINVAL;
+
+	/*
+	 * Pass the physical address of user generated reportdata
+	 * and the physical address of out pointer to store the
+	 * tdreport data to the TDX module to generate the
+	 * TD report. Generated data contains measurements/configuration
+	 * data of the TD guest. More info about ABI can be found in TDX
+	 * Guest-Host-Communication Interface (GHCI), sec titled
+	 * "TDG.MR.REPORT".
+	 */
+	ret = __tdx_module_call(TDX_GET_REPORT, virt_to_phys(data),
+				virt_to_phys(reportdata), 0, 0, NULL);
+
+	if (ret) {
+		if (TDCALL_RETURN_CODE(ret) == TDCALL_INVALID_OPERAND)
+			return -EINVAL;
+		if (TDCALL_RETURN_CODE(ret) == TDCALL_OPERAND_BUSY)
+			return -EBUSY;
+		return -EIO;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(tdx_mcall_tdreport);
+
 static void get_info(void)
 {
 	struct tdx_module_output out;
diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 6a97d42b0de9..b2e76ae8fdf1 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -58,6 +58,8 @@ void tdx_safe_halt(void);
 
 bool tdx_early_handle_ve(struct pt_regs *regs);
 
+int tdx_mcall_tdreport(void *data, void *reportdata);
+
 #else
 
 static inline void tdx_early_init(void) { };
-- 
2.25.1


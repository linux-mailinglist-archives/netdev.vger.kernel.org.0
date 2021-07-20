Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90F6B3CF3C1
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 06:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242592AbhGTEPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 00:15:31 -0400
Received: from mga14.intel.com ([192.55.52.115]:51770 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237680AbhGTEPR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 00:15:17 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10050"; a="210897305"
X-IronPort-AV: E=Sophos;i="5.84,254,1620716400"; 
   d="scan'208";a="210897305"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2021 21:55:56 -0700
X-IronPort-AV: E=Sophos;i="5.84,254,1620716400"; 
   d="scan'208";a="431923344"
Received: from ywei11-mobl1.amr.corp.intel.com (HELO skuppusw-desk1.amr.corp.intel.com) ([10.251.138.31])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2021 21:55:55 -0700
From:   Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <mgross@linux.intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Peter H Anvin <hpa@zytor.com>, Dave Hansen <dave.hansen@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Kuppuswamy Sathyanarayanan <knsathya@kernel.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v3 2/6] x86/tdx: Add GetQuote TDX hypercall support
Date:   Mon, 19 Jul 2021 21:55:48 -0700
Message-Id: <20210720045552.2124688-3-sathyanarayanan.kuppuswamy@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210720045552.2124688-1-sathyanarayanan.kuppuswamy@linux.intel.com>
References: <20210720045552.2124688-1-sathyanarayanan.kuppuswamy@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The second stage in the attestation process is for the guest to
request the VMM generate and sign a quote based on the TDREPORT
acquired earlier.

Add tdx_hcall_get_quote() helper function to implement the GetQuote
hypercall.

More details about the GetQuote TDVMCALL are in the Guest-Host
Communication Interface (GHCI) Specification, sec 3.3, titled
"TDG.VP.VMCALL<GetQuote>".

This will be used by the TD attestation driver in follow-on patches.

Reviewed-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
---

Change since v2:
 * Included TDVMCALL_SUCCESS case check in tdx_hcall_get_quote().

 arch/x86/include/asm/tdx.h |  2 ++
 arch/x86/kernel/tdx.c      | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 4f1b5c14a09b..1599aa4850e5 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -98,6 +98,8 @@ bool tdg_filter_enabled(void);
 
 int tdx_mcall_tdreport(u64 data, u64 reportdata);
 
+int tdx_hcall_get_quote(u64 data);
+
 /*
  * To support I/O port access in decompressor or early kernel init
  * code, since #VE exception handler cannot be used, use paravirt
diff --git a/arch/x86/kernel/tdx.c b/arch/x86/kernel/tdx.c
index f9a28b4e6d3e..aa49c6809a0c 100644
--- a/arch/x86/kernel/tdx.c
+++ b/arch/x86/kernel/tdx.c
@@ -28,6 +28,7 @@
 
 /* TDX hypercall Leaf IDs */
 #define TDVMCALL_MAP_GPA		0x10001
+#define TDVMCALL_GET_QUOTE		0x10002
 
 /* TDX Module call error codes */
 #define TDX_PAGE_ALREADY_ACCEPTED       0x8000000000000001
@@ -37,6 +38,10 @@
 #define TDCALL_SUCCESS			0x0
 #define TDCALL_RETURN_CODE(a)		((a) & TDCALL_RETURN_CODE_MASK)
 
+/* TDX hypercall error codes */
+#define TDVMCALL_SUCCESS		0x0
+#define TDVMCALL_INVALID_OPERAND	0x8000000000000000
+#define TDVMCALL_TDREPORT_FAILED	0x8000000000000001
 
 #define VE_IS_IO_OUT(exit_qual)		(((exit_qual) & 8) ? 0 : 1)
 #define VE_GET_IO_SIZE(exit_qual)	(((exit_qual) & 7) + 1)
@@ -175,6 +180,34 @@ int tdx_mcall_tdreport(u64 data, u64 reportdata)
 }
 EXPORT_SYMBOL_GPL(tdx_mcall_tdreport);
 
+/*
+ * tdx_hcall_get_quote() - Generate TDQUOTE using TDREPORT_STRUCT.
+ *
+ * @data        : Physical address of 4KB GPA memory which contains
+ *                TDREPORT_STRUCT.
+ *
+ * return 0 on success or failure error number.
+ */
+int tdx_hcall_get_quote(u64 data)
+{
+	u64 ret;
+
+	if (!data || !prot_guest_has(PR_GUEST_TDX))
+		return -EINVAL;
+
+	ret = _trace_tdx_hypercall(TDVMCALL_GET_QUOTE, data, 0, 0, 0, NULL);
+
+	if (ret == TDVMCALL_SUCCESS)
+		return 0;
+	else if (ret == TDVMCALL_INVALID_OPERAND)
+		return -EINVAL;
+	else if (ret == TDVMCALL_TDREPORT_FAILED)
+		return -EBUSY;
+
+	return -EIO;
+}
+EXPORT_SYMBOL_GPL(tdx_hcall_get_quote);
+
 static void tdg_get_info(void)
 {
 	u64 ret;
-- 
2.25.1


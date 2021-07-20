Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE733CF3BB
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 06:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242356AbhGTEP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 00:15:28 -0400
Received: from mga14.intel.com ([192.55.52.115]:51770 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236449AbhGTEPQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 00:15:16 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10050"; a="210897303"
X-IronPort-AV: E=Sophos;i="5.84,254,1620716400"; 
   d="scan'208";a="210897303"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2021 21:55:55 -0700
X-IronPort-AV: E=Sophos;i="5.84,254,1620716400"; 
   d="scan'208";a="431923333"
Received: from ywei11-mobl1.amr.corp.intel.com (HELO skuppusw-desk1.amr.corp.intel.com) ([10.251.138.31])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2021 21:55:54 -0700
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
Subject: [PATCH v3 1/6] x86/tdx: Add TDREPORT TDX Module call support
Date:   Mon, 19 Jul 2021 21:55:47 -0700
Message-Id: <20210720045552.2124688-2-sathyanarayanan.kuppuswamy@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210720045552.2124688-1-sathyanarayanan.kuppuswamy@linux.intel.com>
References: <20210720045552.2124688-1-sathyanarayanan.kuppuswamy@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The TDX Guest-Host Communication Interface (GHCI) includes a module
call (TDREPORT TDCALL) that a guest can make to acquire a copy of the
attestation data that it needs to verify its trustworthiness.

Add a wrapper function tdx_mcall_tdreport() that makes the module
call to get this data.

See GHCI section 2.4.5 "TDCALL [TDG.MR.REPORT] leaf" for additional
details.

[Xiaoyao: Proposed error code fix]
Reviewed-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
---

Changes since v2:
 * Included TDCALL_SUCCESS case check in tdx_mcall_tdreport().

 arch/x86/include/asm/tdx.h |  2 ++
 arch/x86/kernel/tdx.c      | 36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 48927fac9e12..4f1b5c14a09b 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -96,6 +96,8 @@ extern int tdx_hcall_gpa_intent(phys_addr_t gpa, int numpages,
 
 bool tdg_filter_enabled(void);
 
+int tdx_mcall_tdreport(u64 data, u64 reportdata);
+
 /*
  * To support I/O port access in decompressor or early kernel init
  * code, since #VE exception handler cannot be used, use paravirt
diff --git a/arch/x86/kernel/tdx.c b/arch/x86/kernel/tdx.c
index c0e0b8a4346f..f9a28b4e6d3e 100644
--- a/arch/x86/kernel/tdx.c
+++ b/arch/x86/kernel/tdx.c
@@ -23,6 +23,7 @@
 /* TDX Module call Leaf IDs */
 #define TDINFO				1
 #define TDGETVEINFO			3
+#define TDREPORT			4
 #define TDACCEPTPAGE			6
 
 /* TDX hypercall Leaf IDs */
@@ -30,6 +31,12 @@
 
 /* TDX Module call error codes */
 #define TDX_PAGE_ALREADY_ACCEPTED       0x8000000000000001
+#define TDCALL_RETURN_CODE_MASK		0xFFFFFFFF00000000
+#define TDCALL_OPERAND_BUSY		0x8000020000000000
+#define TDCALL_INVALID_OPERAND		0x8000000000000000
+#define TDCALL_SUCCESS			0x0
+#define TDCALL_RETURN_CODE(a)		((a) & TDCALL_RETURN_CODE_MASK)
+
 
 #define VE_IS_IO_OUT(exit_qual)		(((exit_qual) & 8) ? 0 : 1)
 #define VE_GET_IO_SIZE(exit_qual)	(((exit_qual) & 7) + 1)
@@ -139,6 +146,35 @@ static bool tdg_perfmon_enabled(void)
 	return td_info.attributes & BIT(63);
 }
 
+/*
+ * tdx_mcall_tdreport() - Generate TDREPORT_STRUCT using TDCALL.
+ *
+ * @data        : Physical address of 1024B aligned data to store
+ *                TDREPORT_STRUCT.
+ * @reportdata  : Physical address of 64B aligned report data
+ *
+ * return 0 on success or failure error number.
+ */
+int tdx_mcall_tdreport(u64 data, u64 reportdata)
+{
+	u64 ret;
+
+	if (!data || !reportdata || !prot_guest_has(PR_GUEST_TDX))
+		return -EINVAL;
+
+	ret = __trace_tdx_module_call(TDREPORT, data, reportdata, 0, 0, NULL);
+
+	if (ret == TDCALL_SUCCESS)
+		return 0;
+	else if (TDCALL_RETURN_CODE(ret) == TDCALL_INVALID_OPERAND)
+		return -EINVAL;
+	else if (TDCALL_RETURN_CODE(ret) == TDCALL_OPERAND_BUSY)
+		return -EBUSY;
+
+	return -EIO;
+}
+EXPORT_SYMBOL_GPL(tdx_mcall_tdreport);
+
 static void tdg_get_info(void)
 {
 	u64 ret;
-- 
2.25.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D28873BF0F3
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 22:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbhGGUqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 16:46:02 -0400
Received: from mga03.intel.com ([134.134.136.65]:2127 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230474AbhGGUqA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Jul 2021 16:46:00 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10037"; a="209424737"
X-IronPort-AV: E=Sophos;i="5.84,221,1620716400"; 
   d="scan'208";a="209424737"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 13:43:19 -0700
X-IronPort-AV: E=Sophos;i="5.84,221,1620716400"; 
   d="scan'208";a="457619709"
Received: from jmcmilla-mobl.amr.corp.intel.com (HELO skuppusw-desk1.amr.corp.intel.com) ([10.254.8.152])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 13:43:18 -0700
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
Subject: [PATCH v2 3/6] x86/tdx: Add SetupEventNotifyInterrupt TDX hypercall support
Date:   Wed,  7 Jul 2021 13:42:46 -0700
Message-Id: <20210707204249.3046665-4-sathyanarayanan.kuppuswamy@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210707204249.3046665-1-sathyanarayanan.kuppuswamy@linux.intel.com>
References: <20210707204249.3046665-1-sathyanarayanan.kuppuswamy@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SetupEventNotifyInterrupt TDX hypercall is used by guest TD to specify
which interrupt vector to use as an event-notify vector to the VMM.
Such registered vector is also used by Host VMM to notify about
completion of GetQuote requests to the Guest TD.

Add tdx_hcall_set_notify_intr() helper function to implement the
SetupEventNotifyInterrupt hypercall.

This will be used by the TD quote driver.

Details about the SetupEventNotifyInterrupt TDVMCALL can be found in
TDX Guest-Host Communication Interface (GHCI) Specification, sec 3.5
"TDG.VP.VMCALL<SetupEventNotifyInterrupt>".

Reviewed-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
---
 arch/x86/kernel/tdx.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/arch/x86/kernel/tdx.c b/arch/x86/kernel/tdx.c
index eb3a90051604..fcb0ed70ea19 100644
--- a/arch/x86/kernel/tdx.c
+++ b/arch/x86/kernel/tdx.c
@@ -29,6 +29,7 @@
 /* TDX hypercall Leaf IDs */
 #define TDVMCALL_MAP_GPA		0x10001
 #define TDVMCALL_GET_QUOTE		0x10002
+#define TDVMCALL_SETUP_NOTIFY_INTR	0x10004
 
 /* TDX Module call error codes */
 #define TDX_PAGE_ALREADY_ACCEPTED       0x8000000000000001
@@ -202,6 +203,30 @@ int tdx_hcall_get_quote(u64 data)
 }
 EXPORT_SYMBOL_GPL(tdx_hcall_get_quote);
 
+/*
+ * tdx_hcall_set_notify_intr() - Setup Event Notify Interrupt Vector.
+ *
+ * @vector        : Vector address to be used for notification.
+ *
+ * return 0 on success or failure error number.
+ */
+int tdx_hcall_set_notify_intr(u8 vector)
+{
+	u64 ret;
+
+	/* Minimum vector value allowed is 32 */
+	if (vector < 32)
+		return -EINVAL;
+
+	ret = _trace_tdx_hypercall(TDVMCALL_SETUP_NOTIFY_INTR, vector, 0, 0, 0,
+				   NULL);
+
+	if (ret == TDCALL_INVALID_OPERAND)
+		return -EINVAL;
+
+	return 0;
+}
+
 static void tdg_get_info(void)
 {
 	u64 ret;
-- 
2.25.1


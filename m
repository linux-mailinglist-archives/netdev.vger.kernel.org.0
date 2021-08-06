Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70A363E1FB4
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 02:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242718AbhHFAKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 20:10:20 -0400
Received: from mga04.intel.com ([192.55.52.120]:45281 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242703AbhHFAKR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 20:10:17 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10067"; a="212422358"
X-IronPort-AV: E=Sophos;i="5.84,299,1620716400"; 
   d="scan'208";a="212422358"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2021 17:10:02 -0700
X-IronPort-AV: E=Sophos;i="5.84,299,1620716400"; 
   d="scan'208";a="420562704"
Received: from rmgular-mobl2.amr.corp.intel.com (HELO skuppusw-desk1.amr.corp.intel.com) ([10.251.138.25])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2021 17:10:00 -0700
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
Subject: [PATCH v4 1/7] x86/tdx: Add tdg_debug_enabled() interface
Date:   Thu,  5 Aug 2021 17:09:39 -0700
Message-Id: <20210806000946.2951441-2-sathyanarayanan.kuppuswamy@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210806000946.2951441-1-sathyanarayanan.kuppuswamy@linux.intel.com>
References: <20210806000946.2951441-1-sathyanarayanan.kuppuswamy@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A guest TD is defined as debuggable if its ATTRIBUTES.DEBUG bit is 1.
In this mode, the host VMM can use Intel TDX functions to access
secret TD state that is not accessible for non-debuggable TDs. A
debuggable TD is, by nature, untrusted.

Since the TD’s ATTRIBUTES are included in the TDG.MR.REPORT, the TD’s
debuggability state can be known to any third party to which the TD
attests. TD Attributes are initialized during TD INIT call. For
more details about debug features, check Intel Trust Domain Extensions
(Intel TDX) Module Architecture specification, sec 13.3.

Add a new interface to detect the TDX debug mode. This will be used by
follow-on patches. Examples of its usage are, when adding command line
debug options to disable TDX features like driver or port filter,
tdg_debug_enabled() is used to make sure it is used only in debug
mode.

https://software.intel.com/content/dam/develop/external/us/en/documents/tdx-module-1eas-v0.85.039.pdf

Reviewed-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
---
 arch/x86/include/asm/tdx.h | 2 ++
 arch/x86/kernel/tdx.c      | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index dd5459ece9aa..50693bd6f0dd 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -69,6 +69,8 @@ enum tdx_map_type {
 
 extern unsigned int tdg_disable_prot;
 
+bool tdg_debug_enabled(void);
+
 void __init tdx_early_init(void);
 
 bool tdx_prot_guest_has(unsigned long flag);
diff --git a/arch/x86/kernel/tdx.c b/arch/x86/kernel/tdx.c
index bfa168f3f09c..c71049cd2255 100644
--- a/arch/x86/kernel/tdx.c
+++ b/arch/x86/kernel/tdx.c
@@ -135,6 +135,11 @@ phys_addr_t tdg_shared_mask(void)
 	return 1ULL << (td_info.gpa_width - 1);
 }
 
+bool tdg_debug_enabled(void)
+{
+	return td_info.attributes & BIT(0);
+}
+
 static void tdg_get_info(void)
 {
 	u64 ret;
-- 
2.25.1


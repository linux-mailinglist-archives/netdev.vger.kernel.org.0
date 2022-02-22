Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 424904C0526
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 00:18:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236120AbiBVXS1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 18:18:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233405AbiBVXS0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 18:18:26 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5443D9027F;
        Tue, 22 Feb 2022 15:17:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645571879; x=1677107879;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=sRi3Y0px8+ojBe6BJa3k8tR0XaiCszxkZ0yaIFLeAEE=;
  b=Q9FpGganICMPmwANM53SvDjLaQPxZmfs2oMxTyo97qE0O2wZH7pXCupF
   xMGw5MSib3rP7N5gqwgsU5owmfKMqr0DW8pXb81kfSBrcdEYnIgKaeQXY
   +QTU+dbjyDDAqXfyOo/K5wzplWb3CvKocsxaw8e0/Scc8W4qEICB74jx6
   bohVf8VMiKGEOa8QO2averLulF0F9cF/fiIRpa067aPdXBot9fNUJ3ZBs
   80P35eQESAovgpY9O/rbaf4qQKWi6L3CbzS3PTZ9OkdXje87FyFskmpsb
   njHtvbun3iER++yFQpMN5DGqwbP0jnn66+c/fNGioQ9qyBhierLCSFCGA
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10266"; a="231810092"
X-IronPort-AV: E=Sophos;i="5.88,389,1635231600"; 
   d="scan'208";a="231810092"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2022 15:17:59 -0800
X-IronPort-AV: E=Sophos;i="5.88,389,1635231600"; 
   d="scan'208";a="776476619"
Received: from skoppolu-mobl4.amr.corp.intel.com (HELO skuppusw-desk1.amr.corp.intel.com) ([10.252.138.103])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2022 15:17:57 -0800
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
Subject: [PATCH v1 0/6] Add TDX Guest Attestation support
Date:   Tue, 22 Feb 2022 15:17:29 -0800
Message-Id: <20220222231735.268919-1-sathyanarayanan.kuppuswamy@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

Hi All,

Intel's Trust Domain Extensions (TDX) protect guest VMs from malicious
hosts and some physical attacks. VM guest with TDX support is called
as TD Guest.

In TD Guest, the attestation process is used to verify the 
trustworthiness of TD guest to the 3rd party servers. Such attestation
process is required by 3rd party servers before sending sensitive
information to TD guests. One usage example is to get encryption keys
from the key server for mounting the encrypted rootfs or secondary drive.
    
Following patches add the attestation support to TDX guest which
includes attestation user interface driver, user agent example, and
related hypercall support.

In this series, only following patches are in arch/x86 and are
intended for x86 maintainers review.

* x86/tdx: Add TDREPORT TDX Module call support
* x86/tdx: Add GetQuote TDX hypercall support
* x86/tdx: Add SetupEventNotifyInterrupt TDX hypercall support
* x86/tdx: Add TDX Guest event notify interrupt vector support

Patch titled "platform/x86: intel_tdx_attest: Add TDX Guest attestation
interface driver" adds the attestation driver support. This is supposed
to be reviewed by platform-x86 maintainers.

Also, patch titled "tools/tdx: Add a sample attestation user app" adds
a testing app for attestation feature which needs review from
bpf@vger.kernel.org.

Dependencies:
--------------

This feature has dependency on TDX guest core patch set series.

https://lore.kernel.org/all/20220218161718.67148-1-kirill.shutemov@linux.intel.com/T/

History:
----------

Previously this patch set was sent under title "Add TDX Guest
Support (Attestation support)". In the previous version, only the
attestation driver patch was reviewed and got acked. Rest of the
patches need to be reviewed freshly.

https://lore.kernel.org/bpf/20210806000946.2951441-1-sathyanarayanan.kuppuswamy@linux.intel.com/

Changes since previous submission:
 * Updated commit log and error handling in TDREPORT, GetQuote and
   SetupEventNotifyInterrupt support patches.
 * Added locking support in attestation driver.

Kuppuswamy Sathyanarayanan (6):
  x86/tdx: Add tdx_mcall_tdreport() API support
  x86/tdx: Add tdx_hcall_get_quote() API support
  x86/tdx: Add SetupEventNotifyInterrupt TDX hypercall support
  platform/x86: intel_tdx_attest: Add TDX Guest attestation interface
    driver
  x86/tdx: Add TDX Guest event notify interrupt vector support
  tools/tdx: Add a sample attestation user app

 arch/x86/coco/tdx.c                           | 170 ++++++++++++
 arch/x86/include/asm/hardirq.h                |   4 +
 arch/x86/include/asm/idtentry.h               |   4 +
 arch/x86/include/asm/irq_vectors.h            |   7 +-
 arch/x86/include/asm/tdx.h                    |   5 +
 arch/x86/kernel/irq.c                         |   7 +
 drivers/platform/x86/intel/Kconfig            |   1 +
 drivers/platform/x86/intel/Makefile           |   1 +
 drivers/platform/x86/intel/tdx/Kconfig        |  13 +
 drivers/platform/x86/intel/tdx/Makefile       |   3 +
 .../platform/x86/intel/tdx/intel_tdx_attest.c | 241 ++++++++++++++++++
 include/uapi/misc/tdx.h                       |  37 +++
 tools/Makefile                                |  13 +-
 tools/tdx/Makefile                            |  19 ++
 tools/tdx/attest/.gitignore                   |   2 +
 tools/tdx/attest/Makefile                     |  24 ++
 tools/tdx/attest/tdx-attest-test.c            | 240 +++++++++++++++++
 17 files changed, 784 insertions(+), 7 deletions(-)
 create mode 100644 drivers/platform/x86/intel/tdx/Kconfig
 create mode 100644 drivers/platform/x86/intel/tdx/Makefile
 create mode 100644 drivers/platform/x86/intel/tdx/intel_tdx_attest.c
 create mode 100644 include/uapi/misc/tdx.h
 create mode 100644 tools/tdx/Makefile
 create mode 100644 tools/tdx/attest/.gitignore
 create mode 100644 tools/tdx/attest/Makefile
 create mode 100644 tools/tdx/attest/tdx-attest-test.c

-- 
2.25.1


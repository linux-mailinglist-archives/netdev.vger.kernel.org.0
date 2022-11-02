Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB899616EE6
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 21:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230501AbiKBUk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 16:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbiKBUkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 16:40:23 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BFC064FF
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 13:40:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667421621; x=1698957621;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ySqZnSC6suTGcbOAxK9qrFJOs9uHcycfG9cTu+yfl9k=;
  b=JpLqWGkfzd87oyBrH5am6AHRCFGKLPed21tG/u1rdRgiBnwfVs8NNDzo
   8FIe4+f+cNh+JKR0POAzGezOUWtj5jRdTQ9RaeLZjO/oXTMNoXumwmFeE
   itqP90H0okhOq2mJKgScAOtpTOrKXIy+xCKG4Rs3YH0SeYpRgByRSrXQw
   8CN1ULsIBc4USanBXN6t9gp7sX0krRJEkeumygjQeBuLwfyTPwI47AF7O
   Py4R5gPQHDqyLQNM9UeUBUZ9aCg2odQC7/7GC3TJJ4ngC0G/gdkcZJfOT
   gD7brPwSDsQ/4LEPr+jM29iKv5tV3vG16ZHgujZErq89GtbDSaua3g7VO
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="336202185"
X-IronPort-AV: E=Sophos;i="5.95,234,1661842800"; 
   d="scan'208";a="336202185"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2022 13:40:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="612385330"
X-IronPort-AV: E=Sophos;i="5.95,234,1661842800"; 
   d="scan'208";a="612385330"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 02 Nov 2022 13:40:09 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Naama Meir <naamax.meir@linux.intel.com>
Subject: [PATCH net-next 3/6] e1000e: Add e1000e trace module
Date:   Wed,  2 Nov 2022 13:39:54 -0700
Message-Id: <20221102203957.2944396-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221102203957.2944396-1-anthony.l.nguyen@intel.com>
References: <20221102203957.2944396-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

Add tracepoints to the driver via a new file e1000e_trace.h and some new
trace calls added in interesting places in the driver. Add some tracing
for s0ix flows to help in a debug of shared resources with the CSME
firmware. The idea here is that tracepoints have such low performance cost
when disabled that we can leave these in the upstream driver.

Performance not affected, and this can be very useful for debugging and
adding new trace events to paths in the future.

Usage:
echo "e1000e_trace:*" > /sys/kernel/debug/tracing/set_event
echo 1 > /sys/kernel/debug/tracing/events/e1000e_trace/enable

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/e1000e/Makefile    |  3 ++
 .../net/ethernet/intel/e1000e/e1000e_trace.h  | 42 +++++++++++++++++++
 drivers/net/ethernet/intel/e1000e/netdev.c    |  4 ++
 3 files changed, 49 insertions(+)
 create mode 100644 drivers/net/ethernet/intel/e1000e/e1000e_trace.h

diff --git a/drivers/net/ethernet/intel/e1000e/Makefile b/drivers/net/ethernet/intel/e1000e/Makefile
index 44e58b6e7660..0baa15503c38 100644
--- a/drivers/net/ethernet/intel/e1000e/Makefile
+++ b/drivers/net/ethernet/intel/e1000e/Makefile
@@ -5,6 +5,9 @@
 # Makefile for the Intel(R) PRO/1000 ethernet driver
 #
 
+ccflags-y += -I$(src)
+subdir-ccflags-y += -I$(src)
+
 obj-$(CONFIG_E1000E) += e1000e.o
 
 e1000e-objs := 82571.o ich8lan.o 80003es2lan.o \
diff --git a/drivers/net/ethernet/intel/e1000e/e1000e_trace.h b/drivers/net/ethernet/intel/e1000e/e1000e_trace.h
new file mode 100644
index 000000000000..19d3cf4d924e
--- /dev/null
+++ b/drivers/net/ethernet/intel/e1000e/e1000e_trace.h
@@ -0,0 +1,42 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2022, Intel Corporation. */
+/* Modeled on trace-events-sample.h */
+/* The trace subsystem name for e1000e will be "e1000e_trace".
+ *
+ * This file is named e1000e_trace.h.
+ *
+ * Since this include file's name is different from the trace
+ * subsystem name, we'll have to define TRACE_INCLUDE_FILE at the end
+ * of this file.
+ */
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM e1000e_trace
+
+#if !defined(_TRACE_E1000E_TRACE_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_E1000E_TRACE_H
+
+#include <linux/tracepoint.h>
+
+TRACE_EVENT(e1000e_trace_mac_register,
+	    TP_PROTO(uint32_t reg),
+	    TP_ARGS(reg),
+	    TP_STRUCT__entry(__field(uint32_t,	reg)),
+	    TP_fast_assign(__entry->reg = reg;),
+	    TP_printk("event: TraceHub e1000e mac register: 0x%08x",
+		      __entry->reg)
+);
+
+#endif
+/* This must be outside ifdef _E1000E_TRACE_H */
+/* This trace include file is not located in the .../include/trace
+ * with the kernel tracepoint definitions, because we're a loadable
+ * module.
+ */
+
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE e1000e_trace
+
+#include <trace/define_trace.h>
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index edc8aa9822ee..f0e015673f48 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -28,6 +28,8 @@
 #include <linux/suspend.h>
 
 #include "e1000.h"
+#define CREATE_TRACE_POINTS
+#include "e1000e_trace.h"
 
 char e1000e_driver_name[] = "e1000e";
 
@@ -6351,6 +6353,7 @@ static void e1000e_s0ix_entry_flow(struct e1000_adapter *adapter)
 		mac_data = er32(H2ME);
 		mac_data |= E1000_H2ME_START_DPG;
 		mac_data &= ~E1000_H2ME_EXIT_DPG;
+		trace_e1000e_trace_mac_register(mac_data);
 		ew32(H2ME, mac_data);
 	} else {
 		/* Request driver configure the device to S0ix */
@@ -6505,6 +6508,7 @@ static void e1000e_s0ix_exit_flow(struct e1000_adapter *adapter)
 		mac_data = er32(H2ME);
 		mac_data &= ~E1000_H2ME_START_DPG;
 		mac_data |= E1000_H2ME_EXIT_DPG;
+		trace_e1000e_trace_mac_register(mac_data);
 		ew32(H2ME, mac_data);
 
 		/* Poll up to 2.5 seconds for ME to unconfigure DPG.
-- 
2.35.1


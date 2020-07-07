Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6CB217BE6
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 01:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729337AbgGGXsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 19:48:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:15272 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728530AbgGGXsM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jul 2020 19:48:12 -0400
IronPort-SDR: r4M+4Ws3aWWywPzlbdtYMEBoZ7t6IM4eLEyZB3KxNxHkpCYSFvK5JBstUroIXy+/iR4GhYi1k+
 8B7UOwyiniCw==
X-IronPort-AV: E=McAfee;i="6000,8403,9675"; a="135949653"
X-IronPort-AV: E=Sophos;i="5.75,325,1589266800"; 
   d="scan'208";a="135949653"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2020 16:48:11 -0700
IronPort-SDR: uVZjgI3z7DtQELu9pzkNJbsuInctAZ0JcMRe4CHocnmVHhBmK16CGlLxEIhAsowlLlcdZLoDVb
 nrmCNCSIr88g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,325,1589266800"; 
   d="scan'208";a="483684034"
Received: from vapadgao-mobl.amr.corp.intel.com ([10.251.143.88])
  by fmsmga005.fm.intel.com with ESMTP; 07 Jul 2020 16:48:11 -0700
From:   Andre Guedes <andre.guedes@intel.com>
To:     netdev@vger.kernel.org
Cc:     intel-wired-lan@lists.osuosl.org
Subject: [PATCH ethtool 3/4] igc: Parse VLANPQF register fields
Date:   Tue,  7 Jul 2020 16:47:59 -0700
Message-Id: <20200707234800.39119-4-andre.guedes@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200707234800.39119-1-andre.guedes@intel.com>
References: <20200707234800.39119-1-andre.guedes@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for parsing the VLAN Priority Queue Filter
(VLANPQF) register fields.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
---
 igc.c | 98 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 98 insertions(+)

diff --git a/igc.c b/igc.c
index df3916c..6a2e06d 100644
--- a/igc.c
+++ b/igc.c
@@ -35,8 +35,39 @@
 #define RCTL_DPF				0x00400000
 #define RCTL_PMCF				0x00800000
 #define RCTL_SECRC				0x04000000
+#define VLANPQF_VP0QSEL				0x00000003
+#define VLANPQF_VP0PBSEL			0x00000004
+#define VLANPQF_VLANP0V				0x00000008
+#define VLANPQF_VP1QSEL				0x00000030
+#define VLANPQF_VP1PBSEL			0x00000040
+#define VLANPQF_VLANP1V				0x00000080
+#define VLANPQF_VP2QSEL				0x00000300
+#define VLANPQF_VP2PBSEL			0x00000400
+#define VLANPQF_VLANP2V				0x00000800
+#define VLANPQF_VP3QSEL				0x00003000
+#define VLANPQF_VP3PBSEL			0x00004000
+#define VLANPQF_VLANP3V				0x00008000
+#define VLANPQF_VP4QSEL				0x00030000
+#define VLANPQF_VP4PBSEL			0x00040000
+#define VLANPQF_VLANP4V				0x00080000
+#define VLANPQF_VP5QSEL				0x00300000
+#define VLANPQF_VP5PBSEL			0x00400000
+#define VLANPQF_VLANP5V				0x00800000
+#define VLANPQF_VP6QSEL				0x03000000
+#define VLANPQF_VP6PBSEL			0x04000000
+#define VLANPQF_VLANP6V				0x08000000
+#define VLANPQF_VP7QSEL				0x30000000
+#define VLANPQF_VP7PBSEL			0x40000000
+#define VLANPQF_VLANP7V				0x80000000
 
 #define RAH_QSEL_SHIFT				18
+#define VLANPQF_VP1QSEL_SHIFT			4
+#define VLANPQF_VP2QSEL_SHIFT			8
+#define VLANPQF_VP3QSEL_SHIFT			12
+#define VLANPQF_VP4QSEL_SHIFT			16
+#define VLANPQF_VP5QSEL_SHIFT			20
+#define VLANPQF_VP6QSEL_SHIFT			24
+#define VLANPQF_VP7QSEL_SHIFT			28
 
 static const char *bit_to_boolean(u32 val)
 {
@@ -48,6 +79,11 @@ static const char *bit_to_enable(u32 val)
 	return val ? "Enabled" : "Disabled";
 }
 
+static const char *bit_to_prio(u32 val)
+{
+	return val ? "Low" : "High";
+}
+
 int igc_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)
 {
 	u32 reg;
@@ -147,5 +183,67 @@ int igc_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)
 		       bit_to_boolean(reg & RAH_AV));
 	}
 
+	offset = 204;
+
+	reg = regs_buff[offset];
+	printf("%04d: VLANPQF (VLAN Priority Queue Filter)       \n"
+	       "    Priority 0                                   \n"
+	       "        Queue:                                 %d\n"
+	       "        Packet Buffer:                         %s\n"
+	       "        Valid:                                 %s\n"
+	       "    Priority 1                                   \n"
+	       "        Queue:                                 %d\n"
+	       "        Packet Buffer:                         %s\n"
+	       "        Valid:                                 %s\n"
+	       "    Priority 2                                   \n"
+	       "        Queue:                                 %d\n"
+	       "        Packet Buffer:                         %s\n"
+	       "        Valid:                                 %s\n"
+	       "    Priority 3                                   \n"
+	       "        Queue:                                 %d\n"
+	       "        Packet Buffer:                         %s\n"
+	       "        Valid:                                 %s\n"
+	       "    Priority 4                                   \n"
+	       "        Queue:                                 %d\n"
+	       "        Packet Buffer:                         %s\n"
+	       "        Valid:                                 %s\n"
+	       "    Priority 5                                   \n"
+	       "        Queue:                                 %d\n"
+	       "        Packet Buffer:                         %s\n"
+	       "        Valid:                                 %s\n"
+	       "    Priority 6                                   \n"
+	       "        Queue:                                 %d\n"
+	       "        Packet Buffer:                         %s\n"
+	       "        Valid:                                 %s\n"
+	       "    Priority 7                                   \n"
+	       "        Queue:                                 %d\n"
+	       "        Packet Buffer:                         %s\n"
+	       "        Valid:                                 %s\n",
+	       offset,
+	       reg & VLANPQF_VP0QSEL,
+	       bit_to_prio(reg & VLANPQF_VP0PBSEL),
+	       bit_to_boolean(reg & VLANPQF_VLANP0V),
+	       (reg & VLANPQF_VP1QSEL) >> VLANPQF_VP1QSEL_SHIFT,
+	       bit_to_prio(reg & VLANPQF_VP1PBSEL),
+	       bit_to_boolean(reg & VLANPQF_VLANP1V),
+	       (reg & VLANPQF_VP2QSEL) >> VLANPQF_VP2QSEL_SHIFT,
+	       bit_to_prio(reg & VLANPQF_VP2PBSEL),
+	       bit_to_boolean(reg & VLANPQF_VLANP2V),
+	       (reg & VLANPQF_VP3QSEL) >> VLANPQF_VP3QSEL_SHIFT,
+	       bit_to_prio(reg & VLANPQF_VP3PBSEL),
+	       bit_to_boolean(reg & VLANPQF_VLANP3V),
+	       (reg & VLANPQF_VP4QSEL) >> VLANPQF_VP4QSEL_SHIFT,
+	       bit_to_prio(reg & VLANPQF_VP4PBSEL),
+	       bit_to_boolean(reg & VLANPQF_VLANP4V),
+	       (reg & VLANPQF_VP5QSEL) >> VLANPQF_VP5QSEL_SHIFT,
+	       bit_to_prio(reg & VLANPQF_VP5PBSEL),
+	       bit_to_boolean(reg & VLANPQF_VLANP5V),
+	       (reg & VLANPQF_VP6QSEL) >> VLANPQF_VP6QSEL_SHIFT,
+	       bit_to_prio(reg & VLANPQF_VP6PBSEL),
+	       bit_to_boolean(reg & VLANPQF_VLANP6V),
+	       (reg & VLANPQF_VP7QSEL) >> VLANPQF_VP7QSEL_SHIFT,
+	       bit_to_prio(reg & VLANPQF_VP7PBSEL),
+	       bit_to_boolean(reg & VLANPQF_VLANP7V));
+
 	return 0;
 }
-- 
2.26.2


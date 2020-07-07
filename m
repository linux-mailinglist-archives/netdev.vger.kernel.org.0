Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6496217BE7
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 01:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729343AbgGGXsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 19:48:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:15281 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729309AbgGGXsM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jul 2020 19:48:12 -0400
IronPort-SDR: cIeNudbkiVx8SzrA49i/mUkAruk0jl2fNwpsXf0VMgokT7UVplVLpxd6ie7IMk9tfKvbzpk4qw
 LjOOuSFBcPLg==
X-IronPort-AV: E=McAfee;i="6000,8403,9675"; a="135949654"
X-IronPort-AV: E=Sophos;i="5.75,325,1589266800"; 
   d="scan'208";a="135949654"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2020 16:48:11 -0700
IronPort-SDR: 2BLrbMYMrN2XU1vBf/zl78CliZqYmYrShYOlrBfH/0HX4H//uRPDSqSCZUxN89yQnnCkqf4PDl
 sfAxLJI6NuAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,325,1589266800"; 
   d="scan'208";a="483684036"
Received: from vapadgao-mobl.amr.corp.intel.com ([10.251.143.88])
  by fmsmga005.fm.intel.com with ESMTP; 07 Jul 2020 16:48:11 -0700
From:   Andre Guedes <andre.guedes@intel.com>
To:     netdev@vger.kernel.org
Cc:     intel-wired-lan@lists.osuosl.org
Subject: [PATCH ethtool 4/4] igc: Parse ETQF registers
Date:   Tue,  7 Jul 2020 16:48:00 -0700
Message-Id: <20200707234800.39119-5-andre.guedes@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200707234800.39119-1-andre.guedes@intel.com>
References: <20200707234800.39119-1-andre.guedes@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for parsing the EType Queue Filter (ETQF)
registers fields.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
---
 igc.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/igc.c b/igc.c
index 6a2e06d..9c0a750 100644
--- a/igc.c
+++ b/igc.c
@@ -59,6 +59,14 @@
 #define VLANPQF_VP7QSEL				0x30000000
 #define VLANPQF_VP7PBSEL			0x40000000
 #define VLANPQF_VLANP7V				0x80000000
+#define ETQF_ETYPE				0x0000FFFF
+#define ETQF_QUEUE				0x00070000
+#define ETQF_ETYPE_LEN				0x01F00000
+#define ETQF_ETYPE_LEN_EN			0x02000000
+#define ETQF_FILTER_EN				0x04000000
+#define ETQF_IMMEDIATE_INTR			0x20000000
+#define ETQF_1588_TIMESTAMP			0x40000000
+#define ETQF_QUEUE_EN				0x80000000
 
 #define RAH_QSEL_SHIFT				18
 #define VLANPQF_VP1QSEL_SHIFT			4
@@ -68,6 +76,8 @@
 #define VLANPQF_VP5QSEL_SHIFT			20
 #define VLANPQF_VP6QSEL_SHIFT			24
 #define VLANPQF_VP7QSEL_SHIFT			28
+#define ETQF_QUEUE_SHIFT			16
+#define ETQF_ETYPE_LEN_SHIFT			20
 
 static const char *bit_to_boolean(u32 val)
 {
@@ -245,5 +255,29 @@ int igc_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)
 	       bit_to_prio(reg & VLANPQF_VP7PBSEL),
 	       bit_to_boolean(reg & VLANPQF_VLANP7V));
 
+	offset = 205;
+
+	for (i = 0; i < 8; i++) {
+		reg = regs_buff[offset + i];
+		printf("%04d: ETQF (EType Queue Filter %d)                 \n"
+		       "    EType:                                     %04X\n"
+		       "    EType Length:                              %d\n"
+		       "    EType Length Enable:                       %s\n"
+		       "    Queue:                                     %d\n"
+		       "    Queue Enable:                              %s\n"
+		       "    Immediate Interrupt:                       %s\n"
+		       "    1588 Time Stamp:                           %s\n"
+		       "    Filter Enable:                             %s\n",
+		       offset + i, i,
+		       reg & ETQF_ETYPE,
+		       (reg & ETQF_ETYPE_LEN) >> ETQF_ETYPE_LEN_SHIFT,
+		       bit_to_boolean(reg & ETQF_ETYPE_LEN_EN),
+		       (reg & ETQF_QUEUE) >> ETQF_QUEUE_SHIFT,
+		       bit_to_boolean(reg & ETQF_QUEUE_EN),
+		       bit_to_enable(reg & ETQF_IMMEDIATE_INTR),
+		       bit_to_enable(reg & ETQF_1588_TIMESTAMP),
+		       bit_to_boolean(reg & ETQF_FILTER_EN));
+	}
+
 	return 0;
 }
-- 
2.26.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66D31217BE4
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 01:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729315AbgGGXsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 19:48:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:15272 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729303AbgGGXsM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jul 2020 19:48:12 -0400
IronPort-SDR: hvfsTiBhFgjl/581wKztW7SBn+/l70CszM5N1FyUs1mX+kvnjaxwOm2s9BtvtOnhqy2KgB3jNv
 9r3IBQED9OPA==
X-IronPort-AV: E=McAfee;i="6000,8403,9675"; a="135949652"
X-IronPort-AV: E=Sophos;i="5.75,325,1589266800"; 
   d="scan'208";a="135949652"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2020 16:48:11 -0700
IronPort-SDR: sgmLYaIfCFC6WOAdNfddBZ2rKjX80v2Qw6vDxNohgW9TdcFbM0DaMsA/uv3a+4a+MxLlphRRVt
 p8BZ9krIL7Ng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,325,1589266800"; 
   d="scan'208";a="483684032"
Received: from vapadgao-mobl.amr.corp.intel.com ([10.251.143.88])
  by fmsmga005.fm.intel.com with ESMTP; 07 Jul 2020 16:48:10 -0700
From:   Andre Guedes <andre.guedes@intel.com>
To:     netdev@vger.kernel.org
Cc:     intel-wired-lan@lists.osuosl.org
Subject: [PATCH ethtool 2/4] igc: Parse RCTL register fields
Date:   Tue,  7 Jul 2020 16:47:58 -0700
Message-Id: <20200707234800.39119-3-andre.guedes@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200707234800.39119-1-andre.guedes@intel.com>
References: <20200707234800.39119-1-andre.guedes@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for parsing the Receive Control (RCTL) register
fields.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
---
 igc.c | 91 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 90 insertions(+), 1 deletion(-)

diff --git a/igc.c b/igc.c
index 91ab64d..df3916c 100644
--- a/igc.c
+++ b/igc.c
@@ -7,6 +7,34 @@
 #define RAH_QSEL				0x000C0000
 #define RAH_QSEL_EN				0x10000000
 #define RAH_AV					0x80000000
+#define RCTL_RXEN				0x00000002
+#define RCTL_SBP				0x00000004
+#define RCTL_UPE				0x00000008
+#define RCTL_MPE				0x00000010
+#define RCTL_LPE				0x00000020
+#define RCTL_LBM				0x000000C0
+#define RCTL_LBM_PHY				0x00000000
+#define RCTL_LBM_MAC				0x00000040
+#define RCTL_HSEL				0x00000300
+#define RCTL_HSEL_MULTICAST			0x00000000
+#define RCTL_HSEL_UNICAST			0x00000100
+#define RCTL_HSEL_BOTH				0x00000200
+#define RCTL_MO					0x00003000
+#define RCTL_MO_47_36				0x00000000
+#define RCTL_MO_43_32				0x00001000
+#define RCTL_MO_39_28				0x00002000
+#define RCTL_BAM				0x00008000
+#define RCTL_BSIZE				0x00030000
+#define RCTL_BSIZE_2048				0x00000000
+#define RCTL_BSIZE_1024				0x00010000
+#define RCTL_BSIZE_512				0x00020000
+#define RCTL_VFE				0x00040000
+#define RCTL_CFIEN				0x00080000
+#define RCTL_CFI				0x00100000
+#define RCTL_PSP				0x00200000
+#define RCTL_DPF				0x00400000
+#define RCTL_PMCF				0x00800000
+#define RCTL_SECRC				0x04000000
 
 #define RAH_QSEL_SHIFT				18
 
@@ -15,6 +43,11 @@ static const char *bit_to_boolean(u32 val)
 	return val ? "True" : "False";
 }
 
+static const char *bit_to_enable(u32 val)
+{
+	return val ? "Enabled" : "Disabled";
+}
+
 int igc_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)
 {
 	u32 reg;
@@ -25,7 +58,63 @@ int igc_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)
 	if (version != 2)
 		return -1;
 
-	for (offset = 0; offset < 172; offset++) {
+	for (offset = 0; offset < 24; offset++) {
+		reg = regs_buff[offset];
+		printf("%04d: 0x%08X\n", offset, reg);
+	}
+
+	offset = 24;
+
+	reg = regs_buff[offset];
+	printf("%04d: RCTL (Receive Control Register)              \n"
+	       "    Receiver:                                    %s\n"
+	       "    Stop Bad Packets:                            %s\n"
+	       "    Unicast Promiscuous:                         %s\n"
+	       "    Multicast Promiscuous:                       %s\n"
+	       "    Long Packet Reception:                       %s\n"
+	       "    Loopback Model:                              %s\n"
+	       "    Hash Select for MTA:                         %s\n"
+	       "    Multicast/Unicast Table Offset:              %s\n"
+	       "    Broadcast Accept Mode:                       %s\n"
+	       "    Receive Buffer Size:                         %s\n"
+	       "    VLAN Filter:                                 %s\n"
+	       "    Canonical Form Indicator:                    %s\n"
+	       "    Canonical Form Indicator Bit:                %s\n"
+	       "    Pad Small Receive Packets:                   %s\n"
+	       "    Discard Pause Frames:                        %s\n"
+	       "    Pass MAC Control Frames:                     %s\n"
+	       "    Strip Ethernet CRC:                          %s\n",
+	       offset,
+	       bit_to_enable(reg & RCTL_RXEN),
+	       bit_to_enable(reg & RCTL_SBP),
+	       bit_to_enable(reg & RCTL_UPE),
+	       bit_to_enable(reg & RCTL_MPE),
+	       bit_to_enable(reg & RCTL_LPE),
+	       (reg & RCTL_LBM) == RCTL_LBM_PHY ? "PHY" :
+	       (reg & RCTL_LBM) == RCTL_LBM_MAC ? "MAC" :
+	       "Undefined",
+	       (reg & RCTL_HSEL) == RCTL_HSEL_MULTICAST ? "Multicast Only" :
+	       (reg & RCTL_HSEL) == RCTL_HSEL_UNICAST ? "Unicast Only" :
+	       (reg & RCTL_HSEL) == RCTL_HSEL_BOTH ? "Multicast and Unicast" :
+	       "Reserved",
+	       (reg & RCTL_MO) == RCTL_MO_47_36 ? "Bits [47:36]" :
+	       (reg & RCTL_MO) == RCTL_MO_43_32 ? "Bits [43:32]" :
+	       (reg & RCTL_MO) == RCTL_MO_39_28 ? "Bits [39:28]" :
+	       "Bits [35:24]",
+	       bit_to_enable(reg & RCTL_BAM),
+	       (reg & RCTL_BSIZE) == RCTL_BSIZE_2048 ? "2048 Bytes" :
+	       (reg & RCTL_BSIZE) == RCTL_BSIZE_1024 ? "1024 Bytes" :
+	       (reg & RCTL_BSIZE) == RCTL_BSIZE_512 ? "512 Bytes" :
+	       "256 Bytes",
+	       bit_to_enable(reg & RCTL_VFE),
+	       bit_to_enable(reg & RCTL_CFIEN),
+	       reg & RCTL_CFI ? "Discarded" : "Accepted",
+	       bit_to_enable(reg & RCTL_PSP),
+	       bit_to_enable(reg & RCTL_DPF),
+	       bit_to_enable(reg & RCTL_PMCF),
+	       bit_to_enable(reg & RCTL_SECRC));
+
+	for (offset = 25; offset < 172; offset++) {
 		reg = regs_buff[offset];
 		printf("%04d: 0x%08X\n", offset, reg);
 	}
-- 
2.26.2


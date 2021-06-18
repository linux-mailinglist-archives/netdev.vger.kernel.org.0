Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66F6F3AD05F
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 18:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235897AbhFRQ3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 12:29:19 -0400
Received: from mga18.intel.com ([134.134.136.126]:5464 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235882AbhFRQ3I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 12:29:08 -0400
IronPort-SDR: Prx5OH/YmtDoZSlYNfSh+DBEFn2G4ABLfMiJvjn+wPX7x0fcoz//IeGpVzi6M5IYAkDQmzvSNK
 7U1zoNZ2/+BA==
X-IronPort-AV: E=McAfee;i="6200,9189,10019"; a="193895225"
X-IronPort-AV: E=Sophos;i="5.83,284,1616482800"; 
   d="scan'208";a="193895225"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2021 09:26:53 -0700
IronPort-SDR: RsjRN9kWTaBzlMEx2QKnOak9gVbZu3yU1ejDzHR/bshrPhbIiGlt8yuZdhpgDqQCZc25Vr7b5h
 eGHVmkGKLZhA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,284,1616482800"; 
   d="scan'208";a="554781632"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 18 Jun 2021 09:26:53 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com, Dave Switzer <david.switzer@intel.com>
Subject: [PATCH net-next 2/3] i40e: clean up packet type lookup table
Date:   Fri, 18 Jun 2021 09:29:31 -0700
Message-Id: <20210618162932.859071-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210618162932.859071-1-anthony.l.nguyen@intel.com>
References: <20210618162932.859071-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

Remove the unused ptype struct value, which makes table init easier for
the zero entries, and use ranged initializer to remove a bunch of code
(works with gcc and clang). There is no significant functional change.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Dave Switzer <david.switzer@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
NOTE: this patch generates an expected checkpatch error due to the
tricky structure initializer macro.

 drivers/net/ethernet/intel/i40e/i40e_common.c | 124 +-----------------
 drivers/net/ethernet/intel/i40e/i40e_type.h   |   1 -
 2 files changed, 6 insertions(+), 119 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_common.c b/drivers/net/ethernet/intel/i40e/i40e_common.c
index 67cb0b47416a..b4d3fed0d2f2 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_common.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_common.c
@@ -552,9 +552,9 @@ i40e_status i40e_aq_set_rss_key(struct i40e_hw *hw,
  * ENDIF
  */
 
-/* macro to make the table lines short */
+/* macro to make the table lines short, use explicit indexing with [PTYPE] */
 #define I40E_PTT(PTYPE, OUTER_IP, OUTER_IP_VER, OUTER_FRAG, T, TE, TEF, I, PL)\
-	{	PTYPE, \
+	[PTYPE] = { \
 		1, \
 		I40E_RX_PTYPE_OUTER_##OUTER_IP, \
 		I40E_RX_PTYPE_OUTER_##OUTER_IP_VER, \
@@ -565,16 +565,15 @@ i40e_status i40e_aq_set_rss_key(struct i40e_hw *hw,
 		I40E_RX_PTYPE_INNER_PROT_##I, \
 		I40E_RX_PTYPE_PAYLOAD_LAYER_##PL }
 
-#define I40E_PTT_UNUSED_ENTRY(PTYPE) \
-		{ PTYPE, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
+#define I40E_PTT_UNUSED_ENTRY(PTYPE) [PTYPE] = { 0, 0, 0, 0, 0, 0, 0, 0, 0 }
 
 /* shorter macros makes the table fit but are terse */
 #define I40E_RX_PTYPE_NOF		I40E_RX_PTYPE_NOT_FRAG
 #define I40E_RX_PTYPE_FRG		I40E_RX_PTYPE_FRAG
 #define I40E_RX_PTYPE_INNER_PROT_TS	I40E_RX_PTYPE_INNER_PROT_TIMESYNC
 
-/* Lookup table mapping the HW PTYPE to the bit field for decoding */
-struct i40e_rx_ptype_decoded i40e_ptype_lookup[] = {
+/* Lookup table mapping in the 8-bit HW PTYPE to the bit field for decoding */
+struct i40e_rx_ptype_decoded i40e_ptype_lookup[BIT(8)] = {
 	/* L2 Packet types */
 	I40E_PTT_UNUSED_ENTRY(0),
 	I40E_PTT(1,  L2, NONE, NOF, NONE, NONE, NOF, NONE, PAY2),
@@ -780,118 +779,7 @@ struct i40e_rx_ptype_decoded i40e_ptype_lookup[] = {
 	I40E_PTT(153, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV6, NOF, ICMP, PAY4),
 
 	/* unused entries */
-	I40E_PTT_UNUSED_ENTRY(154),
-	I40E_PTT_UNUSED_ENTRY(155),
-	I40E_PTT_UNUSED_ENTRY(156),
-	I40E_PTT_UNUSED_ENTRY(157),
-	I40E_PTT_UNUSED_ENTRY(158),
-	I40E_PTT_UNUSED_ENTRY(159),
-
-	I40E_PTT_UNUSED_ENTRY(160),
-	I40E_PTT_UNUSED_ENTRY(161),
-	I40E_PTT_UNUSED_ENTRY(162),
-	I40E_PTT_UNUSED_ENTRY(163),
-	I40E_PTT_UNUSED_ENTRY(164),
-	I40E_PTT_UNUSED_ENTRY(165),
-	I40E_PTT_UNUSED_ENTRY(166),
-	I40E_PTT_UNUSED_ENTRY(167),
-	I40E_PTT_UNUSED_ENTRY(168),
-	I40E_PTT_UNUSED_ENTRY(169),
-
-	I40E_PTT_UNUSED_ENTRY(170),
-	I40E_PTT_UNUSED_ENTRY(171),
-	I40E_PTT_UNUSED_ENTRY(172),
-	I40E_PTT_UNUSED_ENTRY(173),
-	I40E_PTT_UNUSED_ENTRY(174),
-	I40E_PTT_UNUSED_ENTRY(175),
-	I40E_PTT_UNUSED_ENTRY(176),
-	I40E_PTT_UNUSED_ENTRY(177),
-	I40E_PTT_UNUSED_ENTRY(178),
-	I40E_PTT_UNUSED_ENTRY(179),
-
-	I40E_PTT_UNUSED_ENTRY(180),
-	I40E_PTT_UNUSED_ENTRY(181),
-	I40E_PTT_UNUSED_ENTRY(182),
-	I40E_PTT_UNUSED_ENTRY(183),
-	I40E_PTT_UNUSED_ENTRY(184),
-	I40E_PTT_UNUSED_ENTRY(185),
-	I40E_PTT_UNUSED_ENTRY(186),
-	I40E_PTT_UNUSED_ENTRY(187),
-	I40E_PTT_UNUSED_ENTRY(188),
-	I40E_PTT_UNUSED_ENTRY(189),
-
-	I40E_PTT_UNUSED_ENTRY(190),
-	I40E_PTT_UNUSED_ENTRY(191),
-	I40E_PTT_UNUSED_ENTRY(192),
-	I40E_PTT_UNUSED_ENTRY(193),
-	I40E_PTT_UNUSED_ENTRY(194),
-	I40E_PTT_UNUSED_ENTRY(195),
-	I40E_PTT_UNUSED_ENTRY(196),
-	I40E_PTT_UNUSED_ENTRY(197),
-	I40E_PTT_UNUSED_ENTRY(198),
-	I40E_PTT_UNUSED_ENTRY(199),
-
-	I40E_PTT_UNUSED_ENTRY(200),
-	I40E_PTT_UNUSED_ENTRY(201),
-	I40E_PTT_UNUSED_ENTRY(202),
-	I40E_PTT_UNUSED_ENTRY(203),
-	I40E_PTT_UNUSED_ENTRY(204),
-	I40E_PTT_UNUSED_ENTRY(205),
-	I40E_PTT_UNUSED_ENTRY(206),
-	I40E_PTT_UNUSED_ENTRY(207),
-	I40E_PTT_UNUSED_ENTRY(208),
-	I40E_PTT_UNUSED_ENTRY(209),
-
-	I40E_PTT_UNUSED_ENTRY(210),
-	I40E_PTT_UNUSED_ENTRY(211),
-	I40E_PTT_UNUSED_ENTRY(212),
-	I40E_PTT_UNUSED_ENTRY(213),
-	I40E_PTT_UNUSED_ENTRY(214),
-	I40E_PTT_UNUSED_ENTRY(215),
-	I40E_PTT_UNUSED_ENTRY(216),
-	I40E_PTT_UNUSED_ENTRY(217),
-	I40E_PTT_UNUSED_ENTRY(218),
-	I40E_PTT_UNUSED_ENTRY(219),
-
-	I40E_PTT_UNUSED_ENTRY(220),
-	I40E_PTT_UNUSED_ENTRY(221),
-	I40E_PTT_UNUSED_ENTRY(222),
-	I40E_PTT_UNUSED_ENTRY(223),
-	I40E_PTT_UNUSED_ENTRY(224),
-	I40E_PTT_UNUSED_ENTRY(225),
-	I40E_PTT_UNUSED_ENTRY(226),
-	I40E_PTT_UNUSED_ENTRY(227),
-	I40E_PTT_UNUSED_ENTRY(228),
-	I40E_PTT_UNUSED_ENTRY(229),
-
-	I40E_PTT_UNUSED_ENTRY(230),
-	I40E_PTT_UNUSED_ENTRY(231),
-	I40E_PTT_UNUSED_ENTRY(232),
-	I40E_PTT_UNUSED_ENTRY(233),
-	I40E_PTT_UNUSED_ENTRY(234),
-	I40E_PTT_UNUSED_ENTRY(235),
-	I40E_PTT_UNUSED_ENTRY(236),
-	I40E_PTT_UNUSED_ENTRY(237),
-	I40E_PTT_UNUSED_ENTRY(238),
-	I40E_PTT_UNUSED_ENTRY(239),
-
-	I40E_PTT_UNUSED_ENTRY(240),
-	I40E_PTT_UNUSED_ENTRY(241),
-	I40E_PTT_UNUSED_ENTRY(242),
-	I40E_PTT_UNUSED_ENTRY(243),
-	I40E_PTT_UNUSED_ENTRY(244),
-	I40E_PTT_UNUSED_ENTRY(245),
-	I40E_PTT_UNUSED_ENTRY(246),
-	I40E_PTT_UNUSED_ENTRY(247),
-	I40E_PTT_UNUSED_ENTRY(248),
-	I40E_PTT_UNUSED_ENTRY(249),
-
-	I40E_PTT_UNUSED_ENTRY(250),
-	I40E_PTT_UNUSED_ENTRY(251),
-	I40E_PTT_UNUSED_ENTRY(252),
-	I40E_PTT_UNUSED_ENTRY(253),
-	I40E_PTT_UNUSED_ENTRY(254),
-	I40E_PTT_UNUSED_ENTRY(255)
+	[154 ... 255] = { 0, 0, 0, 0, 0, 0, 0, 0, 0 }
 };
 
 /**
diff --git a/drivers/net/ethernet/intel/i40e/i40e_type.h b/drivers/net/ethernet/intel/i40e/i40e_type.h
index c81109a63e90..36a4ca1ffb1a 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_type.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_type.h
@@ -804,7 +804,6 @@ enum i40e_rx_l2_ptype {
 };
 
 struct i40e_rx_ptype_decoded {
-	u32 ptype:8;
 	u32 known:1;
 	u32 outer_ip:1;
 	u32 outer_ip_ver:1;
-- 
2.26.2


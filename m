Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6E223AD05D
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 18:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235886AbhFRQ3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 12:29:14 -0400
Received: from mga18.intel.com ([134.134.136.126]:5462 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235880AbhFRQ3H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 12:29:07 -0400
IronPort-SDR: 3lBpMweAlfzb3WhjxSWyxtTN0DWP3ZEfLcKqeU6KjY/ImtCpb54921EqbObm9g9WQxUzxvy2wB
 hvcbGBKYHAJQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10019"; a="193895226"
X-IronPort-AV: E=Sophos;i="5.83,284,1616482800"; 
   d="scan'208";a="193895226"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2021 09:26:53 -0700
IronPort-SDR: 3iKqhjkWzgILE0yWQkXw4UQnioB5d1KQheJDo+zksBKkPi9gd2xdJlAEVcecJKOAfCXB124SFt
 7uxUTnCX60Xw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,284,1616482800"; 
   d="scan'208";a="554781634"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 18 Jun 2021 09:26:53 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com
Subject: [PATCH net-next 3/3] iavf: clean up packet type lookup table
Date:   Fri, 18 Jun 2021 09:29:32 -0700
Message-Id: <20210618162932.859071-4-anthony.l.nguyen@intel.com>
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
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
NOTE: this patch generates an expected checkpatch error due to the
tricky structure initializer macro.

 drivers/net/ethernet/intel/iavf/iavf_common.c | 124 +-----------------
 drivers/net/ethernet/intel/iavf/iavf_type.h   |   1 -
 2 files changed, 6 insertions(+), 119 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_common.c b/drivers/net/ethernet/intel/iavf/iavf_common.c
index 8547fc8fdfd6..e9cc7f6ddc46 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_common.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_common.c
@@ -522,9 +522,9 @@ enum iavf_status iavf_aq_set_rss_key(struct iavf_hw *hw, u16 vsi_id,
  * ENDIF
  */
 
-/* macro to make the table lines short */
+/* macro to make the table lines short, use explicit indexing with [PTYPE] */
 #define IAVF_PTT(PTYPE, OUTER_IP, OUTER_IP_VER, OUTER_FRAG, T, TE, TEF, I, PL)\
-	{	PTYPE, \
+	[PTYPE] = { \
 		1, \
 		IAVF_RX_PTYPE_OUTER_##OUTER_IP, \
 		IAVF_RX_PTYPE_OUTER_##OUTER_IP_VER, \
@@ -535,16 +535,15 @@ enum iavf_status iavf_aq_set_rss_key(struct iavf_hw *hw, u16 vsi_id,
 		IAVF_RX_PTYPE_INNER_PROT_##I, \
 		IAVF_RX_PTYPE_PAYLOAD_LAYER_##PL }
 
-#define IAVF_PTT_UNUSED_ENTRY(PTYPE) \
-		{ PTYPE, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
+#define IAVF_PTT_UNUSED_ENTRY(PTYPE) [PTYPE] = { 0, 0, 0, 0, 0, 0, 0, 0, 0 }
 
 /* shorter macros makes the table fit but are terse */
 #define IAVF_RX_PTYPE_NOF		IAVF_RX_PTYPE_NOT_FRAG
 #define IAVF_RX_PTYPE_FRG		IAVF_RX_PTYPE_FRAG
 #define IAVF_RX_PTYPE_INNER_PROT_TS	IAVF_RX_PTYPE_INNER_PROT_TIMESYNC
 
-/* Lookup table mapping the HW PTYPE to the bit field for decoding */
-struct iavf_rx_ptype_decoded iavf_ptype_lookup[] = {
+/* Lookup table mapping the 8-bit HW PTYPE to the bit field for decoding */
+struct iavf_rx_ptype_decoded iavf_ptype_lookup[BIT(8)] = {
 	/* L2 Packet types */
 	IAVF_PTT_UNUSED_ENTRY(0),
 	IAVF_PTT(1,  L2, NONE, NOF, NONE, NONE, NOF, NONE, PAY2),
@@ -750,118 +749,7 @@ struct iavf_rx_ptype_decoded iavf_ptype_lookup[] = {
 	IAVF_PTT(153, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV6, NOF, ICMP, PAY4),
 
 	/* unused entries */
-	IAVF_PTT_UNUSED_ENTRY(154),
-	IAVF_PTT_UNUSED_ENTRY(155),
-	IAVF_PTT_UNUSED_ENTRY(156),
-	IAVF_PTT_UNUSED_ENTRY(157),
-	IAVF_PTT_UNUSED_ENTRY(158),
-	IAVF_PTT_UNUSED_ENTRY(159),
-
-	IAVF_PTT_UNUSED_ENTRY(160),
-	IAVF_PTT_UNUSED_ENTRY(161),
-	IAVF_PTT_UNUSED_ENTRY(162),
-	IAVF_PTT_UNUSED_ENTRY(163),
-	IAVF_PTT_UNUSED_ENTRY(164),
-	IAVF_PTT_UNUSED_ENTRY(165),
-	IAVF_PTT_UNUSED_ENTRY(166),
-	IAVF_PTT_UNUSED_ENTRY(167),
-	IAVF_PTT_UNUSED_ENTRY(168),
-	IAVF_PTT_UNUSED_ENTRY(169),
-
-	IAVF_PTT_UNUSED_ENTRY(170),
-	IAVF_PTT_UNUSED_ENTRY(171),
-	IAVF_PTT_UNUSED_ENTRY(172),
-	IAVF_PTT_UNUSED_ENTRY(173),
-	IAVF_PTT_UNUSED_ENTRY(174),
-	IAVF_PTT_UNUSED_ENTRY(175),
-	IAVF_PTT_UNUSED_ENTRY(176),
-	IAVF_PTT_UNUSED_ENTRY(177),
-	IAVF_PTT_UNUSED_ENTRY(178),
-	IAVF_PTT_UNUSED_ENTRY(179),
-
-	IAVF_PTT_UNUSED_ENTRY(180),
-	IAVF_PTT_UNUSED_ENTRY(181),
-	IAVF_PTT_UNUSED_ENTRY(182),
-	IAVF_PTT_UNUSED_ENTRY(183),
-	IAVF_PTT_UNUSED_ENTRY(184),
-	IAVF_PTT_UNUSED_ENTRY(185),
-	IAVF_PTT_UNUSED_ENTRY(186),
-	IAVF_PTT_UNUSED_ENTRY(187),
-	IAVF_PTT_UNUSED_ENTRY(188),
-	IAVF_PTT_UNUSED_ENTRY(189),
-
-	IAVF_PTT_UNUSED_ENTRY(190),
-	IAVF_PTT_UNUSED_ENTRY(191),
-	IAVF_PTT_UNUSED_ENTRY(192),
-	IAVF_PTT_UNUSED_ENTRY(193),
-	IAVF_PTT_UNUSED_ENTRY(194),
-	IAVF_PTT_UNUSED_ENTRY(195),
-	IAVF_PTT_UNUSED_ENTRY(196),
-	IAVF_PTT_UNUSED_ENTRY(197),
-	IAVF_PTT_UNUSED_ENTRY(198),
-	IAVF_PTT_UNUSED_ENTRY(199),
-
-	IAVF_PTT_UNUSED_ENTRY(200),
-	IAVF_PTT_UNUSED_ENTRY(201),
-	IAVF_PTT_UNUSED_ENTRY(202),
-	IAVF_PTT_UNUSED_ENTRY(203),
-	IAVF_PTT_UNUSED_ENTRY(204),
-	IAVF_PTT_UNUSED_ENTRY(205),
-	IAVF_PTT_UNUSED_ENTRY(206),
-	IAVF_PTT_UNUSED_ENTRY(207),
-	IAVF_PTT_UNUSED_ENTRY(208),
-	IAVF_PTT_UNUSED_ENTRY(209),
-
-	IAVF_PTT_UNUSED_ENTRY(210),
-	IAVF_PTT_UNUSED_ENTRY(211),
-	IAVF_PTT_UNUSED_ENTRY(212),
-	IAVF_PTT_UNUSED_ENTRY(213),
-	IAVF_PTT_UNUSED_ENTRY(214),
-	IAVF_PTT_UNUSED_ENTRY(215),
-	IAVF_PTT_UNUSED_ENTRY(216),
-	IAVF_PTT_UNUSED_ENTRY(217),
-	IAVF_PTT_UNUSED_ENTRY(218),
-	IAVF_PTT_UNUSED_ENTRY(219),
-
-	IAVF_PTT_UNUSED_ENTRY(220),
-	IAVF_PTT_UNUSED_ENTRY(221),
-	IAVF_PTT_UNUSED_ENTRY(222),
-	IAVF_PTT_UNUSED_ENTRY(223),
-	IAVF_PTT_UNUSED_ENTRY(224),
-	IAVF_PTT_UNUSED_ENTRY(225),
-	IAVF_PTT_UNUSED_ENTRY(226),
-	IAVF_PTT_UNUSED_ENTRY(227),
-	IAVF_PTT_UNUSED_ENTRY(228),
-	IAVF_PTT_UNUSED_ENTRY(229),
-
-	IAVF_PTT_UNUSED_ENTRY(230),
-	IAVF_PTT_UNUSED_ENTRY(231),
-	IAVF_PTT_UNUSED_ENTRY(232),
-	IAVF_PTT_UNUSED_ENTRY(233),
-	IAVF_PTT_UNUSED_ENTRY(234),
-	IAVF_PTT_UNUSED_ENTRY(235),
-	IAVF_PTT_UNUSED_ENTRY(236),
-	IAVF_PTT_UNUSED_ENTRY(237),
-	IAVF_PTT_UNUSED_ENTRY(238),
-	IAVF_PTT_UNUSED_ENTRY(239),
-
-	IAVF_PTT_UNUSED_ENTRY(240),
-	IAVF_PTT_UNUSED_ENTRY(241),
-	IAVF_PTT_UNUSED_ENTRY(242),
-	IAVF_PTT_UNUSED_ENTRY(243),
-	IAVF_PTT_UNUSED_ENTRY(244),
-	IAVF_PTT_UNUSED_ENTRY(245),
-	IAVF_PTT_UNUSED_ENTRY(246),
-	IAVF_PTT_UNUSED_ENTRY(247),
-	IAVF_PTT_UNUSED_ENTRY(248),
-	IAVF_PTT_UNUSED_ENTRY(249),
-
-	IAVF_PTT_UNUSED_ENTRY(250),
-	IAVF_PTT_UNUSED_ENTRY(251),
-	IAVF_PTT_UNUSED_ENTRY(252),
-	IAVF_PTT_UNUSED_ENTRY(253),
-	IAVF_PTT_UNUSED_ENTRY(254),
-	IAVF_PTT_UNUSED_ENTRY(255)
+	[154 ... 255] = { 0, 0, 0, 0, 0, 0, 0, 0, 0 }
 };
 
 /**
diff --git a/drivers/net/ethernet/intel/iavf/iavf_type.h b/drivers/net/ethernet/intel/iavf/iavf_type.h
index de9fda78b43a..9f1f523807c4 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_type.h
+++ b/drivers/net/ethernet/intel/iavf/iavf_type.h
@@ -370,7 +370,6 @@ enum iavf_rx_l2_ptype {
 };
 
 struct iavf_rx_ptype_decoded {
-	u32 ptype:8;
 	u32 known:1;
 	u32 outer_ip:1;
 	u32 outer_ip_ver:1;
-- 
2.26.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D30AF28664F
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 19:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728788AbgJGRzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 13:55:04 -0400
Received: from mga17.intel.com ([192.55.52.151]:18440 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727697AbgJGRzB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 13:55:01 -0400
IronPort-SDR: pWgho0TGgq5AKHyoK4tHYz2akOd8t/vt4S7v9E2Wvw9kRxg3bxSrXuLnQPyIc7yLJ5vxyduEZX
 QpS38iZ0l4vA==
X-IronPort-AV: E=McAfee;i="6000,8403,9767"; a="144957659"
X-IronPort-AV: E=Sophos;i="5.77,347,1596524400"; 
   d="scan'208";a="144957659"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2020 10:54:59 -0700
IronPort-SDR: B7pYKyFqpGryfs9wCKFCWCLptdGhTRq08ZK2tCSrw4uwtfUnz5R/pN7S/fY9FE4R/RkS14iIQh
 kmmtqbszoKWQ==
X-IronPort-AV: E=Sophos;i="5.77,347,1596524400"; 
   d="scan'208";a="518935800"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2020 10:54:59 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Dan Nowlin <dan.nowlin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Henry Tieman <henry.w.tieman@intel.com>,
        Brijesh Behera <brijeshx.behera@intel.com>
Subject: [net-next 8/8] ice: fix adding IP4 IP6 Flow Director rules
Date:   Wed,  7 Oct 2020 10:54:47 -0700
Message-Id: <20201007175447.647867-9-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201007175447.647867-1-anthony.l.nguyen@intel.com>
References: <20201007175447.647867-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Nowlin <dan.nowlin@intel.com>

A subsequent addition of an IP4 or IP6 rule after other rules would
overwrite any existing TCAM entries of related L4 protocols(ex: tcp4 or
udp6). This was due to the mask including too many TCAM entries. Add new
packet type masks with bits properly excluded so rules are not overwritten.

Signed-off-by: Dan Nowlin <dan.nowlin@intel.com>
Signed-off-by: Henry Tieman <henry.w.tieman@intel.com>
Tested-by: Brijesh Behera <brijeshx.behera@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_flow.c | 62 ++++++++++++++++++++++-
 1 file changed, 61 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_flow.c b/drivers/net/ethernet/intel/ice/ice_flow.c
index 45fa3d9e3af2..eadc85aee389 100644
--- a/drivers/net/ethernet/intel/ice/ice_flow.c
+++ b/drivers/net/ethernet/intel/ice/ice_flow.c
@@ -99,6 +99,54 @@ static const u32 ice_ptypes_ipv6_il[] = {
 	0x00000000, 0x00000000, 0x00000000, 0x00000000,
 };
 
+/* Packet types for packets with an Outer/First/Single IPv4 header - no L4 */
+static const u32 ice_ipv4_ofos_no_l4[] = {
+	0x10C00000, 0x04000800, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+};
+
+/* Packet types for packets with an Innermost/Last IPv4 header - no L4 */
+static const u32 ice_ipv4_il_no_l4[] = {
+	0x60000000, 0x18043008, 0x80000002, 0x6010c021,
+	0x00000008, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+};
+
+/* Packet types for packets with an Outer/First/Single IPv6 header - no L4 */
+static const u32 ice_ipv6_ofos_no_l4[] = {
+	0x00000000, 0x00000000, 0x43000000, 0x10002000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+};
+
+/* Packet types for packets with an Innermost/Last IPv6 header - no L4 */
+static const u32 ice_ipv6_il_no_l4[] = {
+	0x00000000, 0x02180430, 0x0000010c, 0x086010c0,
+	0x00000430, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+	0x00000000, 0x00000000, 0x00000000, 0x00000000,
+};
+
 /* UDP Packet types for non-tunneled packets or tunneled
  * packets with inner UDP.
  */
@@ -250,11 +298,23 @@ ice_flow_proc_seg_hdrs(struct ice_flow_prof_params *params)
 
 		hdrs = prof->segs[i].hdrs;
 
-		if (hdrs & ICE_FLOW_SEG_HDR_IPV4) {
+		if ((hdrs & ICE_FLOW_SEG_HDR_IPV4) &&
+		    !(hdrs & ICE_FLOW_SEG_HDRS_L4_MASK)) {
+			src = !i ? (const unsigned long *)ice_ipv4_ofos_no_l4 :
+				(const unsigned long *)ice_ipv4_il_no_l4;
+			bitmap_and(params->ptypes, params->ptypes, src,
+				   ICE_FLOW_PTYPE_MAX);
+		} else if (hdrs & ICE_FLOW_SEG_HDR_IPV4) {
 			src = !i ? (const unsigned long *)ice_ptypes_ipv4_ofos :
 				(const unsigned long *)ice_ptypes_ipv4_il;
 			bitmap_and(params->ptypes, params->ptypes, src,
 				   ICE_FLOW_PTYPE_MAX);
+		} else if ((hdrs & ICE_FLOW_SEG_HDR_IPV6) &&
+			   !(hdrs & ICE_FLOW_SEG_HDRS_L4_MASK)) {
+			src = !i ? (const unsigned long *)ice_ipv6_ofos_no_l4 :
+				(const unsigned long *)ice_ipv6_il_no_l4;
+			bitmap_and(params->ptypes, params->ptypes, src,
+				   ICE_FLOW_PTYPE_MAX);
 		} else if (hdrs & ICE_FLOW_SEG_HDR_IPV6) {
 			src = !i ? (const unsigned long *)ice_ptypes_ipv6_ofos :
 				(const unsigned long *)ice_ptypes_ipv6_il;
-- 
2.26.2


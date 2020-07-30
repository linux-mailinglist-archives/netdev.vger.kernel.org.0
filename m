Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16CD4233625
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 17:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729797AbgG3P7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 11:59:24 -0400
Received: from mga06.intel.com ([134.134.136.31]:55333 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729762AbgG3P7Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 11:59:24 -0400
IronPort-SDR: pRffL/TDrPgCh+YzxskScI2cApssDvZA/yj2pwk5VQKmoSvkWkO6KJr0cPavLJr41rn+dPtSbL
 PaL+LrZRKvyw==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="213160400"
X-IronPort-AV: E=Sophos;i="5.75,415,1589266800"; 
   d="scan'208";a="213160400"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2020 08:59:24 -0700
IronPort-SDR: /TDh4YPfwGmmJ6gZEMRvHokUAGe577Hsbw6nVsG+55x7t10e4/cdEB4MZrN06pkTRMbI/h8cpm
 2mxkS8BqkbDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,415,1589266800"; 
   d="scan'208";a="435086640"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga004.jf.intel.com with ESMTP; 30 Jul 2020 08:59:22 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 52478119; Thu, 30 Jul 2020 18:59:21 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Ariel Elior <aelior@marvell.com>, GR-everest-linux-l2@marvell.com,
        Alexander Lobakin <alobakin@marvell.com>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1] qed: Use %pM format specifier for MAC addresses
Date:   Thu, 30 Jul 2020 18:59:20 +0300
Message-Id: <20200730155920.40408-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert to %pM instead of using custom code.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/net/ethernet/qlogic/qed/qed_mcp.c   | 5 ++---
 drivers/net/ethernet/qlogic/qed/qed_sriov.c | 6 ++----
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.c b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
index 988d84564849..5be08f83e0aa 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
@@ -2518,11 +2518,10 @@ int qed_mcp_fill_shmem_func_info(struct qed_hwfn *p_hwfn,
 	}
 
 	DP_VERBOSE(p_hwfn, (QED_MSG_SP | NETIF_MSG_IFUP),
-		   "Read configuration from shmem: pause_on_host %02x protocol %02x BW [%02x - %02x] MAC %02x:%02x:%02x:%02x:%02x:%02x wwn port %llx node %llx ovlan %04x wol %02x\n",
+		   "Read configuration from shmem: pause_on_host %02x protocol %02x BW [%02x - %02x] MAC %pM wwn port %llx node %llx ovlan %04x wol %02x\n",
 		info->pause_on_host, info->protocol,
 		info->bandwidth_min, info->bandwidth_max,
-		info->mac[0], info->mac[1], info->mac[2],
-		info->mac[3], info->mac[4], info->mac[5],
+		info->mac,
 		info->wwn_port, info->wwn_node,
 		info->ovlan, (u8)p_hwfn->hw_info.b_wol_support);
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_sriov.c b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
index aa215eeeb4df..9489089706fe 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sriov.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
@@ -3276,14 +3276,12 @@ static void qed_iov_vf_mbx_ucast_filter(struct qed_hwfn *p_hwfn,
 
 	DP_VERBOSE(p_hwfn,
 		   QED_MSG_IOV,
-		   "VF[%d]: opcode 0x%02x type 0x%02x [%s %s] [vport 0x%02x] MAC %02x:%02x:%02x:%02x:%02x:%02x, vlan 0x%04x\n",
+		   "VF[%d]: opcode 0x%02x type 0x%02x [%s %s] [vport 0x%02x] MAC %pM, vlan 0x%04x\n",
 		   vf->abs_vf_id, params.opcode, params.type,
 		   params.is_rx_filter ? "RX" : "",
 		   params.is_tx_filter ? "TX" : "",
 		   params.vport_to_add_to,
-		   params.mac[0], params.mac[1],
-		   params.mac[2], params.mac[3],
-		   params.mac[4], params.mac[5], params.vlan);
+		   params.mac, params.vlan);
 
 	if (!vf->vport_instance) {
 		DP_VERBOSE(p_hwfn,
-- 
2.27.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EEFC13C49
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 01:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727258AbfEDXtb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 19:49:31 -0400
Received: from mga03.intel.com ([134.134.136.65]:20569 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727174AbfEDXtb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 May 2019 19:49:31 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 May 2019 16:49:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,431,1549958400"; 
   d="scan'208";a="139994677"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga008.jf.intel.com with ESMTP; 04 May 2019 16:49:30 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 13/15] ice: Use bitfields where possible
Date:   Sat,  4 May 2019 16:49:27 -0700
Message-Id: <20190504234929.3005-14-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190504234929.3005-1-jeffrey.t.kirsher@intel.com>
References: <20190504234929.3005-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

The driver was converted to not use bool, but it was
neglected that the bools should have been converted to bit fields
as bit fields in software structures are ok, as long as they
use the correct kinds of unsigned types. This avoids
wasting lots of storage space to store single bit values.

One of the change hunks moves a variable lport out of
a group of "combinable" bit fields because all bits of
the u8 lport are valid and the variable can be packed in the
struct in struct holes.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_type.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index 77bc0439e108..a862af4cbf78 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -326,6 +326,8 @@ struct ice_port_info {
 	u8 port_state;
 #define ICE_SCHED_PORT_STATE_INIT	0x0
 #define ICE_SCHED_PORT_STATE_READY	0x1
+	u8 lport;
+#define ICE_LPORT_MASK			0xff
 	u16 dflt_tx_vsi_rule_id;
 	u16 dflt_tx_vsi_num;
 	u16 dflt_rx_vsi_rule_id;
@@ -339,11 +341,9 @@ struct ice_port_info {
 	struct ice_dcbx_cfg remote_dcbx_cfg;	/* Peer Cfg */
 	struct ice_dcbx_cfg desired_dcbx_cfg;	/* CEE Desired Cfg */
 	/* LLDP/DCBX Status */
-	u8 dcbx_status;
-	u8 is_sw_lldp;
-	u8 lport;
-#define ICE_LPORT_MASK		0xff
-	u8 is_vf;
+	u8 dcbx_status:3;		/* see ICE_DCBX_STATUS_DIS */
+	u8 is_sw_lldp:1;
+	u8 is_vf:1;
 };
 
 struct ice_switch_info {
-- 
2.20.1


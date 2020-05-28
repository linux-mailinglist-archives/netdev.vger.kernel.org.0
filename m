Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 853771E5885
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 09:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbgE1HZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 03:25:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:14682 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726467AbgE1HZm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 03:25:42 -0400
IronPort-SDR: hMbLhpIlWdn91i6s3Dp73aWdTFAclrLrADc/+SHaTidpWxJJf8RkB3edtWrCjpckE9fC3Fjzmw
 6F/FnkDkQG7g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2020 00:25:41 -0700
IronPort-SDR: NDFEoLio8WpxICJ+oiHIYWatG8jJPMaYW+gJgJuHca6Y3w69mQBgZvQjzhPY6Vkzq8dqwB6TVH
 UXVTd6Ni9c9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,443,1583222400"; 
   d="scan'208";a="310831109"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by FMSMGA003.fm.intel.com with ESMTP; 28 May 2020 00:25:41 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 04/15] ice: fix MAC write command
Date:   Thu, 28 May 2020 00:25:27 -0700
Message-Id: <20200528072538.1621790-5-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200528072538.1621790-1-jeffrey.t.kirsher@intel.com>
References: <20200528072538.1621790-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

The manage MAC write command was implemented in an overly complex way
that actually didn't work, as it wasn't symmetric to the manage MAC
read command, and was feeding bytes out of order to the firmware. Fix
the implementation by just using a simple array to represent the MAC
address when it is being written via firmware command.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_adminq_cmd.h | 10 ++++------
 drivers/net/ethernet/intel/ice/ice_common.c     |  5 +----
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 586d69491268..f04c338fb6e0 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -156,13 +156,11 @@ struct ice_aqc_manage_mac_write {
 #define ICE_AQC_MAN_MAC_WR_MC_MAG_EN		BIT(0)
 #define ICE_AQC_MAN_MAC_WR_WOL_LAA_PFR_KEEP	BIT(1)
 #define ICE_AQC_MAN_MAC_WR_S		6
-#define ICE_AQC_MAN_MAC_WR_M		(3 << ICE_AQC_MAN_MAC_WR_S)
+#define ICE_AQC_MAN_MAC_WR_M		ICE_M(3, ICE_AQC_MAN_MAC_WR_S)
 #define ICE_AQC_MAN_MAC_UPDATE_LAA	0
-#define ICE_AQC_MAN_MAC_UPDATE_LAA_WOL	(BIT(0) << ICE_AQC_MAN_MAC_WR_S)
-	/* High 16 bits of MAC address in big endian order */
-	__be16 sah;
-	/* Low 32 bits of MAC address in big endian order */
-	__be32 sal;
+#define ICE_AQC_MAN_MAC_UPDATE_LAA_WOL	BIT(ICE_AQC_MAN_MAC_WR_S)
+	/* byte stream in network order */
+	u8 mac_addr[ETH_ALEN];
 	__le32 addr_high;
 	__le32 addr_low;
 };
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 0a0b00fffaf7..5da369ae33e0 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -1994,10 +1994,7 @@ ice_aq_manage_mac_write(struct ice_hw *hw, const u8 *mac_addr, u8 flags,
 	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_manage_mac_write);
 
 	cmd->flags = flags;
-
-	/* Prep values for flags, sah, sal */
-	cmd->sah = htons(*((const u16 *)mac_addr));
-	cmd->sal = htonl(*((const u32 *)(mac_addr + 2)));
+	ether_addr_copy(cmd->mac_addr, mac_addr);
 
 	return ice_aq_send_cmd(hw, &desc, NULL, 0, cd);
 }
-- 
2.26.2


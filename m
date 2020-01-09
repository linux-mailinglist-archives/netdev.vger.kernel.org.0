Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0541F135F9E
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 18:47:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388312AbgAIRrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 12:47:20 -0500
Received: from mga17.intel.com ([192.55.52.151]:61388 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388303AbgAIRrQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 12:47:16 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jan 2020 09:47:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,414,1571727600"; 
   d="scan'208";a="254669801"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by fmsmga002.fm.intel.com with ESMTP; 09 Jan 2020 09:47:15 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Adam Ludkiewicz <adam.ludkiewicz@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net 6/7] i40e: Set PHY Access flag on X722
Date:   Thu,  9 Jan 2020 09:47:12 -0800
Message-Id: <20200109174713.2940499-7-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200109174713.2940499-1-jeffrey.t.kirsher@intel.com>
References: <20200109174713.2940499-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Adam Ludkiewicz <adam.ludkiewicz@intel.com>

The X722 FW API version 1.9 adds support for accessing PHY
registers with Admin Queue Command. This enables reading
EEPROM data from (Q)SFP+ transceivers, what was previously
possible only on X710 devices.

Signed-off-by: Adam Ludkiewicz <adam.ludkiewicz@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_adminq.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_adminq.c b/drivers/net/ethernet/intel/i40e/i40e_adminq.c
index 9f0a4e92a231..37514a75f928 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_adminq.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_adminq.c
@@ -536,6 +536,11 @@ static void i40e_set_hw_flags(struct i40e_hw *hw)
 		    (aq->api_maj_ver == 1 &&
 		     aq->api_min_ver >= I40E_MINOR_VER_FW_LLDP_STOPPABLE_X722))
 			hw->flags |= I40E_HW_FLAG_FW_LLDP_STOPPABLE;
+
+		if (aq->api_maj_ver > 1 ||
+		    (aq->api_maj_ver == 1 &&
+		     aq->api_min_ver >= I40E_MINOR_VER_GET_LINK_INFO_X722))
+			hw->flags |= I40E_HW_FLAG_AQ_PHY_ACCESS_CAPABLE;
 		/* fall through */
 	default:
 		break;
-- 
2.24.1


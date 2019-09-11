Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCD42B0205
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 18:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729432AbfIKQuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 12:50:19 -0400
Received: from mga14.intel.com ([192.55.52.115]:31967 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729381AbfIKQuR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Sep 2019 12:50:17 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Sep 2019 09:50:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,489,1559545200"; 
   d="scan'208";a="385759062"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga006.fm.intel.com with ESMTP; 11 Sep 2019 09:50:16 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 07/13] i40e: fix missed "Negotiated" string in i40e_print_link_message()
Date:   Wed, 11 Sep 2019 09:50:08 -0700
Message-Id: <20190911165014.10742-8-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190911165014.10742-1-jeffrey.t.kirsher@intel.com>
References: <20190911165014.10742-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aleksandr Loktionov <aleksandr.loktionov@intel.com>

The "Negotiated" string in i40e_print_link_message() function was missed.
This string has been added to the dmesg and small refactoring done removing
common substrings and unifying link status message format.
Without this patch it was not clear that FEC is related to negotiated FEC.

Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 3e2e465f43f9..700f38ec8e91 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -6569,19 +6569,19 @@ void i40e_print_link_message(struct i40e_vsi *vsi, bool isup)
 	}
 
 	if (pf->hw.phy.link_info.link_speed == I40E_LINK_SPEED_25GB) {
-		req_fec = ", Requested FEC: None";
-		fec = ", FEC: None";
-		an = ", Autoneg: False";
+		req_fec = "None";
+		fec = "None";
+		an = "False";
 
 		if (pf->hw.phy.link_info.an_info & I40E_AQ_AN_COMPLETED)
-			an = ", Autoneg: True";
+			an = "True";
 
 		if (pf->hw.phy.link_info.fec_info &
 		    I40E_AQ_CONFIG_FEC_KR_ENA)
-			fec = ", FEC: CL74 FC-FEC/BASE-R";
+			fec = "CL74 FC-FEC/BASE-R";
 		else if (pf->hw.phy.link_info.fec_info &
 			 I40E_AQ_CONFIG_FEC_RS_ENA)
-			fec = ", FEC: CL108 RS-FEC";
+			fec = "CL108 RS-FEC";
 
 		/* 'CL108 RS-FEC' should be displayed when RS is requested, or
 		 * both RS and FC are requested
@@ -6590,13 +6590,14 @@ void i40e_print_link_message(struct i40e_vsi *vsi, bool isup)
 		    (I40E_AQ_REQUEST_FEC_KR | I40E_AQ_REQUEST_FEC_RS)) {
 			if (vsi->back->hw.phy.link_info.req_fec_info &
 			    I40E_AQ_REQUEST_FEC_RS)
-				req_fec = ", Requested FEC: CL108 RS-FEC";
+				req_fec = "CL108 RS-FEC";
 			else
-				req_fec = ", Requested FEC: CL74 FC-FEC/BASE-R";
+				req_fec = "CL74 FC-FEC/BASE-R";
 		}
 	}
 
-	netdev_info(vsi->netdev, "NIC Link is Up, %sbps Full Duplex%s%s%s, Flow Control: %s\n",
+	netdev_info(vsi->netdev,
+		    "NIC Link is Up, %sbps Full Duplex, Requested FEC: %s, Negotiated FEC: %s, Autoneg: %s, Flow Control: %s\n",
 		    speed, req_fec, fec, an, fc);
 }
 
-- 
2.21.0


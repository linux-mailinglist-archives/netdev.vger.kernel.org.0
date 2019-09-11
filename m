Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43C5EB0204
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 18:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729269AbfIKQuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 12:50:18 -0400
Received: from mga14.intel.com ([192.55.52.115]:31971 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729386AbfIKQuR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Sep 2019 12:50:17 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Sep 2019 09:50:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,489,1559545200"; 
   d="scan'208";a="385759065"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga006.fm.intel.com with ESMTP; 11 Sep 2019 09:50:16 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Czeslaw Zagorski <czeslawx.zagorski@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 08/13] i40e: Fix message for other card without FEC.
Date:   Wed, 11 Sep 2019 09:50:09 -0700
Message-Id: <20190911165014.10742-9-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190911165014.10742-1-jeffrey.t.kirsher@intel.com>
References: <20190911165014.10742-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Czeslaw Zagorski <czeslawx.zagorski@intel.com>

When variable "req_fec, fec, an" are empty,
dmesg shows log with "Requested FEC: , Negotiated FEC: , Autoneg:".
Add link dmesg log for cards without FEC.

Signed-off-by: Czeslaw Zagorski <czeslawx.zagorski@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 700f38ec8e91..6031223eafab 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -6594,11 +6594,15 @@ void i40e_print_link_message(struct i40e_vsi *vsi, bool isup)
 			else
 				req_fec = "CL74 FC-FEC/BASE-R";
 		}
+		netdev_info(vsi->netdev,
+			    "NIC Link is Up, %sbps Full Duplex, Requested FEC: %s, Negotiated FEC: %s, Autoneg: %s, Flow Control: %s\n",
+			    speed, req_fec, fec, an, fc);
+	} else {
+		netdev_info(vsi->netdev,
+			    "NIC Link is Up, %sbps Full Duplex, Flow Control: %s\n",
+			    speed, fc);
 	}
 
-	netdev_info(vsi->netdev,
-		    "NIC Link is Up, %sbps Full Duplex, Requested FEC: %s, Negotiated FEC: %s, Autoneg: %s, Flow Control: %s\n",
-		    speed, req_fec, fec, an, fc);
 }
 
 /**
-- 
2.21.0


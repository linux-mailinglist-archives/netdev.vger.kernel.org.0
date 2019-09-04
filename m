Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A65CA79E9
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 06:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728327AbfIDEfU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 00:35:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:26532 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728158AbfIDEfS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 00:35:18 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Sep 2019 21:35:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,465,1559545200"; 
   d="scan'208";a="176804399"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga008.jf.intel.com with ESMTP; 03 Sep 2019 21:35:13 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Chinh T Cao <chinh.t.cao@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 04/15] ice: Deduce TSA value from the priority value in the CEE mode
Date:   Tue,  3 Sep 2019 21:35:01 -0700
Message-Id: <20190904043512.28066-5-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190904043512.28066-1-jeffrey.t.kirsher@intel.com>
References: <20190904043512.28066-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chinh T Cao <chinh.t.cao@intel.com>

In CEE mode, the TSA information can be derived from the reported
priority value.

Signed-off-by: Chinh T Cao <chinh.t.cao@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_dcb.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_dcb.c b/drivers/net/ethernet/intel/ice/ice_dcb.c
index d60c942249e8..c5ee8d930611 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb.c
@@ -444,9 +444,15 @@ ice_parse_cee_pgcfg_tlv(struct ice_cee_feat_tlv *tlv,
 	 *        |pg0|pg1|pg2|pg3|pg4|pg5|pg6|pg7|
 	 *        ---------------------------------
 	 */
-	ice_for_each_traffic_class(i)
+	ice_for_each_traffic_class(i) {
 		etscfg->tcbwtable[i] = buf[offset++];
 
+		if (etscfg->prio_table[i] == ICE_CEE_PGID_STRICT)
+			dcbcfg->etscfg.tsatable[i] = ICE_IEEE_TSA_STRICT;
+		else
+			dcbcfg->etscfg.tsatable[i] = ICE_IEEE_TSA_ETS;
+	}
+
 	/* Number of TCs supported (1 octet) */
 	etscfg->maxtcs = buf[offset];
 }
-- 
2.21.0


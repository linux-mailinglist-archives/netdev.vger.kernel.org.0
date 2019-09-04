Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98E62A79F5
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 06:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728558AbfIDEfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 00:35:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:26525 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728196AbfIDEfS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 00:35:18 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Sep 2019 21:35:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,465,1559545200"; 
   d="scan'208";a="176804390"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga008.jf.intel.com with ESMTP; 03 Sep 2019 21:35:13 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 01/15] ice: Fix EMP reset handling
Date:   Tue,  3 Sep 2019 21:34:58 -0700
Message-Id: <20190904043512.28066-2-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190904043512.28066-1-jeffrey.t.kirsher@intel.com>
References: <20190904043512.28066-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

ice_reset_subtask needs to handle EMP resets as well, as EMP resets
can be triggered by the firmware. This patch adds the logic to do
this.

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index f029aee32913..b62c01ca9c28 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -567,6 +567,8 @@ static void ice_reset_subtask(struct ice_pf *pf)
 			reset_type = ICE_RESET_CORER;
 		if (test_and_clear_bit(__ICE_GLOBR_RECV, pf->state))
 			reset_type = ICE_RESET_GLOBR;
+		if (test_and_clear_bit(__ICE_EMPR_RECV, pf->state))
+			reset_type = ICE_RESET_EMPR;
 		/* return if no valid reset type requested */
 		if (reset_type == ICE_RESET_INVAL)
 			return;
-- 
2.21.0


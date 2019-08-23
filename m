Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C48CE9B8F8
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 01:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727745AbfHWXiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 19:38:10 -0400
Received: from mga06.intel.com ([134.134.136.31]:14903 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727052AbfHWXhy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 19:37:54 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Aug 2019 16:37:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,422,1559545200"; 
   d="scan'208";a="184354435"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga006.jf.intel.com with ESMTP; 23 Aug 2019 16:37:51 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Chinh T Cao <chinh.t.cao@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 10/14] ice: Don't clear auto_fec bit in ice_cfg_phy_fec()
Date:   Fri, 23 Aug 2019 16:37:46 -0700
Message-Id: <20190823233750.7997-11-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190823233750.7997-1-jeffrey.t.kirsher@intel.com>
References: <20190823233750.7997-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chinh T Cao <chinh.t.cao@intel.com>

The driver should never clear the auto_fec_enable bit.

Signed-off-by: Chinh T Cao <chinh.t.cao@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 15648d4a8bab..4b43e6de847b 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -2181,27 +2181,24 @@ ice_cfg_phy_fec(struct ice_aqc_set_phy_cfg_data *cfg, enum ice_fec_mode fec)
 {
 	switch (fec) {
 	case ICE_FEC_BASER:
-		/* Clear auto FEC and RS bits, and AND BASE-R ability
+		/* Clear RS bits, and AND BASE-R ability
 		 * bits and OR request bits.
 		 */
-		cfg->caps &= ~ICE_AQC_PHY_EN_AUTO_FEC;
 		cfg->link_fec_opt &= ICE_AQC_PHY_FEC_10G_KR_40G_KR4_EN |
 				     ICE_AQC_PHY_FEC_25G_KR_CLAUSE74_EN;
 		cfg->link_fec_opt |= ICE_AQC_PHY_FEC_10G_KR_40G_KR4_REQ |
 				     ICE_AQC_PHY_FEC_25G_KR_REQ;
 		break;
 	case ICE_FEC_RS:
-		/* Clear auto FEC and BASE-R bits, and AND RS ability
+		/* Clear BASE-R bits, and AND RS ability
 		 * bits and OR request bits.
 		 */
-		cfg->caps &= ~ICE_AQC_PHY_EN_AUTO_FEC;
 		cfg->link_fec_opt &= ICE_AQC_PHY_FEC_25G_RS_CLAUSE91_EN;
 		cfg->link_fec_opt |= ICE_AQC_PHY_FEC_25G_RS_528_REQ |
 				     ICE_AQC_PHY_FEC_25G_RS_544_REQ;
 		break;
 	case ICE_FEC_NONE:
-		/* Clear auto FEC and all FEC option bits. */
-		cfg->caps &= ~ICE_AQC_PHY_EN_AUTO_FEC;
+		/* Clear all FEC option bits. */
 		cfg->link_fec_opt &= ~ICE_AQC_PHY_FEC_MASK;
 		break;
 	case ICE_FEC_AUTO:
-- 
2.21.0


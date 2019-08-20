Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3F5F96BCC
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 23:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731045AbfHTVvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 17:51:12 -0400
Received: from mga05.intel.com ([192.55.52.43]:28768 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730906AbfHTVuv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 17:50:51 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Aug 2019 14:50:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,410,1559545200"; 
   d="scan'208";a="183330510"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga006.jf.intel.com with ESMTP; 20 Aug 2019 14:50:49 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Paul Greenwalt <paul.greenwalt@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v3 04/14] ice: fix set pause param autoneg check
Date:   Tue, 20 Aug 2019 14:50:38 -0700
Message-Id: <20190820215048.14377-5-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190820215048.14377-1-jeffrey.t.kirsher@intel.com>
References: <20190820215048.14377-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Greenwalt <paul.greenwalt@intel.com>

When ETHTOOL_GLINKSETTINGS is defined get pause param pause->autoneg
reports SW configured setting, however when not defined get pause param
pause->autoneg reports the link status. Set pause param needs to compare
pause->autoneg with the same source as get pause param to block the user
from changing autoneg with the set pause param option, or the user
may be incorrectly blocked from changing Rx|Tx pause settings.

Signed-off-by: Paul Greenwalt <paul.greenwalt@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 27 +++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index d3ba535bd65a..6a97ddbbda76 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -2856,6 +2856,7 @@ static int
 ice_set_pauseparam(struct net_device *netdev, struct ethtool_pauseparam *pause)
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
+	struct ice_aqc_get_phy_caps_data *pcaps;
 	struct ice_link_status *hw_link_info;
 	struct ice_pf *pf = np->vsi->back;
 	struct ice_dcbx_cfg *dcbx_cfg;
@@ -2866,6 +2867,7 @@ ice_set_pauseparam(struct net_device *netdev, struct ethtool_pauseparam *pause)
 	u8 aq_failures;
 	bool link_up;
 	int err = 0;
+	u32 is_an;
 
 	pi = vsi->port_info;
 	hw_link_info = &pi->phy.link_info;
@@ -2880,7 +2882,30 @@ ice_set_pauseparam(struct net_device *netdev, struct ethtool_pauseparam *pause)
 		return -EOPNOTSUPP;
 	}
 
-	if (pause->autoneg != (hw_link_info->an_info & ICE_AQ_AN_COMPLETED)) {
+	/* Get pause param reports configured and negotiated flow control pause
+	 * when ETHTOOL_GLINKSETTINGS is defined. Since ETHTOOL_GLINKSETTINGS is
+	 * defined get pause param pause->autoneg reports SW configured setting,
+	 * so compare pause->autoneg with SW configured to prevent the user from
+	 * using set pause param to chance autoneg.
+	 */
+	pcaps = kzalloc(sizeof(*pcaps), GFP_KERNEL);
+	if (!pcaps)
+		return -ENOMEM;
+
+	/* Get current PHY config */
+	status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_SW_CFG, pcaps,
+				     NULL);
+	if (status) {
+		kfree(pcaps);
+		return -EIO;
+	}
+
+	is_an = ((pcaps->caps & ICE_AQC_PHY_AN_MODE) ?
+			AUTONEG_ENABLE : AUTONEG_DISABLE);
+
+	kfree(pcaps);
+
+	if (pause->autoneg != is_an) {
 		netdev_info(netdev, "To change autoneg please use: ethtool -s <dev> autoneg <on|off>\n");
 		return -EOPNOTSUPP;
 	}
-- 
2.21.0


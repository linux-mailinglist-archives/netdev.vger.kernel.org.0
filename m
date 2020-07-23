Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60A8622BA5C
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 01:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728229AbgGWXra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 19:47:30 -0400
Received: from mga12.intel.com ([192.55.52.136]:33987 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728175AbgGWXr1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 19:47:27 -0400
IronPort-SDR: 5LhWztXVtjCPiCyM2VVsNbp6ILsTjoe8qWPhn6argj1EmVH8o9IRebgCF3zZCREvz5hLklJOyR
 DH+zweX3FbFA==
X-IronPort-AV: E=McAfee;i="6000,8403,9691"; a="130200244"
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="130200244"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2020 16:47:26 -0700
IronPort-SDR: gh7IQa0ZyFMXwKOBss3khiH6NEEGGjiR9iY2IYFxmAt35dKXFTd5x2mUFCO4W3Ys2iamIgM+EB
 jdmWIYHNDOKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="328742306"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga007.jf.intel.com with ESMTP; 23 Jul 2020 16:47:25 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Bruce Allan <bruce.w.allan@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Paul Greenwalt <paul.greenwalt@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next 09/15] ice: support Total Port Shutdown on devices that support it
Date:   Thu, 23 Jul 2020 16:47:14 -0700
Message-Id: <20200723234720.1547308-10-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200723234720.1547308-1-anthony.l.nguyen@intel.com>
References: <20200723234720.1547308-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bruce Allan <bruce.w.allan@intel.com>

When the Port Disable bit is set in the Link Default Override Mask TLV PFA
module in the NVM, Total Port Shutdown mode is supported and enabled.  In
this mode, the driver should act as if the link-down-on-close ethtool
private flag is always enabled and dis-allow any change to that flag.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Paul Greenwalt <paul.greenwalt@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h         |  1 +
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 12 ++++++++++++
 drivers/net/ethernet/intel/ice/ice_main.c    | 14 +++++++++++++-
 3 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index e67f4290fa92..c665220bb637 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -359,6 +359,7 @@ enum ice_pf_flags {
 	ICE_FLAG_FD_ENA,
 	ICE_FLAG_ADV_FEATURES,
 	ICE_FLAG_LINK_DOWN_ON_CLOSE_ENA,
+	ICE_FLAG_TOTAL_PORT_SHUTDOWN_ENA,
 	ICE_FLAG_NO_MEDIA,
 	ICE_FLAG_FW_LLDP_AGENT,
 	ICE_FLAG_ETHTOOL_CTXT,		/* set when ethtool holds RTNL lock */
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index f382faaf64e3..60abd261b8bf 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -1196,6 +1196,17 @@ static int ice_set_priv_flags(struct net_device *netdev, u32 flags)
 
 	bitmap_xor(change_flags, pf->flags, orig_flags, ICE_PF_FLAGS_NBITS);
 
+	/* Do not allow change to link-down-on-close when Total Port Shutdown
+	 * is enabled.
+	 */
+	if (test_bit(ICE_FLAG_LINK_DOWN_ON_CLOSE_ENA, change_flags) &&
+	    test_bit(ICE_FLAG_TOTAL_PORT_SHUTDOWN_ENA, pf->flags)) {
+		dev_err(dev, "Setting link-down-on-close not supported on this port\n");
+		set_bit(ICE_FLAG_LINK_DOWN_ON_CLOSE_ENA, pf->flags);
+		ret = -EINVAL;
+		goto ethtool_exit;
+	}
+
 	if (test_bit(ICE_FLAG_FW_LLDP_AGENT, change_flags)) {
 		if (!test_bit(ICE_FLAG_FW_LLDP_AGENT, pf->flags)) {
 			enum ice_status status;
@@ -1283,6 +1294,7 @@ static int ice_set_priv_flags(struct net_device *netdev, u32 flags)
 		change_bit(ICE_FLAG_VF_TRUE_PROMISC_ENA, pf->flags);
 		ret = -EAGAIN;
 	}
+ethtool_exit:
 	clear_bit(ICE_FLAG_ETHTOOL_CTXT, pf->flags);
 	return ret;
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 9580c6096e56..c8c570f95b92 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -1446,6 +1446,8 @@ static int ice_init_nvm_phy_type(struct ice_port_info *pi)
 /**
  * ice_init_link_dflt_override - Initialize link default override
  * @pi: port info structure
+ *
+ * Initialize link default override and PHY total port shutdown during probe
  */
 static void ice_init_link_dflt_override(struct ice_port_info *pi)
 {
@@ -1453,7 +1455,17 @@ static void ice_init_link_dflt_override(struct ice_port_info *pi)
 	struct ice_pf *pf = pi->hw->back;
 
 	ldo = &pf->link_dflt_override;
-	ice_get_link_default_override(ldo, pi);
+	if (ice_get_link_default_override(ldo, pi))
+		return;
+
+	if (!(ldo->options & ICE_LINK_OVERRIDE_PORT_DIS))
+		return;
+
+	/* Enable Total Port Shutdown (override/replace link-down-on-close
+	 * ethtool private flag) for ports with Port Disable bit set.
+	 */
+	set_bit(ICE_FLAG_TOTAL_PORT_SHUTDOWN_ENA, pf->flags);
+	set_bit(ICE_FLAG_LINK_DOWN_ON_CLOSE_ENA, pf->flags);
 }
 
 /**
-- 
2.26.2


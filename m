Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 698F22322A0
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 18:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727889AbgG2QYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 12:24:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:44892 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726341AbgG2QYN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 12:24:13 -0400
IronPort-SDR: OMLghA/KKxwrYtNUVi0mRidLJmiI/0Msi5tbJRSu1Es74vOkpYgrN/NM2KQIYB3/7QBQNe8YMU
 pFUT/ds3xREA==
X-IronPort-AV: E=McAfee;i="6000,8403,9697"; a="169570875"
X-IronPort-AV: E=Sophos;i="5.75,410,1589266800"; 
   d="scan'208";a="169570875"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2020 09:24:12 -0700
IronPort-SDR: x5FG9ZtO8PXQX77lmkpHABOlNLbzljtTekGHjUp+/vvVCV5cylK1tN4wkSi5qJprpkmhcOS9nW
 LhbxBE5fN31g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,410,1589266800"; 
   d="scan'208";a="313087555"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 29 Jul 2020 09:24:12 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next 03/15] ice: fix link event handling timing
Date:   Wed, 29 Jul 2020 09:23:53 -0700
Message-Id: <20200729162405.1596435-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200729162405.1596435-1-anthony.l.nguyen@intel.com>
References: <20200729162405.1596435-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

When the driver experiences a link event (especially link up)
there can be multiple events generated. Some of these are
link fault and still have a state of DOWN set.  The problem
happens when the link comes UP during the PF driver handling
one of the LINK DOWN events.  The status of the link is updated
and is now seen as UP, so when the actual LINK UP event comes,
the port information has already been updated to be seen as UP,
even though none of the UP activities have been completed.

After the link information has been updated in the link
handler and evaluated for MEDIA PRESENT, if the state
of the link has been changed to UP, treat the DOWN event
as an UP event since the link is now UP.

Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c | 2 +-
 drivers/net/ethernet/intel/ice/ice_main.c    | 6 ++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
index 3b3a2789eb55..36abd6b7280c 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
@@ -463,7 +463,7 @@ void ice_dcb_rebuild(struct ice_pf *pf)
 		}
 	}
 
-	dev_info(dev, "DCB restored after reset\n");
+	dev_info(dev, "DCB info restored\n");
 	ret = ice_query_port_ets(pf->hw.port_info, &buf, sizeof(buf), NULL);
 	if (ret) {
 		dev_err(dev, "Query Port ETS failed\n");
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 7b70ab3703a7..e441cafaf23b 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -894,6 +894,12 @@ ice_link_event(struct ice_pf *pf, struct ice_port_info *pi, bool link_up,
 		dev_dbg(dev, "Failed to update link status and re-enable link events for port %d\n",
 			pi->lport);
 
+	/* Check if the link state is up after updating link info, and treat
+	 * this event as an UP event since the link is actually UP now.
+	 */
+	if (phy_info->link_info.link_info & ICE_AQ_LINK_UP)
+		link_up = true;
+
 	vsi = ice_get_main_vsi(pf);
 	if (!vsi || !vsi->port_info)
 		return -EINVAL;
-- 
2.26.2


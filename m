Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E02C130240
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 20:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbfE3Sus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 14:50:48 -0400
Received: from mga04.intel.com ([192.55.52.120]:30427 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726711AbfE3Suk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 May 2019 14:50:40 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 May 2019 11:50:37 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 30 May 2019 11:50:37 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 14/15] ice: Recognize higher speeds
Date:   Thu, 30 May 2019 11:50:44 -0700
Message-Id: <20190530185045.3886-15-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530185045.3886-1-jeffrey.t.kirsher@intel.com>
References: <20190530185045.3886-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

In ice_print_link_msg, add cases for 50GB and 100GB speeds. This
results in the right speed being reported on load, instead of
"Unknownbps".

When VF link if forced (in ice_set_pfe_link_forced), report
max speed 100GB.

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c        | 6 ++++++
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c | 2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index c8cf2c35ecbb..d34e2d529165 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -645,6 +645,12 @@ void ice_print_link_msg(struct ice_vsi *vsi, bool isup)
 	}
 
 	switch (vsi->port_info->phy.link_info.link_speed) {
+	case ICE_AQ_LINK_SPEED_100GB:
+		speed = "100 G";
+		break;
+	case ICE_AQ_LINK_SPEED_50GB:
+		speed = "50 G";
+		break;
 	case ICE_AQ_LINK_SPEED_40GB:
 		speed = "40 G";
 		break;
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index ecbf447e558a..fff59ebf07ca 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -103,7 +103,7 @@ ice_set_pfe_link_forced(struct ice_vf *vf, struct virtchnl_pf_event *pfe,
 	u16 link_speed;
 
 	if (link_up)
-		link_speed = ICE_AQ_LINK_SPEED_40GB;
+		link_speed = ICE_AQ_LINK_SPEED_100GB;
 	else
 		link_speed = ICE_AQ_LINK_SPEED_UNKNOWN;
 
-- 
2.21.0


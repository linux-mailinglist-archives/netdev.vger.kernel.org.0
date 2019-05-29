Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E29252E4BA
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 20:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbfE2Sr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 14:47:56 -0400
Received: from mga17.intel.com ([192.55.52.151]:40834 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726131AbfE2Srs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 14:47:48 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 May 2019 11:47:46 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 29 May 2019 11:47:45 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 11/15] ice: Remove redundant and premature event config
Date:   Wed, 29 May 2019 11:47:50 -0700
Message-Id: <20190529184754.12693-12-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190529184754.12693-1-jeffrey.t.kirsher@intel.com>
References: <20190529184754.12693-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

In the path for re-enabling FW LLDP engine, there is
a call to register for LLDP MIB change events.  This
call is redundant, in that the call to ice_pf_dcb_cfg
will already register the driver for these events.  Also,
the call as it stands now is too early in the flow before
before DCB is configured.

Remove the redundant call.

Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 77c98b121e62..9dde6dd78643 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -1080,12 +1080,6 @@ static int ice_set_priv_flags(struct net_device *netdev, u32 flags)
 			 * registration/init failed but do not return error
 			 * state to ethtool
 			 */
-			status = ice_aq_cfg_lldp_mib_change(&pf->hw, false,
-							    NULL);
-			if (status)
-				dev_dbg(&pf->pdev->dev,
-					"Fail to reg for MIB change\n");
-
 			status = ice_init_pf_dcb(pf, true);
 			if (status)
 				dev_dbg(&pf->pdev->dev, "Fail to init DCB\n");
-- 
2.21.0


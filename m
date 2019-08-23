Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CCAF9B8EF
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 01:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbfHWXhw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 19:37:52 -0400
Received: from mga06.intel.com ([134.134.136.31]:14901 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726824AbfHWXhw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 19:37:52 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Aug 2019 16:37:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,422,1559545200"; 
   d="scan'208";a="184354420"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga006.jf.intel.com with ESMTP; 23 Aug 2019 16:37:51 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Michal Swiatkowski <michal.swiatkowski@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 05/14] ice: Copy dcbx configuration only if mode is correct
Date:   Fri, 23 Aug 2019 16:37:41 -0700
Message-Id: <20190823233750.7997-6-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190823233750.7997-1-jeffrey.t.kirsher@intel.com>
References: <20190823233750.7997-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Swiatkowski <michal.swiatkowski@intel.com>

In rebuild DCB desired_dcbx_cfg was copy to local_dcbx_cfg, but
if DCBX mode is IEEE desired_dcbx_cfg is not initialized by DCBX
config from FW. Change logic to copy config value only if mode is
set to CEE.

If driver copy desired_dcbx_cfg to local_dcbx_cfg in IEEE mode there
is problem with globr. System is frozen after two or more globr.

Signed-off-by: Michal Swiatkowski <michal.swiatkowski@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
index 22bdc244c7e0..4fc9faf5bc71 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
@@ -334,8 +334,10 @@ void ice_dcb_rebuild(struct ice_pf *pf)
 	devm_kfree(&pf->pdev->dev, prev_cfg);
 
 	/* Set the local desired config */
-	memset(&pf->hw.port_info->local_dcbx_cfg, 0, sizeof(*local_dcbx_cfg));
-	memcpy(local_dcbx_cfg, desired_dcbx_cfg, sizeof(*local_dcbx_cfg));
+	if (local_dcbx_cfg->dcbx_mode == ICE_DCBX_MODE_CEE)
+		memcpy(local_dcbx_cfg, desired_dcbx_cfg,
+		       sizeof(*local_dcbx_cfg));
+
 	ice_cfg_etsrec_defaults(pf->hw.port_info);
 	ret = ice_set_dcb_cfg(pf->hw.port_info);
 	if (ret) {
-- 
2.21.0


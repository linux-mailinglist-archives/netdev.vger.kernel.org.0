Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F23E468B5
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 22:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbfFNUQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 16:16:13 -0400
Received: from mga06.intel.com ([134.134.136.31]:59943 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726187AbfFNUP5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 16:15:57 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jun 2019 13:15:56 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga004.fm.intel.com with ESMTP; 14 Jun 2019 13:15:55 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Piotr Marczak <piotr.marczak@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 08/12] i40e: Missing response checks in driver when starting/stopping FW LLDP
Date:   Fri, 14 Jun 2019 13:16:06 -0700
Message-Id: <20190614201610.13566-9-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190614201610.13566-1-jeffrey.t.kirsher@intel.com>
References: <20190614201610.13566-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Piotr Marczak <piotr.marczak@intel.com>

Driver did not check response on LLDP flag change and always returned
SUCCESS.

This patch now checks for an error and returns an error code and has
additional information in the log.

Signed-off-by: Piotr Marczak <piotr.marczak@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../net/ethernet/intel/i40e/i40e_ethtool.c    | 27 +++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 7f7d04ab1515..e9ae95161ce4 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -4852,9 +4852,11 @@ static u32 i40e_get_priv_flags(struct net_device *dev)
 static int i40e_set_priv_flags(struct net_device *dev, u32 flags)
 {
 	struct i40e_netdev_priv *np = netdev_priv(dev);
+	u64 orig_flags, new_flags, changed_flags;
+	enum i40e_admin_queue_err adq_err;
 	struct i40e_vsi *vsi = np->vsi;
 	struct i40e_pf *pf = vsi->back;
-	u64 orig_flags, new_flags, changed_flags;
+	i40e_status status;
 	u32 i, j;
 
 	orig_flags = READ_ONCE(pf->flags);
@@ -5013,7 +5015,28 @@ static int i40e_set_priv_flags(struct net_device *dev, u32 flags)
 			dcbcfg->pfc.willing = 1;
 			dcbcfg->pfc.pfccap = I40E_MAX_TRAFFIC_CLASS;
 		} else {
-			i40e_aq_start_lldp(&pf->hw, false, NULL);
+			status = i40e_aq_start_lldp(&pf->hw, false, NULL);
+			if (status) {
+				adq_err = pf->hw.aq.asq_last_status;
+				switch (adq_err) {
+				case I40E_AQ_RC_EEXIST:
+					dev_warn(&pf->pdev->dev,
+						 "FW LLDP agent is already running\n");
+					return 0;
+				case I40E_AQ_RC_EPERM:
+					dev_warn(&pf->pdev->dev,
+						 "Device configuration forbids SW from starting the LLDP agent.\n");
+					return -EINVAL;
+				default:
+					dev_warn(&pf->pdev->dev,
+						 "Starting FW LLDP agent failed: error: %s, %s\n",
+						 i40e_stat_str(&pf->hw,
+							       status),
+						 i40e_aq_str(&pf->hw,
+							     adq_err));
+					return -EINVAL;
+				}
+			}
 		}
 	}
 
-- 
2.21.0


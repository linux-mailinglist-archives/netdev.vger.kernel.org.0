Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90E62104CDD
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 08:46:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbfKUHql (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 02:46:41 -0500
Received: from mga12.intel.com ([192.55.52.136]:4525 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726437AbfKUHqT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Nov 2019 02:46:19 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Nov 2019 23:46:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,224,1571727600"; 
   d="scan'208";a="216077550"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by fmsmga001.fm.intel.com with ESMTP; 20 Nov 2019 23:46:14 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 07/15] ice: Fix setting coalesce to handle DCB configuration
Date:   Wed, 20 Nov 2019 23:46:04 -0800
Message-Id: <20191121074612.3055661-8-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191121074612.3055661-1-jeffrey.t.kirsher@intel.com>
References: <20191121074612.3055661-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently there can be a case where a DCB map is applied and there are
more interrupt vectors (vsi->num_q_vectors) than Rx queues (vsi->num_rxq)
and Tx queues (vsi->num_txq). If we try to set coalesce settings in this
case it will report a false failure. Fix this by checking if vector index
is valid with respect to the number of Tx and Rx queues configured.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 1f00091f7906..6c796c5c8edf 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3420,10 +3420,17 @@ __ice_set_coalesce(struct net_device *netdev, struct ethtool_coalesce *ec,
 	struct ice_vsi *vsi = np->vsi;
 
 	if (q_num < 0) {
-		int i;
+		int v_idx;
+
+		ice_for_each_q_vector(vsi, v_idx) {
+			/* In some cases if DCB is configured the num_[rx|tx]q
+			 * can be less than vsi->num_q_vectors. This check
+			 * accounts for that so we don't report a false failure
+			 */
+			if (v_idx >= vsi->num_rxq && v_idx >= vsi->num_txq)
+				goto set_complete;
 
-		ice_for_each_q_vector(vsi, i) {
-			if (ice_set_q_coalesce(vsi, ec, i))
+			if (ice_set_q_coalesce(vsi, ec, v_idx))
 				return -EINVAL;
 		}
 		goto set_complete;
-- 
2.23.0


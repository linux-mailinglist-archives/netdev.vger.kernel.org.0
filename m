Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AEF27CEE7
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 22:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730934AbfGaUmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 16:42:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:2721 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730808AbfGaUlz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 16:41:55 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Jul 2019 13:41:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,331,1559545200"; 
   d="scan'208";a="323901044"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga004.jf.intel.com with ESMTP; 31 Jul 2019 13:41:49 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Akeem G Abodunrin <akeem.g.abodunrin@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 13/16] ice: Don't return error for disabling LAN Tx queue that does exist
Date:   Wed, 31 Jul 2019 13:41:44 -0700
Message-Id: <20190731204147.8582-14-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190731204147.8582-1-jeffrey.t.kirsher@intel.com>
References: <20190731204147.8582-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Akeem G Abodunrin <akeem.g.abodunrin@intel.com>

Since Tx rings are being managed by FW/NVM, Tx rings might have not been
set up or driver had already wiped them off - In that case, call to
disable LAN Tx queue is being returned as not in existence. This patch
makes sure we don't return unnecessary error for such scenario.

Signed-off-by: Akeem G Abodunrin <akeem.g.abodunrin@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index e28478215810..2add10e02280 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2148,6 +2148,9 @@ ice_vsi_stop_tx_rings(struct ice_vsi *vsi, enum ice_disq_rst_src rst_src,
 		if (status == ICE_ERR_RESET_ONGOING) {
 			dev_dbg(&pf->pdev->dev,
 				"Reset in progress. LAN Tx queues already disabled\n");
+		} else if (status == ICE_ERR_DOES_NOT_EXIST) {
+			dev_dbg(&pf->pdev->dev,
+				"LAN Tx queues does not exist, nothing to disabled\n");
 		} else if (status) {
 			dev_err(&pf->pdev->dev,
 				"Failed to disable LAN Tx queues, error: %d\n",
-- 
2.21.0


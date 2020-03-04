Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D17EC179C4E
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 00:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388621AbgCDXV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 18:21:56 -0500
Received: from mga09.intel.com ([134.134.136.24]:48334 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388574AbgCDXVl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 18:21:41 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Mar 2020 15:21:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,515,1574150400"; 
   d="scan'208";a="244094641"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga006.jf.intel.com with ESMTP; 04 Mar 2020 15:21:38 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Lukasz Czapnik <lukasz.czapnik@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Brett Creeley <brett.creeley@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 11/16] ice: Increase mailbox receive queue length to maximum
Date:   Wed,  4 Mar 2020 15:21:31 -0800
Message-Id: <20200304232136.4172118-12-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200304232136.4172118-1-jeffrey.t.kirsher@intel.com>
References: <20200304232136.4172118-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lukasz Czapnik <lukasz.czapnik@intel.com>

Currently the PF's mailbox receive queue is only 512 entries. This fine,
but considering that all VF's mailbox send queues funnel into the PF's
single mailbox receive queue, let's increase it to the maximum size. This
will help prevent any possible bottleneck/slowdown occurring from the PF's
mailbox receive queue being full.

Signed-off-by: Lukasz Czapnik <lukasz.czapnik@intel.com>
Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h      | 1 -
 drivers/net/ethernet/intel/ice/ice_main.c | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 31e99f862820..342913d8ae6a 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -64,7 +64,6 @@ extern const char ice_drv_ver[];
 #define ICE_INT_NAME_STR_LEN	(IFNAMSIZ + 16)
 #define ICE_AQ_LEN		64
 #define ICE_MBXSQ_LEN		64
-#define ICE_MBXRQ_LEN		512
 #define ICE_MIN_MSIX		2
 #define ICE_NO_VSI		0xffff
 #define ICE_VSI_MAP_CONTIG	0
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 93160ba4d1bf..30045a194215 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -1518,7 +1518,7 @@ static void ice_set_ctrlq_len(struct ice_hw *hw)
 	hw->adminq.num_sq_entries = ICE_AQ_LEN;
 	hw->adminq.rq_buf_size = ICE_AQ_MAX_BUF_LEN;
 	hw->adminq.sq_buf_size = ICE_AQ_MAX_BUF_LEN;
-	hw->mailboxq.num_rq_entries = ICE_MBXRQ_LEN;
+	hw->mailboxq.num_rq_entries = PF_MBX_ARQLEN_ARQLEN_M;
 	hw->mailboxq.num_sq_entries = ICE_MBXSQ_LEN;
 	hw->mailboxq.rq_buf_size = ICE_MBXQ_MAX_BUF_LEN;
 	hw->mailboxq.sq_buf_size = ICE_MBXQ_MAX_BUF_LEN;
-- 
2.24.1


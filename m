Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEDFE39E47D
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbhFGQwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:52:50 -0400
Received: from mga14.intel.com ([192.55.52.115]:57118 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230323AbhFGQwq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:52:46 -0400
IronPort-SDR: 8th7cBO63g6qSdG5VRASpYjY9OHUqVwpj6pjqNhU9cdh4qR1hOJfcYuu/MVajXExKn6lwOHWo7
 fy62ehEtb5Gg==
X-IronPort-AV: E=McAfee;i="6200,9189,10008"; a="204474553"
X-IronPort-AV: E=Sophos;i="5.83,255,1616482800"; 
   d="scan'208";a="204474553"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2021 09:50:54 -0700
IronPort-SDR: 7FXdEUMBq2ZKZh0oDqvJscgtbEGG37RNwReIss4ilongE1gZ1qhGb5EpHmeMjOCNLnVsztvE11
 IBgpGpmtHwag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,255,1616482800"; 
   d="scan'208";a="484841240"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 07 Jun 2021 09:50:53 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Liwei Song <liwei.song@windriver.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 06/15] ice: set the value of global config lock timeout longer
Date:   Mon,  7 Jun 2021 09:53:16 -0700
Message-Id: <20210607165325.182087-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210607165325.182087-1-anthony.l.nguyen@intel.com>
References: <20210607165325.182087-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Liwei Song <liwei.song@windriver.com>

It may need hold Global Config Lock a longer time when download DDP
package file, extend the timeout value to 5000ms to ensure that
download can be finished before other AQ command got time to run,
this will fix the issue below when probe the device, 5000ms is a test
value that work with both Backplane and BreakoutCable NVM image:

ice 0000:f4:00.0: VSI 12 failed lan queue config, error ICE_ERR_CFG
ice 0000:f4:00.0: Failed to delete VSI 12 in FW - error: ICE_ERR_AQ_TIMEOUT
ice 0000:f4:00.0: probe failed due to setup PF switch: -12
ice: probe of 0000:f4:00.0 failed with error -12

Signed-off-by: Liwei Song <liwei.song@windriver.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_type.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index c580b87c76ee..2e235646ede2 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -64,7 +64,7 @@ enum ice_aq_res_ids {
 /* FW update timeout definitions are in milliseconds */
 #define ICE_NVM_TIMEOUT			180000
 #define ICE_CHANGE_LOCK_TIMEOUT		1000
-#define ICE_GLOBAL_CFG_LOCK_TIMEOUT	3000
+#define ICE_GLOBAL_CFG_LOCK_TIMEOUT	5000
 
 enum ice_aq_res_access_type {
 	ICE_RES_READ = 1,
-- 
2.26.2


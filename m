Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57F62433E7D
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 20:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234832AbhJSSef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 14:34:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:51639 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234526AbhJSSea (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 14:34:30 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10142"; a="226058565"
X-IronPort-AV: E=Sophos;i="5.87,164,1631602800"; 
   d="scan'208";a="226058565"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2021 11:32:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,164,1631602800"; 
   d="scan'208";a="444602722"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 19 Oct 2021 11:32:16 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Cai Huoqing <caihuoqing@baidu.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 08/10] ice: Make use of the helper function devm_add_action_or_reset()
Date:   Tue, 19 Oct 2021 11:30:25 -0700
Message-Id: <20211019183027.2820413-9-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211019183027.2820413-1-anthony.l.nguyen@intel.com>
References: <20211019183027.2820413-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cai Huoqing <caihuoqing@baidu.com>

The helper function devm_add_action_or_reset() will internally
call devm_add_action(), and if devm_add_action() fails then it will
execute the action mentioned and return the error code. So
use devm_add_action_or_reset() instead of devm_add_action()
to simplify the error handling, reduce the code.

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_devlink.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index 55353bf4cbef..e3d9f3f3a631 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -452,10 +452,8 @@ struct ice_pf *ice_allocate_pf(struct device *dev)
 		return NULL;
 
 	/* Add an action to teardown the devlink when unwinding the driver */
-	if (devm_add_action(dev, ice_devlink_free, devlink)) {
-		devlink_free(devlink);
+	if (devm_add_action_or_reset(dev, ice_devlink_free, devlink))
 		return NULL;
-	}
 
 	return devlink_priv(devlink);
 }
-- 
2.31.1


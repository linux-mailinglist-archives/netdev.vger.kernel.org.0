Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 076EA4EDE9A
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 18:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239811AbiCaQVe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 12:21:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239806AbiCaQVc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 12:21:32 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1E441D7D8C
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 09:19:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648743584; x=1680279584;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wBC+3w3qdluWkfwRayQGecQUr9JtO5jfLXgiuORAXm4=;
  b=gQbxcsH53z1YGBKIJaICjrUIBESL8IDqPCwLN7f3SIGSlNqHM1BoXmUy
   1eI2Fcut3YU8VqDT2+7lkLT7LgBIGgggPzQ4IvWLVSP2HY2eMnPQhLdss
   2FggCd5/hBBxSALv8igsVWV890E/wJ9aO5ZRhxVsczZXlOkX/wfm03VlY
   h/OU7s9g0NXDBiNqYM5sZgjob2I8T/USD8Qbv76kk79KZYgTaeiC186mS
   NXGszNLvae0LvF1sPlFDuVyI7op55sfFyuSuh85aJHn3Md3bdMSv92VHI
   DbWC92RTkNaw4fP4F3joaodkTDVZ1T5Laey46NRhrloJLwZdLhenpgqfB
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10302"; a="260067491"
X-IronPort-AV: E=Sophos;i="5.90,225,1643702400"; 
   d="scan'208";a="260067491"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 09:19:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,225,1643702400"; 
   d="scan'208";a="522407019"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 31 Mar 2022 09:19:40 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     alice.michael@intel.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com
Cc:     Ivan Vecera <ivecera@redhat.com>, netdev@vger.kernel.org,
        Jacob Keller <jacob.e.keller@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
Subject: [PATCH net 2/3] ice: Fix MAC address setting
Date:   Thu, 31 Mar 2022 09:20:07 -0700
Message-Id: <20220331162008.1891935-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220331162008.1891935-1-anthony.l.nguyen@intel.com>
References: <20220331162008.1891935-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ivan Vecera <ivecera@redhat.com>

Commit 2ccc1c1ccc671b ("ice: Remove excess error variables") merged
the usage of 'status' and 'err' variables into single one in
function ice_set_mac_address(). Unfortunately this causes
a regression when call of ice_fltr_add_mac() returns -EEXIST because
this return value does not indicate an error in this case but
value of 'err' remains to be -EEXIST till the end of the function
and is returned to caller.

Prior mentioned commit this does not happen because return value of
ice_fltr_add_mac() was stored to 'status' variable first and
if it was -EEXIST then 'err' remains to be zero.

Fix the problem by reset 'err' to zero when ice_fltr_add_mac()
returns -EEXIST.

Fixes: 2ccc1c1ccc671b ("ice: Remove excess error variables")
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Acked-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Signed-off-by: Alice Michael <alice.michael@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 8181688c897b..1f944b3bd795 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5477,16 +5477,19 @@ static int ice_set_mac_address(struct net_device *netdev, void *pi)
 
 	/* Add filter for new MAC. If filter exists, return success */
 	err = ice_fltr_add_mac(vsi, mac, ICE_FWD_TO_VSI);
-	if (err == -EEXIST)
+	if (err == -EEXIST) {
 		/* Although this MAC filter is already present in hardware it's
 		 * possible in some cases (e.g. bonding) that dev_addr was
 		 * modified outside of the driver and needs to be restored back
 		 * to this value.
 		 */
 		netdev_dbg(netdev, "filter for MAC %pM already exists\n", mac);
-	else if (err)
+
+		return 0;
+	} else if (err) {
 		/* error if the new filter addition failed */
 		err = -EADDRNOTAVAIL;
+	}
 
 err_update_filters:
 	if (err) {
-- 
2.31.1


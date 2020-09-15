Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82B0B269B71
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 03:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726160AbgIOBpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 21:45:15 -0400
Received: from mga06.intel.com ([134.134.136.31]:12848 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726123AbgIOBpK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 21:45:10 -0400
IronPort-SDR: hawWc/c14BdaLySaqx6r3SQ6gi5ZlDrySbXAx0V0huTl02lOL21bk6leMHSiz7WGlDW85ppU2J
 klHZOWbp7jUA==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="220742440"
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="220742440"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 18:45:09 -0700
IronPort-SDR: XfmNJ6kejCQAsYTHezT2CWqdJjEGnSRdNLoi2UOIhB80V1umk4QABbgBFFgPzKoByI9nvzj543
 ymUCd/UhZuKw==
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="482571937"
Received: from jbrandeb-saw1.jf.intel.com ([10.166.28.56])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 18:45:09 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        intel-wired-lan@lists.osuosl.org
Subject: [PATCH net-next v2 01/10] i40e: prepare flash string in a simpler way
Date:   Mon, 14 Sep 2020 18:44:46 -0700
Message-Id: <20200915014455.1232507-2-jesse.brandeburg@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915014455.1232507-1-jesse.brandeburg@intel.com>
References: <20200915014455.1232507-1-jesse.brandeburg@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The flash string handling code triggered a W=1 warning and upon
investigation it seems everything can be handled in a simpler
way with a single initialization and one strlcat.  The buffer is filled
with NULL after the end of the string by the initializer, and the
strlcat checks total length, and makes sure the buffer is terminated
cleanly.

I didn't mark this with a fixes tag as there is no apparent bug since
the existing code would limit the input data + path to be the right
size, but it does fix the W=1 warning.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_ddp.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ddp.c b/drivers/net/ethernet/intel/i40e/i40e_ddp.c
index 5e08f100c413..9767fdf56124 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ddp.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ddp.c
@@ -434,14 +434,10 @@ int i40e_ddp_flash(struct net_device *netdev, struct ethtool_flash *flash)
 	 * stored profile.
 	 */
 	if (strncmp(flash->data, "-", 2) != 0) {
+		char profile_name[ETHTOOL_FLASH_MAX_FILENAME] = I40E_DDP_PROFILE_PATH;
 		struct i40e_ddp_old_profile_list *list_entry;
-		char profile_name[sizeof(I40E_DDP_PROFILE_PATH)
-				  + I40E_DDP_PROFILE_NAME_MAX];
 
-		profile_name[sizeof(profile_name) - 1] = 0;
-		strncpy(profile_name, I40E_DDP_PROFILE_PATH,
-			sizeof(profile_name) - 1);
-		strncat(profile_name, flash->data, I40E_DDP_PROFILE_NAME_MAX);
+		strlcat(profile_name, flash->data, ETHTOOL_FLASH_MAX_FILENAME);
 		/* Load DDP recipe. */
 		status = request_firmware(&ddp_config, profile_name,
 					  &netdev->dev);
-- 
2.28.0


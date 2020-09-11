Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06FC726568C
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 03:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725468AbgIKBXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 21:23:48 -0400
Received: from mga05.intel.com ([192.55.52.43]:51425 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725280AbgIKBXq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 21:23:46 -0400
IronPort-SDR: dF/ZKF1whe9wErTBPafXEDppoROxzD4saB4E2rPQHP/1O4LRyazDixHGSpfZGF54BKxT4wUA+K
 B4iq8Tvu+V4w==
X-IronPort-AV: E=McAfee;i="6000,8403,9740"; a="243491820"
X-IronPort-AV: E=Sophos;i="5.76,413,1592895600"; 
   d="scan'208";a="243491820"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2020 18:23:45 -0700
IronPort-SDR: OpYrc7kK15vdglmR0lxLReKBvjx9wyuHJt7ThDQJLtN5mDmshwT8SrfjkpVhY8zFem8gFXn6dG
 NmmdU4LJJddg==
X-IronPort-AV: E=Sophos;i="5.76,413,1592895600"; 
   d="scan'208";a="449808133"
Received: from jbrandeb-desk.jf.intel.com ([10.166.244.152])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2020 18:23:44 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        intel-wired-lan@lists.osuosl.org
Subject: [RFC PATCH net-next v1 01/11] i40e: prepare flash string in a simpler way
Date:   Thu, 10 Sep 2020 18:23:27 -0700
Message-Id: <20200911012337.14015-2-jesse.brandeburg@intel.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200911012337.14015-1-jesse.brandeburg@intel.com>
References: <20200911012337.14015-1-jesse.brandeburg@intel.com>
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
2.27.0


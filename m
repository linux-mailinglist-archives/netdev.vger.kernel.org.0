Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D225580605
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 22:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233504AbiGYU4q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 16:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237162AbiGYU4l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 16:56:41 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54E6D22BEC;
        Mon, 25 Jul 2022 13:56:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658782600; x=1690318600;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=A96Kbpm3i0SigVaYwn2kdkSZyp9EZD3uB6hgozO9nPQ=;
  b=DgDzUx97k7VNG41N8xTs5DnGUN3qmoYlAr3BE7HT8yMSrn9+Ox2fxBrx
   zKtjAjygMsGmaiNM31Axe2rDjLvzNBqR8FEM4uGxW0dzDQtiX+jNr33Tm
   jszGDF+JKEHJ/yFQf2gfu/MNJFI8KVMHtn56joudC9Lr7fXE8ZjXWVO5c
   +diuTqF9p20B/qBUBUBSSWLGolUPNZLOLpvJdOg57pjJ2aPksLaWAEL/N
   HpX8TYIu5bQZ7HOYpynSOpb2sxDNGoyhcbJDlKJAhHE3OMBEunKxOjcTX
   FkYnSNPwLJ1WQ9IcMob0RoCQbqqKN6cG/e4yBfT6LUmCjlfpzhqBd95Vs
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10419"; a="267564335"
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="267564335"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2022 13:56:37 -0700
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="689191024"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.7])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2022 13:56:37 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jonathan Corbet <corbet@lwn.net>, Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-doc@vger.kernel.org
Subject: [net-next v3 4/4] ice: support dry run of a flash update to validate firmware file
Date:   Mon, 25 Jul 2022 13:56:29 -0700
Message-Id: <20220725205629.3993766-5-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.37.1.208.ge72d93e88cb2
In-Reply-To: <20220725205629.3993766-1-jacob.e.keller@intel.com>
References: <20220725205629.3993766-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The devlink core flash update and the PLDMFW library can now handle dry run
requests. Update the ice driver to support this feature.

Indicate that we support dry runs in the .supported_flash_update_params
field. If the dry run is requested, notify the PLDM firmware library by
setting the context bit appropriately. Don't cancel a pending update during
a dry run.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
Changes since v2
* Move the PLDMFW changes to their own patch

 drivers/net/ethernet/intel/ice/ice_devlink.c   |  3 ++-
 drivers/net/ethernet/intel/ice/ice_fw_update.c | 14 ++++++++++----
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index 3337314a7b35..18214ea33e2d 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -467,7 +467,8 @@ ice_devlink_reload_empr_finish(struct devlink *devlink,
 }
 
 static const struct devlink_ops ice_devlink_ops = {
-	.supported_flash_update_params = DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK,
+	.supported_flash_update_params = DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK |
+					 DEVLINK_SUPPORT_FLASH_UPDATE_DRY_RUN,
 	.reload_actions = BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE),
 	/* The ice driver currently does not support driver reinit */
 	.reload_down = ice_devlink_reload_empr_start,
diff --git a/drivers/net/ethernet/intel/ice/ice_fw_update.c b/drivers/net/ethernet/intel/ice/ice_fw_update.c
index 3dc5662d62a6..51b352bc26a2 100644
--- a/drivers/net/ethernet/intel/ice/ice_fw_update.c
+++ b/drivers/net/ethernet/intel/ice/ice_fw_update.c
@@ -1015,15 +1015,21 @@ int ice_devlink_flash_update(struct devlink *devlink,
 	else
 		priv.context.ops = &ice_fwu_ops_e810;
 	priv.context.dev = dev;
+	priv.context.only_validate = params->dry_run;
 	priv.extack = extack;
 	priv.pf = pf;
 	priv.activate_flags = preservation;
 
-	devlink_flash_update_status_notify(devlink, "Preparing to flash", NULL, 0, 0);
+	if (params->dry_run)
+		devlink_flash_update_status_notify(devlink, "Validating flash binary", NULL, 0, 0);
+	else
+		devlink_flash_update_status_notify(devlink, "Preparing to flash", NULL, 0, 0);
 
-	err = ice_cancel_pending_update(pf, NULL, extack);
-	if (err)
-		return err;
+	if (!params->dry_run) {
+		err = ice_cancel_pending_update(pf, NULL, extack);
+		if (err)
+			return err;
+	}
 
 	err = ice_acquire_nvm(hw, ICE_RES_WRITE);
 	if (err) {
-- 
2.35.1.456.ga9c7032d4631


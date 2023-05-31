Return-Path: <netdev+bounces-6803-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ACDDA718240
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 15:41:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 447192814B3
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 13:41:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CCB714AB9;
	Wed, 31 May 2023 13:41:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E188114AA7
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 13:40:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61DACC433A0;
	Wed, 31 May 2023 13:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685540458;
	bh=Ys+J8zyZScPPe4uXqKJZpQIViFuX+QXqtdsc0LeVe9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F3mHPc/lv0Y6qrqJELoDiozPEwRf04mTrpX1us/ZhNgDb6NRaPBPE+qEcOqUWk0YY
	 yEM49wM4Lb8zfKnFtdVTPlxBe7lHTt9LLTd2DavfogEG8B3HAKckO3dt5vIy7s5xM4
	 0MtN126TkEBuvXTSei2WcIuHC9GypzuiiSFyRSRo2/RxkAeDwiZCs9DUw91RqW3yfB
	 AV5EvrzrpclVHNevN8aoabPo7+4M1Y758Hblituivb5tMQhdPK7yjw157bfuuXBAn2
	 CHyMXOpO2kmyKT160AD9fylN8xdP6qT3Cag3vlaynOjGXp8BrwzuS1UrOfgQWSZ430
	 eUuT0OD3hq90w==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Alejandro Lucero <alejandro.lucero-palau@amd.com>,
	Martin Habets <habetsm.xilinx@gmail.com>,
	"David S . Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>,
	ecree.xilinx@gmail.com,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-net-drivers@amd.com
Subject: [PATCH AUTOSEL 6.3 21/37] sfc: fix devlink info error handling
Date: Wed, 31 May 2023 09:40:03 -0400
Message-Id: <20230531134020.3383253-21-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230531134020.3383253-1-sashal@kernel.org>
References: <20230531134020.3383253-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Alejandro Lucero <alejandro.lucero-palau@amd.com>

[ Upstream commit cfcb942863f6fce9266e1957a021e6c7295dee42 ]

Avoid early devlink info return if errors arise with MCDI commands
executed for getting the required info from the device. The rationale
is some commands can fail but later ones could still give useful data.
Moreover, some nvram partitions could not be present which needs to be
handled as a non error.

The specific errors are reported through system messages and if any
error appears, it will be reported generically through extack.

Fixes 14743ddd2495 ("sfc: add devlink info support for ef100")
Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>
Acked-by: Martin Habets <habetsm.xilinx@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/efx_devlink.c | 95 ++++++++++++--------------
 1 file changed, 45 insertions(+), 50 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx_devlink.c b/drivers/net/ethernet/sfc/efx_devlink.c
index 381b805659d39..ef9971cbb695d 100644
--- a/drivers/net/ethernet/sfc/efx_devlink.c
+++ b/drivers/net/ethernet/sfc/efx_devlink.c
@@ -171,9 +171,14 @@ static int efx_devlink_info_nvram_partition(struct efx_nic *efx,
 
 	rc = efx_mcdi_nvram_metadata(efx, partition_type, NULL, version, NULL,
 				     0);
+
+	/* If the partition does not exist, that is not an error. */
+	if (rc == -ENOENT)
+		return 0;
+
 	if (rc) {
-		netif_err(efx, drv, efx->net_dev, "mcdi nvram %s: failed\n",
-			  version_name);
+		netif_err(efx, drv, efx->net_dev, "mcdi nvram %s: failed (rc=%d)\n",
+			  version_name, rc);
 		return rc;
 	}
 
@@ -187,36 +192,33 @@ static int efx_devlink_info_nvram_partition(struct efx_nic *efx,
 static int efx_devlink_info_stored_versions(struct efx_nic *efx,
 					    struct devlink_info_req *req)
 {
-	int rc;
-
-	rc = efx_devlink_info_nvram_partition(efx, req,
-					      NVRAM_PARTITION_TYPE_BUNDLE,
-					      DEVLINK_INFO_VERSION_GENERIC_FW_BUNDLE_ID);
-	if (rc)
-		return rc;
-
-	rc = efx_devlink_info_nvram_partition(efx, req,
-					      NVRAM_PARTITION_TYPE_MC_FIRMWARE,
-					      DEVLINK_INFO_VERSION_GENERIC_FW_MGMT);
-	if (rc)
-		return rc;
-
-	rc = efx_devlink_info_nvram_partition(efx, req,
-					      NVRAM_PARTITION_TYPE_SUC_FIRMWARE,
-					      EFX_DEVLINK_INFO_VERSION_FW_MGMT_SUC);
-	if (rc)
-		return rc;
-
-	rc = efx_devlink_info_nvram_partition(efx, req,
-					      NVRAM_PARTITION_TYPE_EXPANSION_ROM,
-					      EFX_DEVLINK_INFO_VERSION_FW_EXPROM);
-	if (rc)
-		return rc;
+	int err;
 
-	rc = efx_devlink_info_nvram_partition(efx, req,
-					      NVRAM_PARTITION_TYPE_EXPANSION_UEFI,
-					      EFX_DEVLINK_INFO_VERSION_FW_UEFI);
-	return rc;
+	/* We do not care here about the specific error but just if an error
+	 * happened. The specific error will be reported inside the call
+	 * through system messages, and if any error happened in any call
+	 * below, we report it through extack.
+	 */
+	err = efx_devlink_info_nvram_partition(efx, req,
+					       NVRAM_PARTITION_TYPE_BUNDLE,
+					       DEVLINK_INFO_VERSION_GENERIC_FW_BUNDLE_ID);
+
+	err |= efx_devlink_info_nvram_partition(efx, req,
+						NVRAM_PARTITION_TYPE_MC_FIRMWARE,
+						DEVLINK_INFO_VERSION_GENERIC_FW_MGMT);
+
+	err |= efx_devlink_info_nvram_partition(efx, req,
+						NVRAM_PARTITION_TYPE_SUC_FIRMWARE,
+						EFX_DEVLINK_INFO_VERSION_FW_MGMT_SUC);
+
+	err |= efx_devlink_info_nvram_partition(efx, req,
+						NVRAM_PARTITION_TYPE_EXPANSION_ROM,
+						EFX_DEVLINK_INFO_VERSION_FW_EXPROM);
+
+	err |= efx_devlink_info_nvram_partition(efx, req,
+						NVRAM_PARTITION_TYPE_EXPANSION_UEFI,
+						EFX_DEVLINK_INFO_VERSION_FW_UEFI);
+	return err;
 }
 
 #define EFX_VER_FLAG(_f)	\
@@ -587,27 +589,20 @@ static int efx_devlink_info_get(struct devlink *devlink,
 {
 	struct efx_devlink *devlink_private = devlink_priv(devlink);
 	struct efx_nic *efx = devlink_private->efx;
-	int rc;
+	int err;
 
-	/* Several different MCDI commands are used. We report first error
-	 * through extack returning at that point. Specific error
-	 * information via system messages.
+	/* Several different MCDI commands are used. We report if errors
+	 * happened through extack. Specific error information via system
+	 * messages inside the calls.
 	 */
-	rc = efx_devlink_info_board_cfg(efx, req);
-	if (rc) {
-		NL_SET_ERR_MSG_MOD(extack, "Getting board info failed");
-		return rc;
-	}
-	rc = efx_devlink_info_stored_versions(efx, req);
-	if (rc) {
-		NL_SET_ERR_MSG_MOD(extack, "Getting stored versions failed");
-		return rc;
-	}
-	rc = efx_devlink_info_running_versions(efx, req);
-	if (rc) {
-		NL_SET_ERR_MSG_MOD(extack, "Getting running versions failed");
-		return rc;
-	}
+	err = efx_devlink_info_board_cfg(efx, req);
+
+	err |= efx_devlink_info_stored_versions(efx, req);
+
+	err |= efx_devlink_info_running_versions(efx, req);
+
+	if (err)
+		NL_SET_ERR_MSG_MOD(extack, "Errors when getting device info. Check system messages");
 
 	return 0;
 }
-- 
2.39.2



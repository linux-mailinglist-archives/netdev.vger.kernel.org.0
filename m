Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2D7E4DE1B9
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 20:24:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240352AbiCRTZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 15:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239449AbiCRTZN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 15:25:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7881E304AC5
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 12:23:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12F3861BC4
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 19:23:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 338F1C340EF;
        Fri, 18 Mar 2022 19:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647631433;
        bh=BWqjM7C7AFVeo492ME0gLDp/GiAhLNn6+5fp8vEIpO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oyA75MIsMgiAET//h2cUpS/q/PQV4k+3rCEvSZstxaS23lawfT7L2cIIJG28QfcmL
         LpdCBDVloIKcuy/ZgloD703v7dEAKbxw6OqFPopcV2M2fGA5TYJzTGUPVhDXAdz476
         fuiKEWYoORWFKpkKj1iTSuQ6qB9N6Acq/MJOEbrTV747wI5YO8diV6hI9pmjaB9K0i
         srYBtysKS/wGTOYqpXu0CgGUuNPqP4VUpY/MYB0+TXXYS46dCblAa6pzKWufZyBboA
         hoQG77xcdbEzvL3ecGzUP8GORwb4m1CE+BB0p8tZx5Js/ql96dzDAEugroQZ+E+Ez6
         5Jg5MM/qKnyjA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, jiri@resnulli.us, leonro@nvidia.com,
        saeedm@nvidia.com, idosch@idosch.org, michael.chan@broadcom.com,
        simon.horman@corigine.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 1/5] bnxt: use the devlink instance lock to protect sriov
Date:   Fri, 18 Mar 2022 12:23:40 -0700
Message-Id: <20220318192344.1587891-2-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220318192344.1587891-1-kuba@kernel.org>
References: <20220318192344.1587891-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In prep for .eswitch_mode_set being called with the devlink instance
lock held use that lock explicitly instead of creating a local mutex
just for the sriov reconfig.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c       | 1 -
 drivers/net/ethernet/broadcom/bnxt/bnxt.h       | 6 ------
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c | 4 ++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c   | 4 ++--
 4 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 92a1a43b3bee..1c28495875cf 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -13470,7 +13470,6 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 #ifdef CONFIG_BNXT_SRIOV
 	init_waitqueue_head(&bp->sriov_cfg_wait);
-	mutex_init(&bp->sriov_lock);
 #endif
 	if (BNXT_SUPPORTS_TPA(bp)) {
 		bp->gro_func = bnxt_gro_func_5730x;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 447a9406b8a2..61aa3e8c5952 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -2072,12 +2072,6 @@ struct bnxt {
 	wait_queue_head_t	sriov_cfg_wait;
 	bool			sriov_cfg;
 #define BNXT_SRIOV_CFG_WAIT_TMO	msecs_to_jiffies(10000)
-
-	/* lock to protect VF-rep creation/cleanup via
-	 * multiple paths such as ->sriov_configure() and
-	 * devlink ->eswitch_mode_set()
-	 */
-	struct mutex		sriov_lock;
 #endif
 
 #if BITS_PER_LONG == 32
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
index 1d177fed44a6..ddf2f3963abe 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
@@ -846,7 +846,7 @@ void bnxt_sriov_disable(struct bnxt *bp)
 		return;
 
 	/* synchronize VF and VF-rep create and destroy */
-	mutex_lock(&bp->sriov_lock);
+	devl_lock(bp->dl);
 	bnxt_vf_reps_destroy(bp);
 
 	if (pci_vfs_assigned(bp->pdev)) {
@@ -859,7 +859,7 @@ void bnxt_sriov_disable(struct bnxt *bp)
 		/* Free the HW resources reserved for various VF's */
 		bnxt_hwrm_func_vf_resource_free(bp, num_vfs);
 	}
-	mutex_unlock(&bp->sriov_lock);
+	devl_unlock(bp->dl);
 
 	bnxt_free_vf_resources(bp);
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
index 8eb28e088582..b2a9528b456b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
@@ -561,7 +561,7 @@ int bnxt_dl_eswitch_mode_set(struct devlink *devlink, u16 mode,
 	struct bnxt *bp = bnxt_get_bp_from_dl(devlink);
 	int rc = 0;
 
-	mutex_lock(&bp->sriov_lock);
+	devl_lock(devlink);
 	if (bp->eswitch_mode == mode) {
 		netdev_info(bp->dev, "already in %s eswitch mode\n",
 			    mode == DEVLINK_ESWITCH_MODE_LEGACY ?
@@ -595,7 +595,7 @@ int bnxt_dl_eswitch_mode_set(struct devlink *devlink, u16 mode,
 		goto done;
 	}
 done:
-	mutex_unlock(&bp->sriov_lock);
+	devl_unlock(devlink);
 	return rc;
 }
 
-- 
2.34.1


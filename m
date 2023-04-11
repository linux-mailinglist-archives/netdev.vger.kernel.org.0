Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F41E6DDA3D
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 14:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbjDKMF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 08:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjDKMF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 08:05:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AA3630ED
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 05:04:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681214688;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=RIqxLLJNdpzj/dhOUNV64sjQ4VepHfKl/8XXcn7wBeQ=;
        b=SMDJZVcghdf95gcb6LHX3S4swKJtWfC4+m3fEF860V3qUDArDPrgLZjpWN6NPc0uwdhGYc
        v2D/O0D4icv7sGLUeQaSVgqxOuPo6mJ/VTLaDgQ1HENXHE/ZaHympIDCXM0O1hy432Ln7G
        k5GaeFIsb5Qdwm1AC7T9LUk7oiSTLSc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-121-uBZ3tM9tPFuSXy1F4evVwQ-1; Tue, 11 Apr 2023 08:04:45 -0400
X-MC-Unique: uBZ3tM9tPFuSXy1F4evVwQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1B78A2A59557;
        Tue, 11 Apr 2023 12:04:45 +0000 (UTC)
Received: from p1.luc.cera.cz (unknown [10.43.2.89])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D4D88492B00;
        Tue, 11 Apr 2023 12:04:43 +0000 (UTC)
From:   Ivan Vecera <ivecera@redhat.com>
To:     netdev@vger.kernel.org
Cc:     mschmidt@redhat.com, Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next v2] bnxt_en: Allow to set switchdev mode without existing VFs
Date:   Tue, 11 Apr 2023 14:04:42 +0200
Message-Id: <20230411120443.126055-1-ivecera@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove an inability of bnxt_en driver to set eswitch to switchdev
mode without existing VFs by:

1. Allow to set switchdev mode in bnxt_dl_eswitch_mode_set() so
   representors are created only when num_vfs > 0 otherwise just
   set bp->eswitch_mode
2. Do not automatically change bp->eswitch_mode during
   bnxt_vf_reps_create() and bnxt_vf_reps_destroy() calls so
   the eswitch mode is managed only by an user by devlink.
   Just set temporarily bp->eswitch_mode to legacy to avoid
   re-opening of representors during destroy.
3. Create representors in bnxt_sriov_enable() if current eswitch
   mode is switchdev one

Tested by this sequence:
1. Set PF interface up
2. Set PF's eswitch mode to switchdev
3. Created N VFs
4. Checked that N representors were created
5. Set eswitch mode to legacy
6. Checked that representors were deleted
7. Set eswitch mode back to switchdev
8. Checked that representors exist again for VFs
9. Deleted all VFs
10. Checked that all representors were deleted as well
11. Checked that current eswitch mode is still switchdev

Signed-off-by: Ivan Vecera <ivecera@redhat.com>
---
 .../net/ethernet/broadcom/bnxt/bnxt_sriov.c   | 16 ++++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c | 29 ++++++++++++-------
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.h |  6 ++++
 3 files changed, 41 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
index 3ed3a2b3b3a9..dde327f2c57e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
@@ -825,8 +825,24 @@ static int bnxt_sriov_enable(struct bnxt *bp, int *num_vfs)
 	if (rc)
 		goto err_out2;
 
+	if (bp->eswitch_mode != DEVLINK_ESWITCH_MODE_SWITCHDEV)
+		return 0;
+
+	/* Create representors for VFs in switchdev mode */
+	devl_lock(bp->dl);
+	rc = bnxt_vf_reps_create(bp);
+	devl_unlock(bp->dl);
+	if (rc) {
+		netdev_info(bp->dev, "Cannot enable VFS as representors cannot be created\n");
+		goto err_out3;
+	}
+
 	return 0;
 
+err_out3:
+	/* Disable SR-IOV */
+	pci_disable_sriov(bp->pdev);
+
 err_out2:
 	/* Free the resources reserved for various VF's */
 	bnxt_hwrm_func_vf_resource_free(bp, *num_vfs);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
index fcc65890820a..2f1a1f2d2157 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
@@ -356,10 +356,15 @@ void bnxt_vf_reps_destroy(struct bnxt *bp)
 	/* un-publish cfa_code_map so that RX path can't see it anymore */
 	kfree(bp->cfa_code_map);
 	bp->cfa_code_map = NULL;
-	bp->eswitch_mode = DEVLINK_ESWITCH_MODE_LEGACY;
 
-	if (closed)
+	if (closed) {
+		/* Temporarily set legacy mode to avoid re-opening
+		 * representors and restore switchdev mode after that.
+		 */
+		bp->eswitch_mode = DEVLINK_ESWITCH_MODE_LEGACY;
 		bnxt_open_nic(bp, false, false);
+		bp->eswitch_mode = DEVLINK_ESWITCH_MODE_SWITCHDEV;
+	}
 	rtnl_unlock();
 
 	/* Need to call vf_reps_destroy() outside of rntl_lock
@@ -482,7 +487,7 @@ static void bnxt_vf_rep_netdev_init(struct bnxt *bp, struct bnxt_vf_rep *vf_rep,
 	dev->min_mtu = ETH_ZLEN;
 }
 
-static int bnxt_vf_reps_create(struct bnxt *bp)
+int bnxt_vf_reps_create(struct bnxt *bp)
 {
 	u16 *cfa_code_map = NULL, num_vfs = pci_num_vf(bp->pdev);
 	struct bnxt_vf_rep *vf_rep;
@@ -535,7 +540,6 @@ static int bnxt_vf_reps_create(struct bnxt *bp)
 
 	/* publish cfa_code_map only after all VF-reps have been initialized */
 	bp->cfa_code_map = cfa_code_map;
-	bp->eswitch_mode = DEVLINK_ESWITCH_MODE_SWITCHDEV;
 	netif_keep_dst(bp->dev);
 	return 0;
 
@@ -559,6 +563,7 @@ int bnxt_dl_eswitch_mode_set(struct devlink *devlink, u16 mode,
 			     struct netlink_ext_ack *extack)
 {
 	struct bnxt *bp = bnxt_get_bp_from_dl(devlink);
+	int ret = 0;
 
 	if (bp->eswitch_mode == mode) {
 		netdev_info(bp->dev, "already in %s eswitch mode\n",
@@ -570,7 +575,7 @@ int bnxt_dl_eswitch_mode_set(struct devlink *devlink, u16 mode,
 	switch (mode) {
 	case DEVLINK_ESWITCH_MODE_LEGACY:
 		bnxt_vf_reps_destroy(bp);
-		return 0;
+		break;
 
 	case DEVLINK_ESWITCH_MODE_SWITCHDEV:
 		if (bp->hwrm_spec_code < 0x10803) {
@@ -578,15 +583,19 @@ int bnxt_dl_eswitch_mode_set(struct devlink *devlink, u16 mode,
 			return -ENOTSUPP;
 		}
 
-		if (pci_num_vf(bp->pdev) == 0) {
-			netdev_info(bp->dev, "Enable VFs before setting switchdev mode\n");
-			return -EPERM;
-		}
-		return bnxt_vf_reps_create(bp);
+		/* Create representors for existing VFs */
+		if (pci_num_vf(bp->pdev) > 0)
+			ret = bnxt_vf_reps_create(bp);
+		break;
 
 	default:
 		return -EINVAL;
 	}
+
+	if (!ret)
+		bp->eswitch_mode = mode;
+
+	return ret;
 }
 
 #endif
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.h
index 5637a84884d7..33a965631d0b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.h
@@ -14,6 +14,7 @@
 
 #define	MAX_CFA_CODE			65536
 
+int bnxt_vf_reps_create(struct bnxt *bp);
 void bnxt_vf_reps_destroy(struct bnxt *bp);
 void bnxt_vf_reps_close(struct bnxt *bp);
 void bnxt_vf_reps_open(struct bnxt *bp);
@@ -37,6 +38,11 @@ int bnxt_dl_eswitch_mode_set(struct devlink *devlink, u16 mode,
 
 #else
 
+static inline int bnxt_vf_reps_create(struct bnxt *bp)
+{
+	return 0;
+}
+
 static inline void bnxt_vf_reps_close(struct bnxt *bp)
 {
 }
-- 
2.39.2


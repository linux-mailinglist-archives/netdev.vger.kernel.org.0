Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94E1B6D979B
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 15:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbjDFNFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 09:05:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237316AbjDFNFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 09:05:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2BFA135
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 06:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680786303;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=T3RBUCn26A4VbMxyCeQYEHYQ9h598F47onZ1i/ThaI4=;
        b=JPiafOUhQ9G6rOrZ5FOYr7nKMQCFm+IcYdysgs5TMVjgqoBqw9ZY27C8brWGHDrYCW8P4n
        6ipCfxtF0OyJkZwOxt2V/hxmTUJniwc9O1fJA61lMRxIb+IKR4djEPaFd8/kBOgnLUOa3J
        5MgATktIdgDK7RYAdMXIlAmKEpSPQ0E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-297-ozL5-iFePSSMhJJaOmsXRA-1; Thu, 06 Apr 2023 09:04:58 -0400
X-MC-Unique: ozL5-iFePSSMhJJaOmsXRA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D2C008533DD;
        Thu,  6 Apr 2023 13:04:57 +0000 (UTC)
Received: from p1.luc.cera.cz.com (unknown [10.45.224.115])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7AD0E40C20FA;
        Thu,  6 Apr 2023 13:04:56 +0000 (UTC)
From:   Ivan Vecera <ivecera@redhat.com>
To:     netdev@vger.kernel.org
Cc:     mschmidt@redhat.com, Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next] bnxt_en: Allow to set switchdev mode without existing VFs
Date:   Thu,  6 Apr 2023 15:04:55 +0200
Message-Id: <20230406130455.1155362-1-ivecera@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
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
8. Checked that representros were re-created
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


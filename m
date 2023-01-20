Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 689F8674D3C
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 07:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbjATGVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 01:21:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbjATGUx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 01:20:53 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 228E3829AC
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 22:20:48 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id x5so3480737qti.3
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 22:20:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=NvSBaKW/+vTwJ/h+mot8+9I7i8ayV3DTschwel8sRs0=;
        b=boU1j4OE4+8c3Z9W4Em5CmisYpaqznqyE0ScPVvxW4E6Br0QMYXfUThhWRsn9JihnM
         4fZ2ch+O8zNYD8Irhhx+RKixZiffT8CVtExt2kQhxaBvn9QnHAkQw/qD003p2dS/eYXm
         QAhsfSJOgx4YSR0BG3bLNlhlRSXPcHbs2bl5w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NvSBaKW/+vTwJ/h+mot8+9I7i8ayV3DTschwel8sRs0=;
        b=e6XiwG9Yif35X/Sp3spGBPemHw4VQvHVnrABlQdlNHqDkg/WRp4OtIW4/B5gDnuOFU
         9a1kK46OqX8pZuQPNB0rMU94xwY+bwvXjFkzmISE/FOsRA7fjdYTFw5H+iALGYDqBgUW
         gFGTUEt6/SBZRmX0Hs2C8PQmU2QySgM4D1GaE/7SI0nyzl0zoskVTLEt1N9uVpequPPs
         xC2cMWApSRzDepsMLgtIK43ZbRskmZZMLcaLw9PHliUBpMazELE6+d1mFBUIdLy7vJnc
         cNfhPAADQWP+S37JezDMhkSmxEqMas1HTJihGnRHEABMDdvZ677oDf5+ePkp1OOEox/h
         39DA==
X-Gm-Message-State: AFqh2kpq1UVOw6AhWU2sRn4e9m5BKPNQmNYbIeYjjDsgo0oSE0n4dJEZ
        ePtJUiBowLrK+Q8iBbo2WfYLHw==
X-Google-Smtp-Source: AMrXdXuDUqvpEgKx8hbeLcQpnvp7lz4G0il4p9jzJQHRs+ZpBl4HnmKEc5pW4JveUPnUVCVxpSyQJw==
X-Received: by 2002:ac8:550a:0:b0:3b6:3022:688e with SMTP id j10-20020ac8550a000000b003b63022688emr26295416qtq.53.1674195647073;
        Thu, 19 Jan 2023 22:20:47 -0800 (PST)
Received: from localhost.localdomain ([2605:a601:a780:1400:641c:466b:fa8e:b05a])
        by smtp.gmail.com with ESMTPSA id e26-20020ac845da000000b003a527d29a41sm6903273qto.75.2023.01.19.22.20.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 22:20:46 -0800 (PST)
From:   Ajit Khaparde <ajit.khaparde@broadcom.com>
To:     ajit.khaparde@broadcom.com
Cc:     andrew.gospodarek@broadcom.com, davem@davemloft.net,
        edumazet@google.com, jgg@ziepe.ca, kuba@kernel.org,
        leon@kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, michael.chan@broadcom.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        selvin.xavier@broadcom.com, Leon Romanovsky <leonro@nvidia.com>
Subject: [PATCH net-next v8 3/8] bnxt_en: Remove usage of ulp_id
Date:   Thu, 19 Jan 2023 22:05:30 -0800
Message-Id: <20230120060535.83087-4-ajit.khaparde@broadcom.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20230120060535.83087-1-ajit.khaparde@broadcom.com>
References: <20230120060535.83087-1-ajit.khaparde@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000da237a05f2ac0c54"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000da237a05f2ac0c54
Content-Transfer-Encoding: 8bit

Since the driver continues to use the single ULP model,
the extra complexity and indirection is unnecessary.
Remove the usage of ulp_id from the code.

Suggested-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Ajit Khaparde <ajit.khaparde@broadcom.com>
Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
Reviewed-by: Selvin Xavier <selvin.xavier@broadcom.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/bnxt_re/main.c          |  24 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c | 208 ++++++++----------
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h |  26 +--
 4 files changed, 114 insertions(+), 146 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index 82c81ffea152..5bf3dc067484 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -363,8 +363,7 @@ static int bnxt_re_unregister_netdev(struct bnxt_re_dev *rdev)
 
 	en_dev = rdev->en_dev;
 
-	rc = en_dev->en_ops->bnxt_unregister_device(rdev->en_dev,
-						    BNXT_ROCE_ULP);
+	rc = en_dev->en_ops->bnxt_unregister_device(rdev->en_dev);
 	return rc;
 }
 
@@ -375,7 +374,7 @@ static int bnxt_re_register_netdev(struct bnxt_re_dev *rdev)
 
 	en_dev = rdev->en_dev;
 
-	rc = en_dev->en_ops->bnxt_register_device(en_dev, BNXT_ROCE_ULP,
+	rc = en_dev->en_ops->bnxt_register_device(en_dev,
 						  &bnxt_re_ulp_ops, rdev);
 	rdev->qplib_res.pdev = rdev->en_dev->pdev;
 	return rc;
@@ -384,16 +383,15 @@ static int bnxt_re_register_netdev(struct bnxt_re_dev *rdev)
 static int bnxt_re_free_msix(struct bnxt_re_dev *rdev)
 {
 	struct bnxt_en_dev *en_dev;
-	int rc;
 
 	if (!rdev)
 		return -EINVAL;
 
 	en_dev = rdev->en_dev;
 
-	rc = en_dev->en_ops->bnxt_free_msix(rdev->en_dev, BNXT_ROCE_ULP);
+	en_dev->en_ops->bnxt_free_msix(rdev->en_dev);
 
-	return rc;
+	return 0;
 }
 
 static int bnxt_re_request_msix(struct bnxt_re_dev *rdev)
@@ -405,7 +403,7 @@ static int bnxt_re_request_msix(struct bnxt_re_dev *rdev)
 
 	num_msix_want = min_t(u32, BNXT_RE_MAX_MSIX, num_online_cpus());
 
-	num_msix_got = en_dev->en_ops->bnxt_request_msix(en_dev, BNXT_ROCE_ULP,
+	num_msix_got = en_dev->en_ops->bnxt_request_msix(en_dev,
 							 rdev->msix_entries,
 							 num_msix_want);
 	if (num_msix_got < BNXT_RE_MIN_MSIX) {
@@ -468,7 +466,7 @@ static int bnxt_re_net_ring_free(struct bnxt_re_dev *rdev,
 	req.ring_id = cpu_to_le16(fw_ring_id);
 	bnxt_re_fill_fw_msg(&fw_msg, (void *)&req, sizeof(req), (void *)&resp,
 			    sizeof(resp), DFLT_HWRM_CMD_TIMEOUT);
-	rc = en_dev->en_ops->bnxt_send_fw_msg(en_dev, BNXT_ROCE_ULP, &fw_msg);
+	rc = en_dev->en_ops->bnxt_send_fw_msg(en_dev, &fw_msg);
 	if (rc)
 		ibdev_err(&rdev->ibdev, "Failed to free HW ring:%d :%#x",
 			  req.ring_id, rc);
@@ -505,7 +503,7 @@ static int bnxt_re_net_ring_alloc(struct bnxt_re_dev *rdev,
 	req.int_mode = ring_attr->mode;
 	bnxt_re_fill_fw_msg(&fw_msg, (void *)&req, sizeof(req), (void *)&resp,
 			    sizeof(resp), DFLT_HWRM_CMD_TIMEOUT);
-	rc = en_dev->en_ops->bnxt_send_fw_msg(en_dev, BNXT_ROCE_ULP, &fw_msg);
+	rc = en_dev->en_ops->bnxt_send_fw_msg(en_dev, &fw_msg);
 	if (!rc)
 		*fw_ring_id = le16_to_cpu(resp.ring_id);
 
@@ -533,7 +531,7 @@ static int bnxt_re_net_stats_ctx_free(struct bnxt_re_dev *rdev,
 	req.stat_ctx_id = cpu_to_le32(fw_stats_ctx_id);
 	bnxt_re_fill_fw_msg(&fw_msg, (void *)&req, sizeof(req), (void *)&resp,
 			    sizeof(resp), DFLT_HWRM_CMD_TIMEOUT);
-	rc = en_dev->en_ops->bnxt_send_fw_msg(en_dev, BNXT_ROCE_ULP, &fw_msg);
+	rc = en_dev->en_ops->bnxt_send_fw_msg(en_dev, &fw_msg);
 	if (rc)
 		ibdev_err(&rdev->ibdev, "Failed to free HW stats context %#x",
 			  rc);
@@ -566,7 +564,7 @@ static int bnxt_re_net_stats_ctx_alloc(struct bnxt_re_dev *rdev,
 	req.stat_ctx_flags = STAT_CTX_ALLOC_REQ_STAT_CTX_FLAGS_ROCE;
 	bnxt_re_fill_fw_msg(&fw_msg, (void *)&req, sizeof(req), (void *)&resp,
 			    sizeof(resp), DFLT_HWRM_CMD_TIMEOUT);
-	rc = en_dev->en_ops->bnxt_send_fw_msg(en_dev, BNXT_ROCE_ULP, &fw_msg);
+	rc = en_dev->en_ops->bnxt_send_fw_msg(en_dev, &fw_msg);
 	if (!rc)
 		*fw_stats_ctx_id = le32_to_cpu(resp.stat_ctx_id);
 
@@ -1052,7 +1050,7 @@ static int bnxt_re_query_hwrm_pri2cos(struct bnxt_re_dev *rdev, u8 dir,
 
 	bnxt_re_fill_fw_msg(&fw_msg, (void *)&req, sizeof(req), (void *)&resp,
 			    sizeof(resp), DFLT_HWRM_CMD_TIMEOUT);
-	rc = en_dev->en_ops->bnxt_send_fw_msg(en_dev, BNXT_ROCE_ULP, &fw_msg);
+	rc = en_dev->en_ops->bnxt_send_fw_msg(en_dev, &fw_msg);
 	if (rc)
 		return rc;
 
@@ -1235,7 +1233,7 @@ static void bnxt_re_query_hwrm_intf_version(struct bnxt_re_dev *rdev)
 	req.hwrm_intf_upd = HWRM_VERSION_UPDATE;
 	bnxt_re_fill_fw_msg(&fw_msg, (void *)&req, sizeof(req), (void *)&resp,
 			    sizeof(resp), DFLT_HWRM_CMD_TIMEOUT);
-	rc = en_dev->en_ops->bnxt_send_fw_msg(en_dev, BNXT_ROCE_ULP, &fw_msg);
+	rc = en_dev->en_ops->bnxt_send_fw_msg(en_dev, &fw_msg);
 	if (rc) {
 		ibdev_err(&rdev->ibdev, "Failed to query HW version, rc = 0x%x",
 			  rc);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index bf3eaa2c0d06..8d5cdbaa618c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -5538,7 +5538,7 @@ int bnxt_hwrm_vnic_cfg(struct bnxt *bp, u16 vnic_id)
 #endif
 	if ((bp->flags & BNXT_FLAG_STRIP_VLAN) || def_vlan)
 		req->flags |= cpu_to_le32(VNIC_CFG_REQ_FLAGS_VLAN_STRIP_MODE);
-	if (!vnic_id && bnxt_ulp_registered(bp->edev, BNXT_ROCE_ULP))
+	if (!vnic_id && bnxt_ulp_registered(bp->edev))
 		req->flags |= cpu_to_le32(bnxt_get_roce_vnic_mode(bp));
 
 	return hwrm_req_send(bp, req);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
index ef1e89893503..184ad346ddb8 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
@@ -28,59 +28,44 @@
 
 static DEFINE_IDA(bnxt_aux_dev_ids);
 
-static int bnxt_register_dev(struct bnxt_en_dev *edev, unsigned int ulp_id,
-			     struct bnxt_ulp_ops *ulp_ops, void *handle)
+static int bnxt_register_dev(struct bnxt_en_dev *edev,
+			     struct bnxt_ulp_ops *ulp_ops,
+			     void *handle)
 {
 	struct net_device *dev = edev->net;
 	struct bnxt *bp = netdev_priv(dev);
+	unsigned int max_stat_ctxs;
 	struct bnxt_ulp *ulp;
 
-	if (ulp_id >= BNXT_MAX_ULP)
-		return -EINVAL;
-
-	ulp = &edev->ulp_tbl[ulp_id];
-	if (rcu_access_pointer(ulp->ulp_ops)) {
-		netdev_err(bp->dev, "ulp id %d already registered\n", ulp_id);
-		return -EBUSY;
-	}
-	if (ulp_id == BNXT_ROCE_ULP) {
-		unsigned int max_stat_ctxs;
+	max_stat_ctxs = bnxt_get_max_func_stat_ctxs(bp);
+	if (max_stat_ctxs <= BNXT_MIN_ROCE_STAT_CTXS ||
+	    bp->cp_nr_rings == max_stat_ctxs)
+		return -ENOMEM;
 
-		max_stat_ctxs = bnxt_get_max_func_stat_ctxs(bp);
-		if (max_stat_ctxs <= BNXT_MIN_ROCE_STAT_CTXS ||
-		    bp->cp_nr_rings == max_stat_ctxs)
-			return -ENOMEM;
-	}
+	ulp = kzalloc(sizeof(*ulp), GFP_KERNEL);
+	if (!ulp)
+		return -ENOMEM;
 
-	atomic_set(&ulp->ref_count, 1);
+	edev->ulp_tbl = ulp;
 	ulp->handle = handle;
 	rcu_assign_pointer(ulp->ulp_ops, ulp_ops);
 
-	if (ulp_id == BNXT_ROCE_ULP) {
-		if (test_bit(BNXT_STATE_OPEN, &bp->state))
-			bnxt_hwrm_vnic_cfg(bp, 0);
-	}
+	if (test_bit(BNXT_STATE_OPEN, &bp->state))
+		bnxt_hwrm_vnic_cfg(bp, 0);
 
 	return 0;
 }
 
-static int bnxt_unregister_dev(struct bnxt_en_dev *edev, unsigned int ulp_id)
+static int bnxt_unregister_dev(struct bnxt_en_dev *edev)
 {
 	struct net_device *dev = edev->net;
 	struct bnxt *bp = netdev_priv(dev);
 	struct bnxt_ulp *ulp;
 	int i = 0;
 
-	if (ulp_id >= BNXT_MAX_ULP)
-		return -EINVAL;
-
-	ulp = &edev->ulp_tbl[ulp_id];
-	if (!rcu_access_pointer(ulp->ulp_ops)) {
-		netdev_err(bp->dev, "ulp id %d not registered\n", ulp_id);
-		return -EINVAL;
-	}
-	if (ulp_id == BNXT_ROCE_ULP && ulp->msix_requested)
-		edev->en_ops->bnxt_free_msix(edev, ulp_id);
+	ulp = edev->ulp_tbl;
+	if (ulp->msix_requested)
+		edev->en_ops->bnxt_free_msix(edev);
 
 	if (ulp->max_async_event_id)
 		bnxt_hwrm_func_drv_rgtr(bp, NULL, 0, true);
@@ -93,6 +78,8 @@ static int bnxt_unregister_dev(struct bnxt_en_dev *edev, unsigned int ulp_id)
 		msleep(100);
 		i++;
 	}
+	kfree(ulp);
+	edev->ulp_tbl = NULL;
 	return 0;
 }
 
@@ -101,8 +88,8 @@ static void bnxt_fill_msix_vecs(struct bnxt *bp, struct bnxt_msix_entry *ent)
 	struct bnxt_en_dev *edev = bp->edev;
 	int num_msix, idx, i;
 
-	num_msix = edev->ulp_tbl[BNXT_ROCE_ULP].msix_requested;
-	idx = edev->ulp_tbl[BNXT_ROCE_ULP].msix_base;
+	num_msix = edev->ulp_tbl->msix_requested;
+	idx = edev->ulp_tbl->msix_base;
 	for (i = 0; i < num_msix; i++) {
 		ent[i].vector = bp->irq_tbl[idx + i].vector;
 		ent[i].ring_idx = idx + i;
@@ -116,8 +103,9 @@ static void bnxt_fill_msix_vecs(struct bnxt *bp, struct bnxt_msix_entry *ent)
 	}
 }
 
-static int bnxt_req_msix_vecs(struct bnxt_en_dev *edev, unsigned int ulp_id,
-			      struct bnxt_msix_entry *ent, int num_msix)
+static int bnxt_req_msix_vecs(struct bnxt_en_dev *edev,
+			      struct bnxt_msix_entry *ent,
+			      int num_msix)
 {
 	struct net_device *dev = edev->net;
 	struct bnxt *bp = netdev_priv(dev);
@@ -127,13 +115,10 @@ static int bnxt_req_msix_vecs(struct bnxt_en_dev *edev, unsigned int ulp_id,
 	int total_vecs;
 	int rc = 0;
 
-	if (ulp_id != BNXT_ROCE_ULP)
-		return -EINVAL;
-
 	if (!(bp->flags & BNXT_FLAG_USING_MSIX))
 		return -ENODEV;
 
-	if (edev->ulp_tbl[ulp_id].msix_requested)
+	if (edev->ulp_tbl->msix_requested)
 		return -EAGAIN;
 
 	max_cp_rings = bnxt_get_max_func_cp_rings(bp);
@@ -150,8 +135,8 @@ static int bnxt_req_msix_vecs(struct bnxt_en_dev *edev, unsigned int ulp_id,
 		idx = max_idx - avail_msix;
 	}
 
-	edev->ulp_tbl[ulp_id].msix_base = idx;
-	edev->ulp_tbl[ulp_id].msix_requested = avail_msix;
+	edev->ulp_tbl->msix_base = idx;
+	edev->ulp_tbl->msix_requested = avail_msix;
 	hw_resc = &bp->hw_resc;
 	total_vecs = idx + avail_msix;
 	rtnl_lock();
@@ -166,7 +151,7 @@ static int bnxt_req_msix_vecs(struct bnxt_en_dev *edev, unsigned int ulp_id,
 	}
 	rtnl_unlock();
 	if (rc) {
-		edev->ulp_tbl[ulp_id].msix_requested = 0;
+		edev->ulp_tbl->msix_requested = 0;
 		return -EAGAIN;
 	}
 
@@ -175,25 +160,22 @@ static int bnxt_req_msix_vecs(struct bnxt_en_dev *edev, unsigned int ulp_id,
 
 		resv_msix = hw_resc->resv_irqs - bp->cp_nr_rings;
 		avail_msix = min_t(int, resv_msix, avail_msix);
-		edev->ulp_tbl[ulp_id].msix_requested = avail_msix;
+		edev->ulp_tbl->msix_requested = avail_msix;
 	}
 	bnxt_fill_msix_vecs(bp, ent);
 	edev->flags |= BNXT_EN_FLAG_MSIX_REQUESTED;
 	return avail_msix;
 }
 
-static int bnxt_free_msix_vecs(struct bnxt_en_dev *edev, unsigned int ulp_id)
+static void bnxt_free_msix_vecs(struct bnxt_en_dev *edev)
 {
 	struct net_device *dev = edev->net;
 	struct bnxt *bp = netdev_priv(dev);
 
-	if (ulp_id != BNXT_ROCE_ULP)
-		return -EINVAL;
-
 	if (!(edev->flags & BNXT_EN_FLAG_MSIX_REQUESTED))
-		return 0;
+		return;
 
-	edev->ulp_tbl[ulp_id].msix_requested = 0;
+	edev->ulp_tbl->msix_requested = 0;
 	edev->flags &= ~BNXT_EN_FLAG_MSIX_REQUESTED;
 	rtnl_lock();
 	if (netif_running(dev) && !(edev->flags & BNXT_EN_FLAG_ULP_STOPPED)) {
@@ -202,43 +184,43 @@ static int bnxt_free_msix_vecs(struct bnxt_en_dev *edev, unsigned int ulp_id)
 	}
 	rtnl_unlock();
 
-	return 0;
+	return;
 }
 
 int bnxt_get_ulp_msix_num(struct bnxt *bp)
 {
-	if (bnxt_ulp_registered(bp->edev, BNXT_ROCE_ULP)) {
+	if (bnxt_ulp_registered(bp->edev)) {
 		struct bnxt_en_dev *edev = bp->edev;
 
-		return edev->ulp_tbl[BNXT_ROCE_ULP].msix_requested;
+		return edev->ulp_tbl->msix_requested;
 	}
 	return 0;
 }
 
 int bnxt_get_ulp_msix_base(struct bnxt *bp)
 {
-	if (bnxt_ulp_registered(bp->edev, BNXT_ROCE_ULP)) {
+	if (bnxt_ulp_registered(bp->edev)) {
 		struct bnxt_en_dev *edev = bp->edev;
 
-		if (edev->ulp_tbl[BNXT_ROCE_ULP].msix_requested)
-			return edev->ulp_tbl[BNXT_ROCE_ULP].msix_base;
+		if (edev->ulp_tbl->msix_requested)
+			return edev->ulp_tbl->msix_base;
 	}
 	return 0;
 }
 
 int bnxt_get_ulp_stat_ctxs(struct bnxt *bp)
 {
-	if (bnxt_ulp_registered(bp->edev, BNXT_ROCE_ULP)) {
+	if (bnxt_ulp_registered(bp->edev)) {
 		struct bnxt_en_dev *edev = bp->edev;
 
-		if (edev->ulp_tbl[BNXT_ROCE_ULP].msix_requested)
+		if (edev->ulp_tbl->msix_requested)
 			return BNXT_MIN_ROCE_STAT_CTXS;
 	}
 
 	return 0;
 }
 
-static int bnxt_send_msg(struct bnxt_en_dev *edev, unsigned int ulp_id,
+static int bnxt_send_msg(struct bnxt_en_dev *edev,
 			 struct bnxt_fw_msg *fw_msg)
 {
 	struct net_device *dev = edev->net;
@@ -248,7 +230,7 @@ static int bnxt_send_msg(struct bnxt_en_dev *edev, unsigned int ulp_id,
 	u32 resp_len;
 	int rc;
 
-	if (ulp_id != BNXT_ROCE_ULP && bp->fw_reset_state)
+	if (bp->fw_reset_state)
 		return -EBUSY;
 
 	rc = hwrm_req_init(bp, req, 0 /* don't care */);
@@ -287,27 +269,24 @@ void bnxt_ulp_stop(struct bnxt *bp)
 {
 	struct bnxt_en_dev *edev = bp->edev;
 	struct bnxt_ulp_ops *ops;
-	int i;
+	struct bnxt_ulp *ulp;
 
 	if (!edev)
 		return;
 
 	edev->flags |= BNXT_EN_FLAG_ULP_STOPPED;
-	for (i = 0; i < BNXT_MAX_ULP; i++) {
-		struct bnxt_ulp *ulp = &edev->ulp_tbl[i];
-
-		ops = rtnl_dereference(ulp->ulp_ops);
-		if (!ops || !ops->ulp_stop)
-			continue;
-		ops->ulp_stop(ulp->handle);
-	}
+	ulp = edev->ulp_tbl;
+	ops = rtnl_dereference(ulp->ulp_ops);
+	if (!ops || !ops->ulp_stop)
+		return;
+	ops->ulp_stop(ulp->handle);
 }
 
 void bnxt_ulp_start(struct bnxt *bp, int err)
 {
 	struct bnxt_en_dev *edev = bp->edev;
 	struct bnxt_ulp_ops *ops;
-	int i;
+	struct bnxt_ulp *ulp;
 
 	if (!edev)
 		return;
@@ -317,39 +296,33 @@ void bnxt_ulp_start(struct bnxt *bp, int err)
 	if (err)
 		return;
 
-	for (i = 0; i < BNXT_MAX_ULP; i++) {
-		struct bnxt_ulp *ulp = &edev->ulp_tbl[i];
-
-		ops = rtnl_dereference(ulp->ulp_ops);
-		if (!ops || !ops->ulp_start)
-			continue;
-		ops->ulp_start(ulp->handle);
-	}
+	ulp = edev->ulp_tbl;
+	ops = rtnl_dereference(ulp->ulp_ops);
+	if (!ops || !ops->ulp_start)
+		return;
+	ops->ulp_start(ulp->handle);
 }
 
 void bnxt_ulp_sriov_cfg(struct bnxt *bp, int num_vfs)
 {
 	struct bnxt_en_dev *edev = bp->edev;
 	struct bnxt_ulp_ops *ops;
-	int i;
+	struct bnxt_ulp *ulp;
 
 	if (!edev)
 		return;
+	ulp = edev->ulp_tbl;
 
-	for (i = 0; i < BNXT_MAX_ULP; i++) {
-		struct bnxt_ulp *ulp = &edev->ulp_tbl[i];
-
-		rcu_read_lock();
-		ops = rcu_dereference(ulp->ulp_ops);
-		if (!ops || !ops->ulp_sriov_config) {
-			rcu_read_unlock();
-			continue;
-		}
-		bnxt_ulp_get(ulp);
+	rcu_read_lock();
+	ops = rcu_dereference(ulp->ulp_ops);
+	if (!ops || !ops->ulp_sriov_config) {
 		rcu_read_unlock();
-		ops->ulp_sriov_config(ulp->handle, num_vfs);
-		bnxt_ulp_put(ulp);
+		return;
 	}
+	bnxt_ulp_get(ulp);
+	rcu_read_unlock();
+	ops->ulp_sriov_config(ulp->handle, num_vfs);
+	bnxt_ulp_put(ulp);
 }
 
 void bnxt_ulp_irq_stop(struct bnxt *bp)
@@ -360,8 +333,8 @@ void bnxt_ulp_irq_stop(struct bnxt *bp)
 	if (!edev || !(edev->flags & BNXT_EN_FLAG_MSIX_REQUESTED))
 		return;
 
-	if (bnxt_ulp_registered(bp->edev, BNXT_ROCE_ULP)) {
-		struct bnxt_ulp *ulp = &edev->ulp_tbl[BNXT_ROCE_ULP];
+	if (bnxt_ulp_registered(bp->edev)) {
+		struct bnxt_ulp *ulp = edev->ulp_tbl;
 
 		if (!ulp->msix_requested)
 			return;
@@ -381,8 +354,8 @@ void bnxt_ulp_irq_restart(struct bnxt *bp, int err)
 	if (!edev || !(edev->flags & BNXT_EN_FLAG_MSIX_REQUESTED))
 		return;
 
-	if (bnxt_ulp_registered(bp->edev, BNXT_ROCE_ULP)) {
-		struct bnxt_ulp *ulp = &edev->ulp_tbl[BNXT_ROCE_ULP];
+	if (bnxt_ulp_registered(bp->edev)) {
+		struct bnxt_ulp *ulp = edev->ulp_tbl;
 		struct bnxt_msix_entry *ent = NULL;
 
 		if (!ulp->msix_requested)
@@ -409,41 +382,38 @@ void bnxt_ulp_async_events(struct bnxt *bp, struct hwrm_async_event_cmpl *cmpl)
 	u16 event_id = le16_to_cpu(cmpl->event_id);
 	struct bnxt_en_dev *edev = bp->edev;
 	struct bnxt_ulp_ops *ops;
-	int i;
+	struct bnxt_ulp *ulp;
 
-	if (!edev)
+	if (!bnxt_ulp_registered(edev))
 		return;
 
+	ulp = edev->ulp_tbl;
+
 	rcu_read_lock();
-	for (i = 0; i < BNXT_MAX_ULP; i++) {
-		struct bnxt_ulp *ulp = &edev->ulp_tbl[i];
-
-		ops = rcu_dereference(ulp->ulp_ops);
-		if (!ops || !ops->ulp_async_notifier)
-			continue;
-		if (!ulp->async_events_bmap ||
-		    event_id > ulp->max_async_event_id)
-			continue;
-
-		/* Read max_async_event_id first before testing the bitmap. */
-		smp_rmb();
-		if (test_bit(event_id, ulp->async_events_bmap))
-			ops->ulp_async_notifier(ulp->handle, cmpl);
-	}
+
+	ops = rcu_dereference(ulp->ulp_ops);
+	if (!ops || !ops->ulp_async_notifier)
+		goto exit;
+	if (!ulp->async_events_bmap || event_id > ulp->max_async_event_id)
+		goto exit;
+
+	/* Read max_async_event_id first before testing the bitmap. */
+	smp_rmb();
+	if (test_bit(event_id, ulp->async_events_bmap))
+		ops->ulp_async_notifier(ulp->handle, cmpl);
+exit:
 	rcu_read_unlock();
 }
 
-static int bnxt_register_async_events(struct bnxt_en_dev *edev, unsigned int ulp_id,
-				      unsigned long *events_bmap, u16 max_id)
+static int bnxt_register_async_events(struct bnxt_en_dev *edev,
+				      unsigned long *events_bmap,
+				      u16 max_id)
 {
 	struct net_device *dev = edev->net;
 	struct bnxt *bp = netdev_priv(dev);
 	struct bnxt_ulp *ulp;
 
-	if (ulp_id >= BNXT_MAX_ULP)
-		return -EINVAL;
-
-	ulp = &edev->ulp_tbl[ulp_id];
+	ulp = edev->ulp_tbl;
 	ulp->async_events_bmap = events_bmap;
 	/* Make sure bnxt_ulp_async_events() sees this order */
 	smp_wmb();
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
index e8419057f4bb..3f634878a13d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
@@ -64,7 +64,7 @@ struct bnxt_en_dev {
 	#define BNXT_EN_FLAG_MSIX_REQUESTED	0x4
 	#define BNXT_EN_FLAG_ULP_STOPPED	0x8
 	const struct bnxt_en_ops	*en_ops;
-	struct bnxt_ulp			ulp_tbl[BNXT_MAX_ULP];
+	struct bnxt_ulp			*ulp_tbl;
 	int				l2_db_size;	/* Doorbell BAR size in
 							 * bytes mapped by L2
 							 * driver.
@@ -76,21 +76,21 @@ struct bnxt_en_dev {
 };
 
 struct bnxt_en_ops {
-	int (*bnxt_register_device)(struct bnxt_en_dev *, unsigned int,
-				    struct bnxt_ulp_ops *, void *);
-	int (*bnxt_unregister_device)(struct bnxt_en_dev *, unsigned int);
-	int (*bnxt_request_msix)(struct bnxt_en_dev *, unsigned int,
-				 struct bnxt_msix_entry *, int);
-	int (*bnxt_free_msix)(struct bnxt_en_dev *, unsigned int);
-	int (*bnxt_send_fw_msg)(struct bnxt_en_dev *, unsigned int,
-				struct bnxt_fw_msg *);
-	int (*bnxt_register_fw_async_events)(struct bnxt_en_dev *, unsigned int,
-					     unsigned long *, u16);
+	int (*bnxt_register_device)(struct bnxt_en_dev *edev,
+				    struct bnxt_ulp_ops *ulp_ops, void *handle);
+	int (*bnxt_unregister_device)(struct bnxt_en_dev *edev);
+	int (*bnxt_request_msix)(struct bnxt_en_dev *edev,
+				 struct bnxt_msix_entry *ent, int num_msix);
+	void (*bnxt_free_msix)(struct bnxt_en_dev *edev);
+	int (*bnxt_send_fw_msg)(struct bnxt_en_dev *edev,
+				struct bnxt_fw_msg *fw_msg);
+	int (*bnxt_register_fw_async_events)(struct bnxt_en_dev *edev,
+					     unsigned long *events_bmap, u16 max_id);
 };
 
-static inline bool bnxt_ulp_registered(struct bnxt_en_dev *edev, int ulp_id)
+static inline bool bnxt_ulp_registered(struct bnxt_en_dev *edev)
 {
-	if (edev && rcu_access_pointer(edev->ulp_tbl[ulp_id].ulp_ops))
+	if (edev && edev->ulp_tbl)
 		return true;
 	return false;
 }
-- 
2.37.1 (Apple Git-137.1)


--000000000000da237a05f2ac0c54
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
pZEyqKnwS1lKCzjX7mV5W955rFsFxChdAKfw0HilwtqdY24mhy62+GeaEkD0gYIj1tCmw9gnQToc
K+0s7xEunfR9pBrzmOwS3OQbcP0nJ8SmQ8R+reroH6LYuFpaqK1rgQIDAQABo4IB2zCCAdcwDgYD
VR0PAQH/BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3Vy
ZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEG
CCsGAQUFBzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWdu
MmNhMjAyMDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93
d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6
hjhodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNy
bDAlBgNVHREEHjAcgRphaml0LmtoYXBhcmRlQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUbrcTuh0mr2qP
xYdtyDgFeRIiE/gwDQYJKoZIhvcNAQELBQADggEBALrc1TljKrDhXicOaZlzIQyqOEkKAZ324i8X
OwzA0n2EcPGmMZvgARurvanSLD3mLeeuyq1feCcjfGM1CJFh4+EY7EkbFbpVPOIdstSBhbnAJnOl
aC/q0wTndKoC/xXBhXOZB8YL/Zq4ZclQLMUO6xi/fFRyHviI5/IrosdrpniXFJ9ukJoOXtvdrEF+
KlMYg/Deg9xo3wddCqQIsztHSkR4XaANdn+dbLRQpctZ13BY1lim4uz5bYn3M0IxyZWkQ1JuPHCK
aRJv0SfR88PoI4RB7NCEHqFwARTj1KvFPQi8pK/YISFydZYbZrxQdyWDidqm4wSuJfpE6i0cWvCd
u50xggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwM2Vrj
4nZK0WWosNswDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIOzBtKd8NqgewTtT20bo
fUYwX43bT2H+T6+3ybjSjn1EMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIzMDEyMDA2MjA0N1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQA0OEFcjZ9jTAXNDS+MB4shho/zzVvG7FvIpRNU
q247/uEAb40b1FJyavAFBLaZA0pE2U38XZia3B/sLEzkHTu/Ex63hmvwOscVhClZ6GiggupMhg0m
V3WrPNlbuoJhkC3+VQhP0P4ZYAbyQn4+26P37ffVPf1kJJIfeuQz3TzfqKXwuQn6JN/2iM4K4L0y
nNZWUyJ3ZQLHr5uZmma4FX9tjwkn1TzB52zHFk3SciyCZy007OtQoSRmLzLsnjTlCKHedmaVBbWW
gt4I1yhRcugNKhOldeyxc6iNafZzBut44UEZlwRfYp3JktRuukISSxYaVoBtlaJtM0lJ0dKQCEFR
--000000000000da237a05f2ac0c54--

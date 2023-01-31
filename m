Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0ACE6823E9
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 06:26:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231234AbjAaF04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 00:26:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230342AbjAaF0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 00:26:17 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B25F3B675
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 21:26:14 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id rm7-20020a17090b3ec700b0022c05558d22so13322511pjb.5
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 21:26:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=TE6MWWhQ3V+v5EGvuLQqLfN1WtSjtoAM4zsQTX+/HBs=;
        b=CEv7F36adSFiAsxYK/rF5gwfc0n1lINY3G12G5QZLY1c2XJgq8FuG85PM8addtygTO
         tNDp/Q9xWwjf3kK3ebnXmBYd9SxTTjHDPx3qBHF2BWm2v3aXHUBq6W1pOLY9rP/GIiIo
         T6fkUmC4+kA6tEoJLQrDZJ3j2VdVaBVI1LVtU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TE6MWWhQ3V+v5EGvuLQqLfN1WtSjtoAM4zsQTX+/HBs=;
        b=PRGsfWWAJC7E6reNFLHyXpeoAceed1nWlSmd2kYwX1h8nNwzykr4A+TlnYlJo314IQ
         Qs9DKH/j1VKXC4q+Bni31M+4K7LBMbbbo9345fQXSNZGh0x9C6WRMl8T9UYZmZhMT+m4
         2HHZwqKhSIGOZfjs9PNEs+6+pj1yVCsHT+doTNYsQDCHSiCWXSZwijb6k/h3ESlBvCpX
         fXITeR+bf788OGLelvsycgJvrhGYUSwXIodQTXzwksuyjlPfGK46nej8yFhbMqVZ/n0/
         TxTFG0RrQyWrOsDaaOW5SpTKvZB0ZLG0cCarpdFyv5NrbYfnTRSkYpyh1b0ObgOLAye4
         Sy0Q==
X-Gm-Message-State: AO0yUKUFughf93NaQDG5g4SyNshr7F5BLHclYg4Vl9PImhwya+LdqpLN
        IzmtODLRRIScxc4SpjTDAZhlQg==
X-Google-Smtp-Source: AK7set9pHasAKSkjb0ot6zmDTOvllFkGzNEoNkri2XG6b90Qp9gQgb4qvuc0OhXHD8f8YFDZQ4aiSQ==
X-Received: by 2002:a17:902:cacc:b0:189:b4d0:aee with SMTP id y12-20020a170902cacc00b00189b4d00aeemr8556429pld.67.1675142773211;
        Mon, 30 Jan 2023 21:26:13 -0800 (PST)
Received: from localhost.localdomain ([2605:a601:a780:1400:a879:b64b:d9bd:3c1])
        by smtp.gmail.com with ESMTPSA id jk15-20020a170903330f00b001960cccc318sm2310106plb.121.2023.01.30.21.26.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 21:26:12 -0800 (PST)
From:   Ajit Khaparde <ajit.khaparde@broadcom.com>
To:     ajit.khaparde@broadcom.com
Cc:     andrew.gospodarek@broadcom.com, davem@davemloft.net,
        edumazet@google.com, jgg@ziepe.ca, kuba@kernel.org,
        leon@kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, michael.chan@broadcom.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        selvin.xavier@broadcom.com, gregkh@linuxfoundation.org,
        Leon Romanovsky <leonro@nvidia.com>
Subject: [PATCH net-next v9 4/8] bnxt_en: Use direct API instead of indirection
Date:   Mon, 30 Jan 2023 21:25:53 -0800
Message-Id: <20230131052557.99119-5-ajit.khaparde@broadcom.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20230131052557.99119-1-ajit.khaparde@broadcom.com>
References: <20230131052557.99119-1-ajit.khaparde@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000fabf5705f38891f9"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000fabf5705f38891f9
Content-Transfer-Encoding: 8bit

For a single ULP user there is no need for complicating function
indirection calls. Remove all this complexity in favour of direct
function calls exported by the bnxt_en driver. This allows to
simplify the code greatly. Also remove unused ulp_async_notifier.

Suggested-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Ajit Khaparde <ajit.khaparde@broadcom.com>
Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
Reviewed-by: Selvin Xavier <selvin.xavier@broadcom.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/bnxt_re/main.c          | 71 ++++-------------
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  1 -
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c | 76 +++++--------------
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h | 25 +++---
 4 files changed, 45 insertions(+), 128 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index 5bf3dc067484..fa64fe9887bf 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -350,23 +350,6 @@ static struct bnxt_ulp_ops bnxt_re_ulp_ops = {
 
 /* RoCE -> Net driver */
 
-/* Driver registration routines used to let the networking driver (bnxt_en)
- * to know that the RoCE driver is now installed
- */
-static int bnxt_re_unregister_netdev(struct bnxt_re_dev *rdev)
-{
-	struct bnxt_en_dev *en_dev;
-	int rc;
-
-	if (!rdev)
-		return -EINVAL;
-
-	en_dev = rdev->en_dev;
-
-	rc = en_dev->en_ops->bnxt_unregister_device(rdev->en_dev);
-	return rc;
-}
-
 static int bnxt_re_register_netdev(struct bnxt_re_dev *rdev)
 {
 	struct bnxt_en_dev *en_dev;
@@ -374,26 +357,12 @@ static int bnxt_re_register_netdev(struct bnxt_re_dev *rdev)
 
 	en_dev = rdev->en_dev;
 
-	rc = en_dev->en_ops->bnxt_register_device(en_dev,
-						  &bnxt_re_ulp_ops, rdev);
-	rdev->qplib_res.pdev = rdev->en_dev->pdev;
+	rc = bnxt_register_dev(en_dev, &bnxt_re_ulp_ops, rdev);
+	if (!rc)
+		rdev->qplib_res.pdev = rdev->en_dev->pdev;
 	return rc;
 }
 
-static int bnxt_re_free_msix(struct bnxt_re_dev *rdev)
-{
-	struct bnxt_en_dev *en_dev;
-
-	if (!rdev)
-		return -EINVAL;
-
-	en_dev = rdev->en_dev;
-
-	en_dev->en_ops->bnxt_free_msix(rdev->en_dev);
-
-	return 0;
-}
-
 static int bnxt_re_request_msix(struct bnxt_re_dev *rdev)
 {
 	int rc = 0, num_msix_want = BNXT_RE_MAX_MSIX, num_msix_got;
@@ -403,9 +372,9 @@ static int bnxt_re_request_msix(struct bnxt_re_dev *rdev)
 
 	num_msix_want = min_t(u32, BNXT_RE_MAX_MSIX, num_online_cpus());
 
-	num_msix_got = en_dev->en_ops->bnxt_request_msix(en_dev,
-							 rdev->msix_entries,
-							 num_msix_want);
+	num_msix_got = bnxt_req_msix_vecs(en_dev,
+					  rdev->msix_entries,
+					  num_msix_want);
 	if (num_msix_got < BNXT_RE_MIN_MSIX) {
 		rc = -EINVAL;
 		goto done;
@@ -466,7 +435,7 @@ static int bnxt_re_net_ring_free(struct bnxt_re_dev *rdev,
 	req.ring_id = cpu_to_le16(fw_ring_id);
 	bnxt_re_fill_fw_msg(&fw_msg, (void *)&req, sizeof(req), (void *)&resp,
 			    sizeof(resp), DFLT_HWRM_CMD_TIMEOUT);
-	rc = en_dev->en_ops->bnxt_send_fw_msg(en_dev, &fw_msg);
+	rc = bnxt_send_msg(en_dev, &fw_msg);
 	if (rc)
 		ibdev_err(&rdev->ibdev, "Failed to free HW ring:%d :%#x",
 			  req.ring_id, rc);
@@ -503,7 +472,7 @@ static int bnxt_re_net_ring_alloc(struct bnxt_re_dev *rdev,
 	req.int_mode = ring_attr->mode;
 	bnxt_re_fill_fw_msg(&fw_msg, (void *)&req, sizeof(req), (void *)&resp,
 			    sizeof(resp), DFLT_HWRM_CMD_TIMEOUT);
-	rc = en_dev->en_ops->bnxt_send_fw_msg(en_dev, &fw_msg);
+	rc = bnxt_send_msg(en_dev, &fw_msg);
 	if (!rc)
 		*fw_ring_id = le16_to_cpu(resp.ring_id);
 
@@ -531,7 +500,7 @@ static int bnxt_re_net_stats_ctx_free(struct bnxt_re_dev *rdev,
 	req.stat_ctx_id = cpu_to_le32(fw_stats_ctx_id);
 	bnxt_re_fill_fw_msg(&fw_msg, (void *)&req, sizeof(req), (void *)&resp,
 			    sizeof(resp), DFLT_HWRM_CMD_TIMEOUT);
-	rc = en_dev->en_ops->bnxt_send_fw_msg(en_dev, &fw_msg);
+	rc = bnxt_send_msg(en_dev, &fw_msg);
 	if (rc)
 		ibdev_err(&rdev->ibdev, "Failed to free HW stats context %#x",
 			  rc);
@@ -564,7 +533,7 @@ static int bnxt_re_net_stats_ctx_alloc(struct bnxt_re_dev *rdev,
 	req.stat_ctx_flags = STAT_CTX_ALLOC_REQ_STAT_CTX_FLAGS_ROCE;
 	bnxt_re_fill_fw_msg(&fw_msg, (void *)&req, sizeof(req), (void *)&resp,
 			    sizeof(resp), DFLT_HWRM_CMD_TIMEOUT);
-	rc = en_dev->en_ops->bnxt_send_fw_msg(en_dev, &fw_msg);
+	rc = bnxt_send_msg(en_dev, &fw_msg);
 	if (!rc)
 		*fw_stats_ctx_id = le32_to_cpu(resp.stat_ctx_id);
 
@@ -1050,7 +1019,7 @@ static int bnxt_re_query_hwrm_pri2cos(struct bnxt_re_dev *rdev, u8 dir,
 
 	bnxt_re_fill_fw_msg(&fw_msg, (void *)&req, sizeof(req), (void *)&resp,
 			    sizeof(resp), DFLT_HWRM_CMD_TIMEOUT);
-	rc = en_dev->en_ops->bnxt_send_fw_msg(en_dev, &fw_msg);
+	rc = bnxt_send_msg(en_dev, &fw_msg);
 	if (rc)
 		return rc;
 
@@ -1233,7 +1202,7 @@ static void bnxt_re_query_hwrm_intf_version(struct bnxt_re_dev *rdev)
 	req.hwrm_intf_upd = HWRM_VERSION_UPDATE;
 	bnxt_re_fill_fw_msg(&fw_msg, (void *)&req, sizeof(req), (void *)&resp,
 			    sizeof(resp), DFLT_HWRM_CMD_TIMEOUT);
-	rc = en_dev->en_ops->bnxt_send_fw_msg(en_dev, &fw_msg);
+	rc = bnxt_send_msg(en_dev, &fw_msg);
 	if (rc) {
 		ibdev_err(&rdev->ibdev, "Failed to query HW version, rc = 0x%x",
 			  rc);
@@ -1296,20 +1265,12 @@ static void bnxt_re_dev_uninit(struct bnxt_re_dev *rdev)
 		bnxt_re_net_ring_free(rdev, rdev->rcfw.creq.ring_id, type);
 		bnxt_qplib_free_rcfw_channel(&rdev->rcfw);
 	}
-	if (test_and_clear_bit(BNXT_RE_FLAG_GOT_MSIX, &rdev->flags)) {
-		rc = bnxt_re_free_msix(rdev);
-		if (rc)
-			ibdev_warn(&rdev->ibdev,
-				   "Failed to free MSI-X vectors: %#x", rc);
-	}
+	if (test_and_clear_bit(BNXT_RE_FLAG_GOT_MSIX, &rdev->flags))
+		bnxt_free_msix_vecs(rdev->en_dev);
 
 	bnxt_re_destroy_chip_ctx(rdev);
-	if (test_and_clear_bit(BNXT_RE_FLAG_NETDEV_REGISTERED, &rdev->flags)) {
-		rc = bnxt_re_unregister_netdev(rdev);
-		if (rc)
-			ibdev_warn(&rdev->ibdev,
-				   "Failed to unregister with netdev: %#x", rc);
-	}
+	if (test_and_clear_bit(BNXT_RE_FLAG_NETDEV_REGISTERED, &rdev->flags))
+		bnxt_unregister_dev(rdev->en_dev);
 }
 
 /* worker thread for polling periodic events. Now used for QoS programming*/
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 76c1382fc09f..06e7da57c371 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -2414,7 +2414,6 @@ static int bnxt_async_event_process(struct bnxt *bp,
 	}
 	bnxt_queue_sp_work(bp);
 async_event_process_exit:
-	bnxt_ulp_async_events(bp, cmpl);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
index 5bf42fd296c1..d603fdaf0b67 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
@@ -28,9 +28,9 @@
 
 static DEFINE_IDA(bnxt_aux_dev_ids);
 
-static int bnxt_register_dev(struct bnxt_en_dev *edev,
-			     struct bnxt_ulp_ops *ulp_ops,
-			     void *handle)
+int bnxt_register_dev(struct bnxt_en_dev *edev,
+		      struct bnxt_ulp_ops *ulp_ops,
+		      void *handle)
 {
 	struct net_device *dev = edev->net;
 	struct bnxt *bp = netdev_priv(dev);
@@ -55,8 +55,9 @@ static int bnxt_register_dev(struct bnxt_en_dev *edev,
 
 	return 0;
 }
+EXPORT_SYMBOL(bnxt_register_dev);
 
-static int bnxt_unregister_dev(struct bnxt_en_dev *edev)
+void bnxt_unregister_dev(struct bnxt_en_dev *edev)
 {
 	struct net_device *dev = edev->net;
 	struct bnxt *bp = netdev_priv(dev);
@@ -65,7 +66,7 @@ static int bnxt_unregister_dev(struct bnxt_en_dev *edev)
 
 	ulp = edev->ulp_tbl;
 	if (ulp->msix_requested)
-		edev->en_ops->bnxt_free_msix(edev);
+		bnxt_free_msix_vecs(edev);
 
 	if (ulp->max_async_event_id)
 		bnxt_hwrm_func_drv_rgtr(bp, NULL, 0, true);
@@ -80,8 +81,9 @@ static int bnxt_unregister_dev(struct bnxt_en_dev *edev)
 	}
 	kfree(ulp);
 	edev->ulp_tbl = NULL;
-	return 0;
+	return;
 }
+EXPORT_SYMBOL(bnxt_unregister_dev);
 
 static void bnxt_fill_msix_vecs(struct bnxt *bp, struct bnxt_msix_entry *ent)
 {
@@ -103,7 +105,7 @@ static void bnxt_fill_msix_vecs(struct bnxt *bp, struct bnxt_msix_entry *ent)
 	}
 }
 
-static int bnxt_req_msix_vecs(struct bnxt_en_dev *edev,
+int bnxt_req_msix_vecs(struct bnxt_en_dev *edev,
 			      struct bnxt_msix_entry *ent,
 			      int num_msix)
 {
@@ -165,8 +167,9 @@ static int bnxt_req_msix_vecs(struct bnxt_en_dev *edev,
 	edev->flags |= BNXT_EN_FLAG_MSIX_REQUESTED;
 	return avail_msix;
 }
+EXPORT_SYMBOL(bnxt_req_msix_vecs);
 
-static void bnxt_free_msix_vecs(struct bnxt_en_dev *edev)
+void bnxt_free_msix_vecs(struct bnxt_en_dev *edev)
 {
 	struct net_device *dev = edev->net;
 	struct bnxt *bp = netdev_priv(dev);
@@ -185,6 +188,7 @@ static void bnxt_free_msix_vecs(struct bnxt_en_dev *edev)
 
 	return;
 }
+EXPORT_SYMBOL(bnxt_free_msix_vecs);
 
 int bnxt_get_ulp_msix_num(struct bnxt *bp)
 {
@@ -219,7 +223,7 @@ int bnxt_get_ulp_stat_ctxs(struct bnxt *bp)
 	return 0;
 }
 
-static int bnxt_send_msg(struct bnxt_en_dev *edev,
+int bnxt_send_msg(struct bnxt_en_dev *edev,
 			 struct bnxt_fw_msg *fw_msg)
 {
 	struct net_device *dev = edev->net;
@@ -253,6 +257,7 @@ static int bnxt_send_msg(struct bnxt_en_dev *edev,
 	hwrm_req_drop(bp, req);
 	return rc;
 }
+EXPORT_SYMBOL(bnxt_send_msg);
 
 static void bnxt_ulp_get(struct bnxt_ulp *ulp)
 {
@@ -312,14 +317,11 @@ void bnxt_ulp_sriov_cfg(struct bnxt *bp, int num_vfs)
 		return;
 	ulp = edev->ulp_tbl;
 
-	rcu_read_lock();
 	ops = rcu_dereference(ulp->ulp_ops);
-	if (!ops || !ops->ulp_sriov_config) {
-		rcu_read_unlock();
+	if (!ops || !ops->ulp_sriov_config)
 		return;
-	}
+
 	bnxt_ulp_get(ulp);
-	rcu_read_unlock();
 	ops->ulp_sriov_config(ulp->handle, num_vfs);
 	bnxt_ulp_put(ulp);
 }
@@ -376,37 +378,9 @@ void bnxt_ulp_irq_restart(struct bnxt *bp, int err)
 	}
 }
 
-void bnxt_ulp_async_events(struct bnxt *bp, struct hwrm_async_event_cmpl *cmpl)
-{
-	u16 event_id = le16_to_cpu(cmpl->event_id);
-	struct bnxt_en_dev *edev = bp->edev;
-	struct bnxt_ulp_ops *ops;
-	struct bnxt_ulp *ulp;
-
-	if (!bnxt_ulp_registered(edev))
-		return;
-
-	ulp = edev->ulp_tbl;
-
-	rcu_read_lock();
-
-	ops = rcu_dereference(ulp->ulp_ops);
-	if (!ops || !ops->ulp_async_notifier)
-		goto exit;
-	if (!ulp->async_events_bmap || event_id > ulp->max_async_event_id)
-		goto exit;
-
-	/* Read max_async_event_id first before testing the bitmap. */
-	smp_rmb();
-	if (test_bit(event_id, ulp->async_events_bmap))
-		ops->ulp_async_notifier(ulp->handle, cmpl);
-exit:
-	rcu_read_unlock();
-}
-
-static int bnxt_register_async_events(struct bnxt_en_dev *edev,
-				      unsigned long *events_bmap,
-				      u16 max_id)
+int bnxt_register_async_events(struct bnxt_en_dev *edev,
+			       unsigned long *events_bmap,
+			       u16 max_id)
 {
 	struct net_device *dev = edev->net;
 	struct bnxt *bp = netdev_priv(dev);
@@ -420,15 +394,7 @@ static int bnxt_register_async_events(struct bnxt_en_dev *edev,
 	bnxt_hwrm_func_drv_rgtr(bp, events_bmap, max_id + 1, true);
 	return 0;
 }
-
-static const struct bnxt_en_ops bnxt_en_ops_tbl = {
-	.bnxt_register_device	= bnxt_register_dev,
-	.bnxt_unregister_device	= bnxt_unregister_dev,
-	.bnxt_request_msix	= bnxt_req_msix_vecs,
-	.bnxt_free_msix		= bnxt_free_msix_vecs,
-	.bnxt_send_fw_msg	= bnxt_send_msg,
-	.bnxt_register_fw_async_events	= bnxt_register_async_events,
-};
+EXPORT_SYMBOL(bnxt_register_async_events);
 
 void bnxt_rdma_aux_device_uninit(struct bnxt *bp)
 {
@@ -452,7 +418,6 @@ static void bnxt_aux_dev_release(struct device *dev)
 	struct bnxt *bp = netdev_priv(aux_priv->edev->net);
 
 	ida_free(&bnxt_aux_dev_ids, aux_priv->id);
-	aux_priv->edev->en_ops = NULL;
 	kfree(aux_priv->edev);
 	aux_priv->edev = NULL;
 	bp->edev = NULL;
@@ -461,7 +426,6 @@ static void bnxt_aux_dev_release(struct device *dev)
 
 static void bnxt_set_edev_info(struct bnxt_en_dev *edev, struct bnxt *bp)
 {
-	edev->en_ops = &bnxt_en_ops_tbl;
 	edev->net = bp->dev;
 	edev->pdev = bp->pdev;
 	edev->l2_db_size = bp->db_size;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
index aa4e57f670d8..6ce2a1893bcc 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
@@ -26,8 +26,6 @@ struct bnxt_msix_entry {
 };
 
 struct bnxt_ulp_ops {
-	/* async_notifier() cannot sleep (in BH context) */
-	void (*ulp_async_notifier)(void *, struct hwrm_async_event_cmpl *);
 	void (*ulp_stop)(void *);
 	void (*ulp_start)(void *);
 	void (*ulp_sriov_config)(void *, int);
@@ -63,7 +61,6 @@ struct bnxt_en_dev {
 						 BNXT_EN_FLAG_ROCEV2_CAP)
 	#define BNXT_EN_FLAG_MSIX_REQUESTED	0x4
 	#define BNXT_EN_FLAG_ULP_STOPPED	0x8
-	const struct bnxt_en_ops	*en_ops;
 	struct bnxt_ulp			*ulp_tbl;
 	int				l2_db_size;	/* Doorbell BAR size in
 							 * bytes mapped by L2
@@ -75,19 +72,6 @@ struct bnxt_en_dev {
 							 */
 };
 
-struct bnxt_en_ops {
-	int (*bnxt_register_device)(struct bnxt_en_dev *edev,
-				    struct bnxt_ulp_ops *ulp_ops, void *handle);
-	int (*bnxt_unregister_device)(struct bnxt_en_dev *edev);
-	int (*bnxt_request_msix)(struct bnxt_en_dev *edev,
-				 struct bnxt_msix_entry *ent, int num_msix);
-	void (*bnxt_free_msix)(struct bnxt_en_dev *edev);
-	int (*bnxt_send_fw_msg)(struct bnxt_en_dev *edev,
-				struct bnxt_fw_msg *fw_msg);
-	int (*bnxt_register_fw_async_events)(struct bnxt_en_dev *edev,
-					     unsigned long *events_bmap, u16 max_id);
-};
-
 static inline bool bnxt_ulp_registered(struct bnxt_en_dev *edev)
 {
 	if (edev && edev->ulp_tbl)
@@ -106,4 +90,13 @@ void bnxt_ulp_irq_restart(struct bnxt *bp, int err);
 void bnxt_ulp_async_events(struct bnxt *bp, struct hwrm_async_event_cmpl *cmpl);
 void bnxt_rdma_aux_device_uninit(struct bnxt *bp);
 void bnxt_rdma_aux_device_init(struct bnxt *bp);
+int bnxt_register_dev(struct bnxt_en_dev *edev, struct bnxt_ulp_ops *ulp_ops,
+		      void *handle);
+void bnxt_unregister_dev(struct bnxt_en_dev *edev);
+int bnxt_req_msix_vecs(struct bnxt_en_dev *edev, struct bnxt_msix_entry *ent,
+		       int num_msix);
+void bnxt_free_msix_vecs(struct bnxt_en_dev *edev);
+int bnxt_send_msg(struct bnxt_en_dev *edev, struct bnxt_fw_msg *fw_msg);
+int bnxt_register_async_events(struct bnxt_en_dev *edev,
+			       unsigned long *events_bmap, u16 max_id);
 #endif
-- 
2.37.1 (Apple Git-137.1)


--000000000000fabf5705f38891f9
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
4nZK0WWosNswDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIJn4fSbRI79eDTiN14ni
2eyCX0vHX8uMbwvdeckHDJp4MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIzMDEzMTA1MjYxM1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQClU0ef890PKKY035x7GH4eHXNtlojIEKnekTTB
wR+0UVcvfeqtIqwp2bKdRc+8Vk88GY7MqsilET/i0TBrY0vlAU7ZB0nAiitGgRWzOfstOUu2c7Yt
Ai524ccLWuX/70JNXR3Nd8gYVM/GqvpWcaJaEuNs0KJYFaSh27ThQ3j175nXdu1lkxU7VZXAwZii
tXJNyArakjCf3Ru5BgUZOLrGIT/NoNt9JHwnH2/ct+KExM5+99CnXoJc2Vp4Fw3wFCzCILePR27k
wHLcztEb+nUEL8yXQ3nqESejFc2IZ0G+f6sKbR+vsnbQDD4cQhNqci5sIjqfq7XImma6NdYyBLRr
--000000000000fabf5705f38891f9--

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B101661366
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 04:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233051AbjAHDEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 22:04:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234482AbjAHDDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 22:03:01 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9375C3AB08
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 19:02:32 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id k19so3803270pfg.11
        for <netdev@vger.kernel.org>; Sat, 07 Jan 2023 19:02:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=L+idUCg61eq8bhO/eDcLBPpvLjUJqiN79LCFSk33kIM=;
        b=emmDB85+V1WUAj0FbTr21tAmGQ2keGIncujQ9rTbZzzcibRuDbHOx2u8gxMrrCXkCl
         aMzQ3XgKeBr/zk5Q+ES5feDFb/vmso6+O35mcj0iwmOf230bK9LqnpisXv2t3T9zAzx1
         SeAZAFkRjAt6O/Jwgr/LoI7JYxg3cJ2zTQg+8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L+idUCg61eq8bhO/eDcLBPpvLjUJqiN79LCFSk33kIM=;
        b=uKufhI4EL4cvuxAdvV13ahXRn/Bj4VySQr+daDRvJeXATClrMXq/8JykCCbfVDMXQA
         /tQn6y4rUuLZdAjA/j4vXVzeoaMCAhsQhQ1s08rZU+n/YVhypO6fpalIEMoBw8cLcpHQ
         WkmeLlBK6m6S0pPoxolz4g4+ZVy/avpHhUVg5IFftw77xqsBUYutW5MXZb4/pzY++ktU
         kwyn/hNQmXvrMrfot/rwzkXFIJVurC9+lnZtXW+pRReP8w+HyJLIITw+giqApc3JUyh3
         Vpr4i7FJ8D+UNwN6K/b/FW+Fl67/ilNheKZw3vb/GTo6vp0/00PyJVftVhrZLeCx5uRC
         4QWg==
X-Gm-Message-State: AFqh2kqkrofDNhZp0bZMOj7t+hKVp056gB78KjPz0TvXHwmiHBizXATr
        kSAI10u/JBFnCvekbdnKa3cgpA==
X-Google-Smtp-Source: AMrXdXtszFRLjneOqceQ+p1DHfC6AFY9bdaqqPI+ldTnirE8cfYPekEciVIMPEclraOtmMI32DsnRQ==
X-Received: by 2002:a62:1d96:0:b0:575:e8c5:eb14 with SMTP id d144-20020a621d96000000b00575e8c5eb14mr58772429pfd.18.1673146951630;
        Sat, 07 Jan 2023 19:02:31 -0800 (PST)
Received: from localhost.localdomain ([2605:a601:a780:1400:1caf:227a:5e9d:33c3])
        by smtp.gmail.com with ESMTPSA id 69-20020a621748000000b005810a54fdefsm3452148pfx.114.2023.01.07.19.02.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Jan 2023 19:02:31 -0800 (PST)
From:   Ajit Khaparde <ajit.khaparde@broadcom.com>
To:     ajit.khaparde@broadcom.com
Cc:     andrew.gospodarek@broadcom.com, davem@davemloft.net,
        edumazet@google.com, jgg@ziepe.ca, kuba@kernel.org,
        leon@kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, michael.chan@broadcom.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        selvin.xavier@broadcom.com, Leon Romanovsky <leonro@nvidia.com>
Subject: [PATCH 8/8] bnxt_en: Remove runtime interrupt vector allocation
Date:   Sat,  7 Jan 2023 19:02:08 -0800
Message-Id: <20230108030208.26390-9-ajit.khaparde@broadcom.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20230108030208.26390-1-ajit.khaparde@broadcom.com>
References: <20230108030208.26390-1-ajit.khaparde@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000bdb55a05f1b7e1c9"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000bdb55a05f1b7e1c9
Content-Transfer-Encoding: 8bit

Modified the bnxt_en code to create and pre-configure RDMA devices
with the right MSI-X vector count for the ROCE driver to use.
This is to align the ROCE driver to the auxiliary device model which
will simply bind the driver without getting into PCI-related handling.
All PCI-related logic will now be in the bnxt_en driver.

Suggested-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Ajit Khaparde <ajit.khaparde@broadcom.com>
---
 drivers/infiniband/hw/bnxt_re/bnxt_re.h       |   1 -
 drivers/infiniband/hw/bnxt_re/main.c          |  48 ++-----
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c | 126 ++++--------------
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h |   7 +-
 4 files changed, 45 insertions(+), 137 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/bnxt_re.h b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
index b0465c8d229a..5a2baf49ecaa 100644
--- a/drivers/infiniband/hw/bnxt_re/bnxt_re.h
+++ b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
@@ -129,7 +129,6 @@ struct bnxt_re_dev {
 	unsigned int			version, major, minor;
 	struct bnxt_qplib_chip_ctx	*chip_ctx;
 	struct bnxt_en_dev		*en_dev;
-	struct bnxt_msix_entry		msix_entries[BNXT_RE_MAX_MSIX];
 	int				num_msix;
 
 	int				id;
diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index b287c3ba9352..8d991fa184ae 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -262,7 +262,7 @@ static void bnxt_re_stop_irq(void *handle)
 static void bnxt_re_start_irq(void *handle, struct bnxt_msix_entry *ent)
 {
 	struct bnxt_re_dev *rdev = (struct bnxt_re_dev *)handle;
-	struct bnxt_msix_entry *msix_ent = rdev->msix_entries;
+	struct bnxt_msix_entry *msix_ent = rdev->en_dev->msix_entries;
 	struct bnxt_qplib_rcfw *rcfw = &rdev->rcfw;
 	struct bnxt_qplib_nq *nq;
 	int indx, rc;
@@ -281,7 +281,7 @@ static void bnxt_re_start_irq(void *handle, struct bnxt_msix_entry *ent)
 	 * in device sctructure.
 	 */
 	for (indx = 0; indx < rdev->num_msix; indx++)
-		rdev->msix_entries[indx].vector = ent[indx].vector;
+		rdev->en_dev->msix_entries[indx].vector = ent[indx].vector;
 
 	bnxt_qplib_rcfw_start_irq(rcfw, msix_ent[BNXT_RE_AEQ_IDX].vector,
 				  false);
@@ -315,32 +315,6 @@ static int bnxt_re_register_netdev(struct bnxt_re_dev *rdev)
 	return rc;
 }
 
-static int bnxt_re_request_msix(struct bnxt_re_dev *rdev)
-{
-	int rc = 0, num_msix_want = BNXT_RE_MAX_MSIX, num_msix_got;
-	struct bnxt_en_dev *en_dev;
-
-	en_dev = rdev->en_dev;
-
-	num_msix_want = min_t(u32, BNXT_RE_MAX_MSIX, num_online_cpus());
-
-	num_msix_got = bnxt_req_msix_vecs(en_dev,
-					  rdev->msix_entries,
-					  num_msix_want);
-	if (num_msix_got < BNXT_RE_MIN_MSIX) {
-		rc = -EINVAL;
-		goto done;
-	}
-	if (num_msix_got != num_msix_want) {
-		ibdev_warn(&rdev->ibdev,
-			   "Requested %d MSI-X vectors, got %d\n",
-			   num_msix_want, num_msix_got);
-	}
-	rdev->num_msix = num_msix_got;
-done:
-	return rc;
-}
-
 static void bnxt_re_init_hwrm_hdr(struct bnxt_re_dev *rdev, struct input *hdr,
 				  u16 opcd, u16 crid, u16 trid)
 {
@@ -785,7 +759,7 @@ static u32 bnxt_re_get_nqdb_offset(struct bnxt_re_dev *rdev, u16 indx)
 	return bnxt_qplib_is_chip_gen_p5(rdev->chip_ctx) ?
 		(rdev->is_virtfn ? BNXT_RE_GEN_P5_VF_NQ_DB :
 				   BNXT_RE_GEN_P5_PF_NQ_DB) :
-				   rdev->msix_entries[indx].db_offset;
+				   rdev->en_dev->msix_entries[indx].db_offset;
 }
 
 static void bnxt_re_cleanup_res(struct bnxt_re_dev *rdev)
@@ -810,7 +784,7 @@ static int bnxt_re_init_res(struct bnxt_re_dev *rdev)
 	for (i = 1; i < rdev->num_msix ; i++) {
 		db_offt = bnxt_re_get_nqdb_offset(rdev, i);
 		rc = bnxt_qplib_enable_nq(rdev->en_dev->pdev, &rdev->nq[i - 1],
-					  i - 1, rdev->msix_entries[i].vector,
+					  i - 1, rdev->en_dev->msix_entries[i].vector,
 					  db_offt, &bnxt_re_cqn_handler,
 					  &bnxt_re_srqn_handler);
 		if (rc) {
@@ -897,7 +871,7 @@ static int bnxt_re_alloc_res(struct bnxt_re_dev *rdev)
 		rattr.type = type;
 		rattr.mode = RING_ALLOC_REQ_INT_MODE_MSIX;
 		rattr.depth = BNXT_QPLIB_NQE_MAX_CNT - 1;
-		rattr.lrid = rdev->msix_entries[i + 1].ring_idx;
+		rattr.lrid = rdev->en_dev->msix_entries[i + 1].ring_idx;
 		rc = bnxt_re_net_ring_alloc(rdev, &rattr, &nq->ring_id);
 		if (rc) {
 			ibdev_err(&rdev->ibdev,
@@ -1217,7 +1191,7 @@ static void bnxt_re_dev_uninit(struct bnxt_re_dev *rdev)
 		bnxt_qplib_free_rcfw_channel(&rdev->rcfw);
 	}
 	if (test_and_clear_bit(BNXT_RE_FLAG_GOT_MSIX, &rdev->flags))
-		bnxt_free_msix_vecs(rdev->en_dev);
+		rdev->num_msix = 0;
 
 	bnxt_re_destroy_chip_ctx(rdev);
 	if (test_and_clear_bit(BNXT_RE_FLAG_NETDEV_REGISTERED, &rdev->flags))
@@ -1262,13 +1236,15 @@ static int bnxt_re_dev_init(struct bnxt_re_dev *rdev, u8 wqe_mode)
 	/* Check whether VF or PF */
 	bnxt_re_get_sriov_func_type(rdev);
 
-	rc = bnxt_re_request_msix(rdev);
-	if (rc) {
+	if (!rdev->en_dev->ulp_tbl->msix_requested) {
 		ibdev_err(&rdev->ibdev,
 			  "Failed to get MSI-X vectors: %#x\n", rc);
 		rc = -EINVAL;
 		goto fail;
 	}
+	ibdev_dbg(&rdev->ibdev, "Got %d MSI-X vectors\n",
+		  rdev->en_dev->ulp_tbl->msix_requested);
+	rdev->num_msix = rdev->en_dev->ulp_tbl->msix_requested;
 	set_bit(BNXT_RE_FLAG_GOT_MSIX, &rdev->flags);
 
 	bnxt_re_query_hwrm_intf_version(rdev);
@@ -1292,14 +1268,14 @@ static int bnxt_re_dev_init(struct bnxt_re_dev *rdev, u8 wqe_mode)
 	rattr.type = type;
 	rattr.mode = RING_ALLOC_REQ_INT_MODE_MSIX;
 	rattr.depth = BNXT_QPLIB_CREQE_MAX_CNT - 1;
-	rattr.lrid = rdev->msix_entries[BNXT_RE_AEQ_IDX].ring_idx;
+	rattr.lrid = rdev->en_dev->msix_entries[BNXT_RE_AEQ_IDX].ring_idx;
 	rc = bnxt_re_net_ring_alloc(rdev, &rattr, &creq->ring_id);
 	if (rc) {
 		ibdev_err(&rdev->ibdev, "Failed to allocate CREQ: %#x\n", rc);
 		goto free_rcfw;
 	}
 	db_offt = bnxt_re_get_nqdb_offset(rdev, BNXT_RE_AEQ_IDX);
-	vid = rdev->msix_entries[BNXT_RE_AEQ_IDX].vector;
+	vid = rdev->en_dev->msix_entries[BNXT_RE_AEQ_IDX].vector;
 	rc = bnxt_qplib_enable_rcfw_channel(&rdev->rcfw,
 					    vid, db_offt, rdev->is_virtfn,
 					    &bnxt_re_aeq_handler);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
index 57efa4ebc93a..be1130ff7394 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
@@ -42,17 +42,18 @@ int bnxt_register_dev(struct bnxt_en_dev *edev,
 	    bp->cp_nr_rings == max_stat_ctxs)
 		return -ENOMEM;
 
-	ulp = kzalloc(sizeof(*ulp), GFP_KERNEL);
+	ulp = edev->ulp_tbl;
 	if (!ulp)
 		return -ENOMEM;
 
-	edev->ulp_tbl = ulp;
 	ulp->handle = handle;
 	rcu_assign_pointer(ulp->ulp_ops, ulp_ops);
 
 	if (test_bit(BNXT_STATE_OPEN, &bp->state))
 		bnxt_hwrm_vnic_cfg(bp, 0);
 
+	bnxt_fill_msix_vecs(bp, bp->edev->msix_entries);
+	edev->flags |= BNXT_EN_FLAG_MSIX_REQUESTED;
 	return 0;
 }
 EXPORT_SYMBOL(bnxt_register_dev);
@@ -66,7 +67,7 @@ void bnxt_unregister_dev(struct bnxt_en_dev *edev)
 
 	ulp = edev->ulp_tbl;
 	if (ulp->msix_requested)
-		bnxt_free_msix_vecs(edev);
+		edev->flags &= ~BNXT_EN_FLAG_MSIX_REQUESTED;
 
 	if (ulp->max_async_event_id)
 		bnxt_hwrm_func_drv_rgtr(bp, NULL, 0, true);
@@ -79,17 +80,19 @@ void bnxt_unregister_dev(struct bnxt_en_dev *edev)
 		msleep(100);
 		i++;
 	}
-	kfree(ulp);
-	edev->ulp_tbl = NULL;
 	return;
 }
 EXPORT_SYMBOL(bnxt_unregister_dev);
 
-static void bnxt_fill_msix_vecs(struct bnxt *bp, struct bnxt_msix_entry *ent)
+void bnxt_fill_msix_vecs(struct bnxt *bp, struct bnxt_msix_entry *ent)
 {
 	struct bnxt_en_dev *edev = bp->edev;
 	int num_msix, idx, i;
 
+	if (!edev->ulp_tbl->msix_requested) {
+		netdev_warn(bp->dev, "Requested MSI-X vectors insufficient\n");
+		return;
+	}
 	num_msix = edev->ulp_tbl->msix_requested;
 	idx = edev->ulp_tbl->msix_base;
 	for (i = 0; i < num_msix; i++) {
@@ -105,100 +108,13 @@ static void bnxt_fill_msix_vecs(struct bnxt *bp, struct bnxt_msix_entry *ent)
 	}
 }
 
-int bnxt_req_msix_vecs(struct bnxt_en_dev *edev,
-			      struct bnxt_msix_entry *ent,
-			      int num_msix)
-{
-	struct net_device *dev = edev->net;
-	struct bnxt *bp = netdev_priv(dev);
-	struct bnxt_hw_resc *hw_resc;
-	int max_idx, max_cp_rings;
-	int avail_msix, idx;
-	int total_vecs;
-	int rc = 0;
-
-	if (!(bp->flags & BNXT_FLAG_USING_MSIX))
-		return -ENODEV;
-
-	if (edev->ulp_tbl->msix_requested)
-		return -EAGAIN;
-
-	max_cp_rings = bnxt_get_max_func_cp_rings(bp);
-	avail_msix = bnxt_get_avail_msix(bp, num_msix);
-	if (!avail_msix)
-		return -ENOMEM;
-	if (avail_msix > num_msix)
-		avail_msix = num_msix;
-
-	if (BNXT_NEW_RM(bp)) {
-		idx = bp->cp_nr_rings;
-	} else {
-		max_idx = min_t(int, bp->total_irqs, max_cp_rings);
-		idx = max_idx - avail_msix;
-	}
-
-	edev->ulp_tbl->msix_base = idx;
-	edev->ulp_tbl->msix_requested = avail_msix;
-	hw_resc = &bp->hw_resc;
-	total_vecs = idx + avail_msix;
-	if (bp->total_irqs < total_vecs ||
-	    (BNXT_NEW_RM(bp) && hw_resc->resv_irqs < total_vecs)) {
-		if (netif_running(dev)) {
-			rtnl_lock();
-			bnxt_close_nic(bp, true, false);
-			rc = bnxt_open_nic(bp, true, false);
-			rtnl_unlock();
-		} else {
-			rc = bnxt_reserve_rings(bp, true);
-		}
-	}
-	if (rc) {
-		edev->ulp_tbl->msix_requested = 0;
-		return -EAGAIN;
-	}
-
-	if (BNXT_NEW_RM(bp)) {
-		int resv_msix;
-
-		resv_msix = hw_resc->resv_irqs - bp->cp_nr_rings;
-		avail_msix = min_t(int, resv_msix, avail_msix);
-		edev->ulp_tbl->msix_requested = avail_msix;
-	}
-	bnxt_fill_msix_vecs(bp, ent);
-	edev->flags |= BNXT_EN_FLAG_MSIX_REQUESTED;
-	return avail_msix;
-}
-EXPORT_SYMBOL(bnxt_req_msix_vecs);
-
-void bnxt_free_msix_vecs(struct bnxt_en_dev *edev)
-{
-	struct net_device *dev = edev->net;
-	struct bnxt *bp = netdev_priv(dev);
-
-	if (!(edev->flags & BNXT_EN_FLAG_MSIX_REQUESTED))
-		return;
-
-	edev->ulp_tbl->msix_requested = 0;
-	edev->flags &= ~BNXT_EN_FLAG_MSIX_REQUESTED;
-	if (netif_running(dev) && !(edev->flags & BNXT_EN_FLAG_ULP_STOPPED)) {
-		rtnl_lock();
-		bnxt_close_nic(bp, true, false);
-		bnxt_open_nic(bp, true, false);
-		rtnl_unlock();
-	}
-
-	return;
-}
-EXPORT_SYMBOL(bnxt_free_msix_vecs);
-
 int bnxt_get_ulp_msix_num(struct bnxt *bp)
 {
-	if (bnxt_ulp_registered(bp->edev)) {
-		struct bnxt_en_dev *edev = bp->edev;
+	u32 roce_msix = BNXT_VF(bp) ?
+			BNXT_MAX_VF_ROCE_MSIX : BNXT_MAX_ROCE_MSIX;
 
-		return edev->ulp_tbl->msix_requested;
-	}
-	return 0;
+	return ((bp->flags & BNXT_FLAG_ROCE_CAP) && bp->aux_dev ?
+		min_t(u32, roce_msix, num_online_cpus()) : 0);
 }
 
 int bnxt_get_ulp_msix_base(struct bnxt *bp)
@@ -457,6 +373,8 @@ void bnxt_aux_dev_release(struct device *dev)
 		container_of(dev, struct bnxt_aux_dev, aux_dev.dev);
 	struct bnxt *bp = netdev_priv(bnxt_adev->edev->net);
 
+	kfree(bnxt_adev->edev->ulp_tbl);
+	bnxt_adev->edev->ulp_tbl = NULL;
 	kfree(bnxt_adev->edev);
 	bnxt_adev->edev = NULL;
 	bp->edev = NULL;
@@ -480,6 +398,8 @@ static inline void bnxt_set_edev_info(struct bnxt_en_dev *edev, struct bnxt *bp)
 	edev->hw_ring_stats_size = bp->hw_ring_stats_size;
 	edev->pf_port_id = bp->pf.port_id;
 	edev->en_state = bp->state;
+
+	edev->ulp_tbl->msix_requested = bnxt_get_ulp_msix_num(bp);
 }
 
 int bnxt_rdma_aux_device_add(struct bnxt *bp)
@@ -487,6 +407,7 @@ int bnxt_rdma_aux_device_add(struct bnxt *bp)
 	struct bnxt_aux_dev *bnxt_adev = bp->aux_dev;
 	struct bnxt_en_dev *edev = bnxt_adev->edev;
 	struct auxiliary_device *aux_dev;
+	struct bnxt_ulp *ulp;
 	int ret;
 
 	edev = kzalloc(sizeof(*edev), GFP_KERNEL);
@@ -495,6 +416,14 @@ int bnxt_rdma_aux_device_add(struct bnxt *bp)
 		goto cleanup_edev_failure;
 	}
 
+	ulp = kzalloc(sizeof(*ulp), GFP_KERNEL);
+	if (!ulp) {
+		ret = -ENOMEM;
+		goto cleanup_ulp_failure;
+	}
+
+	edev->ulp_tbl = ulp;
+
 	aux_dev = &bnxt_adev->aux_dev;
 	aux_dev->id = bnxt_adev->id;
 	aux_dev->name = "rdma";
@@ -518,6 +447,9 @@ int bnxt_rdma_aux_device_add(struct bnxt *bp)
 cleanup_add_failure:
 	auxiliary_device_uninit(aux_dev);
 cleanup_init_failure:
+	kfree(ulp);
+	bp->edev->ulp_tbl = NULL;
+cleanup_ulp_failure:
 	kfree(edev);
 	bp->edev = NULL;
 cleanup_edev_failure:
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
index 1e7e32a4ab19..d4d36cf38ed2 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
@@ -15,6 +15,8 @@
 
 #define BNXT_MIN_ROCE_CP_RINGS	2
 #define BNXT_MIN_ROCE_STAT_CTXS	1
+#define BNXT_MAX_ROCE_MSIX	9
+#define BNXT_MAX_VF_ROCE_MSIX	2
 
 struct hwrm_async_event_cmpl;
 struct bnxt_aux_dev;
@@ -52,6 +54,7 @@ struct bnxt_ulp {
 struct bnxt_en_dev {
 	struct net_device *net;
 	struct pci_dev *pdev;
+	struct bnxt_msix_entry			msix_entries[BNXT_MAX_ROCE_MSIX];
 	u32 flags;
 	#define BNXT_EN_FLAG_ROCEV1_CAP		0x1
 	#define BNXT_EN_FLAG_ROCEV2_CAP		0x2
@@ -104,10 +107,8 @@ void bnxt_aux_dev_free(struct bnxt *bp);
 int bnxt_register_dev(struct bnxt_en_dev *edev, struct bnxt_ulp_ops *ulp_ops,
 		      void *handle);
 void bnxt_unregister_dev(struct bnxt_en_dev *edev);
-int bnxt_req_msix_vecs(struct bnxt_en_dev *edev, struct bnxt_msix_entry *ent,
-		       int num_msix);
-void bnxt_free_msix_vecs(struct bnxt_en_dev *edev);
 int bnxt_send_msg(struct bnxt_en_dev *edev, struct bnxt_fw_msg *fw_msg);
 int bnxt_register_async_events(struct bnxt_en_dev *edev,
 			       unsigned long *events_bmap, u16 max_id);
+void bnxt_fill_msix_vecs(struct bnxt *bp, struct bnxt_msix_entry *ent);
 #endif
-- 
2.37.1 (Apple Git-137.1)


--000000000000bdb55a05f1b7e1c9
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
4nZK0WWosNswDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIAIwNoDUHPmt5MGXsu3A
E/22/o0P97+jhXXxNB1D91L9MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIzMDEwODAzMDIzMlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQBj/d8t+5SpPJ0XDey9Xflaq2yZYTe0BrpuwX0t
JXwWgvDPRhlmqYgwQSFl0zZuVvS8/Uhf1fvd4nprb5voOIFZKax88hfMaIcOIIihoKJjUMqzq9SD
FulMNULNSYb6+WO8bttiNtYBjj22NGu2XJ4nwSnmuPQmCh4c50vdKp8BkzNNgDGB0zLzNPiw0JEK
8+D5HbxdSV5UbSaJa3rjYpuIvmR/Qu7gZog0+AfGLMCINN3xainq2oJfBPPNk7mPeoIvzPipB8IB
6ymZDyRW2lztr+mGhGdNID9u7TkBNd3huqGmCWiCuFvv7jofgnp8zxABrr7DOTolP7SlwcV6g8Ud
--000000000000bdb55a05f1b7e1c9--

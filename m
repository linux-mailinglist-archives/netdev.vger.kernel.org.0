Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A578966BEBD
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 14:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231556AbjAPNHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 08:07:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231287AbjAPNG6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 08:06:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 920897EE1;
        Mon, 16 Jan 2023 05:06:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 203C460F9B;
        Mon, 16 Jan 2023 13:06:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A0EC433F0;
        Mon, 16 Jan 2023 13:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673874415;
        bh=3onQ/rBBcurHQvS6iIFYjN6t3VLGjjleEvgmJokrbgA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NUJkHjzulOFJcMkWyEr4QZGeeBrMIcy+EHSm7ZNEzgiWesNYaqRow8CXR3AlkAQ8i
         dJvjT8FNvlrkqVq9fs5JF1v5O8p2AJXQrGk7x8i+newd1L8Qc7oAM4Y8faxFFuMm3I
         qqHPzLr8ApM9FLcq0iPB+rYjUNNpKdpQ1pstknMWu7AfW0R7Y8HpZXx4Em51+CPR8b
         ZB3Fbt5NLbLtolW/kHQfgw1BIVr7TB3wHpobxPSgBfk55jPas04n8Oz1TpsI+e0FKC
         rLnD8WKyrb3HBRB++nAeBaQIanu1gD4gW6dZCc76bECmRRIMEPgYDKKGHewU0YMchi
         fee5Llt2FnYWA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Israel Rukshin <israelr@nvidia.com>,
        Bryan Tan <bryantan@vmware.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, Jens Axboe <axboe@fb.com>,
        Keith Busch <kbusch@kernel.org>, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vishnu Dasa <vdasa@vmware.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: [PATCH rdma-next 13/13] nvme-rdma: Add inline encryption support
Date:   Mon, 16 Jan 2023 15:06:00 +0200
Message-Id: <ab0817fac98d498372fd32e950d1ca6e157b575d.1673873422.git.leon@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1673873422.git.leon@kernel.org>
References: <cover.1673873422.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Israel Rukshin <israelr@nvidia.com>

Add support for inline encryption/decryption of the data at a
similar way like integrity is used via a unique Mkey. The feature
is enabled only when CONFIG_BLK_INLINE_ENCRYPTION is configured.
There is no special configuration to enable crypto at nvme modules.

The code was tested with fscrypt and BF-3 HW, which had more than
50% CPU utilization improvement at 64K and bigger I/O sizes when
comparing to the SW only solution at this case.

Signed-off-by: Israel Rukshin <israelr@nvidia.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
---
 drivers/nvme/host/rdma.c | 236 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 232 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index bbad26b82b56..8bea38eb976f 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -40,6 +40,10 @@
 #define NVME_RDMA_METADATA_SGL_SIZE \
 	(sizeof(struct scatterlist) * NVME_INLINE_METADATA_SG_CNT)
 
+#define NVME_RDMA_NUM_CRYPTO_KEYSLOTS	(32U)
+/* Bitmask for 512B and 4K data unit sizes */
+#define NVME_RDMA_DATA_UNIT_SIZES	(512U | 4096U)
+
 struct nvme_rdma_device {
 	struct ib_device	*dev;
 	struct ib_pd		*pd;
@@ -75,6 +79,7 @@ struct nvme_rdma_request {
 	struct nvme_rdma_sgl	data_sgl;
 	struct nvme_rdma_sgl	*metadata_sgl;
 	bool			use_sig_mr;
+	bool			use_crypto;
 };
 
 enum nvme_rdma_queue_flags {
@@ -97,6 +102,7 @@ struct nvme_rdma_queue {
 	int			cm_error;
 	struct completion	cm_done;
 	bool			pi_support;
+	bool			crypto_support;
 	int			cq_size;
 	struct mutex		queue_lock;
 };
@@ -126,6 +132,8 @@ struct nvme_rdma_ctrl {
 	struct nvme_ctrl	ctrl;
 	bool			use_inline_data;
 	u32			io_queues[HCTX_MAX_TYPES];
+
+	struct ib_dek		*dek[NVME_RDMA_NUM_CRYPTO_KEYSLOTS];
 };
 
 static inline struct nvme_rdma_ctrl *to_rdma_ctrl(struct nvme_ctrl *ctrl)
@@ -275,6 +283,8 @@ static int nvme_rdma_create_qp(struct nvme_rdma_queue *queue, const int factor)
 	init_attr.recv_cq = queue->ib_cq;
 	if (queue->pi_support)
 		init_attr.create_flags |= IB_QP_CREATE_INTEGRITY_EN;
+	if (queue->crypto_support)
+		init_attr.create_flags |= IB_QP_CREATE_CRYPTO_EN;
 	init_attr.qp_context = queue;
 
 	ret = rdma_create_qp(queue->cm_id, dev->pd, &init_attr);
@@ -364,6 +374,77 @@ static int nvme_rdma_dev_get(struct nvme_rdma_device *dev)
 	return kref_get_unless_zero(&dev->ref);
 }
 
+static int nvme_rdma_crypto_keyslot_program(struct blk_crypto_profile *profile,
+					    const struct blk_crypto_key *key,
+					    unsigned int slot)
+{
+	struct nvme_ctrl *nctrl =
+		container_of(profile, struct nvme_ctrl, crypto_profile);
+	struct nvme_rdma_ctrl *ctrl = to_rdma_ctrl(nctrl);
+	struct ib_dek_attr dek_attr = { };
+	int err = 0;
+
+	if (slot > NVME_RDMA_NUM_CRYPTO_KEYSLOTS) {
+		dev_err(nctrl->device, "slot index reached the limit %d/%d",
+			slot, NVME_RDMA_NUM_CRYPTO_KEYSLOTS);
+		return -EOPNOTSUPP;
+	}
+
+	if (WARN_ON_ONCE(key->crypto_cfg.crypto_mode !=
+			 BLK_ENCRYPTION_MODE_AES_256_XTS))
+		return -EOPNOTSUPP;
+
+	if (ctrl->dek[slot]) {
+		dev_dbg(nctrl->device, "slot %d is taken, free DEK ID %d\n",
+			slot, ctrl->dek[slot]->id);
+		ib_destroy_dek(ctrl->dek[slot]);
+	}
+
+	dek_attr.key_blob = key->raw;
+	dek_attr.key_blob_size = key->size;
+	dek_attr.key_type = IB_CRYPTO_KEY_TYPE_AES_XTS;
+	ctrl->dek[slot] = ib_create_dek(ctrl->device->pd, &dek_attr);
+	if (IS_ERR(ctrl->dek[slot])) {
+		err = PTR_ERR(ctrl->dek[slot]);
+		dev_err(nctrl->device,
+			"failed to create DEK at slot %d, err %d\n", slot, err);
+		ctrl->dek[slot] = NULL;
+	} else {
+		dev_dbg(nctrl->device, "DEK ID %d was created at slot %d\n",
+			ctrl->dek[slot]->id, slot);
+	}
+
+	return err;
+}
+
+static int nvme_rdma_crypto_keyslot_evict(struct blk_crypto_profile *profile,
+					  const struct blk_crypto_key *key,
+					  unsigned int slot)
+{
+	struct nvme_ctrl *nctrl =
+		container_of(profile, struct nvme_ctrl, crypto_profile);
+	struct nvme_rdma_ctrl *ctrl = to_rdma_ctrl(nctrl);
+
+	if (slot > NVME_RDMA_NUM_CRYPTO_KEYSLOTS) {
+		dev_err(nctrl->device, "slot index reached the limit %d/%d\n",
+			slot, NVME_RDMA_NUM_CRYPTO_KEYSLOTS);
+		return -EOPNOTSUPP;
+	}
+
+	if (!ctrl->dek[slot]) {
+		dev_err(nctrl->device, "slot %d is empty\n", slot);
+		return -EINVAL;
+	}
+
+	dev_dbg(nctrl->device, "Destroy DEK ID %d slot %d\n",
+		ctrl->dek[slot]->id, slot);
+
+	ib_destroy_dek(ctrl->dek[slot]);
+	ctrl->dek[slot] = NULL;
+
+	return 0;
+}
+
 static struct nvme_rdma_device *
 nvme_rdma_find_get_device(struct rdma_cm_id *cm_id)
 {
@@ -430,6 +511,8 @@ static void nvme_rdma_destroy_queue_ib(struct nvme_rdma_queue *queue)
 	dev = queue->device;
 	ibdev = dev->dev;
 
+	if (queue->crypto_support)
+		ib_mr_pool_destroy(queue->qp, &queue->qp->crypto_mrs);
 	if (queue->pi_support)
 		ib_mr_pool_destroy(queue->qp, &queue->qp->sig_mrs);
 	ib_mr_pool_destroy(queue->qp, &queue->qp->rdma_mrs);
@@ -553,10 +636,24 @@ static int nvme_rdma_create_queue_ib(struct nvme_rdma_queue *queue)
 		}
 	}
 
+	if (queue->crypto_support) {
+		ret = ib_mr_pool_init(queue->qp, &queue->qp->crypto_mrs,
+				      queue->queue_size, IB_MR_TYPE_CRYPTO,
+				      pages_per_mr, 0);
+		if (ret) {
+			dev_err(queue->ctrl->ctrl.device,
+				"failed to initialize crypto MR pool sized %d for QID %d\n",
+				queue->queue_size, nvme_rdma_queue_idx(queue));
+			goto out_destroy_sig_mr_pool;
+		}
+	}
+
 	set_bit(NVME_RDMA_Q_TR_READY, &queue->flags);
 
 	return 0;
 
+out_destroy_sig_mr_pool:
+	ib_mr_pool_destroy(queue->qp, &queue->qp->sig_mrs);
 out_destroy_mr_pool:
 	ib_mr_pool_destroy(queue->qp, &queue->qp->rdma_mrs);
 out_destroy_ring:
@@ -585,6 +682,9 @@ static int nvme_rdma_alloc_queue(struct nvme_rdma_ctrl *ctrl,
 		queue->pi_support = true;
 	else
 		queue->pi_support = false;
+
+	queue->crypto_support = idx && ctrl->ctrl.crypto_enable;
+
 	init_completion(&queue->cm_done);
 
 	if (idx > 0)
@@ -805,15 +905,109 @@ static int nvme_rdma_alloc_tag_set(struct nvme_ctrl *ctrl)
 
 static void nvme_rdma_destroy_admin_queue(struct nvme_rdma_ctrl *ctrl)
 {
+	unsigned int i;
+
 	if (ctrl->async_event_sqe.data) {
 		cancel_work_sync(&ctrl->ctrl.async_event_work);
 		nvme_rdma_free_qe(ctrl->device->dev, &ctrl->async_event_sqe,
 				sizeof(struct nvme_command), DMA_TO_DEVICE);
 		ctrl->async_event_sqe.data = NULL;
 	}
+
+	for (i = 0; i < NVME_RDMA_NUM_CRYPTO_KEYSLOTS; i++) {
+		if (!ctrl->dek[i])
+			continue;
+		ib_destroy_dek(ctrl->dek[i]);
+		ctrl->dek[i] = NULL;
+	}
+
 	nvme_rdma_free_queue(&ctrl->queues[0]);
 }
 
+#ifdef CONFIG_BLK_INLINE_ENCRYPTION
+static const struct blk_crypto_ll_ops nvme_rdma_crypto_ops = {
+	.keyslot_program	= nvme_rdma_crypto_keyslot_program,
+	.keyslot_evict		= nvme_rdma_crypto_keyslot_evict,
+};
+
+static int nvme_rdma_crypto_profile_init(struct nvme_rdma_ctrl *ctrl, bool new)
+{
+	struct blk_crypto_profile *profile = &ctrl->ctrl.crypto_profile;
+	int ret;
+
+	if (!new) {
+		blk_crypto_reprogram_all_keys(profile);
+		return 0;
+	}
+
+	ret = devm_blk_crypto_profile_init(ctrl->ctrl.device, profile,
+					   NVME_RDMA_NUM_CRYPTO_KEYSLOTS);
+	if (ret) {
+		dev_err(ctrl->ctrl.device,
+			"devm_blk_crypto_profile_init failed err %d\n", ret);
+		return ret;
+	}
+
+	profile->ll_ops = nvme_rdma_crypto_ops;
+	profile->dev = ctrl->ctrl.device;
+	profile->max_dun_bytes_supported = IB_CRYPTO_XTS_TWEAK_MAX_SIZE;
+	profile->modes_supported[BLK_ENCRYPTION_MODE_AES_256_XTS] =
+		NVME_RDMA_DATA_UNIT_SIZES;
+
+	return 0;
+}
+
+static void nvme_rdma_set_crypto_attrs(struct ib_crypto_attrs *crypto_attrs,
+		struct nvme_rdma_queue *queue, struct nvme_rdma_request *req)
+{
+	struct request *rq = blk_mq_rq_from_pdu(req);
+	u32 slot_idx = blk_crypto_keyslot_index(rq->crypt_keyslot);
+
+	memset(crypto_attrs, 0, sizeof(*crypto_attrs));
+
+	crypto_attrs->encrypt_domain = IB_CRYPTO_ENCRYPTED_WIRE_DOMAIN;
+	crypto_attrs->encrypt_standard = IB_CRYPTO_AES_XTS;
+	crypto_attrs->data_unit_size =
+		rq->crypt_ctx->bc_key->crypto_cfg.data_unit_size;
+	crypto_attrs->dek = queue->ctrl->dek[slot_idx]->id;
+	memcpy(crypto_attrs->xts_init_tweak, rq->crypt_ctx->bc_dun,
+	       sizeof(crypto_attrs->xts_init_tweak));
+}
+
+static int nvme_rdma_fill_crypto_caps(struct nvme_rdma_ctrl *ctrl, bool new)
+{
+	struct ib_crypto_caps *caps = &ctrl->device->dev->attrs.crypto_caps;
+
+	if (caps->crypto_engines & IB_CRYPTO_ENGINES_CAP_AES_XTS) {
+		ctrl->ctrl.crypto_enable = true;
+		return 0;
+	}
+
+	if (!new && ctrl->ctrl.crypto_enable) {
+		dev_err(ctrl->ctrl.device, "Must support crypto!\n");
+		return -EOPNOTSUPP;
+	}
+	ctrl->ctrl.crypto_enable = false;
+
+	return 0;
+}
+#else
+static int nvme_rdma_crypto_profile_init(struct nvme_rdma_ctrl *ctrl, bool new)
+{
+	return -EOPNOTSUPP;
+}
+
+static void nvme_rdma_set_crypto_attrs(struct ib_crypto_attrs *crypto_attrs,
+		struct nvme_rdma_queue *queue, struct nvme_rdma_request *req)
+{
+}
+
+static int nvme_rdma_fill_crypto_caps(struct nvme_rdma_ctrl *ctrl, bool new)
+{
+	return 0;
+}
+#endif /* CONFIG_BLK_INLINE_ENCRYPTION */
+
 static int nvme_rdma_configure_admin_queue(struct nvme_rdma_ctrl *ctrl,
 		bool new)
 {
@@ -835,6 +1029,10 @@ static int nvme_rdma_configure_admin_queue(struct nvme_rdma_ctrl *ctrl,
 	ctrl->max_fr_pages = nvme_rdma_get_max_fr_pages(ctrl->device->dev,
 							pi_capable);
 
+	error = nvme_rdma_fill_crypto_caps(ctrl, new);
+	if (error)
+		goto out_free_queue;
+
 	/*
 	 * Bind the async event SQE DMA mapping to the admin queue lifetime.
 	 * It's safe, since any chage in the underlying RDMA device will issue
@@ -870,6 +1068,12 @@ static int nvme_rdma_configure_admin_queue(struct nvme_rdma_ctrl *ctrl,
 	else
 		ctrl->ctrl.max_integrity_segments = 0;
 
+	if (ctrl->ctrl.crypto_enable) {
+		error = nvme_rdma_crypto_profile_init(ctrl, new);
+		if (error)
+			goto out_quiesce_queue;
+	}
+
 	nvme_unquiesce_admin_queue(&ctrl->ctrl);
 
 	error = nvme_init_ctrl_finish(&ctrl->ctrl, false);
@@ -1268,6 +1472,8 @@ static void nvme_rdma_unmap_data(struct nvme_rdma_queue *queue,
 
 	if (req->use_sig_mr)
 		pool = &queue->qp->sig_mrs;
+	else if (req->use_crypto)
+		pool = &queue->qp->crypto_mrs;
 
 	if (req->mr) {
 		ib_mr_pool_put(queue->qp, pool, req->mr);
@@ -1331,9 +1537,13 @@ static int nvme_rdma_map_sg_fr(struct nvme_rdma_queue *queue,
 		int count)
 {
 	struct nvme_keyed_sgl_desc *sg = &c->common.dptr.ksgl;
+	struct list_head *pool = &queue->qp->rdma_mrs;
 	int nr;
 
-	req->mr = ib_mr_pool_get(queue->qp, &queue->qp->rdma_mrs);
+	if (req->use_crypto)
+		pool = &queue->qp->crypto_mrs;
+
+	req->mr = ib_mr_pool_get(queue->qp, pool);
 	if (WARN_ON_ONCE(!req->mr))
 		return -EAGAIN;
 
@@ -1344,18 +1554,24 @@ static int nvme_rdma_map_sg_fr(struct nvme_rdma_queue *queue,
 	nr = ib_map_mr_sg(req->mr, req->data_sgl.sg_table.sgl, count, NULL,
 			  SZ_4K);
 	if (unlikely(nr < count)) {
-		ib_mr_pool_put(queue->qp, &queue->qp->rdma_mrs, req->mr);
+		ib_mr_pool_put(queue->qp, pool, req->mr);
 		req->mr = NULL;
 		if (nr < 0)
 			return nr;
 		return -EINVAL;
 	}
 
+	if (req->use_crypto)
+		nvme_rdma_set_crypto_attrs(req->mr->crypto_attrs, queue, req);
+
 	ib_update_fast_reg_key(req->mr, ib_inc_rkey(req->mr->rkey));
 
 	req->reg_cqe.done = nvme_rdma_memreg_done;
 	memset(&req->reg_wr, 0, sizeof(req->reg_wr));
-	req->reg_wr.wr.opcode = IB_WR_REG_MR;
+	if (req->use_crypto)
+		req->reg_wr.wr.opcode = IB_WR_REG_MR_CRYPTO;
+	else
+		req->reg_wr.wr.opcode = IB_WR_REG_MR;
 	req->reg_wr.wr.wr_cqe = &req->reg_cqe;
 	req->reg_wr.wr.num_sge = 0;
 	req->reg_wr.mr = req->mr;
@@ -1571,7 +1787,7 @@ static int nvme_rdma_map_data(struct nvme_rdma_queue *queue,
 		goto out;
 	}
 
-	if (count <= dev->num_inline_segments) {
+	if (count <= dev->num_inline_segments && !req->use_crypto) {
 		if (rq_data_dir(rq) == WRITE && nvme_rdma_queue_idx(queue) &&
 		    queue->ctrl->use_inline_data &&
 		    blk_rq_payload_bytes(rq) <=
@@ -2052,6 +2268,18 @@ static blk_status_t nvme_rdma_queue_rq(struct blk_mq_hw_ctx *hctx,
 	else
 		req->use_sig_mr = false;
 
+#ifdef CONFIG_BLK_INLINE_ENCRYPTION
+	if (rq->crypt_ctx) {
+		if (WARN_ON_ONCE(!queue->crypto_support)) {
+			err = -EIO;
+			goto err;
+		}
+		req->use_crypto = true;
+	} else {
+		req->use_crypto = false;
+	}
+#endif
+
 	err = nvme_rdma_map_data(queue, rq, c);
 	if (unlikely(err < 0)) {
 		dev_err(queue->ctrl->ctrl.device,
-- 
2.39.0


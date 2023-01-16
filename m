Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8040F66BEB2
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 14:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231497AbjAPNHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 08:07:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231454AbjAPNGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 08:06:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F5674690;
        Mon, 16 Jan 2023 05:06:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F59B60F8A;
        Mon, 16 Jan 2023 13:06:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB33EC433D2;
        Mon, 16 Jan 2023 13:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673874386;
        bh=PHPfzcF12XN8XXrVZEoA/iEMhAWm5Si9T+rPS/xKCts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mZYTjnfg8+FBLPGRtA0+2CT/2NZiCZAPxlQotdBoQc+7iqOpGJ4kjallcHjbv/LR9
         0GhJFlb4ZWZMMxjFdWAx1XgKiNuBzq3s47KxCfkZiqMCbRqYpYfyakYufFMJEiSNHH
         MzmiRJfjtEmbBuchyPbd6TMJ4OC56i99jm/Q5h1zXjmoSFQqaGVkpJX5XUQKSHxbsz
         qhmjUCMBS+2IRBX2oNd07bmDxndH/+okE4/k8qxjKbE+dUT1dBdViz0tKlTyrldWB0
         Ug+Mhk9jzZJ8HkjQBVA0DZiOZafAu0dgraTV+13maJcQ0rKwe9SB2KBx62t0RnALe3
         l3OZXwnlWC/gg==
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
Subject: [PATCH rdma-next 06/13] RDMA/core: Introduce MR type for crypto operations
Date:   Mon, 16 Jan 2023 15:05:53 +0200
Message-Id: <5b8fadc00c0fcc0c0ba3a5dcc9e7b9012c6b5859.1673873422.git.leon@kernel.org>
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

Add crypto attributes for MKey. With those attributes, the device
can encrypt/decrypt data when transmitting from memory domain to wire
domain and when receiving data from wire domain to memory domain.

Signed-off-by: Israel Rukshin <israelr@nvidia.com>
Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
---
 drivers/infiniband/core/device.c  |  1 +
 drivers/infiniband/core/mr_pool.c |  2 ++
 drivers/infiniband/core/verbs.c   | 56 ++++++++++++++++++++++++++++++-
 include/rdma/crypto.h             | 43 ++++++++++++++++++++++++
 include/rdma/ib_verbs.h           |  7 ++++
 include/trace/events/rdma_core.h  | 33 ++++++++++++++++++
 6 files changed, 141 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index b2016725c3d8..d9e98fe92b3c 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -2599,6 +2599,7 @@ void ib_set_device_ops(struct ib_device *dev, const struct ib_device_ops *ops)
 	SET_DEVICE_OP(dev_ops, alloc_hw_device_stats);
 	SET_DEVICE_OP(dev_ops, alloc_hw_port_stats);
 	SET_DEVICE_OP(dev_ops, alloc_mr);
+	SET_DEVICE_OP(dev_ops, alloc_mr_crypto);
 	SET_DEVICE_OP(dev_ops, alloc_mr_integrity);
 	SET_DEVICE_OP(dev_ops, alloc_mw);
 	SET_DEVICE_OP(dev_ops, alloc_pd);
diff --git a/drivers/infiniband/core/mr_pool.c b/drivers/infiniband/core/mr_pool.c
index c0e2df128b34..d102cb4caefd 100644
--- a/drivers/infiniband/core/mr_pool.c
+++ b/drivers/infiniband/core/mr_pool.c
@@ -44,6 +44,8 @@ int ib_mr_pool_init(struct ib_qp *qp, struct list_head *list, int nr,
 		if (type == IB_MR_TYPE_INTEGRITY)
 			mr = ib_alloc_mr_integrity(qp->pd, max_num_sg,
 						   max_num_meta_sg);
+		else if (type == IB_MR_TYPE_CRYPTO)
+			mr = ib_alloc_mr_crypto(qp->pd, max_num_sg);
 		else
 			mr = ib_alloc_mr(qp->pd, type, max_num_sg);
 		if (IS_ERR(mr)) {
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 03633d706106..61473fee4b54 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -2179,6 +2179,7 @@ int ib_dereg_mr_user(struct ib_mr *mr, struct ib_udata *udata)
 	struct ib_pd *pd = mr->pd;
 	struct ib_dm *dm = mr->dm;
 	struct ib_sig_attrs *sig_attrs = mr->sig_attrs;
+	struct ib_crypto_attrs *crypto_attrs = mr->crypto_attrs;
 	int ret;
 
 	trace_mr_dereg(mr);
@@ -2189,6 +2190,7 @@ int ib_dereg_mr_user(struct ib_mr *mr, struct ib_udata *udata)
 		if (dm)
 			atomic_dec(&dm->usecnt);
 		kfree(sig_attrs);
+		kfree(crypto_attrs);
 	}
 
 	return ret;
@@ -2217,7 +2219,8 @@ struct ib_mr *ib_alloc_mr(struct ib_pd *pd, enum ib_mr_type mr_type,
 		goto out;
 	}
 
-	if (mr_type == IB_MR_TYPE_INTEGRITY) {
+	if (mr_type == IB_MR_TYPE_INTEGRITY ||
+	    mr_type == IB_MR_TYPE_CRYPTO) {
 		WARN_ON_ONCE(1);
 		mr = ERR_PTR(-EINVAL);
 		goto out;
@@ -2294,6 +2297,7 @@ struct ib_mr *ib_alloc_mr_integrity(struct ib_pd *pd,
 	mr->uobject = NULL;
 	atomic_inc(&pd->usecnt);
 	mr->need_inval = false;
+	mr->crypto_attrs = NULL;
 	mr->type = IB_MR_TYPE_INTEGRITY;
 	mr->sig_attrs = sig_attrs;
 
@@ -2306,6 +2310,56 @@ struct ib_mr *ib_alloc_mr_integrity(struct ib_pd *pd,
 }
 EXPORT_SYMBOL(ib_alloc_mr_integrity);
 
+/**
+ * ib_alloc_mr_crypto() - Allocates a crypto memory region
+ * @pd:                   protection domain associated with the region
+ * @max_num_sg:           maximum sg entries available for registration
+ *
+ * Notes:
+ * Memory registration page/sg lists must not exceed max_num_sg.
+ *
+ */
+struct ib_mr *ib_alloc_mr_crypto(struct ib_pd *pd, u32 max_num_sg)
+{
+	struct ib_mr *mr;
+	struct ib_crypto_attrs *crypto_attrs;
+
+	if (!pd->device->ops.alloc_mr_crypto) {
+		mr = ERR_PTR(-EOPNOTSUPP);
+		goto out;
+	}
+
+	crypto_attrs = kzalloc(sizeof(*crypto_attrs), GFP_KERNEL);
+	if (!crypto_attrs) {
+		mr = ERR_PTR(-ENOMEM);
+		goto out;
+	}
+
+	mr = pd->device->ops.alloc_mr_crypto(pd, max_num_sg);
+	if (IS_ERR(mr)) {
+		kfree(crypto_attrs);
+		goto out;
+	}
+
+	mr->device = pd->device;
+	mr->pd = pd;
+	mr->dm = NULL;
+	mr->uobject = NULL;
+	atomic_inc(&pd->usecnt);
+	mr->need_inval = false;
+	mr->sig_attrs = NULL;
+	mr->type = IB_MR_TYPE_CRYPTO;
+	mr->crypto_attrs = crypto_attrs;
+
+	rdma_restrack_new(&mr->res, RDMA_RESTRACK_MR);
+	rdma_restrack_parent_name(&mr->res, &pd->res);
+	rdma_restrack_add(&mr->res);
+out:
+	trace_mr_crypto_alloc(pd, max_num_sg, mr);
+	return mr;
+}
+EXPORT_SYMBOL(ib_alloc_mr_crypto);
+
 /**
  * ib_create_dek - Create a DEK (Data Encryption Key) associated with the
  * specific protection domain.
diff --git a/include/rdma/crypto.h b/include/rdma/crypto.h
index cdf287c94737..ba1c6576a8ba 100644
--- a/include/rdma/crypto.h
+++ b/include/rdma/crypto.h
@@ -34,6 +34,49 @@ struct ib_crypto_caps {
 	u32 max_num_deks;
 };
 
+/**
+ * enum ib_crypto_domain - Encryption domain
+ * According to the encryption domain and the data direction, the HW can
+ * conclude if need to encrypt or decrypt the data.
+ * @IB_CRYPTO_ENCRYPTED_WIRE_DOMAIN: encrypted data is in the wire domain.
+ * @IB_CRYPTO_ENCRYPTED_MEM_DOMAIN: encrypted data is in the memory domain.
+ */
+enum ib_crypto_domain {
+	IB_CRYPTO_ENCRYPTED_WIRE_DOMAIN,
+	IB_CRYPTO_ENCRYPTED_MEM_DOMAIN,
+};
+
+/**
+ * enum ib_crypto_standard - Encryption standard
+ * @IB_CRYPTO_AES_XTS: AES-XTS encryption.
+ */
+enum ib_crypto_standard {
+	IB_CRYPTO_AES_XTS,
+};
+
+/* XTS initial tweak size is up to 128 bits, 16 bytes. */
+#define IB_CRYPTO_XTS_TWEAK_MAX_SIZE 16
+
+/**
+ * struct ib_crypto_attrs - Parameters for crypto handover operation
+ * @encrypt_domain: specific encryption domain.
+ * @encrypt_standard: specific encryption standard.
+ * @data_unit_size: data unit size in bytes. It might be e.g., the filesystem
+ *     block size or the disk sector size.
+ * @xts_init_tweak: a value to be used during encryption of each data unit.
+ *     This value is incremented by the device for every data_unit_size in the
+ *     message.
+ * @dek: Data Encryption Key index.
+ */
+struct ib_crypto_attrs {
+	enum ib_crypto_domain encrypt_domain;
+	enum ib_crypto_standard encrypt_standard;
+	int data_unit_size;
+	/* Today we support only AES-XTS */
+	u32 xts_init_tweak[IB_CRYPTO_XTS_TWEAK_MAX_SIZE / sizeof(u32)];
+	u32 dek;
+};
+
 /**
  * enum ib_crypto_key_type - Cryptographic key types
  * @IB_CRYPTO_KEY_TYPE_AES_XTS: Key of type AES-XTS, which can be used when
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 5fb42d553ca1..7507661c78d0 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -876,6 +876,8 @@ __attribute_const__ int ib_rate_to_mbps(enum ib_rate rate);
  *                            without address translations (VA=PA)
  * @IB_MR_TYPE_INTEGRITY:     memory region that is used for
  *                            data integrity operations
+ * @IB_MR_TYPE_CRYPTO:        memory region that is used for cryptographic
+ *                            operations
  */
 enum ib_mr_type {
 	IB_MR_TYPE_MEM_REG,
@@ -884,6 +886,7 @@ enum ib_mr_type {
 	IB_MR_TYPE_USER,
 	IB_MR_TYPE_DMA,
 	IB_MR_TYPE_INTEGRITY,
+	IB_MR_TYPE_CRYPTO,
 };
 
 enum ib_mr_status_check {
@@ -1854,6 +1857,7 @@ struct ib_mr {
 
 	struct ib_dm      *dm;
 	struct ib_sig_attrs *sig_attrs; /* only for IB_MR_TYPE_INTEGRITY MRs */
+	struct ib_crypto_attrs *crypto_attrs; /* only for IB_MR_TYPE_CRYPTO */
 	/*
 	 * Implementation details of the RDMA core, don't use in drivers:
 	 */
@@ -2512,6 +2516,7 @@ struct ib_device_ops {
 	struct ib_mr *(*alloc_mr_integrity)(struct ib_pd *pd,
 					    u32 max_num_data_sg,
 					    u32 max_num_meta_sg);
+	struct ib_mr *(*alloc_mr_crypto)(struct ib_pd *pd, u32 max_num_sg);
 	struct ib_dek *(*create_dek)(struct ib_pd *pd,
 				     struct ib_dek_attr *attr);
 	void (*destroy_dek)(struct ib_dek *dek);
@@ -4295,6 +4300,8 @@ struct ib_mr *ib_alloc_mr_integrity(struct ib_pd *pd,
 				    u32 max_num_data_sg,
 				    u32 max_num_meta_sg);
 
+struct ib_mr *ib_alloc_mr_crypto(struct ib_pd *pd, u32 max_num_sg);
+
 /**
  * ib_update_fast_reg_key - updates the key portion of the fast_reg MR
  *   R_Key and L_Key.
diff --git a/include/trace/events/rdma_core.h b/include/trace/events/rdma_core.h
index 17642aa54437..b6a3d82b89ca 100644
--- a/include/trace/events/rdma_core.h
+++ b/include/trace/events/rdma_core.h
@@ -371,6 +371,39 @@ TRACE_EVENT(mr_integ_alloc,
 		__entry->max_num_meta_sg, __entry->rc)
 );
 
+TRACE_EVENT(mr_crypto_alloc,
+	TP_PROTO(
+		const struct ib_pd *pd,
+		u32 max_num_sg,
+		const struct ib_mr *mr
+	),
+
+	TP_ARGS(pd, max_num_sg, mr),
+
+	TP_STRUCT__entry(
+		__field(u32, pd_id)
+		__field(u32, mr_id)
+		__field(u32, max_num_sg)
+		__field(int, rc)
+	),
+
+	TP_fast_assign(
+		__entry->pd_id = pd->res.id;
+		if (IS_ERR(mr)) {
+			__entry->mr_id = 0;
+			__entry->rc = PTR_ERR(mr);
+		} else {
+			__entry->mr_id = mr->res.id;
+			__entry->rc = 0;
+		}
+		__entry->max_num_sg = max_num_sg;
+	),
+
+	TP_printk("pd.id=%u mr.id=%u max_num_sg=%u rc=%d",
+		__entry->pd_id, __entry->mr_id, __entry->max_num_sg,
+		__entry->rc)
+);
+
 TRACE_EVENT(mr_dereg,
 	TP_PROTO(
 		const struct ib_mr *mr
-- 
2.39.0


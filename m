Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B37B66BEBF
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 14:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231612AbjAPNHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 08:07:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbjAPNGm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 08:06:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDB2B10AB7;
        Mon, 16 Jan 2023 05:06:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78B6360F97;
        Mon, 16 Jan 2023 13:06:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17886C433D2;
        Mon, 16 Jan 2023 13:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673874394;
        bh=AUs3KMfwul5/qoENqpBBsgdpaDQZs+4sjPEYd3EWOgw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SZ2qMwj8IZWq9M1yXgCtDldTsT2NjF+yGxfuxQc6UhuH6wTSCTXdN8hzxp4iR5+kx
         TAs8fTSTQeD+D8cq/Ge6NnfU1ObfO0vh8sL+fE1NrUgSUPSB/hIfwg8T8DR6cXgAN8
         HaZm5yn7T4ObQhbtMtAuzAPR5t3jE2eMTo9BsF3IDPB/6FuplJNv+huJKbmeS7gjdU
         SeeCkTOFp03faiW1jae/4mHefqoY/AR6QUy9NgxR+Co+CNVB5Y+zKNylpEHNx23pCI
         Nrk4md70FmjZ+U4kzzG/nNSdyRbf6vgaoj+wE+KZoYnYo0MvKynZ8kvqgNXJvkpqGQ
         tJOQAlFnKwrmQ==
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
Subject: [PATCH rdma-next 05/13] RDMA/core: Add DEK management API
Date:   Mon, 16 Jan 2023 15:05:52 +0200
Message-Id: <58e678103d910efbe3481d698169af9dadf70d4b.1673873422.git.leon@kernel.org>
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

Add an API to manage Data Encryption Keys (DEKs). The API allows
creating and destroying a DEK. DEKs allow encryption and decryption
of transmitted data and are used in MKeys for crypto operations.
A crypto setter for the MKey configuration API will be added in the
following commit.

Signed-off-by: Israel Rukshin <israelr@nvidia.com>
Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
---
 drivers/infiniband/core/device.c |  2 ++
 drivers/infiniband/core/verbs.c  | 32 +++++++++++++++++++++++++++
 include/rdma/crypto.h            | 38 ++++++++++++++++++++++++++++++++
 include/rdma/ib_verbs.h          |  3 +++
 4 files changed, 75 insertions(+)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index a666847bd714..b2016725c3d8 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -2615,6 +2615,7 @@ void ib_set_device_ops(struct ib_device *dev, const struct ib_device_ops *ops)
 	SET_DEVICE_OP(dev_ops, create_ah);
 	SET_DEVICE_OP(dev_ops, create_counters);
 	SET_DEVICE_OP(dev_ops, create_cq);
+	SET_DEVICE_OP(dev_ops, create_dek);
 	SET_DEVICE_OP(dev_ops, create_flow);
 	SET_DEVICE_OP(dev_ops, create_qp);
 	SET_DEVICE_OP(dev_ops, create_rwq_ind_table);
@@ -2632,6 +2633,7 @@ void ib_set_device_ops(struct ib_device *dev, const struct ib_device_ops *ops)
 	SET_DEVICE_OP(dev_ops, destroy_ah);
 	SET_DEVICE_OP(dev_ops, destroy_counters);
 	SET_DEVICE_OP(dev_ops, destroy_cq);
+	SET_DEVICE_OP(dev_ops, destroy_dek);
 	SET_DEVICE_OP(dev_ops, destroy_flow);
 	SET_DEVICE_OP(dev_ops, destroy_flow_action);
 	SET_DEVICE_OP(dev_ops, destroy_qp);
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 26b021f43ba4..03633d706106 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -2306,6 +2306,38 @@ struct ib_mr *ib_alloc_mr_integrity(struct ib_pd *pd,
 }
 EXPORT_SYMBOL(ib_alloc_mr_integrity);
 
+/**
+ * ib_create_dek - Create a DEK (Data Encryption Key) associated with the
+ * specific protection domain.
+ * @pd: The protection domain associated with the DEK.
+ * @attr: The attributes of the DEK.
+ *
+ * Return: Allocated DEK in case of success; IS_ERR() is true in case of an
+ * error, PTR_ERR() returns the error code.
+ */
+struct ib_dek *ib_create_dek(struct ib_pd *pd, struct ib_dek_attr *attr)
+{
+	struct ib_device *device = pd->device;
+
+	if (!device->ops.create_dek || !device->ops.destroy_dek)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	return device->ops.create_dek(pd, attr);
+}
+EXPORT_SYMBOL(ib_create_dek);
+
+/**
+ * ib_destroy_dek - Destroys the specified DEK.
+ * @dek: The DEK to destroy.
+ */
+void ib_destroy_dek(struct ib_dek *dek)
+{
+	struct ib_device *device = dek->pd->device;
+
+	device->ops.destroy_dek(dek);
+}
+EXPORT_SYMBOL(ib_destroy_dek);
+
 /* Multicast groups */
 
 static bool is_valid_mcast_lid(struct ib_qp *qp, u16 lid)
diff --git a/include/rdma/crypto.h b/include/rdma/crypto.h
index 4779eacb000e..cdf287c94737 100644
--- a/include/rdma/crypto.h
+++ b/include/rdma/crypto.h
@@ -34,4 +34,42 @@ struct ib_crypto_caps {
 	u32 max_num_deks;
 };
 
+/**
+ * enum ib_crypto_key_type - Cryptographic key types
+ * @IB_CRYPTO_KEY_TYPE_AES_XTS: Key of type AES-XTS, which can be used when
+ * IB_CRYPTO_AES_XTS is supported.
+ */
+enum ib_crypto_key_type {
+	IB_CRYPTO_KEY_TYPE_AES_XTS,
+};
+
+/**
+ * struct ib_dek_attr - Parameters for DEK (Data Encryption Key)
+ * @key_blob: the key blob that will be used for encryption and decryption of
+ *     transmitted data. Actual size and layout of this field depends on the
+ *     provided key_type and key_blob_size.
+ *     The layout of AES_XTS key is: key1_128b + key2_128b or key1_256b +
+ *     key2_256b.
+ * @key_blob_size: size of the key blob in bytes.
+ * @key_type: specific cryptographic key type.
+ */
+struct ib_dek_attr {
+	const void *key_blob;
+	u32 key_blob_size;
+	enum ib_crypto_key_type key_type;
+};
+
+/**
+ * struct ib_dek - Data Encryption Key
+ * @pd: The protection domain associated with the DEK.
+ * @id: DEK identifier.
+ */
+struct ib_dek {
+	struct ib_pd *pd;
+	u32 id;
+};
+
+struct ib_dek *ib_create_dek(struct ib_pd *pd, struct ib_dek_attr *attr);
+void ib_destroy_dek(struct ib_dek *dek);
+
 #endif /* _RDMA_CRYPTO_H_ */
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 83be7e49c5f7..5fb42d553ca1 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2512,6 +2512,9 @@ struct ib_device_ops {
 	struct ib_mr *(*alloc_mr_integrity)(struct ib_pd *pd,
 					    u32 max_num_data_sg,
 					    u32 max_num_meta_sg);
+	struct ib_dek *(*create_dek)(struct ib_pd *pd,
+				     struct ib_dek_attr *attr);
+	void (*destroy_dek)(struct ib_dek *dek);
 	int (*advise_mr)(struct ib_pd *pd,
 			 enum ib_uverbs_advise_mr_advice advice, u32 flags,
 			 struct ib_sge *sg_list, u32 num_sge,
-- 
2.39.0


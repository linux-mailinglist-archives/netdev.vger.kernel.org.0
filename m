Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7FDD66BEC8
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 14:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231576AbjAPNHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 08:07:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbjAPNGs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 08:06:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1C0A468D;
        Mon, 16 Jan 2023 05:06:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81FD9B80E37;
        Mon, 16 Jan 2023 13:06:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63900C433EF;
        Mon, 16 Jan 2023 13:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673874403;
        bh=Wfrh+cFzRa6bL8VsIjXTHMZp54Ti5ONFcFNaROn2N0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BE6tEMsI+O5FK8qa8wAtpmy+ZOkSqtR5gHiDdYaBYb0ant+YSdskbqREQ1w4EPXxG
         EIy7m1WWsgybCSyttOwAHsYEn1pcFeUYPTmV6vKmbWU5XmfbcXlRXohT3y3fx02ZNg
         S8etQ60IlT5YaDoKVuwr0g1cy/N52o0bRNI5ut1FPTydIwGP15BtgV4rK9dsyUlAm9
         qMdZQlN1S2k9WiLELz5sNoHnXjsjxp/OvZurZhneSDNe8SiMUI8r7oGb0AP3S6CTnw
         J8HkCMJ+BJrYJhhhU2os4McmuIj4uoe8HhAUpyQXfD73IaruVVIKzXqybteHruAcEo
         ETpmtsfRT8Gfg==
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
Subject: [PATCH rdma-next 10/13] RDMA/mlx5: Add AES-XTS crypto support
Date:   Mon, 16 Jan 2023 15:05:57 +0200
Message-Id: <0a7ea7b225b3a62be84de852b1fc126508d07ee6.1673873422.git.leon@kernel.org>
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

Add crypto attributes for MKey and QP. With this, the device
can encrypt/decrypt data when transmitting data from memory to
network and when receiving data from network to memory.

Signed-off-by: Israel Rukshin <israelr@nvidia.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
---
 drivers/infiniband/hw/mlx5/crypto.c  |   1 +
 drivers/infiniband/hw/mlx5/crypto.h  |  27 +++++
 drivers/infiniband/hw/mlx5/mlx5_ib.h |   1 +
 drivers/infiniband/hw/mlx5/mr.c      |  33 ++++++
 drivers/infiniband/hw/mlx5/qp.c      |   6 +
 drivers/infiniband/hw/mlx5/wr.c      | 164 +++++++++++++++++++++++++--
 6 files changed, 222 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/crypto.c b/drivers/infiniband/hw/mlx5/crypto.c
index 36e978c0fb85..28bc661bd5bc 100644
--- a/drivers/infiniband/hw/mlx5/crypto.c
+++ b/drivers/infiniband/hw/mlx5/crypto.c
@@ -82,6 +82,7 @@ static void mlx5r_destroy_dek(struct ib_dek *dek)
 static const struct ib_device_ops mlx5r_dev_crypto_ops = {
 	.create_dek = mlx5r_create_dek,
 	.destroy_dek = mlx5r_destroy_dek,
+	.alloc_mr_crypto = mlx5r_alloc_mr_crypto,
 };
 
 void mlx5r_crypto_caps_init(struct mlx5_ib_dev *dev)
diff --git a/drivers/infiniband/hw/mlx5/crypto.h b/drivers/infiniband/hw/mlx5/crypto.h
index b132b780030f..33f7e3b8bcce 100644
--- a/drivers/infiniband/hw/mlx5/crypto.h
+++ b/drivers/infiniband/hw/mlx5/crypto.h
@@ -6,6 +6,33 @@
 
 #include "mlx5_ib.h"
 
+enum {
+	MLX5_CRYPTO_ENCRYPTED_WIRE = 0x0,
+	MLX5_CRYPTO_ENCRYPTED_MEM = 0x1,
+};
+
+enum {
+	MLX5_CRYPTO_AES_XTS = 0x0,
+};
+
+struct mlx5_bsf_crypto {
+	u8 bsf_size_type;
+	u8 encryption_order;
+	u8 rsvd0;
+	u8 encryption_standard;
+	__be32 raw_data_size;
+	u8 block_size_p;
+	u8 rsvd1[7];
+	union {
+		__be32 be_xts_init_tweak[4];
+		__le32 le_xts_init_tweak[4];
+	};
+	__be32 rsvd_dek_pointer;
+	u8 rsvd2[4];
+	u8 keytag[8];
+	u8 rsvd3[16];
+};
+
 /*
  * The standard AES-XTS key blob composed of two keys.
  * AES-128-XTS key blob composed of two 128-bit keys, which is 32 bytes and
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 8f6850539542..6e5b1a65f91b 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1291,6 +1291,7 @@ struct ib_mr *mlx5_ib_alloc_mr(struct ib_pd *pd, enum ib_mr_type mr_type,
 struct ib_mr *mlx5_ib_alloc_mr_integrity(struct ib_pd *pd,
 					 u32 max_num_sg,
 					 u32 max_num_meta_sg);
+struct ib_mr *mlx5r_alloc_mr_crypto(struct ib_pd *pd, u32 max_num_sg);
 int mlx5_ib_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg, int sg_nents,
 		      unsigned int *sg_offset);
 int mlx5_ib_map_mr_sg_pi(struct ib_mr *ibmr, struct scatterlist *data_sg,
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index e3b0f41aef0d..8e2f32ae4196 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -40,6 +40,7 @@
 #include <linux/dma-buf.h>
 #include <linux/dma-resv.h>
 #include <rdma/ib_umem_odp.h>
+#include "crypto.h"
 #include "dm.h"
 #include "mlx5_ib.h"
 #include "umr.h"
@@ -1553,6 +1554,8 @@ mlx5_alloc_priv_descs(struct ib_device *device,
 	int add_size;
 	int ret;
 
+	if (mr->ibmr.type == IB_MR_TYPE_CRYPTO)
+		size += sizeof(struct mlx5_bsf_crypto);
 	add_size = max_t(int, MLX5_UMR_ALIGN - ARCH_KMALLOC_MINALIGN, 0);
 
 	mr->descs_alloc = kzalloc(size + add_size, GFP_KERNEL);
@@ -1582,6 +1585,8 @@ mlx5_free_priv_descs(struct mlx5_ib_mr *mr)
 		int size = mr->max_descs * mr->desc_size;
 		struct mlx5_ib_dev *dev = to_mdev(device);
 
+		if (mr->ibmr.type == IB_MR_TYPE_CRYPTO)
+			size += sizeof(struct mlx5_bsf_crypto);
 		dma_unmap_single(&dev->mdev->pdev->dev, mr->desc_map, size,
 				 DMA_TO_DEVICE);
 		kfree(mr->descs_alloc);
@@ -1862,6 +1867,21 @@ static int mlx5_alloc_integrity_descs(struct ib_pd *pd, struct mlx5_ib_mr *mr,
 	return err;
 }
 
+static int mlx5_alloc_crypto_descs(struct ib_pd *pd, struct mlx5_ib_mr *mr,
+				   int ndescs, u32 *in, int inlen)
+{
+	void *mkc;
+
+	mkc = MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
+	MLX5_SET(mkc, mkc, crypto_en, 1);
+	/* Set bsf descriptors for mkey */
+	MLX5_SET(mkc, mkc, bsf_en, 1);
+	MLX5_SET(mkc, mkc, bsf_octword_size, MLX5_MKEY_BSF_OCTO_SIZE);
+
+	return _mlx5_alloc_mkey_descs(pd, mr, ndescs, sizeof(struct mlx5_klm),
+				      0, MLX5_MKC_ACCESS_MODE_KLMS, in, inlen);
+}
+
 static struct ib_mr *__mlx5_ib_alloc_mr(struct ib_pd *pd,
 					enum ib_mr_type mr_type, u32 max_num_sg,
 					u32 max_num_meta_sg)
@@ -1897,6 +1917,9 @@ static struct ib_mr *__mlx5_ib_alloc_mr(struct ib_pd *pd,
 		err = mlx5_alloc_integrity_descs(pd, mr, max_num_sg,
 						 max_num_meta_sg, in, inlen);
 		break;
+	case IB_MR_TYPE_CRYPTO:
+		err = mlx5_alloc_crypto_descs(pd, mr, ndescs, in, inlen);
+		break;
 	default:
 		mlx5_ib_warn(dev, "Invalid mr type %d\n", mr_type);
 		err = -EINVAL;
@@ -1929,6 +1952,11 @@ struct ib_mr *mlx5_ib_alloc_mr_integrity(struct ib_pd *pd,
 				  max_num_meta_sg);
 }
 
+struct ib_mr *mlx5r_alloc_mr_crypto(struct ib_pd *pd, u32 max_num_sg)
+{
+	return __mlx5_ib_alloc_mr(pd, IB_MR_TYPE_CRYPTO, max_num_sg, 0);
+}
+
 int mlx5_ib_alloc_mw(struct ib_mw *ibmw, struct ib_udata *udata)
 {
 	struct mlx5_ib_dev *dev = to_mdev(ibmw->device);
@@ -2368,6 +2396,11 @@ int mlx5_ib_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg, int sg_nents,
 				      mr->desc_size * mr->max_descs,
 				      DMA_TO_DEVICE);
 
+	if (ibmr->type == IB_MR_TYPE_CRYPTO) {
+		/* This is zero-based memory region */
+		ibmr->iova = 0;
+	}
+
 	return n;
 }
 
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index f04adc18e63b..8eb777d422e4 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -40,6 +40,7 @@
 #include "ib_rep.h"
 #include "counters.h"
 #include "cmd.h"
+#include "crypto.h"
 #include "umr.h"
 #include "qp.h"
 #include "wr.h"
@@ -554,6 +555,8 @@ static int calc_send_wqe(struct ib_qp_init_attr *attr)
 	}
 
 	size += attr->cap.max_send_sge * sizeof(struct mlx5_wqe_data_seg);
+	if (attr->create_flags & IB_QP_CREATE_CRYPTO_EN)
+		size += sizeof(struct mlx5_bsf_crypto);
 	if (attr->create_flags & IB_QP_CREATE_INTEGRITY_EN &&
 	    ALIGN(max_t(int, inl_size, size), MLX5_SEND_WQE_BB) < MLX5_SIG_WQE_SIZE)
 		return MLX5_SIG_WQE_SIZE;
@@ -3024,6 +3027,9 @@ static int process_create_flags(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	process_create_flag(dev, &create_flags, MLX5_IB_QP_CREATE_SQPN_QP1,
 			    true, qp);
 
+	process_create_flag(dev, &create_flags, IB_QP_CREATE_CRYPTO_EN,
+			    !!dev->crypto_caps.crypto_engines, qp);
+
 	if (create_flags) {
 		mlx5_ib_dbg(dev, "Create QP has unsupported flags 0x%llX\n",
 			    create_flags);
diff --git a/drivers/infiniband/hw/mlx5/wr.c b/drivers/infiniband/hw/mlx5/wr.c
index df1d1b0a3ef7..e047b8aabceb 100644
--- a/drivers/infiniband/hw/mlx5/wr.c
+++ b/drivers/infiniband/hw/mlx5/wr.c
@@ -6,6 +6,7 @@
 #include <linux/gfp.h>
 #include <linux/mlx5/qp.h>
 #include <linux/mlx5/driver.h>
+#include "crypto.h"
 #include "wr.h"
 #include "umr.h"
 
@@ -21,6 +22,7 @@ static const u32 mlx5_ib_opcode[] = {
 	[IB_WR_SEND_WITH_INV]			= MLX5_OPCODE_SEND_INVAL,
 	[IB_WR_LOCAL_INV]			= MLX5_OPCODE_UMR,
 	[IB_WR_REG_MR]				= MLX5_OPCODE_UMR,
+	[IB_WR_REG_MR_CRYPTO]			= MLX5_OPCODE_UMR,
 	[IB_WR_MASKED_ATOMIC_CMP_AND_SWP]	= MLX5_OPCODE_ATOMIC_MASKED_CS,
 	[IB_WR_MASKED_ATOMIC_FETCH_AND_ADD]	= MLX5_OPCODE_ATOMIC_MASKED_FA,
 	[MLX5_IB_WR_UMR]			= MLX5_OPCODE_UMR,
@@ -115,7 +117,7 @@ static void set_data_ptr_seg(struct mlx5_wqe_data_seg *dseg, struct ib_sge *sg)
 	dseg->addr       = cpu_to_be64(sg->addr);
 }
 
-static __be64 frwr_mkey_mask(bool atomic)
+static __be64 frwr_mkey_mask(bool atomic, bool crypto)
 {
 	u64 result;
 
@@ -134,6 +136,9 @@ static __be64 frwr_mkey_mask(bool atomic)
 	if (atomic)
 		result |= MLX5_MKEY_MASK_A;
 
+	if (crypto)
+		result |= MLX5_MKEY_MASK_BSF_EN;
+
 	return cpu_to_be64(result);
 }
 
@@ -159,7 +164,8 @@ static __be64 sig_mkey_mask(void)
 }
 
 static void set_reg_umr_seg(struct mlx5_wqe_umr_ctrl_seg *umr,
-			    struct mlx5_ib_mr *mr, u8 flags, bool atomic)
+			    struct mlx5_ib_mr *mr, u8 flags, bool atomic,
+			    bool crypto)
 {
 	int size = (mr->mmkey.ndescs + mr->meta_ndescs) * mr->desc_size;
 
@@ -167,7 +173,9 @@ static void set_reg_umr_seg(struct mlx5_wqe_umr_ctrl_seg *umr,
 
 	umr->flags = flags;
 	umr->xlt_octowords = cpu_to_be16(mlx5r_umr_get_xlt_octo(size));
-	umr->mkey_mask = frwr_mkey_mask(atomic);
+	umr->mkey_mask = frwr_mkey_mask(atomic, crypto);
+	if (crypto)
+		umr->bsf_octowords = cpu_to_be16(MLX5_MKEY_BSF_OCTO_SIZE);
 }
 
 static void set_linv_umr_seg(struct mlx5_wqe_umr_ctrl_seg *umr)
@@ -188,7 +196,7 @@ static u8 get_umr_flags(int acc)
 
 static void set_reg_mkey_seg(struct mlx5_mkey_seg *seg,
 			     struct mlx5_ib_mr *mr,
-			     u32 key, int access)
+			     u32 key, int access, bool crypto)
 {
 	int ndescs = ALIGN(mr->mmkey.ndescs + mr->meta_ndescs, 8) >> 1;
 
@@ -203,6 +211,8 @@ static void set_reg_mkey_seg(struct mlx5_mkey_seg *seg,
 	seg->flags = get_umr_flags(access) | mr->access_mode;
 	seg->qpn_mkey7_0 = cpu_to_be32((key & 0xff) | 0xffffff00);
 	seg->flags_pd = cpu_to_be32(MLX5_MKEY_REMOTE_INVAL);
+	if (crypto)
+		seg->flags_pd |= cpu_to_be32(MLX5_MKEY_BSF_EN);
 	seg->start_addr = cpu_to_be64(mr->ibmr.iova);
 	seg->len = cpu_to_be64(mr->ibmr.length);
 	seg->xlt_oct_size = cpu_to_be32(ndescs);
@@ -353,6 +363,66 @@ static void mlx5_fill_inl_bsf(struct ib_sig_domain *domain,
 		cpu_to_be16(domain->sig.dif.apptag_check_mask);
 }
 
+static void mlx5_set_xts_tweak(struct ib_crypto_attrs *crypto_attrs,
+			       struct mlx5_bsf_crypto *bsf, bool is_be)
+{
+	int tweak_array_size = sizeof(bsf->be_xts_init_tweak) / sizeof(u32);
+	int i, j;
+
+	/* The endianness of the initial tweak in the kernel is LE */
+	if (is_be) {
+		for (i = 0; i < tweak_array_size; i++) {
+			j = tweak_array_size - i - 1;
+			bsf->be_xts_init_tweak[i] =
+				cpu_to_be32(crypto_attrs->xts_init_tweak[j]);
+		}
+	} else {
+		for (i = 0; i < tweak_array_size; i++)
+			bsf->le_xts_init_tweak[i] =
+				cpu_to_le32(crypto_attrs->xts_init_tweak[i]);
+	}
+}
+
+static int mlx5_set_bsf_crypto(struct ib_mr *ibmr, struct mlx5_bsf_crypto *bsf)
+{
+	struct mlx5_ib_dev *dev = to_mdev(ibmr->device);
+	struct mlx5_core_dev *mdev = dev->mdev;
+	struct ib_crypto_attrs *crypto_attrs = ibmr->crypto_attrs;
+	u64 data_size = ibmr->length;
+
+	if (crypto_attrs->encrypt_standard != IB_CRYPTO_AES_XTS)
+		return -EINVAL;
+
+	memset(bsf, 0, sizeof(*bsf));
+
+	/* Crypto only */
+	bsf->bsf_size_type = 1 << 7;
+	/* Crypto type */
+	bsf->bsf_size_type |= 1;
+
+	switch (crypto_attrs->encrypt_domain) {
+	case IB_CRYPTO_ENCRYPTED_WIRE_DOMAIN:
+		bsf->encryption_order = MLX5_CRYPTO_ENCRYPTED_WIRE;
+		break;
+	case IB_CRYPTO_ENCRYPTED_MEM_DOMAIN:
+		bsf->encryption_order = MLX5_CRYPTO_ENCRYPTED_MEM;
+		break;
+	default:
+		WARN_ONCE(1, "Bad encryption domain (%d) is given.\n",
+			  crypto_attrs->encrypt_domain);
+		return -EINVAL;
+	}
+
+	bsf->encryption_standard = MLX5_CRYPTO_AES_XTS;
+	bsf->raw_data_size = cpu_to_be32(data_size);
+	bsf->block_size_p = bs_selector(crypto_attrs->data_unit_size);
+	mlx5_set_xts_tweak(crypto_attrs, bsf,
+			   MLX5_CAP_GEN(mdev, aes_xts_multi_block_be_tweak));
+	bsf->rsvd_dek_pointer |= cpu_to_be32(crypto_attrs->dek & 0xffffff);
+
+	return 0;
+}
+
 static int mlx5_set_bsf(struct ib_mr *sig_mr,
 			struct ib_sig_attrs *sig_attrs,
 			struct mlx5_bsf *bsf, u32 data_size)
@@ -632,10 +702,53 @@ static int set_psv_wr(struct ib_sig_domain *domain,
 	return 0;
 }
 
+static int set_crypto_data_segment(struct mlx5_ib_qp *qp, struct mlx5_ib_mr *mr,
+				   void **seg, int *size, void **cur_edge)
+{
+	int mr_list_size = (mr->mmkey.ndescs + mr->meta_ndescs) * mr->desc_size;
+	int tmp_size;
+
+	mlx5r_memcpy_send_wqe(&qp->sq, cur_edge, seg, size, mr->descs,
+			      mr_list_size);
+	tmp_size = *size;
+	*size = ALIGN(*size, MLX5_SEND_WQE_BB >> 4);
+	*seg += (*size - tmp_size) * 16;
+	handle_post_send_edge(&qp->sq, seg, *size, cur_edge);
+
+	if (mlx5_set_bsf_crypto(&mr->ibmr, *seg))
+		return -EINVAL;
+
+	*seg += sizeof(struct mlx5_bsf_crypto);
+	*size += sizeof(struct mlx5_bsf_crypto) / 16;
+	handle_post_send_edge(&qp->sq, seg, *size, cur_edge);
+
+	return 0;
+}
+
+static int set_dma_bsf_crypto(struct mlx5_ib_mr *mr)
+{
+	int mr_list_size = (mr->mmkey.ndescs + mr->meta_ndescs) * mr->desc_size;
+	int aligned_size = ALIGN(mr_list_size, MLX5_SEND_WQE_BB);
+
+	ib_dma_sync_single_for_cpu(mr->ibmr.device, mr->desc_map + aligned_size,
+				   sizeof(struct mlx5_bsf_crypto),
+				   DMA_TO_DEVICE);
+
+	if (mlx5_set_bsf_crypto(&mr->ibmr, mr->descs + aligned_size))
+		return -EINVAL;
+
+	ib_dma_sync_single_for_device(mr->ibmr.device,
+				      mr->desc_map + aligned_size,
+				      sizeof(struct mlx5_bsf_crypto),
+				      DMA_TO_DEVICE);
+
+	return 0;
+}
+
 static int set_reg_wr(struct mlx5_ib_qp *qp,
 		      const struct ib_reg_wr *wr,
 		      void **seg, int *size, void **cur_edge,
-		      bool check_not_free)
+		      bool check_not_free, bool crypto)
 {
 	struct mlx5_ib_mr *mr = to_mmr(wr->mr);
 	struct mlx5_ib_pd *pd = to_mpd(qp->ibqp.pd);
@@ -667,17 +780,21 @@ static int set_reg_wr(struct mlx5_ib_qp *qp,
 	if (umr_inline)
 		flags |= MLX5_UMR_INLINE;
 
-	set_reg_umr_seg(*seg, mr, flags, atomic);
+	set_reg_umr_seg(*seg, mr, flags, atomic, crypto);
 	*seg += sizeof(struct mlx5_wqe_umr_ctrl_seg);
 	*size += sizeof(struct mlx5_wqe_umr_ctrl_seg) / 16;
 	handle_post_send_edge(&qp->sq, seg, *size, cur_edge);
 
-	set_reg_mkey_seg(*seg, mr, wr->key, wr->access);
+	set_reg_mkey_seg(*seg, mr, wr->key, wr->access, crypto);
 	*seg += sizeof(struct mlx5_mkey_seg);
 	*size += sizeof(struct mlx5_mkey_seg) / 16;
 	handle_post_send_edge(&qp->sq, seg, *size, cur_edge);
 
 	if (umr_inline) {
+		if (crypto)
+			return set_crypto_data_segment(qp, mr, seg, size,
+						       cur_edge);
+
 		mlx5r_memcpy_send_wqe(&qp->sq, cur_edge, seg, size, mr->descs,
 				      mr_list_size);
 		*size = ALIGN(*size, MLX5_SEND_WQE_BB >> 4);
@@ -685,6 +802,9 @@ static int set_reg_wr(struct mlx5_ib_qp *qp,
 		set_reg_data_seg(*seg, mr, pd);
 		*seg += sizeof(struct mlx5_wqe_data_seg);
 		*size += (sizeof(struct mlx5_wqe_data_seg) / 16);
+
+		if (crypto)
+			return set_dma_bsf_crypto(mr);
 	}
 	return 0;
 }
@@ -806,7 +926,7 @@ static int handle_reg_mr(struct mlx5_ib_qp *qp, const struct ib_send_wr *wr,
 {
 	qp->sq.wr_data[idx] = IB_WR_REG_MR;
 	(*ctrl)->imm = cpu_to_be32(reg_wr(wr)->key);
-	return set_reg_wr(qp, reg_wr(wr), seg, size, cur_edge, true);
+	return set_reg_wr(qp, reg_wr(wr), seg, size, cur_edge, true, false);
 }
 
 static int handle_psv(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
@@ -870,7 +990,8 @@ static int handle_reg_mr_integrity(struct mlx5_ib_dev *dev,
 
 		(*ctrl)->imm = cpu_to_be32(reg_pi_wr.key);
 		/* UMR for data + prot registration */
-		err = set_reg_wr(qp, &reg_pi_wr, seg, size, cur_edge, false);
+		err = set_reg_wr(qp, &reg_pi_wr, seg, size, cur_edge, false,
+				 false);
 		if (unlikely(err))
 			goto out;
 
@@ -928,6 +1049,20 @@ static int handle_reg_mr_integrity(struct mlx5_ib_dev *dev,
 	return err;
 }
 
+static int handle_reg_mr_crypto(struct mlx5_ib_qp *qp,
+				const struct ib_send_wr *wr,
+				struct mlx5_wqe_ctrl_seg **ctrl, void **seg,
+				int *size, void **cur_edge, unsigned int idx)
+{
+	qp->sq.wr_data[idx] = IB_WR_REG_MR_CRYPTO;
+	(*ctrl)->imm = cpu_to_be32(reg_wr(wr)->key);
+
+	if (unlikely(!qp->ibqp.crypto_en))
+		return -EINVAL;
+
+	return set_reg_wr(qp, reg_wr(wr), seg, size, cur_edge, true, true);
+}
+
 static int handle_qpt_rc(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 			 const struct ib_send_wr *wr,
 			 struct mlx5_wqe_ctrl_seg **ctrl, void **seg, int *size,
@@ -971,6 +1106,14 @@ static int handle_qpt_rc(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 		*num_sge = 0;
 		break;
 
+	case IB_WR_REG_MR_CRYPTO:
+		err = handle_reg_mr_crypto(qp, wr, ctrl, seg, size, cur_edge,
+					   *idx);
+		if (unlikely(err))
+			goto out;
+		*num_sge = 0;
+		break;
+
 	default:
 		break;
 	}
@@ -1105,7 +1248,8 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, const struct ib_send_wr *wr,
 		}
 
 		if (wr->opcode == IB_WR_REG_MR ||
-		    wr->opcode == IB_WR_REG_MR_INTEGRITY) {
+		    wr->opcode == IB_WR_REG_MR_INTEGRITY ||
+		    wr->opcode == IB_WR_REG_MR_CRYPTO) {
 			fence = dev->umr_fence;
 			next_fence = MLX5_FENCE_MODE_INITIATOR_SMALL;
 		} else  {
-- 
2.39.0


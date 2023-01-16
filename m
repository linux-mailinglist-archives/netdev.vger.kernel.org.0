Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 517B366BEC2
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 14:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231588AbjAPNHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 08:07:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231393AbjAPNGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 08:06:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 372237AA8;
        Mon, 16 Jan 2023 05:06:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9FCD60F97;
        Mon, 16 Jan 2023 13:06:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C5AC433D2;
        Mon, 16 Jan 2023 13:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673874399;
        bh=e1ONfQusN53JOuI2VALrT8a03P5hTd6F5/2Z57t4AgQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NjeEAf6K1ZTvA5sAmlWSOfHcOZLUrT+sap+XphlaKKggOYN+QPNxrmcUQFaf8Dl37
         jll6CyVdwpaeyFDzoSXUsGerkF+82sSLOpgHsFSW2WtWgtwJMLcHaAiA6RTD5GBCbx
         86cQry3okdTrEYP8hjBbdqF6lPFBVPXghRJi7RFvZ6PTTQYXvTBN4IltOejDi8eJk6
         Nta/DpHh7p8t9iM8YgyfWjXykc+Ukxya3aBzhuKzE4xgJOrt6VAaL5D3fHIxi4KxrX
         MAeRmaIk3WdH9vIkaRjmhLj0Q91G5hk3gQwxrf7Tj4CBTH0laj42RSCxQqTJ/xNxCR
         UDxsDd3CQeeFQ==
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
Subject: [PATCH rdma-next 09/13] RDMA/mlx5: Add DEK management API
Date:   Mon, 16 Jan 2023 15:05:56 +0200
Message-Id: <447a02ca42116a422d5727e725bf90551dd0c8ba.1673873422.git.leon@kernel.org>
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

Signed-off-by: Israel Rukshin <israelr@nvidia.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
---
 drivers/infiniband/hw/mlx5/crypto.c | 83 +++++++++++++++++++++++++++++
 drivers/infiniband/hw/mlx5/crypto.h |  8 +++
 2 files changed, 91 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/crypto.c b/drivers/infiniband/hw/mlx5/crypto.c
index 6fad9084877e..36e978c0fb85 100644
--- a/drivers/infiniband/hw/mlx5/crypto.c
+++ b/drivers/infiniband/hw/mlx5/crypto.c
@@ -3,6 +3,87 @@
 
 #include "crypto.h"
 
+static struct ib_dek *mlx5r_create_dek(struct ib_pd *pd,
+				       struct ib_dek_attr *attr)
+{
+	u32 in[MLX5_ST_SZ_DW(create_encryption_key_in)] = {};
+	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)];
+	struct mlx5_ib_dev *dev = to_mdev(pd->device);
+	u32 key_blob_size = attr->key_blob_size;
+	void *ptr, *key_addr;
+	struct ib_dek *dek;
+	u8 key_size;
+	int err;
+
+	if (attr->key_type != IB_CRYPTO_KEY_TYPE_AES_XTS)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	switch (key_blob_size) {
+	case MLX5_IB_CRYPTO_AES_128_XTS_KEY_SIZE:
+		key_size = MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_KEY_SIZE_128;
+		break;
+	case MLX5_IB_CRYPTO_AES_256_XTS_KEY_SIZE:
+		key_size = MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_KEY_SIZE_256;
+		break;
+	default:
+		return ERR_PTR(-EOPNOTSUPP);
+	}
+
+	dek = kzalloc(sizeof(*dek), GFP_KERNEL);
+	if (!dek)
+		return ERR_PTR(-ENOMEM);
+
+	ptr = MLX5_ADDR_OF(create_encryption_key_in, in,
+			   general_obj_in_cmd_hdr);
+	MLX5_SET(general_obj_in_cmd_hdr, ptr, opcode,
+		 MLX5_CMD_OP_CREATE_GENERAL_OBJECT);
+	MLX5_SET(general_obj_in_cmd_hdr, ptr, obj_type,
+		 MLX5_GENERAL_OBJECT_TYPES_ENCRYPTION_KEY);
+	ptr = MLX5_ADDR_OF(create_encryption_key_in, in, encryption_key_object);
+	MLX5_SET(encryption_key_obj, ptr, key_size, key_size);
+	MLX5_SET(encryption_key_obj, ptr, key_type,
+		 MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_TYPE_AES_XTS);
+	MLX5_SET(encryption_key_obj, ptr, pd, to_mpd(pd)->pdn);
+	key_addr = MLX5_ADDR_OF(encryption_key_obj, ptr, key);
+	memcpy(key_addr, attr->key_blob, key_blob_size);
+
+	err = mlx5_cmd_exec(dev->mdev, in, sizeof(in), out, sizeof(out));
+	/* avoid leaking key on the stack */
+	memzero_explicit(in, sizeof(in));
+	if (err)
+		goto err_free;
+
+	dek->id = MLX5_GET(general_obj_out_cmd_hdr, out, obj_id);
+	dek->pd = pd;
+
+	return dek;
+
+err_free:
+	kfree(dek);
+	return ERR_PTR(err);
+}
+
+static void mlx5r_destroy_dek(struct ib_dek *dek)
+{
+	struct mlx5_ib_dev *dev = to_mdev(dek->pd->device);
+	u32 in[MLX5_ST_SZ_DW(general_obj_in_cmd_hdr)] = {};
+	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)];
+
+	MLX5_SET(general_obj_in_cmd_hdr, in, opcode,
+		 MLX5_CMD_OP_DESTROY_GENERAL_OBJECT);
+	MLX5_SET(general_obj_in_cmd_hdr, in, obj_type,
+		 MLX5_GENERAL_OBJECT_TYPES_ENCRYPTION_KEY);
+	MLX5_SET(general_obj_in_cmd_hdr, in, obj_id, dek->id);
+
+	mlx5_cmd_exec(dev->mdev, in, sizeof(in), out, sizeof(out));
+	kfree(dek);
+}
+
+static const struct ib_device_ops mlx5r_dev_crypto_ops = {
+	.create_dek = mlx5r_create_dek,
+	.destroy_dek = mlx5r_destroy_dek,
+};
+
 void mlx5r_crypto_caps_init(struct mlx5_ib_dev *dev)
 {
 	struct ib_crypto_caps *caps = &dev->crypto_caps;
@@ -28,4 +109,6 @@ void mlx5r_crypto_caps_init(struct mlx5_ib_dev *dev)
 
 	caps->crypto_engines |= IB_CRYPTO_ENGINES_CAP_AES_XTS;
 	caps->max_num_deks = 1 << MLX5_CAP_CRYPTO(mdev, log_max_num_deks);
+
+	ib_set_device_ops(&dev->ib_dev, &mlx5r_dev_crypto_ops);
 }
diff --git a/drivers/infiniband/hw/mlx5/crypto.h b/drivers/infiniband/hw/mlx5/crypto.h
index 8686ac6fb0b0..b132b780030f 100644
--- a/drivers/infiniband/hw/mlx5/crypto.h
+++ b/drivers/infiniband/hw/mlx5/crypto.h
@@ -6,6 +6,14 @@
 
 #include "mlx5_ib.h"
 
+/*
+ * The standard AES-XTS key blob composed of two keys.
+ * AES-128-XTS key blob composed of two 128-bit keys, which is 32 bytes and
+ * AES-256-XTS key blob composed of two 256-bit keys, which is 64 bytes.
+ */
+#define MLX5_IB_CRYPTO_AES_128_XTS_KEY_SIZE	32
+#define MLX5_IB_CRYPTO_AES_256_XTS_KEY_SIZE	64
+
 void mlx5r_crypto_caps_init(struct mlx5_ib_dev *dev);
 
 #endif /* _MLX5_IB_CRYPTO_H */
-- 
2.39.0


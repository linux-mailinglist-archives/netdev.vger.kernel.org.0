Return-Path: <netdev+bounces-5203-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ED88E71036F
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 05:49:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A8AD1280A74
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 03:49:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C3171FB6;
	Thu, 25 May 2023 03:49:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65EC256C
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 03:48:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40B0FC433EF;
	Thu, 25 May 2023 03:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684986538;
	bh=00o0uwGQ8ox/biiXEMZzJvCgAnQWSW8pt8xGA1gWyCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sgTViUVEeeEUM2YmhwvaoSrzefzlYxLU/gQCy82vo3p+QfhbAlpKpU/d2myj1mpEV
	 MW/cXa5W6Tfo2AvdAFxE7079jhJgqbX9KAP+vwA9ysa/rmmOF18UhU7la0ftrIymt7
	 TbOZeGIUOxsFPIEmBDfa5oovV+cjYRGYJ35NMtH0FePru23M8Vp+a2h4F3grf8oX0S
	 4x6iE4julxpACPrqOoz2/1ijGnqZOTzqAtRipeezCbhc9HSwUHk+GLGqu4eRuNszNC
	 5kzQMSlVLhC/we76AelMBVmQdVwkFSg4otD9AtSkJ67vhUrLq7D0rcgjUuz4vMGnRo
	 rZKW2WxRNIqKg==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Maher Sanalla <msanalla@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>
Subject: [net 03/17] net/mlx5e: Consider internal buffers size in port buffer calculations
Date: Wed, 24 May 2023 20:48:33 -0700
Message-Id: <20230525034847.99268-4-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230525034847.99268-1-saeed@kernel.org>
References: <20230525034847.99268-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Maher Sanalla <msanalla@nvidia.com>

Currently, when a user triggers a change in port buffer headroom
(buffers 0-7), the driver checks that the requested headroom does
not exceed the total port buffer size. However, this check does not
take into account the internal buffers (buffers 8-9), which are also
part of the total port buffer. This can result in treating invalid port
buffer change requests as valid, causing unintended changes to the shared
buffer.

To address this, include the internal buffers size in the calculation of
available port buffer space which ensures that port buffer requests do not
exceed the correct limit.

Furthermore, remove internal buffers (8-9) size from the total_size
calculation as these buffers are reserved for internal use and are not
exposed to the user.

While at it, add verbosity to the debug prints in
mlx5e_port_query_buffer() function to ease future debugging.

Fixes: ecdf2dadee8e ("net/mlx5e: Receive buffer support for DCBX")
Signed-off-by: Maher Sanalla <msanalla@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en/port_buffer.c       | 42 ++++++++++++-------
 .../mellanox/mlx5/core/en/port_buffer.h       |  8 ++--
 .../ethernet/mellanox/mlx5/core/en_dcbnl.c    |  7 ++--
 3 files changed, 36 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c b/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c
index 7ac1ad9c46de..0d78527451bc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c
@@ -51,7 +51,7 @@ int mlx5e_port_query_buffer(struct mlx5e_priv *priv,
 	if (err)
 		goto out;
 
-	for (i = 0; i < MLX5E_MAX_BUFFER; i++) {
+	for (i = 0; i < MLX5E_MAX_NETWORK_BUFFER; i++) {
 		buffer = MLX5_ADDR_OF(pbmc_reg, out, buffer[i]);
 		port_buffer->buffer[i].lossy =
 			MLX5_GET(bufferx_reg, buffer, lossy);
@@ -73,14 +73,24 @@ int mlx5e_port_query_buffer(struct mlx5e_priv *priv,
 			  port_buffer->buffer[i].lossy);
 	}
 
-	port_buffer->headroom_size = total_used;
+	port_buffer->internal_buffers_size = 0;
+	for (i = MLX5E_MAX_NETWORK_BUFFER; i < MLX5E_TOTAL_BUFFERS; i++) {
+		buffer = MLX5_ADDR_OF(pbmc_reg, out, buffer[i]);
+		port_buffer->internal_buffers_size +=
+			MLX5_GET(bufferx_reg, buffer, size) * port_buff_cell_sz;
+	}
+
 	port_buffer->port_buffer_size =
 		MLX5_GET(pbmc_reg, out, port_buffer_size) * port_buff_cell_sz;
-	port_buffer->spare_buffer_size =
-		port_buffer->port_buffer_size - total_used;
-
-	mlx5e_dbg(HW, priv, "total buffer size=%d, spare buffer size=%d\n",
-		  port_buffer->port_buffer_size,
+	port_buffer->headroom_size = total_used;
+	port_buffer->spare_buffer_size = port_buffer->port_buffer_size -
+					 port_buffer->internal_buffers_size -
+					 port_buffer->headroom_size;
+
+	mlx5e_dbg(HW, priv,
+		  "total buffer size=%u, headroom buffer size=%u, internal buffers size=%u, spare buffer size=%u\n",
+		  port_buffer->port_buffer_size, port_buffer->headroom_size,
+		  port_buffer->internal_buffers_size,
 		  port_buffer->spare_buffer_size);
 out:
 	kfree(out);
@@ -206,11 +216,11 @@ static int port_update_pool_cfg(struct mlx5_core_dev *mdev,
 	if (!MLX5_CAP_GEN(mdev, sbcam_reg))
 		return 0;
 
-	for (i = 0; i < MLX5E_MAX_BUFFER; i++)
+	for (i = 0; i < MLX5E_MAX_NETWORK_BUFFER; i++)
 		lossless_buff_count += ((port_buffer->buffer[i].size) &&
 				       (!(port_buffer->buffer[i].lossy)));
 
-	for (i = 0; i < MLX5E_MAX_BUFFER; i++) {
+	for (i = 0; i < MLX5E_MAX_NETWORK_BUFFER; i++) {
 		p = select_sbcm_params(&port_buffer->buffer[i], lossless_buff_count);
 		err = mlx5e_port_set_sbcm(mdev, 0, i,
 					  MLX5_INGRESS_DIR,
@@ -293,7 +303,7 @@ static int port_set_buffer(struct mlx5e_priv *priv,
 	if (err)
 		goto out;
 
-	for (i = 0; i < MLX5E_MAX_BUFFER; i++) {
+	for (i = 0; i < MLX5E_MAX_NETWORK_BUFFER; i++) {
 		void *buffer = MLX5_ADDR_OF(pbmc_reg, in, buffer[i]);
 		u64 size = port_buffer->buffer[i].size;
 		u64 xoff = port_buffer->buffer[i].xoff;
@@ -351,7 +361,7 @@ static int update_xoff_threshold(struct mlx5e_port_buffer *port_buffer,
 {
 	int i;
 
-	for (i = 0; i < MLX5E_MAX_BUFFER; i++) {
+	for (i = 0; i < MLX5E_MAX_NETWORK_BUFFER; i++) {
 		if (port_buffer->buffer[i].lossy) {
 			port_buffer->buffer[i].xoff = 0;
 			port_buffer->buffer[i].xon  = 0;
@@ -408,7 +418,7 @@ static int update_buffer_lossy(struct mlx5_core_dev *mdev,
 	int err;
 	int i;
 
-	for (i = 0; i < MLX5E_MAX_BUFFER; i++) {
+	for (i = 0; i < MLX5E_MAX_NETWORK_BUFFER; i++) {
 		prio_count = 0;
 		lossy_count = 0;
 
@@ -515,7 +525,7 @@ int mlx5e_port_manual_buffer_config(struct mlx5e_priv *priv,
 
 	if (change & MLX5E_PORT_BUFFER_PRIO2BUFFER) {
 		update_prio2buffer = true;
-		for (i = 0; i < MLX5E_MAX_BUFFER; i++)
+		for (i = 0; i < MLX5E_MAX_NETWORK_BUFFER; i++)
 			mlx5e_dbg(HW, priv, "%s: requested to map prio[%d] to buffer %d\n",
 				  __func__, i, prio2buffer[i]);
 
@@ -530,7 +540,7 @@ int mlx5e_port_manual_buffer_config(struct mlx5e_priv *priv,
 	}
 
 	if (change & MLX5E_PORT_BUFFER_SIZE) {
-		for (i = 0; i < MLX5E_MAX_BUFFER; i++) {
+		for (i = 0; i < MLX5E_MAX_NETWORK_BUFFER; i++) {
 			mlx5e_dbg(HW, priv, "%s: buffer[%d]=%d\n", __func__, i, buffer_size[i]);
 			if (!port_buffer.buffer[i].lossy && !buffer_size[i]) {
 				mlx5e_dbg(HW, priv, "%s: lossless buffer[%d] size cannot be zero\n",
@@ -544,7 +554,9 @@ int mlx5e_port_manual_buffer_config(struct mlx5e_priv *priv,
 
 		mlx5e_dbg(HW, priv, "%s: total buffer requested=%d\n", __func__, total_used);
 
-		if (total_used > port_buffer.port_buffer_size)
+		if (total_used > port_buffer.headroom_size &&
+		    (total_used - port_buffer.headroom_size) >
+			    port_buffer.spare_buffer_size)
 			return -EINVAL;
 
 		update_buffer = true;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.h b/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.h
index a6ef118de758..f4a19ffbb641 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.h
@@ -35,7 +35,8 @@
 #include "en.h"
 #include "port.h"
 
-#define MLX5E_MAX_BUFFER 8
+#define MLX5E_MAX_NETWORK_BUFFER 8
+#define MLX5E_TOTAL_BUFFERS 10
 #define MLX5E_DEFAULT_CABLE_LEN 7 /* 7 meters */
 
 #define MLX5_BUFFER_SUPPORTED(mdev) (MLX5_CAP_GEN(mdev, pcam_reg) && \
@@ -60,8 +61,9 @@ struct mlx5e_bufferx_reg {
 struct mlx5e_port_buffer {
 	u32                       port_buffer_size;
 	u32                       spare_buffer_size;
-	u32                       headroom_size;
-	struct mlx5e_bufferx_reg  buffer[MLX5E_MAX_BUFFER];
+	u32                       headroom_size;	  /* Buffers 0-7 */
+	u32                       internal_buffers_size;  /* Buffers 8-9 */
+	struct mlx5e_bufferx_reg  buffer[MLX5E_MAX_NETWORK_BUFFER];
 };
 
 int mlx5e_port_manual_buffer_config(struct mlx5e_priv *priv,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
index 89de92d06483..ebee52a8361a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
@@ -926,9 +926,10 @@ static int mlx5e_dcbnl_getbuffer(struct net_device *dev,
 	if (err)
 		return err;
 
-	for (i = 0; i < MLX5E_MAX_BUFFER; i++)
+	for (i = 0; i < MLX5E_MAX_NETWORK_BUFFER; i++)
 		dcb_buffer->buffer_size[i] = port_buffer.buffer[i].size;
-	dcb_buffer->total_size = port_buffer.port_buffer_size;
+	dcb_buffer->total_size = port_buffer.port_buffer_size -
+				 port_buffer.internal_buffers_size;
 
 	return 0;
 }
@@ -970,7 +971,7 @@ static int mlx5e_dcbnl_setbuffer(struct net_device *dev,
 	if (err)
 		return err;
 
-	for (i = 0; i < MLX5E_MAX_BUFFER; i++) {
+	for (i = 0; i < MLX5E_MAX_NETWORK_BUFFER; i++) {
 		if (port_buffer.buffer[i].size != dcb_buffer->buffer_size[i]) {
 			changed |= MLX5E_PORT_BUFFER_SIZE;
 			buffer_size = dcb_buffer->buffer_size;
-- 
2.40.1



Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA585C2BD
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 20:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727207AbfGASOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 14:14:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:37338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725853AbfGASOp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jul 2019 14:14:45 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B9BD20B7C;
        Mon,  1 Jul 2019 18:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562004883;
        bh=C2K3onpVkhu6w6pZo99WHPU+233K511hcHqMI4ahYD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qfmqC8jAUWKEOak/3mLrVTVHeV7bv1Zsg/2KWGi6AxA8HTlJhX3b6owcoGBTifQvB
         0wI9Mlh0BZZ303Q+bCXfOWq+NUf7UY6FTHlshvhLwyi+6/G0EDtkKMoxX1e5nt+KNf
         opHg1DOG2VfaptB6NbgD5PhPvfLMynQkthWNpQhs=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Max Gurtovoy <maxg@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next 2/2] IB/mlx5: Implement VHCA tunnel mechanism in DEVX
Date:   Mon,  1 Jul 2019 21:14:02 +0300
Message-Id: <20190701181402.25286-3-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190701181402.25286-1-leon@kernel.org>
References: <20190701181402.25286-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Max Gurtovoy <maxg@mellanox.com>

This mechanism will allow function-A to perform operations "on behalf"
of function-B via tunnel object. Function-A will have privileges for
creating and using this tunnel object.

For example, in the device emulation feature presented in Bluefield-1 SoC,
using device emulation capability, one can present NVMe function to the host OS.

Since the NVMe function doesn't have a normal command interface to the HCA HW,
here is a need to create a channel that will be able to issue commands "on behalf"
of this function.

This channel is the VHCA_TUNNEL general object. The emulation software will create
this tunnel for every managed function and issue commands via devx general cmd
interface using the appropriate tunnel ID. When devX context will receive a command
with non-zero vhca_tunnel_id, it will pass the command as-is down to the HCA.

All the validation, security and resource tracking of the commands and the created
tunneled objects is in the responsibility of the HCA FW. When a VHCA_TUNNEL object
destroyed, the device will issue an internal FLR (function level reset) to the
emulated function associated with this tunnel. This will destroy all the created
resources using the tunnel mechanism.

Signed-off-by: Max Gurtovoy <maxg@mellanox.com>
Reviewed-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/devx.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index cb4f0fc79176..26ba6bf5d19a 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -894,12 +894,16 @@ static int devx_get_uid(struct mlx5_ib_ucontext *c, void *cmd_in)
 
 	return c->devx_uid;
 }
-static bool devx_is_general_cmd(void *in)
+
+static bool devx_is_general_cmd(void *in, struct mlx5_ib_dev *dev)
 {
 	u16 opcode = MLX5_GET(general_obj_in_cmd_hdr, in, opcode);
 
-	if (opcode >= MLX5_CMD_OP_GENERAL_START &&
-	    opcode < MLX5_CMD_OP_GENERAL_END)
+	/* Pass all cmds for vhca_tunnel as general, tracking is done in FW */
+	if ((MLX5_CAP_GEN_64(dev->mdev, vhca_tunnel_commands) &&
+	     MLX5_GET(general_obj_in_cmd_hdr, in, vhca_tunnel_id)) ||
+	    (opcode >= MLX5_CMD_OP_GENERAL_START &&
+	     opcode < MLX5_CMD_OP_GENERAL_END))
 		return true;
 
 	switch (opcode) {
@@ -1025,7 +1029,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OTHER)(
 		return uid;
 
 	/* Only white list of some general HCA commands are allowed for this method. */
-	if (!devx_is_general_cmd(cmd_in))
+	if (!devx_is_general_cmd(cmd_in, dev))
 		return -EINVAL;
 
 	cmd_out = uverbs_zalloc(attrs, cmd_out_len);
@@ -1420,6 +1424,9 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_CREATE)(
 	u32 obj_id;
 	u16 opcode;
 
+	if (MLX5_GET(general_obj_in_cmd_hdr, cmd_in, vhca_tunnel_id))
+		return -EINVAL;
+
 	uid = devx_get_uid(c, cmd_in);
 	if (uid < 0)
 		return uid;
@@ -1519,6 +1526,9 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_MODIFY)(
 	int err;
 	int uid;
 
+	if (MLX5_GET(general_obj_in_cmd_hdr, cmd_in, vhca_tunnel_id))
+		return -EINVAL;
+
 	uid = devx_get_uid(c, cmd_in);
 	if (uid < 0)
 		return uid;
@@ -1561,6 +1571,9 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_QUERY)(
 	int uid;
 	struct mlx5_ib_dev *mdev = to_mdev(c->ibucontext.device);
 
+	if (MLX5_GET(general_obj_in_cmd_hdr, cmd_in, vhca_tunnel_id))
+		return -EINVAL;
+
 	uid = devx_get_uid(c, cmd_in);
 	if (uid < 0)
 		return uid;
@@ -1698,6 +1711,9 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_ASYNC_QUERY)(
 	struct devx_async_cmd_event_file *ev_file;
 	struct devx_async_data *async_data;
 
+	if (MLX5_GET(general_obj_in_cmd_hdr, cmd_in, vhca_tunnel_id))
+		return -EINVAL;
+
 	uid = devx_get_uid(c, cmd_in);
 	if (uid < 0)
 		return uid;
-- 
2.20.1


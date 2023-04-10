Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9438F6DC731
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 15:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbjDJNNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 09:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbjDJNNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 09:13:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 255568689;
        Mon, 10 Apr 2023 06:13:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8DAB6126E;
        Mon, 10 Apr 2023 13:13:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91CF7C433EF;
        Mon, 10 Apr 2023 13:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681132411;
        bh=G3NT1IYDhuEZHl9HEeAqMWm7VNgm19yTVtpBKEDbIOI=;
        h=From:To:Cc:Subject:Date:From;
        b=Ix1/l0uDtt83XBROMSeJSKd9oKbWGKSXNe0vtZIfo+Dpk65uzT70+ev6UjIrhCv5S
         G7TKuSV6hTKMddXqiQIT2YE575bIzIM40NMZbsYSZHAQWqQc7sp7HbILpF1XAzhYFI
         usS+YaOl1t1mUy2qNk4MEhi0++a5Gy/RuwrmT3t2fKzKXjl2OcVpqdcC4B3VJOyyw0
         CBCULoJNMxfuZVi7V2dnrTXQPqUEQkgButWwa3AXsaXuXgP+f5YErfbnPy5XWXmTJX
         FJRXxlbK5Hcq2HIgku3WbQl4qyzS+R2wQ92GBYslOL5KUySlbDLN24YcUG64osh9i5
         duRQ/fKhEzgfQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Mark Bloch <mbloch@nvidia.com>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@nvidia.com>,
        Mark Bloch <markb@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@mellanox.com>
Subject: [PATCH rdma-next] RDMA/mlx5: Fix flow counter query via DEVX
Date:   Mon, 10 Apr 2023 16:13:26 +0300
Message-Id: <e164033f175225a5eb966f769694abdee0200fe2.1681132336.git.leon@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

Commit cited in "fixes" tag added bulk support for flow counters but it
didn't account that's also possible to query a counter using a non-base id
if the counter was allocated as bulk.

When a user performs a query, validate the flow counter id given in the
mailbox is inside the valid range taking bulk value into account.

Fixes: 208d70f562e5 ("IB/mlx5: Support flow counters offset for bulk counters")
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/devx.c | 31 ++++++++++++++++++++++++++-----
 include/linux/mlx5/mlx5_ifc.h     |  3 ++-
 2 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index 8b644df46fba..76384555b37e 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -666,7 +666,21 @@ static bool devx_is_valid_obj_id(struct uverbs_attr_bundle *attrs,
 				      obj_id;
 
 	case MLX5_IB_OBJECT_DEVX_OBJ:
-		return ((struct devx_obj *)uobj->object)->obj_id == obj_id;
+	{
+		u16 opcode = MLX5_GET(general_obj_in_cmd_hdr, in, opcode);
+		struct devx_obj *devx_uobj = uobj->object;
+
+		if (opcode == MLX5_CMD_OP_QUERY_FLOW_COUNTER &&
+		    devx_uobj->flow_counter_bulk_size) {
+			u32 end;
+
+			end = devx_uobj->obj_id +
+				devx_uobj->flow_counter_bulk_size;
+			return devx_uobj->obj_id <= obj_id && end > obj_id;
+		}
+
+		return devx_uobj->obj_id == obj_id;
+	}
 
 	default:
 		return false;
@@ -1517,10 +1531,17 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_CREATE)(
 		goto obj_free;
 
 	if (opcode == MLX5_CMD_OP_ALLOC_FLOW_COUNTER) {
-		u8 bulk = MLX5_GET(alloc_flow_counter_in,
-				   cmd_in,
-				   flow_counter_bulk);
-		obj->flow_counter_bulk_size = 128UL * bulk;
+		u32 bulk = MLX5_GET(alloc_flow_counter_in,
+				    cmd_in,
+				    flow_counter_bulk_log_size);
+
+		if (bulk)
+			bulk = 1 << bulk;
+		else
+			bulk = 128UL * MLX5_GET(alloc_flow_counter_in,
+						cmd_in,
+						flow_counter_bulk);
+		obj->flow_counter_bulk_size = bulk;
 	}
 
 	uobj->object = obj;
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index b54339a1b1c6..3976e6266bcc 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -9283,7 +9283,8 @@ struct mlx5_ifc_alloc_flow_counter_in_bits {
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
 
-	u8         reserved_at_40[0x38];
+	u8         reserved_at_40[0x33];
+	u8         flow_counter_bulk_log_size[0x5];
 	u8         flow_counter_bulk[0x8];
 };
 
-- 
2.39.2


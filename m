Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0274D543D46
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 22:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235858AbiFHUFh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 16:05:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbiFHUFb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 16:05:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 443F2374EE6;
        Wed,  8 Jun 2022 13:05:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EEB30B82AC0;
        Wed,  8 Jun 2022 20:05:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3AFAC34116;
        Wed,  8 Jun 2022 20:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654718727;
        bh=YUf1RPgOPQfuIq0KT9knZ2xE4fv4XzrMdhMkJrF99QY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dh+ewf5Y80pV2gD1trZ5EhG72NV8prgOvYke9nC0WA+qKqQMvOnqgeAGZYGKDM0nO
         a1dn8X0uvqucjTq13VQt1x9SQR025hUsfsCOw0TAIgfteIpmWchwylXWhs1ThbsYgZ
         bCuKmyXZn9zjXQrXWU+E3ZYOWUcUqTFbVf1EoJp8rcIBOIoj2foyhyIxLqx4DsZsFr
         x0lfOGbmCUovp7R+sal8r8qeRDxaWWHZpx8AXQYHAjL68X0JrBvjFFVLjVNTEzWNQZ
         jljEOVyPVHKyOkHHxXqTCGyrncqGi4zw9ChKPIYzFbIxDS8GfiXIArHOo2/sGgZIh7
         U0Y3ijWJd7fQg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, Jianbo Liu <jianbol@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: [PATCH mlx5-next 3/6] net/mlx5: Add support EXECUTE_ASO action for flow entry
Date:   Wed,  8 Jun 2022 13:04:49 -0700
Message-Id: <20220608200452.43880-4-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220608200452.43880-1-saeed@kernel.org>
References: <20220608200452.43880-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianbo Liu <jianbol@nvidia.com>

Attach flow meter to FTE with object id and index.
Use metadata register C5 to store the packet color meter result.

Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/fs_cmd.c  | 33 +++++++++++++++++++
 include/linux/mlx5/fs.h                       | 14 ++++++++
 2 files changed, 47 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
index 2ccf7bef9b05..735dc805dad7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -479,6 +479,30 @@ static int mlx5_set_extended_dest(struct mlx5_core_dev *dev,
 
 	return 0;
 }
+
+static void
+mlx5_cmd_set_fte_flow_meter(struct fs_fte *fte, void *in_flow_context)
+{
+	void *exe_aso_ctrl;
+	void *execute_aso;
+
+	execute_aso = MLX5_ADDR_OF(flow_context, in_flow_context,
+				   execute_aso[0]);
+	MLX5_SET(execute_aso, execute_aso, valid, 1);
+	MLX5_SET(execute_aso, execute_aso, aso_object_id,
+		 fte->action.exe_aso.object_id);
+
+	exe_aso_ctrl = MLX5_ADDR_OF(execute_aso, execute_aso, exe_aso_ctrl);
+	MLX5_SET(exe_aso_ctrl_flow_meter, exe_aso_ctrl, return_reg_id,
+		 fte->action.exe_aso.return_reg_id);
+	MLX5_SET(exe_aso_ctrl_flow_meter, exe_aso_ctrl, aso_type,
+		 fte->action.exe_aso.type);
+	MLX5_SET(exe_aso_ctrl_flow_meter, exe_aso_ctrl, init_color,
+		 fte->action.exe_aso.flow_meter.init_color);
+	MLX5_SET(exe_aso_ctrl_flow_meter, exe_aso_ctrl, meter_id,
+		 fte->action.exe_aso.flow_meter.meter_idx);
+}
+
 static int mlx5_cmd_set_fte(struct mlx5_core_dev *dev,
 			    int opmod, int modify_mask,
 			    struct mlx5_flow_table *ft,
@@ -663,6 +687,15 @@ static int mlx5_cmd_set_fte(struct mlx5_core_dev *dev,
 			 list_size);
 	}
 
+	if (fte->action.action & MLX5_FLOW_CONTEXT_ACTION_EXECUTE_ASO) {
+		if (fte->action.exe_aso.type == MLX5_EXE_ASO_FLOW_METER) {
+			mlx5_cmd_set_fte_flow_meter(fte, in_flow_context);
+		} else {
+			err = -EOPNOTSUPP;
+			goto err_out;
+		}
+	}
+
 	err = mlx5_cmd_exec(dev, in, inlen, out, sizeof(out));
 err_out:
 	kvfree(in);
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index 8135713b0d2d..ece3e35622d7 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -212,6 +212,19 @@ struct mlx5_flow_group *
 mlx5_create_flow_group(struct mlx5_flow_table *ft, u32 *in);
 void mlx5_destroy_flow_group(struct mlx5_flow_group *fg);
 
+struct mlx5_exe_aso {
+	u32 object_id;
+	u8 type;
+	u8 return_reg_id;
+	union {
+		u32 ctrl_data;
+		struct {
+			u8 meter_idx;
+			u8 init_color;
+		} flow_meter;
+	};
+};
+
 struct mlx5_fs_vlan {
         u16 ethtype;
         u16 vid;
@@ -237,6 +250,7 @@ struct mlx5_flow_act {
 	struct mlx5_fs_vlan vlan[MLX5_FS_VLAN_DEPTH];
 	struct ib_counters *counters;
 	struct mlx5_flow_group *fg;
+	struct mlx5_exe_aso exe_aso;
 };
 
 #define MLX5_DECLARE_FLOW_ACT(name) \
-- 
2.36.1


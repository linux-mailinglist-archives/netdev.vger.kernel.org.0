Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC56867169B
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 09:53:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbjARIxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 03:53:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbjARIwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 03:52:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 103809AAAB
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 00:04:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9357161512
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 08:04:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCA9BC433F0;
        Wed, 18 Jan 2023 08:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674029073;
        bh=/wqtILl+wrprfO6Mm2YFZna2PhJDHNaUqaRKix0Fj5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EngMJzn//JLKRSXvr66KWYlpS0KWn9n4JRXEKYlPJVZ1rbF1hs7MiHfjk93nDgefV
         xWKcQAsR8JavVTYxwkbxWprMOBh55m9WM9Cw5OjTY4PVERTW68HsqXaawEXICMd3YW
         pkQz0K4rWCtxcA/AXIGFe7hsw95bN8SlHmPSHGNCV/VPEZZwIwILfNhbxfv0ZFRCWO
         E0me7M+8bxoRwo+Jw5j+qN0Yi9X8GVx6NiX42fbKAb94s9p3QILawtzRK15bJ7Lg+A
         OjsbtrmIPQj18bxsYqYT3KksyasmVd0wNQn4jVaFkfwnfjhbbSsJYqeXvzFfet7hpk
         uTwaB3cL8oJog==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maor Dickman <maord@nvidia.com>, Eli Cohen <elic@nvidia.com>
Subject: [net 04/10] net/mlx5: E-switch, Fix setting of reserved fields on MODIFY_SCHEDULING_ELEMENT
Date:   Wed, 18 Jan 2023 00:04:08 -0800
Message-Id: <20230118080414.77902-5-saeed@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118080414.77902-1-saeed@kernel.org>
References: <20230118080414.77902-1-saeed@kernel.org>
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

From: Maor Dickman <maord@nvidia.com>

According to HW spec element_type, element_attributes and parent_element_id fields
should be reserved (0x0) when calling MODIFY_SCHEDULING_ELEMENT command.

This patch remove initialization of these fields when calling the command.

Fixes: bd77bf1cb595 ("net/mlx5: Add SRIOV VF max rate configuration support")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Eli Cohen <elic@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/esw/qos.c  | 18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
index 4f8a24d84a86..75015d370922 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
@@ -22,15 +22,13 @@ struct mlx5_esw_rate_group {
 };
 
 static int esw_qos_tsar_config(struct mlx5_core_dev *dev, u32 *sched_ctx,
-			       u32 parent_ix, u32 tsar_ix,
-			       u32 max_rate, u32 bw_share)
+			       u32 tsar_ix, u32 max_rate, u32 bw_share)
 {
 	u32 bitmask = 0;
 
 	if (!MLX5_CAP_GEN(dev, qos) || !MLX5_CAP_QOS(dev, esw_scheduling))
 		return -EOPNOTSUPP;
 
-	MLX5_SET(scheduling_context, sched_ctx, parent_element_id, parent_ix);
 	MLX5_SET(scheduling_context, sched_ctx, max_average_bw, max_rate);
 	MLX5_SET(scheduling_context, sched_ctx, bw_share, bw_share);
 	bitmask |= MODIFY_SCHEDULING_ELEMENT_IN_MODIFY_BITMASK_MAX_AVERAGE_BW;
@@ -51,7 +49,7 @@ static int esw_qos_group_config(struct mlx5_eswitch *esw, struct mlx5_esw_rate_g
 	int err;
 
 	err = esw_qos_tsar_config(dev, sched_ctx,
-				  esw->qos.root_tsar_ix, group->tsar_ix,
+				  group->tsar_ix,
 				  max_rate, bw_share);
 	if (err)
 		NL_SET_ERR_MSG_MOD(extack, "E-Switch modify group TSAR element failed");
@@ -67,23 +65,13 @@ static int esw_qos_vport_config(struct mlx5_eswitch *esw,
 				struct netlink_ext_ack *extack)
 {
 	u32 sched_ctx[MLX5_ST_SZ_DW(scheduling_context)] = {};
-	struct mlx5_esw_rate_group *group = vport->qos.group;
 	struct mlx5_core_dev *dev = esw->dev;
-	u32 parent_tsar_ix;
-	void *vport_elem;
 	int err;
 
 	if (!vport->qos.enabled)
 		return -EIO;
 
-	parent_tsar_ix = group ? group->tsar_ix : esw->qos.root_tsar_ix;
-	MLX5_SET(scheduling_context, sched_ctx, element_type,
-		 SCHEDULING_CONTEXT_ELEMENT_TYPE_VPORT);
-	vport_elem = MLX5_ADDR_OF(scheduling_context, sched_ctx,
-				  element_attributes);
-	MLX5_SET(vport_element, vport_elem, vport_number, vport->vport);
-
-	err = esw_qos_tsar_config(dev, sched_ctx, parent_tsar_ix, vport->qos.esw_tsar_ix,
+	err = esw_qos_tsar_config(dev, sched_ctx, vport->qos.esw_tsar_ix,
 				  max_rate, bw_share);
 	if (err) {
 		esw_warn(esw->dev,
-- 
2.39.0


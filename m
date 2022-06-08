Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCEA6543BE3
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 20:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233318AbiFHS7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 14:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233196AbiFHS7V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 14:59:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CD133BA6E
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 11:59:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCD5B61C41
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 18:59:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F38FC3411F;
        Wed,  8 Jun 2022 18:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654714759;
        bh=yOAWfabL83Mjvda7PA3KxosLj+h/CAYtx2RebVvEe10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c0ULr6reBciv6+0l71PiN/xoj0NWo+456/oVpWSJIBeLiI2AyEvmlx6In8jhcqj74
         Y1yfhq7ss0q0rb1DH+/hcVLtyKEhpFUzIWWsIYKmAH7UVtVs6ARPwSBQIr0uDGO9gr
         F9DZ+oOZz38w6C8W97ildfZUdycyi45hwP2xI/WWfoRKnNLFKC3Q1Qr5H+nGMDDb8T
         SBETZnrrwr3557aHHf3ex0kvURl97Wa7PXg292UNK/N6/ESWf5BhYmwTEmkwEBQXwY
         rmMUEdODw8PpVluEvzdguJEhC3GeOEEceQGZYmEwTSAciJMct5Bc70Fg7olpbDzmub
         zOKV7P9TsNLpA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, Feras Daoud <ferasda@nvidia.com>,
        Roy Novich <royno@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 5/6] net/mlx5: Rearm the FW tracer after each tracer event
Date:   Wed,  8 Jun 2022 11:58:54 -0700
Message-Id: <20220608185855.19818-6-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220608185855.19818-1-saeed@kernel.org>
References: <20220608185855.19818-1-saeed@kernel.org>
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

From: Feras Daoud <ferasda@nvidia.com>

The current design does not arm the tracer if traces are available before
the tracer string database is fully loaded, leading to an unfunctional tracer.
This fix will rearm the tracer every time the FW triggers tracer event
regardless of the tracer strings database status.

Fixes: c71ad41ccb0c ("net/mlx5: FW tracer, events handling")
Signed-off-by: Feras Daoud <ferasda@nvidia.com>
Signed-off-by: Roy Novich <royno@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index eae9aa9c0811..978a2bb8e122 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -675,6 +675,9 @@ static void mlx5_fw_tracer_handle_traces(struct work_struct *work)
 	if (!tracer->owner)
 		return;
 
+	if (unlikely(!tracer->str_db.loaded))
+		goto arm;
+
 	block_count = tracer->buff.size / TRACER_BLOCK_SIZE_BYTE;
 	start_offset = tracer->buff.consumer_index * TRACER_BLOCK_SIZE_BYTE;
 
@@ -732,6 +735,7 @@ static void mlx5_fw_tracer_handle_traces(struct work_struct *work)
 						      &tmp_trace_block[TRACES_PER_BLOCK - 1]);
 	}
 
+arm:
 	mlx5_fw_tracer_arm(dev);
 }
 
@@ -1136,8 +1140,7 @@ static int fw_tracer_event(struct notifier_block *nb, unsigned long action, void
 		queue_work(tracer->work_queue, &tracer->ownership_change_work);
 		break;
 	case MLX5_TRACER_SUBTYPE_TRACES_AVAILABLE:
-		if (likely(tracer->str_db.loaded))
-			queue_work(tracer->work_queue, &tracer->handle_traces_work);
+		queue_work(tracer->work_queue, &tracer->handle_traces_work);
 		break;
 	default:
 		mlx5_core_dbg(dev, "FWTracer: Event with unrecognized subtype: sub_type %d\n",
-- 
2.36.1


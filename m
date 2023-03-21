Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5410F6C3C76
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 22:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbjCUVLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 17:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbjCUVLn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 17:11:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B2EE580C9
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 14:11:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B84D5B81A38
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 21:11:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FD11C4339C;
        Tue, 21 Mar 2023 21:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679433099;
        bh=Twx5nMntdov5Sr5FRJHNDHqm4xHonNtpjb3YVJp2yWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qyLIxgCv2JOb/igWthzKRu6YA41NS7FlUdrknZLDROEXVn55l3HF17GU/aMNoWL1A
         PIxMoFWH6BeaBdtsnNe/Nwq0lcoHmhY25ramZw+sJ0yF8OJF1t8ZhEFLte+IQRMP6p
         vC59JT0wo6L2OBCQj1ak2iUtO0SPl2+gXZ7JZn0zKQgsAJIxj4YFJRwgniBKX68DUS
         Qk/pbCY8CZO/k6OGFvgxJ3toor3/dpWyMx9POSu2A6GnNVdY5fhX6ohD8/pItEVhMl
         gbq4/ORdRMZgj5zuj7i7Ld7RNfZcMxw+cwH0TQ3IFJio0tR5d/Goz0X4RocSEKdr0e
         g/SNyvFNsMOjA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Lama Kayal <lkayal@nvidia.com>, Huy Nguyen <huyn@mellanox.com>,
        Maor Dickman <maord@nvidia.com>
Subject: [net 3/7] net/mlx5: Fix steering rules cleanup
Date:   Tue, 21 Mar 2023 14:11:31 -0700
Message-Id: <20230321211135.47711-4-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230321211135.47711-1-saeed@kernel.org>
References: <20230321211135.47711-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lama Kayal <lkayal@nvidia.com>

vport's mc, uc and multicast rules are not deleted in teardown path when
EEH happens. Since the vport's promisc settings(uc, mc and all) in
firmware are reset after EEH, mlx5 driver will try to delete the above
rules in the initialization path. This cause kernel crash because these
software rules are no longer valid.

Fix by nullifying these rules right after delete to avoid accessing any dangling
pointers.

Call Trace:
__list_del_entry_valid+0xcc/0x100 (unreliable)
tree_put_node+0xf4/0x1b0 [mlx5_core]
tree_remove_node+0x30/0x70 [mlx5_core]
mlx5_del_flow_rules+0x14c/0x1f0 [mlx5_core]
esw_apply_vport_rx_mode+0x10c/0x200 [mlx5_core]
esw_update_vport_rx_mode+0xb4/0x180 [mlx5_core]
esw_vport_change_handle_locked+0x1ec/0x230 [mlx5_core]
esw_enable_vport+0x130/0x260 [mlx5_core]
mlx5_eswitch_enable_sriov+0x2a0/0x2f0 [mlx5_core]
mlx5_device_enable_sriov+0x74/0x440 [mlx5_core]
mlx5_load_one+0x114c/0x1550 [mlx5_core]
mlx5_pci_resume+0x68/0xf0 [mlx5_core]
eeh_report_resume+0x1a4/0x230
eeh_pe_dev_traverse+0x98/0x170
eeh_handle_normal_event+0x3e4/0x640
eeh_handle_event+0x4c/0x370
eeh_event_handler+0x14c/0x210
kthread+0x168/0x1b0
ret_from_kernel_thread+0x5c/0x84

Fixes: a35f71f27a61 ("net/mlx5: E-Switch, Implement promiscuous rx modes vf request handling")
Signed-off-by: Huy Nguyen <huyn@mellanox.com>
Signed-off-by: Lama Kayal <lkayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 0f052513fefa..8bdf28762f41 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -959,6 +959,7 @@ void mlx5_esw_vport_disable(struct mlx5_eswitch *esw, u16 vport_num)
 	 */
 	esw_vport_change_handle_locked(vport);
 	vport->enabled_events = 0;
+	esw_apply_vport_rx_mode(esw, vport, false, false);
 	esw_vport_cleanup(esw, vport);
 	esw->enabled_vports--;
 
-- 
2.39.2


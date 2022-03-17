Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19E6F4DCE31
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 19:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235402AbiCQS4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 14:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237734AbiCQSzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 14:55:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45DAF165A83
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 11:54:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D754C617AF
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 18:54:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9F8C340F4;
        Thu, 17 Mar 2022 18:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647543275;
        bh=Qxq6bFQqs97ZGol2Bl4IAnUjZc2GO9IEYORGx8CyF1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ei4s9ZRPjVHI6w8xoxPjIiXs/14EQRFRqcjugR1Tljgqae2k2Op0HcdK4NeadvyIE
         MBCgi69amykYRhX4ZDxNrw67UWPKsfSb35AemIUHZIcDwTph7C8cM0nQOlpE1zer2A
         K353uaWdecsMkXMjzQJLzR6GJy66AZtqzv6V9VzdhH7xnpNuykQqrgU1WlJbbsqrHU
         US/YTEcdc3JYj+Ej2T0akSPqDgvJyfQKCQmOXvljPN9APKMohg78sLf/ooc0Ql1gbq
         0rkFbii39RQl+tufz8o8o8f8XZ4UtjzmBpRkwFP0TFQBEXaAWyEeAdVDUxOrSV0zYi
         95NnD5eXazdcQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Paul Blakey <paulb@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 13/15] net/mlx5: CT: Remove extra rhashtable remove on tuple entries
Date:   Thu, 17 Mar 2022 11:54:22 -0700
Message-Id: <20220317185424.287982-14-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220317185424.287982-1-saeed@kernel.org>
References: <20220317185424.287982-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@nvidia.com>

On tuple offload del command, tuples are tried to be removed twice
from the hashtable, once directly via mlx5_tc_ct_entry_remove_from_tuples()
and a second time in the following mlx5_tc_ct_entry_put()->
mlx5_tc_ct_entry_del()->mlx5_tc_ct_entry_remove_from_tuples() call.

This doesn't cause any issue since rhashtable first checks if the
removed object exists in the hashtable.

Remove the extra mlx5_tc_ct_entry_remove_from_tuples().

Signed-off-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 7db9d8ee1304..e49f51124c74 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -1161,7 +1161,6 @@ mlx5_tc_ct_block_flow_offload_del(struct mlx5_ct_ft *ft,
 	}
 
 	rhashtable_remove_fast(&ft->ct_entries_ht, &entry->node, cts_ht_params);
-	mlx5_tc_ct_entry_remove_from_tuples(entry);
 	spin_unlock_bh(&ct_priv->ht_lock);
 
 	mlx5_tc_ct_entry_put(entry);
-- 
2.35.1


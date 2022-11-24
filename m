Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73DA9637362
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 09:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbiKXILI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 03:11:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbiKXIK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 03:10:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF12CD288A
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 00:10:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90C5AB82707
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 08:10:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C4E0C433B5;
        Thu, 24 Nov 2022 08:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669277457;
        bh=5rTKcF6/qwc5q27UOblKbaetpAx8IkqNhItlrk7mFPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oXM8dUvZ27o4OybVgth+dPORfUyNOa6Xi2H9rXWXgTQZ4z2xB4LxFXBNZ+9ojW9cD
         p+vS7jm6q3EHF0shzlfgRALnDfxbqEzMKncVehwnCYTrjGUsTQUZPMflxHsqc9+KcV
         rlpmiYLJM58QrSNItb/E7AzN0SVtGwAYE3CsVnDAo79ulV3KXPOFx0T5CRhq4fP2UE
         8hbtDxJkO/P3d9uL/q+yIkyzJT+W9Cef+StGchDHPVYbRoQD4O2SOtGEXYhhl+k5aK
         n12/BDWyHPd52iI6aRtxeZifz6tfgkJIOtbQgBfkggIGgwYtKn3icQ4NV6qKYsetab
         HaxhyxxQ1KCGg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
Subject: [net 05/15] net/mlx5e: Fix use-after-free when reverting termination table
Date:   Thu, 24 Nov 2022 00:10:30 -0800
Message-Id: <20221124081040.171790-6-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221124081040.171790-1-saeed@kernel.org>
References: <20221124081040.171790-1-saeed@kernel.org>
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

From: Roi Dayan <roid@nvidia.com>

When having multiple dests with termination tables and second one
or afterwards fails the driver reverts usage of term tables but
doesn't reset the assignment in attr->dests[num_vport_dests].termtbl
which case a use-after-free when releasing the rule.
Fix by resetting the assignment of termtbl to null.

Fixes: 10caabdaad5a ("net/mlx5e: Use termination table for VLAN push actions")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c  | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
index 108a3503f413..edd910258314 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
@@ -312,6 +312,8 @@ mlx5_eswitch_add_termtbl_rule(struct mlx5_eswitch *esw,
 	for (curr_dest = 0; curr_dest < num_vport_dests; curr_dest++) {
 		struct mlx5_termtbl_handle *tt = attr->dests[curr_dest].termtbl;
 
+		attr->dests[curr_dest].termtbl = NULL;
+
 		/* search for the destination associated with the
 		 * current term table
 		 */
-- 
2.38.1


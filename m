Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41F476232B1
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 19:41:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231430AbiKISlS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 13:41:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiKISlL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 13:41:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D642423388
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 10:41:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7147061C83
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 18:41:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB8E4C433D7;
        Wed,  9 Nov 2022 18:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668019263;
        bh=vAkypedKlZ3hkUYFp8HkhmpJtFtYnCgDV62TmejftdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=djcpWUYWAGDRQ62dKaD90jnpxiHeVq5VxtaZUBbYxRstF/B1hwIjDGfk4krYgxnXq
         QUINZ9rxVxVYRSQIPsIeD0cCNz+IF5GzmZhfmEpDDB+oHLhPFsfaIgEKZM6rEFfgC/
         fjwRFT9ZFd1eLaHwn4mpDGkj8SBHpA9A10PKdK/BBFd8aMepeP6Y1+rMGs846PK1Gt
         +FnRzU6DkNQJOy5kcDFjPhaT83mbJVMqUJn6fBzRG9Be4f6PB8T8QPIfkhHuACPUxx
         fSMeb7oQQ5FwEEaTeHTo4QNKKGhIFTRW1zdEEkOslrvY3Nc0zAcdzS3FIW8VjHjLql
         PN2kH/lUZav2g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
Subject: [V3 net 07/10] net/mlx5e: Fix tc acts array not to be dependent on enum order
Date:   Wed,  9 Nov 2022 10:40:47 -0800
Message-Id: <20221109184050.108379-8-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221109184050.108379-1-saeed@kernel.org>
References: <20221109184050.108379-1-saeed@kernel.org>
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

The tc acts array should not be dependent on kernel internal
flow action id enum. Fix the array initialization.

Fixes: fad547906980 ("net/mlx5e: Add tc action infrastructure")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en/tc/act/act.c        | 92 +++++++------------
 1 file changed, 32 insertions(+), 60 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
index 305fde62a78d..3337241cfd84 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
@@ -6,70 +6,42 @@
 #include "en/tc_priv.h"
 #include "mlx5_core.h"
 
-/* Must be aligned with enum flow_action_id. */
 static struct mlx5e_tc_act *tc_acts_fdb[NUM_FLOW_ACTIONS] = {
-	&mlx5e_tc_act_accept,
-	&mlx5e_tc_act_drop,
-	&mlx5e_tc_act_trap,
-	&mlx5e_tc_act_goto,
-	&mlx5e_tc_act_mirred,
-	&mlx5e_tc_act_mirred,
-	&mlx5e_tc_act_redirect_ingress,
-	NULL, /* FLOW_ACTION_MIRRED_INGRESS, */
-	&mlx5e_tc_act_vlan,
-	&mlx5e_tc_act_vlan,
-	&mlx5e_tc_act_vlan_mangle,
-	&mlx5e_tc_act_tun_encap,
-	&mlx5e_tc_act_tun_decap,
-	&mlx5e_tc_act_pedit,
-	&mlx5e_tc_act_pedit,
-	&mlx5e_tc_act_csum,
-	NULL, /* FLOW_ACTION_MARK, */
-	&mlx5e_tc_act_ptype,
-	NULL, /* FLOW_ACTION_PRIORITY, */
-	NULL, /* FLOW_ACTION_WAKE, */
-	NULL, /* FLOW_ACTION_QUEUE, */
-	&mlx5e_tc_act_sample,
-	&mlx5e_tc_act_police,
-	&mlx5e_tc_act_ct,
-	NULL, /* FLOW_ACTION_CT_METADATA, */
-	&mlx5e_tc_act_mpls_push,
-	&mlx5e_tc_act_mpls_pop,
-	NULL, /* FLOW_ACTION_MPLS_MANGLE, */
-	NULL, /* FLOW_ACTION_GATE, */
-	NULL, /* FLOW_ACTION_PPPOE_PUSH, */
-	NULL, /* FLOW_ACTION_JUMP, */
-	NULL, /* FLOW_ACTION_PIPE, */
-	&mlx5e_tc_act_vlan,
-	&mlx5e_tc_act_vlan,
+	[FLOW_ACTION_ACCEPT] = &mlx5e_tc_act_accept,
+	[FLOW_ACTION_DROP] = &mlx5e_tc_act_drop,
+	[FLOW_ACTION_TRAP] = &mlx5e_tc_act_trap,
+	[FLOW_ACTION_GOTO] = &mlx5e_tc_act_goto,
+	[FLOW_ACTION_REDIRECT] = &mlx5e_tc_act_mirred,
+	[FLOW_ACTION_MIRRED] = &mlx5e_tc_act_mirred,
+	[FLOW_ACTION_REDIRECT_INGRESS] = &mlx5e_tc_act_redirect_ingress,
+	[FLOW_ACTION_VLAN_PUSH] = &mlx5e_tc_act_vlan,
+	[FLOW_ACTION_VLAN_POP] = &mlx5e_tc_act_vlan,
+	[FLOW_ACTION_VLAN_MANGLE] = &mlx5e_tc_act_vlan_mangle,
+	[FLOW_ACTION_TUNNEL_ENCAP] = &mlx5e_tc_act_tun_encap,
+	[FLOW_ACTION_TUNNEL_DECAP] = &mlx5e_tc_act_tun_decap,
+	[FLOW_ACTION_MANGLE] = &mlx5e_tc_act_pedit,
+	[FLOW_ACTION_ADD] = &mlx5e_tc_act_pedit,
+	[FLOW_ACTION_CSUM] = &mlx5e_tc_act_csum,
+	[FLOW_ACTION_PTYPE] = &mlx5e_tc_act_ptype,
+	[FLOW_ACTION_SAMPLE] = &mlx5e_tc_act_sample,
+	[FLOW_ACTION_POLICE] = &mlx5e_tc_act_police,
+	[FLOW_ACTION_CT] = &mlx5e_tc_act_ct,
+	[FLOW_ACTION_MPLS_PUSH] = &mlx5e_tc_act_mpls_push,
+	[FLOW_ACTION_MPLS_POP] = &mlx5e_tc_act_mpls_pop,
+	[FLOW_ACTION_VLAN_PUSH_ETH] = &mlx5e_tc_act_vlan,
+	[FLOW_ACTION_VLAN_POP_ETH] = &mlx5e_tc_act_vlan,
 };
 
-/* Must be aligned with enum flow_action_id. */
 static struct mlx5e_tc_act *tc_acts_nic[NUM_FLOW_ACTIONS] = {
-	&mlx5e_tc_act_accept,
-	&mlx5e_tc_act_drop,
-	NULL, /* FLOW_ACTION_TRAP, */
-	&mlx5e_tc_act_goto,
-	&mlx5e_tc_act_mirred_nic,
-	NULL, /* FLOW_ACTION_MIRRED, */
-	NULL, /* FLOW_ACTION_REDIRECT_INGRESS, */
-	NULL, /* FLOW_ACTION_MIRRED_INGRESS, */
-	NULL, /* FLOW_ACTION_VLAN_PUSH, */
-	NULL, /* FLOW_ACTION_VLAN_POP, */
-	NULL, /* FLOW_ACTION_VLAN_MANGLE, */
-	NULL, /* FLOW_ACTION_TUNNEL_ENCAP, */
-	NULL, /* FLOW_ACTION_TUNNEL_DECAP, */
-	&mlx5e_tc_act_pedit,
-	&mlx5e_tc_act_pedit,
-	&mlx5e_tc_act_csum,
-	&mlx5e_tc_act_mark,
-	NULL, /* FLOW_ACTION_PTYPE, */
-	NULL, /* FLOW_ACTION_PRIORITY, */
-	NULL, /* FLOW_ACTION_WAKE, */
-	NULL, /* FLOW_ACTION_QUEUE, */
-	NULL, /* FLOW_ACTION_SAMPLE, */
-	NULL, /* FLOW_ACTION_POLICE, */
-	&mlx5e_tc_act_ct,
+	[FLOW_ACTION_ACCEPT] = &mlx5e_tc_act_accept,
+	[FLOW_ACTION_DROP] = &mlx5e_tc_act_drop,
+	[FLOW_ACTION_GOTO] = &mlx5e_tc_act_goto,
+	[FLOW_ACTION_REDIRECT] = &mlx5e_tc_act_mirred_nic,
+	[FLOW_ACTION_MANGLE] = &mlx5e_tc_act_pedit,
+	[FLOW_ACTION_ADD] = &mlx5e_tc_act_pedit,
+	[FLOW_ACTION_CSUM] = &mlx5e_tc_act_csum,
+	[FLOW_ACTION_MARK] = &mlx5e_tc_act_mark,
+	[FLOW_ACTION_CT] = &mlx5e_tc_act_ct,
 };
 
 /**
-- 
2.38.1


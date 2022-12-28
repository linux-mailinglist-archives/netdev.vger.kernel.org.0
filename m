Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59D3C658683
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 20:44:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232770AbiL1Tn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 14:43:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232797AbiL1Tnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 14:43:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1E182197
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 11:43:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B927615FF
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 19:43:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A98A3C433EF;
        Wed, 28 Dec 2022 19:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672256627;
        bh=PDOINy257e58jZjB2X4ZcchzdU764ICmFQy0iImsteU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SEwfPoJh91rcvmqAgK7Hkh60fug0hftuOpDhJqF4GkZMpqK3SdrYilRioFZMmWSKT
         7ATXTZHa6894tzU9JGm6cC2+U3ModG8g6GkQpzX6KCWgqn5wK2CsiaGqq9Hvnr3TZx
         r1tqpam0ePOXJP96XJCgQ1DLUkeAWC/bBbWAg2yqEY/pmidpxHD0Dj+iWo2oie9+Dy
         mUZ/vA/JfFgfPyZz0eNyCBZLctbs5rWdv1wrvAw5XDzJd+BFe9Ou3r4UPu+bRpjPRt
         PIZLAC78DqFcNXn1rTdjfW7jmswK3M0ZqPR3Ha19B1S6GG2b24Iw/yygaKN6KMp6OT
         yEYCzXwytExIQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Chris Mi <cmi@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: [net 09/12] net/mlx5e: Always clear dest encap in neigh-update-del
Date:   Wed, 28 Dec 2022 11:43:28 -0800
Message-Id: <20221228194331.70419-10-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221228194331.70419-1-saeed@kernel.org>
References: <20221228194331.70419-1-saeed@kernel.org>
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

From: Chris Mi <cmi@nvidia.com>

The cited commit introduced a bug for multiple encapsulations flow.
If one dest encap becomes invalid, the flow is set slow path flag.
But when other dests encap become invalid, they are not cleared due
to slow path flag of the flow. When neigh-update-add is running, it
will use invalid encap.

Fix it by checking slow path flag after clearing dest encap.

Fixes: 9a5f9cc794e1 ("net/mlx5e: Fix possible use-after-free deleting fdb rule")
Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c    | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
index ff73d25bc6eb..2aaf8ab857b8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
@@ -222,7 +222,7 @@ void mlx5e_tc_encap_flows_del(struct mlx5e_priv *priv,
 	int err;
 
 	list_for_each_entry(flow, flow_list, tmp_list) {
-		if (!mlx5e_is_offloaded_flow(flow) || flow_flag_test(flow, SLOW))
+		if (!mlx5e_is_offloaded_flow(flow))
 			continue;
 
 		attr = mlx5e_tc_get_encap_attr(flow);
@@ -231,6 +231,13 @@ void mlx5e_tc_encap_flows_del(struct mlx5e_priv *priv,
 		esw_attr->dests[flow->tmp_entry_index].flags &= ~MLX5_ESW_DEST_ENCAP_VALID;
 		esw_attr->dests[flow->tmp_entry_index].pkt_reformat = NULL;
 
+		/* Clear pkt_reformat before checking slow path flag. Because
+		 * in next iteration, the same flow is already set slow path
+		 * flag, but still need to clear the pkt_reformat.
+		 */
+		if (flow_flag_test(flow, SLOW))
+			continue;
+
 		/* update from encap rule to slow path rule */
 		spec = &flow->attr->parse_attr->spec;
 		rule = mlx5e_tc_offload_to_slow_path(esw, flow, spec);
-- 
2.38.1


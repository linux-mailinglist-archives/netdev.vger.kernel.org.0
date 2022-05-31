Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 866BE539846
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 22:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245557AbiEaUzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 16:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243614AbiEaUzK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 16:55:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CABE9CF70
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 13:55:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9E8AB816C2
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 20:55:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68BCEC385A9;
        Tue, 31 May 2022 20:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654030506;
        bh=ECVlp65srEIF//U2JWelhm55gRikYfdKWmIzvRcIdc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O7OJmxmXRQ+vJZCiiCPKP67Rs71T/l5Qac1NAMz6RRqllTWBKgNt60qNIsCsQKaw+
         3gDuIYyGcGUc/wlixX0aFV7gDv9ORdvR8emfA2X4d07uu6m542ZR/ql5nGKDvlzkDD
         CpOA+68QHPdiFJ6mHLAl6UJg2VAGNKeHqkH4UcNrQRG6IRCwtPdN6LcbuoEIQBLzl9
         Ch1itgY+sYif0XxFc/CcirKG0Fwzh+OzU1GY4Bobiu7dH73KPuSu6uU1A5h9e8ZpMz
         sxMLCcJhsyvI9BzXF0HYmJPMugDJ+VTFCn50Tbn3DKGO5b7I9FPz6rrZ73QCWpXabz
         JI6amXJWJIkjg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Paul Blakey <paulb@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 3/7] net/mlx5: CT: Fix header-rewrite re-use for tupels
Date:   Tue, 31 May 2022 13:54:43 -0700
Message-Id: <20220531205447.99236-4-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220531205447.99236-1-saeed@kernel.org>
References: <20220531205447.99236-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@nvidia.com>

Tuple entries that don't have nat configured for them
which are added to the ct nat table will always create
a new modify header, as we don't check for possible
re-use on them. The same for tuples that have nat configured
for them but are added to ct table.

Fix the above by only avoiding wasteful re-use lookup
for actually natted entries in ct nat table.

Fixes: 7fac5c2eced3 ("net/mlx5: CT: Avoid reusing modify header context for natted entries")
Signed-off-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Ariel Levkovich <lariel@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index bceea7a1589e..25f51f80a9b4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -715,7 +715,7 @@ mlx5_tc_ct_entry_create_mod_hdr(struct mlx5_tc_ct_priv *ct_priv,
 				struct mlx5_flow_attr *attr,
 				struct flow_rule *flow_rule,
 				struct mlx5e_mod_hdr_handle **mh,
-				u8 zone_restore_id, bool nat)
+				u8 zone_restore_id, bool nat_table, bool has_nat)
 {
 	DECLARE_MOD_HDR_ACTS_ACTIONS(actions_arr, MLX5_CT_MIN_MOD_ACTS);
 	DECLARE_MOD_HDR_ACTS(mod_acts, actions_arr);
@@ -731,11 +731,12 @@ mlx5_tc_ct_entry_create_mod_hdr(struct mlx5_tc_ct_priv *ct_priv,
 				     &attr->ct_attr.ct_labels_id);
 	if (err)
 		return -EOPNOTSUPP;
-	if (nat) {
-		err = mlx5_tc_ct_entry_create_nat(ct_priv, flow_rule,
-						  &mod_acts);
-		if (err)
-			goto err_mapping;
+	if (nat_table) {
+		if (has_nat) {
+			err = mlx5_tc_ct_entry_create_nat(ct_priv, flow_rule, &mod_acts);
+			if (err)
+				goto err_mapping;
+		}
 
 		ct_state |= MLX5_CT_STATE_NAT_BIT;
 	}
@@ -750,7 +751,7 @@ mlx5_tc_ct_entry_create_mod_hdr(struct mlx5_tc_ct_priv *ct_priv,
 	if (err)
 		goto err_mapping;
 
-	if (nat) {
+	if (nat_table && has_nat) {
 		attr->modify_hdr = mlx5_modify_header_alloc(ct_priv->dev, ct_priv->ns_type,
 							    mod_acts.num_actions,
 							    mod_acts.actions);
@@ -818,7 +819,9 @@ mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
 
 	err = mlx5_tc_ct_entry_create_mod_hdr(ct_priv, attr, flow_rule,
 					      &zone_rule->mh,
-					      zone_restore_id, nat);
+					      zone_restore_id,
+					      nat,
+					      mlx5_tc_ct_entry_has_nat(entry));
 	if (err) {
 		ct_dbg("Failed to create ct entry mod hdr");
 		goto err_mod_hdr;
-- 
2.36.1


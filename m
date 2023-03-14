Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4D776B8ABA
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 06:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbjCNFn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 01:43:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbjCNFnQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 01:43:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5A151A4B6
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 22:42:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61328615DE
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 05:42:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFDC2C4339B;
        Tue, 14 Mar 2023 05:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678772576;
        bh=Bd2jRnbD1ln1Zn7JgDQtwouyEC3jn8XIrTW7RKbJsWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qFbjs8TnPD7af1YmJU3jrApM1TadvtujmsHXJYZ4bQcI/1FAm4lTNKxfkzpkPmU0D
         nvUvrta2CFRPma+yrO1J0YWOQ2Lg5fPSv2gkHu9at2ZCIX+Y5m+1oiqzL1ojeY4yAY
         EUfdM3E95/zFbLTR8Y/iJ3BcpVvQ0R3S/ngBNZ7Fc+nxwrtUniz0CnQCH0d0UF3HaK
         qk2+VX2AcnEyGuPnyh/Wk51MkOXoKYvot1670fAhCTPmimbh1jjmiFlDsflFZjX2MO
         GqaOZV4GIMEEMtsEFsO+2Hh3CwcGBK51yCStjayZyF1J37OGDCztUlqnK/8BP5MK6O
         MgtYtsremL8ug==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maor Dickman <maord@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [net-next 13/15] net/mlx5e: TC, Extract indr setup block checks to function
Date:   Mon, 13 Mar 2023 22:42:32 -0700
Message-Id: <20230314054234.267365-14-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314054234.267365-1-saeed@kernel.org>
References: <20230314054234.267365-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

In preparation for next patch which will add new check
if device block can be setup, extract all existing checks
to function to make it more readable and maintainable.

Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/rep/tc.c   | 58 ++++++++++++-------
 1 file changed, 36 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index 8f7452dc00ee..b4af006dc494 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -426,39 +426,53 @@ static bool mlx5e_rep_macvlan_mode_supported(const struct net_device *dev)
 	return macvlan->mode == MACVLAN_MODE_PASSTHRU;
 }
 
-static int
-mlx5e_rep_indr_setup_block(struct net_device *netdev, struct Qdisc *sch,
-			   struct mlx5e_rep_priv *rpriv,
-			   struct flow_block_offload *f,
-			   flow_setup_cb_t *setup_cb,
-			   void *data,
-			   void (*cleanup)(struct flow_block_cb *block_cb))
+static bool
+mlx5e_rep_check_indr_block_supported(struct mlx5e_rep_priv *rpriv,
+				     struct net_device *netdev,
+				     struct flow_block_offload *f)
 {
 	struct mlx5e_priv *priv = netdev_priv(rpriv->netdev);
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
-	bool is_ovs_int_port = netif_is_ovs_master(netdev);
-	struct mlx5e_rep_indr_block_priv *indr_priv;
-	struct flow_block_cb *block_cb;
 
-	if (!mlx5e_tc_tun_device_to_offload(priv, netdev) &&
-	    !(is_vlan_dev(netdev) && vlan_dev_real_dev(netdev) == rpriv->netdev) &&
-	    !is_ovs_int_port) {
-		if (!(netif_is_macvlan(netdev) && macvlan_dev_real_dev(netdev) == rpriv->netdev))
-			return -EOPNOTSUPP;
+	if (f->binder_type != FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS &&
+	    f->binder_type != FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS)
+		return false;
+
+	if (mlx5e_tc_tun_device_to_offload(priv, netdev))
+		return true;
+
+	if (is_vlan_dev(netdev) && vlan_dev_real_dev(netdev) == rpriv->netdev)
+		return true;
+
+	if (netif_is_macvlan(netdev)) {
 		if (!mlx5e_rep_macvlan_mode_supported(netdev)) {
 			netdev_warn(netdev, "Offloading ingress filter is supported only with macvlan passthru mode");
-			return -EOPNOTSUPP;
+			return false;
 		}
+
+		if (macvlan_dev_real_dev(netdev) == rpriv->netdev)
+			return true;
 	}
 
-	if (f->binder_type != FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS &&
-	    f->binder_type != FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS)
-		return -EOPNOTSUPP;
+	if (netif_is_ovs_master(netdev) && f->binder_type == FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS &&
+	    mlx5e_tc_int_port_supported(esw))
+		return true;
 
-	if (f->binder_type == FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS && !is_ovs_int_port)
-		return -EOPNOTSUPP;
+	return false;
+}
+
+static int
+mlx5e_rep_indr_setup_block(struct net_device *netdev, struct Qdisc *sch,
+			   struct mlx5e_rep_priv *rpriv,
+			   struct flow_block_offload *f,
+			   flow_setup_cb_t *setup_cb,
+			   void *data,
+			   void (*cleanup)(struct flow_block_cb *block_cb))
+{
+	struct mlx5e_rep_indr_block_priv *indr_priv;
+	struct flow_block_cb *block_cb;
 
-	if (is_ovs_int_port && !mlx5e_tc_int_port_supported(esw))
+	if (!mlx5e_rep_check_indr_block_supported(rpriv, netdev, f))
 		return -EOPNOTSUPP;
 
 	f->unlocked_driver_cb = true;
-- 
2.39.2


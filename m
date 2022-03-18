Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4A94DE2EC
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 21:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240886AbiCRUy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 16:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240869AbiCRUyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 16:54:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1DDCDF38
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 13:53:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60E9660C88
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 20:53:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8565EC340ED;
        Fri, 18 Mar 2022 20:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647636795;
        bh=+bp7dYWw2dsAo1ajifcnewXIUmMjfZmoadWyoh82uIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NpxAYh2AkrgVrZzKUp2HRTzvzektQTnrq5pxqZT6zOCbonIk5X2w5NNHDHm7GhRua
         ysrd+IImdm8OPhbPQvnqoD8CxEcrYed0q2QGgCypwqAjcUtJV0OO2pcXi0cZ9GM+y8
         sV7yoCuFDHGWU6EQw1ZIxMmjlVRlbxCRk7Vv35k3tzIpIRLL3203FaPCb7GW9HzPmq
         3Cv44/H0WLKeCV8ayRQTpuM82YBiRc5Mx4/EZqK5rs1xJ0ZO+KptdgiILXCmUfKxu4
         KR0SjVsBRkqF1cmY48EozHjY6sx0C4ozX0wBLudGac25C/ppj35ysBWSOKYVC+YKoD
         UGVazBvORYXUg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 12/15] net/mlx5e: Permit XDP with non-linear legacy RQ
Date:   Fri, 18 Mar 2022 13:52:45 -0700
Message-Id: <20220318205248.33367-13-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220318205248.33367-1-saeed@kernel.org>
References: <20220318205248.33367-1-saeed@kernel.org>
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

From: Maxim Mikityanskiy <maximmi@nvidia.com>

Now that legacy RQ implements XDP in the non-linear mode, stop blocking
this configuration. Allow non-linear mode only for programs aware of
multi buffer.

XDP performance with linear mode RQ hasn't changed.

Baseline (MTU 1500, TX MPWQE, legacy RQ, single core):
 60-byte packets, XDP_DROP: 11.25 Mpps
 60-byte packets, XDP_TX: 9.0 Mpps
 60-byte packets, XDP_PASS: 668 kpps

Multi buffer (MTU 9000, TX MPWQE, legacy RQ, single core):
 60-byte packets, XDP_DROP: 10.1 Mpps
 60-byte packets, XDP_TX: 6.6 Mpps
 60-byte packets, XDP_PASS: 658 kpps
 8900-byte packets, XDP_DROP: 769 kpps (100% of sent packets)
 8900-byte packets, XDP_TX: 674 kpps (100% of sent packets)
 8900-byte packets, XDP_PASS: 637 kpps

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 39 +++++++++++++------
 1 file changed, 27 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 95cec2848685..3256d2c375c3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3953,6 +3953,31 @@ static bool mlx5e_xsk_validate_mtu(struct net_device *netdev,
 	return true;
 }
 
+static bool mlx5e_params_validate_xdp(struct net_device *netdev, struct mlx5e_params *params)
+{
+	bool is_linear;
+
+	/* No XSK params: AF_XDP can't be enabled yet at the point of setting
+	 * the XDP program.
+	 */
+	is_linear = mlx5e_rx_is_linear_skb(params, NULL);
+
+	if (!is_linear && params->rq_wq_type != MLX5_WQ_TYPE_CYCLIC) {
+		netdev_warn(netdev, "XDP is not allowed with striding RQ and MTU(%d) > %d\n",
+			    params->sw_mtu,
+			    mlx5e_xdp_max_mtu(params, NULL));
+		return false;
+	}
+	if (!is_linear && !params->xdp_prog->aux->xdp_has_frags) {
+		netdev_warn(netdev, "MTU(%d) > %d, too big for an XDP program not aware of multi buffer\n",
+			    params->sw_mtu,
+			    mlx5e_xdp_max_mtu(params, NULL));
+		return false;
+	}
+
+	return true;
+}
+
 int mlx5e_change_mtu(struct net_device *netdev, int new_mtu,
 		     mlx5e_fp_preactivate preactivate)
 {
@@ -3972,10 +3997,7 @@ int mlx5e_change_mtu(struct net_device *netdev, int new_mtu,
 	if (err)
 		goto out;
 
-	if (params->xdp_prog &&
-	    !mlx5e_rx_is_linear_skb(&new_params, NULL)) {
-		netdev_err(netdev, "MTU(%d) > %d is not allowed while XDP enabled\n",
-			   new_mtu, mlx5e_xdp_max_mtu(params, NULL));
+	if (new_params.xdp_prog && !mlx5e_params_validate_xdp(netdev, &new_params)) {
 		err = -EINVAL;
 		goto out;
 	}
@@ -4458,15 +4480,8 @@ static int mlx5e_xdp_allowed(struct mlx5e_priv *priv, struct bpf_prog *prog)
 	new_params = priv->channels.params;
 	new_params.xdp_prog = prog;
 
-	/* No XSK params: AF_XDP can't be enabled yet at the point of setting
-	 * the XDP program.
-	 */
-	if (!mlx5e_rx_is_linear_skb(&new_params, NULL)) {
-		netdev_warn(netdev, "XDP is not allowed with MTU(%d) > %d\n",
-			    new_params.sw_mtu,
-			    mlx5e_xdp_max_mtu(&new_params, NULL));
+	if (!mlx5e_params_validate_xdp(netdev, &new_params))
 		return -EINVAL;
-	}
 
 	return 0;
 }
-- 
2.35.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C05C667975F
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 13:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233378AbjAXMPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 07:15:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbjAXMPY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 07:15:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 894AF44BC8;
        Tue, 24 Jan 2023 04:15:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 453C3B81142;
        Tue, 24 Jan 2023 12:15:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F218C433D2;
        Tue, 24 Jan 2023 12:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674562521;
        bh=d0TP8CzjY3P9mUlZWC+vtoSEaggJpOjFfgdxsGSGWBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TMKXaontAlLIceLepXNK4HHP3gk3+4OXAM4jJ+RzKhwHzHQE+o9iBhL62JRVoFyVM
         p8Nxov+BeojR7/LAg72V7NX1ni/kA6Vo/4RglMCOogS8ySASOmH6P3/4mTtirdlG0/
         bBzJIe7IFL+C6CroKvW6gDR7jhpYMtDMuIMe75x5P2gVh9VN5wicuUhkJ7DbXOwL+c
         r5n4DYyHK/Kd2xfIJwMbj34Nfnw9DhuqQjrK5ig1QVjmGpCZgC8t/Yz9EgKrmBYq+6
         qd7fh1250VdlFdZbWEj4ozEFW/8Jibz3PNjKiKOTDqFNYVntQHBUBNMDVMX4KUQGMl
         KnR/nlu993igw==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        intel-wired-lan@lists.osuosl.org,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        Paolo Abeni <pabeni@redhat.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Veaceslav Falico <vfalico@gmail.com>
Subject: [PATCH net-next v1 02/10] net/mlx5e: Fill IPsec policy validation failure reason
Date:   Tue, 24 Jan 2023 13:54:58 +0200
Message-Id: <827fc088e41d891a651ea7c0c10c0343ffe8177d.1674560845.git.leon@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1674560845.git.leon@kernel.org>
References: <cover.1674560845.git.leon@kernel.org>
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

From: Leon Romanovsky <leonro@nvidia.com>

Rely on extack to return failure reason.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 22 ++++++++++---------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 83e0f874484e..3236c3b43149 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -497,34 +497,33 @@ static void mlx5e_xfrm_update_curlft(struct xfrm_state *x)
 	mlx5e_ipsec_aso_update_curlft(sa_entry, &x->curlft.packets);
 }
 
-static int mlx5e_xfrm_validate_policy(struct xfrm_policy *x)
+static int mlx5e_xfrm_validate_policy(struct xfrm_policy *x,
+				      struct netlink_ext_ack *extack)
 {
-	struct net_device *netdev = x->xdo.real_dev;
-
 	if (x->type != XFRM_POLICY_TYPE_MAIN) {
-		netdev_info(netdev, "Cannot offload non-main policy types\n");
+		NL_SET_ERR_MSG_MOD(extack, "Cannot offload non-main policy types");
 		return -EINVAL;
 	}
 
 	/* Please pay attention that we support only one template */
 	if (x->xfrm_nr > 1) {
-		netdev_info(netdev, "Cannot offload more than one template\n");
+		NL_SET_ERR_MSG_MOD(extack, "Cannot offload more than one template");
 		return -EINVAL;
 	}
 
 	if (x->xdo.dir != XFRM_DEV_OFFLOAD_IN &&
 	    x->xdo.dir != XFRM_DEV_OFFLOAD_OUT) {
-		netdev_info(netdev, "Cannot offload forward policy\n");
+		NL_SET_ERR_MSG_MOD(extack, "Cannot offload forward policy");
 		return -EINVAL;
 	}
 
 	if (!x->xfrm_vec[0].reqid) {
-		netdev_info(netdev, "Cannot offload policy without reqid\n");
+		NL_SET_ERR_MSG_MOD(extack, "Cannot offload policy without reqid");
 		return -EINVAL;
 	}
 
 	if (x->xdo.type != XFRM_DEV_OFFLOAD_PACKET) {
-		netdev_info(netdev, "Unsupported xfrm offload type\n");
+		NL_SET_ERR_MSG_MOD(extack, "Unsupported xfrm offload type");
 		return -EINVAL;
 	}
 
@@ -559,10 +558,12 @@ static int mlx5e_xfrm_add_policy(struct xfrm_policy *x,
 	int err;
 
 	priv = netdev_priv(netdev);
-	if (!priv->ipsec)
+	if (!priv->ipsec) {
+		NL_SET_ERR_MSG_MOD(extack, "Device doesn't support IPsec packet offload");
 		return -EOPNOTSUPP;
+	}
 
-	err = mlx5e_xfrm_validate_policy(x);
+	err = mlx5e_xfrm_validate_policy(x, extack);
 	if (err)
 		return err;
 
@@ -583,6 +584,7 @@ static int mlx5e_xfrm_add_policy(struct xfrm_policy *x,
 
 err_fs:
 	kfree(pol_entry);
+	NL_SET_ERR_MSG_MOD(extack, "Device failed to offload this policy");
 	return err;
 }
 
-- 
2.39.1


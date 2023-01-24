Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F377679763
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 13:15:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233420AbjAXMPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 07:15:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233391AbjAXMPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 07:15:31 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CCA742DD9;
        Tue, 24 Jan 2023 04:15:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CB5EECE1AAB;
        Tue, 24 Jan 2023 12:15:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 504C9C4339C;
        Tue, 24 Jan 2023 12:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674562525;
        bh=YGgQziornQTvmUD4H4CPX7PJFSO8N6MDyXh7nj8fJHg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RvstJDhe1idgKqJsjPl9fifv5nV9lo3mbWxGrlwrILf5ofxUf9Dh4jG7HeMcnKJ1V
         mLJ7Q3LjDfdXIQwBR3z4UHa4MtJB/Q47QLJUsKV+F+VRnQ0j07y/VJNqu/k11J7b3J
         VyPPajE8Ei1+RbGdfXlsnrWkpU5IpKqVNJ9jHH00owuoiup7GZKHXUiocb0XFve3Wq
         Qn3VwjVs9mvH31RyzWCSq2Sev5i23ItNXY5IeV5sLLiDQNmEmXpu5iWUXlBl5/n9rJ
         rlJ75iy4sYaAtjrG4vtWXnIUjdQGN4zD8PUU2vcLs44XmcWxE/RyTFDkhW1d4St2t5
         FL6wt5ZyS5+Kg==
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
Subject: [PATCH net-next v1 04/10] net/mlx5e: Fill IPsec state validation failure reason
Date:   Tue, 24 Jan 2023 13:55:00 +0200
Message-Id: <90d9d78d81ea0b6bffeeb76e8663dae106007d61.1674560845.git.leon@kernel.org>
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
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 75 ++++++++-----------
 1 file changed, 32 insertions(+), 43 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index a889df77dd2d..e84c3400ba1d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -162,91 +162,87 @@ void mlx5e_ipsec_build_accel_xfrm_attrs(struct mlx5e_ipsec_sa_entry *sa_entry,
 	mlx5e_ipsec_init_limits(sa_entry, attrs);
 }
 
-static inline int mlx5e_xfrm_validate_state(struct xfrm_state *x)
+static int mlx5e_xfrm_validate_state(struct mlx5_core_dev *mdev,
+				     struct xfrm_state *x,
+				     struct netlink_ext_ack *extack)
 {
-	struct net_device *netdev = x->xso.real_dev;
-	struct mlx5e_priv *priv;
-
-	priv = netdev_priv(netdev);
-
 	if (x->props.aalgo != SADB_AALG_NONE) {
-		netdev_info(netdev, "Cannot offload authenticated xfrm states\n");
+		NL_SET_ERR_MSG_MOD(extack, "Cannot offload authenticated xfrm states");
 		return -EINVAL;
 	}
 	if (x->props.ealgo != SADB_X_EALG_AES_GCM_ICV16) {
-		netdev_info(netdev, "Only AES-GCM-ICV16 xfrm state may be offloaded\n");
+		NL_SET_ERR_MSG_MOD(extack, "Only AES-GCM-ICV16 xfrm state may be offloaded");
 		return -EINVAL;
 	}
 	if (x->props.calgo != SADB_X_CALG_NONE) {
-		netdev_info(netdev, "Cannot offload compressed xfrm states\n");
+		NL_SET_ERR_MSG_MOD(extack, "Cannot offload compressed xfrm states");
 		return -EINVAL;
 	}
 	if (x->props.flags & XFRM_STATE_ESN &&
-	    !(mlx5_ipsec_device_caps(priv->mdev) & MLX5_IPSEC_CAP_ESN)) {
-		netdev_info(netdev, "Cannot offload ESN xfrm states\n");
+	    !(mlx5_ipsec_device_caps(mdev) & MLX5_IPSEC_CAP_ESN)) {
+		NL_SET_ERR_MSG_MOD(extack, "Cannot offload ESN xfrm states");
 		return -EINVAL;
 	}
 	if (x->props.family != AF_INET &&
 	    x->props.family != AF_INET6) {
-		netdev_info(netdev, "Only IPv4/6 xfrm states may be offloaded\n");
+		NL_SET_ERR_MSG_MOD(extack, "Only IPv4/6 xfrm states may be offloaded");
 		return -EINVAL;
 	}
 	if (x->id.proto != IPPROTO_ESP) {
-		netdev_info(netdev, "Only ESP xfrm state may be offloaded\n");
+		NL_SET_ERR_MSG_MOD(extack, "Only ESP xfrm state may be offloaded");
 		return -EINVAL;
 	}
 	if (x->encap) {
-		netdev_info(netdev, "Encapsulated xfrm state may not be offloaded\n");
+		NL_SET_ERR_MSG_MOD(extack, "Encapsulated xfrm state may not be offloaded");
 		return -EINVAL;
 	}
 	if (!x->aead) {
-		netdev_info(netdev, "Cannot offload xfrm states without aead\n");
+		NL_SET_ERR_MSG_MOD(extack, "Cannot offload xfrm states without aead");
 		return -EINVAL;
 	}
 	if (x->aead->alg_icv_len != 128) {
-		netdev_info(netdev, "Cannot offload xfrm states with AEAD ICV length other than 128bit\n");
+		NL_SET_ERR_MSG_MOD(extack, "Cannot offload xfrm states with AEAD ICV length other than 128bit");
 		return -EINVAL;
 	}
 	if ((x->aead->alg_key_len != 128 + 32) &&
 	    (x->aead->alg_key_len != 256 + 32)) {
-		netdev_info(netdev, "Cannot offload xfrm states with AEAD key length other than 128/256 bit\n");
+		NL_SET_ERR_MSG_MOD(extack, "Cannot offload xfrm states with AEAD key length other than 128/256 bit");
 		return -EINVAL;
 	}
 	if (x->tfcpad) {
-		netdev_info(netdev, "Cannot offload xfrm states with tfc padding\n");
+		NL_SET_ERR_MSG_MOD(extack, "Cannot offload xfrm states with tfc padding");
 		return -EINVAL;
 	}
 	if (!x->geniv) {
-		netdev_info(netdev, "Cannot offload xfrm states without geniv\n");
+		NL_SET_ERR_MSG_MOD(extack, "Cannot offload xfrm states without geniv");
 		return -EINVAL;
 	}
 	if (strcmp(x->geniv, "seqiv")) {
-		netdev_info(netdev, "Cannot offload xfrm states with geniv other than seqiv\n");
+		NL_SET_ERR_MSG_MOD(extack, "Cannot offload xfrm states with geniv other than seqiv");
 		return -EINVAL;
 	}
 	switch (x->xso.type) {
 	case XFRM_DEV_OFFLOAD_CRYPTO:
-		if (!(mlx5_ipsec_device_caps(priv->mdev) &
-		      MLX5_IPSEC_CAP_CRYPTO)) {
-			netdev_info(netdev, "Crypto offload is not supported\n");
+		if (!(mlx5_ipsec_device_caps(mdev) & MLX5_IPSEC_CAP_CRYPTO)) {
+			NL_SET_ERR_MSG_MOD(extack, "Crypto offload is not supported");
 			return -EINVAL;
 		}
 
 		if (x->props.mode != XFRM_MODE_TRANSPORT &&
 		    x->props.mode != XFRM_MODE_TUNNEL) {
-			netdev_info(netdev, "Only transport and tunnel xfrm states may be offloaded\n");
+			NL_SET_ERR_MSG_MOD(extack, "Only transport and tunnel xfrm states may be offloaded");
 			return -EINVAL;
 		}
 		break;
 	case XFRM_DEV_OFFLOAD_PACKET:
-		if (!(mlx5_ipsec_device_caps(priv->mdev) &
+		if (!(mlx5_ipsec_device_caps(mdev) &
 		      MLX5_IPSEC_CAP_PACKET_OFFLOAD)) {
-			netdev_info(netdev, "Packet offload is not supported\n");
+			NL_SET_ERR_MSG_MOD(extack, "Packet offload is not supported");
 			return -EINVAL;
 		}
 
 		if (x->props.mode != XFRM_MODE_TRANSPORT) {
-			netdev_info(netdev, "Only transport xfrm states may be offloaded in packet mode\n");
+			NL_SET_ERR_MSG_MOD(extack, "Only transport xfrm states may be offloaded in packet mode");
 			return -EINVAL;
 		}
 
@@ -254,35 +250,30 @@ static inline int mlx5e_xfrm_validate_state(struct xfrm_state *x)
 		    x->replay_esn->replay_window != 64 &&
 		    x->replay_esn->replay_window != 128 &&
 		    x->replay_esn->replay_window != 256) {
-			netdev_info(netdev,
-				    "Unsupported replay window size %u\n",
-				    x->replay_esn->replay_window);
+			NL_SET_ERR_MSG_MOD(extack, "Unsupported replay window size");
 			return -EINVAL;
 		}
 
 		if (!x->props.reqid) {
-			netdev_info(netdev, "Cannot offload without reqid\n");
+			NL_SET_ERR_MSG_MOD(extack, "Cannot offload without reqid");
 			return -EINVAL;
 		}
 
 		if (x->lft.hard_byte_limit != XFRM_INF ||
 		    x->lft.soft_byte_limit != XFRM_INF) {
-			netdev_info(netdev,
-				    "Device doesn't support limits in bytes\n");
+			NL_SET_ERR_MSG_MOD(extack, "Device doesn't support limits in bytes");
 			return -EINVAL;
 		}
 
 		if (x->lft.soft_packet_limit >= x->lft.hard_packet_limit &&
 		    x->lft.hard_packet_limit != XFRM_INF) {
 			/* XFRM stack doesn't prevent such configuration :(. */
-			netdev_info(netdev,
-				    "Hard packet limit must be greater than soft one\n");
+			NL_SET_ERR_MSG_MOD(extack, "Hard packet limit must be greater than soft one");
 			return -EINVAL;
 		}
 		break;
 	default:
-		netdev_info(netdev, "Unsupported xfrm offload type %d\n",
-			    x->xso.type);
+		NL_SET_ERR_MSG_MOD(extack, "Unsupported xfrm offload type");
 		return -EINVAL;
 	}
 	return 0;
@@ -312,15 +303,13 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x,
 		return -EOPNOTSUPP;
 
 	ipsec = priv->ipsec;
-	err = mlx5e_xfrm_validate_state(x);
+	err = mlx5e_xfrm_validate_state(priv->mdev, x, extack);
 	if (err)
 		return err;
 
 	sa_entry = kzalloc(sizeof(*sa_entry), GFP_KERNEL);
-	if (!sa_entry) {
-		err = -ENOMEM;
-		goto out;
-	}
+	if (!sa_entry)
+		return -ENOMEM;
 
 	sa_entry->x = x;
 	sa_entry->ipsec = ipsec;
@@ -361,7 +350,7 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x,
 	mlx5_ipsec_free_sa_ctx(sa_entry);
 err_xfrm:
 	kfree(sa_entry);
-out:
+	NL_SET_ERR_MSG_MOD(extack, "Device failed to offload this policy");
 	return err;
 }
 
-- 
2.39.1


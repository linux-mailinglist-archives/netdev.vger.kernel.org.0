Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A55A3677D5D
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 15:01:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232123AbjAWOAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 09:00:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232064AbjAWOAx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 09:00:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B6FA2684A;
        Mon, 23 Jan 2023 06:00:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5094BB80DCE;
        Mon, 23 Jan 2023 14:00:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49662C433D2;
        Mon, 23 Jan 2023 14:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674482444;
        bh=Gd9vMcslDI1r9tIWzoeJTAmt/tu1HZbdEQXbvY1ExiA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pXSGYqLtAgS2aCLNJ2E/BIKvmhz8JJSFNE2+bgeHqO28pzhuJXjad0gAtrxYbbkt4
         LVR/xFFjwlZwBnBVjDF4ZRujx/FZvKRkgKuB2BB52kLoi4KvOzYp3whR0kiv9jQoXS
         Qb10EmTQCo+mIFVdX3Jtl/zDlmijUo67JtB9nXm9VDYfKJYaocsn520FG0q19r2Lcv
         kcWq+m4WDTls18Jp110PVK8qBvB9lnQ/567kJy+oZFuJRw/NyxBkrQMZ8wsK7CTf0j
         kt6wKEyP+oG0pZcC8W38cBBqNBoo4ZZndENBv+HOFxcUdU/iZeyoyx28CBi/YZO8HN
         afISmjwnZD+Mg==
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
Subject: [PATCH net-next 01/10] xfrm: extend add policy callback to set failure reason
Date:   Mon, 23 Jan 2023 16:00:14 +0200
Message-Id: <6048dba5bf83d5ad772b37e351bf0f8ebc7d6a7b.1674481435.git.leon@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1674481435.git.leon@kernel.org>
References: <cover.1674481435.git.leon@kernel.org>
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

Almost all validation logic is in the drivers, but they are
missing reliable way to convey failure reason to userspace
applications.

Let's use extack to return this information to users.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
---
 Documentation/networking/xfrm_device.rst                 | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c | 3 ++-
 include/linux/netdevice.h                                | 2 +-
 net/xfrm/xfrm_device.c                                   | 3 +--
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/networking/xfrm_device.rst b/Documentation/networking/xfrm_device.rst
index c43ace79e320..b9c53e626982 100644
--- a/Documentation/networking/xfrm_device.rst
+++ b/Documentation/networking/xfrm_device.rst
@@ -73,7 +73,7 @@ Callbacks to implement
 
         /* Solely packet offload callbacks */
 	void    (*xdo_dev_state_update_curlft) (struct xfrm_state *x);
-	int	(*xdo_dev_policy_add) (struct xfrm_policy *x);
+	int	(*xdo_dev_policy_add) (struct xfrm_policy *x, struct netlink_ext_ack *extack);
 	void	(*xdo_dev_policy_delete) (struct xfrm_policy *x);
 	void	(*xdo_dev_policy_free) (struct xfrm_policy *x);
   };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index bb9023957f74..83e0f874484e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -550,7 +550,8 @@ mlx5e_ipsec_build_accel_pol_attrs(struct mlx5e_ipsec_pol_entry *pol_entry,
 	attrs->reqid = x->xfrm_vec[0].reqid;
 }
 
-static int mlx5e_xfrm_add_policy(struct xfrm_policy *x)
+static int mlx5e_xfrm_add_policy(struct xfrm_policy *x,
+				 struct netlink_ext_ack *extack)
 {
 	struct net_device *netdev = x->xdo.real_dev;
 	struct mlx5e_ipsec_pol_entry *pol_entry;
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index aad12a179e54..7c43b9fb9aae 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1042,7 +1042,7 @@ struct xfrmdev_ops {
 				       struct xfrm_state *x);
 	void	(*xdo_dev_state_advance_esn) (struct xfrm_state *x);
 	void	(*xdo_dev_state_update_curlft) (struct xfrm_state *x);
-	int	(*xdo_dev_policy_add) (struct xfrm_policy *x);
+	int	(*xdo_dev_policy_add) (struct xfrm_policy *x, struct netlink_ext_ack *extack);
 	void	(*xdo_dev_policy_delete) (struct xfrm_policy *x);
 	void	(*xdo_dev_policy_free) (struct xfrm_policy *x);
 };
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 4aff76c6f12e..2cec637a4a9c 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -383,14 +383,13 @@ int xfrm_dev_policy_add(struct net *net, struct xfrm_policy *xp,
 		return -EINVAL;
 	}
 
-	err = dev->xfrmdev_ops->xdo_dev_policy_add(xp);
+	err = dev->xfrmdev_ops->xdo_dev_policy_add(xp, extack);
 	if (err) {
 		xdo->dev = NULL;
 		xdo->real_dev = NULL;
 		xdo->type = XFRM_DEV_OFFLOAD_UNSPECIFIED;
 		xdo->dir = 0;
 		netdev_put(dev, &xdo->dev_tracker);
-		NL_SET_ERR_MSG(extack, "Device failed to offload this policy");
 		return err;
 	}
 
-- 
2.39.1


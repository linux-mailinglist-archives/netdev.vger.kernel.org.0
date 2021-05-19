Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1347E388748
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 08:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239660AbhESGHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 02:07:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:49266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238224AbhESGH1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 02:07:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA7C96139A;
        Wed, 19 May 2021 06:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621404368;
        bh=SMp6wBdvRdpky0LTRvRN3fS/hZ+XFdqXMD8BsN0h+wo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cn3z57iGzozTAE9lowsdrRJe05SqG1xnrehuAl6GxDLsHFSo+PGKWB7cG9wtveEat
         oOwl2+n1YfoXC2K6IaMovBsTV4Fmrf8dDNUBDivXFkvmnN2BRiKV+4DJ1EDp6DhB02
         W+H8dtI8VVtrMU4yUiiEyPwZzE9K6Y3zZAldyvp1JeiG1pAVjTNI+jU9y7eM8tLMSa
         gvB4M+RhHYOEIrb8n2gsvfaA8IaEBShWpZ6sYwbzKGBiJGi4Nly0t2FG6uL6TszgtY
         Hss9fcuY0xy3i2vs4h2kS8pM5uhXeFQB6fpBdpUh3KHskU2UsGWsfrbThgtPmv0eWi
         X0D+XmLL2b5eQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Dima Chumak <dchumak@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 06/16] net/mlx5e: Fix nullptr in mlx5e_tc_add_fdb_flow()
Date:   Tue, 18 May 2021 23:05:13 -0700
Message-Id: <20210519060523.17875-7-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519060523.17875-1-saeed@kernel.org>
References: <20210519060523.17875-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dima Chumak <dchumak@nvidia.com>

The result of __dev_get_by_index() is not checked for NULL, which then
passed to mlx5e_attach_encap() and gets dereferenced.

Also, in case of a successful lookup, the net_device reference count is
not incremented, which may result in net_device pointer becoming invalid
at any time during mlx5e_attach_encap() execution.

Fix by using dev_get_by_index(), which does proper reference counting on
the net_device pointer. Also, handle nullptr return value when mirred
device is not found.

It's safe to call dev_put() on the mirred net_device pointer, right
after mlx5e_attach_encap() call, because it's not being saved/copied
down the call chain.

Fixes: 3c37745ec614 ("net/mlx5e: Properly deal with encap flows add/del under neigh update")
Addresses-Coverity: ("Dereference null return value")
Signed-off-by: Dima Chumak <dchumak@nvidia.com>
Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 46945d04b5b8..882bafba43f2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1322,10 +1322,10 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 		      struct netlink_ext_ack *extack)
 {
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
-	struct net_device *out_dev, *encap_dev = NULL;
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
 	struct mlx5_flow_attr *attr = flow->attr;
 	bool vf_tun = false, encap_valid = true;
+	struct net_device *encap_dev = NULL;
 	struct mlx5_esw_flow_attr *esw_attr;
 	struct mlx5_fc *counter = NULL;
 	struct mlx5e_rep_priv *rpriv;
@@ -1371,16 +1371,22 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 	esw_attr = attr->esw_attr;
 
 	for (out_index = 0; out_index < MLX5_MAX_FLOW_FWD_VPORTS; out_index++) {
+		struct net_device *out_dev;
 		int mirred_ifindex;
 
 		if (!(esw_attr->dests[out_index].flags & MLX5_ESW_DEST_ENCAP))
 			continue;
 
 		mirred_ifindex = parse_attr->mirred_ifindex[out_index];
-		out_dev = __dev_get_by_index(dev_net(priv->netdev),
-					     mirred_ifindex);
+		out_dev = dev_get_by_index(dev_net(priv->netdev), mirred_ifindex);
+		if (!out_dev) {
+			NL_SET_ERR_MSG_MOD(extack, "Requested mirred device not found");
+			err = -ENODEV;
+			goto err_out;
+		}
 		err = mlx5e_attach_encap(priv, flow, out_dev, out_index,
 					 extack, &encap_dev, &encap_valid);
+		dev_put(out_dev);
 		if (err)
 			goto err_out;
 
-- 
2.31.1


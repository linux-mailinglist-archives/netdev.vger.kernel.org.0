Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D40DF2C487E
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 20:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728883AbgKYTf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 14:35:57 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:34743 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728849AbgKYTf4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 14:35:56 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 71D925C00B4;
        Wed, 25 Nov 2020 14:35:55 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 25 Nov 2020 14:35:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=RHHOBVQLw0kZK7z61mje/PbUaJLwKS4IHSZ1rhycxfw=; b=qozx+Q2L
        j0R//NYdaHF+5Wt9HlDsqml9pbuUuxOXWp9tpiMYHoN9IDKDbQrQDOHqLSjwJttA
        YYFyOfcVERRI5jFmlrgJcYEyO2ZDov7PD4QmzsmTTLQoeM2GH2VUH9looAbaCSca
        D0se7WWFK3HftFvvzjdmB13HRbmDCYWiBhKLRp9568+hH5ie1AQuubD6WrQiISti
        5sgxSqSntSYLBM/vCc1ys/Uzjqb/nldb5QjOSvw0UdpF0oCzDDt8vzA5LlGny0zD
        5vfP9LUtV/5ax6BhtZ93/+dQ8I/z97SRgR5a1m3eE18tEHf/ZgopqsP58tZj4jGl
        pUdUxbhIT+Ruuw==
X-ME-Sender: <xms:G7K-X_UuvEtfnEAKCPnaKhEijRNKLiclWBCldTlQGge_JKtFJ1ngKA>
    <xme:G7K-X3k4IlmG7-5gKfNpSujyv7MBdgPAAQN6D8favNW9tTU28gyvqpEl5J8DwM2Om
    gOxUV1AcJIiPb0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudehtddguddvjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheegrddu
    geejnecuvehluhhsthgvrhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:G7K-X7YZO6cgyg7hhUIdsgxqXiMTCLeQQqJ1f_FOTCTRUc-0dvHYhA>
    <xmx:G7K-X6Xi7hntjBE6vmWgn4v8P9n0fJZIaLPj0DqQkGMeVVcGG1tJpg>
    <xmx:G7K-X5mCtuwlWJQ62DKs5aYaWorxYK6bT6RdmXmlVtBYmk821Q1toQ>
    <xmx:G7K-X_iqS6Yq6cBmJMrWGwzF5aCS0igp4Y0NkH_EvnYFf7r8ggNo3g>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0E0D3328005A;
        Wed, 25 Nov 2020 14:35:53 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 5/5] mlxsw: spectrum_router: Update adjacency index more efficiently
Date:   Wed, 25 Nov 2020 21:35:05 +0200
Message-Id: <20201125193505.1052466-6-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201125193505.1052466-1-idosch@idosch.org>
References: <20201125193505.1052466-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The device supports an operation that allows the driver to issue one
request to update the adjacency index for all the routes in a given
virtual router (VR) from old index and size to new ones. This is useful
in case the configuration of a certain nexthop group is updated and its
adjacency index changes.

Currently, the driver does not use this operation in an efficient
manner. It iterates over all the routes using the nexthop group and
issues an update request for the VR if it is not the same as the
previous VR.

Instead, use the VR tracking added in the previous patch to update the
adjacency index once for each VR currently using the nexthop group.

Example:

8k IPv6 routes were added in an alternating manner to two VRFs. All the
routes are using the same nexthop object ('nhid 1').

Before:

# perf stat -e devlink:devlink_hwmsg --filter='incoming==0' -- ip nexthop replace id 1 via 2001:db8:1::2 dev swp3

 Performance counter stats for 'ip nexthop replace id 1 via 2001:db8:1::2 dev swp3':

            16,385      devlink:devlink_hwmsg

       4.255933213 seconds time elapsed

       0.000000000 seconds user
       0.666923000 seconds sys

Number of EMAD transactions corresponds to number of routes using the
nexthop group.

After:

# perf stat -e devlink:devlink_hwmsg --filter='incoming==0' -- ip nexthop replace id 1 via 2001:db8:1::2 dev swp3

 Performance counter stats for 'ip nexthop replace id 1 via 2001:db8:1::2 dev swp3':

                 3      devlink:devlink_hwmsg

       0.077655094 seconds time elapsed

       0.000000000 seconds user
       0.076698000 seconds sys

Number of EMAD transactions corresponds to number of VRFs / VRs.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 28 +++++++------------
 1 file changed, 10 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 9e3dfd2f7f45..12b5d7fbe1e2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -3366,18 +3366,14 @@ static int mlxsw_sp_adj_index_mass_update(struct mlxsw_sp *mlxsw_sp,
 					  struct mlxsw_sp_nexthop_group *nh_grp,
 					  u32 old_adj_index, u16 old_ecmp_size)
 {
-	struct mlxsw_sp_fib_entry *fib_entry;
-	struct mlxsw_sp_fib *fib = NULL;
+	struct mlxsw_sp_nexthop_group_info *nhgi = nh_grp->nhgi;
+	struct mlxsw_sp_nexthop_group_vr_entry *vr_entry;
 	int err;
 
-	list_for_each_entry(fib_entry, &nh_grp->fib_list, nexthop_group_node) {
-		struct mlxsw_sp_nexthop_group_info *nhgi = nh_grp->nhgi;
-
-		if (fib == fib_entry->fib_node->fib)
-			continue;
-		fib = fib_entry->fib_node->fib;
-		err = mlxsw_sp_adj_index_mass_update_vr(mlxsw_sp, fib->proto,
-							fib->vr->id,
+	list_for_each_entry(vr_entry, &nh_grp->vr_list, list) {
+		err = mlxsw_sp_adj_index_mass_update_vr(mlxsw_sp,
+							vr_entry->key.proto,
+							vr_entry->key.vr_id,
 							old_adj_index,
 							old_ecmp_size,
 							nhgi->adj_index,
@@ -3388,16 +3384,12 @@ static int mlxsw_sp_adj_index_mass_update(struct mlxsw_sp *mlxsw_sp,
 	return 0;
 
 err_mass_update_vr:
-	list_for_each_entry_continue_reverse(fib_entry, &nh_grp->fib_list,
-					     nexthop_group_node) {
-		struct mlxsw_sp_nexthop_group_info *nhgi = nh_grp->nhgi;
-
-		fib = fib_entry->fib_node->fib;
-		mlxsw_sp_adj_index_mass_update_vr(mlxsw_sp, fib->proto,
-						  fib->vr->id, nhgi->adj_index,
+	list_for_each_entry_continue_reverse(vr_entry, &nh_grp->vr_list, list)
+		mlxsw_sp_adj_index_mass_update_vr(mlxsw_sp, vr_entry->key.proto,
+						  vr_entry->key.vr_id,
+						  nhgi->adj_index,
 						  nhgi->ecmp_size,
 						  old_adj_index, old_ecmp_size);
-	}
 	return err;
 }
 
-- 
2.28.0


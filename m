Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 405D6155CCD
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 18:27:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgBGR1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 12:27:18 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:34405 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727047AbgBGR1R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Feb 2020 12:27:17 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id E6B8721ACF;
        Fri,  7 Feb 2020 12:27:15 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 07 Feb 2020 12:27:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=FPLhLUiptvYfa9+Y7n9WIWEMSDwryr9706tHRYFpehk=; b=rqsQNN8I
        71MWWDbkOXss6I5f1f7vLh/vmb7qg8SsFgN11NmZ9IX4NwH1EmGB70o8ynuxgOlp
        hY0vTgj2hJKLAElWthaI32ZUmj1jJVDcpEIVszlcSfpdev2O+ZlRtf+8nYziHR/R
        KTxN6uzi3bhtLRENfreAizcNTruFeMwT10eroOWhWSVDZRtQdCXM3erAMuTXAxNs
        xpaaIAeg1jWnQnqBFRLEYg9XQom7qHWZ8xrNNGnORVQ9ahgDZTz1Lym22kRQMkMY
        Q+Iv8FMC7YrM1jAzfFujVE1hG3/z+dJC3n7qvKXbea3ecz6RLdRGi4rk98HZ2evM
        OTGJyu07j9WyQA==
X-ME-Sender: <xms:8509XkAn0EtsDe2x-TbmZh18_VlNUYc_qbaMS0jemernshovCYQh4g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheehgddutdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudekfedruddtjedruddvtdenucevlhhushhtvg
    hrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhs
    tghhrdhorhhg
X-ME-Proxy: <xmx:8509Xm3nAX4yHVm1WmgZzZrcdjvZa1KH2vfDIYRo_XyKkqn1tRAJZw>
    <xmx:8509XrhSJA3GCml1Le2dHjhmIqL8a4H981vIWTzhgvzAbdmVXKkLkA>
    <xmx:8509XuNDlwxRtX8rZB6lRxAT3cICbArK8Kqu471cvWW_Kg6ELj2kCw>
    <xmx:8509XgHdWdqhlCGS06IbLD28ub6qOeo87e40ND0A35gipvRYmvDLjA>
Received: from splinter.mtl.com (bzq-79-183-107-120.red.bezeqint.net [79.183.107.120])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8C75C30605C8;
        Fri,  7 Feb 2020 12:27:14 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 3/5] mlxsw: spectrum_router: Clear offload indication from IPv6 nexthops on abort
Date:   Fri,  7 Feb 2020 19:26:26 +0200
Message-Id: <20200207172628.128763-4-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200207172628.128763-1-idosch@idosch.org>
References: <20200207172628.128763-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Unlike IPv4, in IPv6 there is no unique structure to represent the
nexthop and both the route and nexthop information are squashed to the
same structure ('struct fib6_info'). In order to improve resource
utilization the driver consolidates identical nexthop groups to the same
internal representation of a nexthop group.

Therefore, when the offload indication of a nexthop changes, the driver
needs to iterate over all the linked fib6_info and toggle their offload
flag accordingly.

During abort, all the routes are removed from the device and unlinked
from their nexthop group. The offload indication is cleared just before
the group is destroyed, but by that time no fib6_info is linked to the
group and the offload indication remains set.

Fix this by clearing the offload indication just before dropping the
reference from the nexthop.

Fixes: ee5a0448e72b ("mlxsw: spectrum_router: Set hardware flags for routes")
Reported-by: Alex Kushnarov <alexanderk@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Tested-by: Alex Kushnarov <alexanderk@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index f8b3869672c3..4a77b511ead2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -4993,6 +4993,9 @@ static void mlxsw_sp_rt6_release(struct fib6_info *rt)
 
 static void mlxsw_sp_rt6_destroy(struct mlxsw_sp_rt6 *mlxsw_sp_rt6)
 {
+	struct fib6_nh *fib6_nh = mlxsw_sp_rt6->rt->fib6_nh;
+
+	fib6_nh->fib_nh_flags &= ~RTNH_F_OFFLOAD;
 	mlxsw_sp_rt6_release(mlxsw_sp_rt6->rt);
 	kfree(mlxsw_sp_rt6);
 }
-- 
2.24.1


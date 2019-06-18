Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 773F84A4EC
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 17:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729760AbfFRPNy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 11:13:54 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:53227 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729638AbfFRPNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 11:13:52 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id C1EDD2246B;
        Tue, 18 Jun 2019 11:13:50 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 18 Jun 2019 11:13:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=Nzulxnk9Se5GEvPAddKhUtNC3508PGZpKtyqAWY5XZk=; b=ji78cWve
        PFMEknn1Lyxohm43Kiu9J4COTWaOVG7S4bpsTuQRvlXW0y8mpkA50wdwyKUaELeR
        GFux4Nipt0Rfh0+PweWC1xOJdAcLzpsA/oaD7etY93kPgpPo0d3SRXhbe1465oXL
        Y6XiOCTlICCpUihgEXHe7QUW7FsyegO+4DBoVcwFymheZXSc1vwUhXY/lzkWwD73
        anprTxLcZtqnQDx+aVlar1yCVLsR6cGKfNNh9UhNDkv6gXdo7N6oaEJ2PJiQJihl
        BRwOL8hFWORneBlUOdp2OkbPXXxmyXJ7mH+/UxKOgScPTs4Atw9p0LrASZeBtI1v
        O8PHvsBIyiv4vA==
X-ME-Sender: <xms:rv8IXYsiVXCr5TcbKLrX1YGJnueNm77cALEmhC3lJ-1ekj2A1sijoQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrtddtgdehhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepudef
X-ME-Proxy: <xmx:rv8IXRhIa7BpJPTXRBa1_5eoOYtNcrwgXpiDDTYKo9w4nll_ehv6xw>
    <xmx:rv8IXfE3AiBb6aaeiXrynah_LmUC6Wylsfo0uhUmi53BkO1HZ9zEBQ>
    <xmx:rv8IXaK0zDOAJwvFePesnaQg9YzlrCvCNkP4XBGCa08Ms8NCYhAR2A>
    <xmx:rv8IXcnmqhs8Ct5aw5sD-I0vTeKt-Q9CP82EdbnRRzIbUzG1KUxmRg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 91A19380083;
        Tue, 18 Jun 2019 11:13:48 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, dsahern@gmail.com,
        alexpe@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 14/16] mlxsw: spectrum_router: Create IPv6 multipath routes in one go
Date:   Tue, 18 Jun 2019 18:12:56 +0300
Message-Id: <20190618151258.23023-15-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190618151258.23023-1-idosch@idosch.org>
References: <20190618151258.23023-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Allow the driver to create an IPv6 multipath route in one go by passing
an array of sibling routes and iterating over them.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 36 ++++++++++++-------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 98fd3c582a60..92ec65188e9a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -5373,29 +5373,32 @@ mlxsw_sp_fib6_entry_rt_destroy_all(struct mlxsw_sp_fib6_entry *fib6_entry)
 static struct mlxsw_sp_fib6_entry *
 mlxsw_sp_fib6_entry_create(struct mlxsw_sp *mlxsw_sp,
 			   struct mlxsw_sp_fib_node *fib_node,
-			   struct fib6_info *rt)
+			   struct fib6_info **rt_arr, unsigned int nrt6)
 {
 	struct mlxsw_sp_fib6_entry *fib6_entry;
 	struct mlxsw_sp_fib_entry *fib_entry;
 	struct mlxsw_sp_rt6 *mlxsw_sp_rt6;
-	int err;
+	int err, i;
 
 	fib6_entry = kzalloc(sizeof(*fib6_entry), GFP_KERNEL);
 	if (!fib6_entry)
 		return ERR_PTR(-ENOMEM);
 	fib_entry = &fib6_entry->common;
 
-	mlxsw_sp_rt6 = mlxsw_sp_rt6_create(rt);
-	if (IS_ERR(mlxsw_sp_rt6)) {
-		err = PTR_ERR(mlxsw_sp_rt6);
-		goto err_rt6_create;
+	INIT_LIST_HEAD(&fib6_entry->rt6_list);
+
+	for (i = 0; i < nrt6; i++) {
+		mlxsw_sp_rt6 = mlxsw_sp_rt6_create(rt_arr[i]);
+		if (IS_ERR(mlxsw_sp_rt6)) {
+			err = PTR_ERR(mlxsw_sp_rt6);
+			goto err_rt6_create;
+		}
+		list_add_tail(&mlxsw_sp_rt6->list, &fib6_entry->rt6_list);
+		fib6_entry->nrt6++;
 	}
 
-	mlxsw_sp_fib6_entry_type_set(mlxsw_sp, fib_entry, mlxsw_sp_rt6->rt);
+	mlxsw_sp_fib6_entry_type_set(mlxsw_sp, fib_entry, rt_arr[0]);
 
-	INIT_LIST_HEAD(&fib6_entry->rt6_list);
-	list_add_tail(&mlxsw_sp_rt6->list, &fib6_entry->rt6_list);
-	fib6_entry->nrt6 = 1;
 	err = mlxsw_sp_nexthop6_group_get(mlxsw_sp, fib6_entry);
 	if (err)
 		goto err_nexthop6_group_get;
@@ -5405,9 +5408,15 @@ mlxsw_sp_fib6_entry_create(struct mlxsw_sp *mlxsw_sp,
 	return fib6_entry;
 
 err_nexthop6_group_get:
-	list_del(&mlxsw_sp_rt6->list);
-	mlxsw_sp_rt6_destroy(mlxsw_sp_rt6);
+	i = nrt6;
 err_rt6_create:
+	for (i--; i >= 0; i--) {
+		fib6_entry->nrt6--;
+		mlxsw_sp_rt6 = list_last_entry(&fib6_entry->rt6_list,
+					       struct mlxsw_sp_rt6, list);
+		list_del(&mlxsw_sp_rt6->list);
+		mlxsw_sp_rt6_destroy(mlxsw_sp_rt6);
+	}
 	kfree(fib6_entry);
 	return ERR_PTR(err);
 }
@@ -5608,7 +5617,8 @@ static int mlxsw_sp_router_fib6_add(struct mlxsw_sp *mlxsw_sp,
 		return 0;
 	}
 
-	fib6_entry = mlxsw_sp_fib6_entry_create(mlxsw_sp, fib_node, rt);
+	fib6_entry = mlxsw_sp_fib6_entry_create(mlxsw_sp, fib_node, rt_arr,
+						nrt6);
 	if (IS_ERR(fib6_entry)) {
 		err = PTR_ERR(fib6_entry);
 		goto err_fib6_entry_create;
-- 
2.20.1


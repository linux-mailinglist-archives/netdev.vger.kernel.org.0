Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51B474A4EA
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 17:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729715AbfFRPNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 11:13:49 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:39717 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729638AbfFRPNp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 11:13:45 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id CE89422374;
        Tue, 18 Jun 2019 11:13:44 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 18 Jun 2019 11:13:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=lVgmApZ+oRC/ZvNE2AyxdSOuR2ZD+IR00nw+cjBqA9g=; b=qs27TsuY
        GbTVtH4WxUZb8WK4Ref1DTp0EIRMksl93AhtxRR5OqQJFHV+dBCcdQGnV/JchUY5
        T1Pj9mu0IZzwBzccerSv0f3UKUnLafmUKzIMbjaSmouJ/hGl+6z6jN94Vqs4FCrU
        xb21GDqtKvZAmke/0yXpBioVHKoYE7SHlmtu08sF4PvJFEGzujgT6FsFQSF1DgEQ
        CYRb1PfIRYyT9pmdSfB6+8Oo6ts6zsqlHri3exE7yyqJN4t4SkwQzovc8DjHvVVO
        9EBuTJEr5cky51KY5QQKFGDEDxml7Rrjnye6ejBiPDL3VpEo4ktY28+S9f6IOL3M
        uN7LD0kavSmB+A==
X-ME-Sender: <xms:qP8IXd_gzA3hLHT4wnoB80CMsHO5DxLGk4zaaJr3I8SVbyMpYSWwwQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrtddtgdehhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepuddt
X-ME-Proxy: <xmx:qP8IXQDzVb_swl02zFwrnxTsBS1OCfaM41tITGDTaYoBYFfhWXlsvQ>
    <xmx:qP8IXRmg-8-CPENNlnCJyxA0MSynlgz7OD9V74NL6x_nYWg1TMtM2w>
    <xmx:qP8IXRGyqQuErvVq0kjfMdEp53QUuD6wgrjPmtDSF1fTwOOXhGRzvA>
    <xmx:qP8IXfcxRo8tiHbXs6T25Bw_MA6-cOI-heOA2tOTPsDnQ6zDjqOrOg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2B942380083;
        Tue, 18 Jun 2019 11:13:43 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, dsahern@gmail.com,
        alexpe@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 11/16] mlxsw: spectrum_router: Adjust IPv6 replace logic to new notifications
Date:   Tue, 18 Jun 2019 18:12:53 +0300
Message-Id: <20190618151258.23023-12-idosch@idosch.org>
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

Previously, IPv6 replace notifications were only sent from
fib6_add_rt2node(). The function only emitted such notifications if a
route actually replaced another route.

A previous patch added another call site in ip6_route_multipath_add()
from which such notification can be emitted even if a route was merely
added and did not replace another route.

Adjust the driver to take this into account and potentially set the
'replace' flag to 'false' if the notified route did not replace an
existing route.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 42e0e9677b91..dff96d1b0970 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -5435,16 +5435,16 @@ mlxsw_sp_fib6_node_entry_find(const struct mlxsw_sp_fib_node *fib_node,
 
 static int
 mlxsw_sp_fib6_node_list_insert(struct mlxsw_sp_fib6_entry *new6_entry,
-			       bool replace)
+			       bool *p_replace)
 {
 	struct mlxsw_sp_fib_node *fib_node = new6_entry->common.fib_node;
 	struct fib6_info *nrt = mlxsw_sp_fib6_entry_rt(new6_entry);
 	struct mlxsw_sp_fib6_entry *fib6_entry;
 
-	fib6_entry = mlxsw_sp_fib6_node_entry_find(fib_node, nrt, replace);
+	fib6_entry = mlxsw_sp_fib6_node_entry_find(fib_node, nrt, *p_replace);
 
-	if (replace && WARN_ON(!fib6_entry))
-		return -EINVAL;
+	if (*p_replace && !fib6_entry)
+		*p_replace = false;
 
 	if (fib6_entry) {
 		list_add_tail(&new6_entry->common.list,
@@ -5479,11 +5479,11 @@ mlxsw_sp_fib6_node_list_remove(struct mlxsw_sp_fib6_entry *fib6_entry)
 
 static int mlxsw_sp_fib6_node_entry_link(struct mlxsw_sp *mlxsw_sp,
 					 struct mlxsw_sp_fib6_entry *fib6_entry,
-					 bool replace)
+					 bool *p_replace)
 {
 	int err;
 
-	err = mlxsw_sp_fib6_node_list_insert(fib6_entry, replace);
+	err = mlxsw_sp_fib6_node_list_insert(fib6_entry, p_replace);
 	if (err)
 		return err;
 
@@ -5596,7 +5596,7 @@ static int mlxsw_sp_router_fib6_add(struct mlxsw_sp *mlxsw_sp,
 		goto err_fib6_entry_create;
 	}
 
-	err = mlxsw_sp_fib6_node_entry_link(mlxsw_sp, fib6_entry, replace);
+	err = mlxsw_sp_fib6_node_entry_link(mlxsw_sp, fib6_entry, &replace);
 	if (err)
 		goto err_fib6_node_entry_link;
 
-- 
2.20.1


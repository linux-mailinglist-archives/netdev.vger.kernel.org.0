Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B711147055
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 16:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbfFOOJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 10:09:47 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:45629 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726400AbfFOOJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 10:09:46 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 9D4EF21EAF;
        Sat, 15 Jun 2019 10:09:45 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sat, 15 Jun 2019 10:09:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=KRd+twccF50HWC6fvzIf8mLs56xcEQMtpkx6LwpuQ/s=; b=oErcNM+M
        Zk4+OTUZivNrVnDR/SAP9au3SFc+cHuvLHz0hF0b9rFhA1U9GHMKrcns5OwlSiWw
        8FjlKUD+lqfbInbq9SfRK1IShOPtdVvORGuhY2rb97WjYoUVr65XjSR8keWruWrH
        w8OaPFuWepajgGgdGHN3LagYrog7TrLgtGoRYIKllLzZ9Gedp52jOkVVpAj1omw/
        XTkqKPzwOhKzF4JW32poUllUhkEW6iEAfxVp4UOvsl0wkKYMa4VdFF7yyVwdSk3r
        iJkShTCOIlylpB3HVeyF86987NBOSs7z6RNbCmmWjueVLTDQ2Aa8yr0VztCejxje
        rnv2EbaXRHpb4g==
X-ME-Sender: <xms:KfwEXdqHyw8h7j65aWTd4kGctXz31JtqtgGAwTXquRWeVl9WeW137Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudeifedgjeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudejkedrgeefrddvudeknecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgeptd
X-ME-Proxy: <xmx:KfwEXQXA9sPx-mnO1OWjriPMPSt5QfZHu8XjpRNh_l_ANUpmk8Y6lA>
    <xmx:KfwEXVSnJ6paU2G_rALD-LFjf1VwMlllUgZ21Jah4EtctnUa5HsokA>
    <xmx:KfwEXY6IeI9-6IG2KwG19qPYkNgLq707JKIKf10Jf0otEaQvaSgc7A>
    <xmx:KfwEXc36-JKZNr43QfsLPzfT1vOaRbVwv7HTenNv9mk41hUIuGbJkw>
Received: from splinter.mtl.com (bzq-79-178-43-218.red.bezeqint.net [79.178.43.218])
        by mail.messagingengine.com (Postfix) with ESMTPA id A4B60380085;
        Sat, 15 Jun 2019 10:09:42 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@gmail.com, jiri@mellanox.com,
        alexpe@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 12/17] mlxsw: spectrum_router: Adjust IPv6 replace logic to new notifications
Date:   Sat, 15 Jun 2019 17:07:46 +0300
Message-Id: <20190615140751.17661-13-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190615140751.17661-1-idosch@idosch.org>
References: <20190615140751.17661-1-idosch@idosch.org>
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
index 1f96621eb219..49557eca48e0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -5368,16 +5368,16 @@ mlxsw_sp_fib6_node_entry_find(const struct mlxsw_sp_fib_node *fib_node,
 
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
@@ -5412,11 +5412,11 @@ mlxsw_sp_fib6_node_list_remove(struct mlxsw_sp_fib6_entry *fib6_entry)
 
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
 
@@ -5529,7 +5529,7 @@ static int mlxsw_sp_router_fib6_add(struct mlxsw_sp *mlxsw_sp,
 		goto err_fib6_entry_create;
 	}
 
-	err = mlxsw_sp_fib6_node_entry_link(mlxsw_sp, fib6_entry, replace);
+	err = mlxsw_sp_fib6_node_entry_link(mlxsw_sp, fib6_entry, &replace);
 	if (err)
 		goto err_fib6_node_entry_link;
 
-- 
2.20.1


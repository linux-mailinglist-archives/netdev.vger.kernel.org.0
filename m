Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C09A1BA792
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 17:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728230AbgD0PNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 11:13:51 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:48547 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727006AbgD0PNn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 11:13:43 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 07ADE5C0065;
        Mon, 27 Apr 2020 11:13:42 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 27 Apr 2020 11:13:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=KcXo1mbcgD9Q5Svgact5s+kVwnxv+9szMzsIABTtO90=; b=b+uVN6uL
        1J6pWTukEvHFQFfruBwLaQueYYKEmtEK2xPItms1HGMbsUl3eSfXkauDm8dWXOks
        JAykIhjYTRf0D0i4VZ0TUdO5tOfuHRgcfVWQqFeha9Rww/v+LU2Bf+g83npLpCku
        nww0LsbEDXtJAmq8mW3mT51m/dZERF2i8wlC8YppvhInn8rSosF3WiFJ1X83GQUJ
        3SrmCfV1CzkRR47a6d2hHGfseaJG8BHFdK07FJg/Q8sgNkeqCKqSX9lBMr/EYWuD
        dMvEAsVu/v43a2A6YdDEZA+lz5/RpwbQmBqklAl1FSchifOVBb0uEFvCqgXP7rVB
        HcWhMahH/asy8g==
X-ME-Sender: <xms:pfamXhIcInriqMQHhisfQGY0wmP7xXwqqO8F0NxylW7BUQYiE6v2ew>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrheelgdekgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepjeelrddukedtrdehgedrudduieenucevlhhushhtvghruf
    hiiigvpeejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghh
    rdhorhhg
X-ME-Proxy: <xmx:pfamXov38uqOeawYydy5tddgWrErXpho5eR-_hS9OeYFiHxF44rN_Q>
    <xmx:pfamXgvtD0pTmcdELqP3KlnsFQqq8IJpTHd0ce2FivGZCZm0pQ7H2A>
    <xmx:pfamXkDzQDnbmCsDeL94uPk0x_-hnFb11WHLD3sgW4pbPoURXkbGZg>
    <xmx:pvamXnOwfersr0wOBBGzHH2EUp-uk_mQ1GhqtUrQJ-90IU0viXus6w>
Received: from splinter.mtl.com (bzq-79-180-54-116.red.bezeqint.net [79.180.54.116])
        by mail.messagingengine.com (Postfix) with ESMTPA id BFD0D3280064;
        Mon, 27 Apr 2020 11:13:40 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 08/13] mlxsw: spectrum_matchall: Move ingress indication into mall_entry
Date:   Mon, 27 Apr 2020 18:13:05 +0300
Message-Id: <20200427151310.3950411-9-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200427151310.3950411-1-idosch@idosch.org>
References: <20200427151310.3950411-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Instead of having it in mirror_entry structure, move it to mall_entry
and set it during rule insertion.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../mellanox/mlxsw/spectrum_matchall.c         | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
index adaaee208655..c05e28971d06 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
@@ -18,13 +18,13 @@ enum mlxsw_sp_mall_action_type {
 struct mlxsw_sp_mall_mirror_entry {
 	const struct net_device *to_dev;
 	int span_id;
-	bool ingress;
 };
 
 struct mlxsw_sp_mall_entry {
 	struct list_head list;
 	unsigned long cookie;
 	enum mlxsw_sp_mall_action_type type;
+	bool ingress;
 	union {
 		struct mlxsw_sp_mall_mirror_entry mirror;
 		struct mlxsw_sp_port_sample sample;
@@ -45,8 +45,7 @@ mlxsw_sp_mall_entry_find(struct mlxsw_sp_port *port, unsigned long cookie)
 
 static int
 mlxsw_sp_mall_port_mirror_add(struct mlxsw_sp_port *mlxsw_sp_port,
-			      struct mlxsw_sp_mall_entry *mall_entry,
-			      bool ingress)
+			      struct mlxsw_sp_mall_entry *mall_entry)
 {
 	enum mlxsw_sp_span_type span_type;
 
@@ -55,9 +54,8 @@ mlxsw_sp_mall_port_mirror_add(struct mlxsw_sp_port *mlxsw_sp_port,
 		return -EINVAL;
 	}
 
-	mall_entry->mirror.ingress = ingress;
-	span_type = mall_entry->mirror.ingress ? MLXSW_SP_SPAN_INGRESS :
-						 MLXSW_SP_SPAN_EGRESS;
+	span_type = mall_entry->ingress ? MLXSW_SP_SPAN_INGRESS :
+					  MLXSW_SP_SPAN_EGRESS;
 	return mlxsw_sp_span_mirror_add(mlxsw_sp_port,
 					mall_entry->mirror.to_dev,
 					span_type, true,
@@ -70,8 +68,8 @@ mlxsw_sp_mall_port_mirror_del(struct mlxsw_sp_port *mlxsw_sp_port,
 {
 	enum mlxsw_sp_span_type span_type;
 
-	span_type = mall_entry->mirror.ingress ? MLXSW_SP_SPAN_INGRESS :
-						 MLXSW_SP_SPAN_EGRESS;
+	span_type = mall_entry->ingress ? MLXSW_SP_SPAN_INGRESS :
+					  MLXSW_SP_SPAN_EGRESS;
 	mlxsw_sp_span_mirror_del(mlxsw_sp_port, mall_entry->mirror.span_id,
 				 span_type, true);
 }
@@ -142,14 +140,14 @@ int mlxsw_sp_mall_replace(struct mlxsw_sp_port *mlxsw_sp_port,
 	if (!mall_entry)
 		return -ENOMEM;
 	mall_entry->cookie = f->cookie;
+	mall_entry->ingress = ingress;
 
 	act = &f->rule->action.entries[0];
 
 	if (act->id == FLOW_ACTION_MIRRED && protocol == htons(ETH_P_ALL)) {
 		mall_entry->type = MLXSW_SP_MALL_ACTION_TYPE_MIRROR;
 		mall_entry->mirror.to_dev = act->dev;
-		err = mlxsw_sp_mall_port_mirror_add(mlxsw_sp_port, mall_entry,
-						    ingress);
+		err = mlxsw_sp_mall_port_mirror_add(mlxsw_sp_port, mall_entry);
 	} else if (act->id == FLOW_ACTION_SAMPLE &&
 		   protocol == htons(ETH_P_ALL)) {
 		if (act->sample.rate > MLXSW_REG_MPSC_RATE_MAX) {
-- 
2.24.1


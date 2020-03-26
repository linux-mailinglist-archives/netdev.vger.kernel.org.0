Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4BE194119
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 15:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbgCZORu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 10:17:50 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:59939 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727695AbgCZORu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 10:17:50 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 61F335C021F;
        Thu, 26 Mar 2020 10:17:49 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 26 Mar 2020 10:17:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=9zxaI9XhqCwf8a2xI
        nJWAx7FO2XISc7YgFkeK96wlqI=; b=VH0cE8O4rE9adKB8Hpuy8zRtC5iyFa9jy
        5gWq34nXnRyYBpjO+bNnUYAsie46BaQjffQeMjhn8ZTW5+Por2Ffe2LAcAczvE/m
        aj0q5zZ9j0U00s7Z7SIBJ9lCu8BNsFH8t0f0TZ2KN75o8FGdcKuuuXxNJCPFF3BM
        DFk1NFM+xcV6NsxAeTDSS21KRqpUVO4ziEJc8IuB/7oYZsdCMbiYH3DIx1loIIuf
        uTVdGNnlE1ieGrJTZfy/DMSiZsXaCga2QcLRDMeaut4rqnEFbv4KEM1XJYsJR4MJ
        8Cw6oAm/Nv5DF7qbr2A6paJPB3Z64c7bxcnCEmNgAEPkTaiB8msrQ==
X-ME-Sender: <xms:jbl8XgK5XlHBpTg5TsSkh6M_Tg1H0LXvI6EtXKpuvafRsdnTf0wj-w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudehiedgiedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeejledrudekuddrudefvddrudeludenucevlhhushhtvghruf
    hiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghh
    rdhorhhg
X-ME-Proxy: <xmx:jbl8XrD5yTUgd1wd5I_tJfmSAF-zR2RoHM3U8mmdauYJZrFsgR5d2g>
    <xmx:jbl8XhpQm5kYciXR2fKGCAeBvHCOoN6LmMjtLAyNKG6g6i7LShPO1Q>
    <xmx:jbl8XkbV5k_ichSuDvVICsz05IHd5ZBl8vjS7gI7xTCF9K8oJlcPzQ>
    <xmx:jbl8XmnmiAZZSJRtoIbmVO7bmjOCP9rGRnw-rCdxqyrPQgwdF1tcYw>
Received: from splinter.mtl.com (bzq-79-181-132-191.red.bezeqint.net [79.181.132.191])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1C47F3280059;
        Thu, 26 Mar 2020 10:17:47 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net] mlxsw: spectrum_mr: Fix list iteration in error path
Date:   Thu, 26 Mar 2020 16:17:33 +0200
Message-Id: <20200326141733.1395337-1-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

list_for_each_entry_from_reverse() iterates backwards over the list from
the current position, but in the error path we should start from the
previous position.

Fix this by using list_for_each_entry_continue_reverse() instead.

This suppresses the following error from coccinelle:

drivers/net/ethernet/mellanox/mlxsw//spectrum_mr.c:655:34-38: ERROR:
invalid reference to the index variable of the iterator on line 636

Fixes: c011ec1bbfd6 ("mlxsw: spectrum: Add the multicast routing offloading logic")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c
index 54275624718b..336e5ecc68f8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c
@@ -637,12 +637,12 @@ static int mlxsw_sp_mr_vif_resolve(struct mlxsw_sp_mr_table *mr_table,
 	return 0;
 
 err_erif_unresolve:
-	list_for_each_entry_from_reverse(erve, &mr_vif->route_evif_list,
-					 vif_node)
+	list_for_each_entry_continue_reverse(erve, &mr_vif->route_evif_list,
+					     vif_node)
 		mlxsw_sp_mr_route_evif_unresolve(mr_table, erve);
 err_irif_unresolve:
-	list_for_each_entry_from_reverse(irve, &mr_vif->route_ivif_list,
-					 vif_node)
+	list_for_each_entry_continue_reverse(irve, &mr_vif->route_ivif_list,
+					     vif_node)
 		mlxsw_sp_mr_route_ivif_unresolve(mr_table, irve);
 	mr_vif->rif = NULL;
 	return err;
-- 
2.24.1


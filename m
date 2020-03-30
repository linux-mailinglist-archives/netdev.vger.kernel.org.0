Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 966931984AF
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 21:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728987AbgC3Tje (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 15:39:34 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:34903 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727406AbgC3Tjd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 15:39:33 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 8B0AA580545;
        Mon, 30 Mar 2020 15:39:32 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 30 Mar 2020 15:39:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=0ZPz9qMvTYlXx4wYQuhJJCeI2ymcYIX+JBiCZuuBCjo=; b=m0I8OvWS
        Zb0NTOQOXh3QnEkf2/I0Ki36l6h88B3Pu3BskVcMxwIhwM64hjrj84wCRfUHPYTs
        GP8t8Z7rVIy2yYaIR+Xyuhxh44wSHiyGcdKg8sMLwyMPLpXqBzo8HyvMuBunEeso
        TSrIVynfUwDxybdMYzQi+CgP8RdLYWsooIFyozaiU/3barGN8ez7lssGhFRFu0iT
        omlNaixglI9vHZ1RfPkMxzJ5ej5D5dJhefIJt/sixdh3sKvhH7TmwGYJttgwZ3js
        +YITkK9dz8gmf4O/Wa8k+T0eZ4tRNppUwkZVGXEGs7xJpU6/tusaew6giNwbjG6z
        6s2rxvxKkRgqVA==
X-ME-Sender: <xms:9EqCXr5JhFUwTdMZ5LHvtWqfj-14FbjSt2CbB-WNOdP2XUGljri5SA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeihedgudeflecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepjeelrddukedurddufedvrdduledunecuvehluhhsth
    gvrhfuihiivgepuddtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihgu
    ohhstghhrdhorhhg
X-ME-Proxy: <xmx:9EqCXkuZDZEBE7DdMyD2Wv6uFvbLTsYuLmIXfJLv8h7qm8mi0atppg>
    <xmx:9EqCXgr3xEE5qbmBjRa5ysZsz8mdZS3b8ggsIfAdh7zKuTBKL7qKHA>
    <xmx:9EqCXl-IeuCvVJ2LnSun-BUYQzIc79Yay1X-hjjGNWM3cUdoBe_TVA>
    <xmx:9EqCXmhrD5WxI5K-vZZtPgAConzVox1Sh0zk9JLrPDejFRu7XHbxdg>
Received: from splinter.mtl.com (bzq-79-181-132-191.red.bezeqint.net [79.181.132.191])
        by mail.messagingengine.com (Postfix) with ESMTPA id 74156306C9F4;
        Mon, 30 Mar 2020 15:39:30 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v3 12/15] mlxsw: spectrum_trap: Do not initialize dedicated discard policer
Date:   Mon, 30 Mar 2020 22:38:29 +0300
Message-Id: <20200330193832.2359876-13-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200330193832.2359876-1-idosch@idosch.org>
References: <20200330193832.2359876-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The policer is now initialized as part of the registration with devlink,
so there is no need to initialize it before the registration.

Remove the initialization.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index b2e41eb5ffdb..579f1164ad5d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -307,8 +307,7 @@ static const u16 mlxsw_sp_listener_devlink_map[] = {
 	DEVLINK_TRAP_GENERIC_ID_EGRESS_FLOW_ACTION_DROP,
 };
 
-#define MLXSW_SP_DISCARD_POLICER_ID	(MLXSW_REG_HTGT_TRAP_GROUP_MAX + 1)
-#define MLXSW_SP_THIN_POLICER_ID	(MLXSW_SP_DISCARD_POLICER_ID + 1)
+#define MLXSW_SP_THIN_POLICER_ID	(MLXSW_REG_HTGT_TRAP_GROUP_MAX + 1)
 
 static struct mlxsw_sp_trap_policer_item *
 mlxsw_sp_trap_policer_item_lookup(struct mlxsw_sp *mlxsw_sp, u32 id)
@@ -327,13 +326,6 @@ mlxsw_sp_trap_policer_item_lookup(struct mlxsw_sp *mlxsw_sp, u32 id)
 static int mlxsw_sp_trap_cpu_policers_set(struct mlxsw_sp *mlxsw_sp)
 {
 	char qpcr_pl[MLXSW_REG_QPCR_LEN];
-	int err;
-
-	mlxsw_reg_qpcr_pack(qpcr_pl, MLXSW_SP_DISCARD_POLICER_ID,
-			    MLXSW_REG_QPCR_IR_UNITS_M, false, 10 * 1024, 7);
-	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(qpcr), qpcr_pl);
-	if (err)
-		return err;
 
 	/* The purpose of "thin" policer is to drop as many packets
 	 * as possible. The dummy group is using it.
-- 
2.24.1


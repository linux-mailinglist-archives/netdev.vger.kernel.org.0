Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2EE212C259
	for <lists+netdev@lfdr.de>; Sun, 29 Dec 2019 12:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbfL2Ls4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Dec 2019 06:48:56 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:36579 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726151AbfL2Lsz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Dec 2019 06:48:55 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id C159B21DFB;
        Sun, 29 Dec 2019 06:48:54 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 29 Dec 2019 06:48:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=N2t9DSuK9/u5fLbpDY+LkjGdMP4qJVIRtONzzABH2Xw=; b=iY+nzHZ6
        Gi3tYO6hzNOl4SErUKSO0aDrD3Xdahm2WFaD1OTKPtTkg/LPuVyULTn0QlApU5FP
        MsQmWgmg3TgzhaGSNvktaQePD/tuS8Z2PgUV3/88JTAjtaIfPkR9GicacYY7QBr/
        GHFiHHvSd26eETO3EHl2P9ZFesqmjThPKEO9kG8vNz2/4mRnFo0HZURJOeYlBFHd
        6mkgnOOLhgkT9rucKcvFN0xrFwuQLlZ8qdsjq6xK02nRiV/+gippov5pdxCP7Tq1
        1r+LkK+ousbOa6uYANkFKIdZJupi8ozeafo14D9O3cKxoluELoSW81pcn8yZC9by
        fMwqHA11wgoHsw==
X-ME-Sender: <xms:ppIIXuJHZVGBrCCpb6-mhXRuDFo4uDggopAcNdelt4D_LpR2mx5dCg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdeffedgfedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudekuddriedurdduudejnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgeptd
X-ME-Proxy: <xmx:ppIIXgdOunmn6WD-UpbkCh52zhN_qePOl2Jyfah-lEaKS5g_eN6KqQ>
    <xmx:ppIIXmNzdHm17iEIJRWdyjepVeS_3iQdJz4O-WT1LKy_qbzKVjYmVQ>
    <xmx:ppIIXiJINGPxcA3G1DLbuRkQd6_KBf8m2nkvszNu4LO_ZingUoTaTA>
    <xmx:ppIIXnerCFS97LQKjMcMzzLu0vRWrNBSuWeMdb-RhCbH0cXw4CUrjg>
Received: from splinter.mtl.com (bzq-79-181-61-117.red.bezeqint.net [79.181.61.117])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2A3213060A32;
        Sun, 29 Dec 2019 06:48:53 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 2/3] mlxsw: spectrum_dcb: Allow setting default port priority
Date:   Sun, 29 Dec 2019 13:48:28 +0200
Message-Id: <20191229114829.61803-3-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229114829.61803-1-idosch@idosch.org>
References: <20191229114829.61803-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

When APP TLV selector 1 (EtherType) is used with PID of 0, the
corresponding entry specifies "default application priority [...] when
application priority is not otherwise specified."

mlxsw currently supports this type of APP entry, but uses it only as a
fallback for unspecified DSCP rules. However non-IP traffic is prioritized
according to port-default priority, not according to the DSCP-to-prio
tables, and thus it's currently not possible to prioritize such traffic
correctly.

Extend the use of the abovementioned APP entry to also set default port
priority.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum_dcb.c  | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
index fe3bbba90659..db66f2b56a6d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
@@ -368,6 +368,17 @@ mlxsw_sp_port_dcb_toggle_trust(struct mlxsw_sp_port *mlxsw_sp_port,
 	return err;
 }
 
+static int
+mlxsw_sp_port_dcb_app_update_qpdp(struct mlxsw_sp_port *mlxsw_sp_port,
+				  u8 default_prio)
+{
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	char qpdp_pl[MLXSW_REG_QPDP_LEN];
+
+	mlxsw_reg_qpdp_pack(qpdp_pl, mlxsw_sp_port->local_port, default_prio);
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(qpdp), qpdp_pl);
+}
+
 static int
 mlxsw_sp_port_dcb_app_update_qpdpm(struct mlxsw_sp_port *mlxsw_sp_port,
 				   struct dcb_ieee_app_dscp_map *map)
@@ -405,6 +416,12 @@ static int mlxsw_sp_port_dcb_app_update(struct mlxsw_sp_port *mlxsw_sp_port)
 	int err;
 
 	default_prio = mlxsw_sp_port_dcb_app_default_prio(mlxsw_sp_port);
+	err = mlxsw_sp_port_dcb_app_update_qpdp(mlxsw_sp_port, default_prio);
+	if (err) {
+		netdev_err(mlxsw_sp_port->dev, "Couldn't configure port default priority\n");
+		return err;
+	}
+
 	have_dscp = mlxsw_sp_port_dcb_app_prio_dscp_map(mlxsw_sp_port,
 							&prio_map);
 
-- 
2.24.1


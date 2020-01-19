Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAB25141DE8
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 14:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727285AbgASNBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 08:01:36 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:48413 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727123AbgASNBf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 08:01:35 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id DD7BA216C5;
        Sun, 19 Jan 2020 08:01:34 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 19 Jan 2020 08:01:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=ogps0mhKgPGbAzUIZs0b+CVW3pOSgzrkHHhdY8iai0k=; b=ZpULbVpN
        tEhdq0Lp9bwrD/QdLazKmkbLtXKHLGlautrzbQhCy+YfqpGmBIfAS4MlrWcVoawk
        CqdN8LnT0vPKMS38JPGItw0rds0aTcEcPFSfLJmo6YngaYvwuBV+EXMVX9eXwAsv
        s6hg7012k8Jb+Xzg/WTTfo3DKCIGMXl/18rG2G6zQgsFLaqX7yg3uoQOMYYFESoe
        kSd/srREbRPeOlK2Fsqw55diuZws1W3bx3x83eZoe8jjLsW3okTH/NjrWxLbjvu9
        aHw8LY1t7XtJ8fB7xSC1wV22zFuek2wUGr/xnSDc5Rmjcx7rYHS39/fpbAAAgMZ8
        QQDJrzGqB8qGHg==
X-ME-Sender: <xms:LlMkXqZrxRD687AENmXvYq33-NHOAxI9hgQLZNn-8ZUkZ5yVfL0p_w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudefgdegiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgephe
X-ME-Proxy: <xmx:LlMkXpHJcMCUqiQcUxfK8xL20poKILs_L1XEiZFDIT5dv-_mcEf9ow>
    <xmx:LlMkXvpxEnEL3J5hvYD_9Tvy_a6iVS9pqiGil6lh8-x03zfbKyxf2Q>
    <xmx:LlMkXtlq42NyjrG1SN-7FOTNc2uchy3ouVzxeVTDNEnITpB11QJv9Q>
    <xmx:LlMkXsN1Z-PWv8-MDLc7xl4RbzujJ53JXuiX31bNO_P_m2Mwdss7oQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8A29080061;
        Sun, 19 Jan 2020 08:01:33 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, amitc@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 07/15] mlxsw: Add ECN configurations with IPinIP tunnels
Date:   Sun, 19 Jan 2020 15:00:52 +0200
Message-Id: <20200119130100.3179857-8-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200119130100.3179857-1-idosch@idosch.org>
References: <20200119130100.3179857-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

Initialize ECN mapping registers during router init according to
INET_ECN_encapsulate() and INET_ECN_decapsulate().

For IP-in-IP encapsulation, this is required to ensure that ECN bits in
the underlay are set in accordance with the kernel. For decapsulation,
this is required to ensure that packets with invalid ECN combination in
underlay and overlay are trapped to the kernel and not forwarded.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_ipip.c   | 60 +++++++++++++++++++
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 10 ++++
 .../ethernet/mellanox/mlxsw/spectrum_router.h |  3 +
 3 files changed, 73 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
index 6400cd644b7a..a8525992528f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
@@ -3,8 +3,10 @@
 
 #include <net/ip_tunnels.h>
 #include <net/ip6_tunnel.h>
+#include <net/inet_ecn.h>
 
 #include "spectrum_ipip.h"
+#include "reg.h"
 
 struct ip_tunnel_parm
 mlxsw_sp_ipip_netdev_parms4(const struct net_device *ol_dev)
@@ -338,3 +340,61 @@ static const struct mlxsw_sp_ipip_ops mlxsw_sp_ipip_gre4_ops = {
 const struct mlxsw_sp_ipip_ops *mlxsw_sp_ipip_ops_arr[] = {
 	[MLXSW_SP_IPIP_TYPE_GRE4] = &mlxsw_sp_ipip_gre4_ops,
 };
+
+static int mlxsw_sp_ipip_ecn_encap_init_one(struct mlxsw_sp *mlxsw_sp,
+					    u8 inner_ecn, u8 outer_ecn)
+{
+	char tieem_pl[MLXSW_REG_TIEEM_LEN];
+
+	mlxsw_reg_tieem_pack(tieem_pl, inner_ecn, outer_ecn);
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(tieem), tieem_pl);
+}
+
+int mlxsw_sp_ipip_ecn_encap_init(struct mlxsw_sp *mlxsw_sp)
+{
+	int i;
+
+	/* Iterate over inner ECN values */
+	for (i = INET_ECN_NOT_ECT; i <= INET_ECN_CE; i++) {
+		u8 outer_ecn = INET_ECN_encapsulate(0, i);
+		int err;
+
+		err = mlxsw_sp_ipip_ecn_encap_init_one(mlxsw_sp, i, outer_ecn);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static int mlxsw_sp_ipip_ecn_decap_init_one(struct mlxsw_sp *mlxsw_sp,
+					    u8 inner_ecn, u8 outer_ecn)
+{
+	char tidem_pl[MLXSW_REG_TIDEM_LEN];
+	bool trap_en, set_ce = false;
+	u8 new_inner_ecn;
+
+	trap_en = __INET_ECN_decapsulate(outer_ecn, inner_ecn, &set_ce);
+	new_inner_ecn = set_ce ? INET_ECN_CE : inner_ecn;
+
+	mlxsw_reg_tidem_pack(tidem_pl, outer_ecn, inner_ecn, new_inner_ecn,
+			     trap_en, trap_en ? MLXSW_TRAP_ID_DECAP_ECN0 : 0);
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(tidem), tidem_pl);
+}
+
+int mlxsw_sp_ipip_ecn_decap_init(struct mlxsw_sp *mlxsw_sp)
+{
+	int i, j, err;
+
+	/* Iterate over inner ECN values */
+	for (i = INET_ECN_NOT_ECT; i <= INET_ECN_CE; i++) {
+		/* Iterate over outer ECN values */
+		for (j = INET_ECN_NOT_ECT; j <= INET_ECN_CE; j++) {
+			err = mlxsw_sp_ipip_ecn_decap_init_one(mlxsw_sp, i, j);
+			if (err)
+				return err;
+		}
+	}
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index a014bd8d504d..ce707723f8cf 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -7791,8 +7791,18 @@ mlxsw_sp_ipip_config_tigcr(struct mlxsw_sp *mlxsw_sp)
 
 static int mlxsw_sp_ipips_init(struct mlxsw_sp *mlxsw_sp)
 {
+	int err;
+
 	mlxsw_sp->router->ipip_ops_arr = mlxsw_sp_ipip_ops_arr;
 	INIT_LIST_HEAD(&mlxsw_sp->router->ipip_list);
+
+	err = mlxsw_sp_ipip_ecn_encap_init(mlxsw_sp);
+	if (err)
+		return err;
+	err = mlxsw_sp_ipip_ecn_decap_init(mlxsw_sp);
+	if (err)
+		return err;
+
 	return mlxsw_sp_ipip_config_tigcr(mlxsw_sp);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
index cc1de91e8217..c9b94f435cdd 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
@@ -104,4 +104,7 @@ static inline bool mlxsw_sp_l3addr_eq(const union mlxsw_sp_l3addr *addr1,
 	return !memcmp(addr1, addr2, sizeof(*addr1));
 }
 
+int mlxsw_sp_ipip_ecn_encap_init(struct mlxsw_sp *mlxsw_sp);
+int mlxsw_sp_ipip_ecn_decap_init(struct mlxsw_sp *mlxsw_sp);
+
 #endif /* _MLXSW_ROUTER_H_*/
-- 
2.24.1


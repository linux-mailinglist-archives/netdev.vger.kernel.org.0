Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69C16417B4B
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 20:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348189AbhIXSuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 14:50:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:46462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345726AbhIXStz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 14:49:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78F0361241;
        Fri, 24 Sep 2021 18:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632509301;
        bh=1iwRqgKab90FGDsBHx84dNJHBj3/xbiolRf3PKmYKCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lAzZDK2Z90Ks8Te2J+/5coWL7MyqtvVNPPTZ4N/qIssfT/GzElnyq6IkJrxYh5RsZ
         pifugkYXMQickcF2OGztdPujCo0fE6SlRRC2wXFVk1XPB5MBnyvYEF/1t3mgV5lvQd
         +35iqTWk+3bjKxa65Y3HMCOAW9n95rvV1FXsdb3Ea9+yzvMoO59AEvbplFF+MCDH9b
         TReV/PHp+PFVQEaCdWMVqKv/eUDBvYUGiJcKZwrzAnV3AE/NRoOYSDKPFX6P57bV1q
         tzX1DznerQClumbmdai214BqxSDk6+NtRSsKhcQfZbzV6MbBG02ZPPk8hGlbV+hTPz
         Lo0lEQVBVaBKw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 10/12] net/mlx5e: loopback test is not supported in switchdev mode
Date:   Fri, 24 Sep 2021 11:48:06 -0700
Message-Id: <20210924184808.796968-11-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210924184808.796968-1-saeed@kernel.org>
References: <20210924184808.796968-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

In switchdev mode we insert steering rules to eswitch that
make sure packets can't be looped back.
Modify the self tests infra and have flags per test.
Add a flag for tests that needs to be skipped in switchdev mode.

Before this commit:

$ ethtool --test enp8s0f0
 The test result is FAIL
 The test extra info:
 Link Test        0
 Speed Test       0
 Health Test      0
 Loopback Test    1

After this commit:

$ ethtool --test enp8s0f0
 The test result is PASS
 The test extra info:
 Link Test        0
 Speed Test       0
 Health Test      0

Example output in dmesg:

enp8s0f0: Self test begin..
enp8s0f0:         [0] Link Test start..
enp8s0f0:         [0] Link Test end: result(0)
enp8s0f0:         [1] Speed Test start..
enp8s0f0:         [1] Speed Test end: result(0)
enp8s0f0:         [2] Health Test start..
enp8s0f0:         [2] Health Test end: result(0)
enp8s0f0: Self test out: status flags(0x1)

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  3 +-
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  4 +-
 .../ethernet/mellanox/mlx5/core/en_selftest.c | 92 +++++++++++--------
 3 files changed, 56 insertions(+), 43 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 7b8c8187543a..f5d147c3141a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -220,8 +220,6 @@ struct mlx5e_umr_wqe {
 	struct mlx5_mtt                inline_mtts[0];
 };
 
-extern const char mlx5e_self_tests[][ETH_GSTRING_LEN];
-
 enum mlx5e_priv_flag {
 	MLX5E_PFLAG_RX_CQE_BASED_MODER,
 	MLX5E_PFLAG_TX_CQE_BASED_MODER,
@@ -916,6 +914,7 @@ void mlx5e_fold_sw_stats64(struct mlx5e_priv *priv, struct rtnl_link_stats64 *s)
 
 void mlx5e_init_l2_addr(struct mlx5e_priv *priv);
 int mlx5e_self_test_num(struct mlx5e_priv *priv);
+int mlx5e_self_test_fill_strings(struct mlx5e_priv *priv, u8 *data);
 void mlx5e_self_test(struct net_device *ndev, struct ethtool_test *etest,
 		     u64 *buf);
 void mlx5e_set_rx_mode_work(struct work_struct *work);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 306fb5d6a36d..485f208691ea 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -267,9 +267,7 @@ void mlx5e_ethtool_get_strings(struct mlx5e_priv *priv, u32 stringset, u8 *data)
 		break;
 
 	case ETH_SS_TEST:
-		for (i = 0; i < mlx5e_self_test_num(priv); i++)
-			strcpy(data + i * ETH_GSTRING_LEN,
-			       mlx5e_self_tests[i]);
+		mlx5e_self_test_fill_strings(priv, data);
 		break;
 
 	case ETH_SS_STATS:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c b/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
index ce8ab1f01876..8c9163d2c646 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
@@ -35,30 +35,7 @@
 #include <net/udp.h>
 #include "en.h"
 #include "en/port.h"
-
-enum {
-	MLX5E_ST_LINK_STATE,
-	MLX5E_ST_LINK_SPEED,
-	MLX5E_ST_HEALTH_INFO,
-#ifdef CONFIG_INET
-	MLX5E_ST_LOOPBACK,
-#endif
-	MLX5E_ST_NUM,
-};
-
-const char mlx5e_self_tests[MLX5E_ST_NUM][ETH_GSTRING_LEN] = {
-	"Link Test",
-	"Speed Test",
-	"Health Test",
-#ifdef CONFIG_INET
-	"Loopback Test",
-#endif
-};
-
-int mlx5e_self_test_num(struct mlx5e_priv *priv)
-{
-	return ARRAY_SIZE(mlx5e_self_tests);
-}
+#include "eswitch.h"
 
 static int mlx5e_test_health_info(struct mlx5e_priv *priv)
 {
@@ -265,6 +242,14 @@ static void mlx5e_test_loopback_cleanup(struct mlx5e_priv *priv,
 	mlx5e_refresh_tirs(priv, false, false);
 }
 
+static int mlx5e_cond_loopback(struct mlx5e_priv *priv)
+{
+	if (is_mdev_switchdev_mode(priv->mdev))
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+
 #define MLX5E_LB_VERIFY_TIMEOUT (msecs_to_jiffies(200))
 static int mlx5e_test_loopback(struct mlx5e_priv *priv)
 {
@@ -313,37 +298,47 @@ static int mlx5e_test_loopback(struct mlx5e_priv *priv)
 }
 #endif
 
-static int (*mlx5e_st_func[MLX5E_ST_NUM])(struct mlx5e_priv *) = {
-	mlx5e_test_link_state,
-	mlx5e_test_link_speed,
-	mlx5e_test_health_info,
+typedef int (*mlx5e_st_func)(struct mlx5e_priv *);
+
+struct mlx5e_st {
+	char name[ETH_GSTRING_LEN];
+	mlx5e_st_func st_func;
+	mlx5e_st_func cond_func;
+};
+
+static struct mlx5e_st mlx5e_sts[] = {
+	{ "Link Test", mlx5e_test_link_state },
+	{ "Speed Test", mlx5e_test_link_speed },
+	{ "Health Test", mlx5e_test_health_info },
 #ifdef CONFIG_INET
-	mlx5e_test_loopback,
+	{ "Loopback Test", mlx5e_test_loopback, mlx5e_cond_loopback },
 #endif
 };
 
+#define MLX5E_ST_NUM ARRAY_SIZE(mlx5e_sts)
+
 void mlx5e_self_test(struct net_device *ndev, struct ethtool_test *etest,
 		     u64 *buf)
 {
 	struct mlx5e_priv *priv = netdev_priv(ndev);
-	int i;
-
-	memset(buf, 0, sizeof(u64) * MLX5E_ST_NUM);
+	int i, count = 0;
 
 	mutex_lock(&priv->state_lock);
 	netdev_info(ndev, "Self test begin..\n");
 
 	for (i = 0; i < MLX5E_ST_NUM; i++) {
-		netdev_info(ndev, "\t[%d] %s start..\n",
-			    i, mlx5e_self_tests[i]);
-		buf[i] = mlx5e_st_func[i](priv);
-		netdev_info(ndev, "\t[%d] %s end: result(%lld)\n",
-			    i, mlx5e_self_tests[i], buf[i]);
+		struct mlx5e_st st = mlx5e_sts[i];
+
+		if (st.cond_func && st.cond_func(priv))
+			continue;
+		netdev_info(ndev, "\t[%d] %s start..\n", i, st.name);
+		buf[count] = st.st_func(priv);
+		netdev_info(ndev, "\t[%d] %s end: result(%lld)\n", i, st.name, buf[count]);
 	}
 
 	mutex_unlock(&priv->state_lock);
 
-	for (i = 0; i < MLX5E_ST_NUM; i++) {
+	for (i = 0; i < count; i++) {
 		if (buf[i]) {
 			etest->flags |= ETH_TEST_FL_FAILED;
 			break;
@@ -352,3 +347,24 @@ void mlx5e_self_test(struct net_device *ndev, struct ethtool_test *etest,
 	netdev_info(ndev, "Self test out: status flags(0x%x)\n",
 		    etest->flags);
 }
+
+int mlx5e_self_test_fill_strings(struct mlx5e_priv *priv, u8 *data)
+{
+	int i, count = 0;
+
+	for (i = 0; i < MLX5E_ST_NUM; i++) {
+		struct mlx5e_st st = mlx5e_sts[i];
+
+		if (st.cond_func && st.cond_func(priv))
+			continue;
+		if (data)
+			strcpy(data + count * ETH_GSTRING_LEN, st.name);
+		count++;
+	}
+	return count;
+}
+
+int mlx5e_self_test_num(struct mlx5e_priv *priv)
+{
+	return mlx5e_self_test_fill_strings(priv, NULL);
+}
-- 
2.31.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42EFF3D88E3
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 09:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234986AbhG1HeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 03:34:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:34758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234974AbhG1HeE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 03:34:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7535760E78;
        Wed, 28 Jul 2021 07:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627457643;
        bh=iSElZldKEiMVBs98Ft1f/9FlZOIeqWe8+WmNu6nFw28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XQC96EzoaFarbovlSvOmZgtJvSFgItvCD2QS2Y3IsuMBLxx9Cfs1q7VlPU37LUjcJ
         RwbQf89I5WIXyl7qH+60U12VJd/ktiyZK/3RRRXmAudOpH9ai/PdOUVe+YLo2wG1Wi
         loydmomQGz1ORSyMap0Y6FRJgGrh4s/RiesEEf8gyXgAKrpl072xRDS53ks5twfDyP
         XX5axCXrDPX7lkgmFdCfZ4uFMrEemBJ3qyFKrdkHrjeQ9QEHPa1Wk95cqkix+3Nq+A
         HEEONrYeDVOHOQGoWgSL3rUf/me6GSaHF8PYF3/WWrKy9u3sts2Xg9WSmKQ2IduTsS
         f8K0pBYQNoAGQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Vignesh Raghavendra <vigneshr@ti.com>
Subject: [PATCH net-next v1 1/3] net: ti: am65-cpsw-nuss: fix wrong devlink release order
Date:   Wed, 28 Jul 2021 10:33:45 +0300
Message-Id: <5ce19878648fa1e463298f1630677e92394f4d25.1627456849.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1627456849.git.leonro@nvidia.com>
References: <cover.1627456849.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The commit that introduced devlink support released devlink resources in
wrong order, that made an unwind flow to be asymmetrical. In addition,
the am65-cpsw-nuss used internal to devlink core field - registered.

In order to fix the unwind flow and remove such access to the
registered field, rewrite the code to call devlink_port_unregister only
on registered ports.

Fixes: 58356eb31d60 ("net: ti: am65-cpsw-nuss: Add devlink support")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 34 ++++++++++++------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 718539cdd2f2..61ae01c39140 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2384,21 +2384,6 @@ static const struct devlink_param am65_cpsw_devlink_params[] = {
 			     am65_cpsw_dl_switch_mode_set, NULL),
 };
 
-static void am65_cpsw_unregister_devlink_ports(struct am65_cpsw_common *common)
-{
-	struct devlink_port *dl_port;
-	struct am65_cpsw_port *port;
-	int i;
-
-	for (i = 1; i <= common->port_num; i++) {
-		port = am65_common_get_port(common, i);
-		dl_port = &port->devlink_port;
-
-		if (dl_port->registered)
-			devlink_port_unregister(dl_port);
-	}
-}
-
 static int am65_cpsw_nuss_register_devlink(struct am65_cpsw_common *common)
 {
 	struct devlink_port_attrs attrs = {};
@@ -2460,7 +2445,12 @@ static int am65_cpsw_nuss_register_devlink(struct am65_cpsw_common *common)
 	return ret;
 
 dl_port_unreg:
-	am65_cpsw_unregister_devlink_ports(common);
+	for (i = i - 1; i >= 1; i--) {
+		port = am65_common_get_port(common, i);
+		dl_port = &port->devlink_port;
+
+		devlink_port_unregister(dl_port);
+	}
 dl_unreg:
 	devlink_unregister(common->devlink);
 dl_free:
@@ -2471,6 +2461,17 @@ static int am65_cpsw_nuss_register_devlink(struct am65_cpsw_common *common)
 
 static void am65_cpsw_unregister_devlink(struct am65_cpsw_common *common)
 {
+	struct devlink_port *dl_port;
+	struct am65_cpsw_port *port;
+	int i;
+
+	for (i = 1; i <= common->port_num; i++) {
+		port = am65_common_get_port(common, i);
+		dl_port = &port->devlink_port;
+
+		devlink_port_unregister(dl_port);
+	}
+
 	if (!AM65_CPSW_IS_CPSW2G(common) &&
 	    IS_ENABLED(CONFIG_TI_K3_AM65_CPSW_SWITCHDEV)) {
 		devlink_params_unpublish(common->devlink);
@@ -2478,7 +2479,6 @@ static void am65_cpsw_unregister_devlink(struct am65_cpsw_common *common)
 					  ARRAY_SIZE(am65_cpsw_devlink_params));
 	}
 
-	am65_cpsw_unregister_devlink_ports(common);
 	devlink_unregister(common->devlink);
 	devlink_free(common->devlink);
 }
-- 
2.31.1


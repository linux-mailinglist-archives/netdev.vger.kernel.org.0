Return-Path: <netdev+bounces-11565-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 39D7E733A0F
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 21:39:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D227E28185B
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 19:39:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC2B71ED22;
	Fri, 16 Jun 2023 19:39:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C12911B914
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 19:39:24 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D84D8119
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 12:39:19 -0700 (PDT)
Received: from dude02.red.stw.pengutronix.de ([2a0a:edc0:0:1101:1d::28])
	by metis.ext.pengutronix.de with esmtp (Exim 4.92)
	(envelope-from <l.stach@pengutronix.de>)
	id 1qAExt-0000WQ-I6; Fri, 16 Jun 2023 21:18:33 +0200
From: Lucas Stach <l.stach@pengutronix.de>
To: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Wei Fang <wei.fang@nxp.com>,
	Shenwei Wang <shenwei.wang@nxp.com>,
	Clark Wang <xiaoning.wang@nxp.com>,
	NXP Linux Team <linux-imx@nxp.com>
Cc: Andrew Lunn <andrew@lunn.ch>,
	netdev@vger.kernel.org,
	kernel@pengutronix.de,
	patchwork-lst@pengutronix.de
Subject: [PATCH] net: fec: allow to build without PAGE_POOL_STATS
Date: Fri, 16 Jun 2023 21:18:32 +0200
Message-Id: <20230616191832.2944130-1-l.stach@pengutronix.de>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:1101:1d::28
X-SA-Exim-Mail-From: l.stach@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Commit 6970ef27ff7f ("net: fec: add xdp and page pool statistics") selected
CONFIG_PAGE_POOL_STATS from the FEC driver symbol, making it impossible
to build without the page pool statistics when this driver is enabled. The
help text of those statistics mentions increased overhead. Allow the user
to choose between usefulness of the statistics and the added overhead.

Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
---
 drivers/net/ethernet/freescale/Kconfig    | 2 +-
 drivers/net/ethernet/freescale/fec_main.c | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/Kconfig b/drivers/net/ethernet/freescale/Kconfig
index 1c78f66a89da..75401d2a5fb4 100644
--- a/drivers/net/ethernet/freescale/Kconfig
+++ b/drivers/net/ethernet/freescale/Kconfig
@@ -29,7 +29,7 @@ config FEC
 	select CRC32
 	select PHYLIB
 	select PAGE_POOL
-	select PAGE_POOL_STATS
+	imply PAGE_POOL_STATS
 	imply NET_SELFTESTS
 	help
 	  Say Y here if you want to use the built-in 10/100 Fast ethernet
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 38e5b5abe067..be1308295b11 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -2810,6 +2810,7 @@ static void fec_enet_get_xdp_stats(struct fec_enet_private *fep, u64 *data)
 
 static void fec_enet_page_pool_stats(struct fec_enet_private *fep, u64 *data)
 {
+#ifdef CONFIG_PAGE_POOL_STATS
 	struct page_pool_stats stats = {};
 	struct fec_enet_priv_rx_q *rxq;
 	int i;
@@ -2824,6 +2825,7 @@ static void fec_enet_page_pool_stats(struct fec_enet_private *fep, u64 *data)
 	}
 
 	page_pool_ethtool_stats_get(data, &stats);
+#endif
 }
 
 static void fec_enet_get_ethtool_stats(struct net_device *dev,
-- 
2.40.1



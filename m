Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7334F90B1
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 10:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbiDHI03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 04:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231700AbiDHI01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 04:26:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C643C196D76
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 01:24:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9126061798
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 08:24:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB2CDC385A3;
        Fri,  8 Apr 2022 08:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649406262;
        bh=g5BZOLrLNvvhHcQdaMWGNBWQK2kIYIeP+Xund8My8T0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rGnhHgco+7L0bwWzsRyjSTVcbRnU8aFRb0wJyo5lRzPosxU0NNjfxLbaatSklpt6K
         Yn4rCuRXGZR5UoAYDLh+oAkuolZNqtbA6TYYQPRU0/vGQqtIIxSDDqfPmNHcPMutzf
         wRJUEnBIi2/AaQBmRNW+kZBOK+3+yuDb19bV13D50ZQySF7WzMkdaKpIaNsb6PSqwy
         j0NmIvQ+3yl25Te0Au2XEmnDFtq5NJi0szNEjsWMgwwBqkcXwZeIsWcqSr7rIZ+f/s
         VoPqXZGX0BFmjql2Wc9JEk1Lx/sgjmCin83f2yF4ELTv9vqoeGI24oDVihSpp+aR75
         BYuQ6pN5pUnQQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, thomas.petazzoni@bootlin.com,
        ilias.apalodimas@linaro.org, jbrouer@redhat.com, andrew@lunn.ch,
        jdamato@fastly.com
Subject: [PATCH v2 net-next 2/2] net: mvneta: add support for page_pool_get_stats
Date:   Fri,  8 Apr 2022 10:24:00 +0200
Message-Id: <86f4e67f3f2eaf13e588b4989b364b1616b5fcad.1649405981.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649405981.git.lorenzo@kernel.org>
References: <cover.1649405981.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce support for the page_pool_get_stats API to mvneta driver
Report page_pool stats through ethtool.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/Kconfig  |  1 +
 drivers/net/ethernet/marvell/mvneta.c | 38 +++++++++++++++++++++++----
 2 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/marvell/Kconfig b/drivers/net/ethernet/marvell/Kconfig
index fe0989c0fc25..1240cb2dc07f 100644
--- a/drivers/net/ethernet/marvell/Kconfig
+++ b/drivers/net/ethernet/marvell/Kconfig
@@ -62,6 +62,7 @@ config MVNETA
 	select MVMDIO
 	select PHYLINK
 	select PAGE_POOL
+	select PAGE_POOL_STATS
 	help
 	  This driver supports the network interface units in the
 	  Marvell ARMADA XP, ARMADA 370, ARMADA 38x and
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 934f6dd90992..7cc20d25a7a3 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -540,7 +540,7 @@ struct mvneta_port {
 	bool eee_active;
 	bool tx_lpi_enabled;
 
-	u64 ethtool_stats[ARRAY_SIZE(mvneta_statistics)];
+	u64 *ethtool_stats;
 
 	u32 indir[MVNETA_RSS_LU_TABLE_SIZE];
 
@@ -4732,9 +4732,13 @@ static void mvneta_ethtool_get_strings(struct net_device *netdev, u32 sset,
 	if (sset == ETH_SS_STATS) {
 		int i;
 
-		for (i = 0; i < ARRAY_SIZE(mvneta_statistics); i++)
-			memcpy(data + i * ETH_GSTRING_LEN,
-			       mvneta_statistics[i].name, ETH_GSTRING_LEN);
+		for (i = 0; i < ARRAY_SIZE(mvneta_statistics); i++) {
+			memcpy(data, mvneta_statistics[i].name,
+			       ETH_GSTRING_LEN);
+			data += ETH_GSTRING_LEN;
+		}
+
+		page_pool_ethtool_stats_get_strings(data);
 	}
 }
 
@@ -4847,6 +4851,17 @@ static void mvneta_ethtool_update_stats(struct mvneta_port *pp)
 	}
 }
 
+static void mvneta_ethtool_pp_stats(struct mvneta_port *pp, u64 *data)
+{
+	struct page_pool_stats stats = {};
+	int i;
+
+	for (i = 0; i < rxq_number; i++)
+		page_pool_get_stats(pp->rxqs[i].page_pool, &stats);
+
+	page_pool_ethtool_stats_get(data, &stats);
+}
+
 static void mvneta_ethtool_get_stats(struct net_device *dev,
 				     struct ethtool_stats *stats, u64 *data)
 {
@@ -4857,12 +4872,16 @@ static void mvneta_ethtool_get_stats(struct net_device *dev,
 
 	for (i = 0; i < ARRAY_SIZE(mvneta_statistics); i++)
 		*data++ = pp->ethtool_stats[i];
+
+	mvneta_ethtool_pp_stats(pp, data);
 }
 
 static int mvneta_ethtool_get_sset_count(struct net_device *dev, int sset)
 {
 	if (sset == ETH_SS_STATS)
-		return ARRAY_SIZE(mvneta_statistics);
+		return ARRAY_SIZE(mvneta_statistics) +
+		       page_pool_ethtool_stats_get_count();
+
 	return -EOPNOTSUPP;
 }
 
@@ -5372,6 +5391,7 @@ static int mvneta_probe(struct platform_device *pdev)
 	phy_interface_t phy_mode;
 	const char *mac_from;
 	int tx_csum_limit;
+	int stats_len;
 	int err;
 	int cpu;
 
@@ -5392,6 +5412,14 @@ static int mvneta_probe(struct platform_device *pdev)
 	pp->rxq_def = rxq_def;
 	pp->indir[0] = rxq_def;
 
+	stats_len = ARRAY_SIZE(mvneta_statistics) +
+		    page_pool_ethtool_stats_get_count();
+	pp->ethtool_stats = devm_kzalloc(&pdev->dev,
+					 sizeof(*pp->ethtool_stats) * stats_len,
+					 GFP_KERNEL);
+	if (!pp->ethtool_stats)
+		return -ENOMEM;
+
 	err = of_get_phy_mode(dn, &phy_mode);
 	if (err) {
 		dev_err(&pdev->dev, "incorrect phy-mode\n");
-- 
2.35.1


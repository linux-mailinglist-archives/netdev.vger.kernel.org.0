Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D34DD4FBFF8
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 17:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347690AbiDKPO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 11:14:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347677AbiDKPOX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 11:14:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 702D53153C
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 08:12:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 300D9B81661
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 15:12:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB7E4C385A4;
        Mon, 11 Apr 2022 15:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649689926;
        bh=3k+iXUt6AS4aWUcrIMWzM+K4Folb78epLYqhgaET4Bs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FWz3me2Oim/ix+4Eqp91wCzMsBmM0vdz73kopnng9VRRJq4F1g08TSPa+5wDLnzpF
         WFM+VQFwjD5Kk/2z+1Wt0cJynUfEZXql0Hc0b/IAi4YE80C0ezzx6ncMK8MYX9YKQE
         x2Ml4FXMrMUkLzwbifVYiOFtQElTuJiGUVizOLAyGAwhjXl0N4+OxtCEBzVScR3SOu
         jezx43jtX8qBwMV/bJbXNpfa7CS2Z1uRr6qBBeaugurAF4H0NBzS/wvmCbnrc2Czia
         kIF/dnohhguruXtQbM5zoPL4742WQnXA6tC3ZJuW72n5vnGaUvSMWCbcqyUPGrgaHu
         +qjB/r89UTbyQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, thomas.petazzoni@bootlin.com,
        ilias.apalodimas@linaro.org, jbrouer@redhat.com, andrew@lunn.ch,
        jdamato@fastly.com
Subject: [PATCH v4 net-next 2/2] net: mvneta: add support for page_pool_get_stats
Date:   Mon, 11 Apr 2022 17:11:42 +0200
Message-Id: <1a88c706cca0653f504309e1e61aef750409f7a9.1649689580.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649689580.git.lorenzo@kernel.org>
References: <cover.1649689580.git.lorenzo@kernel.org>
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

Introduce support for the page_pool stats APIs into mvneta driver.
Report page_pool stats through ethtool.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/Kconfig  |  1 +
 drivers/net/ethernet/marvell/mvneta.c | 20 +++++++++++++++++++-
 2 files changed, 20 insertions(+), 1 deletion(-)

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
index 934f6dd90992..f6a54c7f0c69 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -4735,6 +4735,9 @@ static void mvneta_ethtool_get_strings(struct net_device *netdev, u32 sset,
 		for (i = 0; i < ARRAY_SIZE(mvneta_statistics); i++)
 			memcpy(data + i * ETH_GSTRING_LEN,
 			       mvneta_statistics[i].name, ETH_GSTRING_LEN);
+
+		data += ETH_GSTRING_LEN * ARRAY_SIZE(mvneta_statistics);
+		page_pool_ethtool_stats_get_strings(data);
 	}
 }
 
@@ -4847,6 +4850,17 @@ static void mvneta_ethtool_update_stats(struct mvneta_port *pp)
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
@@ -4857,12 +4871,16 @@ static void mvneta_ethtool_get_stats(struct net_device *dev,
 
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
 
-- 
2.35.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98BD14FE5EA
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 18:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355107AbiDLQe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 12:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357649AbiDLQex (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 12:34:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 134235E16F
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 09:32:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C42EEB81A00
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 16:32:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70B22C385A5;
        Tue, 12 Apr 2022 16:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649781152;
        bh=0N8LN93HisCtNKEP5iXujgVeo11564tRbCLuCi+LTDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UePMmK2E7V8xgq4nTV32obezAOX9AKpVhxbZ76m/dENwwJsCtl0hrQdS6zAHhtw46
         I6zkdQa0pEXQP0X+HiGxwsVJanb0iCBitELJiz+yR1OFgry3TraxEnyHXOU1Nlrva/
         m9iCCZzubzY4LS8tw/41M9LeZKwtVm44RDVG3KK51Dk8duADQ8zwRInKcGZQzECFZ7
         aE+ohvJVEdN/gU0ZT2zopuBvo51dOvBwZKQzPbB9i+UBvvG4g3S30rQGDJd03eSkA+
         NYlYuo9JJ1Ciqnf43BvsikGqCRn+Xym24rr2m1mvO4PAjMcW1RpElGczhQMZBFOOg9
         Uul67CWeKPQvQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, thomas.petazzoni@bootlin.com,
        ilias.apalodimas@linaro.org, jbrouer@redhat.com, andrew@lunn.ch,
        jdamato@fastly.com
Subject: [PATCH v5 net-next 2/2] net: mvneta: add support for page_pool_get_stats
Date:   Tue, 12 Apr 2022 18:31:59 +0200
Message-Id: <a3e150cc68b081d83122db45a29d159123708f85.1649780789.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649780789.git.lorenzo@kernel.org>
References: <cover.1649780789.git.lorenzo@kernel.org>
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

Introduce support for the page_pool stats API into mvneta driver.
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


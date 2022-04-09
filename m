Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA8314FAA47
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 20:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243026AbiDISmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Apr 2022 14:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243020AbiDISmF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Apr 2022 14:42:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE172BC56E
        for <netdev@vger.kernel.org>; Sat,  9 Apr 2022 11:39:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0067B80B2A
        for <netdev@vger.kernel.org>; Sat,  9 Apr 2022 18:39:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 469D1C385A0;
        Sat,  9 Apr 2022 18:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649529593;
        bh=raQb32qpKhG6coMzuQwP1bt4Oczwp4xywR7J9ceAbq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PXK4HCX+8sCFXyGDRUqVz2a2CjPwf/56nDh/TdJRvAwHKvBU9xVgKAvYUemw2yoDf
         7JSG5/UV3xvjQJiTIFUqWE+JMjAAUApKR7r7n9sEngQ9IFUAUtHURd/+miqmunFf8o
         57nJTG7djpbDR6cDplKJjyR43fhJ3k86CQpCX55QSo7SDU0isthy4CqgMNJZs85Pf6
         MBdEuFOGl2GenllEvsYnITx0Z6N8D+xOL4GCpc6+10zcKJaEIV0N9+GHQXF/PxLyDx
         lxyLkl3AR7m2JUPI172AATfcLvCH279j8C99xiLlCH9Wk8uR9FgH1WBlO1QlzjHR7h
         DcXKFDZGuYr+w==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, thomas.petazzoni@bootlin.com,
        linux@armlinux.org.uk, jbrouer@redhat.com,
        ilias.apalodimas@linaro.org, jdamato@fastly.com, andrew@lunn.ch
Subject: [PATCH v3 net-next 2/2] net: mvneta: add support for page_pool_get_stats
Date:   Sat,  9 Apr 2022 20:39:11 +0200
Message-Id: <e34cc026163547c7921b1327f4846543fca17aee.1649528984.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649528984.git.lorenzo@kernel.org>
References: <cover.1649528984.git.lorenzo@kernel.org>
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


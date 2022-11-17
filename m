Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43C8A62E5AC
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 21:15:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239502AbiKQUPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 15:15:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240102AbiKQUOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 15:14:55 -0500
Received: from mx18lb.world4you.com (mx18lb.world4you.com [81.19.149.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54CA087571
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 12:14:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=4/EVpN20mx+fHkYApdsyx7bAthPWTzcuZjpTPREdJhQ=; b=qVSYwkX1VgBBQcdr+WZ+AzTPNE
        csn+2eaOm6MKylJ5P8arp7t3Ix6mbkAMGSPatakolMT52q8JE139kz9YAPuCE/IMQb09qC1hdRxs2
        m/yXB8bvTaj32rR9aZk8uh84KgZ33vhCoaLk3da6q99LhbVek8cOre1tHCM5Q3q14PG4=;
Received: from 88-117-56-227.adsl.highway.telekom.at ([88.117.56.227] helo=hornet.engleder.at)
        by mx18lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1ovlHc-0001s8-NW; Thu, 17 Nov 2022 21:14:48 +0100
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next 3/4] tsnep: Add ethtool get_channels support
Date:   Thu, 17 Nov 2022 21:14:39 +0100
Message-Id: <20221117201440.21183-4-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221117201440.21183-1-gerhard@engleder-embedded.com>
References: <20221117201440.21183-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow user space to read number of TX and RX queue. This is useful for
device dependent qdisc configurations like TAPRIO with hardware offload.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/net/ethernet/engleder/tsnep_ethtool.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/engleder/tsnep_ethtool.c b/drivers/net/ethernet/engleder/tsnep_ethtool.c
index a713a126b227..3da5cb75aa55 100644
--- a/drivers/net/ethernet/engleder/tsnep_ethtool.c
+++ b/drivers/net/ethernet/engleder/tsnep_ethtool.c
@@ -288,6 +288,17 @@ static int tsnep_ethtool_set_rxnfc(struct net_device *dev,
 	}
 }
 
+static void tsnep_ethtool_get_channels(struct net_device *dev,
+				       struct ethtool_channels *ch)
+{
+	struct tsnep_adapter *adapter = netdev_priv(dev);
+
+	ch->max_rx = adapter->num_rx_queues;
+	ch->max_tx = adapter->num_tx_queues;
+	ch->rx_count = adapter->num_rx_queues;
+	ch->tx_count = adapter->num_tx_queues;
+}
+
 static int tsnep_ethtool_get_ts_info(struct net_device *dev,
 				     struct ethtool_ts_info *info)
 {
@@ -327,6 +338,7 @@ const struct ethtool_ops tsnep_ethtool_ops = {
 	.get_sset_count = tsnep_ethtool_get_sset_count,
 	.get_rxnfc = tsnep_ethtool_get_rxnfc,
 	.set_rxnfc = tsnep_ethtool_set_rxnfc,
+	.get_channels = tsnep_ethtool_get_channels,
 	.get_ts_info = tsnep_ethtool_get_ts_info,
 	.get_link_ksettings = phy_ethtool_get_link_ksettings,
 	.set_link_ksettings = phy_ethtool_set_link_ksettings,
-- 
2.30.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2153363E0D6
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 20:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbiK3ThT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 14:37:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiK3ThR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 14:37:17 -0500
Received: from mx03lb.world4you.com (mx03lb.world4you.com [81.19.149.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C9148C442
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 11:37:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=q12DUJ3IWa2TF7RYSy/re4lpv1jFfO0xnMOMTN76X4Q=; b=Yuzf0Vtui9lEGXzSLFTpsvXR4c
        eSK/x+8WI6CSePupLkWm2h5sX3cdvmbJqcMpaeJYJDSAKPalchFV6zJNSYu9nqcG1pnm72v3YBGJk
        XaYvizs3HlhBJA0PxKtC0f02MXZL4MhBbhtbU6oQx+OY8HPTgx9j+4VJo7jxO7N9/KoU=;
Received: from 88-117-56-227.adsl.highway.telekom.at ([88.117.56.227] helo=hornet.engleder.at)
        by mx03lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1p0StO-0004tu-Sx; Wed, 30 Nov 2022 20:37:14 +0100
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v2 2/4] tsnep: Add ethtool::get_channels support
Date:   Wed, 30 Nov 2022 20:37:06 +0100
Message-Id: <20221130193708.70747-3-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221130193708.70747-1-gerhard@engleder-embedded.com>
References: <20221130193708.70747-1-gerhard@engleder-embedded.com>
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
Also ethtool::get_per_queue_coalesce / set_per_queue_coalesce requires
that interface.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/net/ethernet/engleder/tsnep_ethtool.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/engleder/tsnep_ethtool.c b/drivers/net/ethernet/engleder/tsnep_ethtool.c
index c2640e88f347..517ac8de32bb 100644
--- a/drivers/net/ethernet/engleder/tsnep_ethtool.c
+++ b/drivers/net/ethernet/engleder/tsnep_ethtool.c
@@ -288,6 +288,17 @@ static int tsnep_ethtool_set_rxnfc(struct net_device *netdev,
 	}
 }
 
+static void tsnep_ethtool_get_channels(struct net_device *netdev,
+				       struct ethtool_channels *ch)
+{
+	struct tsnep_adapter *adapter = netdev_priv(netdev);
+
+	ch->max_rx = adapter->num_rx_queues;
+	ch->max_tx = adapter->num_tx_queues;
+	ch->rx_count = adapter->num_rx_queues;
+	ch->tx_count = adapter->num_tx_queues;
+}
+
 static int tsnep_ethtool_get_ts_info(struct net_device *netdev,
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


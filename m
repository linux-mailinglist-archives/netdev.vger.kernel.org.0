Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EEA8663020
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 20:15:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237298AbjAITPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 14:15:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236382AbjAITPc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 14:15:32 -0500
Received: from mx14lb.world4you.com (mx14lb.world4you.com [81.19.149.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3796F6586
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 11:15:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=R2G+2jvGX0hLdxFAYt9XlU7nmTlz7IKrw9vZBfYWy9M=; b=o2oWxTJWO84uWit3LD0SRHnGcH
        0epZ7CVlAtRJJxxoXjTDyarou8Zc7n1miOsipkkzUhHvrkLPIduChetaLYiA1IobB7AN8HTIUgpdv
        uZfNhXR9rySEjK+ozsU8KT0aeUBaVPC767z/UXm0pxfALexacehMwzWfO44kD31RNL48=;
Received: from 88-117-53-243.adsl.highway.telekom.at ([88.117.53.243] helo=hornet.engleder.at)
        by mx14lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pExcH-0007WQ-Mr; Mon, 09 Jan 2023 20:15:29 +0100
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v4 04/10] tsnep: Add adapter down state
Date:   Mon,  9 Jan 2023 20:15:17 +0100
Message-Id: <20230109191523.12070-5-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230109191523.12070-1-gerhard@engleder-embedded.com>
References: <20230109191523.12070-1-gerhard@engleder-embedded.com>
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

Add adapter state with flag for down state. This flag will be used by
the XDP TX path to deny TX if adapter is down.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/net/ethernet/engleder/tsnep.h      |  1 +
 drivers/net/ethernet/engleder/tsnep_main.c | 11 +++++++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/engleder/tsnep.h b/drivers/net/ethernet/engleder/tsnep.h
index f93ba48bac3f..d658413ceb14 100644
--- a/drivers/net/ethernet/engleder/tsnep.h
+++ b/drivers/net/ethernet/engleder/tsnep.h
@@ -147,6 +147,7 @@ struct tsnep_adapter {
 	bool suppress_preamble;
 	phy_interface_t phy_mode;
 	struct phy_device *phydev;
+	unsigned long state;
 	int msg_enable;
 
 	struct platform_device *pdev;
diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index 8c6d6e210494..943de5a09693 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -43,6 +43,10 @@
 #define TSNEP_COALESCE_USECS_MAX     ((ECM_INT_DELAY_MASK >> ECM_INT_DELAY_SHIFT) * \
 				      ECM_INT_DELAY_BASE_US + ECM_INT_DELAY_BASE_US - 1)
 
+enum {
+	__TSNEP_DOWN,
+};
+
 static void tsnep_enable_irq(struct tsnep_adapter *adapter, u32 mask)
 {
 	iowrite32(mask, adapter->addr + ECM_INT_ENABLE);
@@ -1138,6 +1142,8 @@ static int tsnep_netdev_open(struct net_device *netdev)
 		tsnep_enable_irq(adapter, adapter->queue[i].irq_mask);
 	}
 
+	clear_bit(__TSNEP_DOWN, &adapter->state);
+
 	return 0;
 
 phy_failed:
@@ -1160,6 +1166,8 @@ static int tsnep_netdev_close(struct net_device *netdev)
 	struct tsnep_adapter *adapter = netdev_priv(netdev);
 	int i;
 
+	set_bit(__TSNEP_DOWN, &adapter->state);
+
 	tsnep_disable_irq(adapter, ECM_INT_LINK);
 	tsnep_phy_close(adapter);
 
@@ -1513,6 +1521,7 @@ static int tsnep_probe(struct platform_device *pdev)
 	adapter->msg_enable = NETIF_MSG_DRV | NETIF_MSG_PROBE |
 			      NETIF_MSG_LINK | NETIF_MSG_IFUP |
 			      NETIF_MSG_IFDOWN | NETIF_MSG_TX_QUEUED;
+	set_bit(__TSNEP_DOWN, &adapter->state);
 
 	netdev->min_mtu = ETH_MIN_MTU;
 	netdev->max_mtu = TSNEP_MAX_FRAME_SIZE;
@@ -1609,6 +1618,8 @@ static int tsnep_remove(struct platform_device *pdev)
 {
 	struct tsnep_adapter *adapter = platform_get_drvdata(pdev);
 
+	set_bit(__TSNEP_DOWN, &adapter->state);
+
 	unregister_netdev(adapter->netdev);
 
 	tsnep_rxnfc_cleanup(adapter);
-- 
2.30.2


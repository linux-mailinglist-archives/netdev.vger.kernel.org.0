Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A50D641966
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 23:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbiLCWOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 17:14:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiLCWN5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 17:13:57 -0500
Received: from mx01lb.world4you.com (mx01lb.world4you.com [81.19.149.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF4901CFD9;
        Sat,  3 Dec 2022 14:13:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=qBiNkycqJaZVMSfXgU/O6KmyYN7BmV7kqdW0xUnelh4=; b=iHcSaJVnJhcJKjdkiykJdYlOUN
        i00INF0LIbgymRHp6ZFSHLFANyAx/Zyb/tFPxIUMWjiy7Vag/byzUMzUOkZFXI2vfjimpsfjNUmW2
        72WL3Si8mDLRO4AlvPjZCHIcpTEeFwm/tAl8kb6AWmmPO3jVp+FiMvejAduNnBrThLhg=;
Received: from 88-117-56-227.adsl.highway.telekom.at ([88.117.56.227] helo=hornet.engleder.at)
        by mx01lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1p1aSs-0003Ir-52; Sat, 03 Dec 2022 22:54:30 +0100
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next 1/6] tsnep: Add adapter down state
Date:   Sat,  3 Dec 2022 22:54:11 +0100
Message-Id: <20221203215416.13465-2-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221203215416.13465-1-gerhard@engleder-embedded.com>
References: <20221203215416.13465-1-gerhard@engleder-embedded.com>
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
index f93ba48bac3f..f72c0c4da1a9 100644
--- a/drivers/net/ethernet/engleder/tsnep.h
+++ b/drivers/net/ethernet/engleder/tsnep.h
@@ -148,6 +148,7 @@ struct tsnep_adapter {
 	phy_interface_t phy_mode;
 	struct phy_device *phydev;
 	int msg_enable;
+	unsigned long state;
 
 	struct platform_device *pdev;
 	struct device *dmadev;
diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index bf0190e1d2ea..a28fde9fb060 100644
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
@@ -1143,6 +1147,8 @@ static int tsnep_netdev_open(struct net_device *netdev)
 		tsnep_enable_irq(adapter, adapter->queue[i].irq_mask);
 	}
 
+	clear_bit(__TSNEP_DOWN, &adapter->state);
+
 	return 0;
 
 phy_failed:
@@ -1165,6 +1171,8 @@ static int tsnep_netdev_close(struct net_device *netdev)
 	struct tsnep_adapter *adapter = netdev_priv(netdev);
 	int i;
 
+	set_bit(__TSNEP_DOWN, &adapter->state);
+
 	tsnep_disable_irq(adapter, ECM_INT_LINK);
 	tsnep_phy_close(adapter);
 
@@ -1518,6 +1526,7 @@ static int tsnep_probe(struct platform_device *pdev)
 	adapter->msg_enable = NETIF_MSG_DRV | NETIF_MSG_PROBE |
 			      NETIF_MSG_LINK | NETIF_MSG_IFUP |
 			      NETIF_MSG_IFDOWN | NETIF_MSG_TX_QUEUED;
+	set_bit(__TSNEP_DOWN, &adapter->state);
 
 	netdev->min_mtu = ETH_MIN_MTU;
 	netdev->max_mtu = TSNEP_MAX_FRAME_SIZE;
@@ -1614,6 +1623,8 @@ static int tsnep_remove(struct platform_device *pdev)
 {
 	struct tsnep_adapter *adapter = platform_get_drvdata(pdev);
 
+	set_bit(__TSNEP_DOWN, &adapter->state);
+
 	unregister_netdev(adapter->netdev);
 
 	tsnep_rxnfc_cleanup(adapter);
-- 
2.30.2


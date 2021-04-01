Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9887A351F53
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 21:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237014AbhDATFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 15:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240132AbhDATEF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 15:04:05 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61AECC03D209
        for <netdev@vger.kernel.org>; Thu,  1 Apr 2021 10:56:33 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id s11so2011479pfm.1
        for <netdev@vger.kernel.org>; Thu, 01 Apr 2021 10:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=geh5cwcBZwXCARfeNW4iFXXA3/yom2S97W6ZzL7jivI=;
        b=qmeeVGBn5YEu5ckAuzu4TbMsi1JKzLHh++pD8pTP5D/l8BqJYyqUkzBFSmuVJgJO+h
         DJg+tvaXQKYsM091uIpfvGqYdR1eqpGUDYm4At2pUIZIRNFWsZ2nRHs1TH6bNYpnXqz+
         wGf1Wx8kBSUz3QecS7jaO3uh+904XhBHmqQ3QFCLS7FUIdBCJtZdEQ3qQ5Z07nmPOULz
         enFwMaTJ/qZv1mqq4I87PrpBbSfY/WNCkrTi9hFE8awIo8mhucWN+ogseN8d30LoyCDT
         Zy1oibNoRmWzRCBrbgXWoN6O3/NpkRKcmTSfIHTLosjI1HVDuZiLtqYqM76NZPtil4lR
         8C4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=geh5cwcBZwXCARfeNW4iFXXA3/yom2S97W6ZzL7jivI=;
        b=rmi9yDZ3QW6++2Py0Sg1STEYTPwUk+47VixMb2PwLz/Fp6aVJZxynoYVJLYs4Ty+hj
         XH6w4NSdZYtWA/9Xxk+BJd/n2cDINQEh1nhd86NfA+MMUXxOvy31KBkwKYAsp6cDbkPl
         jwN7XjZrpk8fhUJT97bR79HULITYvcidUkIKqPq1O2/trY7wC0t49j3xyzaa7eFkHm+6
         rrHQdbHk3pGxm/lgg7OunAhG1BXfeezHBE4z+L62uNwycHBAgoYLjAA/e3VyeGJOkMDR
         U0OfduZ4ZjP8wu4ItW4cruqO/vs7YQg394+Y5YVQ7h44MFw5JAyERljHhZCpKb2y+xdr
         kU0A==
X-Gm-Message-State: AOAM532mJqwYcELkohIbkEsN6mRyLW2olqxPPQIKOzeJeUvfRqjyR3UM
        mQw4Bw3cWLhypHI5phwLbD3Fds9t1Z2qyg==
X-Google-Smtp-Source: ABdhPJzXZhxnSEoAh/Sf1fyeVIZFCupN2HleNoyM1TyUU2PJwZNP9xeLGEVdYnST/qp6WVc2XwT19A==
X-Received: by 2002:a65:4986:: with SMTP id r6mr8663719pgs.392.1617299792670;
        Thu, 01 Apr 2021 10:56:32 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id n5sm6195909pfq.44.2021.04.01.10.56.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 10:56:31 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>,
        Allen Hubbe <allenbh@pensando.io>
Subject: [PATCH net-next 10/12] ionic: add ethtool support for PTP
Date:   Thu,  1 Apr 2021 10:56:08 -0700
Message-Id: <20210401175610.44431-11-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210401175610.44431-1-snelson@pensando.io>
References: <20210401175610.44431-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the get_ts_info() callback for ethtool support of
timestamping information.

Signed-off-by: Allen Hubbe <allenbh@pensando.io>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../ethernet/pensando/ionic/ionic_ethtool.c   | 93 +++++++++++++++++++
 1 file changed, 93 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index b1e78b452fad..71db1e2c7d8a 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -849,6 +849,98 @@ static int ionic_get_module_eeprom(struct net_device *netdev,
 	return 0;
 }
 
+static int ionic_get_ts_info(struct net_device *netdev,
+			     struct ethtool_ts_info *info)
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
+	struct ionic *ionic = lif->ionic;
+	__le64 mask;
+
+	if (!lif->phc || !lif->phc->ptp)
+		return ethtool_op_get_ts_info(netdev, info);
+
+	info->phc_index = ptp_clock_index(lif->phc->ptp);
+
+	info->so_timestamping = SOF_TIMESTAMPING_TX_SOFTWARE |
+				SOF_TIMESTAMPING_RX_SOFTWARE |
+				SOF_TIMESTAMPING_SOFTWARE |
+				SOF_TIMESTAMPING_TX_HARDWARE |
+				SOF_TIMESTAMPING_RX_HARDWARE |
+				SOF_TIMESTAMPING_RAW_HARDWARE;
+
+	/* tx modes */
+
+	info->tx_types = BIT(HWTSTAMP_TX_OFF) |
+			 BIT(HWTSTAMP_TX_ON);
+
+	mask = cpu_to_le64(BIT_ULL(IONIC_TXSTAMP_ONESTEP_SYNC));
+	if (ionic->ident.lif.eth.hwstamp_tx_modes & mask)
+		info->tx_types |= BIT(HWTSTAMP_TX_ONESTEP_SYNC);
+
+	mask = cpu_to_le64(BIT_ULL(IONIC_TXSTAMP_ONESTEP_P2P));
+	if (ionic->ident.lif.eth.hwstamp_tx_modes & mask)
+		info->tx_types |= BIT(HWTSTAMP_TX_ONESTEP_P2P);
+
+	/* rx filters */
+
+	info->rx_filters = BIT(HWTSTAMP_FILTER_NONE) |
+			   BIT(HWTSTAMP_FILTER_ALL);
+
+	mask = cpu_to_le64(IONIC_PKT_CLS_NTP_ALL);
+	if ((ionic->ident.lif.eth.hwstamp_rx_filters & mask) == mask)
+		info->rx_filters |= HWTSTAMP_FILTER_NTP_ALL;
+
+	mask = cpu_to_le64(IONIC_PKT_CLS_PTP1_SYNC);
+	if ((ionic->ident.lif.eth.hwstamp_rx_filters & mask) == mask)
+		info->rx_filters |= HWTSTAMP_FILTER_PTP_V1_L4_SYNC;
+
+	mask = cpu_to_le64(IONIC_PKT_CLS_PTP1_DREQ);
+	if ((ionic->ident.lif.eth.hwstamp_rx_filters & mask) == mask)
+		info->rx_filters |= HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ;
+
+	mask = cpu_to_le64(IONIC_PKT_CLS_PTP1_ALL);
+	if ((ionic->ident.lif.eth.hwstamp_rx_filters & mask) == mask)
+		info->rx_filters |= HWTSTAMP_FILTER_PTP_V1_L4_EVENT;
+
+	mask = cpu_to_le64(IONIC_PKT_CLS_PTP2_L4_SYNC);
+	if ((ionic->ident.lif.eth.hwstamp_rx_filters & mask) == mask)
+		info->rx_filters |= HWTSTAMP_FILTER_PTP_V2_L4_SYNC;
+
+	mask = cpu_to_le64(IONIC_PKT_CLS_PTP2_L4_DREQ);
+	if ((ionic->ident.lif.eth.hwstamp_rx_filters & mask) == mask)
+		info->rx_filters |= HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ;
+
+	mask = cpu_to_le64(IONIC_PKT_CLS_PTP2_L4_ALL);
+	if ((ionic->ident.lif.eth.hwstamp_rx_filters & mask) == mask)
+		info->rx_filters |= HWTSTAMP_FILTER_PTP_V2_L4_EVENT;
+
+	mask = cpu_to_le64(IONIC_PKT_CLS_PTP2_L2_SYNC);
+	if ((ionic->ident.lif.eth.hwstamp_rx_filters & mask) == mask)
+		info->rx_filters |= HWTSTAMP_FILTER_PTP_V2_L2_SYNC;
+
+	mask = cpu_to_le64(IONIC_PKT_CLS_PTP2_L2_DREQ);
+	if ((ionic->ident.lif.eth.hwstamp_rx_filters & mask) == mask)
+		info->rx_filters |= HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ;
+
+	mask = cpu_to_le64(IONIC_PKT_CLS_PTP2_L2_ALL);
+	if ((ionic->ident.lif.eth.hwstamp_rx_filters & mask) == mask)
+		info->rx_filters |= HWTSTAMP_FILTER_PTP_V2_L2_EVENT;
+
+	mask = cpu_to_le64(IONIC_PKT_CLS_PTP2_SYNC);
+	if ((ionic->ident.lif.eth.hwstamp_rx_filters & mask) == mask)
+		info->rx_filters |= HWTSTAMP_FILTER_PTP_V2_SYNC;
+
+	mask = cpu_to_le64(IONIC_PKT_CLS_PTP2_DREQ);
+	if ((ionic->ident.lif.eth.hwstamp_rx_filters & mask) == mask)
+		info->rx_filters |= HWTSTAMP_FILTER_PTP_V2_DELAY_REQ;
+
+	mask = cpu_to_le64(IONIC_PKT_CLS_PTP2_ALL);
+	if ((ionic->ident.lif.eth.hwstamp_rx_filters & mask) == mask)
+		info->rx_filters |= HWTSTAMP_FILTER_PTP_V2_EVENT;
+
+	return 0;
+}
+
 static int ionic_nway_reset(struct net_device *netdev)
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
@@ -906,6 +998,7 @@ static const struct ethtool_ops ionic_ethtool_ops = {
 	.set_pauseparam		= ionic_set_pauseparam,
 	.get_fecparam		= ionic_get_fecparam,
 	.set_fecparam		= ionic_set_fecparam,
+	.get_ts_info		= ionic_get_ts_info,
 	.nway_reset		= ionic_nway_reset,
 };
 
-- 
2.17.1


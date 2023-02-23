Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 781EC6A084C
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 13:12:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233897AbjBWMMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 07:12:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234208AbjBWMMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 07:12:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 522821B3;
        Thu, 23 Feb 2023 04:12:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A370616D6;
        Thu, 23 Feb 2023 12:12:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00E99C433D2;
        Thu, 23 Feb 2023 12:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677154322;
        bh=50/Mj+QbzNe5QyiB1d8eS2sMOVZQegFLunYgWaAG5MA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PKnJNa3hp6Ron/jCyIIt6mf6aHpORlhb/p83Y9V7DD7/GTdUyAVKsjg1TQEACj15x
         Xn5QaFigJJ7HJ/BL/A3qL/T9jPTFm2tIX5y3qEKJHUVEucvaAfHL63DFjFxUsW24Fw
         2W5ht5WGcyhAeqbc2Hlx/Nsu2Vym+yCg6sjfWZfnbdyjHDfYt7el7EL8+RxKmKHTIl
         VI614VRcv6+oy3E82kNgD+YtdBuvc9lsjyKrNDyRAjhDBclNruAQA2pxk2NSoA5Oyq
         FEW0XqmenPq7716isaNuAIeRMmt9W6zKAZNAXWB/RRnVlSJJBZpgl6K78M3N2p880O
         MrBJmnHEg/uKQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        saeedm@nvidia.com, tariqt@nvidia.com, leon@kernel.org,
        shayagr@amazon.com, akiyano@amazon.com, darinzon@amazon.com,
        sgoutham@marvell.com, lorenzo.bianconi@redhat.com, toke@redhat.com
Subject: [RFC net-next 4/6] net: ena: take into account xdp_features setting tx/rx queues
Date:   Thu, 23 Feb 2023 13:11:36 +0100
Message-Id: <848b3fb3f77600846b46e3fee92ce5538afed97f.1677153730.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1677153730.git.lorenzo@kernel.org>
References: <cover.1677153730.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ena nic allows xdp just if enough hw queues are available for XDP.
Take into account queues configuration setting xdp_features.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 15 ++++++++++++---
 drivers/net/ethernet/amazon/ena/ena_netdev.c  |  6 ++++--
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index 8da79eedc057..1d4f2f4d10f2 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -850,11 +850,20 @@ static int ena_set_channels(struct net_device *netdev,
 	struct ena_adapter *adapter = netdev_priv(netdev);
 	u32 count = channels->combined_count;
 	/* The check for max value is already done in ethtool */
-	if (count < ENA_MIN_NUM_IO_QUEUES ||
-	    (ena_xdp_present(adapter) &&
-	    !ena_xdp_legal_queue_count(adapter, count)))
+	if (count < ENA_MIN_NUM_IO_QUEUES)
 		return -EINVAL;
 
+	if (!ena_xdp_legal_queue_count(adapter, count)) {
+		if (ena_xdp_present(adapter))
+			return -EINVAL;
+
+		xdp_clear_features_flag(netdev);
+	} else {
+		xdp_set_features_flag(netdev,
+				      NETDEV_XDP_ACT_BASIC |
+				      NETDEV_XDP_ACT_REDIRECT);
+	}
+
 	return ena_update_queue_count(adapter, count);
 }
 
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index d3999db7c6a2..cbfe7f977270 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -4105,8 +4105,6 @@ static void ena_set_conf_feat_params(struct ena_adapter *adapter,
 	/* Set offload features */
 	ena_set_dev_offloads(feat, netdev);
 
-	netdev->xdp_features = NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT;
-
 	adapter->max_mtu = feat->dev_attr.max_mtu;
 	netdev->max_mtu = adapter->max_mtu;
 	netdev->min_mtu = ENA_MIN_MTU;
@@ -4393,6 +4391,10 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	ena_config_debug_area(adapter);
 
+	if (ena_xdp_legal_queue_count(adapter, adapter->num_io_queues))
+		netdev->xdp_features = NETDEV_XDP_ACT_BASIC |
+				       NETDEV_XDP_ACT_REDIRECT;
+
 	memcpy(adapter->netdev->perm_addr, adapter->mac_addr, netdev->addr_len);
 
 	netif_carrier_off(netdev);
-- 
2.39.2


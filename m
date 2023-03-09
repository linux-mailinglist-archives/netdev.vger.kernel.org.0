Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FFBB6B2420
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 13:26:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbjCIM0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 07:26:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbjCIM0b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 07:26:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F086BEB886;
        Thu,  9 Mar 2023 04:26:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 849D861AF9;
        Thu,  9 Mar 2023 12:26:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 988A6C433EF;
        Thu,  9 Mar 2023 12:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678364777;
        bh=GBck1hTFXrdGEGculaWIej+rjhPEtntUsiaXcPlF0iE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DxTZUGOQ55UOK0qp8jDL8dCc8farVeFQ/IN/zKF78cnIjEFwBXVnhMNKOb75v1I70
         lck/yAVpJyAdvtRp9EBWltZ7WYvXe3uj1BzCKWn8UybxKHSUA+oW8z1IOybiXLzdHI
         BftbtohW4B1tJG6ZsUUbsaMUJxWE6lbEY9owySQjYk7h2f+ZfiHVv3QApMAIzGG5NO
         H1dj9Vlqi1jP6fz0fYMomNm0QCXem6UqBn42X7lE41+2TTk74AHWiCHzX0QXT0By/E
         WZFD5OzV70naB4sYb1mANcZ+J742VGLd++MaZk/2uRppk+AsXq4VXn7bUXTnZbyFFX
         hEAU9SxhZNy/w==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        saeedm@nvidia.com, leon@kernel.org, shayagr@amazon.com,
        akiyano@amazon.com, darinzon@amazon.com, sgoutham@marvell.com,
        lorenzo.bianconi@redhat.com, toke@redhat.com, teknoraver@meta.com,
        ttoukan.linux@gmail.com
Subject: [PATCH net v2 5/8] net: ena: take into account xdp_features setting tx/rx queues
Date:   Thu,  9 Mar 2023 13:25:29 +0100
Message-Id: <1852028bc23fec0368a1426fa2f216853d3cf269.1678364613.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1678364612.git.lorenzo@kernel.org>
References: <cover.1678364612.git.lorenzo@kernel.org>
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

Fixes: 66c0e13ad236 ("drivers: net: turn on XDP features")
Reviewed-by: Shay Agroskin <shayagr@amazon.com>
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


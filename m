Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 832A56AE3CC
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 16:04:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbjCGPDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 10:03:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbjCGPDP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 10:03:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD7508091F;
        Tue,  7 Mar 2023 06:54:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 792E16137A;
        Tue,  7 Mar 2023 14:54:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8556EC433EF;
        Tue,  7 Mar 2023 14:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678200880;
        bh=5jq7kB4k8YgnHr9b0rlhDtuZTGAsKEW/bGb6FgDJIx0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uP/JE0trie4l9UAzuITD5IJNr/lcOU3CoU2bJCytzBLFuZ/Nsx8cSta3tFcrrGreo
         lvgikDDI5Ia313Pme26aj6RCeIFV/8IxQ4yub3hITaSCsIOv9/Kx6HX+Ju+HG6A/3p
         3Y61b5UJQ8lCT0hRqgy29hYHx0h43nN7LyXh5iBXEXOFPrr9kbbkuSw3jIJ3l+Po3u
         L+Cjp4NjR5c+J94zW7mzqBlDQU8Syi9B+0fdxGceZgOeSiBWwEXgNOew1Rbt8SCyJf
         9ESaD0OX6nhmYKCAAGFYMRObnhjv3P7o/8sxyd+1ryBSj/DRTdIjipbDtOU48AS7V2
         roWKC50eFuh7w==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        saeedm@nvidia.com, tariqt@nvidia.com, leon@kernel.org,
        shayagr@amazon.com, akiyano@amazon.com, darinzon@amazon.com,
        sgoutham@marvell.com, lorenzo.bianconi@redhat.com, toke@redhat.com,
        teknoraver@meta.com
Subject: [PATCH net-next 4/8] net: thunderx: take into account xdp_features setting tx/rx queues
Date:   Tue,  7 Mar 2023 15:54:01 +0100
Message-Id: <997efc0a28df32326474c3dfa339dc291a998741.1678200041.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1678200041.git.lorenzo@kernel.org>
References: <cover.1678200041.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

thunderx nic allows xdp just if enough hw queues are available for XDP.
Take into account queues configuration setting xdp_features.

Fixes: 66c0e13ad236 ("drivers: net: turn on XDP features")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 .../net/ethernet/cavium/thunder/nicvf_ethtool.c | 17 +++++++++++------
 .../net/ethernet/cavium/thunder/nicvf_main.c    |  4 +++-
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_ethtool.c b/drivers/net/ethernet/cavium/thunder/nicvf_ethtool.c
index e5c71f907852..d8d71bf97983 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_ethtool.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_ethtool.c
@@ -735,12 +735,17 @@ static int nicvf_set_channels(struct net_device *dev,
 	if (channel->tx_count > nic->max_queues)
 		return -EINVAL;
 
-	if (nic->xdp_prog &&
-	    ((channel->tx_count + channel->rx_count) > nic->max_queues)) {
-		netdev_err(nic->netdev,
-			   "XDP mode, RXQs + TXQs > Max %d\n",
-			   nic->max_queues);
-		return -EINVAL;
+	if (channel->tx_count + channel->rx_count > nic->max_queues) {
+		if (nic->xdp_prog) {
+			netdev_err(nic->netdev,
+				   "XDP mode, RXQs + TXQs > Max %d\n",
+				   nic->max_queues);
+			return -EINVAL;
+		}
+
+		xdp_clear_features_flag(nic->netdev);
+	} else if (!pass1_silicon(nic->pdev)) {
+		xdp_set_features_flag(dev, NETDEV_XDP_ACT_BASIC);
 	}
 
 	if (if_up)
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
index 8b25313c7f6b..eff350e0bc2a 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -2218,7 +2218,9 @@ static int nicvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev->netdev_ops = &nicvf_netdev_ops;
 	netdev->watchdog_timeo = NICVF_TX_TIMEOUT;
 
-	netdev->xdp_features = NETDEV_XDP_ACT_BASIC;
+	if (!pass1_silicon(nic->pdev) &&
+	    nic->rx_queues + nic->tx_queues <= nic->max_queues)
+		netdev->xdp_features = NETDEV_XDP_ACT_BASIC;
 
 	/* MTU range: 64 - 9200 */
 	netdev->min_mtu = NIC_HW_MIN_FRS;
-- 
2.39.2


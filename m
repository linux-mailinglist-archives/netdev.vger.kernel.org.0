Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 723B86D1C10
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 11:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231149AbjCaJYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 05:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjCaJYi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 05:24:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 441D61A442
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 02:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680254629;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=SofRWJHE/QJnWkcZE8k2/SP/Z8/NyK1Hy6Rn+F/BylA=;
        b=ObLz8sGRfo+8mQBWPVT3X4epyKnbNawYNXIBSMf9E4ZJRPkryv64+I7aoJy+QYMLkUwK6S
        ye/9iCOfgv9m3Ylb68nYmlUu2wlbaTYvlbFypkNIAEjBHimX5dK5L8rKOGGHdRPHscgsXA
        dtCr0o3/R0fNlrMvWSLSOLaawFcuNfE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-272-_U1-et6iNd2ntsyGGtkEvA-1; Fri, 31 Mar 2023 05:23:45 -0400
X-MC-Unique: _U1-et6iNd2ntsyGGtkEvA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 792BA889047;
        Fri, 31 Mar 2023 09:23:45 +0000 (UTC)
Received: from calimero.vinschen.de (unknown [10.39.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3BB1C492C3E;
        Fri, 31 Mar 2023 09:23:45 +0000 (UTC)
Received: by calimero.vinschen.de (Postfix, from userid 500)
        id 5B619A80CAB; Fri, 31 Mar 2023 11:23:44 +0200 (CEST)
From:   Corinna Vinschen <vinschen@redhat.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org
Subject: [PATCH net-next] net: stmmac: publish actual MTU restriction
Date:   Fri, 31 Mar 2023 11:23:44 +0200
Message-Id: <20230331092344.268981-1-vinschen@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Apart from devices setting the max MTU value from device tree,
the initialization functions in many drivers use a default value
of JUMBO_LEN.

However, that doesn't reflect reality.  The stmmac_change_mtu
function restricts the MTU to the size of a single queue in the TX
FIFO.

For instance, on st_gmac without device tree this is by default 4096.
And so this is what you get:

  # ip -d link show dev enp0s29f1
2: enp0s29f1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
    link/ether 98:4f:ee:16:11:99 brd ff:ff:ff:ff:ff:ff promiscuity 0 minmtu 46 maxmtu 9000 [...etc...]

So maxmtu is set to 9000, but then:

  # ip link set enp0s29f1 mtu 4096
  # ip link set enp0s29f1 mtu 4097
  RTNETLINK answers: Invalid argument

Change code accordingly by not setting maxmtu to JUMBO_LEN by default.
Instead, after all is set and done, let stmmac_dvr_probe set maxmtu
according to the queue size, if it hasn't been already set via device
tree.

The only exception from this rule is dwmac-mediatek, setting maxmtu to
ETH_DATA_LEN, which should be kept intact.

Result now:

  # ip link set enp0s29f1 mtu 4096
  # ip link set enp0s29f1 mtu 4097
  Error: mtu greater than device maximum.

Tested on Intel Elkhart Lake system.

Fixes: 2618abb73c895 ("stmmac: Fix kernel crashes for jumbo frames")
Fixes: a2cd64f30140c ("net: stmmac: fix maxmtu assignment to be within valid range")
Fixes: ebecb860ed228 ("net: stmmac: pci: Add HAPS support using GMAC5")
Fixes: 58da0cfa6cf12 ("net: stmmac: create dwmac-intel.c to contain all Intel platform")
Fixes: 30bba69d7db40 ("stmmac: pci: Add dwmac support for Loongson")
Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c     | 6 ------
 drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c  | 3 ---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c     | 9 +++++++++
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c      | 6 ------
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 5 -----
 5 files changed, 9 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index 13aa919633b4..2912685b481c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -430,9 +430,6 @@ static void common_default_data(struct plat_stmmacenet_data *plat)
 	/* Set default value for unicast filter entries */
 	plat->unicast_filter_entries = 1;
 
-	/* Set the maxmtu to a default of JUMBO_LEN */
-	plat->maxmtu = JUMBO_LEN;
-
 	/* Set default number of RX and TX queues to use */
 	plat->tx_queues_to_use = 1;
 	plat->rx_queues_to_use = 1;
@@ -559,9 +556,6 @@ static int intel_mgbe_common_data(struct pci_dev *pdev,
 	/* Set default value for unicast filter entries */
 	plat->unicast_filter_entries = 1;
 
-	/* Set the maxmtu to a default of JUMBO_LEN */
-	plat->maxmtu = JUMBO_LEN;
-
 	plat->vlan_fail_q_en = true;
 
 	/* Use the last Rx queue */
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
index a25c187d3185..ec90c925ad33 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
@@ -21,9 +21,6 @@ static int loongson_default_data(struct plat_stmmacenet_data *plat)
 	/* Set default value for unicast filter entries */
 	plat->unicast_filter_entries = 1;
 
-	/* Set the maxmtu to a default of JUMBO_LEN */
-	plat->maxmtu = JUMBO_LEN;
-
 	/* Set default number of RX and TX queues to use */
 	plat->tx_queues_to_use = 1;
 	plat->rx_queues_to_use = 1;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 17310ade88dd..c5e74097d9ab 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7246,6 +7246,15 @@ int stmmac_dvr_probe(struct device *device,
 		ndev->max_mtu = JUMBO_LEN;
 	else
 		ndev->max_mtu = SKB_MAX_HEAD(NET_SKB_PAD + NET_IP_ALIGN);
+
+	/* stmmac_change_mtu restricts MTU to queue size.
+	 * Set maxmtu accordingly, if it hasn't been set from DT.
+	 */
+	if (priv->plat->maxmtu == 0) {
+		priv->plat->maxmtu = priv->plat->tx_fifo_size ?:
+				     priv->dma_cap.tx_fifo_size;
+		priv->plat->maxmtu /= priv->plat->tx_queues_to_use;
+	}
 	/* Will not overwrite ndev->max_mtu if plat->maxmtu > ndev->max_mtu
 	 * as well as plat->maxmtu < ndev->min_mtu which is a invalid range.
 	 */
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
index 644bb54f5f02..b3bb0c174b8b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
@@ -33,9 +33,6 @@ static void common_default_data(struct plat_stmmacenet_data *plat)
 	/* Set default value for unicast filter entries */
 	plat->unicast_filter_entries = 1;
 
-	/* Set the maxmtu to a default of JUMBO_LEN */
-	plat->maxmtu = JUMBO_LEN;
-
 	/* Set default number of RX and TX queues to use */
 	plat->tx_queues_to_use = 1;
 	plat->rx_queues_to_use = 1;
@@ -86,9 +83,6 @@ static int snps_gmac5_default_data(struct pci_dev *pdev,
 	/* Set default value for unicast filter entries */
 	plat->unicast_filter_entries = 1;
 
-	/* Set the maxmtu to a default of JUMBO_LEN */
-	plat->maxmtu = JUMBO_LEN;
-
 	/* Set default number of RX and TX queues to use */
 	plat->tx_queues_to_use = 4;
 	plat->rx_queues_to_use = 4;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 067a40fe0a23..857411105a0a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -468,11 +468,6 @@ stmmac_probe_config_dt(struct platform_device *pdev, u8 *mac)
 	plat->en_tx_lpi_clockgating =
 		of_property_read_bool(np, "snps,en-tx-lpi-clockgating");
 
-	/* Set the maxmtu to a default of JUMBO_LEN in case the
-	 * parameter is not present in the device tree.
-	 */
-	plat->maxmtu = JUMBO_LEN;
-
 	/* Set default value for multicast hash bins */
 	plat->multicast_filter_bins = HASH_TABLE_SIZE;
 
-- 
2.39.2


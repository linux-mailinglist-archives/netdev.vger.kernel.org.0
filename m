Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8A442803CF
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 18:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732691AbgJAQXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 12:23:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732534AbgJAQXD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 12:23:03 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 708ECC0613E4
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 09:23:03 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id z19so4984482pfn.8
        for <netdev@vger.kernel.org>; Thu, 01 Oct 2020 09:23:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=e8+WoZz7JPIzdgAShuSA0TcanH2qdNyrsirkG8krFEs=;
        b=HyUjKx3BoZzVtUPuBppYe14sBN1RdtUSq9b4d/oCZHqOkByK+uRecExZqblaTyqKDm
         qGtz3rR7hMslJgi4PKNX+Zxde8QUvjoVeTlERejWXbtQol/7+3TwSvhES3VA8XbsaaJJ
         zrPXYXMCyu+X+ewKGVpCeE6/LrLkYV4xafwHnqTCgy7q456OHm/7aYh6eKE6HTBXrDp3
         RdXeHucwgOhs/w9LXVWoieoSeniltUmYc3veK9yuNedBwue6+M11WcmPEtOhr3NjWvZy
         lDM24vsXUvtq59ulGQky6fGCM52XoXwor3DKLN4p0wGmFtXCdBfXfpbrikUbSXKTFJRk
         i8dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=e8+WoZz7JPIzdgAShuSA0TcanH2qdNyrsirkG8krFEs=;
        b=XGVY7eJSNIhE1MF7ZT+5MtE9rfIJVrNyND1WkAuf56pYOoBC0t/AMp7r33biBkDzzx
         ToJst8TvXW9svZ5hYatHRD79GmG4DJpVu6gG/7GV3XEVrs7kzTDNjIKcgWdkTiTQYj/D
         X1mXcAfJ9PfQZIM6O4PZ5NFXhjY1UrH2+UMt6J8S1B1o81pwosQqud9wP/y0lajXSLea
         ZOmZupd3EwTimG3Qf49xFPp8NC5Gma2lDtoinAADEHlD6j8/8yWdLzf1Kl96te6TiasD
         dvCluoBN220M+B3/HwHdpIPhXAvzpg1i392OZyL08bTqcclUyZAr4s0XxRTodVVUljcn
         UKOg==
X-Gm-Message-State: AOAM533jEb/seVp+BGtYOVfclxnQipPjkVdCpghgk1N7b7iPGATG+lJ7
        +C9Xr9yA+QZoB78HTEuyYEMcFrnRRBj7MA==
X-Google-Smtp-Source: ABdhPJzyDHps7qreCcbTxqTZaE3EcpPqNzfQJYnJWRU2kiQDF3QMl1F4fd/VBEe+BqSZuQMhdex43Q==
X-Received: by 2002:a62:2b52:0:b029:142:2501:35d9 with SMTP id r79-20020a622b520000b0290142250135d9mr7914630pfr.57.1601569382605;
        Thu, 01 Oct 2020 09:23:02 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id k2sm6380066pfi.169.2020.10.01.09.23.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Oct 2020 09:23:01 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 7/8] ionic: use lif ident for filter count
Date:   Thu,  1 Oct 2020 09:22:45 -0700
Message-Id: <20201001162246.18508-8-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201001162246.18508-1-snelson@pensando.io>
References: <20201001162246.18508-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the lif's ident information for the uc and mc filter
counts rather than the ionic's version, to be sure
we're getting the info that is specific to this lif.

While we're thinking about it, add some missing error
checking where we get the lif's identity information.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index fcf5b00d1c33..d655a7ae3058 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1022,7 +1022,6 @@ static int ionic_lif_addr_del(struct ionic_lif *lif, const u8 *addr)
 static int ionic_lif_addr(struct ionic_lif *lif, const u8 *addr, bool add,
 			  bool can_sleep)
 {
-	struct ionic *ionic = lif->ionic;
 	struct ionic_deferred_work *work;
 	unsigned int nmfilters;
 	unsigned int nufilters;
@@ -1032,8 +1031,8 @@ static int ionic_lif_addr(struct ionic_lif *lif, const u8 *addr, bool add,
 		 * here before checking the need for deferral so that we
 		 * can return an overflow error to the stack.
 		 */
-		nmfilters = le32_to_cpu(ionic->ident.lif.eth.max_mcast_filters);
-		nufilters = le32_to_cpu(ionic->ident.lif.eth.max_ucast_filters);
+		nmfilters = le32_to_cpu(lif->identity->eth.max_mcast_filters);
+		nufilters = le32_to_cpu(lif->identity->eth.max_ucast_filters);
 
 		if ((is_multicast_ether_addr(addr) && lif->nmcast < nmfilters))
 			lif->nmcast++;
@@ -1162,12 +1161,9 @@ static void ionic_dev_uc_sync(struct net_device *netdev, bool from_ndo)
 static void ionic_set_rx_mode(struct net_device *netdev, bool from_ndo)
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
-	struct ionic_identity *ident;
 	unsigned int nfilters;
 	unsigned int rx_mode;
 
-	ident = &lif->ionic->ident;
-
 	rx_mode = IONIC_RX_MODE_F_UNICAST;
 	rx_mode |= (netdev->flags & IFF_MULTICAST) ? IONIC_RX_MODE_F_MULTICAST : 0;
 	rx_mode |= (netdev->flags & IFF_BROADCAST) ? IONIC_RX_MODE_F_BROADCAST : 0;
@@ -1182,7 +1178,7 @@ static void ionic_set_rx_mode(struct net_device *netdev, bool from_ndo)
 	 *       to see if we can disable NIC PROMISC
 	 */
 	ionic_dev_uc_sync(netdev, from_ndo);
-	nfilters = le32_to_cpu(ident->lif.eth.max_ucast_filters);
+	nfilters = le32_to_cpu(lif->identity->eth.max_ucast_filters);
 	if (netdev_uc_count(netdev) + 1 > nfilters) {
 		rx_mode |= IONIC_RX_MODE_F_PROMISC;
 		lif->uc_overflow = true;
@@ -1194,7 +1190,7 @@ static void ionic_set_rx_mode(struct net_device *netdev, bool from_ndo)
 
 	/* same for multicast */
 	ionic_dev_uc_sync(netdev, from_ndo);
-	nfilters = le32_to_cpu(ident->lif.eth.max_mcast_filters);
+	nfilters = le32_to_cpu(lif->identity->eth.max_mcast_filters);
 	if (netdev_mc_count(netdev) > nfilters) {
 		rx_mode |= IONIC_RX_MODE_F_ALLMULTI;
 		lif->mc_overflow = true;
@@ -2425,7 +2421,12 @@ int ionic_lif_alloc(struct ionic *ionic)
 
 	lif->identity = lid;
 	lif->lif_type = IONIC_LIF_TYPE_CLASSIC;
-	ionic_lif_identify(ionic, lif->lif_type, lif->identity);
+	err = ionic_lif_identify(ionic, lif->lif_type, lif->identity);
+	if (err) {
+		dev_err(ionic->dev, "Cannot identify type %d: %d\n",
+			lif->lif_type, err);
+		goto err_out_free_netdev;
+	}
 	lif->netdev->min_mtu = max_t(unsigned int, ETH_MIN_MTU,
 				     le32_to_cpu(lif->identity->eth.min_frame_size));
 	lif->netdev->max_mtu =
-- 
2.17.1


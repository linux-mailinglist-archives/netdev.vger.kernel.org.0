Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFDD7484452
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 16:12:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234727AbiADPL6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 10:11:58 -0500
Received: from mx4.wp.pl ([212.77.101.11]:60461 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234739AbiADPL5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 10:11:57 -0500
Received: (wp-smtpd smtp.wp.pl 5522 invoked from network); 4 Jan 2022 16:11:54 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1641309114; bh=nnYFD7nbyje+ojMOhPIiq9CuQd7NImL8QTldm/3xnIc=;
          h=From:To:Subject;
          b=yoI7K9skXQtHph3o9YCtQG0ZimE0yB6gGKgu0tw+2Cqja4aqa9E+CkYvbapfSkLXP
           AsO4MpMcdOPNP4S25Zqx2jjbHn31+RZMt67icoS70Sr5VdmMnmtRH7ssOozFEfzf0e
           qSlchQgAVXnpVBcV/F2n8tffan99aMU4/Ch4P5tQ=
Received: from riviera.nat.ds.pw.edu.pl (HELO LAPTOP-OLEK.lan) (olek2@wp.pl@[194.29.137.1])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <tsbogend@alpha.franken.de>; 4 Jan 2022 16:11:54 +0100
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     tsbogend@alpha.franken.de, olek2@wp.pl, hauke@hauke-m.de,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/3] net: lantiq_xrx200: increase napi poll weigth
Date:   Tue,  4 Jan 2022 16:11:43 +0100
Message-Id: <20220104151144.181736-3-olek2@wp.pl>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220104151144.181736-1-olek2@wp.pl>
References: <20220104151144.181736-1-olek2@wp.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-MailID: c5490d1b28fed5f98233b222534fc22f
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [sRP0]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NAT Performance results on BT Home Hub 5A (kernel 5.10.89, mtu 1500):

	Down		Up
Before	545 Mbps	625 Mbps
After	577 Mbps	648 Mbps

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
 drivers/net/ethernet/lantiq_xrx200.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
index 503fb99c5b90..7cebf4a601bc 100644
--- a/drivers/net/ethernet/lantiq_xrx200.c
+++ b/drivers/net/ethernet/lantiq_xrx200.c
@@ -597,8 +597,10 @@ static int xrx200_probe(struct platform_device *pdev)
 			 PMAC_HD_CTL);
 
 	/* setup NAPI */
-	netif_napi_add(net_dev, &priv->chan_rx.napi, xrx200_poll_rx, 32);
-	netif_tx_napi_add(net_dev, &priv->chan_tx.napi, xrx200_tx_housekeeping, 32);
+	netif_napi_add(net_dev, &priv->chan_rx.napi, xrx200_poll_rx,
+		       NAPI_POLL_WEIGHT);
+	netif_tx_napi_add(net_dev, &priv->chan_tx.napi, xrx200_tx_housekeeping,
+			  NAPI_POLL_WEIGHT);
 
 	platform_set_drvdata(pdev, priv);
 
-- 
2.30.2


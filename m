Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E007577805
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 21:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232570AbiGQTsj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 15:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232460AbiGQTse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 15:48:34 -0400
Received: from mx3.wp.pl (mx3.wp.pl [212.77.101.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7FD611829
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 12:48:32 -0700 (PDT)
Received: (wp-smtpd smtp.wp.pl 10730 invoked from network); 17 Jul 2022 21:48:29 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1658087309; bh=UI6nLD4Fx97G6PDxnH7Sa3zKSOR84nHPMQHr6vxLvAM=;
          h=From:To:Subject;
          b=ppP9K6g0FJrQCEjuWTkxvrDQ/4bQGVlh+1TSWK771fs7UaShztN5nZjBpedY/j0Bt
           XYNQ2a+l7xYM3hVgD0qGQIylaTQHP3xU6LlYS3nYxddM80dOAWufCz8sbik03CajPG
           bLX4dl6YBgEKcBXjil4OvThN+0dD+xEqDiJ26+l0=
Received: from ip-137-21.ds.pw.edu.pl (HELO LAPTOP-OLEK.lan) (olek2@wp.pl@[194.29.137.21])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <hauke@hauke-m.de>; 17 Jul 2022 21:48:29 +0200
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     hauke@hauke-m.de, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, olek2@wp.pl,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 2/2] net: lantiq_xrx200: fix return value in ENOMEM case
Date:   Sun, 17 Jul 2022 21:48:24 +0200
Message-Id: <20220717194824.1017750-2-olek2@wp.pl>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220717194824.1017750-1-olek2@wp.pl>
References: <20220717194824.1017750-1-olek2@wp.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-MailID: 072c0a6f35c53f5a85f852b1be7cdddc
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [QdPE]                               
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The xrx200_hw_receive() function can return:
* XRX200_DMA_PACKET_IN_PROGRESS (the next descriptor contains the
further part of the packet),
* XRX200_DMA_PACKET_COMPLETE (a complete packet has been received),
* -ENOMEM (a memory allocation error occurred).

Currently, the third of these cases is incorrectly handled. The NAPI
poll function returns then a negative value (-ENOMEM). Correctly in
such a situation, the driver should try to receive next packet in
the hope that this time the memory allocation for the next descriptor
will succeed.

This patch replaces the XRX200_DMA_PACKET_IN_PROGRESS definition with
-EINPROGRESS to simplify the driver.

Fixes: c3e6b2c35b34 ("net: lantiq_xrx200: add ingress SG DMA support")
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
 drivers/net/ethernet/lantiq_xrx200.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
index 6a83a6c19484..2865d07f3fc8 100644
--- a/drivers/net/ethernet/lantiq_xrx200.c
+++ b/drivers/net/ethernet/lantiq_xrx200.c
@@ -27,9 +27,6 @@
 #define XRX200_DMA_TX		1
 #define XRX200_DMA_BURST_LEN	8
 
-#define XRX200_DMA_PACKET_COMPLETE	0
-#define XRX200_DMA_PACKET_IN_PROGRESS	1
-
 /* cpu port mac */
 #define PMAC_RX_IPG		0x0024
 #define PMAC_RX_IPG_MASK	0xf
@@ -272,9 +269,8 @@ static int xrx200_hw_receive(struct xrx200_chan *ch)
 		netif_receive_skb(ch->skb_head);
 		ch->skb_head = NULL;
 		ch->skb_tail = NULL;
-		ret = XRX200_DMA_PACKET_COMPLETE;
 	} else {
-		ret = XRX200_DMA_PACKET_IN_PROGRESS;
+		ret = -EINPROGRESS;
 	}
 
 	return ret;
@@ -292,10 +288,8 @@ static int xrx200_poll_rx(struct napi_struct *napi, int budget)
 
 		if ((desc->ctl & (LTQ_DMA_OWN | LTQ_DMA_C)) == LTQ_DMA_C) {
 			ret = xrx200_hw_receive(ch);
-			if (ret == XRX200_DMA_PACKET_IN_PROGRESS)
+			if (ret)
 				continue;
-			if (ret != XRX200_DMA_PACKET_COMPLETE)
-				return ret;
 			rx++;
 		} else {
 			break;
-- 
2.30.2


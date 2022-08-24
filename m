Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 724955A0377
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 23:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240377AbiHXVyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 17:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240290AbiHXVyC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 17:54:02 -0400
Received: from mx3.wp.pl (mx3.wp.pl [212.77.101.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFA5F75CD9
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 14:54:00 -0700 (PDT)
Received: (wp-smtpd smtp.wp.pl 4906 invoked from network); 24 Aug 2022 23:53:57 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1661378037; bh=2D/VRsx5QG7w7GvRQKNXTqivBFxrBuMatT0dd4mF/Bc=;
          h=From:To:Subject;
          b=QskSarllpHRI4LkXPCDscix1ftm9o4Anr4aAkTIiaGFgNNHkaFtBWuiy12E8re/Cp
           KseD9dhIQPH3WecmOIhxAU7k4il5mVrb6ZVeKTTi1D1FOyYUVv32KdYe2tUSWxJwTM
           tJy6pr90IJTt16WEaQTNOt9mA7MJF8Ded1lgOCFo=
Received: from ip-137-21.ds.pw.edu.pl (HELO LAPTOP-OLEK.lan) (olek2@wp.pl@[194.29.137.21])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <hauke@hauke-m.de>; 24 Aug 2022 23:53:57 +0200
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     hauke@hauke-m.de, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, olek2@wp.pl,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v3 2/3] net: lantiq_xrx200: fix lock under memory pressure
Date:   Wed, 24 Aug 2022 23:54:07 +0200
Message-Id: <20220824215408.4695-3-olek2@wp.pl>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220824215408.4695-1-olek2@wp.pl>
References: <20220824215408.4695-1-olek2@wp.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-MailID: 945f79291369001f6d8ed7e1d73329ec
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [8aM0]                               
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the xrx200_hw_receive() function returns -ENOMEM, the NAPI poll
function immediately returns an error.
This is incorrect for two reasons:
* the function terminates without enabling interrupts or scheduling NAPI,
* the error code (-ENOMEM) is returned instead of the number of received
packets.

After the first memory allocation failure occurs, packet reception is
locked due to disabled interrupts from DMA..

Fixes: fe1a56420cf2 ("net: lantiq: Add Lantiq / Intel VRX200 Ethernet driver")
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
 drivers/net/ethernet/lantiq_xrx200.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
index 89314b645c82..25adce7f0c7c 100644
--- a/drivers/net/ethernet/lantiq_xrx200.c
+++ b/drivers/net/ethernet/lantiq_xrx200.c
@@ -294,7 +294,7 @@ static int xrx200_poll_rx(struct napi_struct *napi, int budget)
 			if (ret == XRX200_DMA_PACKET_IN_PROGRESS)
 				continue;
 			if (ret != XRX200_DMA_PACKET_COMPLETE)
-				return ret;
+				break;
 			rx++;
 		} else {
 			break;
-- 
2.30.2


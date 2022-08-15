Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77B7559312A
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 16:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242565AbiHOO6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 10:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242734AbiHOO5v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 10:57:51 -0400
Received: from mx3.wp.pl (mx3.wp.pl [212.77.101.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D6B220D0
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 07:57:50 -0700 (PDT)
Received: (wp-smtpd smtp.wp.pl 21178 invoked from network); 15 Aug 2022 16:57:47 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1660575467; bh=6UBfrDuAKAfCBcQ5WvVckMBl91GC0tVFQSnvsPx4Kjw=;
          h=From:To:Subject;
          b=fxAhDGmeRrbqX7AyzEl8vw5nNyV9mJ2isZrjts8xAvdtOZNct1mvlQDPxMnQ7WHur
           tY9guY8G1tubpc/qDFU/aHBrfjp6eN/niFaXr8xxZpCK/dGllj7ctiHkPlDN+U7fzn
           xPzpfS3D5Heknj0ljlOL8rC+h80Xi8Ueb41oIT84=
Received: from ip-137-21.ds.pw.edu.pl (HELO LAPTOP-OLEK.lan) (olek2@wp.pl@[194.29.137.21])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <hauke@hauke-m.de>; 15 Aug 2022 16:57:47 +0200
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     hauke@hauke-m.de, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, olek2@wp.pl,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v2 2/3] net: lantiq_xrx200: fix lock under memory pressure
Date:   Mon, 15 Aug 2022 16:57:39 +0200
Message-Id: <20220815145740.12075-3-olek2@wp.pl>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220815145740.12075-1-olek2@wp.pl>
References: <20220815145740.12075-1-olek2@wp.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-MailID: fc583946f3f5ae290f869c3fa1f60c3c
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [QVPk]                               
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
index 6a83a6c19484..8f9155eacdb3 100644
--- a/drivers/net/ethernet/lantiq_xrx200.c
+++ b/drivers/net/ethernet/lantiq_xrx200.c
@@ -295,7 +295,7 @@ static int xrx200_poll_rx(struct napi_struct *napi, int budget)
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


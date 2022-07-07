Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA9C5569883
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 05:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234968AbiGGDAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 23:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234947AbiGGDA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 23:00:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1192B2FFDD
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 20:00:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A64562158
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 03:00:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9CB8C341D0;
        Thu,  7 Jul 2022 03:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657162824;
        bh=gVe4HGYNLt/mAhrFQtqwOHd+ci0ewhwtUjTcT1cevY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Duiny1pkJtPj2hnm1IT6VuKL7TceBiHp2/0F6shyt4xF6LeNSqVvPJHblVVUTISVX
         AvruKiewDLxArnxxx91fqZmCe88Nlk0VzThZmhbmmlSR/hAVCXN4L6+2ZA2NPlrALL
         +iK3ipyRsCyUW9CRXLZ0PLjvqFoIvj2xP8f8k8S8y2eAXD7gQAakCvZWJKlBJ9LH0f
         VOUOFLK0shI60Z7+dLczML8FYj/5BrkXl8IcXU1xJnrVonb5yuKw/t34tmyFSQQKDl
         OQO101SYMK6arKu0yJfNd1+QSF9A8BBZLT9lCHMQ2bsSm/ZTSRap2auKwljgurJyAV
         9Krah71caBQLg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, wellslutw@gmail.com
Subject: [PATCH net-next 2/2] eth: sp7021: switch to netif_napi_add_tx()
Date:   Wed,  6 Jul 2022 20:00:20 -0700
Message-Id: <20220707030020.1382722-2-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220707030020.1382722-1-kuba@kernel.org>
References: <20220707030020.1382722-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Tx NAPI should use netif_napi_add_tx().

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: wellslutw@gmail.com
---
 drivers/net/ethernet/sunplus/spl2sw_driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sunplus/spl2sw_driver.c b/drivers/net/ethernet/sunplus/spl2sw_driver.c
index 3773ce5e12cc..546206640492 100644
--- a/drivers/net/ethernet/sunplus/spl2sw_driver.c
+++ b/drivers/net/ethernet/sunplus/spl2sw_driver.c
@@ -494,7 +494,7 @@ static int spl2sw_probe(struct platform_device *pdev)
 	/* Add and enable napi. */
 	netif_napi_add(ndev, &comm->rx_napi, spl2sw_rx_poll, NAPI_POLL_WEIGHT);
 	napi_enable(&comm->rx_napi);
-	netif_napi_add(ndev, &comm->tx_napi, spl2sw_tx_poll, NAPI_POLL_WEIGHT);
+	netif_napi_add_tx(ndev, &comm->tx_napi, spl2sw_tx_poll);
 	napi_enable(&comm->tx_napi);
 	return 0;
 
-- 
2.36.1


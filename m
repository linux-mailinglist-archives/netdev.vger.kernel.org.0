Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CDB8575A74
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 06:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbiGOEWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 00:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiGOEWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 00:22:44 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 097687822B;
        Thu, 14 Jul 2022 21:22:43 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id b8so4576861pjo.5;
        Thu, 14 Jul 2022 21:22:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=BDXd1YFYJN/5jr3L+WHptmtZJbqUiq71TSQ8jDVxf1Y=;
        b=aPzTOBFSudBhnuQRVvjn8x/dSfJC+fySXJi8HTpccyi1GEVZMmxm7E/b0FVxDXECsE
         KZCYROU101PrKzlmEMl9tCngfP7jeMlHDtl1X9q36gXSAHo6z76zfarOFnS6GoOIgmE1
         7eo1zRi2qN4Blu0gTBvvswQxCYYZi7q1zBoYUgrUCeQAwlHfOGq+PnYsICL6ZISP2UBX
         7+SDgTNOUkIbUD4MkwD/FUaip/C6zCv673SrvunVrCVxFchAwLBTJBqRzccvD/Sq5s2C
         sVrsqaxbhyfhvqowNIxFOlNReD2u5d/J1li2Xye+pIbvIt9CQMo7pXeQ/H6PiHFeOsft
         D32w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=BDXd1YFYJN/5jr3L+WHptmtZJbqUiq71TSQ8jDVxf1Y=;
        b=gIUUGSFrZfMWWS5c74gLLdGtUsH3xKMScxo5rAGOzQvq1Qw3buqG8FEzzJeMtsBfEy
         LHQR43jHrisczPOf8Eb9miWCSbysQc2ueb66ij2bgF0QI99tY9I0PveXh+por5jlBbCU
         BpNGj/k3M/z5Ui252i+JMV6GDG/B/QoQrjmloFiMXV8AM9Hx4AGKu4uhp9HAti5EwJvq
         UWFPgcsiCI5t14XngIoFKnAQpx5veyop9w7r9SVt3wCzghsSpXlq9msLkqGfehFk9jSx
         mLRfOwgUfLISE5eH1WAbjc9Ww5FUwN/CmOoKOZ8uHccEHQ2X44lXrdiPRnQVj9O7tmQx
         +6Yw==
X-Gm-Message-State: AJIora9nS0/omhGSBqg2qBrkWovu9M+H1Fv3aj4x4T0GVrkPZ5OzyEdw
        1Vw0YX0PDKp9c7r5jJX4O2c=
X-Google-Smtp-Source: AGRyM1sq4PubJiDAeGNZhSO8GA4QDZ0eyTZWG3JGb0xj2JnyYBxeXxHPp6Gs4Ji4AOr/vdyy98C3yQ==
X-Received: by 2002:a17:902:efc6:b0:16b:dd12:4d30 with SMTP id ja6-20020a170902efc600b0016bdd124d30mr11513832plb.29.1657858962209;
        Thu, 14 Jul 2022 21:22:42 -0700 (PDT)
Received: from DESKTOP-8REGVGF.localdomain ([211.25.125.254])
        by smtp.gmail.com with ESMTPSA id q18-20020a17090311d200b0016a5384071bsm2345714plh.1.2022.07.14.21.22.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 21:22:41 -0700 (PDT)
From:   Sieng-Piaw Liew <liew.s.piaw@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Sieng-Piaw Liew <liew.s.piaw@gmail.com>
Subject: [PATCH] atl1c: use netif_tx_napi_add() for Tx NAPI
Date:   Fri, 15 Jul 2022 12:21:31 +0800
Message-Id: <20220715042131.1237-1-liew.s.piaw@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use netif_tx_napi_add() for NAPI in Tx direction instead of the regular
netif_napi_add() function.

Signed-off-by: Sieng-Piaw Liew <liew.s.piaw@gmail.com>
---
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 948584761e66..bf293a3ed4c9 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -2734,8 +2734,8 @@ static int atl1c_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		netif_napi_add(netdev, &adapter->rrd_ring[i].napi,
 			       atl1c_clean_rx, 64);
 	for (i = 0; i < adapter->tx_queue_count; ++i)
-		netif_napi_add(netdev, &adapter->tpd_ring[i].napi,
-			       atl1c_clean_tx, 64);
+		netif_napi_add_tx_weight(netdev, &adapter->tpd_ring[i].napi,
+					 atl1c_clean_tx, 64);
 	timer_setup(&adapter->phy_config_timer, atl1c_phy_config, 0);
 	/* setup the private structure */
 	err = atl1c_sw_init(adapter);
-- 
2.17.1


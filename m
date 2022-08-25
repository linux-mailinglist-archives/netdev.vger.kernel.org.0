Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1F15A05D9
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 03:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233271AbiHYBgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 21:36:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233189AbiHYBfd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 21:35:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB98094EC3;
        Wed, 24 Aug 2022 18:35:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F36C6192F;
        Thu, 25 Aug 2022 01:35:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB7F5C4347C;
        Thu, 25 Aug 2022 01:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661391328;
        bh=y9Gqdd7ovYcxupWolLJJPqsUTZWvoubjDxpB3Y5omRI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mPlCctD3Yhe6ArIkVt+m113msG8RAuLOaBNLq9bv7XopG15z+LxOOIskYFdZFwGOn
         iG50Cb3ayB6LjR2FpzSlpUWdZHjwnB5lzrzmZJk4P+5A9Ah88VtWhsaTMZ+IeNhoue
         pArPsIOLScDPjXT8sJoBPHaUht4UrZ7ktVqk4Pozwjxxcmi05TJwkN/HcA430GL3mK
         Y23BOG1vIQOoSkDjCl/zbMlSKA0OjN0IJ4Zn6cBxgQkQ3rkd+Erd3otEAEgkLlNp7q
         l1M1cnLDpxRFjc4DO8hkUlSm0H8UQMoGEf9nM+fVjxIKZKU8e3QTTNtpKjijvro7Xc
         dyKhMHvc8ZjJw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Li Qiong <liqiong@nfschina.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, horatiu.vultur@microchip.com,
        UNGLinuxDriver@microchip.com, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 16/38] net: lan966x: fix checking for return value of platform_get_irq_byname()
Date:   Wed, 24 Aug 2022 21:33:39 -0400
Message-Id: <20220825013401.22096-16-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220825013401.22096-1-sashal@kernel.org>
References: <20220825013401.22096-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Li Qiong <liqiong@nfschina.com>

[ Upstream commit 40b4ac880e21d917da7f3752332fa57564a4c202 ]

The platform_get_irq_byname() returns non-zero IRQ number
or negative error number. "if (irq)" always true, chang it
to "if (irq > 0)"

Signed-off-by: Li Qiong <liqiong@nfschina.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 1d6e3b641b2e..d928b75f3780 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -710,7 +710,7 @@ static void lan966x_cleanup_ports(struct lan966x *lan966x)
 	disable_irq(lan966x->xtr_irq);
 	lan966x->xtr_irq = -ENXIO;
 
-	if (lan966x->ana_irq) {
+	if (lan966x->ana_irq > 0) {
 		disable_irq(lan966x->ana_irq);
 		lan966x->ana_irq = -ENXIO;
 	}
@@ -718,10 +718,10 @@ static void lan966x_cleanup_ports(struct lan966x *lan966x)
 	if (lan966x->fdma)
 		devm_free_irq(lan966x->dev, lan966x->fdma_irq, lan966x);
 
-	if (lan966x->ptp_irq)
+	if (lan966x->ptp_irq > 0)
 		devm_free_irq(lan966x->dev, lan966x->ptp_irq, lan966x);
 
-	if (lan966x->ptp_ext_irq)
+	if (lan966x->ptp_ext_irq > 0)
 		devm_free_irq(lan966x->dev, lan966x->ptp_ext_irq, lan966x);
 }
 
@@ -1049,7 +1049,7 @@ static int lan966x_probe(struct platform_device *pdev)
 	}
 
 	lan966x->ana_irq = platform_get_irq_byname(pdev, "ana");
-	if (lan966x->ana_irq) {
+	if (lan966x->ana_irq > 0) {
 		err = devm_request_threaded_irq(&pdev->dev, lan966x->ana_irq, NULL,
 						lan966x_ana_irq_handler, IRQF_ONESHOT,
 						"ana irq", lan966x);
-- 
2.35.1


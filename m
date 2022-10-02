Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFF715F246C
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 19:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbiJBR5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 13:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbiJBR5B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 13:57:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98B133A4BA
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 10:56:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5AC05B80D92
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 17:56:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE697C433D7;
        Sun,  2 Oct 2022 17:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664733414;
        bh=um12r970tY//k8rDHkMaO1E4j9g4VAC+ly9XjWJvjdY=;
        h=From:To:Cc:Subject:Date:From;
        b=XJj4cxiAkqj/2wJiHdevAxT6K9ypWwCtR8DKCeS4xym1EpwrgHo9vXZA5w4ea0+t5
         XrDILgQybeNEt6JedVI0KLHM18BT9/s9NuDNmeQH4m1w68+9jUzPdgQc6KIJvAeAWV
         WWT6jtLchxR5PrlPxW+Skhg0EdcMqMFfs6h3wrbfcCnn/7xaH9qa6997ElcZNA1aa4
         Rvz8ywXmc+jE1eo3tB17B4IOe71VaWPQF7RB/eDlJnHHECnCuOQDX0AYCWwAqT0los
         gpEQSUv79YtIVUOEyavSw/MGDHcETnZp+39VcRpb7eDOfOaQU+DdNDkMOsQjOu24Fk
         O/livvNy+kmPg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>, liuhangbin@gmail.com,
        mkl@pengutronix.de
Subject: [PATCH net-next] eth: octeon: fix build after netif_napi_add() changes
Date:   Sun,  2 Oct 2022 10:56:50 -0700
Message-Id: <20221002175650.1491124-1-kuba@kernel.org>
X-Mailer: git-send-email 2.37.3
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

Guenter reports I missed a netif_napi_add() call
in one of the platform-specific drivers:

drivers/net/ethernet/cavium/octeon/octeon_mgmt.c: In function 'octeon_mgmt_probe':
drivers/net/ethernet/cavium/octeon/octeon_mgmt.c:1399:9: error: too many arguments to function 'netif_napi_add'
 1399 |         netif_napi_add(netdev, &p->napi, octeon_mgmt_napi_poll,
      |         ^~~~~~~~~~~~~~

Reported-by: Guenter Roeck <linux@roeck-us.net>
Fixes: b48b89f9c189 ("net: drop the weight argument from netif_napi_add")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: liuhangbin@gmail.com
CC: mkl@pengutronix.de
---
 drivers/net/ethernet/cavium/octeon/octeon_mgmt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c b/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
index 369bfd376d6f..edde0b8fa49c 100644
--- a/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
+++ b/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
@@ -1396,8 +1396,8 @@ static int octeon_mgmt_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, netdev);
 	p = netdev_priv(netdev);
-	netif_napi_add(netdev, &p->napi, octeon_mgmt_napi_poll,
-		       OCTEON_MGMT_NAPI_WEIGHT);
+	netif_napi_add_weight(netdev, &p->napi, octeon_mgmt_napi_poll,
+			      OCTEON_MGMT_NAPI_WEIGHT);
 
 	p->netdev = netdev;
 	p->dev = &pdev->dev;
-- 
2.37.3


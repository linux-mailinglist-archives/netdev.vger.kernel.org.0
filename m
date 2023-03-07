Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68D666AE695
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 17:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbjCGQbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 11:31:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbjCGQbd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 11:31:33 -0500
Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D27B8535B
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 08:31:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=k1; bh=GpZGDUwUsE0ds3
        5pzFLaSmr9UzqZGY5gVr/k+4eStUI=; b=d8U3ZjUdS2Nw+DeBbeC04ON8UrepdH
        YdMmmpWc+wEMSdxPTDCRtV/+gV+d1IXrtqFEIAHk2TsR2FKaPX06lQCnuoA9QmwN
        bPbSwtm1Ll0zjXq8c/bm0K94IvQWEiN2IE8Zvw6XnCH0cfdDejo3Y78WIC/YRyNW
        +SvV5BjoxHBik=
Received: (qmail 752076 invoked from network); 7 Mar 2023 17:31:06 +0100
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 7 Mar 2023 17:31:06 +0100
X-UD-Smtp-Session: l3s3148p1@b+848FH2dI0gAQnoAFQ+AGEn9EY5VOxJ
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     linux-renesas-soc@vger.kernel.org
Cc:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 07/11] ravb: remove R-Car H3 ES1.* handling
Date:   Tue,  7 Mar 2023 17:30:35 +0100
Message-Id: <20230307163041.3815-8-wsa+renesas@sang-engineering.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230307163041.3815-1-wsa+renesas@sang-engineering.com>
References: <20230307163041.3815-1-wsa+renesas@sang-engineering.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

R-Car H3 ES1.* was only available to an internal development group and
needed a lot of quirks and workarounds. These become a maintenance
burden now, so our development group decided to remove upstream support
and disable booting for this SoC. Public users only have ES2 onwards.

Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
---
Please apply individually per subsystem. There are no dependencies and the SoC
doesn't boot anymore since v6.3-rc1.

 drivers/net/ethernet/renesas/ravb_main.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 0f54849a3823..b81f0d8dfda8 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -28,7 +28,6 @@
 #include <linux/pm_runtime.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
-#include <linux/sys_soc.h>
 #include <linux/reset.h>
 #include <linux/math64.h>
 
@@ -1390,11 +1389,6 @@ static void ravb_adjust_link(struct net_device *ndev)
 		phy_print_status(phydev);
 }
 
-static const struct soc_device_attribute r8a7795es10[] = {
-	{ .soc_id = "r8a7795", .revision = "ES1.0", },
-	{ /* sentinel */ }
-};
-
 /* PHY init function */
 static int ravb_phy_init(struct net_device *ndev)
 {
@@ -1434,15 +1428,6 @@ static int ravb_phy_init(struct net_device *ndev)
 		goto err_deregister_fixed_link;
 	}
 
-	/* This driver only support 10/100Mbit speeds on R-Car H3 ES1.0
-	 * at this time.
-	 */
-	if (soc_device_match(r8a7795es10)) {
-		phy_set_max_speed(phydev, SPEED_100);
-
-		netdev_info(ndev, "limited PHY to 100Mbit/s\n");
-	}
-
 	if (!info->half_duplex) {
 		/* 10BASE, Pause and Asym Pause is not supported */
 		phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_10baseT_Half_BIT);
-- 
2.35.1


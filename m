Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB4296632B3
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 22:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237897AbjAIVTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 16:19:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237557AbjAIVTV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 16:19:21 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 692E619D;
        Mon,  9 Jan 2023 13:19:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1673299145; x=1704835145;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version;
  bh=+spUW6W7ItozH7ki1a6AOa72sASOb3/uSrDwr95CuuI=;
  b=fQKl1gKINI6V7utDwLl94rarT2dR6jCM5YyetMrIBKQeNLrXN28Hnbhe
   9eRPlYbkRXdWVNKvKNVGFLzv1ys+W10bLTdGZLNOd2YzmCPyuNvVSCx2j
   czmcUPmMaoJD93ze6S6s0skaSGCyENVBWv9s1aIxz+mq2THbtoemKl1jO
   5XQH6ZbU5YGiEhW8Hjl+qKTECn9C00n9QsnX+DJ0b+K+xbkhB1SAwy9ld
   qpg25VjSHrgkdm2BLu/+o9Ec9westopqqtNIQoU8ofmtRy5sIIA7LHhbU
   ldPIvBlU7fQW+LwVfWENUR5bfbQyDiijo985Q6QzUG+lwMYtwbfqdS0f+
   g==;
X-IronPort-AV: E=Sophos;i="5.96,313,1665471600"; 
   d="scan'208";a="131543910"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Jan 2023 14:19:04 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 9 Jan 2023 14:19:04 -0700
Received: from AUS-LT-C33025.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Mon, 9 Jan 2023 14:19:01 -0700
From:   Jerry Ray <jerry.ray@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>, <jbe@pengutronix.de>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jerry Ray <jerry.ray@microchip.com>
Subject: [PATCH net-next v6 4/6] dsa: lan9303: write reg only if necessary
Date:   Mon, 9 Jan 2023 15:18:47 -0600
Message-ID: <20230109211849.32530-5-jerry.ray@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230109211849.32530-1-jerry.ray@microchip.com>
References: <20230109211849.32530-1-jerry.ray@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As the regmap_write() is over a slow bus that will sleep, we can speed up
the boot-up time a bit by not bothering to clear a bit that is already
clear.

Signed-off-by: Jerry Ray <jerry.ray@microchip.com>
---
 drivers/net/dsa/lan9303-core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index 8eee340f6464..792ce6a26a6a 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -891,8 +891,11 @@ static int lan9303_check_device(struct lan9303 *chip)
 	if (ret)
 		return (ret);
 
-	reg &= ~LAN9303_VIRT_SPECIAL_TURBO;
-	regmap_write(chip->regmap, LAN9303_VIRT_SPECIAL_CTRL, reg);
+	/* Clear the TURBO Mode bit if it was set. */
+	if (reg & LAN9303_VIRT_SPECIAL_TURBO) {
+		reg &= ~LAN9303_VIRT_SPECIAL_TURBO;
+		regmap_write(chip->regmap, LAN9303_VIRT_SPECIAL_CTRL, reg);
+	}
 
 	return 0;
 }
-- 
2.17.1


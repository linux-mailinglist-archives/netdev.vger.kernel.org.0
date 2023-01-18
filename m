Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27EE6670CF5
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 00:14:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbjAQXOI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 18:14:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbjAQXNQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 18:13:16 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 681D78CE48;
        Tue, 17 Jan 2023 12:57:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1673989037; x=1705525037;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version;
  bh=7EEKO+T/AsKAYllVpBR1IF6jmvpXWkUA9M7SqcfZgMk=;
  b=j3Z9lxUt3D5xAl2yOg+W+QgzMrNkZQkUXPKpx7ZGvkdIbxsxKx9W2lsz
   mY30T89yRWtvSC504RE2eORO8KI09le9wTVeQNeeyINWL2URVL1+P134F
   Fzu2E6dj7YJaoBRp/+9NWXq75zGjWA0KN7BS+E2aj4IDCKjTskFT53O22
   W1S2qTGn9pEyp9aYGUN4rDNTgKc0423+PNtYK4v9WQ/Tlu4+ygCejsnvi
   P8e1nqEHkIo4M7wVEBoAnLi4tDSFOErXUKVz7DL04yL4s/Q2a9ZT/iS96
   zZIQggoNjo30QipykZS9tKVd1ipk6ElMY4WDhFcvDr/DM7B7ny99Bcdft
   A==;
X-IronPort-AV: E=Sophos;i="5.97,224,1669100400"; 
   d="scan'208";a="197211172"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Jan 2023 13:57:14 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 17 Jan 2023 13:57:13 -0700
Received: from AUS-LT-C33025.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Tue, 17 Jan 2023 13:57:11 -0700
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
Subject: [net-next: PATCH v7 3/7] dsa: lan9303: Add exception logic for read failure
Date:   Tue, 17 Jan 2023 14:56:59 -0600
Message-ID: <20230117205703.25960-4-jerry.ray@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230117205703.25960-1-jerry.ray@microchip.com>
References: <20230117205703.25960-1-jerry.ray@microchip.com>
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

While it is highly unlikely a read will ever fail, This code fragment is
now in a function that allows us to return an error code. A read failure
here will cause the lan9303_probe to fail.

Signed-off-by: Jerry Ray <jerry.ray@microchip.com>
---
 drivers/net/dsa/lan9303-core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index 63f5c1ef65e2..66466d50d015 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -911,7 +911,9 @@ static int lan9303_setup(struct dsa_switch *ds)
 	}
 
 	/* Virtual Phy: Remove Turbo 200Mbit mode */
-	lan9303_read(chip->regmap, LAN9303_VIRT_SPECIAL_CTRL, &reg);
+	ret = lan9303_read(chip->regmap, LAN9303_VIRT_SPECIAL_CTRL, &reg);
+	if (ret)
+		return (ret);
 
 	reg &= ~LAN9303_VIRT_SPECIAL_TURBO;
 	regmap_write(chip->regmap, LAN9303_VIRT_SPECIAL_CTRL, reg);
-- 
2.17.1


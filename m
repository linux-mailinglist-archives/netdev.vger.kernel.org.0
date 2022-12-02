Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06D2E640906
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 16:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233747AbiLBPM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 10:12:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233332AbiLBPMQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 10:12:16 -0500
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09547A5574;
        Fri,  2 Dec 2022 07:12:14 -0800 (PST)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id BC8662008;
        Fri,  2 Dec 2022 16:12:12 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1669993932;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9N5iGN9naDmEHyePTLp/VNDqNAqfYj5SwKQDYp+5n08=;
        b=ukgDRQFSLv9COkH21ixYjveituhMhPvZ2feOojDvvWOAcpBbwvbMfJ5GanDphDxuiX4MNN
        e1wKUbMydRsnmvjpgJlWEkEIIKpYntMtawxyOLpesfv7wpKcstyAj7Q5+PTK91rTEhE2pc
        qQRRQNVk59seNeC6/8zXqYF1jvN0BLMh66VRNbyBJ2wRMHm2dFYzARIWO/E1bm0SipIOt4
        agiwA2bA2reTHb80H+vUaZ9ynVC0Ci5jaCMRX30CVx4QD0dsMmc7HvX2bFn3lzWXJN4Bfu
        13j7fBYlterynoHWa+2kGIyR1ZiI0a0hikVoJiBljEiQQsgY6Hs4Rn6K6vYbmg==
From:   Michael Walle <michael@walle.cc>
To:     Xu Liang <lxu@maxlinear.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Michael Walle <michael@walle.cc>
Subject: [PATCH net-next v1 4/4] net: phy: mxl-gpy: disable interrupts on GPY215 by default
Date:   Fri,  2 Dec 2022 16:12:04 +0100
Message-Id: <20221202151204.3318592-5-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221202151204.3318592-1-michael@walle.cc>
References: <20221202151204.3318592-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The interrupts on the GPY215B and GPY215C are broken and the only viable
fix is to disable them altogether. There is still the possibilty to
opt-in via the device tree.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/mxl-gpy.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/phy/mxl-gpy.c b/drivers/net/phy/mxl-gpy.c
index 20e610dda891..edb8cd8313b0 100644
--- a/drivers/net/phy/mxl-gpy.c
+++ b/drivers/net/phy/mxl-gpy.c
@@ -12,6 +12,7 @@
 #include <linux/mutex.h>
 #include <linux/phy.h>
 #include <linux/polynomial.h>
+#include <linux/property.h>
 #include <linux/netdevice.h>
 
 /* PHY ID */
@@ -290,6 +291,10 @@ static int gpy_probe(struct phy_device *phydev)
 	phydev->priv = priv;
 	mutex_init(&priv->mbox_lock);
 
+	if (gpy_has_broken_mdint(phydev) &&
+	    !device_property_present(dev, "maxlinear,use-broken-interrupts"))
+		phydev->irq = PHY_POLL;
+
 	fw_version = phy_read(phydev, PHY_FWV);
 	if (fw_version < 0)
 		return fw_version;
-- 
2.30.2


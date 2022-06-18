Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 766BC550401
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 12:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231736AbiFRK2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jun 2022 06:28:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233569AbiFRK2k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jun 2022 06:28:40 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13AD21F634
        for <netdev@vger.kernel.org>; Sat, 18 Jun 2022 03:28:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=h3X6f8Gj2yDJSiH/wyHo9NG1qNzBjyirqwdpiElksC8=; b=jCSU6jRklCSi6vQv5Cd52ribc6
        dhvJTUE1A38FueEoy0FV3rdtcLke7EB7EtqmeeFtWGwRwOGKYM7+8rNkQGATZm4SLwT84Lp2ZY2EX
        kE0LhwFB8pqJPUPm4tmNDAf43cKzLYR8nO2pUEGXbbgwHStw5ZcvXRw0Zt1Uo0tJK7XJX4zIf0auF
        McXkc9WXPs5BRqEMthSvxV6yMwAoIEQZUG5Dus3J5IXMd/WThcNvbc0Hz59uDty2/P99ZHR2Bb7g/
        gKy2ywy2K170GannSiH19k9R0ZoQTZ/Ssa1GSHVuXU9ghTIeTZKvGghzkFNtylB6UuWRydK3Ssv+j
        X3yDlxng==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:44602 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1o2Vgv-0004Aj-3q; Sat, 18 Jun 2022 11:28:33 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1o2Vgu-0026Bs-7A; Sat, 18 Jun 2022 11:28:32 +0100
In-Reply-To: <Yq2iMpbsux5wEM54@shell.armlinux.org.uk>
References: <Yq2iMpbsux5wEM54@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jose Abreu <Jose.Abreu@synopsys.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 1/4] net: mii: add mii_bmcr_encode_fixed()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1o2Vgu-0026Bs-7A@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Sat, 18 Jun 2022 11:28:32 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a function to encode a fixed speed/duplex to a BMCR value.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 include/linux/mii.h | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/include/linux/mii.h b/include/linux/mii.h
index 5ee13083cec7..d5a959ce4877 100644
--- a/include/linux/mii.h
+++ b/include/linux/mii.h
@@ -545,4 +545,39 @@ static inline u8 mii_resolve_flowctrl_fdx(u16 lcladv, u16 rmtadv)
 	return cap;
 }
 
+/**
+ * mii_bmcr_encode_fixed - encode fixed speed/duplex settings to a BMCR value
+ * @speed: a SPEED_* value
+ * @duplex: a DUPLEX_* value
+ *
+ * Encode the speed and duplex to a BMCR value. 2500, 1000, 100 and 10 Mbps are
+ * supported. 2500Mbps is encoded to 1000Mbps. Other speeds are encoded as 10
+ * Mbps. Unknown duplex values are encoded to half-duplex.
+ */
+static inline u16 mii_bmcr_encode_fixed(int speed, int duplex)
+{
+	u16 bmcr;
+
+	switch (speed) {
+	case SPEED_2500:
+	case SPEED_1000:
+		bmcr = BMCR_SPEED1000;
+		break;
+
+	case SPEED_100:
+		bmcr = BMCR_SPEED100;
+		break;
+
+	case SPEED_10:
+	default:
+		bmcr = BMCR_SPEED10;
+		break;
+	}
+
+	if (duplex == DUPLEX_FULL)
+		bmcr |= BMCR_FULLDPLX;
+
+	return bmcr;
+}
+
 #endif /* __LINUX_MII_H__ */
-- 
2.30.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 804B8671A26
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 12:12:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbjARLMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 06:12:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbjARLLk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 06:11:40 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F1537A53A
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 02:21:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=YQoZfNhJOzNXsXsjKxICyEAaVb3Z3nRPu4h5WsQ5LYc=; b=1o5N9NZ2Lo86PS+TtdutHopjVD
        BmqvjJxNX86QW6aJ5w5hazRKGv5ct2laVXqC++UtB1jokxYRpubSDRmXx6ZMxaSNICSjQvEsSP+nO
        FX2djVrAgyDKqBTxwJRF+CzMGyJfzXN/EdnnsifhrpBe3fJ3OznyM+75lpUsJcVvRKgTT+8iPP0bs
        dK4sVOH9L4oRs0PaSosPq8qoHLEU+rzTyMXMgYYvJW6mLqg5z/HhSXwwo1tuK6kZxES2U/Kb2Cr/j
        V3PyAw3bKBN5Q/SO7JznIglgXbkox17WRXtGBzoVWn0Vl3BvZ5qlODnHe+8eqJd9fI06us9sJImhZ
        Ny1sZQQw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:59202 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1pI5Z2-0001PT-64; Wed, 18 Jan 2023 10:21:03 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1pI5Z1-006GoO-7M; Wed, 18 Jan 2023 10:21:03 +0000
In-Reply-To: <Y8fH+Vqx6huYQFDU@shell.armlinux.org.uk>
References: <Y8fH+Vqx6huYQFDU@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 2/5] net: sfp: use device_get_match_data()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pI5Z1-006GoO-7M@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 18 Jan 2023 10:21:03 +0000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rather than using of_match_node() to get the matching of_device_id
to then retrieve the match data, use device_get_match_data() instead
to avoid firmware specific functions, and free the driver from having
firmware specific code.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index aa2f7ebbdebc..402dcdd59acb 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -2685,19 +2685,11 @@ static int sfp_probe(struct platform_device *pdev)
 	if (err < 0)
 		return err;
 
-	sff = sfp->type = &sfp_data;
+	sff = device_get_match_data(sfp->dev);
+	if (!sff)
+		sff = &sfp_data;
 
-	if (pdev->dev.of_node) {
-		const struct of_device_id *id;
-
-		id = of_match_node(sfp_of_match, pdev->dev.of_node);
-		if (WARN_ON(!id))
-			return -EINVAL;
-
-		sff = sfp->type = id->data;
-	} else if (!has_acpi_companion(&pdev->dev)) {
-		return -EINVAL;
-	}
+	sfp->type = sff;
 
 	err = sfp_i2c_get(sfp);
 	if (err)
-- 
2.30.2


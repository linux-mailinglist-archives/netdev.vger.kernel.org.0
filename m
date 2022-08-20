Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9346B59B0AB
	for <lists+netdev@lfdr.de>; Sun, 21 Aug 2022 00:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231430AbiHTWAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Aug 2022 18:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235277AbiHTWAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Aug 2022 18:00:17 -0400
Received: from mail.base45.de (mail.base45.de [IPv6:2001:67c:2050:320::77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CF8713E09;
        Sat, 20 Aug 2022 15:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=fe80.eu;
        s=20190804; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=XVdSO+LLShiZFjjo6gZ2NwG/b06thMWpGK03N4kUpYI=; b=Hap6V3GTUX/nYHEuKAdPEgZF+w
        8wxrlcyg4lbdUdppjfeFjMzxuwp0gMRSsqEj6HOMk9KatCPy8CmWX4XaY3ad4ZU08D8USOSQKHLhA
        m3C65MyshDrOWy5U7e53VSUmI8cllbXF5c/x3tGCUDXLqljiQ8659ZUUmsj6vrXXB1ZuH2fRFpEBX
        zcQBRDZWOIufmjJvNXYdHs30prcGE+NLCyzEC4kWGVroaa4wu1xszRyPu1BQiWR0+hYW1ScEfMCGl
        6HRJ8+iJ5Vh9PKUEyuAdOXx25/AmIzSoMCYrlForGc2Jx9zGTsu7s/1xJWKppFFcWd/xoWETlulhz
        T3Q1NjuA==;
Received: from [2a02:2454:9869:1a:9eb6:54ff:0:fa5] (helo=cerator.lan)
        by mail.base45.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <lynxis@fe80.eu>)
        id 1oPW9q-00G1Te-QT; Sat, 20 Aug 2022 21:37:30 +0000
From:   Alexander Couzens <lynxis@fe80.eu>
To:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexander Couzens <lynxis@fe80.eu>
Subject: [PATCH 2/2] net: mt7531: ensure all MACs are powered down before reset
Date:   Sat, 20 Aug 2022 23:37:07 +0200
Message-Id: <20220820213707.46138-2-lynxis@fe80.eu>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220820213707.46138-1-lynxis@fe80.eu>
References: <20220820213707.46138-1-lynxis@fe80.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The datasheet [1] explicit describes it as requirement for a reset.

[1] MT7531 Reference Manual for Development Board rev 1.0, page 735

Signed-off-by: Alexander Couzens <lynxis@fe80.eu>
---
 drivers/net/dsa/mt7530.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 95a57aeb466e..409d5c3d76ea 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2329,6 +2329,10 @@ mt7531_setup(struct dsa_switch *ds)
 		return -ENODEV;
 	}
 
+	/* all MACs must be forced link-down before sw reset */
+	for (i = 0; i < MT7530_NUM_PORTS; i++)
+		mt7530_write(priv, MT7530_PMCR_P(i), MT7531_FORCE_LNK);
+
 	/* Reset the switch through internal reset */
 	mt7530_write(priv, MT7530_SYS_CTRL,
 		     SYS_CTRL_PHY_RST | SYS_CTRL_SW_RST |
-- 
2.35.1


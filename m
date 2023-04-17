Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 983F96E500F
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 20:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbjDQSTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 14:19:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjDQSTn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 14:19:43 -0400
Received: from smtp.smtpout.orange.fr (smtp-14.smtpout.orange.fr [80.12.242.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05CC0BF
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 11:19:40 -0700 (PDT)
Received: from pop-os.home ([86.243.2.178])
        by smtp.orange.fr with ESMTPA
        id oTRuppJ6EjYHDoTRupnJXY; Mon, 17 Apr 2023 20:19:39 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=orange.fr;
        s=t20230301; t=1681755579;
        bh=y0spckrc7ta0K605nXj/b2AqFl80Yy12cQ6kS116dzM=;
        h=From:To:Cc:Subject:Date;
        b=AfNloPvJiO3xmvBS09ZuOQjvx+6u9dWeTwKbcTYn4JlO6q0rI8LXxqxdfMA3jHLQE
         X4xXr986pGtd5lFsK/BD779Cnjht4+RSFeJjL0eq0myseNiouJxcv0oC0p9SWPdBrK
         ISLxYqOiVehkzAcFB/edmx60L0e37321NgbcYVp1Hu1Ed7XclXEzo2F9WOM81MlHiP
         HNpjF5eC2un3sUnp//MYfFI51SVVWVmuW+76rYkJ+IozRNKCGL06juPXgeWr2TI1bT
         Yy69/h7qR1XqII+cKkUZV5gzZlGd5ILBfge987nNLU3nZ8sd/WU7KcZstu9X4pW2tc
         abwG8t1dIV7wg==
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Mon, 17 Apr 2023 20:19:39 +0200
X-ME-IP: 86.243.2.178
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org
Subject: [PATCH net] net: dsa: microchip: ksz8795: Correctly handle huge frame configuration
Date:   Mon, 17 Apr 2023 20:19:33 +0200
Message-Id: <43107d9e8b5b8b05f0cbd4e1f47a2bb88c8747b2.1681755535.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Because of the logic in place, SW_HUGE_PACKET can never be set.
(If the first condition is true, then the 2nd one is also true, but is not
executed)

Change the logic and update each bit individually.

Fixes: 29d1e85f45e0 ("net: dsa: microchip: ksz8: add MTU configuration support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Untested.
---
 drivers/net/dsa/microchip/ksz8795.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 23614a937cc3..f56fca1b1a22 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -96,7 +96,7 @@ static int ksz8795_change_mtu(struct ksz_device *dev, int frame_size)
 
 	if (frame_size > KSZ8_LEGAL_PACKET_SIZE)
 		ctrl2 |= SW_LEGAL_PACKET_DISABLE;
-	else if (frame_size > KSZ8863_NORMAL_PACKET_SIZE)
+	if (frame_size > KSZ8863_NORMAL_PACKET_SIZE)
 		ctrl1 |= SW_HUGE_PACKET;
 
 	ret = ksz_rmw8(dev, REG_SW_CTRL_1, SW_HUGE_PACKET, ctrl1);
-- 
2.34.1


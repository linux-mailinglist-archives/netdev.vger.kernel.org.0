Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC0F55945C
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 09:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbiFXHwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 03:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbiFXHv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 03:51:58 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C132956745
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 00:51:57 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1o4e6S-0005uf-NV; Fri, 24 Jun 2022 09:51:44 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1o4e6O-002NyL-HD; Fri, 24 Jun 2022 09:51:41 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1o4e6P-00DAhh-6r; Fri, 24 Jun 2022 09:51:41 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Anton Lundin <glance@acc.umu.se>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Lukas Wunner <lukas@wunner.de>
Subject: [PATCH net v1 2/2] net: usb: asix: do not force pause frames support
Date:   Fri, 24 Jun 2022 09:51:39 +0200
Message-Id: <20220624075139.3139300-2-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220624075139.3139300-1-o.rempel@pengutronix.de>
References: <20220624075139.3139300-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We should respect link partner capabilities and not force flow control
support on every link. Even more, in current state the MAC driver do not
advertises pause support so we should not keep flow control enabled at
all.

Fixes: e532a096be0e ("net: usb: asix: ax88772: add phylib support")
Reported-by: Anton Lundin <glance@acc.umu.se>
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/usb/asix.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/usb/asix.h b/drivers/net/usb/asix.h
index 2c81236c6c7c..45d3cc5cc355 100644
--- a/drivers/net/usb/asix.h
+++ b/drivers/net/usb/asix.h
@@ -126,8 +126,7 @@
 	 AX_MEDIUM_RE)
 
 #define AX88772_MEDIUM_DEFAULT	\
-	(AX_MEDIUM_FD | AX_MEDIUM_RFC | \
-	 AX_MEDIUM_TFC | AX_MEDIUM_PS | \
+	(AX_MEDIUM_FD | AX_MEDIUM_PS | \
 	 AX_MEDIUM_AC | AX_MEDIUM_RE)
 
 /* AX88772 & AX88178 RX_CTL values */
-- 
2.30.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAA884F7C6F
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 12:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244142AbiDGKL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 06:11:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244125AbiDGKLR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 06:11:17 -0400
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D04EF236935;
        Thu,  7 Apr 2022 03:09:16 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 173DA60017;
        Thu,  7 Apr 2022 10:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1649326155;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bmvANx7WYepho7DZQ0HsozEsj0y66stBZ846jh1dlsw=;
        b=JGIer4PErvzE+JPm14rWlbBiF3pDVleODB49CriLOZAClO9SCKY1jLSXhAjU95F7lg0iDF
        mbiLhzlHnOxBwednrFP9QwYqc++QWi41amEC/QZDb2AxLXSTR2KAdcxpeIlaeEkLonyVnc
        6zT06nQdZZHaVSfqsi/E5OM9ZrQBp0TcraY29kYO+tWYs3RaUAH50BwTlmtmYErdOO+QF/
        C92xmrTbxelP3IKUymt5qxTs9kbtpciWRbLl7+dY/0qp+wufZ6hk6MUubMR/8ahebMCFdN
        DgZ4ncmoUghUJ2z74sHHiBacD6PIp2cM6jEHb0DhA66t/CkvWMacNooZXwlH1A==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH v6 06/10] net: ieee802154: at86rf230: Call _xmit_hw_error() when failing to offload frames
Date:   Thu,  7 Apr 2022 12:08:59 +0200
Message-Id: <20220407100903.1695973-7-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220407100903.1695973-1-miquel.raynal@bootlin.com>
References: <20220407100903.1695973-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If we end up at this location, it means that there was likely a hardware
issue (either a bus error when asynchronously offloading the packet to
the transceiver, or the transceiver took too long for some state
change). In this case it was decided to return IEEE802154_SYSTEM_ERROR
through the ieee802154_xmit_hw_error() helper dedicated to non
IEEE802.15.4 specific errors.

Let's use this helper instead of (almost) open-coding it.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/net/ieee802154/at86rf230.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ieee802154/at86rf230.c b/drivers/net/ieee802154/at86rf230.c
index 563031ce76f0..0536ccd55e70 100644
--- a/drivers/net/ieee802154/at86rf230.c
+++ b/drivers/net/ieee802154/at86rf230.c
@@ -346,8 +346,7 @@ at86rf230_async_error_recover_complete(void *context)
 
 	if (lp->was_tx) {
 		lp->was_tx = 0;
-		dev_kfree_skb_any(lp->tx_skb);
-		ieee802154_wake_queue(lp->hw);
+		ieee802154_xmit_hw_error(lp->hw, lp->tx_skb);
 	}
 }
 
-- 
2.27.0


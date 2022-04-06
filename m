Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 307594F6767
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 19:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238836AbiDFRbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 13:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239175AbiDFRb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 13:31:28 -0400
Received: from relay12.mail.gandi.net (relay12.mail.gandi.net [IPv6:2001:4b98:dc4:8::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D384B23702F;
        Wed,  6 Apr 2022 08:34:56 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 04A97200005;
        Wed,  6 Apr 2022 15:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1649259295;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yj2cFOYKpa/ZpdUu3gbCTqoDBIoPudwTCp0bpdE6Mrk=;
        b=b5E7BiXPmdyPIlLZiJpsgEOk9ocvIT4pRiJw5PxAS2R7bmUk5QCfJqdX85/4Okm3uaGUgm
        RZJ6nuacAhiNWGjiHlhw8POQcfce/+O4pDI9vw63OR0rR70x5/ZJIZa72y8/ZMPswUZRIj
        j/DTXgI2rAPZKzUhFbeTU5WuiHIayLhOyrKl1BTmydTk5KF7HSBvcRdtQOuY6dYiLBl62I
        dwI9sYrIFhBuod/w5ywtt78gsKj8cvy0exl0ql8B3fiSg4Rp9ERvyCQrehmGwCLIAtJXwg
        tpHni0CuSqnL0GLHTmaNco75s7pWBifX7dNi/s3PS1aoeqPf50Z6lvU8hFd2YA==
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
Subject: [PATCH v5 09/11] net: ieee802154: atusb: Call _xmit_error() when a transmission fails
Date:   Wed,  6 Apr 2022 17:34:39 +0200
Message-Id: <20220406153441.1667375-10-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220406153441.1667375-1-miquel.raynal@bootlin.com>
References: <20220406153441.1667375-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ieee802154_xmit_error() is the right helper to call when a transmission
has failed. Let's use it instead of open-coding it.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/net/ieee802154/atusb.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ieee802154/atusb.c b/drivers/net/ieee802154/atusb.c
index f27a5f535808..d04db4d07a64 100644
--- a/drivers/net/ieee802154/atusb.c
+++ b/drivers/net/ieee802154/atusb.c
@@ -271,9 +271,8 @@ static void atusb_tx_done(struct atusb *atusb, u8 seq)
 		 * unlikely case now that seq == expect is then true, but can
 		 * happen and fail with a tx_skb = NULL;
 		 */
-		ieee802154_wake_queue(atusb->hw);
-		if (atusb->tx_skb)
-			dev_kfree_skb_irq(atusb->tx_skb);
+		ieee802154_xmit_error(atusb->hw, atusb->tx_skb,
+				      IEEE802154_SYSTEM_ERROR);
 	}
 }
 
-- 
2.27.0


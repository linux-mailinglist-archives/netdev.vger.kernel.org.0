Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 078EA4F6712
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 19:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239022AbiDFRbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 13:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239159AbiDFRbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 13:31:25 -0400
Received: from relay12.mail.gandi.net (relay12.mail.gandi.net [IPv6:2001:4b98:dc4:8::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E75DB2A047A;
        Wed,  6 Apr 2022 08:34:53 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 3FC45200010;
        Wed,  6 Apr 2022 15:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1649259292;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cTOSqg3wgA/EBvGPJTu7veiSkHzXCmhlqoXd663CBgI=;
        b=QM7BYPjxqyK6uGcHNYK7Oo2nemwlCHp/0hINWLeWdSjBr0aSSRyHXusPalgnzLTzEbVEiM
        KQLN1L8JVa1CQk3r8xDr6iQocNspgWo2YFBZS1el7TZze41NEu2hVl3gbGA+rSK+0l/rSs
        ghsnfnoqBACHD8XLjRkca8nxu/r/9xWtK+Q6pMMoxdjX7+jeBKAid2AyPairvQy3APj8K4
        nUkeBm3HYvx3TcVd6P5vFU36xcJD3K7UEq/7K7PIyavAaIr8YcAhlKDKjknAMcAOeq5lzr
        RWIony0SiHBE/U+s6clgE3qT9dk/IFBCU3RhMYWnp1Y9oB3rDDS1a8B8abO6GQ==
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
Subject: [PATCH v5 07/11] net: ieee802154: at86rf230: Call _xmit_bus_error() when a bus error occurs
Date:   Wed,  6 Apr 2022 17:34:37 +0200
Message-Id: <20220406153441.1667375-8-miquel.raynal@bootlin.com>
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

ieee802154_xmit_bus_error() is the right helper to call when a transmission
has failed. Let's use it instead of open-coding it. This also has the
advantage of forwarding a generic IEEE80254_SYSTEM_ERROR reason.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/net/ieee802154/at86rf230.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ieee802154/at86rf230.c b/drivers/net/ieee802154/at86rf230.c
index cafc786aab57..f219732ab301 100644
--- a/drivers/net/ieee802154/at86rf230.c
+++ b/drivers/net/ieee802154/at86rf230.c
@@ -346,8 +346,7 @@ at86rf230_async_bus_error_recover_complete(void *context)
 
 	if (lp->was_tx) {
 		lp->was_tx = 0;
-		dev_kfree_skb_any(lp->tx_skb);
-		ieee802154_wake_queue(lp->hw);
+		ieee802154_xmit_bus_error(lp->hw, lp->tx_skb);
 	}
 }
 
-- 
2.27.0


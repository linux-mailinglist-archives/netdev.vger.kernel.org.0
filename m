Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B22034AC278
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 16:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384171AbiBGPFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 10:05:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442279AbiBGOs1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 09:48:27 -0500
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03917C0401C3;
        Mon,  7 Feb 2022 06:48:26 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 043D220002;
        Mon,  7 Feb 2022 14:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1644245305;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QdYpm+09znRijWCChLopg2JCqV2yMlJEg06i/IJBBk0=;
        b=I+bYbv2MG0D7fM0mHdoAAauZxPSA7aBLHuV8K52l/Lb9FwlxyZBmi64Mu/PdzpVfA5VBI9
        kwaOFzHDqDdpRUotvgCkqEbwwNhtZ/Nvb+SxDpzbR3ruDgpdTRySxg2dXDC6DOzJfAlWz0
        o6/RruwjSPX8cS8bEAqJyVTUUXfbJeDWmz2k4qFjH1p4tc/oYC/Z12oTx6Bh2u9NcA6KSo
        vXdWzeKc9crmhbW/ctSv7OggKjn6WOrVZdKJ3794U7QQb7a0kPDsc0G3bNDPLbUteIZ/Za
        LWLHfQyENa2j4eeQAnNGVjmcEwjPYf+O1awETRxokXeQYS2VIUMNOZMW0vN1eg==
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
Subject: [PATCH wpan-next v2 12/14] net: mac802154: Add a warning in the hot path
Date:   Mon,  7 Feb 2022 15:48:02 +0100
Message-Id: <20220207144804.708118-13-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220207144804.708118-1-miquel.raynal@bootlin.com>
References: <20220207144804.708118-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We should never start a transmission after the queue has been stopped.

But because it might work we don't kill the function here but rather
warn loudly the user that something is wrong.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/mac802154/tx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
index 18ee6fcfcd7f..abd9a057521e 100644
--- a/net/mac802154/tx.c
+++ b/net/mac802154/tx.c
@@ -112,6 +112,8 @@ ieee802154_tx(struct ieee802154_local *local, struct sk_buff *skb)
 static netdev_tx_t
 ieee802154_hot_tx(struct ieee802154_local *local, struct sk_buff *skb)
 {
+	WARN_ON_ONCE(mac802154_queue_is_stopped(local));
+
 	return ieee802154_tx(local, skb);
 }
 
-- 
2.27.0


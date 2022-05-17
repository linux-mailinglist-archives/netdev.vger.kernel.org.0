Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3140D52A816
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 18:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242236AbiEQQfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 12:35:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350968AbiEQQfR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 12:35:17 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::228])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC2084EF79;
        Tue, 17 May 2022 09:35:13 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id B078A1BF20A;
        Tue, 17 May 2022 16:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652805312;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dF4+CZUnuSwm1ST8JkssFZou68yDfHGT3R4u4rXqC9o=;
        b=I/bpBbWPCbfTpCJf1k84s3P8ugFGk9accqldFEz2SFXx1WwWAUZcW8RYzLPUo9D2q4GvXJ
        w2COnQXBvyWeCjTUIoEs0hs6ujs4LCFfOtBgTeoWg/gqKMbo8IeELxewzBjgef+Y4Q0+rc
        KypuuENxvmhwg7vDTK8LZlpqNCdlkpkEEsfxuVFZv3Ek7QTn891ymOHXhRj/n4a0yh0jJv
        xuvAgZydz4JVmt0+xff1AgsZ7wRuiLaOebiEADhjM1cC3BBOK2DN77YyOCkreeOIe3XvTP
        ujPf4FVP2QCBDjv7h6bGc4BUei5UIUExqSybUdbTfxeBRp3+TwpDkZXSg1dlgw==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH wpan-next v3 11/11] net: mac802154: Add a warning in the slow path
Date:   Tue, 17 May 2022 18:34:50 +0200
Message-Id: <20220517163450.240299-12-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220517163450.240299-1-miquel.raynal@bootlin.com>
References: <20220517163450.240299-1-miquel.raynal@bootlin.com>
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

In order to be able to detect possible conflicts between the net
interface core and the ieee802154 core, let's add a warning in the slow
path: we want to be sure that whenever we start an asynchronous MLME
transmission (which can be fully asynchronous) the net core somehow
agrees that this transmission is possible, ie. the device was not
stopped. Warning in this case would allow us to track down more easily
possible issues with the MLME logic if we ever get reports.

Unlike in the hot path, such a situation cannot be handled.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/mac802154/tx.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
index e36aca788ea2..53a8be822e33 100644
--- a/net/mac802154/tx.c
+++ b/net/mac802154/tx.c
@@ -132,6 +132,25 @@ int ieee802154_sync_and_hold_queue(struct ieee802154_local *local)
 	return ret;
 }
 
+static bool ieee802154_netif_is_down(struct ieee802154_local *local)
+{
+	struct ieee802154_sub_if_data *sdata;
+	bool is_down = true;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+		if (!sdata->dev)
+			continue;
+
+		is_down = !(sdata->dev->flags & IFF_UP);
+		if (is_down)
+			break;
+	}
+	rcu_read_unlock();
+
+	return is_down;
+}
+
 static int ieee802154_mlme_op_pre(struct ieee802154_local *local)
 {
 	return ieee802154_sync_and_hold_queue(local);
@@ -150,6 +169,12 @@ static int ieee802154_mlme_tx(struct ieee802154_local *local, struct sk_buff *sk
 	if (!local->open_count)
 		return -EBUSY;
 
+	/* Warn if the ieee802154 core thinks MLME frames can be sent while the
+	 * net interface expects this cannot happen.
+	 */
+	if (WARN_ON_ONCE(ieee802154_netif_is_down(local)))
+		return -EHOSTDOWN;
+
 	ieee802154_tx(local, skb);
 	ret = ieee802154_sync_queue(local);
 
-- 
2.34.1


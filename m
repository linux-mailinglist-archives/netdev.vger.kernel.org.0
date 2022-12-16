Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21F4164F567
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 00:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230263AbiLPX6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 18:58:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbiLPX56 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 18:57:58 -0500
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF9665987;
        Fri, 16 Dec 2022 15:57:47 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 1C89EE0005;
        Fri, 16 Dec 2022 23:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1671235066;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=hMDyExGWKF70lkZyRKRiFJFmtzAkcZU9Ie6RaEJDtZA=;
        b=DJKRPBrIS4J4fBK98qr8QDEoo6lB8+iQKCzZQLf/+uxx0WDM7T9kF8AAcPjoHo6ZPBhpAz
        YBySmdK6cfPVFiLfHWXrc4z7tSe0Z18bHtZFwCz3L2b8zgLNpWh0gnfiyYPwnvYYHpSs8d
        SAi8lJ7d9ss3jtg41233yEXvkocv43fWn7rBpiT3VElbdYmPqrxMye9W18IqzsLQe5GfQa
        i/Dn8Bq8ihrynvj/aF857RIdl5236mXoGv8cWVxA1/BRmunK91Cj494ivUrqWZnxni3FrR
        B4+jffeejKLIbwvlxVegmBXqlESIVpplCZ6WEsepWoURd2MW/VPLH6D9GL1KVQ==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Dan Carpenter <error27@gmail.com>
Subject: [PATCH wpan] mac802154: Fix possible double free upon parsing error
Date:   Sat, 17 Dec 2022 00:57:42 +0100
Message-Id: <20221216235742.646134-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 4d1c7d87030b ("mac802154: Move an skb free within the rx path")
tried to simplify error handling within the receive path by moving the
kfree_skb() call at the very end of the top-level function but missed
one kfree_skb() called upon frame parsing error. Prevent this possible
double free from happening.

Fixes: 4d1c7d87030b ("mac802154: Move an skb free within the rx path")
Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/mac802154/rx.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
index c2aae2a6d6a6..97bb4401dd3e 100644
--- a/net/mac802154/rx.c
+++ b/net/mac802154/rx.c
@@ -213,7 +213,6 @@ __ieee802154_rx_handle_packet(struct ieee802154_local *local,
 	ret = ieee802154_parse_frame_start(skb, &hdr);
 	if (ret) {
 		pr_debug("got invalid frame\n");
-		kfree_skb(skb);
 		return;
 	}
 
-- 
2.34.1


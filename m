Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC525ADA2C
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 22:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232396AbiIEU3K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 16:29:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232083AbiIEU21 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 16:28:27 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C0C26527F;
        Mon,  5 Sep 2022 13:27:29 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 64B5C1BF205;
        Mon,  5 Sep 2022 20:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1662409648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=BnHOMbYg/aYl52AglqRA9BaFquWx+XID3a4n+UoH8uw=;
        b=N1U/6Vb2fG5pGVLAg0qN0sSEVox4muuwFpYwGAICmvmIG6cLzE+jhmQequc91EkBmZkb+k
        38mGDsVxA4DsNSii2RXOoZ9xYeddg7Cjuo14omQlg6IhCglobjBxGRC4G4Mern7eg6IzyT
        xbeZ/hJ6MAd5zhu5jX2zVo5w1W3ODGJ51+eSFY5psErOCfoGftPCQFyBzqjIvepfVBMbPO
        cXC/XCf+5VisYuithX7QqodHUYGXRiNp8ygv60slGzqzn0bEfKzFB87SNFTb/2SdfE9TqU
        BMJ2tISYoAApUVsAl/qCVN5xGZ0hAk8nCNWEe6UW4ZWTEK9UyYjf7vVkRzaJXw==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH wpan/next] net: mac802154: Avoid displaying misleading debug information
Date:   Mon,  5 Sep 2022 22:27:24 +0200
Message-Id: <20220905202724.1322046-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
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

With DEBUG defined, any frame received will see its MHR fields (fc and
addresses, mainly) being printed in the kernel log buffer,
unconditionally. In most cases this is fine, but in some specific cases
(like Acknowledgment frames, where both the source and destination
addressing fields are omitted), it displays garbage which is
misleading.

Only print the addressing fields when they are present, which clarifies
the logs.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/mac802154/rx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
index c439125ef2b9..c0fd8d0c7f03 100644
--- a/net/mac802154/rx.c
+++ b/net/mac802154/rx.c
@@ -114,8 +114,10 @@ ieee802154_subif_frame(struct ieee802154_sub_if_data *sdata,
 static void
 ieee802154_print_addr(const char *name, const struct ieee802154_addr *addr)
 {
-	if (addr->mode == IEEE802154_ADDR_NONE)
+	if (addr->mode == IEEE802154_ADDR_NONE) {
 		pr_debug("%s not present\n", name);
+		return;
+	}
 
 	pr_debug("%s PAN ID: %04x\n", name, le16_to_cpu(addr->pan_id));
 	if (addr->mode == IEEE802154_ADDR_SHORT) {
-- 
2.34.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 974FE49B3F8
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 13:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383295AbiAYM1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 07:27:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383119AbiAYMZw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 07:25:52 -0500
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA20C06173D;
        Tue, 25 Jan 2022 04:25:47 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 24DEBFF809;
        Tue, 25 Jan 2022 12:25:44 +0000 (UTC)
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
Subject: [wpan-next v3 2/3] net: ieee802154: Use the IEEE802154_MAX_PAGE define when relevant
Date:   Tue, 25 Jan 2022 13:25:39 +0100
Message-Id: <20220125122540.855604-3-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220125122540.855604-1-miquel.raynal@bootlin.com>
References: <20220125122540.855604-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This define already exist but is hardcoded in nl-phy.c. Use the
definition when relevant.

While at it, also convert the type from uint32_t to u32.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/ieee802154/nl-phy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ieee802154/nl-phy.c b/net/ieee802154/nl-phy.c
index dd5a45f8a78a..359249ab77bf 100644
--- a/net/ieee802154/nl-phy.c
+++ b/net/ieee802154/nl-phy.c
@@ -30,7 +30,7 @@ static int ieee802154_nl_fill_phy(struct sk_buff *msg, u32 portid,
 {
 	void *hdr;
 	int i, pages = 0;
-	uint32_t *buf = kcalloc(32, sizeof(uint32_t), GFP_KERNEL);
+	u32 *buf = kcalloc(IEEE802154_MAX_PAGE + 1, sizeof(u32), GFP_KERNEL);
 
 	pr_debug("%s\n", __func__);
 
@@ -47,7 +47,7 @@ static int ieee802154_nl_fill_phy(struct sk_buff *msg, u32 portid,
 	    nla_put_u8(msg, IEEE802154_ATTR_PAGE, phy->current_page) ||
 	    nla_put_u8(msg, IEEE802154_ATTR_CHANNEL, phy->current_channel))
 		goto nla_put_failure;
-	for (i = 0; i < 32; i++) {
+	for (i = 0; i <= IEEE802154_MAX_PAGE; i++) {
 		if (phy->supported.channels[i])
 			buf[pages++] = phy->supported.channels[i] | (i << 27);
 	}
-- 
2.27.0


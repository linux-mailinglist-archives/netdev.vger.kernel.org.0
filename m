Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63D3149077E
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 12:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239294AbiAQLy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 06:54:56 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:59737 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239282AbiAQLyw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 06:54:52 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 8EDB520000E;
        Mon, 17 Jan 2022 11:54:49 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH v3 04/41] net: ieee802154: Use the IEEE802154_MAX_PAGE define when relevant
Date:   Mon, 17 Jan 2022 12:54:03 +0100
Message-Id: <20220117115440.60296-5-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220117115440.60296-1-miquel.raynal@bootlin.com>
References: <20220117115440.60296-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This define already exist but is hardcoded in nl-phy.c. Use the
definition when relevant.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/ieee802154/nl-phy.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ieee802154/nl-phy.c b/net/ieee802154/nl-phy.c
index dd5a45f8a78a..02f6a53d0faa 100644
--- a/net/ieee802154/nl-phy.c
+++ b/net/ieee802154/nl-phy.c
@@ -30,7 +30,8 @@ static int ieee802154_nl_fill_phy(struct sk_buff *msg, u32 portid,
 {
 	void *hdr;
 	int i, pages = 0;
-	uint32_t *buf = kcalloc(32, sizeof(uint32_t), GFP_KERNEL);
+	uint32_t *buf = kcalloc(IEEE802154_MAX_PAGE + 1, sizeof(uint32_t),
+				GFP_KERNEL);
 
 	pr_debug("%s\n", __func__);
 
@@ -47,7 +48,7 @@ static int ieee802154_nl_fill_phy(struct sk_buff *msg, u32 portid,
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


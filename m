Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 811A4494CCA
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 12:21:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbiATLVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 06:21:44 -0500
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:34285 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbiATLVa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 06:21:30 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id ACAA9C000C;
        Thu, 20 Jan 2022 11:21:27 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Xue Liu <liuxuenetmail@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Harry Morris <harrymorris12@gmail.com>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [wpan-next v2 6/9] net: ieee802154: Use the IEEE802154_MAX_PAGE define when relevant
Date:   Thu, 20 Jan 2022 12:21:12 +0100
Message-Id: <20220120112115.448077-7-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220120112115.448077-1-miquel.raynal@bootlin.com>
References: <20220120112115.448077-1-miquel.raynal@bootlin.com>
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


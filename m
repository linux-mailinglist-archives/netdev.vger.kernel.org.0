Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68B8A4A632A
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 19:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241767AbiBASGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 13:06:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbiBASGg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 13:06:36 -0500
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDCD5C061714;
        Tue,  1 Feb 2022 10:06:35 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 94051C000A;
        Tue,  1 Feb 2022 18:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1643738794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0RKVhmzBpUL7InLOlDKNKsczQ++IqsA0tupHEotsXG0=;
        b=XCUp9BK1hcnxcGNuy/2jFwhDDp7VFSe2vb8ERGGspwwoZ9yjr1yR36JQCwINPBptpQK6WI
        4DoBs0GAhYuQr6KfGC2ie9M7Gum4UZt48foLrSrZBVUwXQjnFO7Bsp8vb9ogscYBRZxDHc
        XJW/sJt216VbhANukSYkra3/H5XW7MYT6FriE2emn0kvCsjpt92uWwVVNyQFhNC2sk8LL2
        Ig3dnOphQdkcfyHft7RF8fXhNQK1oUEG1ID3lFUbjbtHQRtaRNJ5qhqF8crnM628UcMAab
        4Fyn6VdQ0urZ/VBXmmnkmVHEiYSSH/5c63gHsme9/ltCfvm57Y0Rlx5zN2/AiA==
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
Subject: [PATCH wpan-next v3 1/4] net: ieee802154: ca8210: Fix lifs/sifs periods
Date:   Tue,  1 Feb 2022 19:06:26 +0100
Message-Id: <20220201180629.93410-2-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220201180629.93410-1-miquel.raynal@bootlin.com>
References: <20220201180629.93410-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These periods are expressed in time units (microseconds) while 40 and 12
are the number of symbol durations these periods will last. We need to
multiply them both with the symbol_duration in order to get these
values in microseconds.

Fixes: ded845a781a5 ("ieee802154: Add CA8210 IEEE 802.15.4 device driver")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/net/ieee802154/ca8210.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
index f3438d3e104a..2bc730fd260e 100644
--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -2975,8 +2975,8 @@ static void ca8210_hw_setup(struct ieee802154_hw *ca8210_hw)
 	ca8210_hw->phy->cca.opt = NL802154_CCA_OPT_ENERGY_CARRIER_AND;
 	ca8210_hw->phy->cca_ed_level = -9800;
 	ca8210_hw->phy->symbol_duration = 16;
-	ca8210_hw->phy->lifs_period = 40;
-	ca8210_hw->phy->sifs_period = 12;
+	ca8210_hw->phy->lifs_period = 40 * ca8210_hw->phy->symbol_duration;
+	ca8210_hw->phy->sifs_period = 12 * ca8210_hw->phy->symbol_duration;
 	ca8210_hw->flags =
 		IEEE802154_HW_AFILT |
 		IEEE802154_HW_OMIT_CKSUM |
-- 
2.27.0


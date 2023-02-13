Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF1E694D74
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 17:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbjBMQzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 11:55:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230392AbjBMQy7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 11:54:59 -0500
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83B507698;
        Mon, 13 Feb 2023 08:54:23 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 6581A240003;
        Mon, 13 Feb 2023 16:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1676307261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ud52JoUUkqAzh5uPtXzBoHn5JC0T3wyNnvrXvG9wzQ8=;
        b=Ea6BuM8fdHSr8Ej72WSKj4QIh+2CpcxU2F3HbB/J1I7gwgtlieuD6sFEgvw3CC3BXXxRK2
        PnERRrO2p3mX/q1JTDD38cOj/BvcKmEk8a3C9yoaTMPM1oNh/jKs8Rc+0ejPH0cv+DhxB7
        HcNxCzSCdoYviTva8nsYtZLATtysBW+Ljc8N97kg6xuUkVQRh8vNaL+w2ICLA+N5oOgV9X
        a6rk3eB0gz1Vjmfe6eY5QN46DTMetSPK4ZW9Wr3/SpnQA4rT6rBw6QKeOu8ZXFEzt+GAA+
        9F/eaqtV/5hCdgwKnF6adXPVXKmoEZh18oD4XVu9JNTbaN988MoGSKcHXnh0lQ==
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
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Alexander Aring <aahringo@redhat.com>
Subject: [PATCH wpan 3/6] ieee802154: Change error code on monitor scan netlink request
Date:   Mon, 13 Feb 2023 17:54:11 +0100
Message-Id: <20230213165414.1168401-4-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230213165414.1168401-1-miquel.raynal@bootlin.com>
References: <20230213165414.1168401-1-miquel.raynal@bootlin.com>
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

Returning EPERM gives the impression that "right now" it is not
possible, but "later" it could be, while what we want to express is the
fact that this is not currently supported at all (might change in the
future). So let's return EOPNOTSUPP instead.

Fixes: 45755ce4bf46 ("ieee802154: Add support for user scanning requests")
Suggested-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/ieee802154/nl802154.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index d3b6e9e80941..8ee7d2ef55ee 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1409,7 +1409,7 @@ static int nl802154_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 
 	if (wpan_dev->iftype == NL802154_IFTYPE_MONITOR) {
 		NL_SET_ERR_MSG(info->extack, "Monitors are not allowed to perform scans");
-		return -EPERM;
+		return -EOPNOTSUPP;
 	}
 
 	if (!nla_get_u8(info->attrs[NL802154_ATTR_SCAN_TYPE])) {
-- 
2.34.1


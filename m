Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21767696589
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 14:58:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232950AbjBNN6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 08:58:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231572AbjBNN6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 08:58:19 -0500
Received: from mslow1.mail.gandi.net (mslow1.mail.gandi.net [IPv6:2001:4b98:dc4:8::240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C19F611E83;
        Tue, 14 Feb 2023 05:57:55 -0800 (PST)
Received: from relay2-d.mail.gandi.net (unknown [217.70.183.194])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id 6B896D31DB;
        Tue, 14 Feb 2023 13:51:25 +0000 (UTC)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 9DFA94001D;
        Tue, 14 Feb 2023 13:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1676382645;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8QJ2u6ExijKjmCM6vVGDhZ4dJE6j54W8Koh297gsAcA=;
        b=NWhQQcQSWwaLS9g5A42SRgjSWOWO/uSKs9p8178GIy7Pc6ldtJjI2pq04Z06JcwRjchESR
        /C/7tTfhtlxJljV9qu+QmnkdftCX0gliJuTtoQwAumGSyvVDKr4mh4C39QsSairrjFQ61N
        dcsQ/2oH7ZENRDB4zsf9jraZgpzi1cHDgXHNri1I2LTZf6UjgtAy+5RiwlJQ18WnGRY+QI
        iWf+XgqbmWul165TSHgsSn/9nFQDYCmHRl4NFARzyy1lN7+dYRM34gOxsPIiHLbyR0eQph
        qcW7mAC/0qYNLNGg9G3pwfqYie3UF8Ml/36AP1lcGxPNgDuOXIjm5yu6J+E2vw==
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
Subject: [PATCH wpan v2 3/6] ieee802154: Change error code on monitor scan netlink request
Date:   Tue, 14 Feb 2023 14:50:32 +0100
Message-Id: <20230214135035.1202471-4-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230214135035.1202471-1-miquel.raynal@bootlin.com>
References: <20230214135035.1202471-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Returning EPERM gives the impression that "right now" it is not
possible, but "later" it could be, while what we want to express is the
fact that this is not currently supported at all (might change in the
future). So let's return EOPNOTSUPP instead.

Fixes: ed3557c947e1 ("ieee802154: Add support for user scanning requests")
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


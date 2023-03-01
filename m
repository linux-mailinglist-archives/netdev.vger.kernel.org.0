Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B452D6A700A
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 16:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbjCAPo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 10:44:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbjCAPo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 10:44:57 -0500
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD504113E1;
        Wed,  1 Mar 2023 07:44:55 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id C1225FF812;
        Wed,  1 Mar 2023 15:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1677685493;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=7CBUJvpU2Rqxjw+zH4i747u1NOhNpaI2flcud4fIy+I=;
        b=RlLwfxsbp6Es6yIM37X1QS9F5bsFk4o1relYUs2iY0gsKLKInyA9aAVmG/xm9FFoNeFrl/
        toWvV6hag/m7i91Ud99Nv+1/p7V1y1uTcYT+5MhDQqJbpY5G+8pSBGupgI73JxLYyv/zPY
        3Y3UB1Ke7a2SL/QxvGvypkvKJj8rYK7EKrfNA0jf53AIdwLSWOZGKQQACT6h7D1BpjptGW
        8RXbo82DPqwQsDzPyE9xhPiAceHJb/2FNNrguvZea14LTvd6atibAYHZGOP7G/exoRrutJ
        o7fUEfz69OXNZoBaiMiNNchSoDAZm3n3kz18KuLgACpcpYeeYv2qMxjO2fBYlA==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sanan Hasanov <sanan.hasanov@Knights.ucf.edu>
Subject: [PATCH net] ieee802154: Prevent user from crashing the host
Date:   Wed,  1 Mar 2023 16:44:50 +0100
Message-Id: <20230301154450.547716-1-miquel.raynal@bootlin.com>
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

Avoid crashing the machine by checking
info->attrs[NL802154_ATTR_SCAN_TYPE] presence before de-referencing it,
which was the primary intend of the blamed patch.

Reported-by: Sanan Hasanov <sanan.hasanov@Knights.ucf.edu>
Suggested-by: Eric Dumazet <edumazet@google.com>
Fixes: a0b6106672b5 ("ieee802154: Convert scan error messages to extack")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/ieee802154/nl802154.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 88380606af2c..a18fb98a4b09 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1412,7 +1412,7 @@ static int nl802154_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 		return -EOPNOTSUPP;
 	}
 
-	if (!nla_get_u8(info->attrs[NL802154_ATTR_SCAN_TYPE])) {
+	if (!info->attrs[NL802154_ATTR_SCAN_TYPE]) {
 		NL_SET_ERR_MSG(info->extack, "Malformed request, missing scan type");
 		return -EINVAL;
 	}
-- 
2.34.1


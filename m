Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38BE454FDB2
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 21:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237237AbiFQTdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 15:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237141AbiFQTdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 15:33:03 -0400
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FCC7DE8F;
        Fri, 17 Jun 2022 12:33:02 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id EDB16C0006;
        Fri, 17 Jun 2022 19:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1655494381;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qfqy93Cw6Hdvjpvbx/L1acyYfNiU9Yv8v7DyB380mro=;
        b=L8SJVL7l28jQWGj5rz2jlvwPHlK1suSDUdJuwCpcNMZQ5z8yOJDWU0v9T5G1BJhORUztwU
        /MXVE7KGki5Hq33NO3oBXUoRDwhuDt7dUXXGEdQ2SejHQdtRjLmfPnCi2/9sLW9LpbYQdB
        omwLxH85iG2lSCLJPP/jAXn0ZH2f+xyqdLjwgyfUcqvpXzNx0iSJk5FN6D4z3/mcC843D8
        U2eUQBvGwOg5W5vZ2npb95BJr43GMN/K3FWlCkzdKc558Ocj8FhOC+qp92XeTy7YWbGJaH
        klaLYH9IZ467qn2XnW6KCqp9VQ85RsxX8yBtuJfHM09IznXJKEyW/t/92WldUg==
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
Subject: [PATCH wpan-next v2 2/6] net: ieee802154: Ensure only FFDs can become PAN coordinators
Date:   Fri, 17 Jun 2022 21:32:50 +0200
Message-Id: <20220617193254.1275912-3-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220617193254.1275912-1-miquel.raynal@bootlin.com>
References: <20220617193254.1275912-1-miquel.raynal@bootlin.com>
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

This is a limitation clearly listed in the specification. Now that we
have device types,let's ensure that only FFDs can become PAN
coordinators.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/ieee802154/nl802154.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 638bf544f102..0c6fc3385320 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -924,6 +924,9 @@ static int nl802154_new_interface(struct sk_buff *skb, struct genl_info *info)
 			return -EINVAL;
 	}
 
+	if (type == NL802154_IFTYPE_COORD && !cfg802154_is_ffd(rdev))
+		return -EINVAL;
+
 	if (info->attrs[NL802154_ATTR_EXTENDED_ADDR])
 		extended_addr = nla_get_le64(info->attrs[NL802154_ATTR_EXTENDED_ADDR]);
 
-- 
2.34.1


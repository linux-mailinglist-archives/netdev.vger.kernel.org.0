Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 145C160DE2E
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 11:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbiJZJfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 05:35:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233283AbiJZJfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 05:35:19 -0400
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E198BB878A;
        Wed, 26 Oct 2022 02:35:13 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 27EA020009;
        Wed, 26 Oct 2022 09:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1666776911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q7Xi58osnvUAmjzJGDqgNmzgjEezFGzGtZoGo66Sjzg=;
        b=AAMA/Lc3fC/RCCT5o4glV4C7PmXWYV8U4KIeRPNMOpweCGKo0fvjgVEtt/Yi3iKYM/4fAm
        VGo/QwzA87pigPLEIWbDcrrIHl4gh8X7IUNXu6HG6QEuuL0pK4d5fAUJKqdNfWay//CWBM
        7HJ/3FF/glsNi+2KTkyHpJ5oW+Jk4NskrVGswwMrb34usPjVT2BujOQIx3dYgWkBCqEgo6
        8im/hayp8vZq4iP1q7GwlzV2t1cFy61dLvKq92HLpePZewGyDVfFhyODvTf/j724Ci2nxO
        XZGGC8dSIlTAADKjMIkUTcPZMNNm0iJf118iXvTaxCX2kUm4uoLDJxWfhfzCWA==
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
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH wpan-next v2 2/3] mac802154: Clarify an expression
Date:   Wed, 26 Oct 2022 11:35:01 +0200
Message-Id: <20221026093502.602734-3-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221026093502.602734-1-miquel.raynal@bootlin.com>
References: <20221026093502.602734-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While going through the whole interface opening logic in my head I was
consistently bothered by the condition checking whether there was only
one interface of type NODE/COORD opened at the same time. What actually
bothered me was the fact that in one case we would use the wpan_dev
pointer directly while in the other case we would use the sdata pointer,
making it harder to differentiate both. In practice the condition should
be straightforward to read. IMHO dropping the wpan_dev indirection
allows to clarify the check.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/mac802154/iface.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/mac802154/iface.c b/net/mac802154/iface.c
index d9b50884d34e..f21132dd82cf 100644
--- a/net/mac802154/iface.c
+++ b/net/mac802154/iface.c
@@ -254,7 +254,6 @@ ieee802154_check_concurrent_iface(struct ieee802154_sub_if_data *sdata,
 				  enum nl802154_iftype iftype)
 {
 	struct ieee802154_local *local = sdata->local;
-	struct wpan_dev *wpan_dev = &sdata->wpan_dev;
 	struct ieee802154_sub_if_data *nsdata;
 
 	/* we hold the RTNL here so can safely walk the list */
@@ -267,7 +266,7 @@ ieee802154_check_concurrent_iface(struct ieee802154_sub_if_data *sdata,
 			 * exist really an use case if we need to support
 			 * multiple node types at the same time.
 			 */
-			if (wpan_dev->iftype == NL802154_IFTYPE_NODE &&
+			if (sdata->wpan_dev.iftype == NL802154_IFTYPE_NODE &&
 			    nsdata->wpan_dev.iftype == NL802154_IFTYPE_NODE)
 				return -EBUSY;
 
-- 
2.34.1


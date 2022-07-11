Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8C745635B7
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 16:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232970AbiGAOfy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 10:35:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231350AbiGAOfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 10:35:34 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A16DB3E0F5;
        Fri,  1 Jul 2022 07:31:06 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 84450FF811;
        Fri,  1 Jul 2022 14:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1656685858;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xsmXwpaLpw1nXtS9xDuA/axbZikDTvzLXsvuEZT4atc=;
        b=ETtrcos/xOHeLfRnQ+IeH2sDtXwStgv6Z5xhpQ4xRa5uAqqBVQn04/H8P2ebBAg51pdoRe
        QCEpJUKSUhh4PKXLG1lytSJku/1wNaxoQVbUnQlC3Tn8as8o4CuVbim+rufTTYsfdtEs15
        L/nBt1Bws3DvssOgs1VYYGrOWn/RlFoHhDdPaJeyvSE1+9imo+TbKCKyscH8XC4iMa88ru
        80laA0xF6Ms1SQCwbWyjJFnmHacuvyF8ED7cQqVJCleLx6zVCqML1dlebqdEYB2+r1roIz
        MuUr45bAmhFnYXCHiRmVYrKsERWJ/35u4pLJlaWIEU5klChibND7IpIfkcrKuQ==
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
Subject: [PATCH wpan-next 01/20] net: mac802154: Allow the creation of coordinator interfaces
Date:   Fri,  1 Jul 2022 16:30:33 +0200
Message-Id: <20220701143052.1267509-2-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
References: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As a first strep in introducing proper PAN management and association,
we need to be able to create coordinator interfaces which might act as
coordinator or PAN coordinator.

Hence, let's add the minimum support to allow the creation of these
interfaces. This might be restrained and improved later.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/mac802154/iface.c | 14 ++++++++------
 net/mac802154/rx.c    |  2 +-
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/net/mac802154/iface.c b/net/mac802154/iface.c
index 500ed1b81250..7ac0c5685d3f 100644
--- a/net/mac802154/iface.c
+++ b/net/mac802154/iface.c
@@ -273,13 +273,13 @@ ieee802154_check_concurrent_iface(struct ieee802154_sub_if_data *sdata,
 		if (nsdata != sdata && ieee802154_sdata_running(nsdata)) {
 			int ret;
 
-			/* TODO currently we don't support multiple node types
-			 * we need to run skb_clone at rx path. Check if there
-			 * exist really an use case if we need to support
-			 * multiple node types at the same time.
+			/* TODO currently we don't support multiple node/coord
+			 * types we need to run skb_clone at rx path. Check if
+			 * there exist really an use case if we need to support
+			 * multiple node/coord types at the same time.
 			 */
-			if (wpan_dev->iftype == NL802154_IFTYPE_NODE &&
-			    nsdata->wpan_dev.iftype == NL802154_IFTYPE_NODE)
+			if (wpan_dev->iftype != NL802154_IFTYPE_MONITOR &&
+			    nsdata->wpan_dev.iftype != NL802154_IFTYPE_MONITOR)
 				return -EBUSY;
 
 			/* check all phy mac sublayer settings are the same.
@@ -577,6 +577,7 @@ ieee802154_setup_sdata(struct ieee802154_sub_if_data *sdata,
 	wpan_dev->short_addr = cpu_to_le16(IEEE802154_ADDR_BROADCAST);
 
 	switch (type) {
+	case NL802154_IFTYPE_COORD:
 	case NL802154_IFTYPE_NODE:
 		ieee802154_be64_to_le64(&wpan_dev->extended_addr,
 					sdata->dev->dev_addr);
@@ -636,6 +637,7 @@ ieee802154_if_add(struct ieee802154_local *local, const char *name,
 	ieee802154_le64_to_be64(ndev->perm_addr,
 				&local->hw.phy->perm_extended_addr);
 	switch (type) {
+	case NL802154_IFTYPE_COORD:
 	case NL802154_IFTYPE_NODE:
 		ndev->type = ARPHRD_IEEE802154;
 		if (ieee802154_is_valid_extended_unicast_addr(extended_addr)) {
diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
index b8ce84618a55..39459d8d787a 100644
--- a/net/mac802154/rx.c
+++ b/net/mac802154/rx.c
@@ -203,7 +203,7 @@ __ieee802154_rx_handle_packet(struct ieee802154_local *local,
 	}
 
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
-		if (sdata->wpan_dev.iftype != NL802154_IFTYPE_NODE)
+		if (sdata->wpan_dev.iftype == NL802154_IFTYPE_MONITOR)
 			continue;
 
 		if (!ieee802154_sdata_running(sdata))
-- 
2.34.1


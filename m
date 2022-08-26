Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42B9F5A29B9
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 16:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344510AbiHZOlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 10:41:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344524AbiHZOlP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 10:41:15 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::228])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D75ED4775;
        Fri, 26 Aug 2022 07:41:09 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 94ED01BF207;
        Fri, 26 Aug 2022 14:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1661524867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ajt4B69LYjejgNbGEH2ZBoXmoFMV0MROjIzP4TuvpyA=;
        b=nLwYtks8TJFjNL/MZlSuqKIGaDJf90Y+soH1lEZj70pPwOzqqUMjkFbO7HplUJWf522cwp
        ofV8J2Ct7RoHBZnAHTzTm4SGKXE1w8SSZcm6vq8VHrUj8wohFhxNLelvEOPfPJeMjfUML/
        Jx0kD/TII87FvtMsIeQsc1REhJDe/F5/4txZcEW9j8i8uDUk2U6K8eP0EHvjZPcBUlOcRs
        TIMBDuzQno+9kfnAktPcFlkyiNXPvKRj8qD+82p3ZJZJNfK6NL9t3cZvqqcovvq8DPyf5O
        sfDnrUfbDpLpwhmKLpTPRGUkwJBj9GJqdjwNpyUioJ/4kd3IXCe30VTO4pLYeg==
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
Subject: [PATCH wpan-next v2 06/11] net: ieee802154: Trace the registration of new PANs
Date:   Fri, 26 Aug 2022 16:40:44 +0200
Message-Id: <20220826144049.256134-7-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220826144049.256134-1-miquel.raynal@bootlin.com>
References: <20220826144049.256134-1-miquel.raynal@bootlin.com>
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

From: David Girault <david.girault@qorvo.com>

Add an internal trace when new PANs get discovered.

Signed-off-by: David Girault <david.girault@qorvo.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/ieee802154/pan.c   |  2 ++
 net/ieee802154/trace.h | 25 +++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/net/ieee802154/pan.c b/net/ieee802154/pan.c
index 27fb5432f651..d3b7a9764319 100644
--- a/net/ieee802154/pan.c
+++ b/net/ieee802154/pan.c
@@ -18,6 +18,7 @@
 
 #include "ieee802154.h"
 #include "../ieee802154/nl802154.h"
+#include "trace.h"
 
 struct ieee802154_coord_desc *
 cfg802154_alloc_coordinator(struct ieee802154_addr *coord)
@@ -90,6 +91,7 @@ void cfg802154_record_coordinator(struct wpan_phy *wpan_phy,
 		cfg802154_free_coordinator_desc(desc);
 	} else {
 		list_add_tail(&desc->node, &wpan_dev->coord_list);
+		trace_802154_new_coordinator(desc);
 		nl802154_advertise_new_coordinator(wpan_phy, wpan_dev, desc);
 	}
 
diff --git a/net/ieee802154/trace.h b/net/ieee802154/trace.h
index 19c2e5d60e76..03b3817c34ad 100644
--- a/net/ieee802154/trace.h
+++ b/net/ieee802154/trace.h
@@ -295,6 +295,31 @@ TRACE_EVENT(802154_rdev_set_ackreq_default,
 		WPAN_DEV_PR_ARG, BOOL_TO_STR(__entry->ackreq))
 );
 
+DECLARE_EVENT_CLASS(802154_new_coordinator_evt,
+	TP_PROTO(struct ieee802154_coord_desc *desc),
+	TP_ARGS(desc),
+	TP_STRUCT__entry(
+		__field(__le16, pan_id)
+		__field(__le64, addr)
+		__field(u8, channel)
+		__field(u8, page)
+	),
+	TP_fast_assign(
+		__entry->page = desc->page;
+		__entry->channel = desc->channel;
+		__entry->pan_id = desc->addr->pan_id;
+		__entry->addr = desc->addr->extended_addr;
+	),
+	TP_printk("panid: %u, coord_addr: 0x%llx, page: %u, channel: %u",
+		  __le16_to_cpu(__entry->pan_id), __le64_to_cpu(__entry->addr),
+		  __entry->page, __entry->channel)
+);
+
+DEFINE_EVENT(802154_new_coordinator_evt, 802154_new_coordinator,
+	TP_PROTO(struct ieee802154_coord_desc *desc),
+	TP_ARGS(desc)
+);
+
 TRACE_EVENT(802154_rdev_return_int,
 	TP_PROTO(struct wpan_phy *wpan_phy, int ret),
 	TP_ARGS(wpan_phy, ret),
-- 
2.34.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E20663C189
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 14:55:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbiK2Nz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 08:55:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234473AbiK2Nzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 08:55:53 -0500
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6479253EF9;
        Tue, 29 Nov 2022 05:55:47 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 07EDAFF812;
        Tue, 29 Nov 2022 13:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1669730144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1olgmhX/nzQdYt9m5dIM1iGrl1O8ewDG6zq4MYn3qUs=;
        b=aYVys3GQbl05pcGzT0XrK4KzifR2Sn71O0r5HkAO6mWCexf2vkTWKXerND+fUOtR0F7g7H
        vWJWf+L/LFE2L5FDPEpOt81EBV35MagTMa/gcOUneWqXyySJpOvnaZbEGNJ0IMJmpMy1EP
        lIbInNUhePfCKe4awHLiWX6PtuSAm337H8VwNsNAbJWYO981RqGQMWNnNHIHBxyHjzJAgn
        hQyTQOCKn48HoeSoWHnMferCXej3vjb6Ul4cDIwGCwbs/HFIw9Zwwx/snFzDczVeAX7GNP
        A7aPpus9OPWRYy2r9GPrXfo6zpMTrBu+QKqgRDFB2QbN4OlHX3l9+AJxIAXtbQ==
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
Subject: [PATCH wpan-next v3 2/2] mac802154: Trace the registration of new PANs
Date:   Tue, 29 Nov 2022 14:55:35 +0100
Message-Id: <20221129135535.532513-3-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221129135535.532513-1-miquel.raynal@bootlin.com>
References: <20221129135535.532513-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Girault <david.girault@qorvo.com>

Add an internal trace when valid beacons are received.

Signed-off-by: David Girault <david.girault@qorvo.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/mac802154/trace.h | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/net/mac802154/trace.h b/net/mac802154/trace.h
index df855c33daf2..689396d6c76a 100644
--- a/net/mac802154/trace.h
+++ b/net/mac802154/trace.h
@@ -264,6 +264,31 @@ TRACE_EVENT(802154_drv_set_promiscuous_mode,
 		  BOOL_TO_STR(__entry->on))
 );
 
+TRACE_EVENT(802154_new_scan_event,
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
+		__entry->pan_id = desc->addr.pan_id;
+		__entry->addr = desc->addr.extended_addr;
+	),
+	TP_printk("panid: %u, coord_addr: 0x%llx, page: %u, channel: %u",
+		  __le16_to_cpu(__entry->pan_id), __le64_to_cpu(__entry->addr),
+		  __entry->page, __entry->channel)
+);
+
+DEFINE_EVENT(802154_new_scan_event, 802154_scan_event,
+	TP_PROTO(struct ieee802154_coord_desc *desc),
+	TP_ARGS(desc)
+);
+
 #endif /* !__MAC802154_DRIVER_TRACE || TRACE_HEADER_MULTI_READ */
 
 #undef TRACE_INCLUDE_PATH
-- 
2.34.1


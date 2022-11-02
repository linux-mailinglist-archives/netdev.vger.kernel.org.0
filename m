Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8FB36165F8
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 16:20:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbiKBPUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 11:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230337AbiKBPTa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 11:19:30 -0400
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 440CD1C127;
        Wed,  2 Nov 2022 08:19:27 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 57665C0019;
        Wed,  2 Nov 2022 15:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1667402366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zwy+A+DR3Owv+hWflM+RVTuLs3Xr73iZ4E7To7VS/Uw=;
        b=OL/KVzt7FVyNhS5FPl2fEOe6K097E4gGlDZjbTz6Wrd+d4OrsYtjcauZ2igZnFRQPfDWb5
        zFhRoSrzNzq1WwAjGwkYv2GklBhYAJI/SqgwBtsyzO3H2r60WV0qidf5hTGc5ImF/hxnP/
        6oBQAas3PHtqSQrYOfGycExD3KibxJNxMj2syuDvkeOd2G2Q0/JMmT3rj1sw1M+Vk8ONrG
        s0j8Qpu3qmHMwctXBMeo612O+t1HyWiEFs1R5k7hTX2KjRkGrEV1gQQV/gjJixrFTliXzN
        4qErF1KrGCfLoepzSoIr7Lk0TOfEfnWGcyOBle8cBYiJk0Px5UWzrmorm6PRkQ==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH wpan-next 3/3] ieee802154: Trace the registration of new PANs
Date:   Wed,  2 Nov 2022 16:19:15 +0100
Message-Id: <20221102151915.1007815-4-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221102151915.1007815-1-miquel.raynal@bootlin.com>
References: <20221102151915.1007815-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
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

Add an internal trace when new PANs get discovered.

Signed-off-by: David Girault <david.girault@qorvo.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/ieee802154/pan.c   |  2 ++
 net/ieee802154/trace.h | 25 +++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/net/ieee802154/pan.c b/net/ieee802154/pan.c
index 0d4f752a090a..b41fe173edd3 100644
--- a/net/ieee802154/pan.c
+++ b/net/ieee802154/pan.c
@@ -18,6 +18,7 @@
 
 #include "ieee802154.h"
 #include "../ieee802154/nl802154.h"
+#include "trace.h"
 
 struct ieee802154_coord_desc *
 cfg802154_alloc_coordinator(struct ieee802154_addr *coord, gfp_t gfp)
@@ -91,6 +92,7 @@ void cfg802154_record_coordinator(struct wpan_phy *wpan_phy,
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


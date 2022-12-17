Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABD6464F578
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 01:02:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbiLQACp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 19:02:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiLQACg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 19:02:36 -0500
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E0EC31ED4;
        Fri, 16 Dec 2022 16:02:34 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 1562360002;
        Sat, 17 Dec 2022 00:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1671235353;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p090nh7rgUViJrqpW9jNvqzuL70OUp/3gOlQm9i3wOk=;
        b=oLhUoo3FlkWqZYij+UkyLGGjUg6N+gHvZlgFLymPplAPFAqRgUXoW29sf46u8+Dq6FqTwR
        69tPteqf8vG6GuMvrsCXDbi566/frulj+31yaasv1+fI6WlhuOzcowKsoBO+qHUWHlK8R4
        ffVxU7iAmPj9ihRPY6ipbZQBKxYlpzJ7TP2C/VJfg7k/7/7BV9N7zePUfOm95QgEmnuQkU
        awM7mwua4qbk1uwZJHIEIUVV7cJhkkCfVcDEIh9qe1/XlDmPTHyTLLXAZ8yLUJbZuVBhCo
        ybr/TlmZOBAPt1cTFGpCm2BD86NaCueOhZE17TJzco6YouKwLUAII8w56NDqqg==
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
Subject: [PATCH wpan-next v2 2/6] ieee802154: Define a beacon frame header
Date:   Sat, 17 Dec 2022 01:02:22 +0100
Message-Id: <20221217000226.646767-3-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221217000226.646767-1-miquel.raynal@bootlin.com>
References: <20221217000226.646767-1-miquel.raynal@bootlin.com>
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

This definition will be used when adding support for scanning and defines
the content of a beacon frame header as in the 802.15.4 specification.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/ieee802154_netdev.h | 36 +++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/include/net/ieee802154_netdev.h b/include/net/ieee802154_netdev.h
index 4c33a20ea57f..2f2196049a86 100644
--- a/include/net/ieee802154_netdev.h
+++ b/include/net/ieee802154_netdev.h
@@ -38,6 +38,42 @@
 
 #include <net/cfg802154.h>
 
+struct ieee802154_beacon_hdr {
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+	u16 beacon_order:4,
+	    superframe_order:4,
+	    final_cap_slot:4,
+	    battery_life_ext:1,
+	    reserved0:1,
+	    pan_coordinator:1,
+	    assoc_permit:1;
+	u8  gts_count:3,
+	    gts_reserved:4,
+	    gts_permit:1;
+	u8  pend_short_addr_count:3,
+	    reserved1:1,
+	    pend_ext_addr_count:3,
+	    reserved2:1;
+#elif defined(__BIG_ENDIAN_BITFIELD)
+	u16 assoc_permit:1,
+	    pan_coordinator:1,
+	    reserved0:1,
+	    battery_life_ext:1,
+	    final_cap_slot:4,
+	    superframe_order:4,
+	    beacon_order:4;
+	u8  gts_permit:1,
+	    gts_reserved:4,
+	    gts_count:3;
+	u8  reserved2:1,
+	    pend_ext_addr_count:3,
+	    reserved1:1,
+	    pend_short_addr_count:3;
+#else
+#error	"Please fix <asm/byteorder.h>"
+#endif
+} __packed;
+
 struct ieee802154_sechdr {
 #if defined(__LITTLE_ENDIAN_BITFIELD)
 	u8 level:3,
-- 
2.34.1


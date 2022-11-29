Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0F763C48B
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 17:02:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236137AbiK2QCq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 11:02:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234997AbiK2QCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 11:02:08 -0500
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F3DD64A00;
        Tue, 29 Nov 2022 08:00:57 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id E6C401C0011;
        Tue, 29 Nov 2022 16:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1669737656;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p090nh7rgUViJrqpW9jNvqzuL70OUp/3gOlQm9i3wOk=;
        b=PXFONfr3a+91M6Wq8NgNhy/HYU7BBSa2IXh2q4bzVt48tPjSJbFMVB8djlTtyO652ef3w1
        p59lCxJorlJi1u9bLW3mwF8gvaNQHxLm4bmO0IsimuGJZc3KGYmME9sbhMCaXu0fRWWSGS
        BqrsZIwr8RH1kIdQ8jrAv4CY0562TgwBGzwt0MnFdP/HMvaoRmZWdHuw8lFRoiUNrL7fTv
        PMY2pR4BeDzVwX7sgWVHOjpxL2UhgMH0CZr0ocALPW5RQ2/jYjlx6YnDdiZjfV70bAbWf2
        eZzIFFZk8yZP7DN7yNugpWyx22MWxaEulyKZpz5Fhyt8Zk7IIbNEiLV+IPIhPw==
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
Subject: [PATCH wpan-next 2/6] ieee802154: Define a beacon frame header
Date:   Tue, 29 Nov 2022 17:00:42 +0100
Message-Id: <20221129160046.538864-3-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221129160046.538864-1-miquel.raynal@bootlin.com>
References: <20221129160046.538864-1-miquel.raynal@bootlin.com>
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


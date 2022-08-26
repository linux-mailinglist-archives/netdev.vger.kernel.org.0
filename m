Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 917995A29CB
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 16:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344565AbiHZOlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 10:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344543AbiHZOlR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 10:41:17 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 943F1D5EAB;
        Fri, 26 Aug 2022 07:41:14 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id BA3941BF205;
        Fri, 26 Aug 2022 14:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1661524873;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9wcgIyPGRS/zviXahs9+8cWYo2rex5zR9iCJofdW/9A=;
        b=iF31hzAUFE5ZIwmHVpsNoL6o7zvpuOYwv/bcfMhuVPfhGuIk7N18OFXJvozZ7U6C8WlV+1
        fNgIenm4NqWv5QLTZ5DNvK/9jmSW7w7bhxF18KMdr0GGITopMNDjPU133bEUBV7XK5VyWf
        W5Uqch+znhjSgLrXRGZ0uA8WUG/YG0Ds3gzPeqFcMzBeE/dCRpyRxaKUGF0XlFQy4lT/T2
        VPPNhvAPLZm5PEHUfisxY8JdCJYFmH0fwA3NkB22hGVi0lf0jnWg353xQEPF05wF11iOSm
        omALcMGSu1jyDZmXgKk/i5l6bdU2LZYGyUnC8FZW23g6zsfZtlMy7lDKaXhkig==
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
Subject: [PATCH wpan-next v2 08/11] net: ieee802154: Define a beacon frame header
Date:   Fri, 26 Aug 2022 16:40:46 +0200
Message-Id: <20220826144049.256134-9-miquel.raynal@bootlin.com>
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

This definition will be used when adding support for scanning and defines
the content of a beacon frame header as in the 802.15.4 specification.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/ieee802154_netdev.h | 36 +++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/include/net/ieee802154_netdev.h b/include/net/ieee802154_netdev.h
index d0d188c3294b..fb6ac354a7b6 100644
--- a/include/net/ieee802154_netdev.h
+++ b/include/net/ieee802154_netdev.h
@@ -22,6 +22,42 @@
 
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


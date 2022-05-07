Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD2351E8B7
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 19:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386418AbiEGRJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 May 2022 13:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446638AbiEGRIl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 May 2022 13:08:41 -0400
Received: from mxout3.routing.net (mxout3.routing.net [IPv6:2a03:2900:1:a::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 283D41BE82;
        Sat,  7 May 2022 10:04:54 -0700 (PDT)
Received: from mxbox4.masterlogin.de (unknown [192.168.10.79])
        by mxout3.routing.net (Postfix) with ESMTP id 7F3A66055D;
        Sat,  7 May 2022 17:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailerdienst.de;
        s=20200217; t=1651943092;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ix14kKhkfGJ0LxMzmCAvLzUtN0qvLqOmhQQPbdvCsFI=;
        b=uzvPR9IL9rUuL6JyIRAxn1pjcNMQFBeFUYh8m75mxHhALtCwkHuG/oErktCF4Rwix518dx
        1ilapP1rpHha2rdfg/9iCjQgts91aGy9Pv33Ij5mJ5s5qX+bK9IVLfNX556pjCpcqiCFwy
        np+GpdURPQMTWvTN4ItDN2ZZPHACcfQ=
Received: from localhost.localdomain (fttx-pool-80.245.74.2.bambit.de [80.245.74.2])
        by mxbox4.masterlogin.de (Postfix) with ESMTPSA id 702A1800AB;
        Sat,  7 May 2022 17:04:51 +0000 (UTC)
From:   Frank Wunderlich <linux@fw-web.de>
To:     linux-rockchip@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Greg Ungerer <gerg@kernel.org>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>,
        "Mauro Carvalho Chehab" <mchehab+samsung@kernel.org>
Subject: [PATCH v3 2/6] net: dsa: mt7530: rework mt7530_hw_vlan_{add,del}
Date:   Sat,  7 May 2022 19:04:36 +0200
Message-Id: <20220507170440.64005-3-linux@fw-web.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220507170440.64005-1-linux@fw-web.de>
References: <20220507170440.64005-1-linux@fw-web.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Mail-ID: d260aa6b-fd71-45f7-beb2-17018c2f97a8
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Frank Wunderlich <frank-w@public-files.de>

Rework vlan_add/vlan_del functions in preparation for dynamic cpu port.

Currently BIT(MT7530_CPU_PORT) is added to new_members, even though
mt7530_port_vlan_add() will be called on the CPU port too.

Let DSA core decide when to call port_vlan_add for the CPU port, rather
than doing it implicitly.

We can do autonomous forwarding in a certain VLAN, but not add br0 to that
VLAN and avoid flooding the CPU with those packets, if software knows it
doesn't need to process them.

Suggested-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---
v2: new patch
---
 drivers/net/dsa/mt7530.c | 30 ++++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 19f0035d4410..46dee0714382 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1522,11 +1522,11 @@ static void
 mt7530_hw_vlan_add(struct mt7530_priv *priv,
 		   struct mt7530_hw_vlan_entry *entry)
 {
+	struct dsa_port *dp = dsa_to_port(priv->ds, entry->port);
 	u8 new_members;
 	u32 val;
 
-	new_members = entry->old_members | BIT(entry->port) |
-		      BIT(MT7530_CPU_PORT);
+	new_members = entry->old_members | BIT(entry->port);
 
 	/* Validate the entry with independent learning, create egress tag per
 	 * VLAN and joining the port as one of the port members.
@@ -1537,22 +1537,20 @@ mt7530_hw_vlan_add(struct mt7530_priv *priv,
 
 	/* Decide whether adding tag or not for those outgoing packets from the
 	 * port inside the VLAN.
-	 */
-	val = entry->untagged ? MT7530_VLAN_EGRESS_UNTAG :
-				MT7530_VLAN_EGRESS_TAG;
-	mt7530_rmw(priv, MT7530_VAWD2,
-		   ETAG_CTRL_P_MASK(entry->port),
-		   ETAG_CTRL_P(entry->port, val));
-
-	/* CPU port is always taken as a tagged port for serving more than one
+	 * CPU port is always taken as a tagged port for serving more than one
 	 * VLANs across and also being applied with egress type stack mode for
 	 * that VLAN tags would be appended after hardware special tag used as
 	 * DSA tag.
 	 */
+	if (dsa_port_is_cpu(dp))
+		val = MT7530_VLAN_EGRESS_STACK;
+	else if (entry->untagged)
+		val = MT7530_VLAN_EGRESS_UNTAG;
+	else
+		val = MT7530_VLAN_EGRESS_TAG;
 	mt7530_rmw(priv, MT7530_VAWD2,
-		   ETAG_CTRL_P_MASK(MT7530_CPU_PORT),
-		   ETAG_CTRL_P(MT7530_CPU_PORT,
-			       MT7530_VLAN_EGRESS_STACK));
+		   ETAG_CTRL_P_MASK(entry->port),
+		   ETAG_CTRL_P(entry->port, val));
 }
 
 static void
@@ -1571,11 +1569,7 @@ mt7530_hw_vlan_del(struct mt7530_priv *priv,
 		return;
 	}
 
-	/* If certain member apart from CPU port is still alive in the VLAN,
-	 * the entry would be kept valid. Otherwise, the entry is got to be
-	 * disabled.
-	 */
-	if (new_members && new_members != BIT(MT7530_CPU_PORT)) {
+	if (new_members) {
 		val = IVL_MAC | VTAG_EN | PORT_MEM(new_members) |
 		      VLAN_VALID;
 		mt7530_write(priv, MT7530_VAWD1, val);
-- 
2.25.1


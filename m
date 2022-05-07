Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43DFD51E8CF
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 19:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446691AbiEGRJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 May 2022 13:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446663AbiEGRIm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 May 2022 13:08:42 -0400
Received: from mxout2.routing.net (mxout2.routing.net [IPv6:2a03:2900:1:a::b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D8E1BEB6;
        Sat,  7 May 2022 10:04:55 -0700 (PDT)
Received: from mxbox4.masterlogin.de (unknown [192.168.10.79])
        by mxout2.routing.net (Postfix) with ESMTP id 787F05FBBE;
        Sat,  7 May 2022 17:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailerdienst.de;
        s=20200217; t=1651943093;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BOY0bxdUhNN3M6I8q15fOn3ipf8lrnx60tc5aC+4lnk=;
        b=nqkLXOeSkx0VfNka4n7l/jrc0pql7icRrrm1B91MdHmrdpcESrNV1P4BaIkCM3JCbqM2hD
        9O1tZEwMLOfWwvClUDqVJz2knCu6bIURMi5440WnFj796Ib/kVEBvjMY9kWMn6kfrhwLVd
        OrOYwZNMTn/YUNw7Yj2sg0TEqKO8eZg=
Received: from localhost.localdomain (fttx-pool-80.245.74.2.bambit.de [80.245.74.2])
        by mxbox4.masterlogin.de (Postfix) with ESMTPSA id 618EA800E7;
        Sat,  7 May 2022 17:04:52 +0000 (UTC)
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
Subject: [PATCH v3 3/6] net: dsa: mt7530: rework mt753[01]_setup
Date:   Sat,  7 May 2022 19:04:37 +0200
Message-Id: <20220507170440.64005-4-linux@fw-web.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220507170440.64005-1-linux@fw-web.de>
References: <20220507170440.64005-1-linux@fw-web.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Mail-ID: fbc2c6b2-366b-40c3-9cbd-9defd045faa2
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Frank Wunderlich <frank-w@public-files.de>

Enumerate available cpu-ports instead of using hardcoded constant.

Suggested-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/mt7530.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 46dee0714382..144c29f8fefc 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2087,11 +2087,12 @@ static int
 mt7530_setup(struct dsa_switch *ds)
 {
 	struct mt7530_priv *priv = ds->priv;
+	struct device_node *dn = NULL;
 	struct device_node *phy_node;
 	struct device_node *mac_np;
 	struct mt7530_dummy_poll p;
 	phy_interface_t interface;
-	struct device_node *dn;
+	struct dsa_port *cpu_dp;
 	u32 id, val;
 	int ret, i;
 
@@ -2099,7 +2100,19 @@ mt7530_setup(struct dsa_switch *ds)
 	 * controller also is the container for two GMACs nodes representing
 	 * as two netdev instances.
 	 */
-	dn = dsa_to_port(ds, MT7530_CPU_PORT)->master->dev.of_node->parent;
+	dsa_switch_for_each_cpu_port(cpu_dp, ds) {
+		dn = cpu_dp->master->dev.of_node->parent;
+		/* It doesn't matter which CPU port is found first,
+		 * their masters should share the same parent OF node
+		 */
+		break;
+	}
+
+	if (!dn) {
+		dev_err(ds->dev, "parent OF node of DSA master not found");
+		return -EINVAL;
+	}
+
 	ds->assisted_learning_on_cpu_port = true;
 	ds->mtu_enforcement_ingress = true;
 
@@ -2260,6 +2273,7 @@ mt7531_setup(struct dsa_switch *ds)
 {
 	struct mt7530_priv *priv = ds->priv;
 	struct mt7530_dummy_poll p;
+	struct dsa_port *cpu_dp;
 	u32 val, id;
 	int ret, i;
 
@@ -2332,8 +2346,11 @@ mt7531_setup(struct dsa_switch *ds)
 				 CORE_PLL_GROUP4, val);
 
 	/* BPDU to CPU port */
-	mt7530_rmw(priv, MT7531_CFC, MT7531_CPU_PMAP_MASK,
-		   BIT(MT7530_CPU_PORT));
+	dsa_switch_for_each_cpu_port(cpu_dp, ds) {
+		mt7530_rmw(priv, MT7531_CFC, MT7531_CPU_PMAP_MASK,
+			   BIT(cpu_dp->index));
+		break;
+	}
 	mt7530_rmw(priv, MT753X_BPC, MT753X_BPDU_PORT_FW_MASK,
 		   MT753X_BPDU_CPU_ONLY);
 
-- 
2.25.1


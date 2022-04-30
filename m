Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED081515D30
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 15:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382622AbiD3NH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 09:07:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382595AbiD3NH0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 09:07:26 -0400
Received: from mxout3.routing.net (mxout3.routing.net [IPv6:2a03:2900:1:a::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3735A80722;
        Sat, 30 Apr 2022 06:04:03 -0700 (PDT)
Received: from mxbox3.masterlogin.de (unknown [192.168.10.78])
        by mxout3.routing.net (Postfix) with ESMTP id 695D060558;
        Sat, 30 Apr 2022 13:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailerdienst.de;
        s=20200217; t=1651323842;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LfsvQJQSzl8CIsJRZhpttH4V4tci5c+LrDqCSmvZG2E=;
        b=ZTEMI1rKV8GDE6M6mu1N2eCI7XNXn7tl0UQr2KIYUdn8YCDBjwMrTQ7HJcrYlZJ4REZ/G/
        CvF5jxPiMkDvbl1ieKdY1cB5AL9GALl1SSoIo4/Lq6ETm0+AicgFp5oyYX94WlyE8GnNoH
        XOWldNgLLH58VSRaWkzHD6moPx7RS+s=
Received: from localhost.localdomain (fttx-pool-80.245.72.211.bambit.de [80.245.72.211])
        by mxbox3.masterlogin.de (Postfix) with ESMTPSA id 4E44B3605FC;
        Sat, 30 Apr 2022 13:04:01 +0000 (UTC)
From:   Frank Wunderlich <linux@fw-web.de>
To:     linux-mediatek@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [RFC v2 2/4] net: dsa: mt7530: rework mt753[01]_setup
Date:   Sat, 30 Apr 2022 15:03:45 +0200
Message-Id: <20220430130347.15190-3-linux@fw-web.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220430130347.15190-1-linux@fw-web.de>
References: <20220430130347.15190-1-linux@fw-web.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Mail-ID: 4c126447-4b4c-4737-bb96-3b868640f48f
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Frank Wunderlich <frank-w@public-files.de>

Enumerate available cpu-ports instead of using hardcoded constant.

Suggested-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
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


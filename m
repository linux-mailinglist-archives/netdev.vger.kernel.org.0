Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA6BF51F1FA
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 00:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233437AbiEHWxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 18:53:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233405AbiEHWxc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 18:53:32 -0400
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050:0:465::202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EDCB3896
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 15:49:39 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [10.196.197.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4KxKHg4np3z9swV;
        Mon,  9 May 2022 00:49:35 +0200 (CEST)
From:   Hauke Mehrtens <hauke@hauke-m.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hauke-m.de; s=MBO0001;
        t=1652050173;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/LpIvSbdSirR439IcRLy27XAI6T3D+Euff6M1MgxD9Y=;
        b=sz3bDuhE0zqbDFLXKDxN2Y1ookQ4D0thvC+WiK9psjqx3QJmjma1PFl9/BKJbD/YEwFzvo
        Ryxa0d4Usi3A4bQrWKLMeyKTA61GnkfhDv2O0RMdRXtNVKk6aXq/o88Mcbey8tOwtK+lQx
        hCb2Z6/LvYEAaWDsY+x1rJumYv5iIYiOO9cmStT5ODnFcuiixbZ3J/bGT5mAqif5PHATIn
        efEoKmUg3KzURZNS0j5WA6oD2pkEmmGn3PVV+LTYmGgk6M8ViAStrAgUCsNTiK+HiQ6M87
        ge95i1XP3aBQxuK38PuiKkUAB40A9nL7wPZ2QvXEN63yHTkbvjKnouJ5MkK7LQ==
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linus.walleij@linaro.org, alsi@bang-olufsen.dk, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        netdev@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/4] net: dsa: realtek: rtl8365mb: Add setting MTU
Date:   Mon,  9 May 2022 00:48:47 +0200
Message-Id: <20220508224848.2384723-4-hauke@hauke-m.de>
In-Reply-To: <20220508224848.2384723-1-hauke@hauke-m.de>
References: <20220508224848.2384723-1-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The switch does not support per port MTU setting, but only a MRU
setting. Implement this by setting the MTU on the CPU port.

Without this patch the MRU was always set to 1536, not it is set by the
DSA subsystem and the user scan change it.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/dsa/realtek/rtl8365mb.c | 43 ++++++++++++++++++++++++-----
 1 file changed, 36 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index be64cfdeccc7..f9b690251155 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -1132,6 +1132,38 @@ static int rtl8365mb_port_set_isolation(struct realtek_priv *priv, int port,
 	return regmap_write(priv->map, RTL8365MB_PORT_ISOLATION_REG(port), mask);
 }
 
+static int rtl8365mb_port_change_mtu(struct dsa_switch *ds, int port,
+				     int new_mtu)
+{
+	struct dsa_port *dp = dsa_to_port(ds, port);
+	struct realtek_priv *priv = ds->priv;
+	int length;
+
+	/* When a new MTU is set, DSA always set the CPU port's MTU to the
+	 * largest MTU of the slave ports. Because the switch only has a global
+	 * RX length register, only allowing CPU port here is enough.
+	 */
+	if (!dsa_is_cpu_port(ds, port))
+		return 0;
+
+	length = new_mtu + ETH_HLEN + ETH_FCS_LEN;
+	length += dp->tag_ops->needed_headroom;
+	length += dp->tag_ops->needed_tailroom;
+
+	if (length > RTL8365MB_CFG0_MAX_LEN_MASK)
+		return -EINVAL;
+
+	return regmap_update_bits(priv->map, RTL8365MB_CFG0_MAX_LEN_REG,
+				  RTL8365MB_CFG0_MAX_LEN_MASK,
+				  FIELD_PREP(RTL8365MB_CFG0_MAX_LEN_MASK,
+					     length));
+}
+
+static int rtl8365mb_port_max_mtu(struct dsa_switch *ds, int port)
+{
+	return RTL8365MB_CFG0_MAX_LEN_MASK - ETH_HLEN - ETH_FCS_LEN - 8;
+}
+
 static int rtl8365mb_mib_counter_read(struct realtek_priv *priv, int port,
 				      u32 offset, u32 length, u64 *mibvalue)
 {
@@ -1928,13 +1960,6 @@ static int rtl8365mb_setup(struct dsa_switch *ds)
 		p->index = i;
 	}
 
-	/* Set maximum packet length to 1536 bytes */
-	ret = regmap_update_bits(priv->map, RTL8365MB_CFG0_MAX_LEN_REG,
-				 RTL8365MB_CFG0_MAX_LEN_MASK,
-				 FIELD_PREP(RTL8365MB_CFG0_MAX_LEN_MASK, 1536));
-	if (ret)
-		goto out_teardown_irq;
-
 	if (priv->setup_interface) {
 		ret = priv->setup_interface(ds);
 		if (ret) {
@@ -2080,6 +2105,8 @@ static const struct dsa_switch_ops rtl8365mb_switch_ops_smi = {
 	.phylink_mac_link_down = rtl8365mb_phylink_mac_link_down,
 	.phylink_mac_link_up = rtl8365mb_phylink_mac_link_up,
 	.port_stp_state_set = rtl8365mb_port_stp_state_set,
+	.port_change_mtu = rtl8365mb_port_change_mtu,
+	.port_max_mtu = rtl8365mb_port_max_mtu,
 	.get_strings = rtl8365mb_get_strings,
 	.get_ethtool_stats = rtl8365mb_get_ethtool_stats,
 	.get_sset_count = rtl8365mb_get_sset_count,
@@ -2101,6 +2128,8 @@ static const struct dsa_switch_ops rtl8365mb_switch_ops_mdio = {
 	.phy_read = rtl8365mb_dsa_phy_read,
 	.phy_write = rtl8365mb_dsa_phy_write,
 	.port_stp_state_set = rtl8365mb_port_stp_state_set,
+	.port_change_mtu = rtl8365mb_port_change_mtu,
+	.port_max_mtu = rtl8365mb_port_max_mtu,
 	.get_strings = rtl8365mb_get_strings,
 	.get_ethtool_stats = rtl8365mb_get_ethtool_stats,
 	.get_sset_count = rtl8365mb_get_sset_count,
-- 
2.30.2

